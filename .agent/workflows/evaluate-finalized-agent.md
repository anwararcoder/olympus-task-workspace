---
description: Analyze one finalized Castor agent run and write a success or failure evaluation file in a separate problem-level QA directory
---

# Evaluate Finalized Agent

## When to Use

Run this workflow after a problem is finalized and ready for QA, when the user wants a deep analysis of one specific Castor agent run.

This workflow is designed for directories like:

`my-work/{problem}/...-agents-runs/...-agent-X/`

where `X` is the run index, not the platform hashtag.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Goal

For the chosen run, produce one internal markdown file in a separate problem-level QA directory:

- `{agent-directory-name}-success-evaluation.md` for a legitimate passing run
- `{agent-directory-name}-failure-evaluation.md` for a legitimate failed run

Use a sibling QA directory under the problem root named `{problem-name}-QA`, where `{problem-name}` is the shared prefix used by `{problem-name}-agents-runs` and `{problem-name}-agent-X`.

Example: if the run directory is `kwargs-fork-agent-9`, the QA directory should be `kwargs-fork-QA`, and the output file must be either `kwargs-fork-agent-9-success-evaluation.md` or `kwargs-fork-agent-9-failure-evaluation.md` inside that QA directory.

The document must be human-written, evidence-based, and easy for a reviewer who does not know the repo to understand.

If you are writing multiple evaluations in one batch, do not let them all open the same way or follow the same paragraph skeleton. The final set should read like separate PR comments written by the same experienced reviewer, not like one template copied ten times.

For passing runs especially, the goal is to prove the implementation is correct requirement by requirement, not to write persuasive-sounding prose about why it "seems right."

## Inputs

You need:

1. The problem work directory, for example `my-work/risor-kwargs-forks`
2. The agent run index `X`
3. The current public task artifacts in the problem directory
4. The chosen agent-run directory and its artifacts

## Step 1: Read Standards First

Before touching the run artifacts, read:

1. `standards/WORKFLOW.md`
2. `standards/Olympus-Diamond-Tier-Failure-Analysis-Guide.md`
3. `.agent/rules/finalized-agent-evaluation.md`

Then read the task-specific files in the problem directory:

- immutable `{problem-name}-plan.md`, if present, for intended scope and known traps
- description file
- test patch
- provided solution
- `{problem-name}-auto-review.json`, `{problem-name}-ai-evaluation.md`, and diamond artifacts, if relevant
- human reviews, if relevant

Do not start from the agent's provided solution alone. You must know the public contract before deciding whether the run is right or wrong.

If the user also asks you to create or revise diamond artifacts, treat that as a separate evidence artifact from the per-agent QA files. Diamond artifacts describe the test suite and expected solution shape; per-agent QA files judge one run. Do not mix source-count notes, UI quirks, or one-off verifier confusion into the diamond artifact unless the reviewer explicitly needs that explanation.

## Step 2: Locate the Chosen Run Directory

Find the run directory using the agent index, not any external run ID.

Example shape:

```text
my-work/{problem}/{problem}-agents-runs/{problem}-agent-X/
```

Also identify or create the sibling QA directory:

```text
my-work/{problem}/{problem}-QA/
```

Here `{problem}` means the shared run prefix, not necessarily the outer work-directory name. In the kwargs example, the run directory prefix is `kwargs-fork`, so the QA directory is `kwargs-fork-QA`.

## Step 3: Determine the Evaluation Path

Read `*evaluation.json` first and branch from the verdict.

### Success path

Use the success path when the verdict is a legitimate pass, such as:

- `PASS_LEGITIMATE`

### Failure path

Use the failure path when the verdict is an agent fault, such as:

- `FAIL_WRONG_LOGIC`
- `FAIL_MISSED_REQUIREMENT`
- `FAIL_INTEGRATION_ERROR`

### Escalation path

If the artifacts show environment breakage, unfairness, prompt ambiguity, or test overreach, stop the blame analysis and surface a task-fault finding instead. Do not manufacture an agent-fault story when the task itself is the issue.

## Step 4: Read Evidence in the Right Order

Use this order every time:

1. `*evaluation.json`
2. `*base-tests.xml` and `*new-tests.xml`
3. the agent's provided solution (`*solution.patch`)
4. targeted parts of `*trajectory.json`

This order matters.

- The evaluation JSON gives the claimed summary.
- The XML files tell you what actually passed or failed.
- The agent's provided solution tells you whether the technical story is real.
- The trajectory tells you where the key insight or mistake came from.

Problem-level auto-reviews, legacy AI reports, human-review summaries, and old evaluator notes are context only. They can be stale. The per-run XML, patch, trajectory, and saved evaluation artifact for the run you are scoring are the authority.

