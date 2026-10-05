# Seedable Lazy Attributes v8 Solution-Correctness Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use
> `superpowers:systematic-debugging`, then `superpowers:test-driven-development`, and use
> `superpowers:executing-plans` only after the user approves this plan.

**Goal:** Correct the one confirmed reference-solution defect and close its matching verifier
hole while preserving the measured 1/15 legitimate pass rate and every currently green task gate.

**Architecture:** Keep the existing provenance-bit design. Change only the generated `copyOf`
fallback used when builder `from` is disabled so it distinguishes same-family generated
Modifiable sources from arbitrary external implementations. Add one focused regression for that
already-specified distinction; do not broaden the feature or adopt unrelated verifier-audit
proposals in this iteration.

**Tech stack:** Java, Immutables annotation-processor metadata and generator templates, Maven,
JUnit 5, and the existing shell verifier.

## Global constraints

- Base repository: `immutables/immutables`.
- Exact base commit: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`.
- Keep the task as a behavioral `feature_request`.
- Regular generated builders are in scope; strict and staged builders remain out of scope.
- Arbitrary external implementations must never have their hybrid getter probed.
- Generated immutable and Modifiable sources may expose generated provenance helpers.
- Do not weaken or remove a stated behavior to make the golden patch pass.
- Do not add a new requirement merely because a verifier suggests it.
- Do not modify `task-prompt.md` or `immutables-seedable-lazy-plan.md`.
- Use the hybrid-cloud workflow for authoritative build verification; avoid redundant local
  Maven, Docker, or Codespace runs.

---

## Checkpoint being recorded

- Prior checkpoint: tag `v7`, commit `5e7b6fd`.
- This document and the current downloaded platform evidence are intended for tag `v8`.
- Current description SHA-256:
  `f6951cb4a19d8253e1fe8bc4a86411cf3ccc3d64c6189ab26db12bf01fa4da48`.
- Current test patch SHA-256:
  `e371076f4bd32ce5eebcaf9b65f52ee30974834df20511c73bd326e7a2cf6515`.
- Current solution patch SHA-256:
  `7c894f885882ecc458ee7bddd1b527fc0d9d815c9620c11aca9a4dd5f0daa6c0`.
- Dockerfile SHA-256:
  `2029356181233ac2b0cb2af1bf6675f861bf83f8fed71d854389bb9e94838c6c`.
- Base-file SHA-256:
  `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb`.
- Immutable task-prompt SHA-256:
  `aaa3966935b9259f4dc7765a50e0774e08b33c493f52dafcb625e0090d84ac1d`.
- Immutable construction-plan SHA-256:
  `646074be0dbdb0b21a57c32bfbe302836940c61238ab46990d27b7ac4e10bbf5`.
- Fifteen-run bundle aggregate SHA-256:
  `97d7b2af2be959383226a60f26d02a9e150652b244f2649d637987f7c9ed13d8`.
- Current auto-review SHA-256:
  `9cf10d47ced3bcda1cb0333c167346c30d15d094282a5cebaef0fe86e8589664`.
- Current prechecks SHA-256:
  `6f7e85644e2f55d4004f6fffb7dd38af14b49c6e72f4ccfbc1bbdc741e03731e`.
- Current false-positive report SHA-256:
  `389ffb4b1453dde60dc439a942a13b74667d7468db96da4d265115f149252fef`.
- Current repo-fit report SHA-256:
  `2be4b2f5cece4b27e7ca9e5b1b3292db864853df172f4e0c18bbdc9e1b9e898f`.
- Current verifier-audit report SHA-256:
  `a454317924f3537d439075439cf6ac19a567499d7b5e371be4713b7307bfa9e6`.
- Current verifier proposed-diff SHA-256:
  `330b7c26af48a1beddcc3c4083e16ce49b98905c3590b344317f133f51ab993a`.

`seedable-lazy-auto-review.json`, the 15 run bundles, the current prechecks, false-positive
report, repo-fit report, and verifier audit belong to the current description/test/solution
artifacts. `seedable-lazy-ai-evaluation.md` was not refreshed for this round and must remain
historical evidence.

## Current results

| Gate | Current result | Interpretation |
| --- | --- | --- |
| Verify Tests / Verify Solution | Platform green | The current 12-test harness and golden patch run, but the suite misses the confirmed defect below. |
| Test fairness | PASS | No unfair test was reported. Two coverage suggestions are explicitly non-blocking. |
| Agent calibration | 1/15 legitimate passes (6.7%) | Solvable and below the 40% ceiling. |
| Nova | 0/10 | Failures are integration or stated-behavior misses; no environment-wide breakage. |
| Orion | 1/5 | Agent 12 is a broad legitimate solution; four other Orion runs are near misses. |
| Failure distribution | 10 missed requirement, 2 integration error, 2 regression | The population demonstrates genuine generator difficulty rather than a broken harness. |
| False-positive panel | PASSED_WITH_WARNINGS | The only passer was upheld as genuine. The bitmap-name probe was correctly overruled as unfair. |
| Repo fit | PASS, high confidence | Upstream issue 1137 supplies motivation but no public implementation. |
| Auto-review description | Band 3 | Complete, behavioral, and feature-request appropriate. |
| Auto-review tests | Band 3 independently; band 2 in synthesis | Broad and fair, with one concrete combination missing because it permits the golden defect. |
| Auto-review solution | Band 0 | Blocked by one confirmed high-severity `copyOf` provenance defect. |
| Verifier completeness | INCOMPLETE, two proposed probes | Separate from the auto-review blocker; do not apply the full proposed patch in this iteration. |

The current submission is not deliverable despite the green verification jobs and valid pass
rate. The solution-quality band 0 is a real functional blocker.

## Root cause

`generateImmutableCopyOf` returns a same-family generated immutable immediately, so that source
already retains its seed state. Otherwise it builds a new value.

When generated builder `from` is available, the builder's provenance-aware `from(instance)` logic
correctly distinguishes generated immutable/Modifiable sources from arbitrary external sources.
When builder `from` is disabled, the golden patch instead emits per-attribute builder calls and
currently does this for every seedable-lazy attribute:

```text
External implementations cannot expose seed provenance. Leave this attribute cold.
```

That statement is correct only for an arbitrary external implementation. A same-family generated
Modifiable is also accepted by `copyOf`, has generated `...$seeded()` and `...$seed()` helpers,
and can safely transfer a known explicit seed without invoking its public accessor. The current
fallback skips it unconditionally, so `copyOf` silently loses a required explicit seed.

This is exactly the distinction already stated in the description:

- generated `copyOf` preserves explicit seeds without calling the accessor;
- generated Modifiable sources carry inspectable provenance;
- arbitrary external implementations remain unprobed and unseeded.

The problem is in the reference patch, not in the description.

## Auto-review test finding

The matching test finding is correct and necessary to fix with the solution:

- The current disabled-`from` fixture is immutable-only.
- Its test covers `copyOf` from an arbitrary external implementation.
- No current hidden test combines `@Value.Style(from = "")`, `@Value.Modifiable`, and
  `Immutable...copyOf(modifiableSource)`.
- Consequently, the broken golden branch passes all 12 focused tests.

This is different from a non-blocking suggestion. It demonstrates that the current suite accepts
a golden implementation that violates an explicit transfer requirement. The regression must be
added in the same iteration as the solution correction.

## Pass-rate impact

### Solution-patch correction

Expected direct impact: **none**.

Solver agents do not receive the golden solution patch. Correcting it changes the reference
oracle, not the task they attempt.

### Focused regression test

Expected saved-population result: **1/15 (6.7%), unchanged**.

The sole legitimate passer, Orion agent 12, independently:

- created a model combining `@Value.Immutable`, `@Value.Modifiable`, and
  `@Value.Style(from = "")`;
- added `copyOfPreservesModifiableSeedsWhenBuilderFromIsDisabled`;
- added the generated-Modifiable provenance branch to the no-`from` factory path;
- passed its own 13 feature tests and the platform's 12 hidden tests.

Therefore the regression does not invalidate the only current passer. It may reject an otherwise
incomplete future implementation, but it introduces no new behavior and should not make a
legitimate solver less able to discover the task.

### Optional additions

Expected impact if added now: **unnecessary downward pressure with no benefit to the blocking
repair**.

Do not add the precheck suggestions or the full verifier-audit proposal in this iteration.

## Review-item decisions

### Mandatory: no-`from` generated Modifiable `copyOf`

Accept. It is a confirmed high-severity violation of an explicit requirement and blocks the
auto-review.

### Mandatory: matching regression coverage

Accept. It is the minimal test that fails the current golden defect, and the sole passer already
passes the scenario.

### Test-fairness suggestion: mixed-origin multi-hybrid immutable `copyOf`

Defer. Seed transfer, computed-state reset, multiple-hybrid independence, and ordinary `copyOf`
are already tested independently. The suggestion presents no demonstrated surviving wrong
implementation and is explicitly non-blocking.

### Test-fairness suggestion: serialization of a throwing hybrid

Defer. Java-serialization reset and non-memoization of throwing fallbacks are already tested
independently. The combined scenario is valid but not necessary to close a known hole.

### Verifier-audit gap: Modifiable map mutators

Do not apply in the mandatory repair. This is stated behavior and the audit demonstrated a
mutant, but the golden solution is already correct through ordinary Modifiable set-bit tracking.
It is not the band-0 cause. If the platform requires a verifier-audit resolution after the
auto-review fix, consider accepting only this focused probe in a separate, measured iteration.

### Verifier-audit gap: 65th hybrid bitmap word

Bypass. A 65-accessor fixture tests an internal scale boundary not stated in the brief, adds a
large hidden surface, and is disproportionate while calibration is 1/15. The golden and the sole
passer both appear to index bitmap words correctly, but that does not make the probe necessary or
fairly discoverable.

### Conciseness and Docker warnings

Defer. They are non-blocking and unrelated to the functional defect. Changing description or
environment bytes now would stale additional checks without improving correctness or solvability.

## Approved implementation plan

### Task 1: Add the missing regression first

**Files:**

- Modify: `test-seedable-lazy.patch`

**Fixture change:**

- Add `@Value.Modifiable` to `SeedableLazyNoFromModel`.
- Keep `@Value.Style(from = "")`.
- Reuse its `hybridReads` counter and throwing/distinct fallback.

**Test behavior:**

1. Create a generated Modifiable source with all ordinary attributes set and an explicit
   `expensive` seed.
2. Call `ImmutableSeedableLazyNoFromModel.copyOf(source)`.
3. Assert the explicit seed is returned and `hybridReads` remains zero.
4. Modify an ordinary attribute on the copied immutable and assert the seed still survives.
5. Repeat with an unseeded generated Modifiable.
6. Assert copying does not call its getter, leaves the result cold, and runs the fallback only
   when the copied immutable accessor is first invoked.

The regression must fail against the current solution patch for loss of the explicit seed—not
for compilation, an unrelated assertion, or external-source behavior.

### Task 2: Correct only the no-`from` factory branch

**Files:**

- Modify: `solution-seedable-lazy.patch`

**Required behavior:**

- Preserve the existing immediate return for same-family immutable instances.
- In the builder-based `copyOf` path with `generateBuilderFrom == false`, use a local builder for
  seedable-lazy types so generated-source checks can be emitted as statements.
- Copy every non-hybrid settable attribute exactly as before.
- For each seedable-lazy attribute:
  - if Modifiable generation exists and `instance` is the same-family generated Modifiable,
    inspect its generated seed bit;
  - transfer its generated backing seed only when explicitly set;
  - use the repository-appropriate builder API for scalar, optional, nullable, collection, and
    map attributes;
  - otherwise emit no getter call and leave the destination hybrid absent.
- Build and return the value.

Do not generalize this into reflection, public-getter probing, or unconditional copying. Do not
change builder `from`, `Modifiable.from`, withers, serialization, metadata classification, or
diagnostics.

### Task 3: Validate the focused repair

**Files to audit:**

- `immutables-seedable-lazy.md`
- `test-seedable-lazy.patch`
- `solution-seedable-lazy.patch`
- `Dockerfile-seedable-lazy`
- `BASE_COMMIT-seedable-lazy.txt`

**Lightweight checks before remote verification:**

- Run `git diff --check`.
- Recompute affected new-file blob IDs and hunk line counts.
- Confirm `test.sh` remains mode `100755` and passes `bash -n`.
- Confirm test and solution patches apply independently and together at the exact base.
- Confirm the description, Dockerfile, base file, task prompt, and immutable plan remain
  byte-identical.
- Confirm no fairness suggestion or verifier-audit proposal was accidentally imported.

**Authoritative platform checks:**

1. Run Verify Tests.
2. Run Verify Solution.
3. Rerun auto-review and require solution band greater than 0 with the specific finding absent.
4. Rerun fairness only because the test hash changed; require no unfair test.
5. Replay Orion agent 12 if saved replay is available.
6. Run a small mixed population only if replay is unavailable or if the platform requires fresh
   calibration.
7. Require at least one legitimate pass and at most 40%.

## Stop rules

- Do not change the description to excuse the golden defect.
- Do not remove disabled-builder-`from`, Modifiable, external-copy, or provenance behavior.
- Do not call the hybrid getter to recover a seed.
- Do not add the two fairness suggestions in this iteration.
- Do not apply the verifier audit's full proposed patch.
- Do not add the 65-attribute bitmap fixture.
- Do not rewrite the golden patch around the passing agent's implementation wholesale; use its
  branch only as evidence and implement the smallest compatible correction.
- Do not execute this plan until the user reviews and approves it.
- Do not update this committed plan after the checkpoint unless the user explicitly requests a
  revision.

## Completion criteria

The next implementation iteration is ready only when:

- the focused regression fails on the current golden branch for the expected seed-loss reason;
- the corrected golden patch preserves seeded and unseeded no-`from` generated Modifiable
  provenance without accessor calls;
- all existing focused behaviors remain intact;
- Verify Tests and Verify Solution are green;
- auto-review no longer reports the high-severity solution defect;
- fairness remains clean;
- calibration retains at least one legitimate pass and no more than 40%.
