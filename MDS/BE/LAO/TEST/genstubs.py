import re, sys
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
for i, (name, (ret, args)) in enumerate(sorted(protos.items()), start=100):
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
    else:                                      # Int256_
        body.append(f'    Int256_ v = result(c, {i}); mix256(c, v); return v;')
    out.append(f'{ret} HELPER({name})({sig_args})\n{{\n' + '\n'.join(body) + '\n}\n')
open('opstubs.inc', 'w').write('\n'.join(out))
print(f'{len(protos)} operator helper stubs generated')
