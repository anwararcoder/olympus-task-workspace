# Test Review Guide

Review tests as a human maintainer. Tests must reflect the description exactly - no more, no less. Every test must assert real, observable behavior. Assign a rating from 1-7.

---

## Auto-Reject (Rate 1)

Hard rejection is checked manually. Flag if present:

- Invalid git patch, conflicts, or not runnable (checked manually)
- Does not create `test.sh` with `base` and `new` modes and `--output_path <path>` support. Must be invoked as `./test.sh --output_path <path> base` or `./test.sh --output_path <path> new` and must produce JUnit XML output at the specified path. `base` mode must run existing tests from the codebase that are related to the feature being implemented (to verify the solution doesn't break existing functionality). `new` mode must run only the new tests written specifically for the feature under review.
- Contains solution code, not just tests
- Requires internet access
- Contains malicious code

---

## Quality Criteria

**Description Alignment** - Every requirement has a corresponding test. No surprise tests (behavior not in the description). Tests verify observable behavior, not implementation details. Enumerate every distinct behavior, sub-feature, and variant mentioned in the description (e.g., field aliases, custom hooks, delegation modes, optional parameters) and confirm each has at least one test. If the description says "X delegates to Y" or "X integrates with Y," there must be a test that registers/configures Y and verifies X honors it.

> Repo conventions are not surprises. Tests verifying existing repo patterns (thread safety, error formats, coding standards) are implicit requirements - check before flagging as "surprise."

**Test Alignment** - Requirements map to what the tests verify. No contradictions, no untested requirements, no tested-but-undescribed behavior.

**Base/New Mode Semantics** - `test.sh --output_path <path> base` runs pre-existing tests from the repo that relate to the feature area — these must pass both before and after the solution to prove nothing is broken. `test.sh --output_path <path> new` runs only the new tests written for this feature — these must fail on the base commit and pass only with a correct solution. Both modes must produce JUnit XML output at the specified path. Tests in `new` that pass on base are not validating new behavior. Tests in `base` that fail on base indicate the wrong tests were selected. **You must verify the fail-to-pass property**: mentally (or actually) confirm that each new test would fail without the solution. If a test's assertions could pass against the unmodified codebase (e.g., it only tests pre-existing behavior, or its setup doesn't depend on the new feature), it belongs in `base`, not `new`.

**Determinism** - Consistent results across runs. No flakiness, timing dependencies, race conditions, or reliance on external state/network.

**Assertion Quality** - Assertions verify actual behavior, not just "no crash." No weak assertions (`NotEmpty` without content check), no discarded results (`_ = value`), no loose equality. Precise enough to catch regressions.

**Observation Directness** - When the description specifies that an expression or operator returns distinct values (e.g., TRUE vs FALSE vs NULL, or specific enum variants), tests must assert the actual return value directly — not just observe side effects. For example, SQL WHERE clauses conflate NULL and FALSE (both filter out the row), so a test that only uses WHERE filtering cannot distinguish whether an operator returned NULL or FALSE. If the description specifies three-valued logic (NULL as a distinct result), at least one test must project the expression as a column value and assert the result directly (e.g., `SELECT x IN (...) as result`). Flag any test where the description mandates distinct return values but the test only observes them through a lossy channel that merges two or more of those values.

**Edge Case Coverage** - Edge cases tested (nil, empty, invalid, boundary). Error paths tested, not just happy paths. Error tests verify errors ARE returned — don't mandate exact strings. All obvious edge cases covered. Specifically check for:
- **Malformed/invalid input**: corrupt syntax, wrong types, non-numeric where numeric expected, invalid format strings
- **Sparse/non-contiguous input**: gaps in sequences (e.g., index 0 and 2 without 1), missing intermediate keys
- **Unknown/extra input**: unexpected keys, extra fields, unrecognized parameters — verify the code either ignores or rejects them, and that a test covers whichever behavior the description specifies
- **Feature variant coverage**: if the feature interacts with multiple input types or framework features (e.g., dataclasses AND attrs, aliases AND renames, sync AND async), each variant needs a test. **When the description states that a behavior applies across multiple dimensions (e.g., N operators × M modifiers, or N input types × M output modes), enumerate the cross-product and verify that each cell has at least one test. It is not sufficient to test each dimension independently — the combination matrix must be covered. At minimum, every value in each dimension must appear in at least one tested combination.**

