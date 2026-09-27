---
description: Rules for diagnosing zero-pass results without trading solvability against false-positive safety
---

# Zero-Pass Diagnosis Rules

## Core Rule

When pass rate is zero, identify the cause before selecting a lever. Follow
`false-positive-calibration.md`, especially its exact-state manifest, run-family matrix, and
zero-pass decision tree. A hint is one possible branch, not the default remedy.

## Required Inputs

- Current auto-review JSON, AI evaluation, or saved agents-run artifacts
- Current description
- Current test patch and solution patch
- Previous accepted-history examples for the same repo/problem family
- Exact deliverable hashes and the live criteria panel
- Candidate patches, XMLs, trajectories, and false-positive probes for the current state

## Required Classification

Choose exactly one primary class before editing:

1. Signal or harness defect: repair infrastructure and rerun the same contract.
2. One dominant discoverability blocker: consider one behavioral clarification or hint.
3. Excessive independent breadth: coherently remove one capability island from prose, tests, and
   golden.
4. Golden or contract defect: align all three contract artifacts in one round.
5. Rejected or foreign repository seam: stop and replace the core task.

Do not use passing probability from censored runs. Do not call many independent failures "one
blocker" merely because they produce the same final zero-pass verdict.

## Nearest-Agent Selection Rules

Only for class 2, choose the nearest-solving agent using this priority:
1. Single dominant failure cluster
2. No baseline regression
3. Correct architecture, wrong edge behavior
4. Explicit evidence that remaining issue is local, not global

Reject candidates that fail with:
- multiple unrelated clusters
- compile/runtime regressions across baseline
- unstable or incomplete runs

## Hint Rules

The hint must:
- state observable behavior only
- avoid implementation details
- avoid file/function names
- be one sentence when possible
- Hint size target: one short sentence.

Use the current pass-rate and successful-run bars from
`my-review-workflow/rules/platform-panel.md`. Report the model-tier mix rather than comparing raw
percentages across unlike batches. Check the current platform rules before using a formal hint.

The hint must not:
- reveal algorithm steps
- mention exact internal helper names
- enumerate hidden test cases directly

## Scope Rules

For a zero-pass recovery iteration:

- change one diagnosis or failure class, which may require coordinated edits;
- default to description-only only for a real class-2 discoverability gap;
- change tests and golden together when the contract class is objectively open or wrong;
- keep the delta auditable and predict its effect on named run families;
- replay legitimate passers, nearest solvers, and confirmed FP candidates before a fresh batch.

## Validation Rules

After any update:
- Ensure description-test contract alignment
- Ensure exact-string assertions have explicit wording if required
- Ensure no hidden assumptions remain
- Ensure the golden implements every retained clause
- Run four-state verification and the candidate/golden FP table in isolated environments

## Expected Outcome

The target is not a fixed historical count. The next exact state must have at least one legitimate
pass, remain within the current live bar, preserve fairness, and pass the required FP and quality
gates. If one coherent change cannot plausibly do that, stop and redesign before spending a batch.
