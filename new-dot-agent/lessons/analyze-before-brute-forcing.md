# analyze-before-brute-forcing

**When a batch fails, analyze WHY before adding hints, clarifications, or test edits — most uniform
failures are task ambiguity/unfairness, not weak agents. Brute-forcing the checks green burns
tokens, rounds, and ends in a revert.**

## Evidence (owner's standing instruction, 2026-06)
- The platform operator's note, verbatim in the failure-analysis guide: "some users keep running
  many agents or adding more hints and clarifications ... without first checking why the agents
  failed or whether the tests are fair. ... Please analyze the failures before starting the QA or
  submitting instead of trying to brute force the agents and checks until they pass. It will save
  you time, tokens, and effort."
- "A strong signal that there might be an issue is when all or most agents fail for the same exact
  reason" — could be ambiguity/unfairness, or a genuinely hard fair part. Either way: analyze first.
- Cost of ignoring it: `osctrl-carve-integrity` spent ~8 days re-wording an undiscoverable
  daemon-homed seam (a 0/34 uniform failure) that the W2 preflight + a seam-legality read would have
  flagged in an afternoon. `osctrl-secret-rotation` was brute-forced to 2/10 and finalized, then
  reverted.

## Applies at
W5 §1 (categorize before any lever), W6 (analyze before QA).

## Rule it shaped
`workflows/w5-platform-iteration.md` §1 (the "analyze first" banner + verdict taxonomy),
`rules/fairness-and-review-flags.md` §F.2.
