# Seedable Lazy Evidence Ledger

This is the append-only evidence ledger for the `immutables-seedable-lazy` task. Later findings must be added as new dated entries; earlier observations are not silently rewritten. A superseded conclusion must remain visible and be followed by a correction that cites the new evidence.

## 2026-07-21T03:10:51+03:00 — Foundation snapshot

### Scope and authority

- Task directory: `/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-work/immutables-seedable-lazy`
- Host: `zeyad-nasef`
- Immutable task prompt SHA-256: `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`
- Immutable task plan SHA-256: `646074be0dbdb0b21a57c32bfbe302836940c61238ab46990d27b7ac4e10bbf5`
- Live platform bar observed in `my-review-workflow/rules/platform-panel.md`: pass rate at most 40%, at least one legitimate success, successful-run medians of at least 250 production LOC, 40 messages, and 2 files, with false-positive, fairness, environment, and anti-cheat review all required.
- Current false-positive doctrine observed in `.agent/rules/false-positive-calibration.md`: tests must close the public contract, distinguish a genuinely correct implementation from plausible incomplete implementations, and avoid hidden requirements.
- Execution doctrine observed in `standards/HYBRID-CLOUD-WORKFLOW.md`: inspection, history work, patch construction, and static review are local; heavy clean-state container verification is remote and account-qualified.
- Older numerical or execution guidance is treated as historical where the current platform panel or task prompt explicitly supersedes it.
- Full directory-level doctrine audit is still pending. This entry records only the minimum authority and safety reading required before the ledger was created.

### Repository state

- The task directory did not previously contain `.git`; a task-local repository was initialized on branch `main` before this ledger was written.
- Shared upstream cache (read-only): `/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/repos/immutables`
- Shared cache branch/status at observation: `master...origin/master`, with no short-status changes reported.
- Shared cache HEAD: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`
- Shared cache remote: `https://github.com/immutables/immutables.git`
- Provisional foundation base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`; public upstream and overlap revalidation remain pending and no artifact may claim this base is final yet.
- The shared cache will not be switched, reset, cleaned, stashed, or edited. Source work will use a uniquely named detached worktree or disposable clone.

### Provisional contract model

The proposed feature combines `@Value.Lazy` and `@Value.Default` into one explicitly seedable lazy attribute. The central semantic model has three provenance states:

1. **Cold fallback** — no explicit seed and no successful initializer result.
2. **Computed fallback** — the initializer completed successfully and its result is memoized.
3. **Explicit seed** — a builder, supported copy/merge path, or own-attribute wither supplied a value; the initializer must be bypassed.

Provisional behavioral obligations, pending source and history confirmation:

- Building without a seed must not evaluate the initializer.
- Any legal explicit value—including `null` where permitted, zero, `false`, and empty optional/container values—must count as an explicit seed rather than a sentinel for absence.
- A successful cold access must be thread-safe and memoized once.
- An initializer exception or `Error` must not be memoized; later access retries.
- An own-attribute wither establishes explicit provenance even when its value equals a previously computed fallback; an already-explicit equal value may be a no-op.
- An unrelated changed copy preserves explicit provenance but resets cold or computed fallback provenance to cold; no copy path may force a cold getter.
- Generated `from`/`toBuilder` paths preserve known explicit provenance. A generated merge from an unseeded source behaves as absence and must not erase an existing target seed.
- Equality, hashing, string rendering, and other auxiliary operations must not force a cold seedable-lazy value unless the final scoped contract explicitly and visibly says otherwise.
- Pure `Lazy`, pure `Default`, and pure `Derived` behavior must remain unchanged; `Lazy + Derived` remains invalid.
- Public annotation documentation must describe the supported combination and its constraints.

### Provisional boundary register

Each conditional surface below is unresolved until generator/source tracing and fixture generation establish whether it can be specified, rejected cleanly, or safely excluded:

- collection/map convenience mutators;
- builder `clear` behavior;
- arbitrary external `from`/`copyOf` paths, including checked getters;
- `Modifiable` transfer, unset, and `toImmutable` paths;
- simple and structural Java serialization;
- generated Gson/OkJson and reflective Jackson;
- interning/canonicalization;
- constructor, encoding, strict-builder, staged-builder, naming, nullable, optional, and multi-attribute interactions.

The pre-existing pure-Lazy `lazyInitBitmap` collision is outside scope. Only state names introduced by this hybrid may be changed if a collision is found.

### Initial contract-closure matrix

| Requirement | Intended positive oracle | Intended negative/mutation oracle | Evidence state |
| --- | --- | --- | --- |
| Omitted seed stays cold | build-side-effect counter remains zero | eager-default mutant | Pending |
| Explicit seed bypasses initializer | seed values returned with counter zero | ignores-seed mutant | Pending |
| Legal falsey/empty/null seeds are explicit | parameterized sentinel cases | value-as-sentinel mutant | Pending |
| Successful access memoizes once | repeated and concurrent access | no-memoization/racy mutant | Pending |
| Failure retries | exception and `Error` then success | memoized-failure mutant | Pending |
| Own wither creates explicit provenance | equal-to-computed then unrelated copy | equal-wither-no-op mutant | Pending |
| Unrelated copy resets fallback provenance | computed source copied with other change | copies-cache mutant | Pending |
| Explicit provenance survives copy | explicit source copied with other change | drops-explicit mutant | Pending |
| Transfers do not force cold source | side-effect counter across copy/merge | force-getter mutant | Pending |
| Unseeded merge does not clear target seed | pre-seeded builder merged from cold source | merge-clears-seed mutant | Pending |
| Auxiliary methods remain cold-safe | equals/hash/toString counters | render-forces mutant | Pending |
| Multiple attributes have independent state | two hybrid attributes exercised separately | shared/single-bit mutant | Pending |
| Compatibility boundaries are deterministic | supported fixture or compile-time rejection | unsupported-surface mutant | Pending |
| Pure annotation behavior is unchanged | regression fixtures | broadened-generator-branch mutant | Pending |
| Public Javadocs disclose semantics | source assertion/review | documentation-removal mutant | Pending |

### Mandatory gates not yet satisfied

- Complete read of every file in the six doctrine/workflow directories named by the task prompt.
- Read both older context documents.
- Complete history/artifact study for the five named precedent tasks.
- Gate 0 public issue/PR/branch/commit and current-upstream overlap revalidation.
- Generator architecture trace and generated-source baselines for pure Lazy and pure Default.
- Conditional-surface characterization and explicit scope decisions.
- Minimal vertical spike and meaningful-production-LOC gate.
- Zero-context dry-run calibration if suitable infrastructure is available.
- Final artifact construction, static/adversarial/mutation checks, and four-state remote verification.
- Fresh legitimate solver evidence if available; otherwise that remains an external platform gate.

## 2026-07-21T03:15:11+03:00 — Governing-context audit complete

### Material read in full

- Every file under `.agent/rules/` and `.agent/workflows/`.
- Every textual/source file under `review-guides/`, including the complete example `solution.patch`; compiled Python cache files were identified and inspected for provenance rather than treated as policy text.
- Every file under `my-review-workflow/`, including the complete lessons corpus, rules, references, workflow, and review template.
- Every file under `olympus-tmp/new-dot-agent/`, including all rules, workflows W0–W8, lessons, and templates.
- Every substantive text document under `standards/`: `WORKFLOW.md`, `HYBRID-CLOUD-WORKFLOW.md`, Java/C++ support guidance, and the textual content of the Olympus Diamond guide. The guide's embedded base64 image payload was treated as binary asset data, not prose policy.
- Both older context documents: `olympus-tmp/tmp.md` and `immutable-tmp-plan.md`, including the complete candidate menu, history, gates, graveyard, and knowledge-base brief.

### Authority resolution and consequences

- `my-review-workflow/rules/platform-panel.md` is the live numerical platform authority. Historical 400/700/850-message or LOC figures elsewhere are not current acceptance floors.
- This task deliberately keeps a stricter author-side production threshold from its immutable prompt: GO at 325 meaningful production lines, preferably 375–500, with at least four independent implementation decisions. The platform's 250-line median remains an external run-quality measurement, not permission to submit a thin task.
- False-positive review is a contract-closure exercise, not a request to make a hard task easier. Every public requirement must have a faithful positive path and a plausible-incomplete negative discriminator; a passing candidate remains provisional until adversarially probed.
- Zero-pass remediation must classify the cause before changing anything: harness failure, one dominant discoverability blocker, excessive breadth, golden/contract defect, or invalid seam. Hints may state WHAT is required, never leak HOW the reference implements it.
- Generated-source tasks inherit a substantial integration wall. Difficulty must come from real state/provenance decisions and cross-surface invariants, not incidental template syntax or broad mechanical edits.
- The older derived carry-over proposal is useful negative context: invasive generator-state machinery can create volume while multiplying fairness and compatibility liabilities. Seedable Lazy+Default remains a distinct, narrower idea and must earn its own scope through measured production work; no scope will be added merely to cross the LOC gate.
- Verification is split by design: local history/source/static/patch work, then account-qualified remote clean-state container verification using the task's final bytes. Shared repositories and shared Codespaces are never reset, pruned, stopped, or repurposed without ownership checks.
- Author completion and platform acceptance remain separate. The task can become submission-ready locally while fresh legitimate-solver calibration, platform pass rate, and external reviewer decisions remain explicitly external gates.

### Immediate next gate

Gate 0 must now establish, from current public primary sources and the upstream remote, that issue #1137 is still open/relevant, no accepted implementation or maintainer rejection has made the task stale, the intended base commit is reproducible, and no overlapping local/public branch or patch already solves the requested feature. No implementation work begins until that evidence is recorded.

## 2026-07-21T03:23:37+03:00 — Gate 0 and precedent audit complete

### Current public and repository evidence

- `git ls-remote https://github.com/immutables/immutables.git refs/heads/master` still resolves to `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`, exactly the foundation base. The only current remote heads are `master` and the unrelated `jackson-pathnaming` branch.
- GitHub issue #1137 remains open, unassigned, unlabeled, and without linked development. Its three comments reinforce the same use case: a value may be supplied at construction, otherwise it is computed lazily. No maintainer endorsement or rejection appears; this is evidence of repository fit and an unimplemented request, not evidence that maintainers approved a particular design.
- Open/closed pull-request searches, repository commit searches, the issue timeline, and remote-branch searches found no implementation for issue 1137, `Lazy + Default`, seedable lazy, or settable lazy. The only PR returned by a broad lazy/default search was unrelated PR #806.
- A complete local `my-work/` search found no overlapping task or patch outside this task's immutable prompt and plan.
- The shared checkout remained clean at the exact base. A detached task-owned worktree was created at `/tmp/immutables-seedable-lazy.MEax8f`; the shared checkout has not been edited or switched.
- Current `AccessorAttributesCollector` still emits `@Value.Lazy attribute '<name>' cannot be @Value.Derived or @Value.Default`. Thus the requested combination is not already implemented at the pinned base. Existing fixtures contain separate Lazy and Default accessors, not the combination.

