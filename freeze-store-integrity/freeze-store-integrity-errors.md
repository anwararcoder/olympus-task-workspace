# :: Problem description stays within the hard word cap (pass ≤1000 words, fail >1000)
Failed
Description is too long (1030 words). Maximum is 1000 words.

Raw Output

{
  "maxWords": 1000,
  "wordCount": 1030
}

# :: Problem description doesn't look AI-generated (line wrapping, em-dashes)
Warning
Description formatting looks AI-generated. Rewrite naturally (or paste from a normal editor) to make this signal go away:

- 4 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.

*This is a heuristic warning — adjust the wording and structure to match how you'd write it for a human teammate.*

Raw Output

{
  "blankLineRuns": 0,
  "emdashes": 0,
  "hardwrappedParagraphs": 0,
  "signals": [
    {
      "detail": "4 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.",
      "kind": "wall_of_text"
    }
  ],
  "wallOfText": 4,
  "wordCount": 1026
}

# :: Problem and tests are good quality (AI, up to 1 min)
Warning
Summary: Tests and problem description are well-aligned and high quality overall; minor robustness concerns in the test runner script should be considered.

Details:
1. No test leakage [OK]: The problem statement does not reference or expose any test classes, files, or logic introduced by the patch; it only specifies behavior and public configuration/properties.

2. Tests cover required behavior [OK]: The suite thoroughly exercises integrity modes, entry classifications (broken/resolved/misplaced/shared/colliding/occupied/unowned), symlink/hardlink handling, saving/forgetting semantics, permissions and safety constraints, concurrency guarantees, fail reporting order/content, index rewrite conditions, and built-in/strategy file naming (stability, charset, length, uniqueness), matching the detailed problem requirements.

3. Tests focus on behavior [OK]: Validations are based on public API calls, filesystem side effects, and error messages; they do not enforce internal implementation choices beyond explicit behavior guarantees (e.g., not rewriting the index when unchanged).

4. Sanity and professionalism [WARNING]: test.sh’s XML checker uses Java single-file source execution (java path/to/MalformedXml.java), requiring Java 11+; if unavailable, all files are flagged as malformed, potentially causing false failures. Consider compiling the helper with javac for broader compatibility. Tests also assume POSIX filesystem features (symlinks, chmod) which is fine for Linux CI but could be brittle on non-POSIX environments. Consider improving test.sh robustness; tests themselves are otherwise coherent and feasible.

Please ensure:
- No references to test files/functions or test logic
- Tests cover required behavior
- Tests focus on behavior, not implementation details
- Tests are well-formed and coherent

Raw Output

{
  "all_issues": "Summary: Tests and problem description are well-aligned and high quality overall; minor robustness concerns in the test runner script should be considered.\n\nDetails:\n1. No test leakage [OK]: The problem statement does not reference or expose any test classes, files, or logic introduced by the patch; it only specifies behavior and public configuration/properties.\n\n2. Tests cover required behavior [OK]: The suite thoroughly exercises integrity modes, entry classifications (broken/resolved/misplaced/shared/colliding/occupied/unowned), symlink/hardlink handling, saving/forgetting semantics, permissions and safety constraints, concurrency guarantees, fail reporting order/content, index rewrite conditions, and built-in/strategy file naming (stability, charset, length, uniqueness), matching the detailed problem requirements.\n\n3. Tests focus on behavior [OK]: Validations are based on public API calls, filesystem side effects, and error messages; they do not enforce internal implementation choices beyond explicit behavior guarantees (e.g., not rewriting the index when unchanged).\n\n4. Sanity and professionalism [WARNING]: test.sh’s XML checker uses Java single-file source execution (java path/to/MalformedXml.java), requiring Java 11+; if unavailable, all files are flagged as malformed, potentially causing false failures. Consider compiling the helper with javac for broader compatibility. Tests also assume POSIX filesystem features (symlinks, chmod) which is fine for Linux CI but could be brittle on non-POSIX environments. Consider improving test.sh robustness; tests themselves are otherwise coherent and feasible.",
  "no_test_leakage": {
    "explanation": "The problem description does not mention or depend on any tests added in this patch. It explains desired behaviors, properties, and public interfaces (e.g., default.integrity, default.fileNames, RuleViolationFileNameStrategy) without referencing specific test files or methods. There are no references to the newly added FreezeStoreMaintenance_e448f3_Test or build changes. Thus, no leakage of test logic is present.",
    "status": "OK"
  },
  "sanity_check": {
    "explanation": "Overall the tests and problem are coherent and professionally structured. One minor fragility is the test.sh XML validation helper invoking 'java <file.java>' (single-file source execution), which requires Java 11+. If unavailable, the script treats all result XML as malformed, potentially turning a passing run into a failure. Compiling the helper with javac then running the class would be more robust. The tests also rely on POSIX filesystems, symlinks, and permissions—appropriate for typical Linux CI, but could fail on non-POSIX filesystems. Aside from these caveats, the setup is reasonable and feasible.",
    "status": "WARNING"
  },
  "tests_cover_required_behavior": {
    "explanation": "The added test suite is extremely comprehensive and validates all major behaviors described: integrity modes (ignore/repair/fail) including unknown/near-miss values; classification and handling of broken/resolved/misplaced/shared/colliding/occupied/unowned entries; symlink/hardlink behaviors (including links outside folder and dangling links); behavior of saving new/existing rules, safety around index path, absolute or escaping paths, and not overwriting unowned files; rule forgetting semantics under repair and permissions edge cases; concurrency during initialization and saving, blocking and waiting semantics; ordering and content of fail reports; index rewrite behavior (only when modified) including byte equality and mtime stability; default.fileNames strategies (random/description) including determinism, length/charset constraints, stability across locales/machines, uniqueness for similar descriptions; and instantiation/validation of custom strategy classes including wrong types, constructor requirements, and no-name cases. The tests also re-validate state after operations and cross-run stability. No major requirement from the description appears untested.",
    "status": "OK"
  },
  "tests_focus_on_behavior": {
    "explanation": "Assertions focus on observable public behavior and side effects: filesystem contents, index entries/serialization, thrown exceptions and messages (including ordering), and store APIs (initialize, contains, getViolations, save). Where internal timing/concurrency is involved, tests simulate via public-facing effects (e.g., waiting until a save is in progress). Checks like not rewriting the index (bytes/mtime) are justified by the description's explicit promise to only write if entries changed. No tests require inspecting private internals or algorithmic steps beyond what the description defines.",
    "status": "OK"
  }
}
Close