**Negative-Input Balance** - The suite must not be overwhelmingly happy-path. Count the ratio of positive (expected-success) tests to negative (error/rejection/malformed-input) tests. If the feature has error conditions, invalid inputs, or boundary behaviors described, the suite needs proportional negative-input coverage. A suite that is 90%+ roundtrip/happy-path assertions with only a few configuration-error tests is under-testing the failure surface. Flag suites where negative testing is limited to trivial cases (e.g., only config validation errors) while ignoring runtime error paths (e.g., malformed data during processing).
**No Redundancy** - No duplicate tests verifying the same behavior. Each test adds distinct value. Test count proportional to complexity.

**Code Quality & Repo Conventions** - Follows repo test naming, structure, and patterns. No unused code or dead helpers. No `--bail` in `test.sh`.

**Minimal Test Footprint** - Tests should demand only the API surface needed to verify the described feature. Flag test suites that introduce excessive helper functions, convenience wrappers, builder utilities, or integration shims beyond what the description requires. If the core feature is a matcher and two integrations, the tests should not force a sprawl of extra helpers (custom formatters, debug printers, assertion utilities) that inflate the solution patch without testing distinct described behavior. Each test helper must be justified by a specific requirement in the description — not added "for completeness" or because it's nice to have. The test footprint should be proportional to the feature scope.

**AI Slop Detection** - No AI-generated comments (NOTE, TODO, obvious restatements of what the next line does). No robotic/templated test descriptions inconsistent with the repo's existing test style. No verbose doc comments or JSDoc on test helpers when the repo's own test files have none. Comment density and style must match peer test files in the codebase — excessive inline comments explaining trivial setup or assertions are a characteristic AI tell. Test code should read like it was written by someone familiar with the codebase, not generated by a model.

**No Solution Leakage** - Tests don't reveal implementation details. A different correct implementation would still pass. No assumptions about internal paths, data structures, or naming. Setup uses public interfaces. Specifically:
- Do NOT spell out exact callback or function signatures (e.g., `func() (string, []byte, error)`) — this locks the API design. Test what the callback produces, not its type signature.
- Do NOT name internal error types or assert with `errors.Is` against implementation-specific error values (e.g., `IsCorruptionError`) — test that an error occurs and its observable message, not the error's concrete type.
- Do NOT use reflection-based helpers that probe struct layout (flat fields vs nested structs, method signatures, field names). A nested struct implementation that is behaviorally identical must still pass. Test through the public API, not by inspecting the shape of internal types.
- Do NOT enforce a specific internal representation when the description only requires observable behavior. For example, if tests call `.as_reference().unwrap()` to traverse output structure, they reject implementations that use inline/direct objects instead of indirect references — even though both are valid. Tests should access values through APIs that accept either form, or test the final observable result rather than the intermediate structural representation.
- Do NOT lock in specific import paths or function locations (e.g., `from package.submodule import flatten`) when the description only requires the feature to exist — a valid implementation placing it in a different submodule would fail.
- **Conversely**, when the description **does** specify a concrete module shape or file structure (e.g., "create `compare-schemas.ts`", "add a `flatten` method to `Converter`"), tests must enforce that exact shape — not silently accept alternatives (e.g., `compare-schemas/index.ts` instead of `compare-schemas.ts`). A test that tolerates either form is too permissive and fails to validate the requested structure. The rule is symmetric: don't lock in what isn't specified, but DO enforce what IS specified.
- Do NOT assert on specific exception types or exception attributes (e.g., checking `err.key == "foo"` or `isinstance(err, FlattenError)`) unless the description explicitly specifies that exact type/attribute. Test that an error occurs and validate its observable message or behavior instead.

**Test Harness vs Codebase Pattern Compatibility** - When tests use custom harnesses (helpers that execute commands, feed messages, simulate event loops, etc.), verify the harness is compatible with the **dominant patterns in the existing codebase**. If the codebase consistently uses a specific pattern for a category of operations (e.g., `tea.Sequence` for command composition in Bubble Tea, middleware chaining in Express, `async/await` with specific error propagation), and the test harness **cannot process that pattern** (e.g., it calls `cmd()` directly and feeds results back, but cannot handle runtime-internal message types produced by `tea.Sequence`), then any correct implementation following the codebase pattern will silently fail all integration tests. This creates a hidden trap: the solver must independently discover that the dominant codebase pattern doesn't work with the test harness and choose a different approach — without any hint in the description. Flag this as a **harness-pattern trap** when:
- The test harness bypasses the framework runtime (e.g., calls `cmd()` directly instead of going through the full event loop)
- The existing codebase uses a specific command composition pattern for the exact operations being batch-ified
- An implementation following that pattern would silently produce unrecognized messages that the harness drops
- The description says nothing about command composition or return-type constraints
- The only way to pass is to diverge from the codebase pattern without being told to