Gate 0 result: **continue**. No public implementation or maintainer rejection was found. The exact base remains reproducible and current. The absence of maintainer feedback remains an explicit uncertainty rather than being converted into an endorsement claim.

### Precedent-history synthesis

The complete version histories and available run/review artifacts for all five required precedent tasks were inspected. The recurring result is more specific than a generic warning about difficulty:

- Map-entry collections showed that many fixtures can collapse to one central recognition decision and produce 10/10 fresh passes. Boundary checks such as adjacent `Map -> Stream` behavior and generated-name collisions are more useful than additional examples of the same decision.
- Criteria quantifiers showed both sides of the calibration failure: broad conjunctive scope repeatedly produced zero passers, while narrowing restored legitimate passes; separately, a large raw diff still failed the strict meaningful-production floor at roughly 230 lines.
- Binary serialization became accepted only after constructor and shape promises were narrowed coherently and every retained eligibility/evolution class received both positive and plausible-incomplete negative coverage. Its final distribution was 1/14 with a genuine passer.
- Value pointers became safe only after eligibility was expressed as a repository-level class covering all relevant nested implementations and vetoes rather than individual fixtures. Its accepted iteration retained legitimate passers under FP review.
- Exhaustive fold recovered from zero passers caused by unstated API pins; its final FP closure added behavioral comparator/enclosing boundaries while keeping two genuine passers.

Applied rule for this task: the closure unit is `provenance state × generated transfer surface`. Tests will distinguish cold, computed, and explicit origin across build, own-copy, unrelated-copy, generated merge, and auxiliary observation. Additional shapes are retained only where they introduce an independent semantic decision; they are not used to inflate fixture count or source volume.

