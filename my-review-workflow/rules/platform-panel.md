# Platform panel: fields, scores, numbers (single source of truth)

Every number and field definition for reviews lives here. When the platform changes something,
edit this file and its changelog, nothing else.

## Panel fields (current, 2026-07)

- Decision: Approve / Request Changes / Reject.
- Three scored fields, each 0-3 with its own Low/Med/High confidence (confidence is internal):
  Problem Description, Tests, Solution & Code.
- Any score under 3 requires a Reason for that field. The reason is sent to the author as the
  feedback for that section, so it must be specific and actionable.
- There is NO internal reasoning box anymore (confirmed by Karim, 2026-07: "feel free to drop it
  in the other notes"). Reasoning goes into Other notes.
- Other notes: sent to the author. Anything outside the three fields: difficulty, LOC, repo fit,
  overlap, plus the decision reasoning.
- Tags: internal only, for managers. Available: Difficulty / scope, Lines of code, Repo fit,
  AI slop, Duplicate / overlapping, Already solved (PR/issue online). Tag what you actually
  flagged, with a one-line why in the review doc.
- Downgrade to Mars checkbox: flips the submission to Mars on finalization. Use when Olympus
  targets are not met and the author would rather land it than bump scope; surface the choice to
  the author first.

## Score definitions (verbatim hover text)

Description:
- 0 Failing: Missing or contradictory requirements, or a raw spec dump.
- 1 Weak: Prescriptive/leaky, ambiguous, or off-scope; needs changes.
- 2 Minor: Passes, with soft issues; mildly AI-ish, slightly verbose, or minor formatting.
- 3 Clean: Natural, only necessary detail, non-prescriptive, well-formed. Complete,
  self-contained, unambiguous, real repo scope.

Tests:
- 0 Failing: Passes on base, non-deterministic, missing critical tests, verifies hidden
  requirements, or doesn't validate behavior.
- 1 Weak: FP/FN risk, flaky, fragile internals, or ignores repo structure. Missing needed tests
  suggested by the Test Fairness check.
- 2 Minor: Solid; a missed edge case or one weak/redundant assertion.
- 3 Clean: Covers all requirements and obvious edge cases, deterministic, strong assertions,
  follows repo patterns.

Solution:
- 0 Failing: Doesn't meet requirements or breaks existing code.
- 1 Weak: Touches unrelated code, fragile, or slop-ish.
- 2 Minor: Works; minor noise; a small irrelevant edit, minor harmless bugs, or light unexplained
  defensive code.
- 3 Clean: Meets requirements, no regressions, no irrelevant changes, stable API, no slop.

Scoring discipline: a field with real minor findings is a 2. Do not hand out a 3 and bury the
findings in notes; do not drop to 1 for cosmetics. Approve with 2s is normal and expected.

## Tier bars (read the criteria panel per submission; these are the current defaults)

- 2026-07-11 criteria change (owner + lazygit round): Olympus is now pass rate <= 40%, median of
  successful runs >= 250 LOC, >= 40 messages, >= 2 files. Mars is RETIRED; submissions created in
  the old UI may still carry a stale "Mars" task-type tag in prechecks, ignore it and grade
  against the new Olympus bar. The Downgrade-to-Mars checkbox is dead with it.
- The tier is defined by the criteria panel targets, never the docker base image name.
- Golden-solution effective LOC floor tracks the criteria LOC row (now 250 meaningful production
  lines), counted with the manager's exclusion list (msw-rooms revert): blanks, comments, braces
  and punctuation-only lines, imports, export-only wiring, type-only declarations, boilerplate,
  tests. count_loc.py is a lenient screen only (it passed at 505 a golden the manager counted at
  360-371). Strict count under the floor = Request Changes with the bump choice put to the
  author, never approve-with-note.
- New required check (2026-07-11): False Positive evaluation must run and pass.
  PASSED_WITH_WARNINGS means solo dissents were overruled; re-derive every caveat yourself, and
  treat a SPEC_GAP_REFERENCE_ALSO_FAILS tag as a golden-vs-description mismatch lead (Solution 2
  territory), per lessons/LESSONS.md 2026-07-11.
- General gates on the panel: fair task (no run flagged unfair), solvable (>= 1 legit pass), cheat
  rate < 20%, no environment blockers.

## Superseded numbers (pre-2026-07-11, kept for reading old rounds)

- Olympus: >= 10 completed runs, pass rate <= 20%, long-horizon median >= 3 files, >= 80
  messages, >= 400 LOC; golden strict floor 400.
- Mars: >= 10 completed runs, pass rate <= 30%, median successful-run LOC >= 100.

## Decision mapping

- Approve: all fields 2 or 3, no blocking finding, difficulty/fairness gates hold.
- Request Changes: any field at 1, or a specific fixable blocker (weak assertions that admit wrong
  solutions, spec/test contradiction, base test edited, dead code, unfair point). List each item
  as an action.
- Reject: core idea fails (duplicate, already solved upstream, philosophy violation, out of
  scope), per reference/check_rejection.md. Do not reject for description word count (Karim).

## Changelog

- 2026-07-11: criteria change per owner + live panels: Olympus <= 40% pass, median >= 2 files /
  >= 40 messages / >= 250 LOC; Mars retired (old-UI submissions may carry a stale Mars tag,
  ignore it); golden LOC floor tracks the 250 row; False Positive evaluation added as a required
  check (PASSED_WITH_WARNINGS caveats get re-derived, they can carry the round's main finding).
  Old numbers moved to a Superseded section.
- 2026-07-02: created. 0-3 panel replaces the 21-check Yes/No list (Karim's announcement).
  Reasoning box removed; reasoning goes to Other notes. Tier bars taken from live criteria panels
  (Olympus <= 20%, Mars <= 30%).
- 2026-07-02 (later): golden LOC floor corrected to 400 per owner; the ~380 in count_loc.py and
  check_loc.md is stale. Also: the panel's long-horizon LOC row counts RAW diff lines (agents'
  own tests and comments included), so a green row does not clear the meaningful-LOC check.
- 2026-07-02 (msw revert): manager's exclusion list confirmed to also strip imports, export-only
  wiring, and boilerplate. Datapoint: same golden = 505 (count_loc.py), 398 (blanks/comments/
  punctuation only), 360-371 (manager). Sub-400 strict = Request Changes; the approved-with-note
  review was reverted.
