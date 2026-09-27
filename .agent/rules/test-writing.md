---
trigger: always_on
description: Test standards, semantic trap patterns, and coverage requirements
globs: "**/test-*.patch"
---

# Test Writing Rules

## Target Metrics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Test count | 30+ | 50+ |
| Test lines | 700+ | 900-1200+ |
| Fail on base | 100% | 100% |
| Match repo style | Required | Required |

> **Note:** Numbers are guidance from accepted work. Focus on comprehensive coverage that eliminates naive approaches.

## Official Platform Requirements (T1-T8)

Full text in `olympus-platform.md` section 4. Every test patch must satisfy all of them:

- **T1** 100% fail at base, 100% pass with the solution.
- **T2** deterministic: no timing, randomness, or ordering dependence. Verify Flakiness runs the
  suites several times with and without the solution and blocks on any changed result.
- **T3** strong: no permissive assertions that admit inaccurate solutions (the FP check will find
  them).
- **T4** covers the requested behavior and all obvious edge cases.
- **T5** nothing unspecified or undiscoverable. Test Quality checks each hidden test against the
  description and repo.
- **T6** no network (`--network none`).
- **T7** do not over-pin output: no exact error text, wording, or formatting unless the
  description states it or existing repo patterns make it obvious.
- **T8** keep failure diagnostics intact: failures must show which test failed and its real
  assertion output. A custom harness, reporter, or JUnit adapter must never hide failures behind
  hardcoded catch-all messages, mask upstream errors, or report something other than what ran.

Leak rule: no directories or files named "challenge", "quest", or "olympus"; no `test.sh` comments
referencing the challenge; no "Shipd", "Olympus", or "mars" anywhere in the patch.

## Professional Tester Mindset

Act as a professional tester who:
- Spots any missing gap independently
- Designs tests that fail naive implementations
- Ensures every test traces back to a description statement
- Reviews `*-human-reviews.md` files for common patterns before submitting

## Three Test Tiers

### Tier 1: Basic Tests (AI usually passes)
- Happy path functionality
- Simple valid inputs
- Core feature verification

### Tier 2: Edge Cases (AI sometimes fails)
- Empty inputs, nil values, boundaries
- Invalid inputs that should error
- Format/type edge cases

### Tier 3: Semantic Traps (AI rarely passes)
- Require specific architectural approach
- Exploit common naive implementations
- Order-dependent behavior

## Semantic Trap Types

| Trap Type | Pattern | Why It Works |
|-----------|---------|--------------|
| Scope resolution | Inner field shadows outer | Naive linear search fails |
| Branch isolation | Only successful branch tokens | Retrospective lookup fails |
| Timing semantics | Build-time vs parse-time | Agents conflate timing |
| State persistence | Values restore after operation | Agents forget cleanup |
| Kind preservation | Symbol metadata in free vars | defineFree() drops data |
| Order-dependent | Defaults reference earlier vars | Sequential eval required |

## Real Trap Examples

**From tengo-destructuring (v6):**
```go
// Order-dependent defaults: b's default references a
// Naive: parallel evaluation fails
// Correct: sequential binding with scope
[a, b = a + 1] := [10]  // b = 11
```

**From tengo-shadow-warnings (v6):**
```go
// Kind preservation in nested closures
// Naive: defineFree() loses IsParam flag
// Correct: preserve Kind when creating free symbols
func(x) { func() { return x }() }  // x.Kind = SymbolKindParam
```

## Code Rules

- NO comments (unless matching exact repo style)
- NO debug statements
- NO docstrings in test functions
- Match repo's existing test patterns
- Use build tags for isolation (`//go:build featurename`)

## Behavioral, Not Interface-Coupled (Critical)

Tests must reference **only symbols that already exist at the base commit**. Drive new behavior through existing entry points (HTTP handlers, existing public methods) and assert observable outputs (status codes, response bodies, rows in existing tables, rendered output). Capture any value you need (e.g. the current secret) through an existing field *before* the change, then observe the effect afterwards.

If a test references a symbol the *solution* introduces (a new method, struct field, type, constant, or a new handler name), the platform's auto-review raises an **"interface information" ERROR**: the solver is forced to name internals exactly like the reference, which is unfair. It also turns "fail on base" into a compile failure instead of clean red tests.

- Trigger a new operator action by extending an **existing** handler with a new action value and POSTing **raw JSON** (do not construct the new request struct — that references a new field).
- Read state through existing fields only; never read a field the solution adds.
- Result: the test compiles on the base commit and fails at **runtime** (the behavior is absent), which is the clean form of fail-on-base.

