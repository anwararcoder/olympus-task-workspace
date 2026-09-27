# LOC Verification (Mandatory First Check)

> STALE NUMBERS (2026-07-02): the live floor is 400 meaningful LOC, and the exclusion list also
> strips imports, export-only wiring, and boilerplate. This file and count_loc.py keep the old
> ~380 bar and a leaner exclusion set; use them as a screen only. Source of truth:
> my-review-workflow/rules/platform-panel.md.

Before reviewing anything else, count the **lines of code changed** in `solution.patch`.

## How to count

- Count all meaningful changed lines — added (`+`), deleted (`-`), and modified lines (excluding `+++`/`---` file header lines)
- **Exclude:** spacing-only changes, blank line additions/removals, comment-only lines (including doc comments/JSDoc even if they follow repo conventions), and any edits that exist solely to inflate the count
- Focus on lines that represent **actual engineering work — logic, data structures, functional code**

**⚠️ The `solution.patch` sometimes contains test code — DO NOT count it.**
Any lines that are part of test files, test functions, test modules, test fixtures, test helpers, or test utilities must be completely excluded from the LOC total. If a file is primarily a test file (e.g., `*_test.go`, `test_*.py`, `*.test.ts`, `*.spec.js`, files under `tests/`, `__tests__/`, etc.), skip the entire file. If test code lives alongside implementation code in the same file, exclude only the test functions/blocks. Only implementation lines count.

## Threshold: ~380 meaningful LOC changed

- If the count is **below ~380** → **STOP the review**. Do not rate or approve. Report:
  - The exact LOC count
  - What was counted vs excluded
  - Recommend the task be made more complex to meet the 400+ LOC requirement
- If the count is **at or above ~380** → proceed with the rest of the review

## Watch for LOC inflation tricks

- Large auto-generated or cache file changes that pad the diff
- Copied boilerplate or duplicated code blocks
- Verbose formatting that could be written concisely
- Config/manifest changes that don't represent real implementation work
- Spacing or whitespace-only edits scattered across files
- Test code mixed into the solution patch to inflate the count

The submitted solution's LOC must genuinely reflect the complexity of the engineering work.
