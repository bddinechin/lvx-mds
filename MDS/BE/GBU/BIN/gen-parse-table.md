# `gen-parse-table` — the LVX assembler operand-parser generator

Design/reference documentation for the assembler operand-parser-table generator
in `BE/GBU`. It was historically the last Ruby generator here
(`gen-parse-table.rb`); it has since been ported to Perl on the shared `MDS.pm`
(`gen-parse-table.pl`, the file the `Makefile` now runs) and the `.rb` removed.
The Perl port reproduces the generated `gas/config/lvx-parse.h`
**byte-for-byte** — which is stronger than the bar below required.

The header's only job is to make `lvx-binutils`'s hand-written parser driver
(`lvx-parse.c`) recognise exactly the set of assembly statements the ISA
defines, so the functional acceptance test is "the same `.s` inputs assemble the
same way". Note one hard constraint that is *not* optional (§4, §9): the 1-based
terminal index the generator assigns must equal the `Method`/`Instruction` enum
value gbu.pl emits into `include/opcode/lvx.h`, because the lexer compares the
table's `steering` ids against those enum constants — so the `overweight_seps`
terminal ordering is load-bearing and any port must reproduce it exactly.

## 1. Role in the build

```
FAMILY=lvx CORES="lvx_v1 lvx_v2" ruby gen-parse-table.rb  \
    lvx_v1/TESTS.xml lvx_v2/TESTS.xml  >  gas/config/lvx-parse.h
```

- **Input**: one `TESTS.xml` per core — a plain concatenation of the MDD `.table`
  files, i.e. the full MDS description (`<Instruction>`, `<Format>`, `<Operand>`,
  `<RegClass>`, `<Register>`, `<Immediate>`, `<Modifier>`, `<Synthetic>`, …).
  `CORES` (env) names the cores; `ARGV[i]` is the matching XML. The two cores are
  emitted into **one** header, each guarded by its own `arch` suffix
  (`_lvx_v1` / `_lvx_v2`).
- **Output**: `gas/config/lvx-parse.h`, ~960 KB, installed by `BE/GBU install`
  into both `lvx-binutils` and `lvx-gdb`. Committed reference:
  `lvx-refs/BE/GBU/lvx/gas/config/lvx-parse.h`.
- **Build rule**: `MDS/BE/GBU/Makefile.in:117` (currently `$(RUBY)`; the port
  flips this to `$(PERL) $(PERLINC)` like every other `gbu-*.pl`).
- **Consumer**: `lvx-binutils/gas/config/lvx-parse.c` (+ `tc-lvx.h` for the
  struct definitions). The generator emits *data tables only*; the parsing
  algorithm is hand-written C. Understanding the consumer is what pins down the
  meaning of every magic number below.

## 2. What kind of parser this feeds

`lvx-parse.c` is a **recursive-descent parser with backtracking and infinite
look-ahead**. The generated tables are an LL(1)-style steering table that
deliberately **keeps ambiguities** (a token may steer to several alternatives);
the driver tries them in order and backtracks (`parse_with_restarts`,
`lvx-parse.c:906`).

Each grammar rule is emitted as a null-terminated array of `struct steering_rule`:

```c
struct steering_rule { int steering; int jump_target; int stack_it; };
struct rule          { struct steering_rule *rules; };
```

- **`steering`** — the token class id (1-based index into the `terminals`
  array, see §4) that selects this entry; `-1` terminates the array.
- **`jump_target`** — the rule to descend into next.
- **`stack_it`** — a rule id to push so the driver resumes it after `jump_target`
  completes (the "rest of the sequence").

Three sentinel encodings the driver keys on (`lvx-parse.c:936-961`):

| entry | meaning |
|---|---|
| `{steering, -1, -1}` | **terminal match**: consume the token whose class is `steering`. |
| `{steering, -2, -2}` | **epsilon**: an optional element was absent — accept without consuming (used for nullable modifiers). |
| `steering == -3` | the **end-of-input** marker `$` (a FOLLOW-set member). |

