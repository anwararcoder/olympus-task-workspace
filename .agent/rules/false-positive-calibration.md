---
description: Calibrate solvability and false-positive safety from exact artifacts, candidate families, and contract-closure probes
---

# False-Positive and Solvability Calibration

Use this rule when designing a task, interpreting agent runs, recovering from a zero-pass round,
or preparing the final iteration after a false-positive review. It exists to stop the recurring
loop in which a change improves pass rate by admitting an incorrect solution, then a new test
closes that false positive and returns the task to zero pass.

The pre-submission work in section 4 is mandatory before the first external agent batch or
coverage check. Do not use a generative fairness panel as the task's test designer. No finite suite
can prove that no conceivable incorrect program will ever pass, and a generative reviewer can
always propose another permutation. The readiness standard is instead evidence-backed closure:
every promised decision point has a proof owner, every plausible repository-native wrong
architecture has been challenged, and no known fair discriminator remains open.

## 0. Required working product

Reading this rule is not compliance. Before saying that a task is covered, ready, or free of known
false positives, the authoring agent must produce a **false-positive closure packet** in the task's
internal ledger or planning material. It must contain:

1. The exact-state manifest from section 3.
2. A clause-to-decision-point contract matrix covering both the semantic core and integration
   shell.
3. A repository pipeline map naming independent producers, consumers, branches, and bypasses.
4. A wrong-implementation portfolio with executed mutation or candidate-replay evidence.
5. An advisory register that classifies every suggestion by stable failure class.
6. A vacuity audit for every negative, omission, disabled-state, and conditional assertion.
7. Four-state verification and regression evidence tied to the exact artifact hashes.
8. The signed readiness certificate in section 14, including any residual uncertainty.

The agent must read the complete description, test patch, solution patch, harness, reports, saved
candidate patches, and relevant repository implementation before filling this packet. Search
snippets, evaluator summaries, test names, and a correct golden are leads; none substitutes for
that reading.

Use strict evidence language:

- `covered` means a named proof owner rejects a named wrong architecture for the intended reason;
- `duplicate` means existing evidence kills the same decision-path failure class;
- `N/A` means a repository-grounded reason shows that the branch is absent or outside scope;
- `ready` means the section 14 certificate has no open fair survivor or stale required evidence.

Never add a test merely because a reviewer can describe another input, type, setting, or
permutation. Never dismiss one merely because it is advisory or the golden already behaves
correctly. First identify the implementation decision that could be wrong and prove whether the
current verification detects it.

## 1. Authority and scope

For a current normal Olympus task, the live numeric and panel authority is:

`Shipd - Olympus/my-review-workflow/rules/platform-panel.md`

As of its 2026-07-11 entry, the default Olympus bar is pass rate `<= 40%`, successful-run medians
of `>= 250` LOC, `>= 40` messages, and `>= 2` files, with at least one legitimate pass, no unfair
run, no environment blocker, and a required False Positive evaluation. Re-read that file before
every round. Older Diamond, Castor, Mars, or rollout documents remain historical or mode-specific;
they control only when the current task panel explicitly selects that mode.

Use these sources in this order when they disagree:

1. Current task deliverables and exact run artifacts.
2. The current criteria panel and `my-review-workflow/rules/platform-panel.md`.
3. Current human feedback and explicit maintainer evidence.
4. Auto-review, AI evaluation, prechecks, and false-positive reports, after checking freshness.
5. Historical workflow documents and accepted examples, for lessons rather than current numbers.

A green platform check is evidence for the state it evaluated. It is not proof that a later dirty
working tree, an untested contract class, or a different platform mode is safe.

## 2. Keep the gates separate

Do not optimize a single score. A submission must satisfy independent questions:

| Question | What it measures | Typical failure |
| --- | --- | --- |
| Solvability | Can at least one capable agent implement the stated task? | Zero legitimate passes |
| Difficulty | Do enough agents still fail for substantive reasons? | Pass rate above the live bar |
| False-positive safety | Does every counted passer satisfy the whole stated contract? | A passing patch has a fair discriminator |
| Reference correctness | Does the golden implement every stated behavior? | Candidate and reference both fail, or golden contradicts prose |
| Test quality | Does the suite reject wrong behavior without hidden requirements? | Conditional, weak, or over-pinned assertions |
| Fairness | Could a faithful alternative infer and satisfy every tested behavior? | Undiscoverable or unspecified edge |
| Repository fit | Is this feature welcome and native to the upstream seam? | Explicit maintainer rejection or foreign design |

Changing one axis does not clear another. In particular:

- A low pass rate does not excuse a false positive.
- A passed False Positive evaluation does not override solution, test, human-review, or repo-fit
  blockers.
