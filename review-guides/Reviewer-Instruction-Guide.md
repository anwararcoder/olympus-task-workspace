**Reviewer Instructions Guide**

*Core onboarding instructions and review workflow*

**Purpose.** This guide is designed for new reviewers. The first section contains the reviewer onboarding instructions. The second section contains the review workflow and how to submit a review.

# **Part 1 \- Reviewer Onboarding Instructions**

## **1\. Reviews tab, stats, and time logging**

* Open the new Reviews tab and explore the reviewer interface.  
* At the top, you will see your **stats** and **reviewer score**.  
* Use the stats card to log hours at [https://shipd.ai/quests/olympus/time-logs](https://shipd.ai/quests/olympus/time-logs).  
* When logging hours, include a **note** describing what you did during that interval, such as: reviewed 3 submissions, 2 approved, 1 requested changes, helped 1 user with an issue. **And, add the type.**

## **2\. Review queue and reservations**

* The review queue is sorted by the oldest submissions first.  
* Each queue item has three main actions: **View**, **Reserve, and Skip**.  
* **View** lets you inspect the submission without reserving it.  
* **Reserve** assigns the submission to you for 2 hours so another reviewer does not overlap with your work.  
* **Skip** lets you skip this submission and get another. Keep in mind that skips are limited and filled by doing reviews.  
* If you request changes and the author resubmits, the submission remains reserved to you for **24 hours**.  
* Submissions that were previously reviewed by you and got fixed will have higher priority in your queue deck and will show before the newer submissions.

## **3\. Review view extra sections**

1. **Submit review card:** use this to rate the submission, mark checks, write feedback, and explain your reasoning.  
2. **Related Submissions:** inspect problems flagged as possibly similar, read the outputs, and decide. Higher scores mean higher duplicate risk. If a listed problem is tagged “older,” it was created before the current submission. Keep the original and reject the copy.  
3. **Quick Setup:** includes repo clone instructions, checkout, test patch, solution patch and the Dockerfile if you want to run tests before applying the solution. Build the Dockerfile with \`network=none\` because there should be no network access inside the container.

## **4\. Agent runs and review evidence**

* You can copy or download any agent run and inspect its details.  
* Check agent results thoroughly rather than relying only on pass/fail status.  
* Spot the **median LOC** and compare it against the user solution, make sure it’s meeting the requirements.  
* Check the failure reasons to verify the problem is fair, challenging, and not overfit or undertested.  
* Passing agents can indicate that the task is solvable, but they can also expose weak tests if incomplete or overly short solutions pass.

## **5\. Making the review decision**

* Approve only when the submission meets the full quality bar and required checks.  
* Request changes when the submission is promising but has fixable issues.  
* Reject or downgrade when the problem is a duplicate, below the expected bar, unfair, too weak, or more appropriate for a lower category.  
* Rejection should be made **only** when there are existing issues or PRs, or if it’s a duplicate. Otherwise, we give the authors a **chance to improve**.  
* Write feedback that is specific, actionable, and tied to the actual issue. The feedback should be **complete and clear** to avoid unnecessary iterations and make it easy for authors to follow.

## **6\. What happens after approval**

* After you approve a submission, it goes to final review.  
* A manager or admin will either accept it or revert it if they find remaining issues.  
* **Reverted reviews affect the reviewer's score.** Initial reviews may not count, but later reviews will.  
* A consistently low reviewer score may lead to the removal of reviewer access, though you can still contribute as an author.   
* Don’t be scared of any score drops; if you get a revert, it’s a sign that you’re learning something new, and you can discuss the revert with the manager if you disagree with it.  
* When your review is accepted by managers/admins, any active approval bonus should be reflected according to the current bonus rules.

# **Part 2 \- Review Process**

**Context.** The following section consolidates the review process.

## **1\. Already existing idea or a misfit**

* Make sure to look out for existing PRs, issues, or discussions about this task to check if it has a public solution or if the maintainers have already rejected it.  
* Check on the reported similar submissions (if applicable), read their outputs, and the reasoning behind the tags to tell if this submission is a duplicate of an existing submission, or a very similar idea such that they cannot co-exist.  
* Make sure to get some context on the repo and the submission to determine whether they align with the repo’s philosophy and design goals.

## **2\. Problem description review standards**

* Be concise and include only necessary information.  
* Avoid AI slop.  
* Avoid being overly prescriptive unless implementation details are truly required.  
* Avoid weird titles or rigid sections such as “test assumptions.” Keep the description natural.  
* Do not frame the prompt as if the repo is external.  
* Do not turn the prompt into a list of requests or snappy commands.  
* Do not list discoverable repo behavior or implementation details unless necessary.  
* Do not use code snippets when plain English is clearer, unless code is truly needed.

## **3\. Tests**

* Base tests should be running the repo’s existing tests, unless some tests are flaky or irrelevant (check what the user skips cause maybe they’re breaking something).

* The new tests should check all explicit requirements and obvious edge cases (If the test fairness checks show a 💡, then check its test suggestions if they are valid and were actually gaps in the tests).  
* The tests should be deterministic, robust, and verify only discoverable points (whether mentioned in the prompt, discoverable from the repo, or well-known conventions).  
* They should never require any network connection cause we run the container with \`--network=none\`  
* The tests should be confirming the requested behavior, not the implementation (unless it was something explicitly mentioned or discoverable from the repo). This is to make sure that we don’t get **false negatives** (accurate solutions failing because the tests are tailored to the user’s solution).  
* Make sure the JUnit XML format is proper, doesn’t skip tests, and surfaces real failures.

## **4\. Solution**

* The solution should meet all the requested requirements in the description.  
* It shouldn’t edit irrelevant code or break existing code.  
* Follows the repo’s patterns and no AI slop (out-of-place excessive comments, unexplained defensive code, etc).  
* Check for code smells and LOC bumps by dead code, irrelevant refactors, or reordering, etc.

## **5\. Check LOC carefully**

* Check the user-submitted solution LOC and the agents’ solutions to estimate the true LOC.  
* Exclude blank lines, dead code, unnecessary filler, documentation-only inflation, test additions, unrelated changes, and other non-essential additions.  
* If the LOC is close to the limit or you are unsure, ask in the reviewer channel.

## **6\. Watch for agent results**

* Passing agent results are not enough by themselves.  
* Inspect the solution diff, LOC, and whether the agent solution is much shorter than the user solution.  
* Check the failing agents to understand why they failed. Confirm that the failures are fair cause sometimes the failures surface ambiguous points in the description or unfair tests.

## **7\. Inline comments**

* Use inline comments on the submission description or code when giving feedback.  
* Inline comments make feedback more precise, reduce confusion, shorten review cycles, and allow discussion threads with users.

## **8\. Mars vs Olympus judgment**

* Downgrade the submission to Mars if it is more suitable for Mars-level expectations. **Requesting changes is preferable** for submissions with potential, giving the user a chance to tweak it.

## **9\. Submitting Feedback**

* You’ll find 3 bands for: Problem description, Tests, and Solution. Each band has a rating from 0 to 3\.  
- 3 \= Clean; this section is perfect, no comments to add  
- 2 \= Minor issues; it’s not the cleanest and could be approved or fixed (your call)  
- 1 \= Weak; it has to be fixed  
- 0 \= Failing; totally bad, and used for the rejection cases  
* Confidence for each band: High, Medium, and Low. This one is mainly for you to ask yourself, **“How confident am I when picking this rating?”** If you’re picking 3/3 with low or medium confidence, check what’s making you hesitant; maybe it’s a 2/3 or it might need another round of fixes.  
* For any ratings less than 3/3, you’ll be asked to write the reasoning/feedback behind your decision and this will surface to the author. Make sure to reference the points from our [guides](https://shipd.ai/quests/olympus/docs/problem) (e.g., not meeting T3 cause some tests are weak …).  
* Other Notes field for any other comments (difficulty, LOC, duplicate, already solved, etc). It also has pre-existing tags that you should pick from if applicable.

# **Appendix \- Recommended review mindset**

* Be fair, consistent, and highly attentive.  
* Prioritize problem quality and test quality.  
* **Do not approve because a submission is close;** approve because it meets the bar.  
* Use clear evidence: diffs, LOC, agent runs, test behavior, and similarity results.  
* Give feedback that helps the author fix the actual issue quickly. Guide briefly when possible; the author doesn’t know what’s in your head.

# **Advice from the team and the managers**

* Have this doc by your side when reviewing. Following the listed instructions will help avoid getting reverts.  
* AI agents are your helpers, so make sure to keep it that way and use your judgement when reviewing. Otherwise, you’ll be the same as the auto review …  
* Check the agent runs carefully, as they can uncover many issues.  
* Keep an eye on Discord and the announcements to keep up with any updates.

Best of luck with your reviews ;)  
