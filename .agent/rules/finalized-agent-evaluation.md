---
description: Standards for analyzing finalized Castor agent runs and writing confidential success or failure evaluation documents
---

# Finalized Agent Evaluation Rules

## Purpose

Use this rule when evaluating one finalized Castor or Olympus agent run after the task is locked and ready for QA.

The goal is not to retell the trajectory. The goal is to explain, with evidence, why the agent's implementation is correct or why it failed, in a way that a technically capable reviewer who does not know the repo can still follow.

## Core Principles

1. Be evidence-driven. Every important conclusion must come from the prompt, XML results, the provided solution, evaluation JSON, or targeted trajectory snippets.
2. Be fair before being critical. If the task or environment is at fault, say so directly instead of forcing agent blame.
3. Be confidential. These documents are internal QA artifacts, not public submission files.
4. Be human. check how humanize ai tool work, and not machine generated words.
5. Be concise. Explain the root cause or correctness story, not the full history of every tool call.
6. Be exact about the contract. When the task description states a requirement directly, quote it directly instead of relying on loose paraphrase.
7. Keep artifact purposes separate. Per-agent QA files judge one run; diamond artifacts explain the verifier suite and expected solution shape.
8. Treat `*-qa-audit.json` files as read-only platform output. They are downloaded after submitting QA and running AI checks; use them as review feedback, but do not edit them as source artifacts.
9. Review how human reviewers notes on other QAs and avoid repeating the same mistakes (IMPORTANT).

## Required Inputs

Before writing any evaluation, read these sources in this order:

1. `standards/WORKFLOW.md`
2. `standards/Olympus-Diamond-Tier-Failure-Analysis-Guide.md`
3. The current task files in the problem directory:
   - immutable `{problem-name}-plan.md`, if present, for intended scope and known traps
   - description file
   - test patch
   - provided solution
   - `{problem-name}-auto-review.json`, `{problem-name}-ai-evaluation.md`, and diamond artifacts, if relevant
   - human reviews, if relevant
4. The chosen agent-run directory under `*-agents-runs/`

Inside the agent-run directory, locate artifacts by wildcard pattern instead of hardcoded names because the file prefixes are not perfectly uniform across runs.

Agent `X` means the run-directory index such as `*-agent-X`, not the platform hashtag or external run identifier.

For diamond artifacts and test-description work, also inspect the test patch directly. JUnit XML is the authority for pass/fail outcomes of a saved run, but the test patch is often the clearest source for inputs, expected outputs, and edge-case intent.

## Writing Requirements

- Do not present guesses as facts.
- Do not soften a real issue to protect a passing agent.
- Do not exaggerate a failure when the requirement was ambiguous.
- Anchor the opening sentence in run-specific evidence or the actual bug, not a stock wrapper.
- When writing a batch, vary paragraph shape and sentence rhythm across runs so the notes read like individual reviews, not fill-in-the-blank templates.
- Do not reuse canned openers such as `This is a fair fail.` or `I would keep this as a legitimate pass.` across the set.
- In diamond/test-group artifacts, do not repeat rubric openers such as `This group checks...` and `This is fair because...` for every group. Answer the required questions in natural prose, with the concrete test behavior leading the paragraph.
- For passing runs, do not force the same paragraph order every time. If one run is most convincing on dynamic defaults and another on pipe plumbing or patch hygiene, let that strongest evidence lead the writeup.
- In failure notes, quote the exact task sentence or sentences the failing group is exercising whenever the prompt gives you the contract directly.
- In success notes, avoid plausibility language such as `convincing`, `looks correct`, `appears safe`, or `legitimate pass`. Prove the claim with concrete evidence.
- In success notes, do not hide a requirement cluster behind a blanket closing line such as `the remaining interaction points are covered` or `every major requirement is accounted for`. Name the requirement cluster explicitly before claiming it is satisfied.
- If the prompt ends with a catch-all integration clause such as `the same calling rules apply when the callee is a method, a dynamically chosen function, or a value retrieved from a list or map`, treat that as its own requirement cluster and address it explicitly.
- Do not claim that a run artifact proved a sub-fact unless the artifact explicitly shows it. If regenerated output is visible only in the patch plus clean test results, say exactly that; do not say the artifact stream recorded parser regeneration, goyacc execution, or similar runtime proof unless the saved logs or evaluation artifact actually say so.
- Treat backticks as evidence claims. A backticked path, config line, selector, template snippet, or value must either appear literally in the artifact you read or be described as a computed path shape in prose. Do not write pseudo-literals like `content/.../<slug>/file.jpg`, `link_url = "..."`, `<a href=...>`, or `{{if x}}...{{end}}` unless those exact characters appear in the prompt, patch, XML, repo, or trajectory.
- Do not translate artifact syntax into another format while presenting it as exact text. If the test uses a Go fixture field named `linkURL`, do not write it as TOML `link_url` unless the TOML source exists in the artifact.
- In failure notes, every group must stand on its own. Do not make a later group depend on shorthand such as `downstream of Group 1` or `same bug as Group 1` as its main explanation. Restate the direct requirement, the direct failing surface, and the direct causal chain inside that group.
- When a group is anchored by a concrete named test or a reviewer is likely to read the file test-by-test, explicitly connect that named test to the primary public contract it checks and, when useful, the concrete XML mismatch it observed.