- A correct golden does not make an unstated hidden assertion fair.
- A high-quality candidate is not a legitimate pass if one fair, stated behavior is wrong.
- A task with an explicitly rejected core seam must be replaced, not calibrated harder.

## 3. Freeze an exact round manifest

Before drawing conclusions, create a round manifest in the task ledger or handoff. Record:

- task path, current commit/tag, HEAD SHA, and `git status --short`;
- SHA-256 for description, test patch, solution patch, Dockerfile, and base-commit file;
- timestamp and SHA-256 for auto-review, AI evaluation, prechecks, false-positive evaluation, and
  human-review files;
- saved run ID, actual model tier, evaluation verdict, baseline/focused XML totals, patch hash, and
  trajectory availability for every run used;
- which evidence belongs to a tag and which belongs only to the current dirty working tree;
- which remote verification output belongs to this exact patch set.

Never equate "latest tag" with "current task." A dirty working tree can contain the actual repair
while every summary document still describes the tagged submission. Run directories can be
renumbered, overwritten, or partially downloaded; identify runs by platform run ID and tier, not
by folder number. AI-evaluation denominators can include platform runs that were not saved locally,
so state both counts when they differ.

If a task is finalized and waiting for manager approval, freeze it. Do not improve, restyle, or
recalibrate it unless manager feedback explicitly reopens the task.

## 4. Build the contract-closure matrix first

Translate every description clause into a matrix before changing prose or tests:

| Clause or invariant | Dimensions and decision points | Positive and negative controls | Plausible wrong architecture | Proof mode and exact evidence | Fairness source | Status |
| --- | --- | --- | --- | --- | --- | --- |
| Example: every generated form round-trips | builder/constructor; default/non-default | supported instance keeps state; unreconstructable shape gets no partial form | decodes an attribute but discards it | focused test names plus executed mutation | exact prompt clause and existing construction APIs | missing non-default constructor case |

The matrix is complete only when each required equivalence class has both permission and rejection
evidence where appropriate. Pay special attention to universal or negative words such as `all`,
`every`, `any`, `other`, `none`, `never`, and `neither`: they create a class of obligations, not
one example.

Enumerate relevant branch pairs:

- present/absent and default/non-default;
- eligible/ineligible and generated/not generated;
- builder/constructor/copy construction paths;
- scalar/container, key/value/element, and top-level/nested positions;
- success/failure and exact failure category;
- direct/inherited and static/instance only when the description makes that distinction;
- old/new schema direction where compatibility is bidirectional;
- empty/null/missing/malformed when those are real repository values.

Do not create a Cartesian product of exotic possibilities. Cross dimensions only when the
description promises them, the repository exposes them, or a plausible implementation architecture
makes the interaction dangerous. The goal is contract closure, not novelty.

Fixture presence is not branch coverage. A fixture named "constructor default" proves nothing if
the assertion only uses the default value, permits the API to be absent, or never executes the
reconstruction branch.

Complete this matrix in the task ledger or another internal authoring document. Do not copy its
coverage explanations, hidden-test inventory, implementation hints, evaluator terminology, or
internal project names into the task description or other user-facing deliverables.

### 4.1 Audit both the semantic core and the integration shell

A feature can be semantically correct when invoked through a test fixture and still be unusable,
partially gated, or incompatible through the repository's normal path. Inventory both rings before
writing the final tests:

| Ring | Required questions |
| --- | --- |
| Semantic core | What is accepted, rejected, retained, omitted, transformed, or preserved? What are the identity, scope, ordering, closure, error, and stability rules? |
| Integration shell | How is the feature discovered, configured, defaulted, parsed, invoked, propagated, disabled, and combined with adjacent settings? Which existing writers, readers, lifecycle paths, and output positions can bypass it? |

For the semantic core, explicitly consider when applicable:

- positive behavior and the load-bearing negative behavior;
- exact identity versus same-name collisions, aliases, overloads, or descriptors;
- direct versus transitive behavior and termination on cycles;
- live versus omitted, dead, failed, filtered, or rolled-back producers;
- top-level, nested, inherited, callback, asynchronous, and re-entrant scopes;
- ordering, determinism, idempotence, and repeated-context behavior;
- code or structured data versus comments, literals, metadata, or other lookalikes.

For the integration shell, explicitly consider when applicable:

- public registration and discovery through the repository's normal existing API;
- exact public key or spelling, type metadata, default value, and supported shorthand;
- absent, explicitly disabled, and enabled behavior;
- partial gating across every independent production consumer or writer;
- interaction with pre-existing removal, reconstruction, compatibility, strictness, or lifecycle
  controls;