`*-qa-audit.json` files are also context only. They are downloaded from the platform after QA submission and AI checks, and must be treated as read-only platform output. Use their findings to decide what to fix in QA markdown, diamond artifacts, plans, or process docs; do not edit the audit JSON itself.

When the test patch and the JUnit source disagree, use the JUnit XML for per-run pass/fail facts and use the test patch to understand the test intent. If the user or UI explicitly selects one source for a diamond/test-description artifact, align the grouped test list to that selected source. If a test appears only in the patch but later appears in regenerated JUnit, put it in the appropriate functional group rather than leaving a stale separate note.

## Step 5A: Success Path

If the run is a legitimate pass, answer the required question:

Write that answer as one `**Justification:**` block in the final markdown rather than splitting it into multiple rubric subsections.
Put the text within codeblock, so it will be like this:

**Justification**

```
The Justification block
```

Treat this as a certainty exercise. A strong success note should read like a reviewer who checked every major public requirement and did not find a credible hidden bug path, not like someone arguing from vibes.

### Success analysis checklist

- Confirm baseline tests passed.
- Confirm new tests passed.
- Confirm the hidden tests were not modified.
- Break the task description into its major public requirement clusters and cover each one explicitly.
- Identify the architectural changes in the provided solution that satisfy each requirement cluster.
- Explain why those changes match the literal prompt requirements, not just a paraphrased version of them.
- If the prompt includes a final catch-all integration clause, treat it as a separate requirement cluster and name each covered surface explicitly instead of folding it into a generic summary paragraph.
- Check for obvious regression risks in the touched subsystems.
- Decide whether the implementation would survive expert review as the cleanest repo-aligned implementation in the run.
- If code review plus XML are not enough to support a high-confidence claim, do targeted local validation or debugger inspection before scoring it as a `4` or `5`.

### What to emphasize

- Every major requirement from the task description, handled one by one
- The exact implementation evidence that satisfies each requirement
- Why the agent did not merely overfit tests
- Why baseline behavior still appears safe after the checks you actually performed
- Why a repo expert would see this as complete and clean, not just passing
- Accurate evidence boundaries when artifacts are partial. If regenerated output is visible in the patch but the logs do not explicitly show regeneration work, describe that distinction accurately instead of implying the logs proved more than they did.

When writing several passing notes in one batch, do not default to the same paragraph order every time. Lead with the strongest run-specific evidence, whether that is default semantics, compiler/VM plumbing, pipe support, or patch hygiene.

### What not to do

- Do not just say "all tests passed"
- Do not narrate the full development journey
- Do not compare line by line against the reference solution as if exact parity were required
- Do not lean on language like `convincing`, `legitimate pass`, `looks correct`, or `easiest place to see`. If a point matters, state the requirement and prove it.
- Do not end with a blanket claim like `the remaining interaction points are covered` unless those interaction points were named explicitly first.

### Confidence step

Choose a score from 1 to 5 using the scale in `.agent/rules/finalized-agent-evaluation.md`, and render it in the final markdown as `**Score:** N`.

### Optional issues step

Add an issue only when there is a real, review-worthy problem that does not change the run's legitimate pass verdict.

Typical cases are:

- a latent public API or integration gap outside the verifier's executed path,
- a repo-alignment problem a code reviewer would reasonably flag,
- or a deterministic but untested edge that the current verdict and reviewer process still want documented as a pass issue rather than reclassified as an agent failure.

Do not use the issues section for speculative style complaints, generic maintainability concerns, or task-fault material. If the issue proves the verifier itself is unfair or the task is ambiguous, escalate the task fault instead of hiding it in a passing note.

For each issue, keep `Severity` and `Category` as standalone fields, then add one short prose paragraph, optionally labeled `Justification`, that covers the exact failure mode and why it matters despite the passing verdict.

### Success output template