**Unstated Semantic Assumptions** - Tests must not assume specific standard-library or runtime semantics that the description does not state. When a test expects a particular error/success outcome, verify that the description actually specifies that behavior. Common traps:
- **Deletion semantics**: `os.RemoveAll` (Go), `rm -rf` (shell), `shutil.rmtree` (Python) return success for nonexistent paths. If tests expect nonexistent paths to produce errors in a batch-delete function, the description must explicitly state "nonexistent paths are errors." If it doesn't, the test is asserting undescribed behavior — a solver using the standard library's documented semantics would produce a valid but different result.
- **Ordering guarantees**: Tests assume a specific iteration order (e.g., map keys, directory listings) that the language/OS does not guarantee and the description does not specify.
- **Nil/empty vs error**: Tests treat nil/empty returns as errors (or vice versa) when the description doesn't specify which.
- **Implicit pre-checks**: The solution adds a pre-validation step (e.g., `os.Stat` before `os.RemoveAll`) that changes the error surface. If the description doesn't require this pre-check, a solver skipping it writes equally valid code that fails the tests.
Flag these as **unstated semantic assumption** — the test encodes a design choice that isn't derivable from the description alone.

**Round-Trip & Data Preservation (if applicable)** - `input -> output -> input` produces the same result. No silent data loss. Formatting and structural changes caught.

**Format-Specific Validation (if applicable)** - Correct format produced (YAML/TOML/JSON). No wrong-format fallback. Structure matches format expectations.

---

## Red Flags