## 2026-07-21T03:23:37+03:00 — Architecture characterization before spike

### Current model and generated-source behavior

- Pure Lazy is classified with `isGenerateLazy`; it is gettable but not settable or implemented. `ValueType.getLazyAttributes()` gives it a separate generated path, while `implementedAttributes` controls ordinary immutable fields, equivalence, rendering, and generated marshaling.
- Pure Default is both implemented and settable. Its builder storage may use a tracked optional bit; construction eagerly invokes the accessor initializer when the builder omits a value. Default therefore cannot simply remain active on a hybrid without violating cold construction and auxiliary identity.
- The pure-Lazy generator emits a transient value field, a volatile initialization bitmap, and a synchronized double check. It publishes the bit only after the initializer returns, which naturally preserves retry after `Exception` or `Error`.
- Builders derive their fields and mutation methods from `settableAttributes`; immutable stored fields/accessors derive from `implementedAttributes`. This permits a distinct hybrid to be builder-settable while remaining outside identity/rendering/marshaling, but construction and copy templates must then transfer its state explicitly.
- Existing direct copy construction iterates settable/implemented attributes as ordinary values. Existing builder `from` invokes every setter from an accessor. Both would force or lose seed provenance unless they receive hybrid-specific paths.
- Structural Java serialization iterates `settableAttributes` and calls accessors, so an unfiltered hybrid would be forced. Simple Java serialization already treats ordinary Lazy cache fields as transient. Generated Gson/OkJson write paths derive from implemented/marshaled attributes and naturally omit Lazy; Jackson's reflective behavior can still discover public getters, as it does for ordinary Lazy.
- Modifiable generation derives fields/accessors/from/unset/toImmutable behavior from implemented/settable groups. Supporting the hybrid there would require a separate mutable provenance contract. Interning can canonicalize two identity-equal values with different auxiliary origins. Neither behavior can be left accidental.
- Checked exceptions are already supported by pure Lazy accessors. A provenance-aware generated-instance copy can avoid invoking them; arbitrary external instances cannot reveal provenance and therefore must be treated as absent rather than read.

### Provisional spike scope, subject to the strict LOC gate

The spike will introduce an explicit seedable-lazy model classification rather than retain ordinary Default implementation semantics. It will cover immutable builder activation, tracked explicit values (including primitive and nullable sentinels), lazy success/retry/concurrency, scalar and JDK-optional own withers, unrelated withers, generated-instance `from`/`toBuilder`, cold-safe external copy behavior, auxiliary identity/rendering, builder clear, structural-serialization cold safety, and generated-name disambiguation for new state.

The spike will reject, with source diagnostics rather than undefined generation, combinations whose native contracts are not part of the selected feature: collection/map/array incremental mutation shapes, `@Value.Modifiable`, interning, builder-disabled/constructor-only generation, and encoding-backed attributes. Reflective Jackson retains its existing getter-discovery behavior and simple Java serialization resets all transient Lazy state to cold. Generated Gson/OkJson omit the auxiliary value on write; any input-side behavior will be characterized before the final contract is frozen.

This scope is not final merely because it is implementable. After the smallest complete vertical slice, the manager-style meaningful production count decides GO/investigate/kill. No conditional surface will be added solely to cross the 325-line author threshold.

## 2026-07-21T03:56:08+03:00 — W3 spike, conditional-surface decision, and Gate B

### Spike implementation and remote evidence

- The isolated worktree remains `/tmp/immutables-seedable-lazy.MEax8f` at base `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`; the shared checkout remains untouched.
- The spike now uses a distinct seedable-lazy classification. It is builder-settable and lazy but is not an implemented/equivalence/marshaled attribute. Explicit-seed and successful-lazy-initialization state are tracked separately.
- Immutable construction stays cold when omitted. Explicit primitive, nullable, optional, array, collection, and map seeds initialize the lazy result without executing the fallback. Empty bulk collection/map mutations establish explicit provenance.
- A successful fallback uses the existing synchronized Lazy publication path. A thrown checked exception is not memoized. Immutable own-withers establish explicit provenance even when supplied content equals a computed fallback; unrelated changed withers preserve explicit seeds and reset computed fallback caches to cold.
- Generated immutable `from`, `toBuilder`, and `copyOf` paths inspect provenance only for generated implementations. Arbitrary external implementations are treated as unseeded and their hybrid getter is not invoked, including when builder `from` generation is disabled.
- Equality, hashing, rendering, structural serialization, and generated marshaling continue to derive from implemented attributes and therefore do not force or include the hybrid. Simple Java serialization follows ordinary Lazy behavior: transient lazy state returns cold after deserialization. Reflective Jackson remains governed by its ordinary public-getter discovery behavior and is not represented as a universal omission guarantee.
- Collection/map/array APIs were retained after source characterization showed that their native builder and wither shapes introduce a real explicit-empty decision. All add/addAll/put/putAll paths use the normal tracked-set machinery rather than a separate sentinel convention.
- Modifiable support was initially considered for rejection. Source generation showed that `@Value.Modifiable` already has a native non-caching Lazy fallback model, so the retained contract now supplies the missing explicit-seed layer rather than prohibiting the combination. Direct access, `isSet`, `unset`, `clear`, modifiable-to-modifiable merge, immutable-to-modifiable merge, modifiable-to-immutable conversion, and immutable-builder transfer are provenance-aware. Unseeded sources neither force a fallback nor clear an existing target seed.
- Unsupported combinations are now explicit: builder-disabled generation, disabled generated with-methods, interning, and encoding-backed hybrid attributes. `Lazy + Derived` remains invalid. These restrictions prevent silently partial generator output.
- New state names are disambiguated against ordinary implemented attributes and seedable-lazy attributes. Internal provenance helper names use the repository's accessor-disambiguation convention.
- The first remote clean build exposed a template-balancing error in a regression-isolation branch. The next exposed statically impossible sibling casts and helper visibility across Immutable/Modifiable companions. Those were corrected at their generator roots. The final focused remote run completed with 5 tests, 0 failures, 0 errors, and `BUILD SUCCESS` at `2026-07-21T00:54:49Z` (10.979 s).

### Gate B strict production count

Current production delta: 508 additions and 22 deletions across eight production files. A reproducible conservative screen over the unified diff classified:

- 37 blank additions;
- 77 comment/Javadoc additions;
- 37 brace or punctuation-only additions;
- 357 remaining added production/control lines, including 139 substantive generator branch/iteration directives; and
- 19 nontrivial deleted/replaced production lines.

