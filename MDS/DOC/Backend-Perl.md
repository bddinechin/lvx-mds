# Writing an MDS back-end in Perl: the in-core XML object model

Notes on how the Perl back-ends (`MDS/BE/*/BIN/*.pl`, on the shared
`MDS/LIB/MDS.pm` + `MDS/BE/LIB/*.pm`) read the machine description, the idioms
that recur across them, the traps that bit during the `gen-parse-table` port,
and a set of small `MDS.pm` additions that would remove most of the repeated
boilerplate. Written with the next back-ends in mind — **GEM5** (partly landed),
**SAIL** (not started), and **LLVM** (rides on GEM5 or SAIL). All three iterate
instructions/operands/registers exactly the way the existing back-ends do, so
the model below is the whole interface they need.

Ruby back-ends used a very different shape (`Mds::MdsDescription`, an object
graph built with REXML); this note is about the **Perl** side, which is where
new back-ends should be written (the repo is on a `ruby-removal` track).

## 1. The object model

`&MDS::parse(*FILEHANDLE)` reads one MDS XML stream (a `TESTS.xml` /
`Description`-derived table concatenation) with `XML::Parser::Expat` and, as a
side effect, populates two global stores:

- **`%MDS::table`** — every element that has an `ID`, keyed by that full ID
  string (`RegClass-lvx_v1-singleReg`, `Immediate-lvx_v1-signed10`, …). This is
  what IDREF resolution reads. It is a *lexical* (`my %table`) inside `MDS.pm`,
  so it is not resettable from a back-end (see the multi-core trap in §4).
- **`@<Element>::table`** — one array per DTD element (`@Instruction::table`,
  `@RegClass::table`, `@Operand::table`, …), in document order. This is what you
  iterate.

Each element is a **blessed hashref** (blessed into a package named after the
element — `Instruction`, `RegClass`, …) with four fields:

| field | meaning |
|---|---|
| `ATTRIBUTES` | hashref of the XML attributes (whitespace-normalised, entities decoded) |
| `CONTENTS`   | arrayref of child elements (blessed) and/or text chunks, in order |
| `PARENT`     | the enclosing element, or `undef` |
| `CORES`      | the `$MDD::CORE` in effect when it was parsed |

The per-element packages (`package Instruction; @ISA = ("MDS"); ...`) are **not
hand-written** — they are generated from `DOC/MDD.dtd` into `LIB/MDD.pm` by
`BIN/dtd2pm.pl`. Each carries `%ATTLIST` (attribute name → `[type, default,
IDREF-target, …]`), `@CHILD_ELEMENTS` (from the content model), `sub attlist`,
`sub childElements`, `sub ID/IDs` (ID formatting), and the `sub enter` that
pushes the element onto `@<Element>::table` — **or onto `@<Element>::noname`**
if its ID has no third `-`-component (the `Foo-lvx_v1-` placeholders). So
iterating `@<Element>::table` already excludes those placeholders; you never
filter them yourself.

## 2. The accessor catalogue (`MDS.pm`)

Everything a back-end needs is a method on the blessed element. The ones that
matter:

| method | returns | notes |
|---|---|---|
| `->attribute("x")` | the attribute string, or `undef` | **croaks** if `x` isn't in the element's `%ATTLIST` — a typo is loud, not silent. One-arg = get; two-arg = set. |
| `->access("x")` | the **objects** an ID/IDREFS attribute points at | `map { fetch } split ' ', value`. Dangling ID ⇒ `croak`. Returns a **list** (see the scalar-context trap in §4). |
| `->filterID("x")` | the *IDs* in an ID/IDREFS attribute that actually exist | the tolerant sibling of `access` — no croak on dangling refs. |
| `->name($sep)` | the **3rd** `-`-component of the ID (`singleReg`) | `$sep` replaces non-word chars. `undef` for placeholders. |
| `->fullName($sep)` | core + name (`lvx_v1_singleReg` with `'_'`) | the standard C-name shape for most back-ends. |
| `->core()` / `->type()` | 2nd / 1st ID component (`lvx_v1` / `RegClass`) | |
| `->children("Type")` | the `CONTENTS` elements blessed into `Type` | e.g. `$insn->children("Behavior")`. |
| `->contents()` | the raw `CONTENTS` arrayref | text + elements. |
| `->emit()` / `->emit(1)` | the element re-serialised to XML tokens | attributes in **sorted** order, `undef` skipped — this is why `refs` output is stable. |
| `&MDS::fetch($id)` / `&MDS::exists($id)` | object by ID / boolean | fetch croaks if absent. |
| `&MDS::proxies(@syntaxes)` | the sorted unique `%N`/`%N:M` operand proxies in some syntax strings | |

