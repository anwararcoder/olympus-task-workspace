#!/usr/bin/env python3
"""
LOC Counter for solution.patch files.

Counts meaningful lines of code changed, following the rules in check_loc.md:
  - Counts added (+) and deleted (-) lines (excludes +++/--- file headers)
  - Modifications (adjacent - then + lines) count as ONE change, not two
  - Excludes: blank/whitespace-only lines, comment-only lines, test files/code
  - Reports per-file breakdown and final verdict against the ~380 threshold
"""

import re
import sys
import os
from pathlib import PurePosixPath

# ─── Test file detection ─────────────────────────────────────────────────────

TEST_DIR_PATTERNS = [
    "tests/", "test/", "__tests__/", "__test__/",
    "testing/", "spec/", "specs/",
    "testdata/", "test_data/",
    "testutil/", "testutils/", "test_utils/",
    "testhelper/", "testhelpers/", "test_helpers/",
    "fixtures/",
]

TEST_FILE_PATTERNS = [
    # Go
    re.compile(r"_test\.go$"),
    # Python
    re.compile(r"(^|/)test_[^/]+\.py$"),
    re.compile(r"(^|/)[^/]+_test\.py$"),
    re.compile(r"(^|/)conftest\.py$"),
    # JS/TS
    re.compile(r"\.(test|spec)\.(js|jsx|ts|tsx|mjs|cjs)$"),
    # Rust
    re.compile(r"(^|/)tests\.rs$"),
    # Ruby
    re.compile(r"(^|/)test_[^/]+\.rb$"),
    re.compile(r"(^|/)[^/]+_test\.rb$"),
    re.compile(r"_spec\.rb$"),
    # Java/Kotlin
    re.compile(r"Test\.java$"),
    re.compile(r"Tests\.java$"),
    re.compile(r"Test\.kt$"),
    # C/C++
    re.compile(r"(^|/)test_[^/]+\.(c|cpp|cc|cxx)$"),
    re.compile(r"_test\.(c|cpp|cc|cxx)$"),
    # PHP
    re.compile(r"Test\.php$"),
    # Elixir
    re.compile(r"_test\.exs$"),
]


def is_test_file(filepath: str) -> bool:
    fp = filepath.lower().replace("\\", "/")
    # Check directory patterns
    for d in TEST_DIR_PATTERNS:
        if f"/{d}" in fp or fp.startswith(d):
            return True
    # Check filename patterns
    for pat in TEST_FILE_PATTERNS:
        if pat.search(filepath):
            return True
    return False


# ─── Comment detection ────────────────────────────────────────────────────────

def _get_comment_patterns(filepath: str):
    """Return single-line comment prefixes for the file's language."""
    ext = PurePosixPath(filepath).suffix.lower()
    mapping = {
        # // style
        ".go": ["//"], ".rs": ["//", "///", "//!"], ".c": ["//"], ".h": ["//"],
        ".cpp": ["//"], ".cc": ["//"], ".cxx": ["//"], ".hpp": ["//"],
        ".java": ["//"], ".kt": ["//"], ".kts": ["//"],
        ".js": ["//"], ".jsx": ["//"], ".ts": ["//"], ".tsx": ["//"],
        ".mjs": ["//"], ".cjs": ["//"],
        ".cs": ["//", "///"], ".swift": ["//"], ".scala": ["//"],
        ".dart": ["//"], ".zig": ["//"], ".v": ["//"],
        ".proto": ["//"], ".gradle": ["//"],
        # # style
        ".py": ["#"], ".rb": ["#"], ".sh": ["#"], ".bash": ["#"],
        ".zsh": ["#"], ".pl": ["#"], ".pm": ["#"],
        ".r": ["#"], ".R": ["#"],
        ".yaml": ["#"], ".yml": ["#"], ".toml": ["#"],
        ".dockerfile": ["#"], ".tf": ["#"], ".hcl": ["#"],
        ".ex": ["#"], ".exs": ["#"], ".cr": ["#"],
        ".jl": ["#"], ".nim": ["#"],
        # -- style
        ".lua": ["--"], ".hs": ["--"], ".sql": ["--"],
        ".elm": ["--"], ".erl": ["%"], ".hrl": ["%"],
        # ; style
        ".asm": [";"], ".s": [";"], ".clj": [";"],
        ".el": [";"], ".lisp": [";"],
        # Mixed
        ".php": ["//", "#"],
    }
    return mapping.get(ext, ["//", "#"])


def _uses_triple_quote_docstrings(filepath: str) -> bool:
    """Whether this language uses triple-quoted docstrings."""
    ext = PurePosixPath(filepath).suffix.lower()
    return ext in (".py", ".pyw", ".pyi")


