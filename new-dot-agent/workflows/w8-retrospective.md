# W8 — Retrospective (mandatory at every terminal event; this is how the system improves)

**Trigger:** task ACCEPTED, KILLED, REVERTED, or DOWNGRADED — no exceptions. Also after any
platform-requirement change. **Output:** lessons files + rule updates. **Rule:**
`rules/documentation-ledger.md` §4.

1. Read the task's `{problem-name}-ledger.md` end-to-end (this is why it exists). Answer in writing:
   - At which STAGE was the decisive outcome (good or bad) actually born?
   - What was the EARLIEST moment it was detectable, with which signal? Was that signal available
     under this workflow's gates (W1 A/B/C, W2, the W5 ceiling check)? If yes and missed — why
     (which step was skipped or rationalized)? If no — what new gate would have caught it?
   - Which levers were tried that a rule should have pre-killed?
   - How many rounds went undocumented or under-documented? (target: zero)
2. Write `lessons/{kebab-name}.md`: one-line summary, the evidence (dated, with the n behind it;
   single observations say "observed once — a prior to check, not a gate"), the stage it applies
   to, the rule/workflow it should change. Add the line to `lessons/INDEX.md`.
3. **Re-validate, don't just add**: check whether this retrospective's evidence CONTRADICTS any
   existing lesson. If so, apply the revision protocol (`rules/documentation-ledger.md` §4):
   append a dated Revised/Superseded section to that lesson, update its INDEX line, and correct
   any rule it had shaped — never silently delete history.
4. **Propagate**: if the lesson contradicts or extends a rule, EDIT THE RULE in the same sitting
   (numbers → only `rules/platform-bar.md` + its changelog). A lesson that doesn't change a rule
   or add a check is an anecdote — prefer turning it into a gate.
5. If the platform changed a requirement: update `platform-bar.md` + changelog, then grep the
   rules/workflows for any newly-invalidated guidance (there should be none outside platform-bar —
   that is the point of the numbers rule — but verify), AND re-check every lesson whose INDEX line
   names the old bar — gate-bound lessons are exactly the ones a bar change can invalidate.
6. Tell the owner the one-paragraph version: what we learned, what changed in the system.

The old workflow's deepest gap was that fifteen weeks of pain produced lessons that lived in one
assistant's memory and a few onboarding docs. This workflow makes every ordeal — and every win —
compound into the file-based system any future agent on any provider will load.
