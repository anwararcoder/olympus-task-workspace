# 01 :: Problem description doesn't look AI-generated (line wrapping, em-dashes)
Warning
Description formatting looks AI-generated. Rewrite naturally (or paste from a normal editor) to make this signal go away:

- 2 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.

*This is a heuristic warning — adjust the wording and structure to match how you'd write it for a human teammate.*

Raw Output

{
  "blankLineRuns": 0,
  "emdashes": 0,
  "hardwrappedParagraphs": 0,
  "signals": [
    {
      "detail": "2 paragraphs are 150+ words of unbroken prose. Break long prose into bullets or shorter paragraphs — wall-of-text dense paragraphs are a common AI-output shape.",
      "kind": "wall_of_text"
    }
  ],
  "wallOfText": 2,
  "wordCount": 642
}
Close

# 02 :: Problem and tests are good quality (AI, up to 1 min)
Warning
Summary: Tests align very well with the problem and provide comprehensive behavioral coverage; minor environment-dependency risks exist.

Details:
1. No test leakage [OK]: Problem statement does not mention or depend on any newly added test files, classes, or Gradle tasks; it only specifies product behavior.

2. Tests cover required behavior [OK]: Extensive coverage of integrity modes, entry classifications, file/link edge cases, naming rules and constraints (including determinism and stability), permissions and deletion failures, concurrency guarantees, and report ordering.

3. Tests focus on behavior [OK]: Assertions check public behaviors (filesystem effects, API results, error message ordering per spec) rather than internal implementation details.

4. Sanity/professionalism [WARNING]: Some tests rely on POSIX features (symlinks/hardlinks, chmod), WatchService timing, and an external 'setpriv' tool to simulate unprivileged behavior. In environments without these capabilities, tests may be flaky or fail. Consider improving tests by avoiding external tool dependencies (or skipping that branch when unavailable) and guarding OS-specific assumptions.


Please ensure:
- No references to test files/functions or test logic
- Tests cover required behavior
- Tests focus on behavior, not implementation details
- Tests are well-formed and coherent

Raw Output

{
  "all_issues": "Summary: Tests align very well with the problem and provide comprehensive behavioral coverage; minor environment-dependency risks exist.\n\nDetails:\n1. No test leakage [OK]: Problem statement does not mention or depend on any newly added test files, classes, or Gradle tasks; it only specifies product behavior.\n\n2. Tests cover required behavior [OK]: Extensive coverage of integrity modes, entry classifications, file/link edge cases, naming rules and constraints (including determinism and stability), permissions and deletion failures, concurrency guarantees, and report ordering.\n\n3. Tests focus on behavior [OK]: Assertions check public behaviors (filesystem effects, API results, error message ordering per spec) rather than internal implementation details.\n\n4. Sanity/professionalism [WARNING]: Some tests rely on POSIX features (symlinks/hardlinks, chmod), WatchService timing, and an external 'setpriv' tool to simulate unprivileged behavior. In environments without these capabilities, tests may be flaky or fail. Consider improving tests by avoiding external tool dependencies (or skipping that branch when unavailable) and guarding OS-specific assumptions.\n",
  "no_test_leakage": {
    "explanation": "The problem statement does not reference any files, classes, or logic added by the test patch (e.g., FreezeStoreMaintenance_e448f3_Test, test.sh, or custom Gradle tasks). It only describes behaviors and configuration for TextFileBasedViolationStore at a product level. No new test implementation details are leaked in the description.",
    "status": "OK"
  },
  "sanity_check": {
    "explanation": "Overall the tests and harness are coherent and professional. One potential fragility: a few tests depend on POSIX permissions, hard/symbolic links, and the external 'setpriv' tool to drop privileges when the directory remains writable (e.g., running as root). In environments lacking 'setpriv' or POSIX semantics, these could fail. The suite also launches separate JVMs and uses WatchService—reasonable but environment-sensitive. Build wiring via Gradle custom tasks is consistent, and the test.sh merges JUnit XML robustly. No blatant errors found, but consider guarding OS/tool-specific paths more defensively to avoid flakiness.",
    "status": "WARNING"
  },
  "tests_cover_required_behavior": {
    "explanation": "Coverage is very thorough. The tests exercise all major behaviors specified: integrity modes (ignore/repair/fail) including invalid values; exact semantics of broken/resolved/misplaced/occupied/shared/colliding/unowned; index handling (creation, non-rewrite when unchanged, symlink/absolute path/nested path rejections); naming strategies (default/random/description/custom class, constructor-provided vs configured, no-arg/public checks, null/empty name failures, deterministic/stable naming across runs/locales); name constraints (ASCII/[-_]/<=200 chars, never 'stored.rules', keep a 4–120 char word from description, distinctness for similar descriptions); save semantics (never overwrite index/outside/unowned files, resolution-forget logic under repair, concurrency save/initialize interactions, link handling, file deletion failure behavior); ordering in 'fail' reports; and concurrency guarantees (no examination during in-progress save, resulting readable index). No major requirement in the description appears untested.",
    "status": "OK"
  },
  "tests_focus_on_behavior": {
    "explanation": "Assertions target observable behavior via the public API and filesystem effects: presence/absence of entries and files, contents, naming, rejection conditions, and ordering within error messages as specified. While specific details like timestamp checks and message token ordering are asserted, these directly validate stated behavioral requirements (e.g., index isn’t rewritten if nothing changes; fail report ordering). The tests do not require internal/private implementation details.",
    "status": "OK"
  }
}
Close