The codebase-standard `ValueAttributeFunctions` predicate expansion contributes 23 lines that may be treated as boilerplate. Removing all 23 from the 357-line screen and counting the 19 nontrivial replaced lines yields **353 strict production lines**. This deliberately gives no credit to annotation Javadoc, fixtures/tests, generated Java, imports, blanks, comments, punctuation-only lines, or the predicate boilerplate. It clears the task's 325 author gate and the live 250 platform floor without relying on raw generated output; it remains below the 375 preferred comfort target, so no unrelated surface will be added.

Independent implementation decisions now exceed four:

1. model classification and compatibility validation;
2. separate explicit-origin and computed-cache state/publication;
3. builder activation and falsey/empty sentinel handling across scalar/container shapes;
4. immutable wither/copy provenance reset versus preservation;
5. generated-instance versus arbitrary-external transfer policy, including checked getters;
6. auxiliary identity/marshaling/serialization boundaries;
7. Modifiable access, unset, clear, and bidirectional conversion semantics; and
8. feature-introduced name disambiguation and multi-bitmap allocation.

Gate B result: **GO**. The behavioral scope is frozen to the surfaces above. The next work is contract-first task artifact construction, adversarial test closure, mutation review, and exact four-state verification; no further feature family is authorized merely to increase patch size.

## 2026-07-21T04:18:00+03:00 — First canonical-artifact verification, then superseded

### Artifact and contract construction

- The five canonical artifacts were created at the pinned base. The test patch keeps its positive feature sources outside Maven's configured test roots and stages them only in `new` mode. This is necessary for a fair base state: the clean processor rejects the annotation pair during test compilation before Surefire can apply a class exclusion.
- The focused suite initially contained nine behavioral tests covering cold/successful initialization, falsey and empty seeds, checked-exception and `Error` retry, concurrency, immutable withers, generated and external transfers, auxiliary identity/rendering, simple and structural serialization, Modifiable state/conversions, multiple attributes, and a feature-introduced state-name collision.
- Three isolated `javac -proc:only` fixtures require processor diagnostics for builder-disabled, copy-method-disabled, and interned configurations. They check a semantic identification of the annotation pair rather than a complete diagnostic sentence.
- Independent and combined exact-base `git apply --check`, `--whitespace=error-all`, `git diff --check`, executable-mode, shell-syntax, path-disjointness, ASCII, forbidden-path, and solution/test leakage gates passed.

### Remote four-state result for the first hashes

- Account: `Zeyad-Nasef`.
- Codespace: `olympus-forge---zeyad-nasef-g44vv9gxpgxg29r69`.
- Base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- First verified hashes: description `aecb243e5ff65ef50dab65f24057ff1512f819a2bf79204680f37fe998a8ec32`, tests `6da8a5cbbc5efd5f282bb9b3a096f8fe6178b9e62d1fb0899d298bf1f579ae82`, solution `00b8dbc390272550a8152ea24e5803a361bbb74aeed2d4218e1479506bf475d1`, Dockerfile `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c`, base file `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.
- `scripts/verify-remote.sh my-work/immutables-seedable-lazy --account Zeyad-Nasef` reported all four states held: baseline passed without the solution, focused tests failed without the solution, baseline passed with the solution, and focused tests passed with the solution.
- Returned solution-state XML: 327 baseline tests, 0 failures, 0 errors, 1 existing skip; 9 focused tests, 0 failures, 0 errors, 0 skips.
- A separate exact test-image replay preserved the missing-solution failure: exit status 1 because the clean processor reports that every paired accessor cannot combine `@Value.Lazy` with `@Value.Default`. This proves feature causality rather than a harness/environment failure.

### Why this verification is superseded

The subsequent fresh documentation and coverage audit found two author-side completeness improvements: the `Value.Default` Javadoc also needs an explicit cross-reference to the combined lazy behavior, and the focused suite should exercise single-element collection/map mutators plus unseeded and explicit Modifiable-to-Modifiable transfers. Those changes alter the solution and test hashes, and the public Modifiable wording was narrowed to types requesting both generated companions. Therefore the successful batch above remains useful development evidence but is **not** final-hash verification. All static and four-state gates must run again after the bytes stabilize.

The task-owned remote verification and spike directories and the two task images were removed after their evidence was copied locally. No other container was running; the forge was stopped with approximately 7.0 GB free. No shared image prune was performed.

## 2026-07-21T06:02:03+03:00 — Adversarial closure and final author-ready hashes

### Superseded stabilization runs

After the first canonical batch, the `Value.Default` Javadoc, collection/map single-element
mutators, Modifiable-to-Modifiable transfers, cold structural serialization, and generated Gson
output coverage were added. Multiple clean remote batches held all four states while those checks
were developed. The last such superseded artifact set had description
`d43cf30fd179dd44ad48a3b947eaf526e8187ef9e285fdd30ecf688e39c0de91`, test patch
`ac30dd945ef8d857d56c90509a88ad1170df4dc96412edc284f0199c6c5a240d`, and solution patch
`8f89045f69ab0e32a756e1a598fbad9f8cc1bfb0dba6f5cc7f85dcd2f26ddaa7`. It returned 327 clean
baseline tests and 9 clean focused tests. It is retained as development evidence only: the later
adjacent-diagnostic and dead-branch audit changed all three hashes.

### Mutation and functional bug-hunt evidence

Fourteen behavioral variants were exercised against generated output. The raw
`.verify/mutations/results.tsv` records twelve immediate kills and two initial survivors. Those
survivors were investigated rather than accepted:

- the first failure-memoization edit did not match the generated checked-exception expression;
  correcting the operator caused `checkedExceptionAndErrorAreRetriedUntilSuccess` to fail;
- the first structural-serialization test used only an explicit source, so forced evaluation was
  observationally masked; adding a cold structural source caused the corrected mutant to fail.

The final fourteen behavioral variants all failed a stated focused test while the reference
passed. A processor-source mutant that removed interning rejection was also killed by the isolated
negative compile gate. A generated Gson adapter mutant that wrote `instance.value()` was compiled
directly and killed by the marshaling assertion because it both included the property and forced
the cold initializer. Final semantic mutation result: **16/16 killed**. Raw corrected logs remain
under `.verify/mutations/`; the initial survivor rows were not rewritten.

The last human-style audit found that pure-Lazy abstract, final, and Lazy+Derived diagnostics were
preserved by the reference but not actively pinned by the focused patch. Three isolated
`javac -proc:only` sources were added with semantic diagnostic fragments. Together with interned,
builder-disabled, and copy-method-disabled hybrid sources, the final suite has six negative
configurations.

An attempted encoding-boundary probe then proved the planned restriction was unreachable.
`ValueAttribute.initAndValidate` deliberately skips encoding instantiation whenever
`isGenerateLazy` is true, so a hybrid Lazy attribute can never have `AttributeTypeKind.ENCODING`.
The reference's encoding-validation loop was dead and the description's matching promise was
vacuous. Both were removed. This supersedes the provisional plan/earlier ledger statements that
encoding-backed hybrids should be rejected. No alternative feature was introduced.

The dead-branch removal changed raw production size from 510 additions to 504. The strict Gate B
screen correspondingly changed from 357 to 351 added production/control lines. Discounting all 23
predicate-boilerplate lines and crediting 19 nontrivial deleted/replaced lines gives **347 strict
meaningful production lines**. Gate B remains GO: 22 lines above the 325 author buffer and 97 above
the live 250 floor, with the same eight independent architectural decisions.

### Final canonical artifacts

- Base file: `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`
- Dockerfile: `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c`
- Description: `3eea6ddb46980cf329ba3aa420630a6ad6b452d8d2de5c134816d62eb0408ec2`
- Test patch: `1a04d0f653d8542b59ce1561fefbfd78b608570ebb3652b1ed100c9954810022`
- Solution patch: `63dedce9e52a5c3f977b8ca37fafb6889bcad0e6318d2dcfab6c816ec2abf4ec`
- Immutable prompt: `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`
- Immutable plan: `646074be0dbdb0b21a57c32bfbe302836940c61238ab46990d27b7ac4e10bbf5`

Final static checks passed: independent and combined exact-base application, whitespace-error
application, isolated `git diff --check`, zero path overlap, executable harness mode, shell syntax,
selector/exclusion review, ASCII, forbidden-path and leakage scans, and canonical-applied-tree
equality with the isolated worktree. `commit-message.txt` remains absent because the user did not
request it. The shared checkout remained clean at
`45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.