- backward compatibility through the real existing regression suite;
- separate contexts, caches, retries, resets, serialization boundaries, and plugin boundaries.

Mark a row `N/A` only with a repository-grounded reason. Do not turn this list into a Cartesian
product. Cross two dimensions when the contract promises their combination, the repository has a
separate branch for it, or a plausible wrong architecture can implement each independently while
missing their interaction.

#### Mandatory decision-path kernel

For each feature, walk this kernel once. It is a branch inventory, not an instruction to create a
test for every cell. Give each applicable row a proof owner; justify the others as `N/A`.

| Failure class | Question that must be answered | Typical sufficient proof |
| --- | --- | --- |
| Public-surface bypass | Could a raw map, fixture, reflection call, or internal helper work while registration, metadata, exact spelling, defaulting, or normal parsing is missing? | One public integration test through a base-existing discovery/invocation API, plus default evidence |
| Disabled/default drift | Are absent and explicitly disabled behavior unchanged from the actual base, rather than merely equal to each other after both drift? | Candidate regression suite against base behavior; focused comparison only when it reaches an independent writer |
| Eligibility boundary | Can a broad category check accept or reject the wrong entity, type, direction, scope, or lifecycle state? | Positive and negative boundary controls that kill the broad classifier |
| Semantic identity | Can text, token, or simple-name matching confuse overloads, descriptors, shadowing, aliases, another owner, comments, literals, or metadata? | The smallest realistic collision that kills the name-based architecture |
| Propagation and closure | Can a one-hop implementation miss a live transitive dependency, loop forever on a cycle, or allow omitted/dead/failed code to seed the result? | Positive transitive case, cycle termination, and omitted/dead-origin negative case when those are distinct branches |
| Independent producers or consumers | Do fields, methods, nested forms, writers, readers, directions, or output positions use separate repository branches? | One representative per independent implementation site, not per cosmetic kind |
| Phase ordering | Could correct logic run before reconstruction/filtering/rollback or after the output-defining phase and pass the happy path? | A case whose observable changes across the two phases, backed by pipeline trace |
| Adjacent-setting interaction | Can an existing removal, reconstruction, strictness, or lifecycle control bypass or override the new decision? | Paired settings only when repository code or a mutation shows an independent interaction branch |
| State isolation | Can caches or mutable state leak across contexts, runs, retries, tenants, or processes? | Sequential isolation/reset case at each real state boundary |
| Error and fallback integrity | Can a partial result, swallowed failure, wrong error category, or side effect before validation pass? | Failure-path observable plus positive success control |

The kernel prevents two opposite mistakes. A public-registration check, an omitted-code seed, or a
same-name collision is a real gap when it admits a distinct cheap architecture. A second
reconstruction toggle, member kind, literal, or disabled example is repetition when it traverses
the same decision path and the same mutation is already killed. Repository control flow and
mutation evidence decide which it is; the reviewer's wording does not.

### 4.2 Trace the repository decision pipeline

Before declaring coverage, trace the feature from its public entry to its observable effect:

```text
registration/discovery -> parsing/defaulting -> eligibility -> transformation
-> propagation/lifecycle -> emission/persistence
```

Adapt the stages to the repository. Locate every independent producer, consumer, writer, reader,
callback, cache, and reset path that can affect the result. A call-site trace proves that code
runs; it does not prove that all promised scopes receive the effect.

For each stage, ask:

1. Can an implementation skip this stage and still pass the current tests?
2. Can it implement only one consumer, member kind, direction, or lifecycle path?
3. Can it execute in the wrong phase and accidentally pass the happy path?
4. Can a raw fixture injection bypass public registration, validation, or defaulting?
5. Does the repository expose a base-existing public discovery or execution API through which the
   requirement can be tested fairly?

Do not treat a generic parser accepting an arbitrary key as proof that an option is registered or
discoverable. Conversely, do not inspect annotations, constants, helper names, or map layout
directly when an existing public discovery API exposes the same contract behaviorally.

### 4.3 Assign the right proof mode

Every matrix row needs a named proof owner. Test coverage and verification coverage are related but
not identical:

| Proof mode | Use it for | Common mistake |
| --- | --- | --- |
| Focused behavioral test | Observable feature semantics and discriminators | Asserting source shape instead of behavior |
| Public integration test | Discovery, metadata, defaults, parsing, and normal invocation through base-existing APIs | Injecting a raw property and claiming public registration |
| Existing regression suite | Broad disabled/default compatibility and repository-wide invariants | Running it only on the golden, not on candidate states |
| Static/wiring audit | Dead hooks, all producers/consumers, and obligations with no fair behavioral surface | Treating golden inspection as protection against an incomplete candidate |
| Mutation or candidate replay | Proof that a plausible wrong architecture is actually rejected | Recording a compile failure that never exercised the invariant |
| Description and repository evidence | Fairness and discoverability of the requirement | Treating prose alone as proof that code behaves correctly |

