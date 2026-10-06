<!-- =============================================== Step 1 =============================================== -->

Hey there. I need your help to recommend a repo similar to those ones regarding the infra and align with the rules and workflows mentioned in [.agent](shipd/Shipd - Olympus/.agent/) and [new-dot-agent](shipd/olympus-tmp/new-dot-agent/) directories.

You can also check the [Accepted](shipd/Shipd - Olympus/my-work/Accepted/) tasks to understand what good tasks look like, especially Sprint 4 and Sprint 5 because they are the most recent ones.

Also, I put the recent repos under [repos](shipd/Shipd - Olympus/repos/).

I think having a repo that has around 500–5k GitHub stars and solid infrastructure will pay off better.

I also think Java offers great variation in the types of tasks we can design, so please consider Java repositories strongly during the analysis.

### Important analysis constraint

Do NOT analyze or rely on the Git history of the accepted tasks.

I do NOT want you to study commits, commit-by-commit changes, branches, diffs across revisions, or the chronological evolution of previous tasks.

Instead, learn from the actual task artifacts and the problems themselves.

For the accepted tasks, focus on:

- The original problem/task description.
- The repository structure and internal architecture.
- The issue/problem being addressed.
- The relevant source code.
- Existing loggers and logging behavior.
- Existing error handling and diagnostics.
- The tests associated with the problem.
- The solution/final state as an artifact, only to understand what kind of repository problem was suitable.
- Review documents and reviewer feedback, when available.
- Documented mistakes, issues, and failure cases.
- Regression scenarios and edge cases that were identified.
- Why the problem was difficult or interesting from an agent perspective.
- What kinds of repository knowledge were required to solve it.
- What made the task fair, solvable, and challenging.

The goal is NOT to reproduce or derive an existing task.

The goal is to understand the underlying characteristics of a strong task:

- What makes a repository suitable?
- What makes a problem sufficiently deep?
- What kinds of bugs or missing behavior create good challenges?
- What makes the task require meaningful repository exploration?
- What makes the task challenging without becoming ambiguous?
- What kinds of logging, diagnostics, state management, persistence, concurrency, parsing, validation, or infrastructure problems create strong tasks?
- What mistakes commonly make a task weak, unfair, trivial, or impossible?

Please study the repositories internally as well, including their architecture, modules, infrastructure, tests, dependencies, patterns, and existing implementation conventions.

Do NOT use Git history as a source of task ideas or as evidence of how an accepted task was constructed.

After completing this analysis, recommend 3 repositories that are strong candidates for creating new tasks.

For each repository, explain:

1. Why the repository is a good fit.
2. What parts of its infrastructure provide good task opportunities.
3. What types of problems could realistically be created there.
4. Why those problems would be challenging for coding agents.
5. What existing code/logging/tests make the repository suitable.
6. Potential risks or reasons the repository might be a bad choice.
7. Your confidence that a well-designed task on this repository could meet the Shipd standards.

Do not design the final task yet.

The objective of this step is only to identify the strongest repository candidates based on repository internals, existing problems, infrastructure quality, and lessons learned from previous task artifacts.

Go ahead and do amazing work.













<!-- =============================================== Step 2 =============================================== -->

Well, good work.

Now I need to start a task from scratch, and you should recommend a solid task idea that can compete with the quality of the accepted tasks and has a strong chance of being accepted from the first iteration.

Before designing the task, you MUST deeply analyze the accepted Sprint 4 and Sprint 5 task artifacts that are available to you.

### Critical analysis constraint

Do NOT inspect or analyze Git history.

Do NOT study commits, commit sequences, branches, historical diffs, revision timelines, or how previous tasks evolved.

I specifically do NOT want to learn from the implementation process of previous tasks.

Instead, learn from the problems themselves and from the artifacts that describe them.

For each relevant accepted task, analyze:

- The problem statement.
- The repository state relevant to the problem.
- The affected components.
- The existing implementation.
- Existing loggers and logging behavior.
- Existing error messages and diagnostics.
- Existing tests.
- Regression tests and edge cases.
- Documented issues and failure modes.
- Reviewer feedback.
- Review criteria.
- Why certain aspects were considered problematic.
- What made the task difficult but still solvable.
- What repository knowledge an agent needed.
- What kinds of mistakes agents commonly made.
- What gaps had to be considered when defining a robust task.

Pay particular attention to recurring problem patterns.

I want you to learn the engineering lessons from those problems, not copy their implementation or task structure mechanically.

The goal is to understand:

- What constitutes a meaningful repository-level problem.
- What makes a task challenging for capable coding agents.
- How to create enough ambiguity for genuine investigation without making the task unfair.
- How to avoid over-specifying the implementation.
- How to identify hidden edge cases without revealing the solution.
- How logging and diagnostics can expose or conceal important behavior.
- How tests should verify behavior rather than dictate implementation.
- How to distinguish a real repository problem from an artificial coding exercise.
- How to make the task require meaningful changes across the repository.
- How to keep the task self-contained and solvable from the provided context.

### Task design requirements

After completing this analysis, design ONE strong original task for the selected repository.

The task must:

- Be repo-fit.
- Be technically meaningful.
- Require real repository understanding.
- Have a clear behavioral objective.
- Be challenging for strong coding agents.
- Be solvable from the repository and task context.
- Avoid unnecessary implementation prescription.
- Avoid copying an existing accepted task.
- Avoid relying on undocumented assumptions.
- Have enough depth to expose meaningful agent failures.
- Have realistic regression risks.
- Have a clear verification strategy.
- Respect all rules and workflows under `.agent` and `new-dot-agent`.

Before creating the implementation plan, identify the underlying repository problem and explain why it is a strong task candidate.

