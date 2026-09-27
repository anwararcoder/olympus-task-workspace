# well-known-spec-features-are-ceiling-bound

**A feature whose CORE is a published / well-known specification (an RFC, a standard protocol, a
named algorithm) is ceiling-bound for Diamond EVEN WHEN it is STATE-shaped — because a FAIR
description must state the contract clearly, and a clear statement of a standard the model already
knows telegraphs its own implementation. STATE shape is necessary but NOT sufficient.**

## Evidence (as of 2026-06-25)

- `api-gateway-http-cache` (membrane/api-gateway), KILLED at W1 Gate C (naive-agent gauntlet), before
  any platform spend. The idea was textbook-STATE: a cross-request response cache with a freshness
  lifecycle + backend revalidation reconciliation (RFC 9111). Gate A passed on paper (central
  entry-model commitment cascades ~53% of a ~32-test suite); Gate B passed (real volume — the
  faithful reference measured ~719 eff LoC, clearing the bar). But Gate C was decisive: a fresh
  strong agent given ONLY the description built a complete RFC-9111 cache (5 classes, ~719 eff LoC,
  25 own tests) that **passed all 25 on the first full run**, correctly implementing EVERY cascade
  fork — `(method,target,Vary)` secondary-key, independent `byte[]` body capture, freshness from
  max-age/Expires/Date/Age with an injected clock it rediscovered on its own, 304-refresh /
  200-replace revalidation, and no-store/no-cache/private. It self-rated HIGH confidence on every
  CORE requirement; only EDGE scope-reductions (status>200, heuristic freshness, 304 header-merge)
  were left at MEDIUM — 1-2-test clusters worth ~0.05 each under partial reward, never a cascade.
- The mechanism: HTTP caching's difficulty CANNOT live in "which headers/rules matter" (stating them
  is required for fairness; hiding them is the ambiguity killer). So a fair description enumerates the
  contract, and a thorough agent who already knows RFC 9111 just implements it. There is no
  "intuitive design is architecturally wrong" property — the intuitive design (the RFC) IS correct.
- This is the same ceiling fingerprint as the compiler-assisted READs
  (`read-features-hit-the-ceiling`: semantic-tokens 3x1.00, call-hierarchy) and the same root as
  `over-clarity-vs-ambiguity` — but here the over-clarity is FORCED by the spec being well-known, not
  a wording slip. n=1 for the STATE-but-well-known-spec angle (the cache), but it sits inside a
  3+-task ceiling pattern; treat as a strong prior + a mandatory gauntlet check, not yet a hard gate.

## The cheap test that caught it

The W1 naive-agent gauntlet (`workflows/w1-craft-idea.md` Gate C): give a fresh strongest-model
session ONLY the draft description + repo. If it builds the core correctly with little struggle
(here: 25/25 first run, HIGH confidence on all core reqs), the rollout median will be ~1.0 — KILL or
downgrade NOW, at slice cost (~1 session), not after a full build + QA. This is exactly the
semantic-tokens/secret-rotation pain the gauntlet exists to prevent.

## Deepen does not escape it (by adding more recalled surface)

Adding more of the SAME standard's RECALLED surface (request directives, heuristic freshness,
invalidation) adds telegraphed-but-easy tests → RAISES rollout scores. Grafting a non-standard
owned-state axis (multi-instance coherence, cross-store coupling) draws fairness flags (the carve
grafted-endpoint failure) while staying thorough-agent-solvable.

## Escape route (refinement 2026-06-26): find the spec's DERIVE-not-recall corner

A well-known spec is not uniformly recalled. The codeforces principle applies: a small problem
change that targets the standard's OBSCURE, algorithm-forcing corner — the part a strong agent must
DERIVE rather than recall — does raise the bar. For `api-gateway-http-cache` the corner was RFC 9111
§3.3-3.4 **partial-content accumulation**: the stored representation becomes a coalescing
byte-interval accumulator (merge-intervals + coverage + validator-scoped combining + unknown-length
+ multipart/byteranges). A 2nd gauntlet on the deepened description still built the basic cache but
SKIPPED multi-range and was uncertain on unknown-total — evidence the corner is derive-not-recall.
Calibration honesty: this reliably clears the OLYMPUS floor (weak/mid agents fail the interval
algorithm) and is a Diamond CANDIDATE, but a strong Opus agent may still derive it (interval
coalescing is LeetCode-medium), so Diamond is not guaranteed — the platform rollouts decide. The
rule for selection: if the core is a published spec, either reject for Diamond OR locate its
derive-not-recall corner and confirm with the W1 gauntlet (and expect strong-Olympus, not certain
Diamond).

## Applies at

W0 seam classification (flag a seam whose core is a named standard), W1 idea selection +
knowledge-transfer table + Gate C, W2 decision.

## Rule it shaped

`rules/task-shape.md` §1 (STATE bullet gains the "necessary-but-not-sufficient / well-known-spec"
caveat + a kill-question). Refines `lessons/state-ownership-lifecycle-is-the-shape` (STATE is the
only shape to MEET the bar, but a published-spec STATE is still ceiling-bound). Sibling of
`lessons/read-features-hit-the-ceiling`, `lessons/over-clarity-vs-ambiguity`.
