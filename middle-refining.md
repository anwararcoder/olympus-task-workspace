Well, rememeber what brings us here. I needed your help to refine the tasks to be ready to be accepted. We successfully passed the prechecks, with this task, but after running the agents to evaluate the pass rate we couldn't achieve the needed pass rate and also one agent flagged the task with test_mismatch (agent-13) which affect the fairness of the task.

Please analyze all details pretty well. I downloaded all evaluations, prechecks, verifier-audit (the directory that has 2 docs, and it's optional by the way but could provide good insights, don't stick to all stuff, see what's really valid only), auto-review.json, repo-fit, and of course the agent runs with all attached artifacts to it.

I want you to analyze everything correctly not just in a small or inefficient way or random greps, etc. I want to gather correct, complete, and valid info please. This is required because this will affect the way you will work on.

Also remember what I am telling other agents while working to ensure they are present to the rules, guidelines and standards to avoid breaking something by mistake.

Files like @shipd/olympus-tmp/review-codex-start-prompt.md , @shipd/olympus-tmp/Review-sub-starter.md , @shipd/olympus-tmp/TASK-LIFECYCLE.md , @shipd/olympus-tmp/TASK-LIFECYCLE.md , etc.

Those are files that and even the guidelines themselves always putsh to be skeptic, fully-mindful, and have good sense to small details that affect the whole submission. Those gian info could lead to a small sentence change or 2 or 3 lines in the patches, but lead to a huge difference.

So please take your time with analysis to remind yourself with all small details then ensure you refine the task.

First after finishing all needed analysis I want you to write down those 2 docs:
commit-message.txt: to document this first iteration following @shipd/Shipd - Olympus/.agent/workflows/write-commit-message.md workflow.

Second: {task-name}-next-plan.md to show the current state of the task and what are the blockers and what are the valid points that are raised and need to be addressed and how to achieve the needed consistency between all deliverables, and how to ensure the task is solvable by the agents after analyzing their trajectory and notice the major blocker that blocked the most capable/nearest agents to solve it. Also, show any small defects you noticed while working.

Then do the commit by yourself as following:
git add .
git reset commit-message.txt task-prompt.md
git commit -F commit-message.txt
git tag "v$(($(git tag --list 'v*' | sed 's/v//' | sort -n | tail -n 1) + 1))"


Then start executing to fix anything that block this task from being accepted, and don't forget to cover anything related to false-positive, issue in the solution, auto-review points, or anything else.

You should be very powerful to do that. Also, btw the current task is passing the "Verify Solution" and "Verify Tests" So the current artifacts are passing the four states of verifications. I know that some major changes must be verified using @shipd/Shipd - Olympus/standards/HYBRID-CLOUD-WORKFLOW.md approach, which is okay, but this might take too long, so I would like to make it take as minimal time as needed and use it if you really need it and there's no way to validate everything is good with lighter methods. Of course don't build or run anything locally as we got weak resources, but use what you only need, and if you could ensure stuff are okay quickly then do it.

I set /goal to take the time you needed so please ensure you achieve that goal. 


Go ahead now and do amazing work please. 