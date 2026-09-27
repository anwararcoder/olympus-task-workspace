IRON MAN:
```
@everyone 
Quick reviewer question:
hard to judge whether something is truly approval-ready or still needs changes.
Especially around:
deciding between 5 / 6 / 7 quality rating,identifying when a problem is slightly over-scoped vs still cohesive,judging how seriously to treat system warnings during review

appreciate any practical review tips 😁
```

reply: Kevin@shipd
```
The most important factors are:
The problem is clear, challenging, and the tests are fair

On the 5/6/7 split, if the task is well-scoped and tests are solid, lean toward approving. If you're on the fence, you can ask yourself:  "would an agent learn something useful from this?"

For system warnings: feel free to not pay too much attention to the AI warnings in the "0.125 units" section, those aren't very smart. But if "Task Quality" check flags an issue or an agent run is marked as unfair, take those seriously.
```

Leonard@shipd
```
<@&1477475557720588288> Seeing this being circulated around for effective LOC, credits to <@875697950653816862>. I think its a fair list, but I also just want to note that we do not want to be overly pedantic or nitpicky because I do not want to users to add slop just to make things appear longer. 

blank lines
comment-only lines
trivial no-op lines like pass, continue, break, return None, return nil
generated files
test files
package declarations, like package foo
imports, using, use, namespace
from x import y
import block contents and closing ) / }
braces / punctuation-only lines, like {, }, );, ,
package/import/brace-heavy boilerplate

The main idea is that we just don't want someone to submit a Mars where like 80% its just imports and 20 lines of actual solution, so as long as you keep to the spirit of that, it is good enough.
```

Karim@shipd

```
Please don't request changes for submissions based purely on their description word count

Remember what the goal is:
- concise
- non-prescriptive (it's not telegraphing the solution, "unless something is undiscoverable")
- looks natural, not some AI slop

If the task is huge, the word count is expected to jump a bit, so make sure to judge properly based on all the inputs you have, not just the count
```

Karim@shipd

```
Make sure to check on the test fairness check if it shows the light bulb 

This means there are some tests suggestions, CHECK if these suggestions are needed.

The contributors already know that if they submit while having valid suggestions to patch gaps in their test batch, they'll be getting their submission back. It's pretty much the same, our managers will be returning it back if these suggestions were valid and skipped.

If the suggestions are overly strict, or their behavior or edge case is already covered by other tests, then it's totally fine to skip them.
```

Karim@shipd
```
Hello,

👉  A quick reminder to pay close attention to passing agent results. Please make sure to **review the solution diff** and check the LOC carefully.

In many cases, agents increase LOC by documenting changes, adding tests, or making other non-essential additions, which can make a solution fall well below the expected quality bar.

When an agent's solution is significantly shorter than the user's, there are usually two possible explanations:

1. The user increased LOC with unnecessary changes or a weak implementation, while the agent solved it more efficiently.
2. The new tests are too weak, allowing an incomplete solution to pass.

⚠️ Also, please remember to report any users who abuse the **"BYPASS"** button to push through submissions that are clearly below the approval bar without a valid reason in https://discord.com/channels/1477474990197837874/1477482774733787339.
```

Karim@shipd
```
Also <@&1477475557720588288> , there are some changes for how the problem descriptions should be reviewed "we're kinda back to mars's style 👀 "

## Problem Description Reviews

### Instructions:
1. Be concise: only mention what's necessary; no need to include discoverable details  
2. No AI slop  
3. Avoid being prescriptive unless implementation details are required  
4. No weird titles or rigid sections (e.g. "test assumptions"); keep it natural  

### Common Mistakes:
1. Don't frame the prompt as if the repo is external (e.g. it starts with "Langchain currently supports xyz, but lacks abc...")  
2. Don't turn it into a list of requests or snappy instructions; it should flow naturally  
3. Don't list discoverable repo details (behavioral or implementation) unless necessary  
4. Don't use code snippets when plain English works better (e.g. `'model.update()' and 'model.delete() should ...'` vs `Model updates and deletes should ...`), unless it's needed 

👉 If you're hesitant about the prompt or want to double-check, feel free to ping us
```