## Human Precision Guardrails

Human-written does not mean loose. The best QA note should read like a careful internal PR comment: natural, direct, and easy to follow, while still making only claims that the artifacts prove.

- Treat each sentence as a claim that may be audited. If a sentence could be read two ways, rewrite it until the actor, condition, and consequence are explicit.
- Use the task's own nouns when they matter. Do not replace prompt terms such as `unowned files`, `fresh build`, `generated public path`, or `Atom media root` with near-synonyms unless you also explain the implementation detail behind the synonym.
- Be precise about sequence and ownership. Say which function, job, phase, helper, template, or test performs the action. Do not write broad phrases like "the cleanup code removes it" or "prepare handles changed media" if the real behavior is split across validation, preparation, fetch, rendering, and finalize paths.
- Include preconditions for conditional behavior. If a helper removes files only when a sidecar exists and a fingerprint differs, say that. Do not compress it into wording that makes the behavior sound unconditional.
- Do not generalize one test's assertions to a whole group. If only one test checks rendered page references, old-extension cleanup, or a particular XML mismatch, attach that claim to that test by name.
- Do not infer trajectory reasoning from the final patch. If the trajectory contains the thought, cite or quote the targeted snippet. If only the patch proves the mistake, write that the final patch shows it.
- Avoid aggregate trajectory claims when one concrete step is available. A keyword search such as "many cleanup mentions and no feed mentions" is weaker than a step where the agent explicitly marks a requirement as unchanged or out of scope.
- Prefer step-level trajectory references over raw JSON line references in reviewer-facing prose. If a human review asks where the agent made a mistake, cite the concrete `step_id` and the short quote from that step; use JSON line numbers only as a private lookup aid.
- Do not overstate the agent's trajectory reasoning. If the relevant content is concentrated in one checklist item, one edit step, or one local-test interpretation, describe that exact step instead of writing broad phrases such as "the trajectory spends real time on" or "has detailed reasoning about."
- Keep diamond artifacts and per-agent QA separate in tone and purpose. Diamond artifacts describe what the verifier proves and what the expected solution shape is. Per-agent QA explains why one run passed or failed.
- For test-group summaries, describe the exact inputs and expected outputs before making coverage claims. The reader should never have to guess which named test supports a sentence.
- In diamond artifacts, do not claim a test proves timing, ordering, or a closed set of covered inputs unless the assertions actually prove that. If timing is inferred from solution shape or another group, say that explicitly and put the proof in the group that asserts it.
- When a test asserts both the presence and absence of rendered output, mention both sides. Do not summarize a dual assertion as "checks one anchor" or "checks one path" if it also verifies the fallback path is absent.
- For passing runs, do not add weak issues just to fill an `Issues` section. Style preferences, harmless overengineering, or generic maintainability notes should stay out unless they point to a concrete review-worthy failure mode.
- Humanize by removing boilerplate, not by softening facts. Vary paragraph openings, avoid repeated skeletons, and keep the prose specific to the run or test group being discussed.

## PASS Evaluation Rules

If the run is a legitimate pass, create `{agent-directory-name}-success-evaluation.md` in the problem-level QA directory.

Use a sibling QA directory under the problem root named `{problem-name}-QA`, where `{problem-name}` is the shared prefix used by `{problem-name}-agents-runs` and `{problem-name}-agent-X`.

Example: if the run directory is `kwargs-fork-agent-1`, the QA directory should be `kwargs-fork-QA`, and the output file must be `kwargs-fork-agent-1-success-evaluation.md` inside that QA directory.

The required text box answer must explain:

- why the implementation is correct,
- why it would pass a thorough code review by a repo expert,
- how the task requirements are met,
- why there is no evidence of regressions or newly introduced bugs.

The bar for a strong passing note is certainty, not plausibility. The reader should come away thinking the implementation is free of contract-level errors and is close to the cleanest repo-aligned way to implement the task, not merely that it "might be right."

Present that answer in the final markdown as:

- `**Score:** <1-5>`
- one human-written `**Justification:**` block that covers the full correctness story

Your success analysis must include:

1. Every major public requirement cluster from the task description, handled one by one
2. The concrete implementation evidence that satisfies each requirement cluster
3. Why baseline behavior still appears safe after code review and any targeted local validation you needed
4. Why a repo expert would view this as complete and repo-aligned rather than a lucky green result

If the prompt contains a final umbrella sentence that gathers several integration surfaces into one clause, spell those surfaces out explicitly in the note instead of implying them through a generic `shared dispatch` or `same call path` claim.

Do not rely on "tests passed" as the whole argument. Use the patch to explain why the result is technically sound.
Across a batch of passes, avoid repeating the same verifier-green -> architecture -> prompt-alignment -> no-regressions paragraph sequence unless the run genuinely demands it.

If XML plus patch review do not give you enough evidence to make a high-confidence claim, do targeted local validation before scoring the run a `4` or `5`. That can include focused checks, closer runtime inspection, or debugger work when the safety of the implementation depends on subtle runtime state.

## Score Scale

Choose one score from 1 to 5.

- `5`: Very high confidence. The patch clearly satisfies the full contract, matches repo conventions, preserves baseline behavior, and no real hidden issue is apparent.
- `4`: High confidence. The implementation is very likely correct, with only minor non-blocking uncertainty.
- `3`: Mixed confidence. Tests pass, but there is meaningful uncertainty or an area that could hide a problem.
- `2`: Low confidence. The implementation passes tests but has serious unresolved doubt.
- `1`: Very low confidence. You cannot honestly defend the implementation as correct.

In the final markdown, render this as `**Score:** N`.

## Optional Issues Section for Passing Runs

Add an `Issues` section only when a legitimate passing run still has a real, review-worthy problem that should be visible to the reviewer.

Valid examples include:

- a latent public API or integration gap outside the verifier's executed path,
- a repo-alignment problem a code reviewer would reasonably flag,
- or a deterministic but untested edge that the current verdict and reviewer process still want documented as a pass issue rather than reclassified as an agent failure.

Do not add issues for speculation, generic style preferences, or broad maintainability anxiety. If the issue shows the verifier is unfair, the task is ambiguous, or the verdict itself should change, escalate that task/verifier problem instead of burying it in a passing note.

Each optional issue must include:

- `Severity`: 1 to 5, where 4+ is blocking
- `Category`: one of `correctness`, `design`, `extensibility`, `readability`, `instruction_following`
- one short human-written paragraph, optionally labeled `Justification`, that covers:
   - the exact failure mode
   - why it matters despite the passing verdict

Do not add speculative style complaints or generic maintainability comments. Be clear and specific.

## Failure Evaluation Rules

If the run fails for a legitimate agent reason, create `{agent-directory-name}-failure-evaluation.md` in the problem-level QA directory.

Example: if the run directory is `kwargs-fork-agent-4`, the QA directory should be `kwargs-fork-QA`, and the output file must be `kwargs-fork-agent-4-failure-evaluation.md` inside that QA directory.

Start from the failed test cases in `*new-tests.xml`, then group them by common root cause.

Group tests together only when they share all three of these traits:

1. The same requirement cluster
2. The same incorrect assumption or missing logic
3. The same code-path failure in the solution patch

Split tests into separate groups when:

- they fail for different reasons,
- they depend on different prompt clauses,
- they need different fairness arguments,
- or they originate from different mistakes in the trajectory.

If there is only one failed test, still use a single group, but do not force a fake `Why grouped` subsection just to defend a singleton. Use that space only when the grouping decision itself needs explanation.

For each failure group, cover these points:

1. Why these tests belong in one group
2. Fairness: Would a seasoned engineer have avoided this error, and is the requirement clear?
3. Root cause: Where in the trajectory did the error originate, and what kind of mistake was it?

For singleton groups, point 1 is optional when it would just restate that there was only one failing test.

In the final markdown, make those points visible as three labeled review points for every failure group. Use either standalone headings or numbered labels, but keep them easy to scan. Accepted reviewer notes often use labels like:

- `1. Why grouped:`
- `2. Fairness:` (1. Fairness in case it's only one test)
- `3. Root cause:`

Do not hide the fairness or root-cause reasoning inside one generic paragraph. A reviewer should be able to scan the file and immediately find the unfairness check and the root-cause analysis for each failed test group.
Under those labels, prefer ordinary prose paragraphs anchored in run-specific evidence. When it helps, add one plain follow-up paragraph after the root-cause point to pin the bug to the exact search, edit, or local test choice that let it slip. Do not open every subsection with reusable declarations such as `I do not see an unfairness issue` or `The wrong turn is`; start from the prompt clause, failing test behavior, or concrete patch decision instead.

Your unfairness check must explicitly say whether the test is fair, cite the relevant prompt sentence, explain how the failing test case correctly validates that requirement, and cite repo convention when that is part of the inference. When the prompt states the requirement in direct words, quote that sentence verbatim. Your root-cause analysis must identify the first meaningful wrong turn in the trajectory, name the wrong assumption or missed edge case, and connect it to a concrete patch hunk or emitted behavior.

If the trajectory does not explicitly show the wrong assumption, do not invent one. It is acceptable to say the root cause is visible in the final patch and that the trajectory did not revisit the exact edge case. Separate "the patch proves this bug" from "the trajectory shows this thought process."

If a grouped failure is really exercising more than one explicit prompt sentence, quote each relevant sentence instead of citing one broad clause and implying the rest.

If the group contains a clearly representative test such as `ArithmeticPropagation`, `MetadataContinuity`, or another contract-defining name, make sure the fairness and root-cause prose directly address that test's main requirement surface rather than only the broader family label.

## Diamond Artifact And Test-Group Rules

Use this section when the user asks for diamond artifacts, test descriptions, or grouped verifier explanations. Do not treat these as the same thing as a per-agent success or failure evaluation.

For each test group, answer the review questions inside that group:

- what the group checks,
- concrete inputs and expected outputs,
- happy paths and edge cases,
- why the group is fair under the task description,
- and how the group covers its part of the added functionality.

Avoid detached global "overall suite" sections unless the target form explicitly has a separate overall-suite field. In many review UIs, the "overall suite" prompt means the tests currently being grouped; the coverage explanation should live with the group so the reviewer does not have to connect it later.

Use JUnit XML for saved-run outcomes and the test patch for understanding test intent. If the JUnit source omits a test that exists in the patch, do not create a permanent "patch-only" section by default. Either group the test according to the source currently selected by the reviewer, or, if the source has been fixed, put the test in its natural functional group. Keep count-mismatch commentary out of the diamond artifact unless the reviewer specifically asks for it.

The prose should sound like a person explaining a test plan. Vary paragraph openings, avoid repeated sentence skeletons, and remove wording that makes the artifact look like a generated rubric response.

## Task-Fault Escalation Rule

If the evaluation JSON, XML, trajectory, or patch review shows that the run was blocked by an environment problem, ambiguous requirement, or unfair test expectation, do not force an agent-fault narrative.

Instead:

- state that the run reveals a task fault or fairness problem,
- explain the evidence,
- and recommend task or verifier fixes before further blame analysis.

This follows the Olympus failure-analysis rule: unfairness must be fixed and rerun, not explained away.

## Trajectory Review Rules

Do not read the trajectory like a novel.

Use this sequence:

1. Read `*evaluation.json` to get the claimed summary.
2. Read XML to confirm which tests passed or failed.
3. Read the relevant hunks from the agent's provided solution.
4. Search the trajectory for:
   - the first incorrect assumption,
   - the key file reads that shaped the agent's approach,
   - the code edit where the bug or correct design landed,
   - the final test interpretation.

Only quote trajectory snippets that materially support your claim.

Ignore exploratory dead ends unless they directly caused the final bug.

## Required Sanity Checks

Before saving either document, verify these points:

- Baseline status matches the evaluation summary.
- New-test status matches the evaluation summary.
- The agent did not modify hidden test files to force a pass.
- Your claims are based on the public contract, not hidden expectations.
- Any claimed regression risk is visible in the provided solution, not invented from anxiety.
- Every exact-looking backticked value is literal artifact text, or the prose clearly says it is a computed/generated shape rather than a quote.
- Any claim about what the trajectory noticed, assumed, or decided is backed by a targeted trajectory snippet. If only the patch proves the mistake, say that.
- Any human-review fix that asks for trajectory grounding cites the relevant `step_id` and does not rely on broad absence claims when a concrete checklist or edit step exists.
- Any diamond/test-group coverage claim is no broader than the test patch assertions. Watch especially for wording that turns examples into exhaustive lists, or turns a failure-preservation assertion into proof that validation necessarily happened before all media work.
- No `*-qa-audit.json` file was edited. These audit files are platform-generated review results, not the canonical QA document to fix.
- Any `4` or `5` success score is backed by requirement-by-requirement evidence strong enough to justify certainty rather than "looks good" language.

## Output Naming And Location

Create exactly one of these by default:

- `{agent-directory-name}-success-evaluation.md`
- `{agent-directory-name}-failure-evaluation.md`

Use the exact basename of the agent-run directory as the prefix.
Store the file in a sibling QA directory under the problem root named `{problem-name}-QA`, not inside the agent-run directory itself.

Example:

- Run directory: `kwargs-fork-agent-7`
- QA directory: `kwargs-fork-QA`
- Success output: `kwargs-fork-agent-7-success-evaluation.md`
- Failure output: `kwargs-fork-agent-7-failure-evaluation.md`

Only create both if the user explicitly asks for combined analysis.
