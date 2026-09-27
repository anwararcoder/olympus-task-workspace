---
description: Analyze platform review data and agent-run artifacts, then address difficulty, precision, quality, and sanity issues
---

# Handle Platform Review Data

## When to Use

Run after receiving platform review data to understand all check types and address issues. Current problem directories may contain `{problem-name}-auto-review.json`, `{problem-name}-agents-runs/`, `{problem-name}-ai-evaluation.md`, older `*-ai-report.md` files, or a combination of these.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Core Principle

> **Never weaken a valid contract merely to move pass rate. Diagnose the failing class first. A
> coherent de-scope is allowed only when description, tests, and golden change together.**

Before interpreting a batch, read `../rules/false-positive-calibration.md` and the current numeric
authority at `my-review-workflow/rules/platform-panel.md`. Historical Diamond or Castor numbers do
not control a normal Olympus task unless its current criteria panel selects that mode.

## Platform Rules for Rollouts and Later Checks

From the official process (`../rules/olympus-platform.md` sections 9-11):

- **Order**: rollouts only after Prechecks, Scope Gate, Build, and all Quality checks are green and
  current. Then quick check -> full batch -> FP check -> Auto Review -> Submit.
- **Quick check vs full batch**: iterate with single cheap runs; use a full batch (agents and
  counts are configurable) only once the task is stable. Trust the results banner ("run a quick
  check", "run the full batch", "too easy", "looks broken", "ready"). A 100% quick pass means too
  easy; a 0% on a vague point or unfair test means fix before any full batch.
- **Minimum finished rollouts**: required before submitting; the count is in the criteria panel.
  Runs count only once finished (~15 minutes typical, up to 90 on big or hard tasks).
- **Staleness**: results are pinned to exact content. Editing any field after a rollout, check, or
  review finishes makes it stale and it stops counting. One batch at a time; read results before
  editing; never trigger more rollouts while a batch is in flight.
- **Solvability**: at least one agent must pass before the platform allows submission.
- **FP check**: run only after the run set is settled; a single false pass fails "No false
  positives". Set **Protected source folders** first if real source sits under `build`, `dist`,
  `target`, `node_modules`, `__pycache__`, or `.venv`.
- **Auto Review**: must run to completion; run it last when everything else is green. Its verdict
  does not block but predicts the human review, and a clean one may grant a queue skip to manager
  final approval.
- **Contest button**: some failed verdicts on checks or runs allow one rebuttal. Use it only when
  the verdict is actually wrong, with proof (code, test output, run log); the note is what the
  human reviewer reads. Contesting never refunds tokens. Refunds happen automatically only for
  platform infrastructure failures.

## All Check Types

Platform review artifacts contain multiple check types that must all be addressed:

| Check Type | Priority | What It Checks |
|------------|----------|----------------|
| **False Positive** | Required | Whether every counted passing patch satisfies the stated contract |
| **Difficulty** | Required | Solvability, pass rate, and successful-run medians from the live panel |
| **Precision** | High | Description alignment with tests |
| **Quality** | Medium | Code standards, style adherence |
| **Sanity** | Medium | Basic requirements, format |

> For initial checks before the full platform review, see `/handle-initial-checks`

---

## Step 1: Read and Analyze the Review Artifacts

Read the newest available artifacts in the problem directory. Prefer structured auto-review JSON and saved agent-run artifacts over stale summary notes:

```bash
cat my-work/{problem}/{name}-auto-review.json
find my-work/{problem}/{name}-agents-runs -maxdepth 2 -type f
```

Extract key metrics:
- **Verdict counts**: agent_fault, problem_fault, pass, api
- **Run-level evidence**: `*evaluation.json`, `*new-tests.xml`, `*base-tests.xml`, `*solution.patch`, and targeted `*trajectory.json` snippets

## Step 2: Categorize Verdicts

| Verdict | Meaning | Action |
|---------|---------|--------|
| PASS_LEGITIMATE | Agent solved correctly | Problem may be too easy |
| FAIL_EARLY_TERMINATION | Agent gave up | Neutral - Evaluation not counted |
| FAIL_WRONG_LOGIC | Agent made bugs | Good - tests caught issues |
| FAIL_MISSED_REQUIREMENT | Agent missed requirement | Good - requirement is hard |
| FAIL_INTEGRATION_ERROR | Code doesn't compile | Good - integration is hard |
| FAIL_TEST_BROKEN | Test infra broken | Fix infra — fairness violation |
| PROBLEM_FAULT_* | Description unclear | Fix description |
| FAIL_API_FAILURE | External API issue | Ignore for metrics |

Also classify run quality:
- **Signal stable**: most runs completed with agent verdicts.
- **Signal noisy**: many `DID_NOT_RUN` / missing verdicts.

If signal is noisy, rerun before making design changes.

## Step 3: Analyze Accepted Work (Before Making Changes)

Before modifying anything, study accepted work to compete:

```bash
# Go to accepted work directory and iterate from v1 to latest
cd my-work/{accepted-problem}/
```

For each version (v1, v2, ..., vN), read:
1. **Commit message** - What changed and why
2. **Description file** - How they phrased requirements
3. **Test patch** - How they designed traps
4. **Solution patch** - How they solved from roots
5. **Auto-review JSON / legacy AI report** - What worked/failed
6. **Agents-run artifacts** - Per-agent verdicts, XML, solution patches, and targeted trajectories
7. **Human reviews** (if any) - Feedback patterns

> This analysis gives you ideas that can compete against existing work regarding difficulty.

## Step 4: Apply Tiered Approach

Use these tiers only after the contract-closure matrix is complete and current passers have survived
the FP audit. Every addition must remain inside a stated or clearly inferable contract class.

### Tier 1: Find Missing Gaps

First, identify missing cells in the retained contract:
- Review agent solutions that passed - what did they miss?
- Check for obvious behaviors not covered
- Look for boundary conditions
- Verify error paths are tested

### Tier 2: Add Hard Aspects

Cross dimensions already promised by the description or exposed by a realistic repository shape:
- Expand existing test cases with deeper scenarios
- Add integration tests across layers
- Test state persistence and cleanup
- Verify order-dependent behaviors

### Tier 3: Add Semantic Traps

Add discriminators targeting observed wrong architectures. Pair each negative discriminator with a
positive control so the easiest response cannot be to disable the feature:

| Trap Type | What It Catches |
|-----------|-----------------|
| Scope resolution | Naive linear search |
| Order-dependent | Parallel evaluation |
| Kind preservation | Metadata loss in free vars |
| Branch isolation | Retrospective lookup |
| Timing semantics | Build/parse-time confusion |

### Tier 4: Controlled Difficulty Tuning

When pass rate is above target (over-solve), do not rewrite broadly.

1. Freeze the retained description contract.
2. Select one observed wrong architecture or open contract class.
3. Add the smallest class-closing discriminator and positive control.
4. Replay the golden, legitimate passers, and the targeted wrong patch.
5. Re-run all stale checks and measure a fresh batch.

This avoids oscillation between too easy and unfair.

## Step 5: Address Precision Issues

If description misaligned with tests:
- Ensure every test behavior is inferable from description
- Add minimal clarification to description, OR
- Rephrase existing description to make behavior inferable without implementation hints

## Step 6: Address Quality Issues

If code standards not met:
- Review `*-human-reviews.md` files for common patterns
- Verify no AI-style comments in patches
- Confirm repo coding standards followed

## Step 7: Apply Changes and Verify

Read `standards/HYBRID-CLOUD-WORKFLOW.md`. Keep edits local, but run expensive Docker verification
on an explicitly selected remote forge. Never reset or clean a shared checkout. From the
`Shipd - Olympus` root, the normal path is:

```bash
scripts/verify-remote.sh my-work/{problem} --account <authorized-login>
```

The account's `primary` slot is the default. If it is occupied but the account
still has quota, select an already provisioned slot with `--slot <name>` as
documented in the hybrid workflow. If the account is out of hours, change
accounts; another slot under the same account will not help.

Use a task-owned isolated worktree/container for targeted candidate/golden FP probes and copy the
logs, XML, probe source, and hashes back locally.

## Step 8: Regenerate Patches

Regenerate only from the task-owned local worktree. Confirm no other agent is using it first.

```bash
git reset .
git add test.sh path/to/tests.go
git diff --cached -- test.sh path/to/tests > ../../my-work/{problem}/test-{name}.patch
git reset .
git add path/to/solution.go
git diff --cached -- path/to/solution.go > ../../my-work/{problem}/solution-{name}.patch
```

## Step 9: Verify Fresh Apply

Run the remote verifier against the final exact hashes. Require all four states documented in
`standards/HYBRID-CLOUD-WORKFLOW.md`, then run candidate/golden discriminators in separate mutable
namespaces. Do not prune or stop a forge until it is clear no other task is active.

---

## Quick Decision Table

| Situation | Action |
|-----------|--------|
| Pass rate above the live panel | Apply the tiered approach after the FP and contract-closure audit |
| 0% pass rate | Run `/handle-zero-pass`; distinguish harness, one blocker, breadth, golden, and repo-fit causes |
| Problem faults | Clarify description, ensure alignment with tests |
| Precision errors | Rephrase description to align or accept if behavior is inferable |
| Quality issues | Check human-reviews patterns, fix code |
| 0% with agent faults only | Not enough to call it appropriately hard; run the breadth and discoverability audit |
| In-band legitimate passes | Continue only after FP, medians, freshness, and other gates also clear |
| Test collision (TEST_MISMATCH) | Reclassify only when exact artifacts prove an evaluator/name collision |
| Metric below threshold | Use the live panel; solvability and required medians cannot be inferred away |
| Many DID_NOT_RUN / missing verdicts | Re-run checks before modifying problem design |
| Dominant FAIL_TEST_MISMATCH | Audit exact-vs-contains contract alignment first |

---

## Checklist Before Resubmitting

- [ ] Analyzed accepted work for competing ideas
- [ ] Applied tiered approach (gaps → hard aspects → traps)
- [ ] Description aligned with all tests
- [ ] No surprise tests
- [ ] Checked `*-human-reviews.md` patterns
- [ ] Checked `{name}-auto-review.json` and `{name}-agents-runs/` when present
- [ ] Reproduced and classified every false-positive discriminator against candidate and golden
- [ ] Confirmed all reports describe the same hashed deliverable state
- [ ] Solution still passes all tests
- [ ] Fresh apply verification passes

## Agent Messages

Use the message definition and model identities recorded in the current artifacts. Agent mix and
batch size can change; report actual tiers rather than assuming a fixed roster.

## Evaluation-Label Adjudication

A helper label may be overturned only when exact artifacts prove it is an evaluation collision or
classification error; record that evidence. Numeric panel gates, legitimate solvability, fairness,
repo fit, and the required FP evaluation are not bypassed by an explanation.

If pass rate is zero, use `/handle-zero-pass` and `../rules/false-positive-calibration.md`. A short
behavioral hint is only the single-dominant-discoverability branch. Harness defects, excessive
independent breadth, golden/contract defects, and rejected repo seams require different actions.
Check the current platform authority before using a formal hint.

## Long-Horizon Metric

Use the successful-run LOC, message, and file medians in the live criteria panel. Do not copy old
Diamond, Castor, or pre-2026 Olympus thresholds into a current decision.

Agent assignments and outcomes are stochastic, so compare exact state, tier mix, and architecture
families rather than percentages alone.

### Stochastic Variation Warning

A fresh batch can move without a contract edit. Before attributing movement to randomness:

1. Confirm identical deliverable hashes and a comparable tier mix.
2. Check whether the failing architecture family or test path changed.
3. Rule out harness, golden, fairness, and FP defects.
4. Rerun only when the state is sound and the movement is genuinely sampling noise.

A rerun never cures a reproducible false positive or reference defect.
