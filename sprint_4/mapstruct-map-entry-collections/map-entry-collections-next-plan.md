# Map Entry Collections Boundary Calibration Plan

**Goal:** Preserve the valid MapStruct #3580 feature while replacing the repeated 100% outcome with a replay-proven 4/10 boundary split, closing both confirmed false positives, and keeping the reference implementation unchanged.

**Decision:** The next lever is the method-family boundary around the new cross-container classification. A `Map` is treated as entry elements only when the other side is an `Iterable` or array; the change must not make `Stream` mappings eligible. This is an existing repository invariant and a central dispatch decision, not another container example. The second confirmed false positive, unsafe generated entry-local naming around `@Context` parameters, is closed in the same iteration as required verifier repair but is not counted as the difficulty lever.

**Execution boundary:** This plan is committed with the current evaluated round and tagged `v5` before implementation begins. After that checkpoint, keep this file and `commit-message.txt` unchanged. Record execution results in the append-only ledger and leave the final submission artifacts uncommitted on `v5`.

## Binding constraints

- Exact upstream base: `7ad5f9e56e9896c8f165d509b0cff8916061e85e` from `https://github.com/mapstruct/mapstruct.git`.
- Live Olympus bar: at least one legitimate pass, pass rate at or below 40%, successful-run medians of at least 250 LOC, 40 messages, and 2 files, with no unfair run, environment blocker, or false-positive failure.
- Preserve issue #3580's maintainer-authored Map-to-iterable and iterable-to-Map domain. Do not add a separate feature island.
- Use public mapper declarations and repository-standard compilation diagnostics. Do not inspect generated source text or require the reference's model/template architecture.
- Keep test and solution write sets disjoint, `test.sh` at mode `100755`, and all new fixture/test names collision-resistant with a fresh six-hex token.
- Keep editing, history, patch generation, and durable evidence local. Use one explicitly selected idle Codespace only after the exact bytes are stable; reuse its built image for candidate replay and do not touch another task's namespace.
- The current reference patch is the solvability anchor. Do not change it unless an approved new test unexpectedly proves a reference defect.

## Exact evaluated state before `v5`

- Git state: `HEAD=24e2574ad054c35d988af134867361e2fa06dd0c`, tag `v4`, with the post-v4 calibration and second platform batch in the working tree.
- Current deliverable hashes:
  - description: `30f440ab0a0aa265433a4e81f8387a9e42bae566adf6ff760a945a9ee8663570`
  - tests: `0245ff55f4f24e933b6c311f84bc7cc562a53a29c2254b6906dd0662d5b79741`
  - solution: `020784f03f8b68dfd491f64e5355f3a9c6b48f8106cc93ad42fc4f3d754263f8`
  - Dockerfile: `045350f5c216e79a809e6d2321458530e7ce13d8b367cc709b68a8c9dbb62cd3`
  - base metadata: `cebdef1e81bf8860e9bda579127a944d90132247dcc1fc87c524237435660548`
- Current report hashes:
  - AI evaluation: `89b28b04277d0b85899d37bc070989285428e80cf91ec49a3a5b108f74d49b9c`
  - false-positive evaluation: `8c1cfa95dd424f6616a19e6f6bf612ca337e233ac30f0a4c904e2d0603f13186`
  - prechecks: `4e63356723cacf0e3044d5b28709eacec1702a295c051682e455aea45b5d9ec7`
- The test patch has 14 logical processor tests, each under javac and Eclipse, for 28 focused invocations. The unchanged reference passes them.
- The second platform batch is ten Nova runs. All ten passed 3,641 reported baseline cases and all 28 focused invocations. Successful-run medians are 16.5 files, 131 messages, and 479.5 LOC.
- The AI evaluation is `TOO_EASY` solely because the nominal pass rate is 10/10.
- The required FP evaluation failed with two adjudicated false positives and eight genuine passes:
  - Nova 3 emits an unsafe entry local that collides with a legal `@Context` parameter.
  - Nova 9 weakens method retrieval so broadly that `Map -> Stream` compiles, discards its source, and returns an empty factory-created stream; clean and reference states reject it.