def _uses_block_comments(filepath: str) -> bool:
    """Whether this language uses /* ... */ block comments."""
    ext = PurePosixPath(filepath).suffix.lower()
    return ext in (
        ".go", ".rs", ".c", ".h", ".cpp", ".cc", ".cxx", ".hpp",
        ".java", ".kt", ".kts", ".js", ".jsx", ".ts", ".tsx",
        ".mjs", ".cjs", ".cs", ".swift", ".scala", ".dart",
        ".php", ".css", ".scss", ".less",
    )


def _supports_nested_block_comments(filepath: str) -> bool:
    """Whether this language supports nested /* /* */ */ block comments."""
    ext = PurePosixPath(filepath).suffix.lower()
    return ext in (".rs",)


def _count_block_depth_change(line: str) -> tuple[int, int]:
    """Count /* opens and */ closes in a line, returning (opens, closes)."""
    opens = 0
    closes = 0
    i = 0
    while i < len(line) - 1:
        if line[i] == "/" and line[i + 1] == "*":
            opens += 1
            i += 2
        elif line[i] == "*" and line[i + 1] == "/":
            closes += 1
            i += 2
        else:
            i += 1
    return opens, closes


def classify_lines(lines: list[tuple[str, str]], filepath: str):
    """Classify each changed line as 'code', 'comment', or 'blank'.

    Tracks multi-line block comments (/* ... */) with nesting support
    for Rust, and Python triple-quoted docstrings so that interior
    lines are correctly marked as comments.

    Returns (counted, excluded_blank, excluded_comment).
    """
    prefixes = _get_comment_patterns(filepath)
    has_docstrings = _uses_triple_quote_docstrings(filepath)
    has_block = _uses_block_comments(filepath)
    nested_block = _supports_nested_block_comments(filepath)

    block_depth = 0           # nesting depth for /* ... */ (0 = not in comment)
    in_docstring = False      # """..."""
    docstring_delim = None    # which delimiter opened it: '"""' or "'''"

    counted = 0
    excluded_blank = 0
    excluded_comment = 0

    for content, _change_type in lines:
        stripped = content.strip()

        # ── blank lines ──────────────────────────────────────────────
        if not stripped:
            excluded_blank += 1
            continue

        # ── inside a multi-line block comment (/* ... */) ────────────
        if block_depth > 0:
            excluded_comment += 1
            if nested_block:
                opens, closes = _count_block_depth_change(stripped)
                block_depth += opens - closes
                block_depth = max(0, block_depth)
            else:
                if "*/" in stripped:
                    block_depth = 0
            continue

        # ── inside a multi-line docstring (Python) ───────────────────
        if in_docstring:
            excluded_comment += 1
            if docstring_delim in stripped:
                in_docstring = False
                docstring_delim = None
            continue

        # ── Python triple-quoted docstrings ──────────────────────────
        if has_docstrings:
            handled = False
            for delim in ('"""', "'''"):
                if delim in stripped:
                    count = stripped.count(delim)
                    if count == 1:
                        # Opens a multi-line docstring
                        in_docstring = True
                        docstring_delim = delim
                        excluded_comment += 1
                        handled = True
                        break
                    elif count >= 2:
                        # Single-line docstring: """Some text."""
                        # If line starts with the delimiter, it's a docstring
                        if stripped.startswith(delim):
                            excluded_comment += 1
                        else:
                            # Code with inline string: x = """val"""
                            counted += 1
                        handled = True
                        break
            if handled:
                continue

        # ── /* ... */ block comment start ─────────────────────────────
        if has_block:
            if stripped.startswith("/*") or stripped.startswith("/**"):
                opens, closes = _count_block_depth_change(stripped)
                if closes >= opens:
                    # Single-line block comment: /* ... */
                    excluded_comment += 1
                else:
                    block_depth = opens - closes
                    excluded_comment += 1
                continue
            # Stray block-comment closing or continuation lines.
            # Only match patterns that look like comment formatting:
            #   */  or  *  (alone)  or  * followed by space (doc continuation)
            # Do NOT match code like:  *ptr = 5;  or  **kwargs
            if stripped == "*/":
                excluded_comment += 1
                continue

        # ── single-line comments ─────────────────────────────────────
        is_comment = False
        for p in prefixes:
            if stripped.startswith(p):
                is_comment = True
                break
        if is_comment:
            excluded_comment += 1
            continue

        # ── meaningful code ──────────────────────────────────────────
        counted += 1

    return counted, excluded_blank, excluded_comment



# ─── Patch parser ─────────────────────────────────────────────────────────────

