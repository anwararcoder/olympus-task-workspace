# Task Shape — the selection doctrine (read before ANY idea work)

This is the highest-leverage rule in the system. Every dead or painful task we have built was
killable at selection time with the tests below. They are MEASURED conclusions, not theory — each
carries the task that proved it.

## 1. The READ / EDIT / STATE pre-screen (mandatory, first question)

Every candidate feature is one of three shapes. Classify it before anything else.

- **READ** — computes output from data a framework already resolved (an LSP feature backed by
  javac, a formatter walking a parsed AST, an exporter over a typed model). **REJECT for Diamond.
  No exceptions.** Measured: `java-semantic-tokens` — 11 iterations, every fair lever tried, three
  independent 3/3 = 1.00 rollout batches; `java-call-hierarchy` — same wall, shipped only by
  downgrading to normal Olympus. When the framework hands over the answer, a thorough agent
  implements the full stated contract and scores ~1.0. Fair forks catch only WEAK agents;
  de-telegraphing is inferred away; LoC/fork-count/test-count change nothing — the CORE is a read.
- **EDIT** — produces a code/content change bound by a GLOBAL property it must preserve (still
  compiles, behaves identically, every reference stays consistent). The property couples local
  decisions into a cascade: do X → Y breaks → fixing Y conflicts with Z. Eligible when the cascade
  is real (`java-move-class-to-package`, accepted 20%, ~1100 LoC). The strongest EDITs are ones
  where wrong output still COMPILES but means something different (semantic preservation).
- **STATE** — owns PERSISTED state with an ownership rule and a lifecycle that must reconcile
  across runs/processes/components: what to keep, what to delete, who owns it, what is stale.
  This is the only shape that has ever met the diamond rollout bar
  (`sorg-newsletter-delivery-snapshots`: 10% pass, strong agents landing at 12–17/19 because ONE
  design commitment — durable ownership + multidimensional freshness — gates most of the suite).
  **CAVEAT (`state-shape-predicts-cascade-not-volume`): STATE predicts the CASCADE/ceiling, not the
  VOLUME.** A STATE core that is pure BOOKKEEPING — keyed store + state transitions + a hash + a few
  reject branches — is implementation-thin because the framework primitives collapse it (idempotency:
  a full-depth 6-fork build measured 160 effective LoC vs the ~850 floor). VOLUME needs an inherent
  ALGORITHM (parser, recursion, freshness/age math, canonicalization, multi-axis reconciliation).
  Newsletter had that (path-canon + multidimensional freshness); idempotency did not. Screen at
  selection: *algorithm, or just storage+branching?* — recognition-difficulty adds ceiling, not LoC.
  **CAVEAT 2 (`well-known-spec-features-are-ceiling-bound`): even a STATE core with a real algorithm
  is CEILING-bound if that algorithm IS a published spec (an RFC, a standard protocol, a named
  algorithm).** A FAIR description must state the contract clearly, and a clear statement of a
  standard the model already knows telegraphs its own implementation — there is no "intuitive design
  is wrong" property when the intuitive design IS the standard. Measured: `api-gateway-http-cache` — a
  desc-only W1 gauntlet built a complete RFC-9111 response cache (key+Vary secondary-key, freshness
  age-math, 304/200 revalidation, directives), 25/25 tests passing on the first run, despite a 53%
  Gate-A cascade and ~719 honest LoC; KILLED at Gate C. Screen at selection: *is the core a standard
  the model has seen?* If yes, difficulty must come from a repo-specific twist where the obvious
  (standard) design is WRONG — not from re-implementing the standard — and the W1 gauntlet must
  confirm it before any build.

Pre-screen verdict: **STATE > cascade-EDIT >> everything else. READ is dead on arrival.**
Variants of READ in disguise: "compute-and-emit" (transforms input→output in one pass, no owned
state — `sorg-search-index` before its rescue), and "leaf value" (a value with no derived state, no
cache, no downstream consumers — `osctrl-secret-rotation`, breadth-capped, eventually reverted).

## 2. Score geometry (new, mandatory — exists because of partial reward)

The diamond gate scores the FRACTION of tests passed (`rules/platform-bar.md`). Suite topology
therefore determines the achievable score range BEFORE difficulty is even considered:

- **Scattered micro-tests** (one assert-cluster per edge): a strong agent that misses an edge loses
  1–2 tests → scores 0.95+. This topology CANNOT produce a sub-0.6 median no matter how hard the
  edges are. (semantic-tokens: 74 micro-tests, ceiling 0.97–1.00.)
- **Cascade-coupled tests** (most scenarios route through the owned state / the global property):
  one wrong design commitment fails a CLUSTER. (newsletter: a path-canonicalization mistake alone
  took out 5 of 19 tests; ownership-tracking mistakes took out 2–7; strong agents landed at
  0.63–0.89 and only 1/10 reached 1.0.)

**Design requirement: the hard core must gate >50% of the suite.** Ask of every planned test: "if
the agent gets the central design commitment wrong, does this test fail?" If under half say yes,
the suite cannot reach the bar. Fairness guard: coupling must run through STATED requirements —
every failing test must still map to a prompt clause on its own (the auditor checks per-test, and
"uniform failure on a fork with a reasonable alternative reading" is graded a defect).

## 3. The seven properties of accepted work (the positive sense)

1. Sits on a seam that ALREADY EXISTS in the repo (newsletter: the build/send render split;
   move-class: the `rewrite/` package). If you cannot name the base subsystem it extends, it is
   grafted, and grafted features generate fairness flags forever (carve-integrity's operator
   endpoint).
2. Difficulty DISTRIBUTED across 4+ independent concerns, each failing DIFFERENT tests in
   different runs — never one shared gotcha.
