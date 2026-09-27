# Writing style for everything sent to the platform

The final text is written by hand, in my words. AI drafts the analysis, never the prose that
ships (nienterfall's one rule, confirmed by the manager warning on the pactum review: "the
feedback I read has obvious AI-written parts").

## Hard bans (any of these = rewrite the sentence)

- Em dashes (U+2014) and any non-ASCII punctuation. Use a comma, colon, or plain hyphen.
- Praise intros before the point: "Nice submission, this is a hard, fair, well-built feature."
  Open with the point. "Good task, but a few things need fixing first." is the approved ceiling.
- Hedge and filler phrases: "it's worth noting", "for the record", "that said", "overall",
  "in summary", "importantly", "not worth a point".
- Meta framing that tells the reader what they need instead of the thing itself: "What needs a
  human is X" / "A manager wants to see Y". Just say the fact.
- Label-style lines: "Fit:", "Fairness:", "Quality 3/7: plausible idea with real breadth, but...".
  Write sentences.
- Restating the same finding in checklist, feedback, and notes. Each section adds something or
  says nothing.
- Obvious statements as content: "MIT is on the allow-list", "the base commit is pinned".
- Superlatives and balance-sheet rhythm ("solid X with real Y, held down by Z").

## Author-facing sections carry issues only (owner rule, 2026-07-02)

Per-field reasons and Other notes name defects and actions, nothing else. No "the suite is
strong", no "repo fit is clean", no green-check inventory, no local-run success stories. If a
category has no issue, it gets no sentence (Other notes: "None."). Everything positive or
contextual lives in Illustrations for the owner. Praise framing before a gap list reads as
hedging and buries the ask.

## What good looks like

- Defect first, then the fix. Never the process that found it: "I ran the suite against two mutated
  references" is Illustrations material; the author reads "the suite never checks X, so a solution
  that does Y passes; add a test asserting Z."
- One fact or one action per sentence. "R13 and the two closing regression tests check the same
  thing. Trim one side."
- Reviewer-transcript register (the accepted diamond reviews): "the test checks X, the agent did
  Y, the prompt says Z."
- Reasons under 3 are written to the author: name the exact test/file/paragraph, say the fix.
- Other notes carry the decision reasoning in a few short sentences a manager can scan at
  50 tasks/hour: what was checked, what was found, why the decision follows.
- It should read like a Discord message from a person who did the work, not a report.

## Recommendation discipline (owner rules, 2026-07-08..10)

- Issue first, then the fix direction: root-cause level, respecting the repo's own standards and
  the grading sandbox (docker --network=none). Never suggest what violates either.
- Not sure the fix is right? State the minor without a recommendation.
- Never prescribe an exact test filename; the platform convention is a hash/ID suffix against
  collisions. Describe the test to add, not the file to create.
- Description-edit asks are last resort: a description change can break the whole task. Prefer
  test- or solution-side fixes.
- Mechanism names stay in Illustrations; author-facing text names the behavior.
- One root cause = one finding in one place, even when two checks report it.
- A point running three paragraphs gets rewritten: one issue, a few short sentences, actionable.

## Self-test before submitting

Read the author-facing text once, aloud-in-your-head, asking of each sentence: is this a fact or
an action? Would I type this to a colleague? Does any sentence repeat an earlier one? Delete
anything that fails. Then grep the text for non-ASCII as a final check.
