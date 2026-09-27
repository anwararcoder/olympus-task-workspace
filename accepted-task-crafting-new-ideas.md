I want you to recall the full history with all mistakes, iterations, fixings, lessons, etc and help finding the next task from [vineflower](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/repos/vineflower/) repo to start gettting the next idea that we will work on similar to other tasks. I set goal to take the time you need to analyze everything. Don't limit yourself to our task only, there are a lot of great lessons in other tasks, and of course recalling all small details from [.agent](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/.agent/) and [new-dot-agent](/home/zeyad/Downloads/ai/shipd/olympus-tmp/new-dot-agent/) and developing the reviewer persona as well by rechecking [review-guides](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/review-guides/) and [my-review-workflow](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-review-workflow/) are very very important to spot what will work out and what to skip.

The repo is new, I only developed one idea from it which is [vineflower-duplicate-class-resolution](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-work/vineflower-duplicate-class-resolution/) directory and we could get the same infra (test.sh and dockerfile) from it and that will save time for us.

I gave this prompt to claude before to help me refining some tasks and I think it could help you a lot:
```md
Hey there. Could you please make a re-review to the latest changes within .agent/rules and .agent/workflows along with new-dot-agent under olymypus-tmp/ and ensure you got the whole updated info?

There are some stuff that got updated, and I can't list them all, and good analysis will help you.

Also take a task like @shipd/Shipd - Olympus/my-work/Accepted/olympus/sprint4/immutables-binary-serialization/ and analyze its full history because it's dense and contains a lot of useful insights.

Also re-develop the reviewer persona by analyze 2 recents tasks we reviewed within my-work/Reviews/Accepted, and ensure you analyze all files under my-review-workflow and review-guides/ directories.

Go ahead and ensure everything is perfect to go with.

I will need that as I will fork this chat multiple times to refine or start implementing new tasks and I don't want each chat to start analysis from scratch again, so you will be the foundation, and I need this to be perfect.

There are some files I used before please have a look on them because the same instructions could be useful for you like @shipd/olympus-tmp/refine-fp.md  and @shipd/olympus-tmp/Review-sub-starter.md  and @shipd/olympus-tmp/review-codex-start-prompt.md  docs.

Go ahead and don't stop until ensure you developed that sense. Everything else will build up on this, so please take your time to refresh everything and use good analysis not just random grep or some similar stuff.

Note: you might find some info are outdated like the pass rate or somestuff. Also we introduced some new checks that might not be fully present like repo-fit, and {task-name}-verifier-audit like the one within @shipd/Shipd - Olympus/my-work/immutables-seedable-lazy/. 

It's perfect to analyze this seedable-lazy task as well, and check what we have gone through so far. Agent-runs are perfect to know how capable those agents we are dealing with, and also, it's useful to see the steps they made through the whole task, it will be perfect when crafting an idea as well, to know the needed level of difficulty to challenge those agents.

/goal Go ahead and do amazing work.
```

Please take your time to do the analysis you want. Go to tasks within [sprint4](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-work/Accepted/olympus/sprint4/) analyze their git history fully, see how fp behaved against each change we made in any artifact, also see the auto-review and its evaluation across the history, etc.

All of that is essential to ship something that's really working without taking those too long iterations like what happened with [immutables-binary-serialization](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-work/Accepted/olympus/sprint4/immutables-binary-serialization/) or [immutables-seedable-lazy](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-work/immutables-seedable-lazy/) tasks.

But as you are taking the needed time and doing a great analysis. I don't want only one valid idea. I want 3 actually, and their details should be written in directory and plan doc and their task-prompt.md that will be the entry point to a chat that has zero context about everything.

You should see some directories like the current active ones under my-work/ they are in development right now, and the start was done by an agent like you who created the directory then put 2 files:
{repo-name}-{task-name}/
- {task-name}-plan.md (show every single detail the agent need to know and will act as onboarding on the task and the repo and what we are doing and will show the choices, and will tell him to be skeptic and have critical analysis to what's written and will ensure it also not take anything superficially but instead should have a deep look and see the full picture when going or not going with a claim or finding. Of course it should refer to all files, rules, guidelines, standards, explain how we work, show what to analyze and spend time doing it, etc.
- task-prompt.md (shows all details that an a zero context agent should know and that what I will copy and paste in the agent chatbox, and should deliver those files:
  - {repo-name}-{task-name}.md (description)
  - test-{task-name}.patch
  - solution-{task-name}.patch
  - dockerfile-{task-name}
  - BASE_COMMIT-{task-name}
  - {task-name}-plan.md (written by you)


Now do amazing work with crafting those 3 directories and each idea should be reviewed critically multiple time to ensure it's repo fit, not ruled against from a maintainer or something, and of course it should allow no space for false-positive or pass rate to be broken or something. This will be understood better by analyzing the false-positive docs in multiple tasks and how we evolved the task multiple time until we we were able to get it passed.

Have amazing attention to details please even stuff that I might miss while talking here and ensure we deliver amazing work.

Go ahead and do amazing work please with the three tasks and ensure all of them are valid and will payoff a great tasks.