So a Perl port must reproduce these exact sentinel conventions; they are the
contract with the C driver, not an internal detail.

## 3. Top-level flow (`main` → `gen_header`)

```
main:
  puts $header_common                         # licence + prototypes + #ifndef guard
  for each core i:
    target_mds = read_mds(ARGV[i])            # REXML → Mds::MdsDescription
    gen_header(target_mds, cores[i])
  puts "#endif"
```

`gen_header` is the spine:

1. `insns = extract_insns_from_mds(mds)` — every instruction/synthetic as a token list (§5).
2. `terminals = insns.flatten.uniq` sorted by `overweight_seps` (§4).
3. `maps = gen_maps(mds, terminals)` — reg/imm/mod tables + pseudo-classes (§6).
4. Extend `terminals` with the reg/mod/imm *class names*, re-sort/uniq (§4).
5. Recompute `maps[:nullable]` against the final `terminals` indices.
6. `rules = compute_rules_from_insns(insns, terminals)` — factorised grammar (§7).
   (Post-step: any rule whose body is a bare terminal is rewritten `[hd, ["#{hd}"]]`
   to promote leaf numbered-rules into self-referential terminals.)
7. `parse_table = compute_parse_table(maps[:nullable], rules)` — FIRST/FOLLOW → steering table (§8).
8. `gen_c_structs(arch, parse_table, terminals, maps)` — emit the C (§9).

## 4. Tokens, terminals and their ordering (`overweight_seps`)

A **token** is a string. The universe of tokens (`terminals`) is, in final form:

```
tokens from instruction syntaxes           (mnemonics+suffix, separators)
  ∪ RegClass names   (maps[:reg] keys)
  ∪ Modifier names   (maps[:mod] keys)
  ∪ Immediate names  (maps[:imm] keys)
```

uniq'd and **sorted by `overweight_seps`**. That helper rewrites each separator
character `= , [ ] ? @ ( )` to `chr(ord+150)` before comparing, which forces all
punctuation to sort *after* alphanumerics. The resulting position **+1** (indices
are 1-based; 0 is reserved for the start symbol) is the token's **class id** —
the `steering` value in the tables and the `Instruction_*` / `Separator_*` /
`RegClass_*` / … enum value the lexer in `lvx-parse.c` assigns.

**Port note.** This ordering is load-bearing for *correctness of the port only
in that a token's id must match everywhere it is used within the generated
header* — the header is internally consistent by construction, and the C driver
never hardcodes a numeric id. So an alternative stable ordering is acceptable as
long as it is applied consistently to (a) the `tokens_names_<arch>` array, (b)
every `steering`/`jump_target` id, and (c) the `_enc(x)` bitmask bases. Keeping
`overweight_seps` verbatim is the low-risk choice and makes the reference diff
legible; changing it is allowed but buys nothing.

## 5. `extract_insns_from_mds` — from ISA description to token lists

For every non-synthetic `Instruction`, and separately for every `Synthetic`:

```
ops = [ insn.mnemonic ] + fmt.operands.map { |o| o.method.id }
```

- `o.method` is `description.methods[<method>]` — for a **register** operand this
  is the `RegClass` (id e.g. `singleReg`), for an **immediate** operand the
  `Immediate` (id e.g. `signed10`). `.id` is the MDS id string. So `ops[0]` is
  the mnemonic and `ops[k]` (k≥1) is the *class name* of the k-th operand.

Then the human syntax string is tokenised:

```
suffix = stx =~ /\..[^ ]*/  ? that match : ""      # e.g. ".w" / ".dcache"
stx    = stx.gsub(/\..[^ ]*/,'')                    # strip suffix
syntax = stx.split(/([% \?,()\[\]])/)               # keep separators as tokens
                .map { |t| t =~ /^\d+/ ? ops[t.to_i] : t }   # %N → ops[N]
syntax[0] += suffix                                 # glue suffix onto mnemonic
insn = syntax.reject { |s| s =~ /[% ]/ || s.empty? } # drop '%', spaces, empties
             .map    { |s| s.gsub(/-/,'_') }         # sanitise '-' → '_'
```

