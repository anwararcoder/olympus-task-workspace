---
description: Diagnose and recover from zero-pass results without creating a false-positive loop
---

# Handle Zero Pass

## When to Use

Run whenever a current platform batch has zero legitimate passes. Prefer exact saved runs and
current auto-review/FP artifacts over older summaries. Read
`../rules/false-positive-calibration.md` before changing anything.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Goal

Identify the primary cause and make one coherent class-level correction that can restore at least
one legitimate passer while preserving the live pass-rate, fairness, reference, and FP gates.

## Step 1: Confirm Signal Quality

Before changing anything, verify report quality:
- Verdicts are complete for most agents
- Not dominated by missing runs/API errors
- Deliverable hashes match the evaluated state
- Baseline/focused XML and trajectory are available for the runs used
- Candidate and golden builds cannot contaminate each other

If signal is noisy or the harness censored a solver class, repair/rerun before changing task scope.

## Step 2: Classify the Zero

Build the run-family and contract-closure matrices, then classify the round:

1. Signal/harness defect.
2. One dominant discoverability blocker.
3. Too many independent fair blockers.
4. Golden or contract defect.
5. Rejected or foreign repo seam.

Write the evidence for the classification. If several cells fail independently, compute the
conjunction rather than treating the closest final score as proof of one blocker.

## Step 3: Select the Matching Lever

- Class 1: fix infrastructure only and rerun the unchanged contract.
- Class 2: rank the nearest correct-architecture candidate and add one short behavior-only
  clarification or permitted hint.
- Class 3: remove one coherent capability island across description, tests, and golden.
- Class 4: choose the intended contract and repair description, tests, and golden together.
- Class 5: stop and replace the core task.

Do not remove a fair discriminator just to revive its candidate. Do not constrain the description
to match a golden that violates the intended feature.

## Step 4: Predict Named Run-Family Effects

Before editing, state:

- which legitimate or near-solver architecture should become green;
- which wrong architecture must remain red;
- which confirmed FP candidate must remain red or be repaired at its root;
- why the expected pass rate remains inside the live panel for the actual tier mix.

"One lever" means one diagnosis or defect class; dependent prose/test/golden edits belong in the
same round.

## Step 5: Validate the Contract Lock

After the edit, verify:
- Every exact-string assertion has explicit contract wording if required
- No new hidden assumptions
- Description avoids implementation recipe
- Every retained clause has tests and golden support
- Every test maps back to a retained clause
- Positive controls prevent disabling the feature
- Exact candidate/golden probes have the intended four-way classification

## Step 6: Verify and Re-run

Run remote four-state verification, replay the named saved patches, preserve exact logs/hashes, and
then run a fresh platform batch plus every check made stale by the edit. Use the current numeric
authority at `my-review-workflow/rules/platform-panel.md`.

## Output Template

Use this template in your iteration notes:

```text
Exact state and hashes: <manifest>
Primary zero-pass class: <1-5>
Evidence: <run families, first wrong turns, breadth arithmetic>
One coherent lever: <infrastructure, clarification, de-scope, contract repair, or replacement>
Expected passer family: <run IDs and architecture>
Wrong/FP families that must remain red: <run IDs and architecture>
Verification and stale checks: <exact list>
```