The register model has its own helpers, because **a register file is just a
RegClass carrying `regFileName`** (there is no `RegFile` element — see the main
`CLAUDE.md`):

| method | returns |
|---|---|
| `&MDS::regFiles()` | the canonical RegClasses (those with a `regFileName`), in `regFileNumber` order — the replacement for the old `@RegFile::table` |
| `RegClass->isRegFile()` | whether this RegClass is a file rather than a view |
| `RegClass->regFileName($sep)` / `->regFileFullName($sep)` | the **file** name (`GPR`, `SFR`, …), which is *unrelated* to `->name()` (`singleReg`, `systemReg`) — using `->name()` where you meant the file name fails silently |

## 3. The idioms, by frequency

These are the patterns you'll copy into a new back-end. Counts are across the
current `BE/*/BIN/*.pl`.

**Iterate a table, pull scalar attributes.**
```perl
for my $opcode (@Opcode::table) {
    my $mnemonic = $opcode->attribute("mnemonic") || '';
    my $syntax   = $opcode->attribute("syntax")   || '';
    ...
}
```

**Resolve IDREFS to objects** (list) and **a single IDREF** (scalar). The single
form is written `my ($x) = ...` in **49 places across 21 files** — because
`access` returns a `map`, a plain `my $x = $o->access(...)` gets the list
*count*, not the object. This is the single most common footgun.
```perl
my @operands   = $opcode->access("operands");        # list
my ($sched)    = $opcode->access("scheduling");      # single — note the parens
```

**Space-separated list attributes** — `names`, `members`, `fields`,
`resources`, `requirements`, `stages`, … are all `split ' '` on the raw
attribute:
```perl
my @names = split ' ', $register->attribute("names");
```

**ID → C identifier.** Two shapes coexist, and the difference is a real trap:
- `->fullName('_')` / `->name('_')` derive the C name from **components** of the
  ID (`lvx_v1_singleReg` / `singleReg`).
- but where a back-end must emit the **whole prefixed** ID as a C token
  (`RegClass_lvx_v1_singleReg`, the form gbu.pl puts in `include/opcode/lvx.h`),
  it takes `->attribute("ID")` and hand-substitutes: `(my $c = $id) =~
  s/[-.]/_/g`. This `s/\W/_/`-style sanitisation is hand-rolled **~40 times**
  across `gbu*.pl`, `gen-parse-table.pl`, `LAO/Operator.pl`, …

**The multi-core parse loop.** Two dialects. Most `LAO/*.pl` parse a single
concatenated stream — `&MDS::parse(*ARGV)` — and never loop. The GBU/GDB/GCC
family instead loops per core, clearing the tables between files:
```perl
for my $i (0 .. $#Cores) {
    open(my $fh, '<', $ARGV[$i]) or die;
    clearMDSTables();               # hand-written, per back-end
    &MDS::parse(*$fh);
    gen_header($Cores[$i]);
}
```

## 4. Traps learned the hard way

- **`access` in scalar context returns garbage.** `my $x = $o->access("a")` is
  the list length. Always `my ($x) = ...` for a single IDREF. A `->reference`
  helper (§5) removes the hazard.
- **`->name()` is the ID's 3rd field, not the whole ID, and not the register-file
  name.** Three back-ends broke on exactly this during the RegFile/RegClass
  unification (matched `->name() eq 'SFR'` when the file name lives in
  `regFileName`). For a *whole prefixed* C token you want `attribute("ID")`
  sanitised, **not** `name`/`fullName`.
- **`%MDS::table` is not cleared between cores; `@<Element>::table` must be.**
  `clearMDSTables()` is hand-written in each looping back-end and only clears the
  arrays that back-end happens to read — `gbu.pl`'s copy omits `@Format::table`
  and `@Synthetic::table`, so a back-end that reuses it and *does* read those
  (as the parse-table generator does) sees both cores' rows merged. Leaving
  `%MDS::table` uncleared is safe only because IDs are core-qualified
  (`…-lvx_v1-…` vs `…-lvx_v2-…`) so there's no collision and cross-core `access`
  still resolves correctly — but it means the ID map grows across cores, which
  matters if a back-end ever iterates it.
- **`attribute` croaks on an unknown name.** Good (typos are caught), but it
  means you can't probe for an attribute that might not be in the DTD; if the
  attribute is optional, it's in `%ATTLIST` and returns `undef`, so use `//`.