```markdown
# Success Evaluation

**Score:** 5

**Justification:**

```
[Explanation]
```

## Issues
### Issue 1

**Severity:** 4

**Category:** correctness

**Justification:**

```
[Describe the exact failure mode and why it matters despite the passing verdict.]
```

Skip `Issues` if none.

## Step 5B: Failure Path

If the run failed legitimately, answer the failure QA prompt by grouping failed tests by root cause.

### Failure analysis checklist

- Read `*new-tests.xml` and list every failed test case.
- Group failures by shared requirement and shared broken code path.
- Verify each group against the public prompt.
- Read the provided solution to identify the exact missing logic or wrong behavior.
- Read the trajectory only where needed to find the originating mistake.
- For each group, quote the exact task sentence or sentences that the failing tests are exercising.
- If a group spans multiple explicit prompt sentences, quote each one rather than citing only the broadest sentence.

### Grouping rules

Group tests together only when they share:

1. the same requirement cluster,
2. the same patch-level bug,
3. and the same mistaken assumption in the trajectory.

Separate groups when any of those differ.

If there is only one failing test, still create one group, but do not force a `Why grouped` subsection unless the grouping decision itself needs explanation.

Each failure group must be readable on its own. Do not make later groups rely on shorthand such as `downstream of Group 1` or `same bug as Group 1` without restating the direct requirement, the direct failing behavior, and the direct causal chain inside that later group.

### Required points for each group

Write all of these as visible subsections for the group, not as one merged justification paragraph:

1. Why these tests are grouped together
2. Unfairness check: Would a seasoned engineer have avoided this error? Is the requirement clear? Does the test correctly validate that public contract?
3. Root cause: Where in the trajectory did the error originate? Bad assumption, missed edge case, or convention over prompt?

Use visible labels so the reviewer can scan for them quickly. You can use either headings or numbered review points. Accepted examples often use numbered labels such as:

- `1. Why grouped:`
- `2. Fairness:` or `2. Unfairness check:`
- `3. Root cause:` or `3. Root cause analysis:`

Under those labels, write normal prose paragraphs rather than formulaic mini-rubric answers. When needed, add one ordinary follow-up paragraph after the root-cause point to pin the bug to the exact search, edit, or local test choice that missed the contract. Start from the run-specific evidence itself, not stock wrappers like `I do not see an unfairness issue` or `The wrong turn is`.

For `Fairness`, quote the exact prompt sentence or sentences being tested. A reviewer should be able to see the requirement immediately without reopening the task description.

If the group is anchored by a specific named test, make that test's main contract surface explicit rather than only describing the larger family label.

## Step 5C: Diamond Artifact or Test-Group Summary Path

Use this only when the user asks for diamond artifacts, test descriptions, or grouped verifier explanations. These are not success/failure evaluations for one agent run.

For each group of tests, answer the reviewer questions inside that group:

- what the group checks, with concrete inputs and expected outputs,
- which happy paths and edge cases are included,
- why those tests are fair under the task description,
- and how that group covers its slice of the added functionality.

Do not move the completeness answer into a detached global paragraph unless the target form explicitly asks for one. In most diamond-review UIs, "overall suite" means the grouped set currently being described, so fold the coverage explanation back into the relevant groups.

Use the test source the reviewer is actually judging. If the JUnit UI source is selected, group the JUnit-visible tests. If the test patch is selected or a missing JUnit test has been restored, include that test in its natural functional group. Avoid stale sections such as "patch-only test" after the source has been fixed or after the user says not to care about the mismatch.

Write these artifacts like a human explaining a test plan, not like a form response. Do not repeat openers such as `This group checks...` or `This is fair because...` across groups. Vary the prose and lead with the concrete behavior in that group.

### What strong failure analysis looks like

- cites the exact prompt sentence or clearly inferable repo convention,
- explains how the failed test case maps to that requirement,
- names the shared technical failure precisely,
- points to the patch hunk or missing logic,
- isolates the first meaningful wrong turn in the trajectory,
- opens each subsection with run-specific evidence rather than a reusable reviewer phrase,
- avoids hand-wavy blame language.

### Failure output template

```markdown
# Failure Evaluation

## Group 1: [short root-cause label]

### Tests
- TestNameA
- TestNameB

1. Why Grouped
[Explain why these tests share one requirement cluster and one broken code path.]

2. Fairness
[Quote the prompt, explain why the test is fair, and describe how the test validates that contract.]