Net effect: `addw %1 = %2, %3` with operands `[singleReg, singleReg, signed10]`
becomes the token list `["addw", "singleReg", "=", "singleReg", ",", "signed10"]`.
The `%N` placeholders resolve to operand **class** names (so all instructions
sharing a shape share tokens and factorise well); literal separators survive as
their own tokens; the opcode suffix is fused onto the mnemonic.

Differences for **synthetics** (`target_mds.synthetics`):
- The syntax comes from `insn.syntax` when `insn.forced` is set, else `fmt.syntax`
  (`stx = insn.forced.nil? ? fmt.syntax : insn.syntax`). Synthetics are
  specialised forms of real instructions, so the per-synthetic syntax can pin
  operands the base format leaves free.
- The `%N` match uses `/\d+/` (unanchored) vs `/^\d+/` for real instructions — a
  historical inconsistency; preserve it unless testing shows it is inert.

Non-synthetic instructions with a non-empty `insn.synthetic` attribute are
**skipped** (`next if !insn.synthetic.empty?`) — they are covered via the
`Synthetic` pass instead.

## 6. `gen_maps` — the register / immediate / modifier machinery

Builds `maps`, a hash of the auxiliary tables the C needs. All keys are
name-sanitised with `gsub(/[-\.]/,'_')`.

- **`maps[:reg]`** = sorted `[regclass_name, [register display names…]]`, one per
  `RegClass`, **excluding** classes whose name ends in `_[0-9]+` (the `.0/.1`
  multi-register sub-views — see the RegFile/RegClass note in the repo CLAUDE.md).
  Register names come from `mds.registers[reg].names` flattened.
- **`maps[:imm]`** = `[immediate_name, width]`, **sorted by width ascending**,
  except `wrapped32` is forced to sort-key 48 and `wrapped8` to 32, i.e. the
  wrapped (multi-syllable) immediates are tried only after everything that fits
  in two syllables. This ordering *is* the immediate-promotion chain (§9,
  `promote_immediate`): smallest-that-fits first, escalate on parse failure.
- **`maps[:mod]`** = sorted `[modifier_name, [members downcased…]]`.
- **`maps[:nullable]`** = the modifier classes whose members include `"."` (the
  empty/optional member) → their **1-based index in `terminals`**. These are the
  rules the parser may satisfy with epsilon (`{-2,-2}`). Computed twice: once in
  `gen_maps` and again in `gen_header` against the *final* `terminals` (the second
  is the one that counts — the first is dead once `terminals` is extended).
- **`maps[:pseudo_reg]` / `maps[:pseudo_mod]`** = `compute_pseudo_class` output.

### `compute_pseudo_class` — overlapping classes → disjoint pseudo-classes

A register/modifier can belong to several classes, but the lexer needs each token
to have exactly **one** category. So:

1. Invert `class → [members]` into `member → [classes it belongs to]`.
2. Group members by that **set of classes**: each distinct class-set becomes one
   pseudo-class holding all members that share it.

The C encodes "which real classes this pseudo-class stands for" as a bitmask:
`#define _enc(x) (1ULL << ((x) - fst_reg))`, `prc_<arch>_id_NN = _enc(c1)|_enc(c2)…`.
`fst_reg` / `fst_mod` are the base ids (`maps[:reg][0][0]` / `maps[:mod][0][0]`),
the numerically smallest class id, so the shift stays in `[0,64)`.

## 7. Grammar construction (`compute_rules_from_insns`)

Turns the token lists into a compact factored grammar. Three stages:

1. **`insns_to_ptree`** — build a prefix tree (trie) over the token lists, then
   `simplify` it: any chain of single-child nodes is collapsed into one node
   whose key is the concatenated token list. Result: a `Hash` trie whose keys are
   token *runs*.
