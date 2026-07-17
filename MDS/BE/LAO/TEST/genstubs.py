# Copyright (C) 2026 Liesme Tech.
# Benoît Dupont de Dinechin (benoit.dinechin@gmail.com).
# Distributed under the GNU General Public License, version 2 or later.

import re, sys, zlib
src = open(sys.argv[1]).read()
# The generator emits its own prototypes: BehaviorDeclare(id, DECLARE(<proto>;))
protos = {}
for m in re.finditer(r'BehaviorDeclare\([A-Za-z0-9_]+,DECLARE(?:_ALT)?\((.*?);\)\)', src):
    p = m.group(1).strip()
    mm = re.match(r'(\w+)\s+HELPER\((\w+)\)\((.*)\)$', p)
    if not mm: continue
    ret, name, args = mm.group(1), mm.group(2), mm.group(3)
    protos[name] = (ret, args)

out = ['/* Generated from Behavior.tuple\'s own BehaviorDeclare prototypes. */\n']

# A helper's identity in the trace is a function of its NAME, not of its position in this
# list.  It used to be `enumerate(..., start=100)`, which made every stub's identity
# depend on which OTHER helpers existed: delete one and each later helper shifts by one,
# so every opcode that calls any of them gets a different trace with no change in
# meaning.  That is not hypothetical -- wiring the FP macros dropped
# commit_float_exception_flags from the description, and 134 of 870 lvx_v1 traces moved
# for it, none of them a semantic change.  A diff between two generations is only
# evidence if the helper set may not vary; the whole point of this test is to compare
# across changes to the description, and the description is where helpers come and go.
def ident(name):
    return 100 + (zlib.crc32(name.encode()) & 0xffffff)

for name, (ret, args) in sorted(protos.items()):
    i = ident(name)
    params = [a.strip() for a in args.split(',')]
    body = ['    Ctx *c = t;', f'    mix(c, 0x{i:x}ULL);']
    for p in params[1:]:                      # skip "void *this"
        var = p.split()[-1]
        body.append(f'    mix256(c, {var});' if p.startswith('Int256_') else f'    mix(c, (uint64_t){var});')
    sig_args = ', '.join(['void *t'] + params[1:])
    if ret == 'void':
        pass
    elif ret == 'bool':
        body.append(f'    Int256_ v = result(c, {i}); mix256(c, v); return (v.dwords[0] & 1);')
    elif ret.startswith('Tuple_'):
        # A flag-returning helper (DOC/FP-helpers.md 6a).  The struct's name IS its
        # shape -- Tuple_32_1_1_1_1_1 is (result, io, dz, ov, un, in) -- so the widths
        # come from it and nothing else has to be parsed.  Every element is carved from
        # the one deterministic value the other stubs return whole, which keeps the
        # trace a function of the arguments exactly as before.
        widths = [int(x) for x in ret[len('Tuple_'):].split('_')]
        body.append(f'    Int256_ v = result(c, {i}); mix256(c, v);')
        body.append(f'    {ret} r;')
        off = 0
        for k, w in enumerate(widths):
            cty = ('uint8_t' if w <= 8 else 'uint16_t' if w <= 16
                   else 'uint32_t' if w <= 32 else 'uint64_t')
            if off % 64 + w > 64:              # never straddle a limb: start the next
                off = (off // 64 + 1) * 64
            d, s = off // 64, off % 64
            mask = '~(uint64_t)0' if w >= 64 else f'0x{(1 << w) - 1:x}ULL'
            body.append(f'    r._{k} = ({cty})((v.dwords[{d}] >> {s}) & {mask});')
            off += w
        body.append('    return r;')
    else:                                      # Int256_
        body.append(f'    Int256_ v = result(c, {i}); mix256(c, v); return v;')
    out.append(f'{ret} HELPER({name})({sig_args})\n{{\n' + '\n'.join(body) + '\n}\n')
open('opstubs.inc', 'w').write('\n'.join(out))
print(f'{len(protos)} operator helper stubs generated')