Karim@shipd
```
Hey <@&1477475557720588288> <@&1477475878589169665> 👋

We're changing how reviews work. The 21-item Yes/No checklist is gone 🥳 

From now on, you'll score **three fields**:
**Problem Description**
**Tests**
**Solution & Code**
Each field uses a **0–3 rating**:
**3 = Clean**
**2 = Minor issues**
**1 = Weak**
**0 = Failing**
Please focus on the following:
1. **Hover over each rating before selecting it.**
   The tooltip explains when that score should be used.

2. **Anything below 3 needs a clear reason.**
   That reason is sent to the author as feedback for that section, so make it specific and actionable.
3. **Reference the guideline IDs in your reasoning.**
   The docs now label each point as:
   * **P1, P2, ...** for Problem Description
   * **T1, T2, ...** for Tests
   * **S1, S2, ...** for Solution & Code
   Example: “Fails T4 because the tests don't cover the main edge case.”
   Guidelines: https://shipd.ai/quests/olympus/docs/problem
4. **Set confidence for each field: Low / Med / High.**
   This is internal only. Authors do **not** see it.
5. **Use Other Notes only for things outside the three scored fields.**
   Examples: LOC, difficulty, repo fit, overlap with an existing problem, etc.
   These notes are sent to the author.
   Tags can also be selected when relevant, but tags are internal for managers/admins only. Authors do **not** see the tags.

If you're writing feedback for an issue that is **not covered in the guidelines**, ping me so I can add it to the docs.

That's it. This should make reviews faster, clearer, and more useful for authors.

Please take a minute to read this carefully before your next review. 🙏

I attached an image to have an idea on how it'll look for the authors
```

**Hover Data - New Panel**:
```
Description:
   0 · Failing: Missing or contradictory requirements, or a raw spec dump.
   1 · Weak: Prescriptive/leaky, ambiguous, or off-scope — needs changes.
   2 · Minor: Passes, with soft issues — mildly AI-ish, slightly verbose, or minor formatting.
   3 · Clean: Natural, only necessary detail, non-prescriptive, well-formed. Complete, self-contained, unambiguous, real repo scope.
   
Tests: 
   0 · Failing: Passes on base, non-deterministic, missing critical tests, verifies hidden requirements,or doesn't validate behavior.
   1 · Weak: FP/FN risk, flaky, fragile internals, or ignores repo structure. Missing needed tests suggested by the Test Fairness check
   2 · Minor: Solid; a missed edge case or one weak/redundant assertion.
   3 · Clean: Covers all requirements and obvious edge cases, deterministic, strong assertions, covers edges, follows repo patterns.

Solution:
   0 · Failing: Doesn't meet requirements or breaks existing code.
   1 · Weak: Touches unrelated code, fragile, or slop-ish.
   2 · Minor: Works; minor noise — a small irrelevant edit, minor harmless bugs, or light unexplained defensive code.
   3 · Clean: Meets requirements, no regressions, no irrelevant changes, stable API, no slop.
```

Zeyad
```
Hey guys, 
How do you ensure that a sub fits well in the repo?

Personally, I am using gh command to search for any related issues/PRs to the task, analyze the results, and see if there are any mentioned violations.

Any other ideas that you found useful?
```

Reply: Karim@shipd
```
I think your question is a bit different from the approach

> that a sub fits well in the repo
requires understanding the context and the task cause it's not always the case that you'll find someone in a PR's comment talking about how this task will be a violation

it's definitely important to check the PR/issues to see if that's the case or if it's publicly solved, but for pure "repo alignment" that's mostly on you and ur judgement
```

Reply: Zeyad
```
Ah, gotcha. Thanks for the heads up! 

I was using 'repo fit' just to say there aren't any blockers keeping it from being merged (old PRs, philosophy mismatch, etc), but I see what you mean
```