- **`emit` sorts attributes and drops `undef`.** Any back-end that round-trips
  or compares against `lvx-refs/` depends on this being the canonical order; don't
  reimplement serialisation.
- **Placeholders (`Foo-lvx_v1-`) are already excluded** from `@<Element>::table`
  (they land in `@<Element>::noname`). Don't re-filter on a trailing `-`; do
  filter the numbered register sub-views (`…_0`/`…_1`) yourself when you don't
  want them — that's a `/_[0-9]+$/` on the name, and it is *not* automatic.

## 5. The `MDS.pm` convenience helpers

All additive, none change existing behaviour; each collapses one of the
duplicated idioms above. **Implemented in `MDS/LIB/MDS.pm`** (and `@MDD::ELEMENTS`
in `LIB/MDD.pm`, emitted by `dtd2pm.pl`); `BE/GBU/BIN/gen-parse-table.pl` uses all
five and is the worked example. New back-ends (GEM5/SAIL/LLVM) should prefer
these over the older hand-rolled forms.

**(a) `->reference($attr)` — the single-IDREF accessor.** Replaces the 49
`my ($x) = ...->access` sites and removes the scalar-context footgun.
```perl
my $sched = $opcode->reference("scheduling");   # the object, or undef
```

**(b) `->attributeList($attr)` — the space-list accessor.** Replaces the
scattered `split ' ', $o->attribute(...)` (and its `|| ''` guards).
```perl
my @names = $register->attributeList("names");
```

**(c) `->cName($sep)` — the whole ID as a C identifier.** The ~40 hand-rolled
`(my $c = $o->attribute("ID")) =~ s/[-.]/_/g`. Deliberately *not* `fullName`
(which drops the element-type prefix): this is the token the C headers emit
(`RegClass_lvx_v1_singleReg`). `$sep` defaults to `_`; `\W` == `[-.]` for MDS IDs.
```perl
print "RegClass ", $rc->cName, " ...";          # RegClass_lvx_v1_singleReg
```

**(d) `MDS::clearTables()` — reset *every* `@<Element>::table`.** Iterates
`@MDD::ELEMENTS` (the full generated element list, now emitted by `dtd2pm.pl`)
clearing each `@{"${elem}::table"}`/`@{"${elem}::noname"}`, so it can't miss a
table the way a per-back-end `clearMDSTables` does. It leaves `%MDS::table`
alone, matching the existing back-ends (IDs are core-qualified, so re-parsing a
*different* core never collides; re-parsing the *same* file twice still would, as
it always has).
```perl
MDS::clearTables();
```

**(e) `MDS::forCores(\@files, \@cores, $cb)` — the multi-core driver.** Wraps the
open / `clearTables` / `parse` / callback loop so a back-end's `main` is a few
lines and can't get the clearing wrong.
```perl
MDS::forCores(\@ARGV, [ split ' ', $ENV{CORES} ], \&gen_header);
```

(a)–(c) are supersets of the existing call sites and can be adopted
incrementally; (d)–(e) also close the "forgot to clear a table" hazard and are
the recommended shape for any new per-core back-end.

## 6. Starting points for GEM5 / SAIL / LLVM

- **The instruction/operand/format walk** — the spine of an ISA-describing
  back-end — is cleanest in `BE/GBU/BIN/gen-parse-table.pl` (`extract_insns_from_mds`:
  `@Instruction::table` + `@Synthetic::table`, `$insn->access("formats")`,
  `$fmt->access("operands")`, `$op->attribute("method")`, `$fmt->attribute("syntax")`)
  and `BE/LAO/BIN/Opcode.pl` (encodings, decodings, scheduling, the operator map).
  Copy those, not the older idioms.
- **Behaviour / operational semantics** (what an LLVM or SAIL model of execution
  needs) come through `BE/LAO`'s `Behavior.tuple` — see `DOC/Behavior.md`. GEM5
  already rides on `BE/LAO` for `lvx_v1`; LLVM/SAIL that need semantics should do
  the same rather than re-deriving from tables.
- **Registers / register files**: always via `&MDS::regFiles()` +
  `->regFileName`, never `->name()` — this is the one place the model is
  counter-intuitive (§2, §4).
- Write the new back-end's `main` with the §5(e) driver if it's adopted;
  otherwise copy a *complete* `clearMDSTables` (all tables you read, including
  `@Format::table`/`@Synthetic::table`), not `gbu.pl`'s partial one.
```
