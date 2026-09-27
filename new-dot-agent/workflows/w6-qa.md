# W6 — QA Authoring & Audit Loop

**Input:** all gates green + auto-review approval + owner-supplied test-group list + settled human
concerns (pre-QA huddle done). **Output:** per-run evaluations + diamond artifacts, audit
all-`true`. **Rules:** `rules/qa-authoring.md` (+ the full manual `olympus-tmp-files/start-qa.md`),
`rules/fairness-and-review-flags.md` §E.

**QA is itself a fairness gate, not paperwork.** Diamond REQUIRES failure QA. If, while analyzing a
failing run, you find a test is unfair or underspecified, you do NOT spin an agent-fault story —
you ESCALATE back to W5 (fix the task, re-run the pipeline). A submission that forwards a known
unfair test is reverted later at far higher cost.

1. **Pre-QA risk huddle** (mandatory, new): confirm no open human-review concern, no gate about to
   stale, and the verdict story per run is settled (XML + patch are the authority; the eval JSON
   can be wrong). QA written under unsettled conditions becomes rework (carve: 12-note revision).
2. Write per-run evaluations (one per saved run, exact dir-basename prefix) and the diamond
   artifacts (consume the owner's test-group list in full). Vary prose across the batch; per-run
   isolation absolute.
3. **Self-audit sweep on every file before submitting** — grep your own drafts for every §E trap
   (backticked file:line, non-literal tokens, absolutes, unresolvable step_ids, em-dashes,
   template openers...). Fix every hit; re-derive every touched citation.
4. Owner submits; audit returns `{problem}-qa-audit.json` (read-only). For each `mixed`/`false`:
   fix at the source, then **sweep the mistake class across all files** (the audit samples — the
   class, not the instance, is what's broken). Re-derive citations after every wording edit.
5. Iterate to all-`true`. QA-only edits do not stale the platform checks — keep fix rounds
   strictly inside QA artifacts. Ledger line per round: flagged count, classes, sweep done.
