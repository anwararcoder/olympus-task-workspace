# Repo Selection — pick repos by SEAM SHAPE, not by stars

A bad repo choice is unfixable downstream: it caps every idea you will ever craft on it. Evidence:
`java-language-server` met all the hygiene criteria (stars, license, rich packages, test infra) and
still consumed FOUR task attempts (semantic-tokens, call-hierarchy, inlay-hints, encapsulate-field)
that all hit the same wall — because an LSP server backed by javac is structurally a READ machine.
Meanwhile `sorg` — a one-maintainer blog generator — produced the only task that ever met the
diamond rollout bar, because its build/send/cleanup lifecycle owns persisted state.

## 1. Hygiene gate (necessary, fast, NOT a predictor)

See `rules/platform-bar.md` for license/stars/language facts. Plus:
- **Deterministic, offline test suite.** Clone it and RUN the full suite twice in a clean container
  before committing: no network at test time, no flaky timing tests (or a known, skippable list),
  no root requirement. A repo whose tests need network or wall-clock luck will produce
  FAIL_TEST_BROKEN fairness violations months later (we carry Dockerfile skip-lists for two flaky
  osctrl base tests to this day — budget for that, or walk away).
- **Buildable in the platform's base image** with a pinned toolchain, offline deps cacheable.
- **Moderate popularity** (~500–5000 stars). Too famous → every feature has public discussion/PRs
  (plagiarism/duplicate risk) and giant-org backing; too obscure → reviewers question repo quality.
- **Language** — hygiene accepts what ships in practice (Go, Java). As an idea-difficulty intuition,
  agents struggle more in lower-level/stricter languages (rough order Rust > C/C++ > Go > Java > TS >
  Python > JS), and Java's verbosity makes hitting the LoC depth natural — but shape (READ/EDIT/STATE)
  dominates language every time; never pick a language to manufacture difficulty.
- The ">20 maintainers" heuristic is DROPPED. sorg is essentially one maintainer and is our best
  repo. What maintainer count was proxying for — idiomatic, well-tested code — test directly.

## 2. The seam inventory (the actual predictor — do this BEFORE committing to a repo)

Spend a session enumerating the repo's candidate feature seams and classifying each as
READ / EDIT / STATE per `rules/task-shape.md`. The repo is eligible only if the inventory contains
**at least 2 STATE-shaped or cascade-EDIT-shaped seams** that are also testable (see #3).

What STATE seams look like (hunt for these):
- **Persisted artifacts with a lifecycle**: build outputs, caches, snapshots, manifests, indexes,
  exports — anything written to disk in one run that a later run must trust, refresh, or clean up.
  (sorg-newsletter: web pages rendered at build time, email re-rendered at send time — the drift
  seam IS the task.)
- **Two subsystems that compute the same thing independently** (drift), or a fast path and a slow
  path that must agree (cache coherence).
- **Cross-process boundaries**: CLIs invoked repeatedly, daemons with on-disk state, migration
  steps, sync/replication, upload sessions with resumability.
- **Ownership questions**: directories shared between tool-generated and user-placed files; cleanup
  that must delete only what it owns.

What cascade-EDIT seams look like:
- The repo transforms/refactors code or content under a global correctness property (output must
  compile / render identically / stay consistent across files), AND the repo already hosts a family
  of such transforms so a new one is a sibling, not an invader (move-class lived in `rewrite/`).

Automatic red flags for the whole repo:
- The interesting work is done by a framework/library the repo merely drives (a compiler, an ORM,
  a protocol library) → everything will be a READ.
- All long-running behavior lives in daemons/goroutines with no synchronous entry point → the
  natural features are untestable by base-symbols-only tests (carve-integrity's founding disaster).
- Tests are thin/missing → you will fight infra, and reviewers will distrust the baseline.

## 3. Testability check per seam (15 minutes each, saves months)

For each candidate seam answer in writing:
1. What SYNCHRONOUS, base-named entry point drives it? (existing handler/CLI command/public method)
2. What base-readable state observes it? (files on disk, HTTP responses, rows, rendered output)
3. Can a test that references ONLY base-commit symbols compile on base and fail at runtime there?
If any answer is "a daemon loop", "an internal class the solution adds", or "you'd have to wait for
a background thread" — the seam is mis-shaped; drop it now.

## 4. Output: the repo dossier

Write `my-work/_repos/{repo}-dossier.md` containing: hygiene-gate evidence (suite run twice, green,
offline), the seam inventory table (seam → shape → entry point → observable → verdict), known flaky
tests and their skip recipe, toolchain pins (exact JDK/Go version, build flags, heap limits, build
time), and the 2+ surviving STATE/EDIT seams ranked. This dossier is the input to
`workflows/w1-craft-idea.md` and is reused for every task on the repo — keep it updated as you
learn (flaky tests discovered later go here, not in chat history).

## 5. Portfolio rule

Run 2–3 repos in parallel at the dossier level before building anything: ideas compete across
repos, not just within one. When a repo's surviving-seam list is exhausted (java-language-server
after move-class), RETIRE it for Diamond explicitly in the dossier rather than mining it for
weaker and weaker ideas — the four java-LS read attempts are the cost of not doing this.
