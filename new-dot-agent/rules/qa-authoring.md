# QA Authoring — every annotation `true`, first or second pass

The full operating manual is `olympus-tmp-files/start-qa.md` (battle-tested; keep using it as the
zero-context QA onboarding). This rule is the binding summary plus the two process changes the
autopsies demanded.

## The artifacts

- Per-run evaluations in `{problem}-QA/`: `{problem}-agent-N-success-evaluation.md`
  (PASS_LEGITIMATE; score 1-5, accepted passes are almost always a 4 with the held-back reason
  stated; certainty not plausibility — ban "looks correct/appears safe") or
  `{problem}-agent-N-failure-evaluation.md` (groups by root cause: same requirement cluster + same
  wrong assumption + same broken code path, else split; each group: Tests / Why grouped /
  Fairness with VERBATIM prompt quotes / Root cause with trajectory step_id + verbatim quote).
- `{problem}-diamond-artifacts.md`: Environment Description · Success Solution Explanation
  (plain-text file:line, honest disclosure of extra artifacts) · Grouped Test Summary (consumes
  the owner-supplied test list; per-group what-it-checks + verbatim fairness clause; closing
  coverage check mapping every prompt requirement to a group) · Success Trajectory Analysis.

## Scoring & issue taxonomy (use it; don't hand-wave)
- **Success score 1-5:** 5 = certainty (full contract + repo conventions + baseline safe, no hidden
  issue) · 4 = very likely, one minor stated uncertainty (accepted passes are almost always a 4) ·
  3 = passes but real doubt · 2 = serious doubt · 1 = cannot defend. Prove each requirement cluster;
  ban "convincing/looks correct/appears safe".
- **Every issue (success or failure) carries Severity 1-5 (4+ = blocking, 3 = borderline) and a
  Category:** correctness · design · extensibility · readability · instruction-following.
- A failure group, when the cause is ambiguity/unfairness, ESCALATES as a task fault — never write a
  confident agent-fault story over a real task fault (the QA author owns this honesty).

## The prime directive and the audit loop

Every backticked token / file:line / quoted sentence / step_id / asserted effect must be literally
verifiable in THAT run's own artifacts (`agent_solution_patch`, `test_patch`, `trajectory_json`,
`junit_new_xml`). The full trap list is `rules/fairness-and-review-flags.md` §E — run the
self-audit sweep on every file BEFORE submitting. The audit returns `{problem}-qa-audit.json`
(read-only platform output): fix every `mixed`/`false` at the SOURCE, then **sweep that mistake
class across all files** (the audit samples), re-derive every touched citation, resubmit.
Convergence 14→4→0 over rounds is normal; fewer is cheaper. QA-only edits do not re-stale checks.

## Process changes (new, from the autopsies)

1. **Pre-QA risk huddle.** QA is written only AFTER all gates are green AND any human-review
   concern has been resolved or consciously justified — never to a template under time pressure
   (carve's 12-note QA revision round was this). If a reviewer concern is open, settle it first;
   the QA then discloses it honestly instead of papering over it.
2. **Ledger lines for every audit round** (`rules/documentation-ledger.md`): flagged count, the
   mistake CLASSES, the sweep done. QA rounds were the least documented and among the most
   expensive — no longer.
3. **Per-run isolation absolutism.** No cross-run references, no annotations copy-pasted across
   tests within a run (vary the prose, differentiate per test), no reference-solution symbols
   attributed to a run that implemented things differently.