# 03 :: Description Quality
Verdict

Summary

The task is technically precise and test-aligned, but several dense, multi-clause rules need splitting before implementation work can begin confidently.

Completed in 119.3s

Raw Output

{
  "completed": true,
  "evaluation": {
    "comments": [
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "An entry is broken when its resolved path is not a regular file directly in the folder, and resolved when that file yields no violations, as a file of line breaks alone (`\\n`, `\\r\\n` or a lone `\\r`) does; a carriage return inside a stored violation stays part of its text.",
        "severity": "minor",
        "suggestion": "Split this into named definitions so the classification rules do not have to be reconstructed from one compound sentence: “An entry is broken when its resolved path is not a regular file directly in the folder. It is resolved when that file yields no violations; files containing only `\\n`, `\\r\\n`, or lone `\\r` line breaks count as resolved. A carriage return inside a stored violation remains part of that violation’s text.” This preserves the tested conditions while making their precedence and scope readable.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch has dedicated tests for broken entries, empty and line-break-only files, and carriage returns within violations (for example, `anEntryWhoseFileIsAbsentIsBroken`, `aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks`, and `carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved`). The suggestion retains every condition and value.",
          "searchedFor": "broken, resolved, carriage return, line breaks"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "An entry is misplaced when its name is not its rule's derived one, and occupied when it is misplaced and its derived name already names something, is recorded by another entry, or escapes the folder; an entry recording its derived name is never occupied.",
        "severity": "minor",
        "suggestion": "Break the nested definition into short rules: “An entry is misplaced when its recorded name differs from its rule’s derived name. A misplaced entry is occupied when its derived name already exists, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied.” The current coordination makes it unnecessarily difficult to tell which predicates apply only to misplaced entries.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch explicitly tests misplaced entries, occupied derived names, escaping names, and entries already recording their derived name, including `anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs`. The proposed rewrite preserves the tested terms and rules.",
          "searchedFor": "misplaced, occupied, derived name"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "Storing a rule never writes over the index, whatever name leads to it, over anything outside the folder, or over a file its own entry does not record.",
        "severity": "minor",
        "suggestion": "Use a direct subject for each safety rule: “When saving, the store must not overwrite the index, including through an alternate path; write outside the folder; or overwrite a file not recorded by that rule’s own entry.” This removes the ambiguous repeated “over” construction without changing the protection requirements.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch covers all three protections: saves targeting the index via direct, alternate, symbolic-link, and hard-link names; names outside the folder; and unowned or another rule’s file. The rewrite retains each tested safety constraint.",
          "searchedFor": "writes over the index, outside the folder, own entry"
        }
      }
    ],
    "formattingChecks": {
      "hardWrap": {
        "detected": false,
        "evidence": "",
        "note": "Paragraphs are long single lines rather than text wrapped at a recurring fixed column."
      },
      "headerScaffolding": {
        "detected": false,
        "evidence": "",
        "note": "The raw description has no markdown section headers or generated-spec heading skeleton."
      },
      "titleDuplication": {
        "detected": false,
        "evidence": "",
        "note": "The problem description begins directly with the task statement rather than a markdown title repeating “Freeze store integrity maintenance”."
      }
    },
    "summary": "The task is technically precise and test-aligned, but several dense, multi-clause rules need splitting before implementation work can begin confidently.",
    "verdict": "FAIL",
    "verdictBasis": {
      "dropped": [],
      "majors": 0,
      "minors": 3,
      "unanchoredFormattingDetections": 0
    }
  },
  "executionTimeSeconds": 119.296967,
  "summary": "The task is technically precise and test-aligned, but several dense, multi-clause rules need splitting before implementation work can begin confidently.",
  "verdict": "FAIL"
}
Close