2. **`factorize(sexprs, terminals)`** — the interesting one. It:
   - value-numbers every sub-expression into an integer id (`insert_in_table`),
     terminals first (so terminal ids are stable and small), start symbol = 0;
   - repeatedly rewrites every expression by **pairing adjacent elements**
     (`each_slice(2)`), scoring the two pairings (aligned vs offset-by-one) by how
     often each resulting sub-expression already occurs (`counters` / `compute_score`
     / `select_best`), and keeping the higher-scoring one — a greedy
     common-subexpression factorisation that drives every rule toward the binary
     form `A → K | B C`;
   - loops until the total token count stops shrinking (fixed point);
   - prunes rules that were created mid-search but ended up unused
     (`extract_really_used`), and returns `[fexprs, factor_map]` where `factor_map`
     maps each surviving id back to its expansion.
3. **`compute_rules`** — walks the (simplified) prefix tree alongside the
   `sub_rules`/`keymap` from factorisation to emit the final rule hash
   `{ id => [ alternative, … ] }`, each alternative a list of `[token, next_rule]`
   or sub-rule ids. It then **renumbers** all rule ids into a gap-free `0..N`
   range (`deep_replace` fixes every cross-reference), with 0 the start symbol.

The header comment (lines 20–66 of the `.rb`) works a full example end to end and
is the clearest specification of the intended output; keep it in the port.

## 8. FIRST / FOLLOW and the steering table (`compute_parse_table`)

Standard LL machinery over the numbered rules, with `'eps'` as the epsilon marker
and `-3` as `$`:

- **`compute_firsts`** (`compute_first_aux`) — FIRST(rule): descend alternatives,
  accumulating leading tokens and stopping at the first non-nullable element; a
  rule in `nullable` contributes `'eps'`.
- **`compute_follows`** — FOLLOW(rule): start symbol 0 gets `[-3]`; for each
  position in each alternative, add FIRST of the next element (minus `eps`), and
  if that is nullable also add its FOLLOW; the last element inherits the rule's
  FOLLOW.
- **`compute_parse_table`** — for each rule/alternative, index it under every
  token in FIRST(first-element); for a nullable first element, also index it under
  every token in FOLLOW as an epsilon entry (`[-2,-2]`). Output:
  `{ rule_id => { steering_token => [ [jump_target, stack_it], … ] } }`.

## 9. C emission (`gen_c_structs` + `$header_common`)

Everything is `puts` to stdout; `main` frames the two per-core blocks with the
common licence header/prototypes and the closing `#endif`. Per core (`arch`):

- `tokens_names_<arch>[]` — every terminal's printable name (separators mapped via
  `tr_map`, e.g. `"["→"rsbracket"`), 3 per line.
- `insn_<arch>_<mnem>[]`, `sep_<arch>_<name>[]` — singleton name arrays per
  instruction/separator terminal.
- `prc_<arch>_id_t` enum + `prc_<arch>_NN[]` arrays — pseudo-register classes and
  their `_enc(...)` bitmasks; likewise `pmd_<arch>_…` for pseudo-modifiers.
- `reg_classes_<arch>[]`, `mod_classes_<arch>[]`, `imm_classes_<arch>[]`,
  `insn_classes_<arch>[]`, `sep_classes_<arch>[]` — arrays of `struct token_class`
  `{ class_values, class_id, sz }`, each `-1`-terminated. `imm_classes` encodes the
  width as `sz`, negated for `_signed` immediates.
- `token_classes_<arch>` — the aggregate `struct token_classes` binding the five
  arrays together.
- `rule_<arch>_NNNN[]` — one `struct steering_rule[]` per parse-table rule, entries
  sorted by `steering`, each `-1`-terminated (see §2 for the sentinel meanings).