A past full-suite pass by the golden proves only that golden hash. If disabled compatibility is a
universal requirement, the actual candidate verifier must run the relevant regression suite or a
representative discriminator must reject partial/default gating mistakes. A focused test that
compares option-absent with option-disabled output proves equality between those two states; it
does not prove either state still equals the repository baseline if both were changed.

Prefer a public behavioral proof whenever one exists. If an obligation can be checked only by
pinning golden internals, do not hide that pin in the tests. Either find a repository-native
observable, clarify or narrow the contract, or keep every otherwise-passing candidate provisional
until a manual solution audit establishes the obligation.

### 4.4 Execute a wrong-implementation portfolio

Before the first external agent batch or fairness check, build and run small, task-owned mutations
or candidate patches. The matrix's "plausible wrong architecture" column is not complete until its
important rows have executable evidence.

Consider each applicable family:

- no-op, conditional assertion, or API-absence escape hatch;
- always enabled, wrong default, or absent-versus-disabled conflation;
- semantics reachable through a raw fixture key but missing public discovery or normal invocation;
- only one writer, declaration kind, input position, direction, or lifecycle path implemented;
- special-casing the visible fixture, one value, one type, or one reconstruction;
- text/name/token matching instead of semantic identity;
- one-hop propagation instead of a fixed closure, or failure to terminate on cycles;
- dead, omitted, filtered, failed, or rolled-back state incorrectly seeding live behavior;
- broad category retention/rejection instead of per-entity decisions;
- adjacent settings ignored or allowed to override the new decision incorrectly;
- correct logic executed before or after the phase whose output defines the contract;
- shared state leaking across runs, contexts, tenants, processes, or retries;
- correct happy path with partial/corrupt fallback or the wrong error category.

For every mutation, record:

```text
Mutation or candidate patch/hash:
Repository-native wrong assumption:
Contract row violated:
Tests expected to kill it:
Observed command and result:
Why the failure proves that invariant:
Surviving sibling branches:
```

A test failing on the base revision does not prove false-positive resistance. The same test must
reject the plausible wrong implementation for the intended semantic reason. A mutation killed by
unrelated compilation, fixture setup, or a broad earlier assertion is not proof of the claimed
row. Any fair surviving mutation is an open gap: close its architectural class or narrow the
contract coherently before submitting.

### 4.5 Run a fresh-eyes challenger

After freezing the description and test patch, use a separate agent or fresh context when
available. Give it the base repository, description, tests, and test command, but do not explain
the golden architecture. Ask it to attack the suite:

```text
Find the smallest plausible repository-native incorrect implementation that passes this suite.
For every claimed gap, provide the exact contract clause, the wrong implementation family, why
the current assertions allow it, and the smallest fair behavioral discriminator. Do not propose
another input or setting unless it reaches a new decision point or lets a materially different
wrong architecture pass. Separately audit the semantic core and the public integration shell.
```

The authoring agent must reproduce each proposed survivor. A challenger suggestion is a lead, not
evidence. If another agent is unavailable, perform the same audit only after freezing the artifacts
and review the tests from the perspective of a solver trying to pass them cheaply; do not use the
golden's correctness as the answer.

### 4.6 Classify proposed gaps before editing

Generative reviewers are non-monotonic: after one case is added, another run may suggest a sibling
case, and the number of advisories can rise even as coverage improves. Split composite suggestions
into independent claims, then classify each claim:

| Classification | Required evidence | Action |
| --- | --- | --- |
| Confirmed contract gap | A fair clause, concrete wrong architecture, current-test evasion, and a reproducing discriminator | Close the whole failure class |
| Duplicate or indirectly covered | Existing test or mutation already kills the same wrong architecture | Record the exact evidence; do not add a permutation |
| Verification gap | Real obligation is proved only by full-suite, public-API, wiring, or manual audit evidence | Strengthen the correct proof path, not necessarily the focused tests |
| Unfair or out of scope | No discoverable contract basis, or behavior contradicts the stated boundary | Reject it and preserve the boundary |
| Invalid or unstable probe | Golden also fails, fixture is invalid, parser path is non-discriminating, or result is flaky | Repair/reproduce before drawing conclusions |

Use these questions in order:

1. What exact observable invariant would the proposal protect?
2. What concrete wrong patch can pass now?
3. Does it exercise a new repository decision point or merely another value at a covered point?
4. Which existing assertion or mutation does that wrong patch evade?
5. Can the behavior be tested through a base-existing public surface?
6. What positive control prevents solving it by disabling or rejecting the feature?

Do not label an advisory "noise" merely because the golden is correct. The question is whether an
incomplete candidate can pass. Do not label it a gap merely because another example is imaginable.
The question is whether it exposes a new fair failure class.

Maintain an advisory register so later reviewers cannot restart an adjudicated class with new
wording:

```text
Advisory ID and exact wording:
Observable invariant:
Decision-path fingerprint: <component> -> <stage> -> <branch or bypass>
Plausible wrong architecture or candidate hash:
Current-test evasion:
Existing killer/proof owner, if any:
Classification and evidence:
Required action or justified no-change:
Reopen only if:
```

The decision-path fingerprint, not the suggested example, is the stable identity. Suggestions such
as "try another reconstruction," "try another declaration kind," or "compare more disabled
outputs" stay closed when they name no new branch and the recorded mutation is already rejected.
Reopen a closed entry only when new repository evidence reveals a separate branch, a concrete
candidate survives the existing proof, the prior probe was invalid, or the contract changed.

### 4.7 Apply a fairness gate to every discriminator

Before adding or keeping a hidden test, require all of the following:

- cite the exact description clause and, where inference is needed, the repository convention that
  makes the behavior discoverable;
- assert observable behavior through base-existing symbols where possible;
- allow faithful alternative architectures and avoid golden-only names, helpers, ordering, or
  storage layout;
- include a positive control and a load-bearing negative control where the invariant has both
  directions;
- prove that the base fails for the intended missing behavior and the golden passes;
- prove that the targeted wrong mutation or candidate fails for the intended reason;
- check determinism, fixture validity, and isolation from stale build or shared cache state;
- avoid over-broad claims: a representative case proves a decision path, not every untested
  permutation of that path.

Audit vacuity separately. For every assertion that expects absence, omission, no change, disabled
behavior, or a conditional result, prove all applicable preconditions:

- the fixture really contains the entity or state whose removal, retention, transformation, or
  non-effect is under test;
- the comparison mode actually activates the adjacent setting, marker, reconstruction, failure,
  or lifecycle branch named by the test;
- a positive control proves the harness can observe the entity or behavior;
- the assertion would fail if the feature were globally disabled, the fixture were empty, the
  marker were never emitted, or the relevant branch never ran;
- a conditional assertion cannot silently skip because a solution API, generated artifact, or
  setup precondition is absent.

For example, a marker-comment test must establish that the marker is emitted before using its text
as a non-reference; an omission test must establish that the declaration would otherwise be
eligible; and absent-versus-disabled equality needs separate base-compatibility evidence. These
controls may share a fixture or assertion, but their evidence must be explicit in the matrix.

Public integration is fair to test when the description promises a user-facing facility and the
base repository exposes a conventional discovery or invocation API. Test through that API. Merely
requiring the golden's new constant, annotation, helper, or internal map shape is not fair unless
that exact interface is itself an explicit and repository-native public contract.

Run the clause-to-test audit in both directions after every change: every tested behavior must be
discoverable from the contract, and every mandatory contract behavior must have a proof owner.

### 4.8 First-submission saturation gate

Do not send the first external batch or call the task coverage-complete until:

- every semantic-core and integration-shell row is covered or has a justified `N/A`;
- every applicable decision-path-kernel row has a named proof owner and every `N/A` cites
  repository evidence;
- every universal clause has representative evidence across its independent implementation sites,
  not merely several inputs routed through one site;
- every proof owner names an exact test, regression command, audit, or replay;
- every high-risk wrong architecture has an executed mutation or candidate result;
- no fair mutation survives;
- the fresh-eyes challenger has produced no unreproduced new architecture family;
- every proposed extra case has been classified under section 4.6;
- the advisory register has no open item and no duplicate lacks its exact existing killer;
- the vacuity audit proves every negative, omission, disabled-state, and conditional assertion can
  fail for the intended reason;
- the reverse fairness audit finds no hidden requirement or implementation pin;
- base, golden, focused, disabled/default, and applicable regression states are verified on the
  exact artifact hashes;
- no task-specific validation, naive-solver, red-team, or mutation gate remains marked incomplete.

Saturation means no known unowned failure class, not zero advisory suggestions. Do not rerun a
generative check merely to sample a more pleasing advisory count. After submission, a genuinely new
candidate architecture or fair discriminator reopens the relevant matrix row; a rephrased sibling
suggestion does not.

## 5. Build the run-family matrix

Raw pass counts hide architecture. For each run, record:

| Run ID | Tier | Architecture family | Baseline/focused result | First wrong turn | Contract-grounded failure? | Replay role |
| --- | --- | --- | --- | --- | --- | --- |
| `<id>` | Nova/Orion/Vega/Castor | concise implementation description | exact XML totals | trajectory step or patch site | yes/no/unclear | passer, near-solver, mutation, or FP candidate |

For this workspace, capability generally rises `Nova < Orion < Vega < Castor`. Treat that ordering
as calibration context, not a verdict shortcut. Batch composition matters: `3/10` from ten Nova
runs is not interchangeable with `3/10` from a stronger mixed batch. Report per-tier results and
the mix before comparing rounds.

Cluster patches by their first architectural commitment, not by their final failing test. Examples:
eligibility gating, reconstruction strategy, query-rendering strategy, type classification, or
equality semantics. Several failing tests produced by one commitment are one failure class. One
test that catches several unrelated architectures is not one class.

Candidate final messages and evaluator summaries are leads. The candidate patch, generated code,
test logs, and exact XML are evidence. A passing run remains provisional until its patch survives
contract review and fair adversarial probes.

## 6. Adjudicate every false-positive probe in four states

Run each proposed discriminator against the exact candidate and exact golden in isolated states:

| Candidate | Golden | Classification | Action |
| --- | --- | --- | --- |
| Fails | Passes | Confirmed false positive, if the probe is fair | Close the violated contract class |
| Fails | Fails | Spec/reference gap or unfair probe | Choose the intended contract, then fix prose/golden/tests together |
| Passes | Fails | Golden defect or candidate improvement | Repair the golden; do not punish the candidate |
| Passes | Passes | Non-discriminating probe | Do not add it as FP evidence |

Fairness is evaluated independently. A candidate-only failure is not a valid false positive when
the behavior is unstated, contradicts another clause, or relies on a pathological edge outside the
promised surface. Conversely, a broad substantive implementation is still a false positive when
one fair discriminator proves a universal clause is violated.

Keep exact probe source, logs, candidate patch hash, golden patch hash, base SHA, and environment
identity. Shared Maven repositories, build trees, and generated sources can make a probe execute
the wrong processor or stale class. An unisolated discriminator is not final evidence.

## 7. Close a failure class, not one witnessed instance

When a fair false positive is confirmed:

1. Name the violated invariant in observable language.
2. Identify the candidate's architectural cause.
3. Enumerate sibling branches reachable through that cause.
4. Select the smallest realistic representative set that covers the class.
5. Add a positive control so the fix cannot simply disable the feature.
6. Make the golden pass and the base fail for the intended reason.
7. Prove a targeted wrong mutation or the exact candidate patch is newly rejected.
8. Replay known legitimate passers and nearest solvers to detect accidental difficulty jumps.
9. Update the matrix, ledger, and all now-stale platform checks.

"One lever per round" means one diagnosis or defect class, not necessarily one assertion or one
file. A class-closing change may require coordinated description, golden, fixture, and assertion
updates. Splitting those dependent edits across rounds creates known inconsistent states and wastes
platform batches.

Never delete a valid discriminator merely to make its false-positive candidate pass. Either repair
the underlying production architecture, coherently narrow the promised capability, or accept that
this candidate is not the solvability anchor.

An accepted historical task is a calibration example, not an exhaustive modern oracle. Re-run its
architectural invariants against the current false-positive standard before copying its test shape.

## 8. Zero-pass decision tree

Zero pass is a symptom. Do not default to a hint.

### A. Signal or harness defect

Evidence: missing verdicts, test-jar or fixture packaging skipped, wrong test mode, shared build
contamination, environment failures, or baseline regressions caused by the task.

Action: fix infrastructure, rerun the same contract, and discard censored runs from difficulty
calibration. A hint cannot repair a verifier.

### B. One dominant discoverability blocker

Evidence: several runs chose the right architecture and stop at the same local, stated behavior;
at least one near-solver has no unrelated regression.

Action: add one short behavioral clarification or formal hint if the current platform permits it.
Do not name internal helpers or prescribe an algorithm. Replay the near-solver and then run a fresh
mixed batch.

### C. Too many independent fair blockers

Evidence: many individually reasonable cells fail at moderate rates, but their conjunction makes
the probability of a full pass near zero. There is no single nearest-solver gap.

Action: remove one coherent capability island across description, tests, and golden. Preserve the
task's core architectural challenge and keep a positive control at the new boundary. Deleting
isolated difficult assertions while leaving their promise in prose is forbidden.

### D. Golden or contract defect