Then create a directory:

`{repo-name}-{task-name}/`

Inside it, create:

`{task-name}-plan.md`

This plan must contain everything required for a zero-context implementation agent to execute the task correctly.

Include, at minimum:

- Task objective.
- Repository context.
- Problem statement.
- Existing behavior.
- Expected behavior.
- Scope.
- Non-goals.
- Relevant files/modules.
- Important architectural constraints.
- Existing logging behavior.
- Error/diagnostic behavior.
- Required behavioral changes.
- Edge cases.
- Regression risks.
- Testing strategy.
- Acceptance criteria.
- Design decisions.
- Repo-fit justification.
- Fairness/solvability considerations.
- Potential agent failure modes.
- Important details that a zero-context agent could otherwise miss.

However, do NOT turn the plan into an implementation recipe.

The plan should explain WHAT must be achieved and all behavioral constraints, while avoiding unnecessary instructions about exactly HOW the implementation must be written.

### Draft description

Before implementation, also create a draft description document similar in quality and structure to the accepted task descriptions.

The draft description must:

- Clearly explain the problem.
- Be self-contained.
- Describe the expected behavior.
- Avoid revealing the solution.
- Avoid over-prescribing implementation details.
- Be fair to coding agents.
- Be concise enough to remain readable.
- Follow the applicable Shipd description rules.
- Be clearly original and not a copy of an existing task.

We will submit the draft description first to verify that the idea itself is acceptable and not plagiarized.

Do NOT start implementation yet.

First complete the analysis, design the task, create the plan and draft description, and explain why you believe this task has strong acceptance potential.

Go ahead and do amazing work.



















<!-- =============================================== Step 3 =============================================== -->

Okay, great work.

I have confirmed on the platform that the task idea is not plagiarized, so we can now start implementing it and bringing it to a submission-ready state.

I also provided review documents explaining how reviewers evaluate submissions, along with reference tasks containing documented problems, review feedback, regression risks, and lessons learned from previous submissions.

### Critical constraint

Do NOT analyze or rely on Git history of the reference tasks.

Do NOT study commit history, revision sequences, branches, historical diffs, or the chronological process by which previous tasks were developed.

Instead, review the actual task/problem artifacts and learn from the engineering problems they exposed.

The purpose is to understand:

- What went wrong.
- Why it went wrong.
- What requirements were easy to miss.
- What edge cases caused failures.
- What made the task unclear or overly prescriptive.
- What made an implementation incomplete.
- What reviewers considered problematic.
- How logging and diagnostics affected debugging.
- What kinds of regressions appeared.
- Which assumptions were unsafe.
- What should have been considered earlier during task design.

Use these lessons to improve our current task.

Do NOT copy previous solutions.

Do NOT reproduce previous task wording.

Do NOT derive implementation details from historical commits.

### Review the current task deeply

Before finalizing the implementation, review our task from multiple perspectives:

#### 1. Repository fit

Confirm that the task naturally belongs in the repository and follows its existing architecture, conventions, APIs, logging patterns, error handling, and testing style.

#### 2. Problem quality

Confirm that the task addresses a meaningful engineering problem rather than an artificial coding exercise.

#### 3. Solvability

Confirm that a capable agent can solve the task using the repository, the task description, and normal code investigation without requiring undocumented external knowledge.

#### 4. Fairness

Check that the description does not hide essential requirements while also avoiding unnecessary implementation instructions.

#### 5. Difficulty

Confirm that the task requires meaningful reasoning, repository exploration, and implementation rather than a trivial localized edit.

#### 6. Regression coverage

Look for realistic failure modes, especially those suggested by the problems and review feedback from the reference tasks.

#### 7. Logging and diagnostics

Review the existing logger and diagnostic behavior carefully.

Make sure the task does not accidentally make debugging impossible or introduce requirements that conflict with the repository's existing logging conventions.

#### 8. Tests

Review the test strategy carefully.

Tests should verify the required behavior and important regressions without unnecessarily prescribing the implementation.

#### 9. Description quality

Review the description for:

- Ambiguity.
- Over-specification.
- Missing behavioral requirements.
- Unnecessary implementation details.
- Hidden assumptions.
- Unfair requirements.
- Excessive density.
- Missing edge cases.
- Any wording that could cause agents to misunderstand the actual objective.

### Learn from failure patterns

I want you to explicitly compare our task against the failure patterns found in the reference task artifacts.

For every relevant lesson, ask:

1. Could the same class of problem occur in our task?
2. If yes, how can we prevent it without over-specifying the solution?
3. Is the requirement already covered by the description?
4. Is it better handled by tests?
5. Is the behavior naturally implied by the repository?
6. Would adding the requirement make the task unfair or too prescriptive?

The goal is to achieve the right balance between:

**clear enough to be solvable**

and

**open enough to require genuine engineering reasoning.**

### Final objective

Take the time necessary to make the implementation and task artifacts submission-ready.

Before considering the work complete, verify:

- The implementation matches the intended behavior.
- The solution is consistent with repository architecture.
- Existing behavior is preserved where required.
- Important regressions are covered.
- Logging and diagnostics remain correct.
- Tests are meaningful and robust.
- The task description is self-contained.
- The task is not over-prescriptive.
- The task is not under-specified.
- The task does not depend on Git history.
- The task does not reveal its intended implementation.
- The task is repo-fit.
- The task is fair and solvable.
- The task has meaningful difficulty.
- The final artifacts are ready for submission.

Most importantly, do not optimize for making the task look similar to an accepted task.

Optimize for reproducing the **engineering quality and problem characteristics** that made those tasks strong.

We do not have room for careless mistakes, so perform a thorough final review before declaring the task submission-ready.

Go ahead and do amazing work.