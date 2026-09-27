# concede-base-behavior-conflicts

**A difficulty lever that contradicts documented base-repo behavior is unfair, and defending it
against a correct reviewer wastes rounds — verify the claim against base source, then concede and
re-scope in ONE round.**

## Evidence (as of 2026-06-10)
- `osctrl-secret-rotation-windows`: the headline cross-process freshness clause required behavior
  the repo deliberately does not have — base osctrl documents a security-reviewed 2-hour cache
  TTL. The author first defended on consistency grounds, the reviewer narrowed the point
  correctly, and the author conceded and re-scoped the clause out (difficulty-neutral). The
  defend-then-concede path cost extra rounds over concede-immediately.
- `osctrl-carve-integrity`: asserting a SYNCHRONOUS response where base is asynchronous
  (`go ProcessCarveBlock`) was the same class of conflict — instantly unfair.
- Corollary learned alongside: a reviewer's "this is stronger than the repo's behavior" is ALSO
  a ceiling signal (the requirement may be carrying less difficulty than believed) — feed it into
  the W5 ceiling check, don't just litigate fairness.

## Applies at
W1 fork design (pre-verify every fork against base source) and W7 review handling.

## Rule it shaped
`rules/fairness-and-review-flags.md` §A (base-conflict note), `workflows/w7-human-review.md`
steps 3-4.