def parse_patch(patch_text: str):
    """
    Parse a unified diff and return per-file line lists.
    Returns: list of (filepath, [(line_content, change_type)]) 
             where change_type is '+' or '-'
    """
    files = []
    current_file = None
    current_lines = []

    for raw_line in patch_text.splitlines():
        # Detect file header: diff --git a/... b/...
        if raw_line.startswith("diff --git "):
            if current_file is not None:
                files.append((current_file, current_lines))
            current_lines = []
            # Extract b/ path
            m = re.search(r" b/(.+)$", raw_line)
            current_file = m.group(1) if m else None
            continue

        # Skip file-level headers
        if raw_line.startswith("+++") or raw_line.startswith("---"):
            continue
        if raw_line.startswith("@@"):
            continue
        if raw_line.startswith("index ") or raw_line.startswith("new file") or raw_line.startswith("deleted file"):
            continue
        if raw_line.startswith("old mode") or raw_line.startswith("new mode"):
            continue
        if raw_line.startswith("similarity index") or raw_line.startswith("rename "):
            continue
        if raw_line.startswith("Binary files"):
            continue

        if current_file is None:
            continue

        # Changed lines
        if raw_line.startswith("+"):
            current_lines.append((raw_line[1:], "+"))
        elif raw_line.startswith("-"):
            current_lines.append((raw_line[1:], "-"))
        # Context lines (starting with ' ') are ignored

    if current_file is not None:
        files.append((current_file, current_lines))

    return files


# ─── Modification collapsing ──────────────────────────────────────────────────

def collapse_modifications(lines: list[tuple[str, str]]) -> list[tuple[str, str]]:
    """
    Collapse adjacent -/+ line pairs into single modification entries.

    In a unified diff, a contiguous block of '-' lines immediately followed
    by a contiguous block of '+' lines represents modifications, not separate
    deletions and additions.  Each paired (-,+) counts as ONE change.
    Leftover '-' lines (pure deletions) or '+' lines (pure additions) each
    count as one change.

    Returns a new list of (content, change_type) tuples where paired lines
    use the '+' side content with a 'M' (modification) change_type.
    """
    result = []
    i = 0
    n = len(lines)

    while i < n:
        # Collect a contiguous block of '-' lines
        minus_start = i
        while i < n and lines[i][1] == '-':
            i += 1
        minus_count = i - minus_start

        # If no '-' lines, just emit the current line as-is and advance
        if minus_count == 0:
            result.append(lines[i])
            i += 1
            continue

        # Collect the contiguous block of '+' lines right after
        plus_start = i
        while i < n and lines[i][1] == '+':
            i += 1
        plus_count = i - plus_start

        # Pair them up: each pair = 1 modification
        paired = min(minus_count, plus_count)
        for j in range(paired):
            # Use the '+' side content, mark as modification
            result.append((lines[plus_start + j][0], 'M'))

        # Leftover '-' lines (pure deletions)
        for j in range(paired, minus_count):
            result.append(lines[minus_start + j])

        # Leftover '+' lines (pure additions)
        for j in range(paired, plus_count):
            result.append(lines[plus_start + j])

    return result


# ─── Main counting logic ─────────────────────────────────────────────────────

def count_loc(patch_path: str):
    with open(patch_path, "r", encoding="utf-8", errors="replace") as f:
        patch_text = f.read()

    files = parse_patch(patch_text)

    total_counted = 0
    total_excluded = 0
    total_test_excluded = 0
    file_reports = []

    for filepath, raw_lines in files:
        test_file = is_test_file(filepath)

        if test_file:
            total_test_excluded += len(raw_lines)
            file_reports.append({
                "file": filepath,
                "is_test": True,
                "counted": 0,
                "excluded_blank": 0,
                "excluded_comment": 0,
                "excluded_test": len(raw_lines),
                "total_changed": len(raw_lines),
            })
            continue

        # Collapse adjacent -/+ pairs into single modifications
        lines = collapse_modifications(raw_lines)

        counted, excluded_blank, excluded_comment = classify_lines(lines, filepath)

        total_counted += counted
        total_excluded += excluded_blank + excluded_comment

        file_reports.append({
            "file": filepath,
            "is_test": False,
            "counted": counted,
            "excluded_blank": excluded_blank,
            "excluded_comment": excluded_comment,
            "excluded_test": 0,
            "total_changed": len(raw_lines),
            "total_after_collapse": len(lines),
        })

    return total_counted, total_excluded, total_test_excluded, file_reports


# ─── Output ───────────────────────────────────────────────────────────────────

THRESHOLD = 380

RED = "\033[91m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
CYAN = "\033[96m"
DIM = "\033[2m"
BOLD = "\033[1m"
RESET = "\033[0m"