- Surprise test: behavior not in description (check repo conventions first)
- Weak assertion: passes regardless of implementation
- **Tolerance not scaled to the requested accuracy (check BOTH directions)**: a call requests `accuracy`/`tolerance` X, and the assertion does not track it. Tighter than X (asserts 1e-4 on a 1e-3 request) rejects a faithful solution (unfairness). Looser than X (requests 1e-9, asserts 1e-4) fails to verify the contract. A one-sided bound (a floor with no matching tight ceiling, e.g. an inscribed lower bound plus a slack `1.05*rectangle` cap) lets the degenerate/limit answer pass (returning the plain rectangle perimeter for a boxy superellipse). Walk the whole oracle table; a green suite hides all three (kurbo-superellipse revert).
- Incomplete: only checks "no panic" without verifying output
- Too prescriptive: demands exact error message text
- Testing implementation details: inspects internal state/callbacks instead of observable behavior
- Signature lock-in: spells out exact function/callback type signatures instead of testing behavior
- Internal error type coupling: uses `errors.Is` or type assertions against implementation-specific error types instead of checking error occurrence and message
- Reflection probing: uses reflection to inspect struct layout, field types, or method signatures — fails on valid alternative implementations (e.g., nested struct vs flat struct)
- Representation lock-in: tests enforce a specific internal representation (e.g., indirect references vs inline objects, separate objects vs embedded dictionaries) when the description only specifies observable behavior — a valid alternative representation would fail the test despite producing correct output
- Import path lock-in: tests import from a specific submodule path when the description doesn't mandate that exact location
- Exception shape lock-in: tests assert on specific exception class names or custom attributes (e.g., `.key`, `.path`) that the description doesn't require
- Over-permissive module shape: tests accept multiple file/module structures (e.g., both `foo.ts` and `foo/index.ts`) when the description specifies one exact shape — fails to enforce the requested structure
- Solution-specific helpers: uses methods added by the solution
- Redundant/bloated: same behavior tested multiple times
- Flaky: timing-dependent or non-deterministic
- Silent data loss: round-trip tests that don't verify preservation
- Swallowed exceptions: catches errors without asserting
- Happy-path bias: suite is overwhelmingly positive-case roundtrips with minimal negative-input or error-path testing — the failure surface is under-tested
- Missing feature variant: a described sub-feature or input type variant (e.g., aliases, custom hooks, async mode) has zero test coverage
- Lossy observation: tests observe an expression's effect through a channel that cannot distinguish between two distinct values the description requires (e.g., testing NULL vs FALSE only through WHERE filtering, or testing error vs success only through a boolean flag that discards the error detail)
- Incomplete cross-product: description specifies behavior across N × M combinations (e.g., 5 operators × 3 modifiers) but tests only cover a diagonal or subset, leaving entire rows or columns of the matrix untested
- Missing malformed-input tests: no tests for corrupt, sparse, or syntactically invalid inputs that the feature must handle
- Unverifiable fail-to-pass: cannot confirm from the patch that `new` tests would actually fail on the base commit
- Helper sprawl: tests introduce excessive helper functions, wrappers, or utilities that force the solution to implement more API surface than the description requires — inflates the patch without testing distinct described behavior
- AI slop: robotic comments (NOTE, TODO, obvious restatements), verbose doc comments on test helpers when repo test files have none, templated test descriptions inconsistent with repo style, excessive inline comments explaining trivial code
- **Harness-pattern trap**: test harness (custom helper that executes commands, event loop simulator, message pump) cannot process the dominant codebase pattern for the operations being tested. A solver following the existing code's approach silently fails integration tests. The only way to pass is to independently discover the harness limitation and use a non-obvious alternative pattern. Examples: test helper calls `cmd()` directly but `tea.Sequence` produces runtime-internal messages the helper drops; test driver uses synchronous execution but the codebase pattern requires async resolution; test mock intercepts at a layer that doesn't support the standard middleware chain.
- **Unstated semantic assumption**: tests assert error/success outcomes for standard-library operations where the description does not specify the expected behavior. The test encodes a design choice (e.g., "nonexistent path → error" via pre-stat check) that contradicts the standard library's documented behavior (e.g., `os.RemoveAll` returns nil for nonexistent paths). A solver using the stdlib's documented semantics writes correct code that fails the test. Other examples: assuming specific file ordering, assuming nil means error, assuming a particular rounding mode.
- **Broken JUnit XML plumbing**: `test.sh` uses the wrong reporter for the framework, omits required flags (e.g., missing `-v` for go-junit-report), pipes without `-set-exit-code`, or leaves `$OUTPUT_PATH` unquoted. Result: empty/malformed XML or silently swallowed test failures.
- **Missing mode isolation**: `test.sh new` runs the entire test suite instead of only new tests (e.g., `go test ./...` without `-run` filter, or `vitest run` without specifying test files). This means `new` mode passes on the base commit, defeating fail-to-pass validation.

---

## Review Process

For each test file, read line by line and verify:
- What behavior is asserted and whether the assertion is strong enough
- Whether important edge cases are missing
- Whether the test is redundant with others
- Whether it fails on base commit
- Whether it aligns with the description

