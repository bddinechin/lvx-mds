/*
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

/* A helper's result: a pure function of the trace so far and the seed.  Pure means
 * both generations see identical inputs iff they made identical calls. */
static inline Int256_
result(Ctx *ctx, uint64_t salt)
{
    uint64_t h = ctx->trace ^ (ctx->seed + salt * 0x9E3779B97F4A7C15ULL);
    h ^= h >> 29; h *= 0xBF58476D1CE4E5B9ULL; h ^= h >> 32;
    uint64_t g = h * 0xD6E8FEB86659FD93ULL; g ^= g >> 31;
    /* Deliberately wide: a helper may legitimately return a 256-bit value, and a
     * bug that only corrupts the high limbs must not hide. */
    Int256_ r = { .dwords = { h, g, h ^ g, h + g } };
    return r;
}

#define HELPER(routine) Behavior_##routine

/* ---- the 17 shim helpers (hand-written; they are the ISS's state interface) ---- */

Int256_ HELPER(operandRead)(void *t, int i)
{ Ctx *c = t; mix(c, 0x01); mix(c, i); Int256_ v = result(c, 1); mix256(c, v); return v; }

void HELPER(operandFromValue)(void *t, int a, int b, int d, Int256_ v)
{ Ctx *c = t; mix(c, 0x02); mix(c, a); mix(c, b); mix(c, d); mix256(c, v); }

void HELPER(commitRegFiles)(void *t)
{ Ctx *c = t; mix(c, 0x03); }

#define SHIM_REGFILE(NAME)                                                       \
    void HELPER(operandFromRegFile_##NAME)(void *t, int a, int b, int d, int r)  \
    { Ctx *c = t; mix(c, 0x10); mix(c, a); mix(c, b); mix(c, d); mix(c, r); }    \
    void HELPER(operandToRegFile_##NAME)(void *t, int a, int b, int d, int r)    \
    { Ctx *c = t; mix(c, 0x11); mix(c, a); mix(c, b); mix(c, d); mix(c, r); }
SHIM_REGFILE(GPR) SHIM_REGFILE(PGR) SHIM_REGFILE(QGR) SHIM_REGFILE(SFR)

#define SHIM_READ(NAME)                                                          \
    Int256_ HELPER(readFromStorage_##NAME)(void *t, int s, int a, int e, int w)  \
    { Ctx *c = t; mix(c, 0x20); mix(c, s); mix(c, a); mix(c, e); mix(c, w);      \
      Int256_ v = result(c, 2); mix256(c, v); return v; }
#define SHIM_WRITE(NAME)                                                         \
    void HELPER(writeToStorage_##NAME)(void *t, int s, int a, int e, int w, Int256_ v) \
    { Ctx *c = t; mix(c, 0x21); mix(c, s); mix(c, a); mix(c, e); mix(c, w); mix256(c, v); }
SHIM_READ(SFR) SHIM_READ(PC) SHIM_READ(PS) SHIM_READ(NPC)
SHIM_WRITE(SFR) SHIM_WRITE(NPC)

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
        for (uint64_t seed = 1; seed <= 32; seed++) {
            Ctx ctx = { .seed = seed * 0x2545F4914F6CDD1DULL, .trace = 1469598103934665603ULL };
            /* Operands come from the seed: the behaviours index decoded[] directly. */
            OperandDecoded decoded[16];
            for (int i = 0; i < 16; i++) {
                uint64_t h = ctx.seed + (uint64_t)i * 0x9E3779B97F4A7C15ULL;
                h ^= h >> 30; h *= 0xBF58476D1CE4E5B9ULL; h ^= h >> 27;
                decoded[i] = (OperandDecoded)(h & 0x3F);   /* small: a register index */
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
