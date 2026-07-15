/*
 * Copyright (C) 2026 Liesme Tech.
 * Benoît Dupont de Dinechin (benoit.dinechin@gmail.com).
 *
 * Distributed under the terms of the GNU General Public License, version 2
 * or later.
 *
 * Differential test harness for the generated Behavior C.
 *
 * The point is not to simulate LVX.  It is to decide whether two *generations* of
 * Behavior.tuple -- the baseline, which computes everything in Int256_, and an
 * unboxed one, which computes in native C types where the abstract values allow --
 * compute the same thing.  So every helper is replaced by a deterministic pure
 * function of its arguments, and every call is folded into a running trace hash.
 * If unboxing changed any value anywhere, it reaches a helper argument or a storage
 * write, and the trace diverges.
 *
 * That makes the real Int256_ arithmetic (Kalray's, from kvx-lao) the oracle for
 * both sides, and it needs no ISS, no gem5, and no architectural model.
 */
#include "int256rt.h"

typedef int64_t ImmediateValue;
typedef int64_t OperandDecoded;
typedef void *Processor;
#include "regs.inc"
#include "bounds.inc"

typedef struct {
    uint64_t seed;
    uint64_t trace;
} Ctx;

/* FNV-1a, folded over everything a helper sees and everything it returns. */
static inline void
mix(Ctx *ctx, uint64_t v)
{
    ctx->trace = (ctx->trace ^ v) * 1099511628211ULL;
}

static inline void
mix256(Ctx *ctx, Int256_ v)
{
    for (int i = 0; i < 4; i++) mix(ctx, v.dwords[i]);
}

/* A value, spread over all four limbs: a helper may legitimately return a 256-bit
 * one, and a bug that corrupts only the high limbs must not hide. */
static inline Int256_
spread(uint64_t h)
{
    h ^= h >> 29; h *= 0xBF58476D1CE4E5B9ULL; h ^= h >> 32;
    uint64_t g = h * 0xD6E8FEB86659FD93ULL; g ^= g >> 31;
    Int256_ r = { .dwords = { h, g, h ^ g, h + g } };
    return r;
}

/* A helper's result: a pure function of the trace so far and the seed.  Pure means
 * both generations see identical inputs iff they made identical calls. */
static inline Int256_
result(Ctx *ctx, uint64_t salt)
{
    return spread(ctx->trace ^ (ctx->seed + salt * 0x9E3779B97F4A7C15ULL));
}

/* A *read*'s result, which must NOT depend on the trace so far.
 *
 * operandRead is a pure accessor: in the ISS, reading operand i twice gives the same
 * value, and the order the two reads happen in is not part of the semantics.  Deriving
 * its value from the running trace made it depend on that order -- and C fixes the
 * evaluation order of neither `a | b` nor `Int256_or(a, b)`.  The splat32 forms read
 * one operand twice, in the two arms of an IOR, so unboxing that IOR flipped the order
 * gcc happened to pick and 54 traces moved with no value having changed.  That is the
 * test failing on something that is not a property of the generated code.  Keyed on
 * (seed, index) instead, the two reads agree and the order stops mattering; the call is
 * still folded into the trace, so a read that goes missing or gains a twin is still
 * caught.  Helpers with real side effects (MEM_load, the atomics) keep result(). */
static inline Int256_
readback(Ctx *ctx, uint64_t salt, uint64_t key)
{
    return spread(ctx->seed + (salt * 0x9E3779B97F4A7C15ULL) + (key * 0xC2B2AE3D27D4EB4FULL));
}

#define HELPER(routine) Behavior_##routine

/* ---- the 17 shim helpers (hand-written; they are the ISS's state interface) ---- */

Int256_ HELPER(operandRead)(void *t, int i)
{ Ctx *c = t; mix(c, 0x01); mix(c, i); Int256_ v = readback(c, 1, (uint64_t)i); mix256(c, v); return v; }

/* The fourth argument is a commit MASK, and it is a POINTER, not an int: a masked STORE
 * passes &static_<mask>, an unmasked one passes 0.  lvx_v1 has no masked store and so never
 * passes anything but 0, which an `int d` swallowed; lvx_v2's lane-masked writes do, and the
 * harness would not compile against them.  Fold the mask itself in, or a masked commit and
 * an unmasked one to the same value would trace alike. */
void HELPER(operandFromValue)(void *t, int a, int b, const Int256_ *m, Int256_ v)
{ Ctx *c = t; mix(c, 0x02); mix(c, a); mix(c, b);
  mix(c, m ? 1 : 0); if (m) mix256(c, *m); mix256(c, v); }

void HELPER(commitRegFiles)(void *t)
{ Ctx *c = t; mix(c, 0x03); }

