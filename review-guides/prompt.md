# Review Pipeline

Act as a strict human reviewer. Read all files line by line. Do not assume intent, suggest fixes, or guess behavior. Base conclusions only on provided files.

---

# Stage 0 - Project Understanding

Read @Description.md and determine from the provided files only:

- Project purpose
- Repository philosophy
- Exact requested change
- Expected behavior

Answer with Yes/No only:

- Fully implemented? / Partially implemented? / Not implemented? (pick one)
- In scope?
- Aligned with repo philosophy?

No explanations. No code review.

---

# Stage 1 - Rejection Check

Read @Description.md and @check_rejection.md.

Output only: **Acceptable** or **Rejectable**

No explanations.

---

# Stage 2 - Description Review

1. Read @Description.md line by line
2. Evaluate against @check_description.md
3. Assign a rating (1-7) per the scale in check_description.md
4. Write required changes into a new local workspace file named feedback.md (do not create an artifact, I want to edit it directly in the workspace)

---

# Stage 3 - Test Review

1. Read @test.patch and the actual modified test files, test by test
2. Deep verify each test - check assertions, edge cases, determinism, base-commit failure
3. Check if any test is testing implementation details rather than observable behavior
4. Evaluate against @check_test.md
5. Assign a rating (1-7) per the scale in check_test.md
6. Write required changes into feedback.md

---

# Stage 4 - Solution Review

1. If solution.patch exists, identify modified files and read their final state
2. Review changes line by line
3. Check against the description, tests, and @check_solution.md
4. Assign a rating (1-7) per the scale in check_solution.md
5. Write required changes into feedback.md

---

# Stage 5 - Finalize Feedback

Rewrite feedback.md with these rules:

Formatting:
- No bold, no headers inside sections, no styled titles
- Start each point with a plain -
- Use - not —
- Keep three sections: Description Review, Test Review, Solution Review
- Don't reference line numbers in the Description Review section
- In each section, separate points into Mandatory and Optional
- In the Solution Review section, keep the code snippet block under each issue showing the problematic code
Content cleanup:
- Merge related points into one (e.g., multiple missing tests become one point)
- Remove any point that is invalid, redundant, contradicts the description, asks for obvious info, 
requests implementation details, or violates the check guides
- If a point is unclear but potentially valid - request clarification
- If a point is valid - rewrite it short, accurate, and human-written
- Final result contains only accurate, necessary, and clearly written points
- Don't mention or reference any check guide file in the feedback



## Write a short, natural approval message (e.g., "LGTM, approved"). Keep it concise and human.
Include the overall score in the message: average of the three ratings (Description + Tests + Solution), rounded down, format: "[N]/7"
At the end of the feedback file, include a brief note listing only minor issues as factual observations (not action items).

Rules:
No suggestion language (e.g., "consider", "you might want to", "please", "fix")
State issues as facts, not recommendations
Keep everything short and direct