### Final exact-hash remote verification

The final command was:

```text
scripts/verify-remote.sh my-work/immutables-seedable-lazy --account Zeyad-Nasef
```

- Account: `Zeyad-Nasef`.
- Codespace: `olympus-forge---zeyad-nasef-g44vv9gxpgxg29r69`.
- Fresh-clone base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- Container test networking: disabled.
- Base + test patch, baseline mode: PASS.
- Base + test patch, new mode: expected FAIL, observed nonzero.
- Base + test + solution, baseline mode: PASS.
- Base + test + solution, new mode: PASS.
- Verifier summary: `RESULT: ALL FOUR STATES HELD`.

Copied final evidence:

- `.verify/out/base.xml`: 60 suites, 327 tests, 0 failures, 0 errors, 1 skip; SHA-256
  `ad6ebe569d54b7692e87f37dfc6c8ca8db2a0ecb6141b42fdedcda114127d03d`.
- `.verify/out/new.xml`: 1 suite, 9 tests, 0 failures, 0 errors, 0 skips; SHA-256
  `a40a806eacaff190eef327fdf54f340f1b3bcf476e03a8fce721db1285f79e62`.
- `.verify/out/final-missing-solution-new.xml`: 1 synthetic pre-Surefire test and 1 failure;
  SHA-256 `29d49b82c5373c664671b8625a0ea269a475fb1a5c00629017fe084a24aeca18`.
- `.verify/out/final-missing-solution-new.log`: SHA-256
  `5d6344229fd35d9b5d999e01200206cb2ec68bd052afc0c40dc5bc62f9e5d51c`.

The separate missing-solution replay exited 1 because the clean processor rejected all paired
accessors with its existing Lazy/Default diagnostic. The successful new state ran all nine JUnit
methods and all six negative compilation checks. No network, dependency, or selector failure was
used to satisfy the expected-red state.

### Final public-state refresh and cleanup

Immediately before handoff, upstream `master` still resolved to the exact base; the only other
remote head was unrelated `jackson-pathnaming`. Issue #1137 remained open, unassigned, unlabeled,
with three comments and no linked development. A pull-request search for issue 1137, lazy default,
or seedable lazy returned zero results. This is repository-fit evidence, not maintainer approval.

After copying evidence, the exact task images
`olympus-verify-immutables-seedable-lazy-t` and
`olympus-verify-immutables-seedable-lazy-ts` and the exact remote directory
`/home/codespace/verify/immutables-seedable-lazy` were removed. No containers existed before or
after cleanup, no broad image/system prune ran, and the forge was stopped. Disk state before stop
reported approximately 6.2 GB free.

### Readiness boundary

Author-side verdict: **ready for external calibration on the five exact hashes above**. The full
author review is `seedable-lazy-author-review.md`.

Gate C and final solver calibration were not fabricated. No legitimate task-scoped zero-context
solver/platform runner with capability-tier identity was available in this session; an inherited
collaboration agent would not be an independent sample. Therefore legitimate-pass count, pass
rate, successful-run medians, platform false-positive adjudication, platform auto-review/AI
evaluation/prechecks, manager approval, and acceptance remain external. Any canonical artifact
edit invalidates this final verification and requires a new exact-hash run.

## 2026-07-21T07:40:00+03:00 — Post-precheck refinement

The later solution-quality precheck invalidated the preceding author-ready verdict. It found a
real state-transfer hole: generated transfer paths always called `addAll`/`putAll` for collection
and map attributes, so an explicitly seeded `null` on a nullable container could not survive
`from`, `toBuilder`, or immutable/modifiable conversion. The old exact hashes and remote evidence
remain historical only.

### Refinement checklist

- [x] Rewrite the description in the compact accepted-task style, add the standard metadata, and
  remove implementation history, redundant legacy behavior, reflective-serializer wording, and
  generic collision reminders. The contract is now 286 words.
- [x] Preserve nullable collection/map seeds by routing nullable containers through their normal
  whole-value setters during generated immutable and modifiable transfers; keep incremental
  `addAll`/`putAll` transfer for non-null containers.