After reviewing all test files, perform these cross-cutting checks:
- **Feature variant checklist**: list every sub-feature, input type, and behavioral variant from the description. Confirm each has ≥1 test. Flag any with zero coverage.
- **Negative-input audit**: count positive vs negative tests. If negative tests are <20% of the suite and the feature has error paths, flag as happy-path biased.
- **Fail-to-pass verification**: for each `new` test, confirm it exercises new behavior that would not exist on the base commit. If uncertain, flag it.
- **API-shape leakage scan**: check if tests lock in import paths, function locations, exception class names, or custom attributes not specified in the description.
- **Structural enforcement check**: if the description specifies a concrete file/module layout (file names, export shapes, class locations), verify the tests enforce that exact structure — not a looser alternative. Tests that accept multiple structural forms when only one is specified are too permissive.
- **Scope proportionality check**: compare the test surface (number of distinct helpers, utilities, and API endpoints exercised) against the description's feature scope. If tests demand significantly more API surface than described, flag as helper sprawl / scope inflation.
- **Harness-pattern compatibility audit**: if tests use custom harnesses/helpers to simulate framework behavior (event loops, command execution, message passing), read the harness code and identify what patterns it can and cannot handle. Then read the existing codebase to identify the dominant pattern for the operations being tested. If the harness cannot process the dominant pattern (e.g., the harness calls `cmd()` and feeds results to `Update()`, but the codebase uses `tea.Sequence` which produces runtime-internal messages the harness silently drops), flag as a harness-pattern trap. The key question: **would a solver who correctly follows the existing codebase's pattern for these operations pass or fail the integration tests?** If they would fail, this is a mandatory issue.
- **Unstated semantic assumption audit**: for each test that asserts error/success outcomes on standard-library operations (file deletion, network calls, parsing), verify the description explicitly states the expected behavior. If the test assumes a specific semantic (e.g., "nonexistent path → error") that contradicts the standard library's documented behavior (e.g., `os.RemoveAll` returns nil for nonexistent paths), and the description does not specify which semantic to use, flag as an unstated semantic assumption. Count how many tests are affected.
- **`test.sh` implementation verification**: read `test.sh` line by line and verify the following:
  - **Argument parsing**: must accept `./test.sh --output_path <path> base` and `./test.sh --output_path <path> new`. Check that argument parsing is robust — positional assumptions that break on reordered args are acceptable as long as the documented invocation order works. Flag if `--output_path` is ignored or mode is not validated.
  - **JUnit XML plumbing per framework**: verify the correct reporter/tool is used for the project's test framework:
    - **Go**: must use `go-junit-report`. The `go test` command must include the `-v` flag — `go-junit-report` parses verbose output and produces empty/broken XML without it. Verify the pipe: `go test -v ... 2>&1 | go-junit-report -set-exit-code > "$OUTPUT_PATH"`.
    - **vitest**: must use `--reporter=junit --outputFile="$OUTPUT_PATH"`.
    - **jest**: must use `jest-junit` reporter with `JEST_JUNIT_OUTPUT_DIR` and `JEST_JUNIT_OUTPUT_NAME` env vars, or equivalent config.
    - **pytest**: must use `--junitxml="$OUTPUT_PATH"`.
    - **mocha**: must use `mocha-junit-reporter` with `--reporter-options mochaFile="$OUTPUT_PATH"`.
    - **deno**: must use `--junit-path="$OUTPUT_PATH"`.
    - If the framework is not in this list, verify the JUnit XML output mechanism is correct for that framework.
  - **Output path wiring**: verify `$OUTPUT_PATH` is properly quoted in the command that writes the XML file. Unquoted `$OUTPUT_PATH` breaks on paths with spaces.
  - **No `--bail` or early-exit flags**: `--bail` (jest/vitest) or `-x` (pytest) cause the runner to stop after the first failure, which hides additional failing tests and produces incomplete JUnit XML. Flag if present.
  - **`set -e` behavior**: verify the script uses `set -e` or equivalent. If the test runner's exit code is piped (e.g., `go test | go-junit-report`), verify the pipe doesn't swallow failures — `go-junit-report -set-exit-code` handles this for Go, other frameworks may need `set -o pipefail`.
  - **Mode isolation**: `base` mode must run only pre-existing tests (not new tests). `new` mode must run only new tests (not the entire suite). Verify the test file lists or filter patterns achieve proper isolation. Common issues: `new` mode runs `./...` without a `-run` filter (runs everything), or `base` mode accidentally includes new test files.

---

## Rating Scale

| Rating | Label | Criteria |
|--------|-------|----------|
| **1** | **Rejected** | Invalid patch, conflicts, not runnable, or violates hard requirements. *(Checked manually)* |
| **2** | **Fundamentally Broken** | Tests don't fail on base, are flaky, or violate determinism. |
| **3** | **Major Quality Issues** | Weak assertions, incomplete coverage, structural issues, or determinism concerns. |
| **4** | **Borderline** | Deterministic but bloated, missing edge cases, or weak assertions. Structural mismatch with repo conventions. Needs changes. |
| **5** | **Good (Approvable)** | Deterministic and valid. Some redundancy or uneven elegance. Assertions correct but not always sharp. Poor edge case coverage. |
| **6** | **Strong** | Deterministic. Slight redundancy or minor stylistic issues. Edge coverage could improve slightly. No major tests missing. |
| **7** | **Exceptional** | Rock-solid determinism. Precise assertions. Covers behavior and edge cases cleanly. No redundancy, no leakage. |

- 1-3: Do not approve
- 4: Request revisions
- 5-7: Approvable (5 is minimum)

---

## Output

Write in `Feedback.md`:

```
## Rating: [N] - [Label]

## Issues Found
- [Each issue: Weak assertion / Missing edge case / Redundant / Surprise test / Solution leakage / Flaky / Structural / Red flag]

## Summary
[1-3 sentences on why this rating was given]
```

Rules: Be concise, focus only on test problems, don't suggest code fixes, reference exact test names or lines.
