---
description: Document iteration progress with structured commit message
---

# Write Commit Message

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

Create a commit message documenting the current iteration state.

## Steps

1. **Read current state**
   - Check which version number this will be (look at git tags)
   - If it's the initial version then see what we are trying to do (our problem), then what are the content of the current work (our approach), then check the results (auto-review JSON, agents-run artifacts, AI evaluation, human reviews, legacy AI report, or anything the user is saying)
   - Identify what changed since last version
   - Check whether this iteration is blocked by duplicate/similarity findings
   - Read `{problem-name}-auto-review.json`, `{problem-name}-agents-runs/`, `{problem-name}-ai-evaluation.md`, `{problem-name}-human-reviews.md`, or older `*-ai-report.md` files when present

2. **Structure the message**
   ```
   problem-name: Brief summary of changes

   == Problem ==
   What issue does this iteration address?
   - Previous version's AI pass rate
   - Specific failures or feedback
   - Precision/quality check failures

   == Approach ==
   What changes were made?
   - Description updates (quote exact changes)
   - New tests added (list with purpose)
   - Solution refactoring
   - Reviewer notes added/removed

   == Results ==
   What are the new AI difficulty numbers?
   - X% (N/M passed)
   - List verdict types (FAIL_WRONG_LOGIC, PASS_LEGITIMATE, etc.)

   == Submission Status ==
   Is this iteration deliverable?
   - Accepted / Pending / Blocked
   - If blocked, state exact blocker (e.g., duplicate/similarity) and key evidence

   == Analysis ==
   Why did the results change?
   - What caused pass rate to increase/decrease?
   - Are there remaining issues?

   == Next Steps (if applicable) ==
   What should be done in next iteration?
   ```

3. **Next-plan rule**
   - Do not create or update `{problem-name}-next-plan.md` as part of this workflow unless the user explicitly asks for a next plan.
   - When explicitly requested, write the next plan as the post-commit iteration strategy and leave the immutable `{problem-name}-plan.md` unchanged.