- [x] Add nullable list/map fixtures and assertions for direct builder seeds, with-methods,
  `from`, `toBuilder`, `copyOf`, Modifiable-to-immutable, immutable-to-Modifiable, and
  Modifiable-to-builder transfers, plus nullable `unset` behavior. These checks distinguish an
  explicit `null` seed from omission and prove that no fallback is evaluated during transfer.
- [x] Compare seeded and unseeded instances directly across equality, hash code, and string
  rendering while their initializer counters remain cold.
- [x] Loosen the three legacy invalid-Lazy diagnostic checks to the stable semantic fragment
  `@Value.Lazy`; retain the more specific hybrid diagnostic check for the three newly unsupported
  configurations stated by the task.
- [x] Remove `seedable-lazy-author-review.md`. It duplicated ledger evidence and its readiness
  verdict was stale after the transfer defect was discovered.
- [x] Regenerate both canonical patches from the task-owned worktree and re-run exact-base static
  application checks.
- [ ] Run the remote exact-hash four-state verifier and the platform prechecks/auto-review after
  Verify Solution is available. Agent pass-rate and false-positive calibration remain external
  submission gates rather than author-side claims.

### Local verification and current artifacts

- Exact base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- Combined production build: PASS.
- Baseline mode: 327 tests, 0 failures, 0 errors, 1 existing skip.
- Focused mode: 9 tests, 0 failures, 0 errors, 0 skips; all six negative compilation checks also
  passed.
- Independent test-patch and solution-patch application checks passed at the exact base. Combined
  `--whitespace=error-all` application and `git diff --check` passed; the harness remains
  executable.
- The solution still has 504 additions and 22 deletions across eight production files. The prior
  conservative 347 meaningful-production-line count is unchanged because the repair changes
  template branch conditions without changing the production line count.
- Description SHA-256:
  `1dc71692e858391d536074862f8c8d5e7bad63f5512a1913f5aa34ed40538249`.
- Test patch SHA-256:
  `9cf41d322c3c86c89992c266e2de127881a1b2eebad09948d5bb380ae581bceb`.
- Solution patch SHA-256:
  `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.

No Codespace or remote container was used for this refinement. The canonical artifacts are locally
coherent and ready for the unavailable external verification gates; they are not represented as
platform-accepted or final-hash remotely verified.

## 2026-07-21T08:29:23+03:00 - Submitted-precheck repair

The platform prechecks for the preceding hashes were saved as
`seedable-lazy-prechecks.md`, SHA-256
`7800686e2a90b138a8d9fedbec799a3e88ab1b88419868956fb0b6b665f41032`. They reported two
blocking task defects. Test Fairness rejected the fixture attribute named
`seedableLazyInitBitmap` because it exposed a private generated-state naming choice. The
problem/test alignment check rejected the negative-compilation harness because it required the
literal phrase `@Value.Lazy with @Value.Default` even though the description promised only a
diagnostic identifying both annotations. The stale Verify Solution block separately showed green
baseline and focused results, then failed with `harbor_oracle_failed` and `RuntimeError`; this is
platform infrastructure evidence, not a reproduced solution failure.

### Coherent repair

- Removed the private-name collision fixture and assertion. The same scenario now tests only the
  repo-discoverable behavioral contract that multiple seedable-lazy attributes keep independent
  initialization state.
- Changed the three hybrid negative-compilation checks to require the two annotation markers
  independently. Implementations may choose their own connective wording while diagnostics still
  identify the prohibited combination. The legacy Lazy checks continue to require only the
  `@Value.Lazy` marker.
- Applied all current description-bot suggestions: removed the redundant `non-abstract` qualifier,
  ordinary Lazy restatement, auxiliary meta lead-in, optional label, and discoverable Modifiable
  method-name list. The remaining 247 words state only the new observable contract.
- Added the two advisory coverage branches inside existing lifecycle scenarios. Ordinary Java
  serialization now proves that an already-computed fallback is restored cold, and two consecutive
  checked failures on an unseeded Modifiable prove retry without setting the attribute.
- Removed the redundant Maven-wrapper version probe from the Dockerfile. The remaining Maven
  resolution warning is generic to building this Maven reactor, and deleting `target` directories
  after dependency installation is intentional image-size cleanup. Neither advisory warrants
  changing the repository dependency model or retaining disposable build products.

The production solution did not change in this repair. In particular, its internal generated-field
disambiguation remains a robustness property, but no test requires a solver to predict that private
name or mechanism.

### Local verification and current artifacts

- Exact base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- Baseline mode: 327 tests, 0 failures, 0 errors, 1 existing skip.
- Focused mode: 9 tests, 0 failures, 0 errors, 0 skips; all six negative compilation checks passed.
- Shell syntax, patch whitespace, independent exact-base application, combined exact-base
  application, executable harness mode, ASCII, and private-name/exact-phrase leakage scans passed.
- Dockerfile SHA-256:
  `d4631cd6ba874efecee7f56b2230f8d7bdc671f23792879dace6df765e46a767`.
- Description SHA-256:
  `347a85d090766ce037828501afb08d8ca082960eb4890207ffb752a55e54d2f0`.
- Test patch SHA-256:
  `4afbd8cfe88367330a37f668338408264887e65d85f1ee7e4fbf9e71d43697d8`.
- Unchanged solution patch SHA-256:
  `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.

No Codespace was started. The changed description, test patch, and Dockerfile make all preceding
platform verdicts state-stale. Test Fairness, problem/test alignment, description review,
Dockerfile review, Verify Solution, agent calibration, and False Positive evaluation must be run
again against these exact hashes before submission readiness can be claimed.

## 2026-07-21T08:49:51+03:00 - Stale Verify dependency in Solution Quality

The refreshed precheck file has SHA-256
`35030714265096b5ec893c1f4cee6916fd636bf0d56d23e2579877dcb670c145`. Test Fairness now passes.
Solution Quality fails for no independently identified production behavior: it consumes the stale
Verify Solution testcase inventory, which still expects
`featureStateNamesAndMultipleAttributesRemainIndependent`. That identifier belonged to the prior
unfair collision scenario. The current fair replacement is
`multipleSeedableLazyAttributesRemainIndependent`, and the exact local focused XML contains that
test among 9 tests with 0 failures and 0 errors.

The evidence is internally conclusive:

- Verify Solution is explicitly marked stale and retains the earlier 667.710175-second result.
- Its fail-to-pass list contains the removed method identifier.
- The same stale block reports `newTestsPassed: true`, 9 of 9 focused tests passing, then fails only
  with `harbor_oracle_failed` and `RuntimeError`.
