# state-ownership-lifecycle-is-the-shape

**The only task shape ever to meet the diamond rollout bar: persisted STATE with an ownership
rule and a lifecycle reconciled across runs/processes — because ONE architectural commitment then
gates most of the suite, which is exactly what partial-reward medians require.**

## Evidence (as of 2026-06-10)
- `sorg-newsletter-delivery-snapshots` (accepted, 10% pass — the only sub-0.4 task): strong
  agents landed at 12-17/19 tests (scores 0.63-0.89); only 1/10 reached 1.0. The failures were
  CASCADES, not edges: a path-canonicalization mistake alone took 5/19 tests; wildcard-delete /
  in-memory-ownership mistakes took 2-7 each. Freshness was multidimensional (source + view +
  layout + partials + render mode); ownership had to survive fresh processes.
- Fairness held because every cascade traces to stated clauses ("only the snapshots that a
  previous successful build wrote"), and two genuinely different faithful implementations passed
  (reference's `.snapshot.json` sidecar vs a passing agent's in-file fingerprint marker).
- The contrast class: scattered micro-test suites (semantic-tokens' 74 independent asserts) cap
  thorough agents at ~0.97 regardless of edge difficulty.

## Applies at
W0 seam hunting, W1 idea selection, W3 score-geometry test design.

## Rule it shaped
`rules/task-shape.md` §1-3 (STATE shape + score geometry), `rules/repo-selection.md` §2.

## Refined 2026-06-25 — STATE is NECESSARY, NOT SUFFICIENT (two failure modes added)

The original framing ("STATE is the only shape to MEET the bar") risks reading as "STATE → likely
Diamond." Two same-day kills on membrane/api-gateway show STATE can still fail, for two distinct
reasons — screen for BOTH before building:
- **Volume** ([[state-shape-predicts-cascade-not-volume]]): a STATE core that is pure bookkeeping
  (keyed store + branches + a hash) is implementation-thin (idempotency: full-depth 6-fork build =
  160 eff LoC). STATE predicts the cascade, not the volume; volume needs an inherent algorithm.
- **Ceiling** ([[well-known-spec-features-are-ceiling-bound]]): a STATE core whose algorithm IS a
  published spec (RFC/protocol/named algorithm) is ceiling-bound even with a real cascade AND real
  volume (http-cache: 53% Gate-A cascade, ~719 LoC, yet a desc-only gauntlet built it 25/25 first
  run). A fair description of a known standard telegraphs the implementation.

Unchanged: the newsletter evidence (STATE that is NOT a published spec AND carries real algorithm —
path-canonicalization + multidimensional freshness — remains the one shape that met the bar). The
selection screen is now: STATE **+ inherent non-standard algorithm + no published-spec core** →
run the W1 gauntlet to confirm before building.