- Static review shows that the Stream regression is an architecture family, not one isolated candidate. Nova 1, 3, 5, 6, 9, and 10 use the same global Map exemption; Nova 2, 4, 7, and 8 use correctly paired Map/Iterable predicates.
- Issue #3580 remains open, feature-labelled, assigned to milestone 1.7.x, with no linked implementation. Remote `main` still resolves to the pinned base at this checkpoint.

The 3,553-case count in the local clean-room ledger and the 3,641-case count in the platform artifacts belong to different recorded harness executions. Do not combine them or claim a regression from the count alone; use exact run IDs and XML for each claim.

## Why both full platform rounds reached 100%

The first map-entry round at `v4` used 11 logical tests / 22 compiler invocations and produced 10/10 passes from eight Nova and two Orion runs. It required meaningful compiler work, but the recognition problem was one-dimensional: once a solver represented `Map<K,V>` as `Map.Entry<K,V>` elements, selection, qualifiers, conversions, bean properties, subtypes, inheritance, update targets, and null handling mostly reused existing MapStruct container machinery.

The post-v4 calibration added arrays and compatible lower-bounded results. Replaying the old saved candidates produced 3/10, which looked healthy, but that result did not predict a fresh population. The revised description explicitly named both new cells, and every fresh Nova trajectory deliberately implemented and tested arrays and lower bounds. The second full batch therefore returned to 10/10 at 28/28. The refinement turned omissions in old patches into a checklist for new solvers without adding a second architectural decision.

The current FP panel reveals the missing decision: several solvers enabled the desired pair by globally exempting any Map from MapStruct's iterable/non-iterable validation. The positive suite cannot distinguish that shortcut from a narrowly integrated implementation. Preserving the neighboring Stream family forces the classifier to express the exact allowed pair and catches six independently written broad architectures.

## Current run-family matrix

| Run | Run ID | Architecture | Boundary finding | Expected final result |
| --- | --- | --- | --- | --- |
| Nova 1 | `rd79z80pqv2a5njj571b6ev17x8awafg` | unified iterable path | global Map exemption admits Stream | fail |
| Nova 2 | `rd7be5xjyp0w1s87rqz61j38cd8awsxg` | dedicated reverse method | pairwise Map/Iterable guard | pass |
| Nova 3 | `rd7fyhy810e6f843vkrdr2mzkd8axdtj` | dedicated reverse method | global exemption and unsafe context-colliding local | fail |
| Nova 4 | `rd77avh0n1tw32t3jk6n29mpnx8axprg` | reused MapMappingMethod | pairwise guard and safe local | pass |
| Nova 5 | `rd70nssc0ecqbmzkhrjf8g2cyx8awb2z` | unified iterable path | global Map exemption admits Stream | fail |
| Nova 6 | `rd7fcrtfadcarp380mtpy16csx8aw5ka` | unified iterable path | global Map exemption admits Stream | fail |
| Nova 7 | `rd7401f1x8y35bxnhsdh71ymv18aw85g` | reused MapMappingMethod | pairwise guard | pass |
| Nova 8 | `rd78694r6gmbrw3bfhh8beq1rn8aw15a` | reused MapMappingMethod | pairwise guard | pass |
| Nova 9 | `rd7fd1yq0zgc0w5xmhs01e0m3s8awdyx` | compact unified path | reproduced Map-to-Stream regression | fail |
| Nova 10 | `rd7esq2qw88f9ddvbph5g1ft5n8aw1z1` | unified iterable path | global Map exemption admits Stream | fail |

Required exact replay: Nova 2, 4, 7, and 8 pass; the other six fail, for 4/10. A different result is a debugging signal, not a reason to add another discriminator.

## Contract-closure matrix