- Solution Quality says the executed 9 tests passed and names only the synthesized missing old
  identifier as its comprehensiveness blocker.
- Its code-quality score is reduced only because of that alleged hidden-test gap; it identifies no
  dead code, fragile mechanism, style violation, or concrete incorrect production path.

The two new Test Fairness coverage suggestions were audited without changing the canonical test
patch. Generated immutable `copyOf` deliberately returns an already-generated immutable instance
unchanged. Builder and Modifiable transfer templates first test explicit-seed provenance, then use
the whole-value initializer/setter for optionals and arrays; `Optional.empty()` and zero-length
arrays are therefore transferred as explicit values rather than treated as absent. These advisory
probes would be redundant with the architecture already exercised and are not evidence of a
solution defect.

No description, test, or solution change was made in response to this report. Renaming the fair
test back to satisfy a stale expected-test list would preserve obsolete platform state rather than
repair the task. The required order when the service recovers is: run Verify Solution against the
current artifacts, confirm its fail-to-pass inventory contains the replacement method and the
Harbor oracle completes, then rerun Solution Quality.

Current submitted-artifact hashes observed during this diagnosis:

- Dockerfile: `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c`.
- Description: `347a85d090766ce037828501afb08d8ca082960eb4890207ffb752a55e54d2f0`.
- Test patch: `4afbd8cfe88367330a37f668338408264887e65d85f1ee7e4fbf9e71d43697d8`.
- Solution patch: `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.

The two description suggestions remain nonblocking. The proposed removals would erase explicit
anchors for cold identity operations and Modifiable reset/conversion behavior that the fairness
report itself traces to the prompt, so they are intentionally not applied during this stale-result
round.

## 2026-07-22T01:35:12+03:00 - v1 zero-pass checkpoint and targeted solvability repair

The first agent population produced 0/17 legitimate passes across 10 Nova, 6 Orion, and 1 Vega
runs. Fifteen candidates passed the baseline, while every candidate failed the focused suite.
Verdicts were 12 `FAIL_INTEGRATION_ERROR`, 3 `FAIL_MISSED_REQUIREMENT`, 1 `FAIL_SYNTAX_ERROR`,
and 1 `FAIL_REGRESSION`. Candidate patches changed 340-946 effective lines across 7-13 files, so
the result reflects processor-integration failures rather than non-engagement.

Trajectory and patch analysis identified one dominant first failure in ten runs, including four
of six Orion runs. These candidates generally implemented separate explicit-seed state but copied
a recorded seed by calling the public hybrid accessor. A legal accessor that declares a checked
exception then makes generated transfer or Modifiable code uncompilable. Agents 3, 10, 14, 15,
and 16 were especially close architectural solvers censored by this decision. Other candidates
remain separated by collection overloads, Modifiable reset/state, no-`from` style handling,
representation errors, or agent-authored syntax/regression defects.

The complete first-round state, including all 17 run bundles and the new calibration plan, was
committed as `a7cabac` and tagged `v1`. `commit-message.txt` and `task-prompt.md` were excluded as
requested.

The v2 working state changes only the description's generated-transfer paragraph. It now states
that seed transfer does not invoke the hybrid accessor even when it declares checked exceptions,
that generated accessors retain declared exceptions, and that copying from arbitrary external
implementations leaves the hybrid attribute unseeded without reading its getter. This is a public
behavior clarification already enforced by the checked-exception fixture and reference solution;
it does not expose a field, bitmap, helper, template, or algorithm.

Lightweight post-edit evidence:

- Description SHA-256: `4c887cbd87d90af4ea2fa0790c4bd541e44d7843aedc50f918ee0ddbb101596f`
  (261 words).
- Test patch unchanged: `4afbd8cfe88367330a37f668338408264887e65d85f1ee7e4fbf9e71d43697d8`.
- Solution patch unchanged: `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.
- Dockerfile unchanged: `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c0`.
- Base file: `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.
- Task prompt: `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`.
- Exact v1 deliverable diff inspected and `git diff --check` passed.

No Maven, Docker, Codespace, four-state verification, or historical-candidate replay was run.
Those heavy checks would only reconfirm byte-identical implementation artifacts. The next useful
evidence is a fresh mixed platform population. Submission still requires a legitimate pass rate
greater than 0% and no more than 40%, followed by false-positive evaluation of every passer.

## 2026-07-22T02:28:34+03:00 - Submitted-v2 precheck fairness repair

The platform verified both tests and the reference solution for the submitted v2 state. The new
precheck report, SHA-256
`b8b40ca5896976ec582ba9e6d18aca044f60c34537a32a57c691a56c4b8831c5`, nevertheless blocked Test
Fairness with one unfair-test class. Multiple assertions required the exact numeric or string
result of initializer bodies that exist only in hidden fixtures. The lifecycle semantics were
stated, but values such as counter-derived numbers and private fallback labels were not part of
the public contract. The report also suggested builder `isSet` and array-wither coverage, warned
about the versioned value-processor JAR path, and requested removal of redundant exception prose.

The repair sweeps the entire unfair assertion class. Cold and computed fallbacks are now captured
from the public getter and compared only for memoization or seed preservation. Invocation counters
prove whether an initializer stayed cold, retried, recomputed, or reset after serialization.
Exact assertions remain only for values explicitly supplied by the test through a builder,
with-method, or Modifiable setter. This preserves the same lifecycle discrimination without making
hidden fixture literals part of the solver contract.

One advisory identified a real distinct branch and was closed inside the existing wither lifecycle
test. An array fallback is captured, passed back through the generated array with-method, and then
preserved while another attribute changes without another initializer call. The builder `isSet`
suggestion was not added: the description does not promise a public builder-state API, while build
and clear already exercise its internal bookkeeping.

The negative-compilation harness now discovers non-classifier `value-*.jar` artifacts after the
reactor build and requires exactly one main processor JAR. It no longer assumes the repository
version is `2.12.3-SNAPSHOT`. The Dockerfile's unused Maven-wrapper version probe was removed so
the image and runtime harness consistently use system Maven. Target cleanup remains intentional:
reactor artifacts are installed in `/opt/m2`, while workspace targets are deleted to prevent stale
generated classes from masking a candidate patch.

The description retains the dominant solvability clarification—generated transfers do not call
the hybrid accessor—but removes separate checked-exception wording and replaces the broad
Modifiable summary with direct unseeded/set/unset/clear behavior. The equality/rendering and
diagnostic clauses were also compressed without dropping their tested contracts. The reference
solution remains byte-identical.

Current hashes:

- Description: `08c27375e837a494b9f685c9c136ba0c7fac6f83c9d1fadbe09058604f1d55e7`
  (233 words).
- Test patch: `9d0c03022c50aa1fbb8f93226492ed46c45ecb42ed53e6878cb59be7340a89f5`.
- Solution patch: `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.
- Dockerfile: `d4631cd6ba874efecee7f56b2230f8d7bdc671f23792879dace6df765e46a767`.
- Base file: `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.
- Task prompt: `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`.

Lightweight validation passed: both patches apply independently at the exact base with strict
whitespace checking; the combined test-plus-solution state applies cleanly in a disposable
worktree; `test.sh` is executable and passes `bash -n`; changed new-file blob headers match their
contents; the combined source diff and task working tree pass `git diff --check`; and no exact
hidden fallback output remains in a test assertion.
No Maven, Docker, Codespace, or four-state run was performed. The next gate is fresh prechecks on
these hashes, followed by a mixed agent population only after fairness is green.

## 2026-07-22T07:10:00+03:00 - v2 second zero-pass checkpoint

The refreshed state passed platform Verify Tests, Verify Solution, and Test Fairness, then produced
0/20 legitimate solutions across 10 Nova, 8 Orion, and 2 Vega runs. Verdicts are 12
`FAIL_INTEGRATION_ERROR`, 7 `FAIL_MISSED_REQUIREMENT`, and 1 `FAIL_TEST_BROKEN`. Nineteen candidates
passed all 326 baseline tests; run `rd70f1jnyb4dvrqw2qz8nmpw0x8b1ekj` never reached compilation
because concurrent verifier modes cleaned the same `value-fixture/target` tree and shared staged
sources/reports. That run is retained in the official 0/20 denominator but censored from difficulty
arithmetic.

Twelve of the 19 usable candidates hit checked-exception compatibility before the nine focused
methods could execute. Nova runs 5-7 and 10 generated an immutable or Modifiable call without a
compatible throws boundary; Orion runs 11 and 13-18 omitted the checked declaration from the
Modifiable override; Vega run 20 still called a checked hybrid accessor during `toBuilder`.
Independent families remain: Nova runs 2/4/8/9 lose standard collection overloads, runs 1/3/9 omit
Modifiable reset/state APIs, and Vega run 19 corrupts Optional representation. Candidate patches
change 7-16 files and 357-1256 LoC, so zero pass is not non-engagement.

Fresh reports for the exact submitted state:

- AI evaluation: `NEEDS_HINTS`, SHA-256
  `e20e93b56480cb7c8a85862d1c191a4446107271c1a5561d16dcd27c9b8aed03`.
- Prechecks: Test Fairness `PASS`, zero unfair tests and two advisory suggestions, SHA-256
  `71940dbdaa9fa143b2ad207d6bfe25cf09e4e914fb9daaa8a9ab6701ba162a7a`.
- Repo fit: `PASS` at high confidence, SHA-256
  `b5254b5a3c37241a9712ad3ec9bff3081c172c3c821ad30b54ce03b9ebdb724f`.

Submitted deliverable hashes remain description
`08c27375e837a494b9f685c9c136ba0c7fac6f83c9d1fadbe09058604f1d55e7`, tests
`9d0c03022c50aa1fbb8f93226492ed46c45ecb42ed53e6878cb59be7340a89f5`, solution
`7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`, Dockerfile
`d4631cd6ba874efecee7f56b2230f8d7bdc671f23792879dace6df765e46a767`, and base file
`70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.

