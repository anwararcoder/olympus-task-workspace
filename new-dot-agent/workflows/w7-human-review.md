# W7 — Human Review Handling

**Input:** `{problem}-human-reviews.md` notes. **Output:** point-by-point FIXED / Justified
responses, recorded in the same file, with gates protected.

**Reviewer notes are Discord justifications, NOT a section in the description file.** Never
pre-emptively add a "Reviewer Notes" block to the deliverable; keep justifications to 1-2 sentences,
sent when the reviewer raises a concern. Common patterns: "tests reference solution code" → a build
tag / reflection isolates the feature tests; "exact error strings are brittle" → the message is a
user-facing contract the repo's own tests pin; "this test is a surprise" → it's inferable from
clause X.

1. Record the notes verbatim in `{problem}-human-reviews.md` (append, dated round).
2. For each note, classify BLOCKER vs SUGGESTION (ask if unclear — re-staling all checks over a
   deferrable note is the expensive mistake).
3. For each, decide with evidence:
   - **FIX** when the reviewer is right. Before fixing, verify the claim against the live base
     repo — then fix at the source and sweep the class.
   - **JUSTIFY** when complying would break a principle (pin a free implementation choice, test
     prompt-unstated behavior). Write the justification; reviewers accept solid reasoning.
   - **CONCEDE on base-behavior conflicts.** When a reviewer shows a requirement fights
     documented repo behavior, concede and re-scope — defending it never wins (secret-rotation's
     freshness clause: author argued, reviewer narrowed correctly, author conceded; the lesson is
     to verify-then-concede in one round, not three).
   - **ESCALATE duplicates:** a duplicate/similarity flag is a line-of-work blocker — archive and
     pivot, never reword-in-place.
4. **Treat reviewer concerns as difficulty data too** (new): a reviewer saying "this is stronger
   than the repo's behavior" or "agents will find this easy" is a ceiling signal — feed it into
   the W5 ceiling check rather than only defending fairness.
5. Mind staleness: deliverable edits re-stale everything (fresh batches required); confirm
   blocker-status before any deliverable edit. QA-only and reviewer-notes edits do not stale.
6. Ledger line + Phase A if strategy changed; respond point-by-point; confirm with the owner before
   resubmitting.
