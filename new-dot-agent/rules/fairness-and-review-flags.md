# Fairness & Review Flags — the complete catalogue (pre-empt, don't discover)

Every entry here was flagged on a REAL submission. Sweep deliverables against this list at build
time (`workflows/w4-verify.md`) — discovering any of these on the platform costs a full re-stale
cycle (`rules/platform-bar.md` staleness).

## A. Difficulty-lever verdicts (the four ways a lever dies)

| Verdict | Fingerprint | Real case | Action |
|---|---|---|---|
| **WALL** | ~all castor agents fail one test; rollouts still ~1.0 | de-telegraph 0/10; anon-supertype 0/12 | remove the test/lever; recover prior state byte-exact from git |
| **UNFAIR (hidden internals)** | requirement not in prompt nor discoverable in repo | record-component dedup (javac models it as 3 elements) | never ship; platform Test-Fairness FAIL |
| **AMBIGUOUS (spec-open)** | a correct agent can legitimately diverge | constructor-name modifiers; "smallest" delta edits; modifier render order | assert only the pinned part (a set, a count, a named modifier) |
| **NO-OP** | saved/strong agents already do it identically to the reference | package-segment skipping; delta/resultId per-doc state | probe first (replay), never ship unprobed forks |

Also: a fork contradicting DOCUMENTED base behavior is instantly unfair (secret-rotation's
freshness clause vs the security-reviewed 2h cache TTL) — verify against base source, and when a
reviewer narrows such a point correctly, CONCEDE and re-scope rather than defend.

## B. Description flags

Telegraphing pre-existing behavior with one word ("still") — blocking. Negative/relative text
definitions — ambiguous. Partial enumeration read as exhaustive. Degenerate fixture semantics
stated only in hidden tests. Mechanism hints / internal names. (Full rules:
`rules/description-writing.md`.)

## C. Solution flags (human reviewers, recurring)

Dead code & unused helpers (the #1 flag) · comments above repo density / AI-style prose · diff
noise & cosmetic churn · missing path canonicalization · non-atomic writes · wildcard-delete
cleanup without ownership records · in-memory state where the contract implies durability ·
side effects before validation · overly-broad type checks · undocumented extra artifacts
(disclose them) · monolithic god-classes (design nit). (Full rules: `rules/solution-writing.md`.)

## D. Test flags

Compile-fail on base (interface-information ERROR) · internal class names / `Class.forName` ·
pinned unspecified serialization order · sync assertion over an async base path · network/timing
flakiness · guessable test filename collisions · `-mod=vendor` · tests that under-enforce ("what
wrong implementation still passes?" — the reviewer will ask; have an answer per fork). (Full
rules: `rules/test-writing.md`.)

## E. QA-audit flags (the annotation auditor)

Prime directive: every backticked token, file:line, quoted prompt sentence, quoted step_id, and
every asserted effect/mechanism must be literally verifiable in THAT run's own artifacts.
Top killers: backticked `file:line` (write plain text, verified against the real repo file) ·
tokens not literal in that run's artifacts · JUnit expected/actual quoted as one token · ellipsis
or placeholders inside backticks · absolutes broader than evidence (never/only/exactly/disjoint) ·
effects the junit lines don't show · partially-true enumerations · incomplete mechanisms ·
step_ids that don't resolve · cross-run references · invented eval-result fields · interpretation
asserted as fact (label it) · em-dash connectives, template openers, copy-paste identical
annotations across tests. (Full operating manual: `rules/qa-authoring.md`.)

## F. The meta-rules

1. **A flagged instance is a flagged CLASS.** The audit samples; if one file backticked a
   file:line, they all did. Sweep the class across every artifact, not the instance.
2. **All-fail-for-one-reason = task fault until proven otherwise.** Analyze before brute-forcing
   agents at it (the platform says exactly this). Conversely all-pass = too easy; same discipline.
3. **Warnings are advice, mandates are mandates.** A precheck WARNING may be declined with
   justification when complying would pin a free choice (we did, correctly, for textual-assertion
   suggestions); a fairness FAIL is always fixed.
4. **Never edit platform output files** (`*-qa-audit.json`, check reports). Fix the source.