Evidence: the golden fails a stated behavior, candidate and golden fail a fair probe, or tests
conditionally allow the golden to omit an API the prose requires.

Action: decide the contract first, then align prose, tests, and golden in the same round. Difficulty
numbers from the defective round do not establish readiness.

### E. Rejected or foreign repository seam

Evidence: explicit maintainer refusal, an already-solved feature, or a design that bypasses the
repository's normal mechanism.

Action: stop. Archive the task or replace the core domain. Do not spend another agent batch trying
to make a rejected idea statistically acceptable.

Use breadth arithmetic before editing. If eight independent hard cells each have a 60% chance of
being solved, their conjunction is roughly `0.6^8`, or 1.7%. Improving one cell rarely moves a
zero-pass batch into a stable solvable band.

## 9. Safe de-scope protocol

De-scope only when the task has excessive independent breadth or a capability cannot be made fair.

1. Name the capability island being removed.
2. Remove or narrow its description clauses.
3. Remove only tests whose sole purpose is that island.
4. Remove golden code that exists solely for it, unless harmless repository structure requires it.
5. Re-run the clause-to-test and test-to-clause audit in both directions.
6. Keep boundary tests proving the remaining feature is neither silently disabled nor broadened
   into a partial/corrupt form.
7. Replay false-positive candidates, legitimate passers, and near-solvers.

Prefer wording such as "outside the required surface" when an implementation may safely support
more. Do not say a type "must not" receive an API when the golden intentionally supports it. The
description defines the required contract; it must not be reverse-engineered around one golden
implementation merely to make the check green.

## 10. Read the platform reports together

### False Positive evaluation

- `PASSED` is necessary evidence, not proof that every equivalence class was explored.
- `PASSED_WITH_WARNINGS` requires independent review of every dissent and adjudicator tag.
- `SPEC_GAP_REFERENCE_ALSO_FAILS` is a golden/description lead even when the overall result passes.
- `FAILED` requires reproducing the discriminator before editing.
- Platform mechanics (official): the check covers the passing runs that exist when triggered, and a
  single pass judged false fails the "No false positives" criterion. Trigger it only after the run
  set is settled; any edit stales it. The fix for a confirmed FP is stronger tests, plus a
  description check so the new assertions stay discoverable.
- The check rebuilds each solution from the agent's patch and skips folders named `build`, `dist`,
  `target`, `node_modules`, `__pycache__`, or `.venv`. If real repository source lives under such a
  name, list its full path under **Protected source folders** before running, or an incomplete
  rebuilt solution can read as a false positive. Rule this out before adjudicating any FP finding.

### Auto-review

Read gate, description, tests, solution, agents, and synthesis separately. A good pass rate and a
substantive agent band do not cancel a band-0 golden. Conditional assertions, API-absence escape
hatches, and incomplete cross-position compatibility tests are common ways a suite passes while
the contract remains open.

### AI evaluation

Use it to locate run clusters and stated readiness, but verify its denominator, freshness, and
source artifacts. A current dirty patch can invalidate its conclusion without changing the file.

### Human review

Human feedback can identify a repository-native regression or contract ambiguity missed by both
panels. Resolve each requested action at the defect-class level. Approval freezes a finalist; it
does not become historical acceptance until the manager finalizes it.

### Repository fit

Check current issues, pull requests, maintainer comments, upstream HEAD, and existing design seams.
This gate can reject a technically excellent task before agent runs. Do it early.

## 11. Stop rules

Pause another platform iteration and perform a class audit when any of these holds:

- the same architectural false-positive class returns across three rounds;
- two rounds changed symptoms but not the conjunction breadth;
- the current reports describe different file hashes or tags;
- a single wall or harness defect dominates all failures;
- the golden and description disagree on which forms are supported;
- explicit upstream evidence rejects the requested core behavior;
- the task is finalized and awaiting manager action.

Iteration count is not evidence of progress. A new version is justified only by a new tested
hypothesis and a coherent expected effect on named run families.

Advisory count is not evidence of progress either. Generative coverage suggestions are not a
cumulative checklist: a later run can omit an earlier idea, rephrase an already adjudicated class,
or invent a new permutation. Preserve the section 4.6 classification and its evidence in the
ledger. Reopen the task only for a new fair invariant, a concrete surviving wrong architecture, or
proof that the earlier evidence was invalid.

## 12. Remote verification and concurrent-agent safety

Read `Shipd - Olympus/standards/HYBRID-CLOUD-WORKFLOW.md` before any expensive verification.
Analysis, editing, history, patches, reviews, and durable evidence remain local. Docker builds,
four-state verification, and special reproductions run on an explicitly selected remote forge.

When several agents or chats are active:

- assign one owner per task and one exact patch manifest per run;
- inspect the chosen forge before starting and use the other forge if occupied;
- never share a mutable checkout, generated-source directory, Maven repository, container name, or
  output directory between candidate and golden probes;
- use task- and run-specific namespaces for worktrees, images, containers, caches, and output;
- do not clean, stop, prune, reset, or overwrite resources owned by another task;
- check disk before heavy work and remove only the current task's disposable artifacts;
- stop a forge only after confirming no other container is active;
- copy XML, probe source, logs, and hashes back to the local task directory.

Do not run heavy local builds merely because a remote forge is occupied. Wait, select the other
authorized forge, or continue read-only analysis.

## 13. Fork-ready finalization brief

Before forking a chat to finalize one task, write or refresh this brief:

```text
Task and exact state:
Current tag/HEAD/dirty files:
Deliverable hashes:
Fresh reports and their hashes:
Superseded or stale reports:
Current panel mode and numeric authority:
Pre-submission semantic-core and integration-shell closure:
Mutation portfolio and surviving families:
Fresh-eyes challenger findings and reproductions:
Pass rate by tier and saved-run denominator:
Legitimate passers and architecture families:
Confirmed FP candidate/golden probe table:
Open contract-closure cells:
Auto-review blockers by band:
AI-evaluation blockers:
Human-review actions:
Upstream/repo-fit verdict:
Allowed next-iteration lever:
Forbidden shortcuts:
Replays and four-state verification required:
Checks that must be rerun after edits:
External final gate:
```

The finalizing agent should change only what the brief identifies, update all three contract
artifacts when needed, verify remotely, then rerun every stale platform check. "Locally ready"
and "platform accepted" are different states.

## 14. Reusable false-positive closure certificate

Complete this block from evidence before using the word `ready`:

```text
Exact state and deliverable hashes:
Contract version/frozen scope:

Semantic-core closure: PASS | BLOCKED
  Open rows or N/A justifications:
Integration-shell closure: PASS | BLOCKED
  Public surface, default/disabled, propagation, and adjacent-setting proof owners:
Repository decision pipeline:
  Independent producers/consumers/branches and evidence for each:

Vacuity audit: PASS | BLOCKED
  Negative/omission/conditional assertions and their positive controls:
Wrong-implementation portfolio: PASS | BLOCKED
  Mutation/candidate hashes, intended killers, observed results, surviving siblings:
Advisory register: CLOSED | OPEN
  Confirmed gaps, duplicates, verification gaps, rejected probes, reopen conditions:

Four-state and regression evidence:
  Commands, exact hashes, isolated environment, XML/log locations:
Fairness reverse trace: PASS | BLOCKED
  Every test -> clause; every mandatory clause -> proof owner; faithful alternative considered:
Solvability evidence: PASS | BLOCKED
  Legitimate current-state passer(s), tier mix, pass rate, nearest solver:
Freshness audit: PASS | BLOCKED
  Reports that match this state; explicitly stale reports:

Known residual uncertainty:
Readiness verdict: READY | BLOCKED
Blocking actions, if any:
```

`READY` means **no known fair false-positive architecture survives the executed portfolio**. It
does not claim mathematical proof over every conceivable program. Never hide missing evidence
behind `N/A`, `likely`, a green advisory panel, or the reference solution's correctness. If a row
cannot be tested fairly, name the manual/static proof owner or narrow the contract; if it has no
proof owner, the verdict is `BLOCKED`.

This certificate is reusable and must describe only the current task state. Historical task
diagnoses belong in their own ledgers, not in this rule, where they become stale instructions for
unrelated work.

## 15. Submission-ready exit gate

Do not call a task ready until all are true for the same hashed state:

- the section 14 closure certificate is complete and its verdict is `READY`;
- description, tests, and golden close the same contract matrix;
- the semantic-core and integration-shell audit has no unexplained row or missing proof owner;
- the mutation portfolio and fresh-eyes challenge leave no fair surviving wrong architecture;
- base plus tests passes, new plus tests fails for the intended behavior, and both golden states pass;
- universal compatibility claims are exercised against candidate states through the applicable
  regression suite or representative independent decision sites;
- at least one legitimate current-state passer exists and the pass rate meets the live panel;
- successful-run medians meet the live panel, with tier mix reported;
- every confirmed FP discriminator is closed and every warning independently adjudicated;
- auto-review, AI evaluation, prechecks, human actions, and required FP evaluation are fresh;
- no unresolved band-0/band-1, fairness, environment, or repo-fit blocker remains;
- remote artifacts and exact hashes are preserved locally;
- manager acceptance is reported only after it actually occurs.