Karim@shipd
```
Yoo @Reviewer, when rating a submission, any real minor issue should drop the relevant section from **3/3 to 2/3**.

I don't want to see submissions marked as all **3/3s** with **Medium confidence**. If you're not confident the section is clean, ask yourself why before giving it a **3/3**.

Grade carefully and make sure your feedback is complete enough for the author to address all existing issues. If a submission has minor issues but is rated as clean across the board, it may be reverted for you to fix the rating.

This won't affect your score at first, but we need reviewers to take this seriously. No slacking on ratings or feedback.

Also, following up on the above message 

I don't want you to be afraid of the score and the reverts so much, if something gets reverted unfairly or for being "overly strict" in ur opinion, make sure to ping the manager who reverted it to discuss the situation in ur private channel. I can later remove the score effect for such cases.

It's also a chance to learn "I think everyone remembers their reverts haha"

Lastly, we all started as reviewers and we know slips happen. If something isn't ur fault, the managers will be skipping the score effect without you even asking 🙌

Some of you might be familiar with this doc (it got updated, give it a look)
https://docs.google.com/document/d/1aow7aYAyMeUuB-I2hz137UKy0rJF95h-AXVFrCyRxhg/edit?tab=t.0 (@Reviewer-Instruction-Guide.md)

This doc will be our source of truth for the reviews. 

The first part is for onboarding and the second part is for the review flow. Any updates to the requirements or any common mistakes we spot shall be added to it, so make sure to always follow it and keep it by your side.

Wishing you a zero-reverts sprint 🥶
```

Zeyad
```
Hey there.
If a submission was flagged as "Distinct" with confidence 0.71 in the first version; then I asked the user for some changes, and now it's flagged as "Adjacent" with confidence 0.72.

Should I reject it or ask the user to rephrase it or something?
```

Reply: Karim@shipd

```
read the outputs
nothing else
also where did u get the confidence number
ahh nvm, the raw output. But this confidence is in the LLM's judgement that they're similar, but this neither confirms nor denies if they're duplicates
```

Reply: Zeayd
```
I don't have access to check the other submission that's flagged as adjacent. I just rely on this LLM's evaluation.
So, if I find some major work in the meaningful difference, can I ignore this evaluation? Like, what should I check in the output to know this can't be bypassed or not?
```

Reply: Karim@shipd
```
just try to understand the context and make the call whether the one you're reviewing can coexist with the other or not

this depends on the listed differences and what's similar, if both submissions are doing pretty much the same thing, or have the same core idea (not enough material to introduce smth new), then it's a rejection
similar and derivative submissions can exist just fine if they have meaningful differences, so it's not about the tag
```

Reply: Zeyad
```
Understood. Thanks for the heads up!
```

Elabyad@shipd:

```
Yoo @Reviewers
You should check the effective LoC for passing agents as well, and ensure they meet the criteria needed.

Also, we noticed some users use old commits to introduce some features already introduced in the recent commits, make sure to flag this, and warn those authors as they might be banned if that's repeated.

Also, when checking the patches, ensure they are aligned with the repo coding standards and rules. No "Olympus" or "Mars" mentioned there. Review the names and everything else, and imagine this is incoming PR and you're a maintainer, what might block it from getting merged (unrelated changes, violations to the agreed on practices, dead/unreachable code, etc).

Also, note that dockerfile checks might get some warnings. Just ensure the build is safe, and the agents are working without env issues.
```

Karim@shipd
```
Ensure you add the lable of the rule that's been violated from the [platform-doc.md](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/review-guides/platform-doc.md) document in the review.
Like T1, S2, P3, etc.
```

Leonard@shipd
```
# Note on FP (False Positive) Checks

It has been raised that many of you might not fully understand this check. So this is to clarify what this check really means.

For the submission that you are creating, agent runs are meant to see how an LLM will perform in the task environment. We are looking for tasks that are hard and challenging for LLMs, and how this is defined, is by whether the agent's output passes the tests that you write - and a good task should have tests that correctly reflect what was required by the agent in your task environment.

False positives are when agents pass the tests, but do not *actually* meet the task requirements. For example, if your description prompt lists out requirements A B C but your tests only test A and B - an agent can meet A and B but not C but still shows up as a pass. This indicates either a gap in the tests (not testing for C) or a gap in the prompt (including a requirement C which is not really intended) which has to be fixed as this means the submission has broken verifiers (tests) and the LLM cannot be effectively evaluated.

The challenge of going through as little iterations of this as possible, is the skill of matching your prompt to your tests and making sure it is complete, and the mindset you should take is that you are trying to create an "exam" for the LLM and also effectively grade it. A good "exam" not only have tough problems, but also a fair and complete way to validate whether a passing student really met the goals of learning through taking this exam.

Under "Test Fairness" check, there is a 💡 icon. Even before the agents run, this indicates potential suggestions to improve your test coverage. Taking a look here and filtering out what is noise and what are true gaps in tests (that you should add) will save alot of iteration time. Catching these early is key, before the agent runs and fp panel which take much longer to complete.
```