- `rules_<arch>[]` — the `struct rule[]` indexing all rule arrays by id, 5 per line.
- `promote_immediate_<arch>()` — a `switch` mapping each immediate token to the
  **next larger** immediate (the chain from `maps[:imm]`'s size order); the largest
  maps to itself (`default: return tok`). This is what lets the driver retry a
  literal against progressively wider immediate classes.
- `setup_<arch>()` — wires an `env` struct the driver reads: `tokens_names`,
  `fst_reg` (base reg class id), `sys_reg` (`RegClass_<arch>_systemReg`), `fst_mod`,
  `promote_immediate`, `rules`, `token_classes`.

`$header_common` (lines 514–546) is the fixed licence block, the `#ifndef
__H_LVX_PARSER__` guard, and the four public prototypes (`parse`,
`free_token_list`, `setup`, `cleanup`). There is a dead `enum lvx_tokens_<arch>`
block gated by `if false` — do not port it (or port it behind the same dead gate).

## 10. Ruby → Perl porting notes

- **MDS API parity.** The generator uses `Mds::MdsDescription` (`BE/LIB/MDS.rb`).
  Everything it touches has a `MDS.pm` counterpart already exercised by the other
  `gbu-*.pl` back-ends: instructions/synthetics iteration, `mnemonic`, `formats`,
  `operands`, `operand.method` + its `id`, `syntax`, `synthetic`, `forced`,
  `regclasses`/`registers`/`names`, `immediates`/`width`, `modifiers`/`members`.
  Confirm each accessor exists in `MDS.pm` before relying on it; add the thin
  accessor there if missing rather than re-parsing XML in the generator.
- **Hash ordering.** Ruby 1.9+ hashes preserve insertion order and
  `MdsOrderedHash` leans on that; the code additionally `.sort`s the maps
  explicitly at the points that matter (`:reg`, `:imm`, `:mod`, terminals). Make
  the Perl port sort at those same points — do not depend on Perl hash order
  anywhere a Ruby `.sort`/`.sort_by` is present, and *do* add explicit sorts where
  Ruby was relying on insertion order feeding into a later `.sort`.
- **`fixnum?`** is just "is this an `Integer` in the 64-bit range" — used to
  distinguish an already-numbered leaf from a still-symbolic sub-expression during
  factorisation. In Perl this becomes a "looks like an integer id" test; the
  TODO comment in the source flags it as possibly-vestigial, worth revisiting.
- **`deep_replace`** — recursive scalar replacement through nested arrays; trivial
  to port, used only by the id-renumbering in `compute_rules`.
- **Two cores, one header.** Preserve the `arch` suffixing so `lvx_v1` and `lvx_v2`
  blocks coexist; `setup(int version)` in the driver dispatches on it.

## 11. How to validate functional equivalence (no byte-diff required)

The port is correct iff the driver built against the new header assembles the
same programs. Available oracles, in increasing realism:

1. **Generated regression assembly** — `lvx-refs/BE/GBU/lvx/lvx_v1/LVX_OPCODE_FLAG_MODE64.s`
   and `.../lvx_v2/LVX_OPCODE_FLAG_MODE64.s` exercise (close to) every opcode/format.
   Assemble with `lvx-mbr-as` built from a `lvx-binutils` that has the **old**
   header, then again with the **new** header, and compare the object output
   (`.bin` in `BE/GBU`'s own test targets, or `objdump -d`). This is the primary
   test and mirrors what `make -C BE/GBU check` already does for the opcode table.
2. **Real hand-written assembly** — `lvx-newlib/libgloss/lvx-mbr/asm_syscalls.S`
   and `lvx-newlib/newlib/libc/machine/lvx/{setjmp.S,memcpy.S,memmove.S,memset.S,
   memcmp.S}` (+ `jmpbuf.h`). These use the human-facing syntax (separators,
   modifiers, immediates of varying width, register classes) the way a programmer
   does, so they stress the backtracking/promotion paths the synthetic `.s` may not.
3. **The committed header itself** — a `diff` against
   `lvx-refs/BE/GBU/lvx/gas/config/lvx-parse.h` is a *sufficient* check if it happens
   to be clean, but is **not required**. Expect and accept differences in rule
   *numbering*, table *ordering*, and factorisation choices as long as (1)/(2) pass.

Suggested loop: build `lvx-binutils` once with the current header (baseline),
capture disassembly of all four `.s`/`.S` sets; regenerate the header with the
Perl port; rebuild; re-capture; `diff` the disassemblies. Empty diff ⇒ done.
