# Test Writing — score geometry, seam legality, and the fairness traps

Counts and floors: see `rules/platform-bar.md`. Structure beats count: with partial reward, suite
TOPOLOGY decides the achievable score range before difficulty even matters.

## 1. Score geometry (design the suite top-down)

Design scenarios so the hard core gates >50% of tests (`rules/task-shape.md` §2). Concretely:
- Prefer **lifecycle scenario tests** (build → mutate → rebuild → observe; send-after-build;
  fresh-process re-run) over per-edge micro-asserts. One wrong design commitment must fail a
  CLUSTER. (newsletter: a path-canonicalization bug alone took 5/19 tests.)
- Keep a layer of independent edge tests too — they make failures ATTRIBUTABLE and the failure
  spread fair across runs. The mix: core-coupled majority + attributable edges.
- Fairness guard on coupling: each test must still map to a stated clause ON ITS OWN, and a
  uniform 100%-fail test is a wall (castor 0/N + rollouts ~1.0 fingerprint) — remove walls.

## 2. Seam legality (the carve rule — audit BEFORE writing assertions)

Every observable must be reachable from **base-commit symbols only**, through a **synchronous**
entry point. Tests compile on base and fail at RUNTIME there (a compile failure on base is the
"interface information" auto-review ERROR — the agent would be forced to guess your internal
names). Mechanics:
- Drive new behavior through EXISTING handlers/commands/methods; send raw JSON rather than
  constructing new request structs; read state through existing fields, files on disk, HTTP
  responses, rendered output, or raw DB selects — never a field/class the solution adds.
- New enum constants, struct fields, status strings: assert the literal serialized value, not the
  new symbol. (Java: reach solution-only behavior via reflection so the file compiles on base.)
- If the natural observable lives in a daemon loop / goroutine / background thread — STOP; that is
  an idea-shape failure (carve's 0/34), not something to hack around in the test.
- Wire-level harnesses (LSP JSON-RPC framing, HTTP) are the gold standard: they bind to protocol
  field names, so no internal DTO is load-bearing and any faithful implementation passes.
  Never `Class.forName` an internal param type (a call-hierarchy fairness block).

## 3. Assertion discipline (each item here failed a real submission)

- **Never pin an unspecified serialization**: modifier/bitset render order, map/JSON key order,
  list order the contract leaves free → sort to canonical form or compare sets.
- **Never assert spec-open choices**: "smallest" delta edits, which modifiers a constructor name
  carries, import-statement-site tokens — if the spec/prompt leaves it open, a correct agent may
  diverge.
- **Never require hidden internals knowledge** (javac models a record component as 3 elements;
  asserting "one token" failed Test-Fairness). If it's not in the prompt or discoverable in the
  repo, it's unfair.
- **Async base paths**: if the base handles X asynchronously (`go ...`), don't assert a
  synchronous response flag — assert SETTLED state (poll/waitFor the persisted effect) so sync and
  async faithful solutions both pass.
- Exact-string asserts only for description-quoted contracts; contains-style for everything else.
  Accept thrown-or-returned errors both. Two genuinely different faithful implementations must
  pass — prove it by imagining (or building) the second one.
- **`contains` is NOT automatically fair on GENERATED CODE.** A substring assert that encodes a
  free RENDERING choice — modifier order (`private static `), call qualification/spacing
  (`n = compute(` vs `this.compute (`), method-insertion placement — is unfair even as "contains",
  because a faithful impl renders it differently (java-extract-method: 10 such asserts flagged after
  passing earlier rounds). For STRUCTURAL properties of synthesized code (static-ness, return type,
  parameter set, private, sibling), COMPILE the edit and assert via REFLECTION
  (`Modifier.isStatic`, `getReturnType`, `getParameterTypes`), not source text. Reserve substring
  asserts for tokens the description QUOTES (a command id, the user-supplied name) or the compiler
  FORCES (`throws IOException` on a body that throws it uncaught). The W4 sweep must enumerate EVERY
  `containsString` and classify each as quoted-contract/compiler-forced (keep) vs spec-open-rendering
  (convert to reflection) — "no emitted-source assertions" is a claim to verify line-by-line, not assume.
- **Dump-then-assert**: never hand-write expected coordinates/values; run the reference, read the
  actual output from failures, paste it back. Hand-derived expectations drift.
- **Distractor fixtures** convert string-matchers into semantic implementations (move-class's
  local variable named like the moved type; newsletter's slug-shaped user file `200-notes.html`).
  Give every suite at least one.
- Deterministic: no network, no timing luck, no ordering dependence between tests. Known flaky
  base tests get skipped via Dockerfile ENV (record the recipe in the repo dossier).

## 4. Fork independence — prove by ablation

One injected one-line bug in the reference must break exactly one fork's tests; no single fix may
clear two forks. Ablation, not intuition, is the proof of "independent". (carve's distributed-fork
restoration was validated exactly this way.)

## 5. Trap taxonomy (design the trap before the code; pick by what a naive impl gets wrong)

| Trap type | Pattern | Why it works |
|---|---|---|
| Scope resolution | inner binding shadows outer | naive linear search resolves to the wrong one |
| Branch isolation | only the taken branch's effects are observable | retrospective/global lookup over-reports |
| Timing semantics | build-time vs parse-time vs call-time | agents conflate the phases |
| State persistence | values must restore/clean up after an operation | agents forget the teardown |
| Kind preservation | metadata must survive a transform (free var, copy) | the transform silently drops it |
| Order-dependent | a later default/step references an earlier one | parallel/unordered eval fails |

Worked examples: order-dependent default `[a, b = a+1] := [10]` → `b==11` (sequential binding, not
parallel); kind preservation `func(x){ func(){ return x }() }` → inner `x` keeps the param flag
(naive `defineFree()` loses it). Prefer ONE test combining scope + reassignment + control flow over
many single-axis permutations (intersection traps > repetition).

## 6. Mechanics

Distinctive test filename with a random token (`{feature}_{4-6 hex}_test.go` /
`Feature_{hex}_Test.java`) — the platform predicts likely solver filenames and flags collisions.
One file per package. Match repo test style; comments at repo density only. `test.sh` per
`templates/test-sh.md`: executable 100755, `--output_path` JUnit XML, `base`/`new` modes, no
`--bail`, no dependency installs, never `-mod=vendor` (agents corrupt vendor → FAIL_TEST_BROKEN on
us).

**Go build-tag isolation** — keep new tests off the base build so they compile-on-base but don't run
there:
```go
//go:build featurename

package pkg_test
// reference ONLY base-commit symbols; the test compiles on base and fails at runtime (behavior absent)
```
`test.sh new` then runs `-tags=featurename`. (Java has no build tags — reach solution-only behavior
via reflection so the file still compiles on base.)
