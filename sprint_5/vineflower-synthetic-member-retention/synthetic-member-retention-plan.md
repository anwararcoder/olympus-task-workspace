# Plan - Reference-Aware Synthetic Member Retention (Vineflower)

Repository: https://github.com/Vineflower/vineflower
Planning base: `b8273988af850e8cfb234ca08d129058502b032f` (upstream `master` head, tag `1.12.0`, 2026-04-29)
Local clone: `Shipd - Olympus/repos/vineflower`, verified 0 commits behind `origin/master`
Target: Olympus, `feature_request`, difficulty `hard`, language `java`
Schema: `olympus-tmp/new-dot-agent/rules/idea-crafting.md` section "Output"
Date: 2026-07-30

> **Execution correction, 2026-07-31.** A full implementation spike disproved the draft's claim that
> unconditional retention could leave every existing golden unchanged: nine of 1,330 repository
> cases deliberately emit partially reconstructed compiler scaffolding. The shipped contract is
> therefore opt-in through `reference-aware-synthetic-retention`, disabled by default. The enabled
> path is covered by 13 independent cells; the disabled path passes the unmodified repository suite.
> Gate B is now measured on the final solution patch. Gate C remains the first external agent
> calibration activity and cannot be inferred from the reference implementation.

---

## 1. What It Is

Compiled classes carry members no source declared: fields and methods a compiler generates for
assertions, enum machinery, nested-class access, lambda bodies, switch maps and similar constructs.
Vineflower omits them from the emitted source, because a faithful reconstruction usually rebuilds
the construct they served and no longer needs them.

The omission is currently decided from **what a member looks like** - its access flags, or its
membership in a mutable set some earlier transform wrote into - and never from **what the writer
actually emitted**. When the opt-in feature is enabled, the decision follows the emitted source: a
generated member is declared exactly when emitted Java code that is itself part of the output refers
to it. The option is disabled by default because this changes longstanding output in partially
reconstructed cases.

### Observable behavior at base vs with the feature

Fixture: one class with `assert x > 0 : "neg";` in an ordinary method and a second `assert` inside a
lambda body. Reconstruction of assertions disabled; synthetic removal at its default enabled value.

Base output (VERIFIED 2026-07-30, pinned jar `build/libs/vineflower-1.12.0+local-slim.jar`):

```
$ java -jar vineflower-1.12.0+local-slim.jar --decompile-assert=0 \
      --remove-synthetic=1 --remove-bridge=1 <classes> <out>
$ grep -n 'assertionsDisabled' out/Probe1.java
36:      if (!$assertionsDisabled && var1 <= 0) {
45:         if (!$assertionsDisabled && var1 <= 0) {
$ javac --release 17 -d chk out/Probe1.java
out/Probe1.java:36: error: cannot find symbol
out/Probe1.java:45: error: cannot find symbol
2 errors
```

The emitted source reads `$assertionsDisabled` twice; the declaration is suppressed anyway. With the
feature, the field is declared, because emitted code refers to it.

Second, independent instance of the same defect class - enum reconstruction disabled:

```
59:      public static p.Probe1.E[] values() {
60:         return (p.Probe1.E[])$VALUES.clone();
```

`$VALUES` is referenced and not declared. (This fixture also exposes unrelated defects -
`classes cannot directly extend java.lang.Enum` - so it is evidence of the defect class, not a
usable cell.)

### The load-bearing negative behavior (VERIFIED, and it is what makes the task shippable)

Compiled `--release 8` so `javac` emits legacy accessors, a class whose inner, static-nested and
anonymous classes read and write two private outer fields and call a private outer method produces
`access$002`, `access$102`, `access$000`, `access$100`, `access$200` and `$assertionsDisabled` in
bytecode. Decompiled with **default** options, **none of them appear in the output and the output
recompiles cleanly**. Under defaults the base also folds the switch, omits the switch-map holder
class, inlines lambda bodies, and correctly keeps `helper()` for `this::helper` because the lambda
hider is guarded by `!is_method_reference` at `NestedClassProcessor.java:48`.

