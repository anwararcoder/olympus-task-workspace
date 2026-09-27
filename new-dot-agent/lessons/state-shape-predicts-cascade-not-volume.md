# state-shape-predicts-cascade-not-volume

**The STATE shape predicts CASCADE quality (the rollout ceiling), not VOLUME. A STATE feature whose
core is *bookkeeping* — store + branch + fingerprint, with no inherent algorithm — is
implementation-thin, because the framework primitives collapse every fork to a few lines. Volume
needs an inherent ALGORITHM (parser, recursion, planner, canonicalization, multi-axis
reconciliation). Screen for algorithm-content at W0/W1, not just state-ownership.**

## Evidence (as of 2026-06-25)
- `api-gateway-idempotency` (Membrane): a textbook STATE cascade — per-key state-machine record,
  capture/replay (streaming-trap-correct independent byte copy), thread-safe in-flight CAS, SHA-256
  request fingerprint, method+target scoping, 422/425. Built at FULL depth in a W2 slice and proven
  complete + genuinely hard: S3 14/14 green, S2 **8/10 fork tests fail on the base stub** (the
  cascade bites). **Measured Gate B = 160 effective LoC** (generous non-blank incl. headers ~260)
  vs the ~850 honest target / ~700 floor (`rules/platform-bar.md`) — a **>5x shortfall**. KILLED on
  volume at the cheapest point (local Gate-B measurement, zero platform spend); gauntlet/rollouts
  were correctly NOT run (the size gate is independent of and prior to the ceiling).
- The owner's plan estimated 650-800 effective; the honest build was 160 — **~4x optimistic**, worse
  than the usual ~40% (`estimates-run-40pct-optimistic`), because Membrane/JDK primitives are
  exceptionally terse: Guava `Cache.asMap()` = the whole thread-safe store + in-flight CAS in ~6
  lines (`putIfAbsent`/`replace`/`remove`); `ResponseBuilder` + `new Header(h)` + `setBodyContent`
  = streaming-correct capture/replay in ~10; `MessageDigest`+`HexFormat` = fingerprint in ~12;
  `ProblemDetails` = 422/425 in ~5.
- Consistent with `java-encapsulate-field` (8 forks, recognition-hard, honest build 451 — "each fork
  a 10-30-line branch the JDK's primitives make trivial"). Idempotency is the same class, intensified.
- **Contrast — the only sub-0.4 task had ALGORITHMIC state-content:** `sorg-newsletter` carried path
  canonicalization, multidimensional freshness (source+view+layout+partials+render-mode), and
  ownership-scoped cleanup — computation, not just storage+branching. That is why it had both the
  cascade AND the volume. STATE was necessary; the ALGORITHM supplied the LoC.

## The screen (apply at W0 seam inventory + W1 Gate A/B, before building)
Ask of every STATE candidate: **does the core contain an ALGORITHM, or just storage + branching?**
- Algorithm present (recursive cost, RFC parser, freshness/age math, canonicalization, multi-axis
  reconciliation, planner) → volume is plausible; measure it (Gate B).
- Bookkeeping only (keyed store + state transitions + a hash + a few reject branches) → honest
  volume is thin REGARDLESS of how hard the design is to RECOGNIZE; recognition-difficulty adds
  ceiling, not LoC. Expect a Gate-B kill; either find an in-contract algorithm to add, or pick a
  different seam. Do NOT pad (config-children, durable stores needing untestable fresh-process
  boundaries, header-fidelity that overlaps a sibling idea) — padding catches zero agents and the
  reviewers reject it.

## Applies at
W0 seam inventory (classify STATE seams by algorithm-content, not only state-ownership), W1 Gate A/B
(the volume screen above), W2 (this kill was a clean Gate-B measurement before any platform spend).

## Rule it shaped
`rules/task-shape.md` §1 (STATE definition gets the bookkeeping-vs-algorithm caveat) + §5 kill
question 8 (VOLUME); `rules/idea-crafting.md` Gate B (the algorithm screen); `rules/repo-selection.md`
§2 (seam inventory notes that bookkeeping-STATE seams are thin). Extends
[[estimates-run-40pct-optimistic]] and refines [[state-ownership-lifecycle-is-the-shape]].

_n = 1 fully-measured case (idempotency) + 1 strong analog (encapsulate-field) + the newsletter
contrast. A prior to apply, strengthened if the parallel `api-gateway-http-cache` spike (algorithmic
STATE) clears volume where idempotency (bookkeeping STATE) did not._