def print_report(patch_path, total_counted, total_excluded, total_test_excluded, file_reports):
    print(f"\n{BOLD}{'═' * 60}{RESET}")
    print(f"{BOLD}  LOC Count Report — {os.path.basename(patch_path)}{RESET}")
    print(f"{BOLD}{'═' * 60}{RESET}\n")

    # Per-file breakdown
    print(f"  {BOLD}{'File':<45} {'Count':>6}  {'Excl':>6}  {'Test':>6}{RESET}")
    print(f"  {'─' * 45} {'─' * 6}  {'─' * 6}  {'─' * 6}")

    for r in file_reports:
        name = r["file"]
        if len(name) > 44:
            name = "…" + name[-43:]

        if r["is_test"]:
            print(f"  {DIM}{name:<45} {'—':>6}  {'—':>6}  {r['excluded_test']:>6}{RESET}  {DIM}(test file){RESET}")
        else:
            excl = r["excluded_blank"] + r["excluded_comment"]
            collapsed = r["total_changed"] - r.get("total_after_collapse", r["total_changed"])
            counted_str = str(r["counted"]) if r["counted"] > 0 else "—"
            excl_str = str(excl) if excl > 0 else "—"
            collapse_note = f"  {DIM}({collapsed} modifications collapsed){RESET}" if collapsed > 0 else ""
            print(f"  {name:<45} {counted_str:>6}  {excl_str:>6}  {'—':>6}{collapse_note}")

    # Totals
    print(f"\n  {'─' * 67}")
    print(f"  {BOLD}{'TOTAL':<45} {total_counted:>6}  {total_excluded:>6}  {total_test_excluded:>6}{RESET}")

    # Verdict
    impl_file_count = sum(1 for r in file_reports if not r["is_test"])
    test_file_count = sum(1 for r in file_reports if r["is_test"])

    print(f"\n{BOLD}{'─' * 60}{RESET}")
    print(f"  Impl files:      {BOLD}{impl_file_count}{RESET}" + (f"  ({test_file_count} test file{'s' if test_file_count != 1 else ''} excluded)" if test_file_count else ""))
    print(f"  Meaningful LOC:  {BOLD}{total_counted}{RESET}")
    print(f"  Excluded:        {total_excluded} (blank/comment)")
    print(f"  Test lines:      {total_test_excluded} (skipped entirely)")

    if total_counted >= THRESHOLD:
        verdict = f"{GREEN}{BOLD}✓ PASS{RESET} — {total_counted} LOC meets the ~{THRESHOLD} threshold"
    else:
        deficit = THRESHOLD - total_counted
        verdict = f"{RED}{BOLD}✗ FAIL{RESET} — {total_counted} LOC is ~{deficit} short of the ~{THRESHOLD} threshold"

    print(f"\n  {verdict}")

    # ── User-facing feedback messages ─────────────────────────────────
    MIN_FILES = 3
    messages = []

    if total_counted < THRESHOLD:
        messages.append(
            f"The meaningful LOC for your solution is {total_counted}. "
            f"After excluding {total_excluded} LOC of comments and blank lines"
            + (f" and {total_test_excluded} LOC of test code" if total_test_excluded else "")
            + f", please add more complexity to this problem, as we require at least "
            f"{THRESHOLD} LOC in your solution. Additionally, the median LOC of the "
            f"agents who solved this problem should also be around {THRESHOLD} LOC "
            f"of real changes."
        )

    if impl_file_count < MIN_FILES:
        messages.append(
            f"The solution only modifies {impl_file_count} implementation "
            f"file{'s' if impl_file_count != 1 else ''}. We require changes across "
            f"at least {MIN_FILES} implementation files to ensure the task has "
            f"sufficient architectural breadth. Please expand the scope of the "
            f"problem to involve more files."
        )

    if messages:
        print(f"\n{YELLOW}{BOLD}  📋 Feedback to send:{RESET}")
        for msg in messages:
            print(f"\n  {YELLOW}{msg}{RESET}")

    print(f"\n{BOLD}{'═' * 60}{RESET}\n")


def main():
    if len(sys.argv) < 2:
        print(f"Usage: python {sys.argv[0]} <solution.patch>")
        sys.exit(1)

    patch_path = sys.argv[1]
    if not os.path.isfile(patch_path):
        print(f"Error: file not found: {patch_path}")
        sys.exit(1)

    total_counted, total_excluded, total_test_excluded, file_reports = count_loc(patch_path)
    print_report(patch_path, total_counted, total_excluded, total_test_excluded, file_reports)


if __name__ == "__main__":
    main()