The validation spike added a stronger observation. Unconditional retention changed nine existing
goldens: one partially reconstructed assertion case, enum scaffolding, IDEA null-check scaffolding,
Groovy scaffolding, Kotlin enum/coroutine scaffolding, and an LVT enum case. Those outputs genuinely
contain references to omitted generated members, so exempting them inside the analysis would
contradict the feature. The compatibility boundary must instead be explicit.

Three consequences:

1. `reference-aware-synthetic-retention` is disabled by default. A correct implementation changes
   nothing while it is disabled; the whole 1,330-case repository suite stays byte-identical and no
   `.dec` expectation is rewritten.
2. The over-keeping direction is a real, testable failure - not a stylistic preference.
3. Every focused feature cell enables the option explicitly, using its public string key so the test
   patch still compiles and runs on the base revision.

### Upstream request

Issue **#117**, "Analyze synthetic methods to figure out which can be excluded from the source and
which need to stay", opened 2022-05-06, **open**. Labels `Type: Enhancement`, `Subsystem: Writing`.
Body in full: "Especially for Java code, since we know about the patterns the compiler follows, e.g.
switch maps and inner class access". Zero comments. The GitHub timeline API returns **0**
`cross-referenced`, `connected` or `referenced` events - no PR, branch or commit is linked.
`gh pr list --state all --search "117 OR \"synthetic methods\" OR \"exclude synthetic\""` returns
one unrelated closed Kotlin PR (#589). Merged history touching synthetics is limited to *marking*
(#332) and a parameter-slot fix (#401), not retention.

**Rejected candidate, recorded so it is not rediscovered:** issue #538 ("Class qualifier removed if
same field name in current class exists during assignment") has a **working patch in its body**,
posted by the reporter, naming the exact file and method. Publicly solved; it would fail the
originality gate. It is also why section 7 keeps `AssignmentExprent.toJava` out of the required edit
set.

---

## 2. Why Hard At Its Core (file:line evidence, base `b8273988`)

**One mutable set, six writers, three blind readers, no reconciliation.**

The state: `main/rels/ClassWrapper.java:41`
`private final Set<String> hiddenMembers = new HashSet<>();`, exposed raw and mutable at `:259`.
Keys are `InterpreterUtil.makeUniqueKey(name, descriptor)` for members, a bare qualified name for
nested classes. No lifecycle, no ordering, no validation, no record of why anything was hidden.

Producers, each from an unrelated transform:

| Site | Hides |
|---|---|
| `main/rels/NestedClassProcessor.java:51` | lambda content method, guarded `!is_method_reference` (`:48`) |
| `main/rels/NestedClassProcessor.java:618` | captured field of a nested class |
| `modules/decompiler/ClassReference14Processor.java:74`, `:223` | legacy `class$` members |
| `modules/decompiler/SimplifyExprentsHelper.java:1110` | field consumed by a folded pattern |
| `modules/decompiler/EnumProcessor.java:28`, `:33`, `:54` | enum `values` / `valueOf` / `$VALUES` |
| `modules/decompiler/InitializerProcessor.java:154` | field folded into an initializer |
| `plugins/kotlin/.../KEnumProcessor.java:17` | Kotlin enum members (out of scope, section 4.10) |

Consumers, each OR-ing the set against a raw flag test:

- `main/ClassWriter.java:455-457` fields:
  `fd.isSynthetic() && getOption(REMOVE_SYNTHETIC) || wrapper.getHiddenMembers().contains(key)`
- `main/ClassWriter.java:482-484` methods, plus `mt.hasModifier(ACC_BRIDGE) && getOption(REMOVE_BRIDGE)`
- `main/ClassWriter.java:509-510` nested classes, keyed by qualified name
- a fourth reader, `modules/decompiler/exps/AssignmentExprent.java:120`, consults the set for
  assignment folding and must stay consistent

Options (`main/extern/IFernflowerPreferences.java`): `REMOVE_BRIDGE=1`, `REMOVE_SYNTHETIC=1`,
`DECOMPILE_ASSERTIONS=1`, `SYNTHETIC_NOT_SET=0`, `MARK_CORRESPONDING_SYNTHETICS=0`. Both removal
options are enabled in `test/.../SingleClassesTest.java:69-70, 79-80` and
`testFixtures/.../DecompilerTestFixture.java:53-54`, so the repository suite exercises the enabled
path.

**Why the intuitive design is architecturally wrong.** The reachability question looks like
dead-code elimination, so the obvious basis is the constant pool / bytecode reference graph - what a
shrinker does. That basis is wrong here in both directions: it keeps members whose references the
reconstruction folded away (the five `access$*` accessors the base correctly omits), and it cannot
see that a surviving reference lives inside a member the output itself omits. The correct basis is
the *post-reconstruction statement trees*, which exist at the decision point (`ClassWriter` runs
after processing, so every `MethodWrapper` already holds its decompiled `root`) but are not what any
current code consults.

**Why a text scan is wrong.** `DUMP_BYTECODE_ON_ERROR` defaults to `1`, so a class that fails to
decompile re-emits opcode mnemonics into the output, and a member name can appear in a comment or an
instruction listing without being a reference. A sibling task shipped a `!contains("31337")`
assertion and Verify Solution failed it for exactly this reason.

---

## 3. Independent Semantic Forks

Six forks, each failing differently, each with its discoverability proof
(clause or repo signal -> naive opposite -> failing cell -> base-symbols observable).

| # | Fork | Naive opposite | Fails as | Discoverability |
|---|---|---|---|---|
| F1 | Reference basis is the **emitted** trees | bytecode / constant-pool reachability | over-keeps: inlined accessors and folded initializer fields reappear | clause "an occurrence in emitted Java code"; repo signal: hiders run during processing, folds erase references before writing |
| F2 | **Closure** over omitted code | one pass over all members | keeps a member referenced only from an omitted member | clause "Omitted code refers to nothing" |
| F3 | Scope is the **output file** | per-`ClassWrapper` decision | outer-declared member referenced only from a lambda/nested body is dropped -> dangling reference | clause "One output file is decided as a whole"; repo signal: nested classes are written inline into the outer file |
| F4 | The new decision is **authoritative** over the existing tests | add the analysis, leave the raw flag OR in place at one or more of the three sites | site-specific: fields, methods and nested classes fail in different cells | the three sites are plainly visible; the legalization precedent proves agents *find* the second authority (20-26 trajectory mentions) and still let it win in 10 of 14 runs |
| F5 | References are **code**, not text | grep the emitted source for the name | comments count -> over-keeps; qualified/shadowed spellings missed -> under-keeps | clause "Text that is not code refers to nothing either, including comments" |
| F6 | **Per-member** granularity | keep or drop a whole category once one member is needed | unreferenced siblings appear | clause "Retention is decided per member ... some ... while omitting others of the same kind" |

Every observable is reachable from base-commit symbols through a synchronous entry point
(`ConsoleDecompiler` / the test fixture, an `IResultSaver`, then `javac` and an isolated class
loader). No daemon, no async path, no solution-only API.

**Honest weakness to settle at Gate C:** F1, F2 and F5 are three faces of "what counts as a
reference". They fail differently and are separately observable, but a solver who reads the contract
carefully may get all three from one correct design. Gate C must report whether the gauntlet
actually splits them. If it does not, the fork count is effectively 4, not 6, and the idea needs the
deepener in section 5 rather than more cells.

---

## 4. Frozen behavior contract

Freeze each row before writing tests; every cell traces to a row, every row has coverage.

1. **Activation.** `reference-aware-synthetic-retention` is disabled by default. Disabled output is
   unchanged; the remaining rules apply only while it is enabled.
2. **Retention.** A generated member is declared when emitted Java code that is itself part of the
   output refers to it.
3. **Omission.** It is left out when nothing emitted refers to it. Retention is not licence to keep
   everything.
4. **Basis.** The decision follows the produced source, not access flags, names or shapes, under
   whatever combination of reconstruction settings produced that source.
5. **Closure.** Omitted code refers to nothing; a member reachable only from an omitted member is
   omitted.
6. **Non-code.** Comments refer to nothing.
7. **Scope.** One output file is decided as a whole, including member, local, anonymous and lambda
   bodies within it.
8. **Granularity.** Per member; one file may declare some generated members and omit others of the
   same kind.
9. **Stability.** Deterministic across repeated runs, separate contexts, and a further round over
   recompiled output.
10. **Out of scope (state explicitly - this is what kills probe fuel).** Non-Java writers (Kotlin,
    Scala, Groovy plugins) and their parallel hiding logic; deciding whether a reconstruction
    *should* have run, or changing any reconstruction; re-synthesising, renaming, re-qualifying,
    importing or reordering anything; output entry naming and file layout; references that exist
    only across output files; behavior when a class fails to decompile in its entirety; any other
    new user-facing option.

**Accuracy limit the description must not overstate.** Do not promise that emitted source compiles
in general - with enum reconstruction disabled the output has other, unrelated defects. The promise
is precisely "no emitted reference is left without its declaration". Compilation and behavioral
equality may only be asserted on fixtures whose output is otherwise valid.

---

## 5. Gate A / Gate B / Gate C

### Gate A - cascade arithmetic (DONE, on paper)

Final suite: 13 cells (section 8). The central design commitment is "a closure over emitted
references, file-wide, authoritative over the flag tests".

- Omitting the core retention behavior fails **13 of 13** cells when the emitted source is recompiled.
- Keeping every generated member is rejected by the reconstruction, sibling-omission, closure,
  omitted-body and non-code cells.
- Getting authority wrong fails in a site-dependent pattern across fields, methods, bridges and
  member classes.
- Getting scope wrong fails independently in member, local, anonymous and lambda bodies.

Score geometry: **13 of 13 cells route through the core**, and
the suite is cascade-coupled rather than scattered micro-tests. Coupling runs through stated
requirements only - every cell maps to a numbered row of section 4 on its own.

For the binary Olympus bar the relevant arithmetic is the conjunction: a partial implementation that
gets basis and authority right but closure or one scope family wrong still fails. The intended
near-solver band must be measured by the external agent calibration rather than forecast from the
reference.

### Gate B - validation spike: EXECUTED 2026-07-31 - GO

The final solution patch reports **444** changed production lines with the legacy
`review-guides/count_loc.py` screen. A manager-style recount that additionally removes package and
import lines plus standalone braces and punctuation yields **320**; removing the preference and
context-key wiring conservatively leaves **312**. The current Olympus golden floor is 250 meaningful
production lines, so the implementation clears it without counting tests, build logic, the
Dockerfile, comments, imports, braces, or option-table wiring.

The measured implementation uses the writer's structural text tokens rather than duplicating an
expression-tree visitor. Its substantial work is the monotone declaration closure, file-wide
candidate authority, Java field/method hierarchy resolution with access rules, and stable resolution
caches. This is why the measured file distribution differs from the original forecast below.

Execute: in a throwaway worktree, build the hardest fork - the emitted-reference closure with
file-wide scope, made authoritative at all three writer sites - and **measure** effective LoC
(non-blank, non-brace, non-comment, no imports, no type-only declarations), using the manager's
exclusion list.

Original forecast, retained for comparison:

| File | Responsibility | Forecast (effective) |
|---|---|---|
| `main/collectors/SyntheticRetentionAnalysis.java` (NEW) | traverse the decompiled statement/expression trees of a root class and its whole nested tree, collect member references across every expression form that can name a member, iterate to closure over the candidate-omission set, answer `isRetained(owner, key)` | 150-200 |
| `main/ClassWriter.java` | build once per root class; replace the three two-term OR decisions | 30-45 |
| `main/rels/ClassWrapper.java` | expose a reconciled, non-mutable retention view beside the raw set | 12-18 |
| `main/ClassesProcessor.java` or `main/rels/NestedClassProcessor.java` | keep nested-class omission consistent with the member decision | 10-15 |
| `main/extern/IFernflowerPreferences.java` | public opt-in key and disabled default | wiring only |

**The floor, corrected.** `my-review-workflow/rules/platform-panel.md` states the golden-solution
effective-LOC floor **tracks the criteria LOC row**, counted strictly, and that a strict count under
the floor is Request Changes with a bump choice - never approve-with-note. The panel doc records the
2026-07-11 row as 250; the sibling platform artifacts observed the live row at **200** in the most
recent rounds (a sibling passed at a 217 median and its ledger recorded the correction explicitly).
Note also that lenient tooling over-reports: `count_loc.py` passed a golden at 505 that the manager
counted at 360-371.

Therefore: **target >=250 strict effective lines and treat 200 as the absolute floor.** An earlier
draft of this plan targeted 150-170; that was wrong and is corrected here.

Gate B pass/fail:

- strict effective >= 250 -> GO (**met at 312 conservatively**);
- 200-250 -> GO only with a deepener applied and re-measured;
- < 200 -> the feature is thin. Deepen with an in-contract algorithm, or kill.

Deepeners that are legitimate (they force an algorithm, they are inside the stated contract, and
they do not pad): completeness of the reference traversal across every expression form that can name
a member (field access, invocation, instance creation, method reference, nested type usage in casts,
`instanceof`, generic arguments and annotation values); correct closure ordering; and consistent
nested-class retention. Deepeners that are **banned**: any further option; a diagnostics or reporting
subsystem; emitted-metadata rewriting (that is a claimed sibling island that scored 1/18 and 0/10
Nova); anything in `ContextUnit`, `CancelationManager`, the renamer, or the stack pipeline.

### Gate C - naive-agent gauntlet: NOT EXECUTED. Blocking.

Execute: a fresh session on the strongest available model, zero plan context, given only
`vineflower-synthetic-member-retention.md` plus the repo at base, ~1-2h. Record its diff and every
divergence verbatim in the plan as an addendum.

Read it against the three outcomes:

- cruises the core -> the ceiling is ~1.0; **kill or deepen**;
- builds the core and makes the predicted architectural mistakes -> strong signal; each observed
  mistake becomes a fixture;
- cannot start -> suspect ambiguity or undiscoverability, not difficulty; fix the wording and re-run.

Three specific questions Gate C must answer, because the plan cannot:

1. Does it reach for bytecode/constant-pool reachability (F1) or for the emitted trees?
2. Does it find all three writer sites, or subordinate only one (F4)?
3. Do F1, F2 and F5 actually split, or does one correct reading deliver all three (section 3)?

### The collapse risk Gate C must also settle

Both reproduced instances are reconstruction-setting-driven. A solver could write ~10 lines of
name-based or setting-based special-casing - "when assertion reconstruction is off, keep
`$assertionsDisabled`; when enum reconstruction is off, keep `$VALUES`" - and satisfy every naive
positive cell with no analysis at all.

**Mandatory experiment, before implementation:** hand-write that mutant and run the frozen suite
against it. It must fail at least three distinct cells - N3 (closure), P3 (cross-scope) and C1
(paired directions) are designed to be undecidable by any name-based special case. If it survives,
the suite is wrong or the task is not real: fix the suite, or kill.

---

## 6. Layer spread

| Layer | What the feature touches |
|---|---|
| class-file structure / access flags | `isSynthetic`, `ACC_BRIDGE` as inputs that stop being decisive |
| processing transforms | the six producers whose unilateral writes become candidates rather than verdicts |
| per-class wrapper state | `hiddenMembers` gains a reconciled view |
| decompiled statement / expression trees | the new reference source of truth |
| writer decision sites | three OR-decisions collapse into one authority |
| emitted output | declaration set, and therefore compilability of the file |

Six layers, each constraining the next: the matchstick touches the others rather than sitting in one.

---

## 7. Reference implementation shape

Five production files, including the required opt-in preference. `modules/decompiler/exps/AssignmentExprent.java:120` reads the raw set for
assignment folding and must stay *consistent*, but is deliberately **not** in the required edit set:
it is the same method that issue #538's publicly posted patch modifies and it sits inside a sibling
task's write set, so touching it invites both an originality and an overlap question for no contract
benefit. If a later revision proves an edit there is unavoidable, justify it in a dated plan addendum
first.

Count effective LoC twice - once after implementation, once after regenerating the final patch - and
explain every difference. Never count both sides of a replacement as two behaviors. Have the final
self-review actively try to reduce the solution; if a simpler faithful design drops under the floor,
the candidate is invalid even though the implemented patch is larger.

---

## 8. Test design

**10-13 cells.** Breadth, not any single cell, caused both sibling zero-pass rounds: four
near-disjoint capability islands produced 0/18, and forty cells across eight behavior classes
produced 0/17 then 0/20 with six near-solvers each dying on a *different* residual.

**Oracle.** Original-class-as-oracle - the only pattern that has held Test Fairness at
`unfairTestCount: 0` across repeated rolls in this repository family. Compile the fixture with
`javac --release 17`, decompile, recompile the emitted source, load both through isolated class
loaders, compare returned values, reference identity, record components and exception *classes*.
Assert properties, never forms.

**Per-cell fail-on-base is mandatory** - a cell built on a shape the base already gets right is not
a discriminator no matter how correct the property it asserts. Because the omission direction passes
on base by definition, pair the directions inside single cells: assert that a required member **is
present** and an unneeded member **is absent**. The presence half fails on base, so the cell is a
genuine F2P case, and the absence half still blocks F1, F5 and F6.

| Cell | Row | Content |
|---|---|---|
| P1 | 1-4,8 | assertion scaffolding is omitted after successful reconstruction and retained when reconstruction is disabled |
| P2 | 2-4,8 | inherited synthetic field retained while its sibling is omitted |
| P3 | 2-4,8 | inherited synthetic method retained while its sibling is omitted |
| P4 | 2-4,8 | bridge removal uses the same per-method decision |
| P5 | 2-4,8 | referenced synthetic member class retained while its sibling is omitted |
| S1 | 2,7 | outer field referenced only from a member-class body |
| S2 | 2,7 | outer field referenced only from a local-class body |
| S3 | 2,7 | outer field referenced only from an anonymous-class body |
| S4 | 2,7 | outer field referenced only from a lambda body |
| C1 | 2,5,8 | retained initializer reaches its own generated dependency but not an unrelated sibling |
| C2 | 3,5 | a generated method reachable only from omitted generated code stays omitted |
| N1 | 3,6,8 | a structural method token inside a comment does not retain that method |
| D1 | 2,3,9 | repeated runs, separate contexts and a recompiled round agree |

The repository `test` task is the activation/default-compatibility check: all existing goldens remain
unchanged while the option is disabled.

**Fixtures.** Prefer ordinary Java compiled in-test with `ToolProvider.getSystemJavaCompiler()`,
plus byte-rewriting of the class file where a JVM-valid but source-invalid shape is required. Avoid
asmtools unless unavoidable: the documented tax (Latin-1 source decoding, no `Signature` on methods,
no quoted enum values, no quoted class names in `InnerClasses`, explicit constant-pool indices) cost
a sibling two false REDs and hit three of its own agents.

**Non-negotiable fairness rules, all learned from sibling failures.** Assert the property, never the
form - no exact message text, no exception identity where a class suffices, no iteration order, no
source spelling, no member ordering, no file layout, no whole-output equality. Never assert anything
about your own fixtures. Never let an oracle construct or call a class the solution may modify (a
sibling shipped one and scored 0/18 with contradictory failure texts across runs). Never scan
emitted text for a member name. Tests compile against base-revision symbols only. Distinctive hidden
test-class filename - a predictable name was rejected outright in a sibling.

Build a mutant per row of section 3 plus the section 5 special-case mutant, and record which cell
kills each. Verify each kill is caused by the property you think it is; do not over-claim a mutation
proof.

---

## 9. Bypass-resilience table

| Question | Answer | Evidence / risk |
|---|---|---|
| Can a capable agent solve it in <20 min? | No for the whole contract | requires locating six producers, three consumer sites, and the tree-vs-bytecode distinction |
| Does each fork fail differently? | F3, F4, F6 clearly yes; F1/F2/F5 - **open** | flagged in section 3; Gate C must settle it |
| Is there a well-known pattern that solves it directly? | Partly - reachability is textbook | the twist is the *basis* (post-reconstruction trees) and the over-keeping penalty; see section 10 |
| Does the naive approach partially work? | **Yes** - bytecode reachability passes the positive cells and fails the negative ones | intended: partial success is the near-solver band, and it is why the paired-direction cells exist |
| Would the simple version pass 80%+ of planned cells? | No-retention fails 13/13; keep-all is rejected across multiple independent cells | special-case mutants still require external calibration |

---

## 10. Knowledge-transfer table

The model has certainly seen reachability-based dead-member elimination. The required twist is that
copying it produces the **wrong architecture** here.

| Language | Analogous feature the model has seen | Why transfer fails / misleads in this repo |
|---|---|---|
| Java | ProGuard / R8 shrinking, `-dontshrink`, tree shaking over the constant pool | the shrinker's basis is bytecode references; here the references that matter are the ones surviving *after* reconstruction, so a bytecode basis keeps members the base correctly omits |
| JavaScript | bundler tree-shaking, `sideEffects: false` | bundlers bias toward keeping when unsure; here over-keeping is a graded failure, so the "safe" bias is wrong |
| Python | `vulture` / unused-symbol linters | text- and AST-of-source based; here the source does not exist yet - it is being produced by the same pass that must decide |
| Go / Rust | linker dead-code elimination, `--gc-sections` | one global pass over a fixed graph; here the graph changes as the decision changes, which is why closure is required |

The prior is a liability: the obvious basis is bytecode, the obvious bias is keep-when-unsure, and
both are wrong. **Whether that is enough of a twist is exactly what Gate C measures** - this is the
single biggest open question in the plan, because `lessons/well-known-spec-features-are-ceiling-bound.md`
and `lessons/famous-refactoring-ceiling-survives-the-moat.md` both record a fair description of a
known algorithm telegraphing its own implementation.

---

## 11. Why this will be accepted (the seven properties)

1. **Existing seam.** `ClassWrapper.hiddenMembers` and the three `ClassWriter` decision sites are the
   seam; the feature extends them rather than grafting anything.
2. **Distributed difficulty.** Six forks (section 3), failing in different cells - with the F1/F2/F5
   caveat recorded honestly.
3. **Intuitive design is wrong.** Bytecode reachability and keep-when-unsure both fail, and the
   wrongness is discoverable from the stated contract and from the repo's own fold behavior.
4. **Observable contract.** Two faithful implementations - one collecting references during writing,
   one walking the trees beforehand - both pass.
5. **Description states outcomes.** Behavioral prose, no mechanism, every clause load-bearing.
6. **Failures map to requirements.** Every cell traces to a numbered row of section 4.
7. **Substantial, idiomatic reference.** Subject to Gate B; the floor is a hard gate, not a target to
   pad toward.

## 12. Why this dodges the anti-patterns

(a) **LoC as input** - forks come first, LoC is measured at Gate B and may kill the idea.
(b) **Fork contradicting base behavior** - the contract was derived *from* verified base behavior in
both directions, including the default-option negative result.
(c) **Arbitrary constant / unobservable fork** - every fork is observable in the emitted source or by
running the recompiled class.
(d) **Leaf value** - the decision has downstream consumers (the file's compilability) and a closure
over itself.
(e) **Compute-and-emit** - the sharpest objection. It is answered by the mutual dependency: the
output of the decision changes its own input, so it is not a single forward pass. Gate C must confirm
this is felt in practice.
(f) **Untestable natural home** - no daemon, no async; a synchronous decompile call drives everything.
(g) **Compiler-assisted READ** - nothing hands over the answer; it must be derived from trees the
repo does not currently consult.
(h) **Wall fork** - no cell requires a behavior no agent produces; the positive cells are satisfied
by the base's own reconstruction machinery once the decision is reconciled.

---

## 13. Harness (reuse the proven shape; one deliberate change)

- **`test.sh base` runs the repository's real `test` task**, not bespoke baseline cells. A sibling
  earned an auto-review `tests` band 1 with the explicit remedy "make `base` execute an appropriate
  set of the repository's pre-existing regression tests"; the other sibling's base mode is the full
  suite, 1330 cases in ~52s. Section 1 licenses this here: a correct implementation churns no
  golden, so the suite has real teeth. **Do not add any description clause licensing golden updates**
  - a sibling solver used exactly that licence to rewrite 16 goldens and report a clean 1330-case
  baseline while over-pinning the repository.
- **`test.sh new`** runs one custom Gradle `Test` task filtered to the hidden class. `test.sh` is
  `new file mode 100755`, contains no feature logic, takes `--output_path` and `base|new`, and copies
  the produced XML.
- **build.gradle**: a `JavaCompile` + `Test` pair, `options.release = 17`, `jacoco.enabled = false`,
  `outputs.upToDateWhen { false }` (a sibling audit caught Gradle reusing a custom `Test` task's
  output), `dependsOn classes, testFixturesClasses`, and **never `testDataClasses`** - that target
  provisions JDK 8/9/11/16/17/21/25 toolchains and destroys offline execution. Exclude the hidden
  class from the repository `test` task so base mode never runs it.
- **Dockerfile**: `public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`, non-root runtime, permissions set
  **before** `testClasses` (changing `/app` permissions afterwards invalidates Gradle input
  snapshots), pre-resolve `testRuntimeClasspath` / `testFixturesRuntimeClasspath` / `jacocoAgent` /
  `jacocoAnt` via an init script, strip JDK tarballs and daemon state, and carry
  `-Dorg.gradle.java.installations.paths=/opt/jdk-25` in **both** the Dockerfile and `test.sh`. Paste
  the local Dockerfile before every batch and re-verify after every download; a sibling batch silently
  ran on the platform's stale root-user copy.
- Expect `3-way test.patch merge failed (exit 128); resetting N test-patch file(s)` on every run once
  the test patch touches `build.gradle`. It always recovers, but every agent edit inside test-patch
  paths is discarded at grading time - so keep anything that must survive out of the test patch.
- Repo build facts: Gradle wrapper 9.2.1, toolchain 17, UTF-8 forced. Local `javac` 21.0.12. The
  default `test` task is offline-hostile only through `testDataClasses`.

---

## 14. Preflight plan and gate order

1. **Plagiarism preflight** with the full description at `vineflower-synthetic-member-retention.md`
   (the judge compares how the description is written, so this file is the right input, not a stub).
   Flagged similarity means pivot, not reword.
   **Known precheck risk to expect here:** the category bot failed a sibling for declaring
   `feature_request` where it wanted `enhancement`. Upstream labels #117 `Type: Enhancement`, so this
   submission is a likely repeat. The accepted sibling shipped `feature_request` and passed, so keep
   it and be ready to justify: the change adds a decision the decompiler does not currently make,
   rather than tuning an existing one. Do not silently flip the header - it is a graded field.
2. **Gate B** spike, measured.
3. **Gate C** gauntlet, recorded verbatim, plus the special-case mutant experiment.
4. **Red-team session**: a fresh session with only this plan + the repo tries to answer "yes" to
   every kill question in `rules/task-shape.md` section 5 and to attack each gate's evidence.
5. **W2 difficulty preflight** - vertical slice, draft submission, read trajectories not scores. No
   full build without a W2 GO.

## 15. Kill and redesign conditions

- an upstream merged or active implementation of #117 appears;
- the section 5 special-case mutant survives the frozen suite;
- Gate B strict effective LoC lands under 200 and no in-contract deepener lifts it;
- Gate C shows a fresh strong agent cruising the core;
- F1/F2/F5 prove to be one fork, leaving too few independent failures;
- no fixture can express closure or cross-scope reference stably without asmtools;
- a correct implementation cannot leave the 1330-case suite untouched;
- the only way to make a cell discriminate is to assert a source form, a message, an ordering, or the
  fixtures themselves.

If a batch returns zero passes, do **not** broaden: identify the single residual cell the strongest
runs fail and relax exactly that, in its own round. Coverage hardening and solvability recovery are
different rounds - a sibling added one coverage assertion during a recovery round and it became the
sole blocker of its best run, consuming the whole margin. If a batch exceeds 40%, the missing
difficulty is a behavior class or a shortcut, not obscure trivia - and never publish the lever as a
requirement while also adding the cell that covers it.