3. Root Cause Analysis
[Explain where the trajectory went wrong and how the patch implements that mistake.]
```

Repeat for each group.
If it's only one test, then there's no "Why grouped" to answer.

## Step 6: Use the Trajectory Efficiently

Do not read the trajectory from top to bottom and summarize everything.

Instead:

1. Start from the verdict summary and test failures.
2. Identify the relevant symbols, files, or requirement phrases.
3. Search the trajectory for:
   - the first assumption about that behavior,
   - the edit that implemented it,
   - the final test or build feedback around it.

Capture only the snippets that support your final conclusion.
Prefer `step_id` citations in the final QA prose. If one step contains the wrong checklist item or edit, cite that step directly instead of describing a broad trajectory theme or relying on raw JSON line numbers.

The finished writeup should explain the origin of the success or failure, not replay the session.

## Step 6A: Keep Claims Artifact-Exact

Before saving, audit the wording for exact-looking claims.

Backticks make text look like artifact evidence. Use them only for strings, symbols, paths, or snippets that literally appear in the prompt, patch, XML, repo, or trajectory. If a test constructs a path dynamically, describe the construction in prose instead of writing placeholder text like `content/.../<slug>/file.jpg` as though it were copied from the artifact. If a fixture uses a Go field such as `linkURL`, do not rewrite it as TOML like `link_url = ...` unless that exact TOML appears in the source you read.

The same rule applies to code snippets with ellipses. Do not write placeholder snippets such as `<a href=...>` or `{{if x}}...{{end}}` inside backticks unless the artifact contains those literal characters. Say "the photo anchor needs a `LinkURL` conditional" or quote the actual template line.

Be equally strict about trajectory attribution. If the final patch reveals a bad assumption but the trajectory does not say that assumption out loud, write that distinction plainly. Use "the final patch still..." or "the code path shows..." instead of claiming "the trajectory decided..." or "the trajectory identified..." without a supporting trajectory snippet.

## Step 6B: Run the Human Precision Pass

Before saving, read the draft once as if you were the reviewer trying to disprove it.

Tighten any sentence that has a hidden assumption, a fuzzy actor, or a claim broader than the artifact supports. The goal is not to sound formal; the goal is to sound like a careful engineer who knows exactly what the evidence says.

Check for these failure modes:

- A prompt term was replaced with a nearby phrase that changes the meaning. Use the prompt's term unless the implementation detail matters, and explain the implementation detail separately.
- A conditional behavior was described without its precondition. Add the condition so the sentence cannot be read as unconditional.
- A function, phase, helper, or template was credited with work that another path performs. Name the exact mechanism instead.
- A test-group summary says "the tests check..." when only one named test checks that assertion. Tie the assertion to the named test.
- A trajectory claim is based on the final patch or a keyword search rather than a targeted trajectory snippet. Either cite the snippet or label the claim as patch-derived.
- A trajectory claim says the agent had "detailed reasoning," "spent real time," or "reached" a file without naming the concrete step where the relevant decision happened. Replace it with the exact `step_id` and a short quote.
- A code or template snippet is shown with ellipses or translated syntax. Quote the artifact exactly or describe the shape in prose.
- A passing-run `Issues` section contains style nits or weak preferences instead of review-worthy risks.
- Several sections start with the same stock sentence or follow the same paragraph rhythm. Rewrite them so each note starts from that run's concrete evidence.

For diamond artifacts and grouped test descriptions, do one extra check: every coverage sentence must be traceable to a specific named test or to the explicit task description. If the test group contains mixed assertions, split the paragraph so each assertion is attached to the right test. Do not call an exercised input list exhaustive unless the contract or tests make it exhaustive, and do not say a group proves ordering/timing unless the assertions directly observe that ordering.

## Step 7: Quality Gate Before Saving

Before you write the markdown file, verify all of these:

- Your conclusions match the XML and evaluation artifacts.
- Your fairness argument uses the public contract, not hidden expectations.
- Your provided-solution analysis is tied to real code changes or missing changes.
- Your trajectory evidence is minimal and relevant.
- Every backticked path, config key, selector, template snippet, or quoted value is either literal artifact text or clearly described as a path shape / computed value.
- You did not attribute reasoning to the trajectory unless a targeted trajectory snippet supports that reasoning. Patch-derived root causes should be labeled as patch-derived.
- You did not edit any `*-qa-audit.json` file. If an audit finding is correct, apply the fix to the underlying QA markdown or artifact that produced the finding.
- Your language is understandable to a non-repo expert.
- You did not include speculative or decorative criticism.
- If you wrote more than one evaluation, you removed repeated stock openers and obvious sentence-template reuse across the batch.
- Any passing note scored `4` or `5` proves the implementation requirement by requirement and does not rely on plausibility language.

If the analysis uncovers a task fault, stop and report that instead of writing a misleading agent evaluation.

## Step 8: Save the Output in the QA Directory

Write the output file into the sibling QA directory for the problem, not into the chosen run directory:

- `{agent-directory-name}-success-evaluation.md`, or
- `{agent-directory-name}-failure-evaluation.md`

The prefix must match the exact basename of the run directory.
The containing directory must be `{problem-name}-QA`.

Do not create both unless the user explicitly asks for a combined analysis artifact.

## Practical Notes for This Repo Layout

- The kwargs sample has three legitimate passes and multiple legitimate failures.
- Filenames vary slightly between runs, so always use wildcard discovery inside the selected run folder.
- Start from `*evaluation.json`, but never trust it blindly without checking XML and the patch.

## End Condition

You are done only when the chosen agent directory contains a clean, defensible markdown evaluation that another capable reviewer could read and agree with without needing to inspect the entire trajectory themselves.
