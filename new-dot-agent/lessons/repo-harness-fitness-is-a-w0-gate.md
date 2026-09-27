# Repo harness-fitness is a W0 gate (the harbor oracle needs a deterministic, isolation-safe, offline suite)

**Stage:** W0 repo selection / dossier (MANDATORY screen, before ANY idea or build).
**Rule it shaped:** `rules/task-shape.md` selection doctrine — add a repo-fitness pre-screen that is
independent of, and prior to, the READ/EDIT/STATE idea screen. A perfect task on a harness-hostile
repo scores zero.

## The rule

Before investing in a repo, prove its EXISTING test suite is compatible with the platform's grading
harness. The platform's **harbor oracle** (the `verify-solution` gate) does not just check f2p/p2p —
it runs the base suite **twice** (test-patch-alone, then +solution) and the diff must equal
**exactly** the solution's tests. That requires the rest of the suite to be **deterministic across
two runs in the grading environment**. Three properties must ALL hold, and each is a one-command
check at W0:

1. **Offline-clean** — the suite runs green with no network (hermetic, `--network none`). Red flag:
   tests that dial external hosts or need servers (Elasticsearch, Memcached, a real HTTP endpoint).
2. **Deterministic** — run the offline suite TWICE and diff the per-test outcomes; they must be
   identical (zero flips). Stress it: perturb the classpath/order between the two runs (adding any
   new class, as a solution would, changes class-discovery order). Red flag: any test flips.
3. **Isolation-safe** — the suite runs green with `-DreuseForks=false` (a fresh JVM per test class).
   Red flag: errors appear, meaning tests share JVM state or rely on a monolithic aggregator.

If any check fails, the repo is harness-hostile: **reject it, or expect the harbor oracle to be
unsatisfiable no matter how good the task is.**

### The biggest red flag: a monolithic `@Suite`

If the repo runs its whole test set through one JUnit `@Suite` class (`@SelectPackages(...)` executed
in a single JVM), it is almost certainly order-dependent and not isolation-safe. One `@Suite` class =
one surefire fork = thousands of tests sharing one JVM, in a discovery order that varies by
filesystem/classpath/environment. That is the textbook setup for non-determinism the oracle rejects.

## Evidence (api-gateway / Membrane, 2026-06; base 2a37283)

Two tasks were built on `membrane/api-gateway`: `api-gateway-http-cache` and
`api-gateway-graphql-cost`. Both consumed enormous time and BOTH were rejected — not for task
quality (http-cache reached 7/8 task-quality; verify-tests, env-quality, and all solution/test
mechanics were green), but because the repo is harness-hostile in three escalating ways:

1. **Heavy multi-module offline build** (Spring Boot `distribution`/`war` fat-jars) — a full-reactor
   `mvn install` hung ~1h on the platform builder. Fixed by priming only what's needed.
2. **Network/external-service tests** in the default suite (`Http2ClientTest.getGoogleHomepage`,
   `ElasticSearchExchangeStoreTest`) — fail in the hermetic sandbox. Fixed by exclusion.
3. **Non-deterministic, order-dependent, not-isolation-safe suite** — UNFIXABLE. The repo runs
   ~3,500 core tests through one `UnitTests` `@Suite` in a single JVM. The harbor oracle's two runs
   (test-patch-alone vs +solution) produced a diff of **65** fail-to-pass tests: the 57 real cache
   tests **plus 8 unrelated OpenAPI tests** (`AbstractArrayExplodeOASXXTest`) that flipped fail→pass
   purely because the `+solution` classpath shifted the `@Suite`'s class-discovery order in the
   harbor environment. `harborOraclePassed=false`, every other metric green.

Every determinism fix was tried and FAILED, proving no clean+deterministic config exists:
- `-DreuseForks=false` (per-class isolation) → **126 errors** (suite shares JVM state; raw includes
  also run abstract `*Test` base classes).
- `ClassOrderer$ClassName` (force a deterministic order) → **183 errors** (any non-default order
  breaks the inter-test dependencies).
- Default-order `@Suite` (`reuseForks=true`) → 0 errors **locally**, but the order is
  environment-specific, so the harbor's different order is what produced the 8 flips. Local two-run
  diffs showed 0 flippers — the flakiness is intermittent/environment-specific and **cannot be
  reproduced or fixed from the authoring machine.**

## How to avoid repeating this

- At W0, before the dossier is "PASS", run the three checks above on the clean base suite. Bake the
  commands into the dossier (offline run ×2 + diff; `reuseForks=false` run). A repo that needs a
  giant `@Suite`, or that fails per-class isolation, is disqualified for the oracle.
- Treat "all my local four-state runs are green" as INSUFFICIENT evidence: the harbor oracle's
  two-run, different-environment determinism check catches what single local runs cannot. If you
  cannot make the base suite pass a local two-run diff under `reuseForks=false`, assume the oracle
  will fail.
- Prefer small, single-module repos whose tests are independent (each class runnable on its own).
  The portable assets of a killed task (the spec, the behavioral test suite, the solution design)
  move to a friendlier repo; the repo tax does not.