## Test File Naming (avoid path collisions)

The platform predicts likely test paths and flags collisions when your new test filename matches a name a solver agent would plausibly create (e.g. `secret_rotation_test.go`, `rotation_test.go`). Give new test files a **distinctive, unlikely-to-guess name** by appending a short token, e.g. `secret_rotation_window_5k2p_test.go`. Keep one such file per package.

## Assertion Contract Policy

- Use exact-string assertions only for explicit user-facing contracts stated in description.
- Use contains-style assertions for non-contract diagnostics and implementation-dependent wording.
- If review data shows repeated `FAIL_TEST_MISMATCH`, audit assertion contract alignment before adding new feature scope.

## Trap Density Guidelines

- Prefer intersection traps over repetitive type permutations.
- Good: one test combining scope + reassignment + control flow.
- Weak: many tests repeating the same single mismatch pattern with different primitive types.
- Consolidate variants only if semantic coverage remains equivalent.

## Build Tag Pattern

```go
//go:build destructuring

package tengo_test

import (
    "testing"
    . "github.com/d5/tengo/v2"
)

func TestDestructuring_BasicArray(t *testing.T) {
    // test implementation
}
```

**Why:** Isolates new tests from running on base repo. Without tag, tests fail on unpatched code breaking CI.

## Test Helper Functions

Create helpers for consistent patterns:

```go
func expectScript(t *testing.T, input, expected string) {
    t.Helper()
    // common test logic
}

func expectError(t *testing.T, input, errMsg string) {
    t.Helper()
    // error verification
}
```

## Questions To Ask

1. What would a naive implementation do?
2. What test would catch that naive implementation?
3. Does this test verify behavior or implementation?
4. Is this test deterministic?
5. Does this test match repo style?

## test.sh Requirements

```bash
#!/bin/bash
set -eo pipefail

cd "$(dirname "$0")"

OUTPUT_PATH=""
MODE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        base|new)
            MODE="$1"
            shift
            ;;
        *)
            echo "Usage: $0 --output_path <path> {base|new}"
            exit 1
            ;;
    esac
done

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 --output_path <path> {base|new}"
    exit 1
fi

run_tests() {
    local test_args=("$@")
    if [[ -n "$OUTPUT_PATH" ]]; then
        GOWORK=off go test -v "${test_args[@]}" 2>&1 | go-junit-report -set-exit-code > "$OUTPUT_PATH"
    else
        GOWORK=off go test "${test_args[@]}"
    fi
}

case "$MODE" in
    base)
        run_tests ./... -count=1 -timeout 10m
        ;;
    new)
        run_tests -tags=featurename -run ^TestFeatureContract_ ./... -count=1 -timeout 10m
        ;;
esac
```

Requirements:
- Executable (`chmod 755`)
- Supports `--output_path <path>` for JUnit XML output
- Supports `base` and `new` modes
- JUnit XML reporter installed in Dockerfile (e.g., `go-junit-report` for Go; pre-installed in the Go base image, as are `jest-junit` and `mocha-junit-reporter`)
- `base` runs the repo's real existing tests for the area the change touches: a genuine regression check, not a token smoke test
- Existing tests may be excluded only when flaky, network-dependent, or failing for pre-existing reasons, with the reason recorded; never exclude a valid test because the solution breaks it
- NO fail-fast flags (`--bail`, `-x`, `--fail-fast`, `failfast`): every test result must be reported
- NO dependency installation
- The script itself stops on setup errors (e.g. `set -eo pipefail`), but the test run must not stop at the first failing test
- Test output and JUnit XML must report what actually ran (T8); never rewrite, mask, or replace failure messages

> **IMPORTANT (Go repos):** Do NOT use `-mod=vendor` in test.sh. Agents can corrupt/delete the vendor directory, causing `FAIL_TEST_BROKEN` which is a platform fairness violation. Use default module resolution with `go mod download` in Dockerfile instead.

## Verification Before Submission

1. `./test.sh --output_path /tmp/base.xml base` → All PASS
2. `./test.sh --output_path /tmp/new.xml new` → All FAIL (on base code)
3. Apply solution
4. `./test.sh --output_path /tmp/new2.xml new` → All PASS

## Common Mistakes

- Tests pass on base code (not failing)
- Implementation-specific tests (checking internal state)
- Tests verify things not in description (surprise tests)
- Not matching repo's existing test style
- Exact-text assertions on messages the description never pins (T7)
- Order- or timing-dependent assertions that flip under Verify Flakiness (T2)
- Test directories, files, or `test.sh` comments named after the challenge/quest/program (leak rule)