3. The intuitive implementation is ARCHITECTURALLY WRONG; only a repo-aware design survives. The
   wrongness must be discoverable (the test surface / repo signals the right design), never an
   arbitrary constant.
4. Tests assert the observable CONTRACT; two genuinely different faithful implementations both
   pass (newsletter: sidecar vs in-file marker — both passed).
5. Description = natural behavioral prose stating OUTCOMES; zero mechanism hints; every clause
   load-bearing; one misleading word is a BLOCKING defect (atom-media's "still").
6. Every agent failure maps to an explicit-or-inferable requirement. No environment friction.
7. Reference solution substantial, idiomatic, dead-code-free; LoC is an OUTPUT of forks, never a
   target you pad toward.

**The matchstick test (volume comes from depth, never padding).** One feature that touches every
component creates unavoidable complexity: a hard task forces changes across parsing/tokenizing →
AST → compiler/CFG → VM/eval → type/validation → scope/state → object model — each layer
constraining the others. Single-layer features are easy for agents. Ask: does this matchstick touch
all the others? If it touches one, the honest LoC is thin (`estimates-run-40pct-optimistic`).

**The professional-path rule.** Most ideas have a workaround that covers the common cases. We do NOT
build to the workaround and defend it with valid-but-weak points — we build the complete, roots-deep
solution that handles every edge, and we validate THAT. If the easy path covers 80% of the tests,
the idea is too easy (a selection failure), not a thing to patch with trap tests.

**Quick green/red scan (necessary, not sufficient).** Green: multi-component needing investigation ·
undocumented behavior in real use · features needing scope/state/lifecycle · no public PR/blog/SO
answer. Red: solution describable in one sentence · single-file fix · a known pattern ("add a null
check", "use a WeakSet") · a "good first issue" · an existing blog/StackOverflow solution.

## 4. The anti-patterns (each killed or bled a real task)

(a) **LoC as input** — breadth = fairness surface, not difficulty (carve: 7 behaviors → a new
    fairness coin-flip every round). (b) **Fork contradicting base behavior** (secret-rotation's
    freshness clause vs a documented 2h TTL — instantly unfair). (c) **Arbitrary-constant /
    unobservable fork** (carve's "three failed attempts"). (d) **Leaf value** (secret-rotation).
(e) **Compute-and-emit** (search-index pre-rescue). (f) **Natural home untestable by
    base-symbols-only tests** — daemon loop / async goroutine / background thread (carve's founding
    disaster: 34/34 built reclamation correctly in the daemon, 0/34 passed). (g) **Compiler-assisted
    READ** (semantic-tokens, call-hierarchy — see §1). (h) **Wall fork** — a behavior ~no agent
    produces (0/N castor + ~1.0 rollouts is the fingerprint; remove it, don't defend it).

## 5. The kill questions (run as a gauntlet; one honest "yes" = keep crafting or kill)

1. Is it a READ, compute-and-emit, or leaf value? (§1)
2. Would the naive/simple version pass 80%+ of the planned tests?
3. Do the "independent" forks collapse into one insight ("add a parameter" six ways)?
4. Is any fork an arbitrary constant, unobservable, spec-open, or contrary to base behavior?
5. Does the natural home need a daemon/async path a base-symbols test cannot drive?
6. Does a well-known pattern give agents a head start WITHOUT a repo twist that actively misleads?
7. Does the hard core gate <50% of the planned suite? (§2)
8. **(VOLUME)** After the core insight, is each fork a 10–30-line branch the repo's primitives make
   trivial? Then the honest sum is thin (encapsulate-field: 8 forks, 451 LoC). The cure is a stated
   CONSTRAINT that forces a real algorithm (the codeforces principle), not more small branches.
9. **(VOLUME)** Is the LoC an estimate rather than a number MEASURED by building the hardest fork
   in a worktree? Estimates run ~40% optimistic. An unmeasured number is fiction.
10. Could a THOROUGH, persistent, opus-tier agent — assume it reads everything, writes its own
    tests, and infers de-telegraphed principles from first principles — implement the full stated
    contract? If yes for the CORE, the rollout median will be ~1.0 regardless of edges.
11. **(TWO-PART CEILING — both must clear.)** First: is the core algorithm computed by the
    framework/compiler and handed over (compiler-assisted READ)? Second — even if the algorithm is
    compiler-WITHHELD — is it one the MODEL itself already knows (a named refactoring, a textbook
    analysis like liveness/dataflow, a published spec)? If yes, a FAIR description telegraphs it and
    the ceiling is ~1.0 anyway: the moat hides the algorithm from the compiler, not from the model
    (`famous-refactoring-ceiling-survives-the-moat`: java-extract-method KILLED at W2 — a
    zero-context gauntlet built the full liveness contract, incl. the two-live-out and control-escape
    rejections, from the description alone). The only rescue is a repo-specific twist where the
    obvious KNOWN design is wrong AND the wrongness is discoverable unstated — and a deepener that is
    a MORE-obvious design (record-return for multi-output) adds LoC, not ceiling.

## 6. Two empirical gates that replace optimism (details in `workflows/`)

- **Naive-agent gauntlet** (local, before any platform spend): give a FRESH strong agent only the
  draft description + repo; watch where it struggles. If it cruises through the core, the idea is
  dead — no amount of test cleverness will resurrect it. (`workflows/w1-craft-idea.md`)
- **Difficulty preflight** (platform, before the full build): minimal vertical slice containing the
  difficulty CORE → run Diamond Checks rollouts → read the trajectories. Strong agents cruising =
  KILL or DEEPEN now, at slice cost, not after 1000 lines. (`workflows/w2-difficulty-preflight.md`)

A single low rollout batch is not validation either way — read trajectories, not just scores.