| Invariant | Positive control | Negative discriminator | Golden | Wrong family |
| --- | --- | --- | --- | --- |
| Map entries can feed Iterable/array results | existing list and array tests | none needed | passes | all current candidates pass |
| Iterable/array elements can feed Map results | existing list, array, qualifier, and bound tests | none needed | passes | all current candidates pass |
| Cross-container recognition is limited to the declared families | a new composite fixture also declares Map-to-Iterable and Iterable-to-Map methods | Map-to-Stream and Stream-to-Map retain repository diagnostics in that same compilation | narrow pairwise guard emits only the expected Stream diagnostics | clean base adds diagnostics for the unsupported positive methods; broad Map exemptions omit the Stream diagnostics |
| Generated locals remain legal around ordinary mapper parameters | existing reverse mapping | selected entry method consumes a deliberately colliding `@Context` parameter name | safe-name allocation passes | Nova 3 emits duplicate local |

The Stream behavior is already established by `ErroneousStreamMappingTest` and the base retrieval diagnostics, but a standalone negative test would also pass on the clean base and is therefore invalid as a new task test. The new processor test must compile positive Map/Iterable methods and the two negative Stream methods together: the clean base reports extra diagnostics for the unsupported feature, the reference reports exactly the established Stream diagnostics, and broad candidates incorrectly omit those diagnostics. Applicable object factories isolate the Stream classification gate so candidates cannot fail for an unrelated construction reason. The context test asserts a runtime key derived from the context value; it does not inspect the generated variable name.

## Rejected alternatives

- Do not add more Set, subtype, null-source, duplicate-key, or value-conversion examples. Current implementations already generalize those from the central loop.
- Do not add raw maps, null elements, direct `List<Map.Entry>` identity mapping, an element type literally named `Entry`, reverse forged-property qualifier propagation, or generic `<T> Map.Entry<T,T>` methods. The current reference shares or ambiguously scopes those gaps.
- Do not restore the object-factory-precedence probe. It was reference-green, but exact saved-candidate replay was 0/10, making that conjunction proven over-hard for this calibration rather than a useful 40% discriminator.
- Do not require a concrete Map.Entry implementation, entry mutability, generated-source shape, or arbitrary wildcard combinations.
- Do not add a hint or spell out internal predicates. The public contract already says Iterable or array, and Java Stream is neither; the repository has an explicit Stream mapping family and rejection tests.
- Do not treat description trimming as the difficulty lever. The 4/10 projection comes from exact candidate code, not hidden wording.
- Do not change production code pre-emptively. The reference already has the correct narrow guard and safe entry-local allocation.

## Execution plan

### 1. Create one isolated local editing snapshot

- Confirm `v5` and `HEAD` match and only `commit-message.txt` remains outside the checkpoint before new edits.
- Inspect the shared MapStruct checkout and existing worktrees; create a uniquely named detached worktree or temporary clone at the exact base without modifying the shared checkout.
- Apply the current test patch with `git apply --check` and `git apply --whitespace=error`.

### 2. Add a fail-to-pass method-family boundary regression

- Generate one fresh token with `openssl rand -hex 3` and use it in the new test and mapper type names.
- Add one repository-style erroneous mapper containing positive `Map<String,String> -> List<String>` and `List<String> -> Map<String,String>` feature methods together with both `Map<String,String> -> Stream<String>` and `Stream<String> -> Map<String,String>` methods.
- Add applicable Stream and Map object factories so broad candidates reach the retrieval/classification decision rather than an implementation-type error.
- Add one processor test expecting only the two established Stream diagnostics under javac and Eclipse. On the clean base, the positive methods must introduce unexpected feature diagnostics; on the reference, only the expected Stream diagnostics remain; on broad candidates, the expected Stream diagnostics disappear. Keep exact diagnostic text only because the base repository already treats it as a stable compilation contract.
- Add the new test class to `new` mode and exclude it alongside the existing task test from `base` mode.

### 3. Close the confirmed context-name false positive

- Add a randomized mapper whose iterable-to-map method has a `@Context` parameter named exactly like the unsafe candidate's derived entry local.
- Make the selected entry mapping consume that context and assert the resulting key/value through the public generated mapper API.
- Add the mapper to the existing test class and one logical runtime test. Expected total after Tasks 2-3: 16 logical tests / 32 compiler invocations.

