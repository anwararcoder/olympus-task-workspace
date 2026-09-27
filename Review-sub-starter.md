Hey there. I need you to develop a very good sense in understanding the criteria and assessments of how a good submission look like for shipd tasks.

The current workspace is deisgned to create a powerful tasks that can be accepted with minimial required changes, and I added a lot of written and un-written stuff to achieve that or to balance multiple stuff together, and sometimes to tweak the checks somehow.

But now you should act as a reviewer. I am having 2 tasks that I should be a reviewer for them, and this is pretty new for me.

Here's the message I got:
```
I sent you an invite on platform to review 2 tasks, you'll find it in your notifications.

Before starting, please read the docs carefully:
https://shipd.ai/quests/olympus/docs/problem (@shipd/Shipd - Olympus/guides Review/platform-doc.md )

When reviewing, make sure to check:
* Repo requirements
* Problem description quality
* Agent runs
* Fairness
* Actual challenge level
* All small details

Using AI or agents to help during the process is allowed, but don't rely on them heavily. Your judgment is what matters.

If you think a submission should be rejected, you don't need to continue the full review. Just write clear feedback, explain your reasoning, and move on.

## What you'll see in the assessment
You'll be having the **reviewer view** of submissions "it's pretty much the same, just some extra fields". There is a checklist has **21 checks**, matching the docs, and will guide you through what to review.
✅ To approve a submission, **all fields must be "Yes."** and the quality rating should be from 5-7.

If you're requesting changes or rejecting, you can put any suitable quality rating in your POV.

📝 **Feedback vs Reasoning fields**

* **Feedback** goes to the author, so make it clear, complete, and include all issues you found.
* **Reasoning** is internal, visible only to us, where you explain why you rated it that way or clarify anything for managers/admins.

There's also a special field for logging your **thoughts and review flow**. We'd love to see how you approach the review and what steps you take. Grammar doesn't matter there, just write naturally.

The assessment is timed, so make sure to have a clear 2-hour window for having it cause it cannot be paused.
Ignore any staleness in the checks, and take care when writing the feedback cause I saw some people pasting AI-written feedback and it's affecting the verdict. (Ensure it's humanized)

```

This is an assessment to see if I can use AI with reviews like I am doing with creating challeneges.
So I need you to avoid breaking or clicking some stuff by mistake, but you can launch the browser to analyze some stuff if you need to, and I will try to provide as much info as possible locally.

Also review how Olympus and Mars tasks are reviewed within *-human-reviews.md and what the reviewers focus on.

Pick any *-human-reviewer.md doc and analyze as much as you need and ensure you develop a perfect sense of how to evaluate a task.

We should check for paliagrism and the platform help with that.
There are some stuff that the checks might miss, and that's our role to do. Also the most important and hard stuff is to check that there are no PRs for that task, and any discussion that touch that task should be reviewed and ensure we are aligned with the upstream without violations, like the maintainer said explicitly this should be done using X and the task is doing it using Y, or anything else. We had a similar disucssion with a human-reviewer when we were crafting @shipd/Shipd - Olympus/my-work/Accepted/olympus/sprint2/osctrl-secret-rotation-windows/ task, and you can check the human reviewer notes, and how I tried to convince him (and I tried to implement his suggestion, but it didn't workout).

I asked a friend who was a reviewer before to help with providing some insights and he gave me @shipd/Shipd - Olympus/guides-review/ directory, and I added 2 docs in it. Winnie-checklist.txt. This is from a different friend, and @platform-doc.md to check explicitly what the platform said (the official doc).

While crafting a task, I target some horizons that even more than requirements to ensure we are having lower chance of getting a rejection or having a bad review. But this shouldn't be applied to the reviews we should do. We need to ensure the main checks are valid, and no hidden issues like what usually happen with *-human-reviews.md. But it's useful to have an idea of how I evaluate stuff but don't care about diamond at all. Just ensure we are focusing on mars and Olympus.

Mars conditions are a bit different than Olympus, as Olympus is harder and has some more requirements like 400+ effective LoC, and more >= 3 files touched and 30% pass rate, while Mars pass rate is 40% and just requires >= 100 LoC.

Analyzing the files under .agent/rules and .agent/workflows along with @shipd/olympus-tmp/new-dot-agent/workflow-onboarding.md will help you got that sense but most importantly analyzing all files under guides-review and *-human-reviews.md.

So please ensure we are fine with that and ensure you get the full picture first.

After you develop that sense of how to critically look at a task/submission, and find all hidden issues within it. Like violations to software principles, and differentiate between minor and critical stuff. Spot any buggy or dead code, etc.

As you know launching browser and analyzing via it is pretty slow and cost a lot of time and resources and we are tied with only 2 hours to review 2 tasks. So let's first discuss if we really need to launch the browser sometime.

I don't want you to review anything. I just need you to handle that part first before anything else so when I enter the assessment, you already have all the needed context to start ahead.

Finish your analysis, and let me know when you're ready to start ahead so I can start the assessment. Also, ask if anything is needed and if anything is confusing.

Go ahead and do amazing work.