#define SHIM_REGFILE(NAME)                                                       \
    void HELPER(operandFromRegFile_##NAME)(void *t, int a, int b, int d, int r)  \
    { Ctx *c = t; mix(c, 0x10); mix(c, a); mix(c, b); mix(c, d); mix(c, r); }    \
    void HELPER(operandToRegFile_##NAME)(void *t, int a, int b, int d, int r)    \
    { Ctx *c = t; mix(c, 0x11); mix(c, a); mix(c, b); mix(c, d); mix(c, r); }
/* Also a pure read, and keyed on what it reads, for the same reason as operandRead. */
#define SHIM_READ(NAME)                                                          \
    Int256_ HELPER(readFromStorage_##NAME)(void *t, int s, int a, int e, int w)  \
    { Ctx *c = t; mix(c, 0x20); mix(c, s); mix(c, a); mix(c, e); mix(c, w);      \
      Int256_ v = readback(c, 2, (uint64_t)((s * 31 + a) * 31 + e) * 31 + w);    \
      mix256(c, v); return v; }
#define SHIM_WRITE(NAME)                                                         \
    void HELPER(writeToStorage_##NAME)(void *t, int s, int a, int e, int w, Int256_ v) \
    { Ctx *c = t; mix(c, 0x21); mix(c, s); mix(c, a); mix(c, e); mix(c, w); mix256(c, v); }

/* Which register files and which storages, from the tuple itself rather than from a list
 * here: lvx_v1 has four register files, lvx_v2 has fourteen (the XVR octuples) and a CS
 * storage besides.  genregs.py writes the invocations. */
#include "shims.inc"

/* ---- the read-unknown variables: a scaffold, not a fix ----
 *
 * lvx_v2's generated C DOES NOT COMPILE.  A variable is declared from the WRITEs to it, so
 * one that is only ever read is never declared at all: FNARROWDWQ reads `ziplanes`, and the
 * four CMOVE* forms read `argument3`, with no reaching WRITE anywhere.  16 opcodes, 9
 * undeclared variables.
 *
 * Behavior.md section 5 records the `ziplanes` one -- ALU_FWQWR declares the encoding field
 * and then omits it from operands: -- as "a real bug, left unfixed on purpose", and says
 * nothing anywhere fails.  It does fail: at compile time, the moment anyone builds lvx_v2's
 * ISS.  That nobody had noticed is itself the evidence that the lvx_v2 tuple has never been
 * compiled -- BE/GEM5 rides on BE/LAO for lvx_v1 only.  The CMOVE* `argument3` is a second
 * instance that section 5 does not mention.
 *
 * File-scope zeros let both generations compile and be compared, which is all this test
 * needs: an undeclared read resolves here, identically on both sides, and a local
 * declaration shadows it wherever there is one.  Fixing the description is a separate job
 * (it moves the opcode table) and is tracked in Behavior.md. */
static Int256_ argument3, ziplanes;

/* ---- the ~137 operator helpers, defined from the generator's own prototypes ---- */
#include "opstubs.inc"

/* ---- the generated bodies ---- */
#define Behavior_FETCH
#define Behavior_EXECUTE
#define Behavior_COMMIT
#define Behavior_STATIC
#include BEHAVIOR_TUPLE
#undef Behavior_STATIC
#undef Behavior_COMMIT
#undef Behavior_EXECUTE
#undef Behavior_FETCH

typedef void (*Phase)(void *, OperandDecoded *, Processor);
typedef struct { const char *name; Phase f, e, c; } Row;

static const Row table[] = {
#define FETCH(ID)   ID
#define EXECUTE(ID) ID
#define COMMIT(ID)  ID
#define Behavior(OPCODE, F, E, C) { #OPCODE, F, E, C },
#include BEHAVIOR_TUPLE
#undef Behavior
#undef COMMIT
#undef EXECUTE
#undef FETCH
};

int
main(void)
{
    const int rows = (int)(sizeof(table) / sizeof(table[0]));
    for (int r = 0; r < rows; r++) {
        uint64_t acc = 0;
        /* The declared ranges for this opcode's operands, if the description gave any. */
        const Bounds *bb = NULL;
        for (size_t k = 0; k < sizeof bounds / sizeof bounds[0]; k++)
            if (!strcmp(bounds[k].name, table[r].name)) { bb = &bounds[k]; break; }
        for (uint64_t seed = 1; seed <= 32; seed++) {
            Ctx ctx = { .seed = seed * 0x2545F4914F6CDD1DULL, .trace = 1469598103934665603ULL };
            /* Operands come from the seed: the behaviours index decoded[] directly.
             *
             * Each one is drawn from the range the DESCRIPTION proves for it (bounds.inc,
             * out of Width.pm's METHOD intervals), and that is not fussiness.  A register
             * operand's METHOD is the index into its file, and that interval is exactly
             * what lets CodeGen give it a narrow C type; hand it something outside and the
             * boxed and unboxed forms disagree, correctly, on an input the architecture
             * says cannot occur.  lvx_v2's registerGl is bounded `hi:0` -- one register,
             * index always 0 -- and is then shifted << 6, so a single stray 1 overflows the
             * uint8_t the analysis proved sufficient.  Guessing a plain 0..63 "failed" 58
             * of 1453 opcodes that way, none of them a bug.
             *
             * The register bases in regs.inc are all 0 for the same reason, from the other
             * end: a behaviour turns a decoded operand into an index by subtracting its
             * file's base, so a base above the value makes the index NEGATIVE -- which is
             * what a plain 0..63 did to three of lvx_v1's four register files.  With every
             * base 0 the decoded value simply *is* the index, and it is in range by
             * construction. */
            OperandDecoded decoded[16];
            for (int i = 0; i < 16; i++) {
                uint64_t h = ctx.seed + (uint64_t)i * 0x9E3779B97F4A7C15ULL;
                h ^= h >> 30; h *= 0xBF58476D1CE4E5B9ULL; h ^= h >> 27;
                long long v;
                if (bb && i < bb->n && bb->hi[i] >= bb->lo[i]) {
                    unsigned long long span =
                        (unsigned long long)(bb->hi[i] - bb->lo[i]) + 1ULL;
                    v = bb->lo[i] + (long long)(h % span);
                } else {
                    v = (long long)(h & 0x03);      /* no interval: stay small */
                }
                decoded[i] = (OperandDecoded)v;
            }
            if (table[r].f) table[r].f(&ctx, decoded, 0);
            if (table[r].e) table[r].e(&ctx, decoded, 0);
            if (table[r].c) table[r].c(&ctx, decoded, 0);
            acc = (acc ^ ctx.trace) * 1099511628211ULL;
        }
        printf("%s %016" PRIx64 "\n", table[r].name, acc);
    }
    return 0;
}