The next execution has one calibration lever plus a mandatory deterministic-harness repair. The
harness will serialize base/new mutation. The description will explicitly preserve ordinary Lazy
retry and checked-throws compatibility, and will state that a style disabling builder `from` may
treat a non-immutable `copyOf` source as external. The reference and focused behavior suite remain
unchanged. If the next deterministic mixed batch is still 0%, no third hint is permitted; the task
must be reclassified as excessive breadth and coherently de-scoped.

## 2026-07-22T08:00:13+03:00 - Current-state `Modifiable.from` fairness clarification

The latest Test Fairness report for the current working submission flagged one unfair behavior.
The focused suite requires `Modifiable.from(...)` to transfer an explicit hybrid seed from a
generated immutable or modifiable source, while treating an unseeded generated source as absent so
it is not evaluated and does not establish or clear a destination seed. The description named
builder `from`, `toBuilder`, and `copyOf`, but did not explicitly include the distinct generated
`Modifiable.from(...)` API. Existing generator conventions made ordinary getter copying a
reasonable competing interpretation, so this was a real contract gap rather than a flaky check.

The description now states that observable transfer rule directly. This is a behavior-only
clarification: it exposes no field, bitmap, helper, template, or algorithm. No test was removed or
relaxed, no production solution byte changed, and none of the task's other required behavior was
altered. Consequently, this repair closes the reported fairness gap while preserving the current
difficulty surface; only a fresh agent population can measure any pass-rate effect.

Hashes after the repair:

- Description: `b3414cf23cbd51ac06d840ef763ced91e6ca84c4a76e9a082a61afc5dfa8f844`
  (260 words; pre-repair current-state hash
  `10d40ceecb74d8bbfdefebc127e47fb0358e3574b1b83c5171ae58b0da3909d4`).
- Test patch unchanged: `9120155dff6a0cffb79ea4288919fccd4e9ae2df97de64b37366ce87c69b8357`.
- Solution patch unchanged: `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.
- Dockerfile unchanged: `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c`.
- Base file unchanged: `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.
- Task prompt unchanged: `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`.
- Triggering precheck report: `5828731c9d5d77e16fe52d4a67c49d4d3f09eea85136233a578d4b54d91d550f`.

The two advisory coverage suggestions were not used to add tests or requirements in this repair.
They are outside the single fairness blocker and changing them now would add unnecessary
calibration risk.

Lightweight validation passed. The canonical test and solution patches apply independently and
together at exact base `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e` with strict whitespace
checking, and the description-plus-ledger diff passes `git diff --check`. No Maven, Docker,
Codespace, or fresh agent calibration was run because this repair changes only prose and the
append-only log. The next meaningful gate is a fresh Test Fairness run on the new description
hash; agent calibration should be repeated only after that gate is green.
