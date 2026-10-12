# Task Prompt Quality
Verdict

FAIL
Task prompt is too prescriptive

This check can't be contested. Focus on behavior instead of implementation details and write the description like how you would prompt an LLM, then re-run the check.

Summary

The task is technically precise and test-aligned, but several long, nested sentences make important filesystem rules unnecessarily hard to parse.

Completed in 159.3s

Raw Output

{
  "completed": true,
  "evaluation": {
    "aiDetection": {
      "blocking": true,
      "fractionAi": 1,
      "fractionAiAssisted": 0,
      "mode": "blocking",
      "prediction": "AI",
      "threshold": 0.5,
      "wordCount": 828
    },
    "comments": [
      {
        "category": "ai_generated",
        "presentationOnly": false,
        "quote": "Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.",
        "severity": "major",
        "suggestion": "This description was detected as AI-generated. Rewrite it in your own words.",
        "testPatchCheck": {
          "foundInTestPatch": false,
          "reasoning": "Constructed from an AI-detection window.",
          "searchedFor": ""
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "The store rejects that write, leaving the index and the folder as they were,",
        "severity": "minor",
        "suggestion": "Split this into direct rules while retaining every condition: “Reject the write without changing the index or folder when the name leads to the index, including an alias through a symbolic or hard link, or anywhere outside the folder. For a rule with no entry, also reject a name that already exists or is recorded by another entry.” The original makes the safety conditions difficult to extract from its nested clauses.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch has tests for writes through symbolic and hard links to the index, names outside or nested under the folder, existing unowned files, and names recorded by another entry. The suggestion retains those conditions and only reorganizes the prose.",
          "searchedFor": "storingARuleNeverWritesOverTheIndex, symbolic link, hard link, recorded by another entry"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "Apart from the index, a regular file directly in the folder that no entry's name leads to",
        "severity": "minor",
        "suggestion": "Use two sentences with named subjects: “A regular file directly in the folder is unowned when no entry leads to it, directly or through a symbolic link. The index is never unowned.” This preserves the definition but avoids the stacked relative clauses.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch explicitly tests unowned files, files reached through symbolic links, and that stored.rules is not unowned. The proposed wording keeps all of those semantics.",
          "searchedFor": "unowned file, symbolic link, theIndexItselfIsNeverUnowned"
        }
      },
      {
        "category": "tone",
        "presentationOnly": true,
        "quote": "Stores initializing or saving concurrently in one process leave a readable index",
        "severity": "minor",
        "suggestion": "State the concurrency guarantee as two direct sentences: “Concurrent initialization and save operations in one process must leave the index readable and the folder containing only the index and surviving files. Initialization must not examine a save that is still in progress.” This is easier to scan without changing the guarantee.",
        "testPatchCheck": {
          "foundInTestPatch": true,
          "reasoning": "The patch contains tests for concurrent repairs producing a readable index and for repair/fail initialization waiting while a save is in progress. The suggestion retains both tested guarantees.",
          "searchedFor": "concurrentInitializationsLeaveAReadableIndex, examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave"
        }
      }
    ],
    "summary": "The task is technically precise and test-aligned, but several long, nested sentences make important filesystem rules unnecessarily hard to parse.",
    "verdict": "FAIL",
    "verdictBasis": {
      "aiDetectionBlocking": true,
      "dropped": [],
      "majors": 1,
      "minors": 3
    }
  },
  "executionTimeSeconds": 159.306635,
  "summary": "The task is technically precise and test-aligned, but several long, nested sentences make important filesystem rules unnecessarily hard to parse.",
  "verdict": "FAIL"
}
Close