### 4. Align prose and low-risk environment documentation

- Keep the core behavior, arrays, qualifiers, logical key/value properties, and lower-bounded result rule.
- Apply the precheck-requested conciseness cleanup by removing the exhaustive list of default framework integrations and the redundant null-strategy sentence. Retain the explicit normal mapping-method-selection and qualifier contract because it grounds the selected `@Context` entry mapping.
- Do not add a Stream implementation hint; the description's Iterable/array boundary remains exact.
- Add only the missing Java 21 rationale comments to the Dockerfile. Do not alter the working pinned JDK, Maven commands, dependencies, or image behavior merely to silence advisory warnings.

### 5. Regenerate and audit the canonical artifacts

- Regenerate `test-map-entry-collections.patch` from the exact base using intent-to-add for new files; do not hand-edit patch indices.
- Preserve `solution-map-entry-collections.patch` byte-for-byte unless the new reference check disproves the expected green state.
- Run lightweight local gates: independent/combined apply checks, whitespace and `git diff --check`, path disjointness, executable `test.sh`, ASCII, banned-token scan, new-test selector/exclusion audit, exact diagnostic line-number audit, and solution hash check. Audit every logical new test separately: each must fail on the clean base for the intended missing-feature reason and pass with the reference.
- Build a static replay matrix from all ten saved patches before using remote compute. Stop if the predicted broad/narrow split is not exact.

### 6. Run one decisive remote batch

- Read `standards/HYBRID-CLOUD-WORKFLOW.md`, inspect both mapped forges, and explicitly select one idle account. Do not start both.
- Run one final four-state verification after all bytes are stable. Do not run local Maven/Docker first and do not rebuild the immutable task image between candidate patches.
- Reuse only that immutable built image/cache. Give every clean, reference, and candidate probe a pristine run-specific worktree, container, build tree, and output path under one task-owned parent namespace; never carry generated sources or a patched checkout between probes.
- Preserve a concise per-state and per-candidate replay manifest with the exact source/base/patch/image hashes, commands, exit status, failing test names, relevant XML, and diagnostic/build log. This is durable reproducibility evidence, not ten redundant image builds.
- Required focused results: reference 32/32; candidates 2, 4, 7, and 8 at 32/32; candidates 1, 3, 5, 6, 9, and 10 fail the boundary test, with candidate 3 also expected to fail the context-collision test.
- Confirm no task container is running, copy evidence locally, remove only this task's disposable remote namespace/images if cleanup is needed, and stop the forge only if it is otherwise empty.

### 7. Final readiness audit

- Append exact hashes, token, path list, four-state outcomes, candidate matrix, selected forge/account, and cleanup state to the ledger.
- Recheck issue #3580, linked PRs, and remote `main` immediately before handoff.
- Reopen description, test patch, solution patch, Dockerfile, XML, and generated diff. Verify prompt-to-test, test-to-prompt, prompt-to-reference, and reference-to-prompt alignment.
- Report the result as locally verified and replay-calibrated. Do not claim a fresh platform pass rate, FP pass, human approval, or acceptance until those external checks run on the final hashes.

## Submission gate

The post-plan state is ready for a fresh platform round only when:

- `v5` is the immutable evaluated-round checkpoint;
- the reference solution hash remains `020784f...` and passes all 32 focused invocations;
- base/new behavior and the Stream diagnostics are correct under both compiler variants;
- exact saved-run replay is 4/10 with the named four survivors;
- both adjudicated FP defects are exercised, without adopting shared-reference or out-of-scope probes;
- all local patch, mode, disjointness, leakage, and lint checks pass;
- one final remote verification batch is preserved locally and its remote resources are handled safely;
- upstream issue #3580 remains open and unimplemented; and
- final submission artifacts remain uncommitted on tag `v5`, ready for fresh AI, precheck, FP, and human review.
