Hey there. I need your help to be a critical reviewer for Olympus and Mars tasks, and this require you to be aware of all details.

I used to use Claude for this, and he logs a lot of stuff in files like MEMORY.md and in the system claude configurations.

Those lessons are very very important as this process evolve over time, and I need you to be aware of small details as they make a huge difference.

Now to understand what we are doing here you should first understand what we are doing to craft a task for shipd.ai.

To know that you will start by analyzing everything under those stuff:

Ship - Olympus/.agent/rules
Ship - Olympus/.agent/workflows

You should also analyze those docs pretty well:
[WORKFLOW.md](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/standards/WORKFLOW.md) 

Also, if you want to test anything (mostly you don't need while reviewing) you could analyze this:
[HYBRID-CLOUD-WORKFLOW.md](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/standards/HYBRID-CLOUD-WORKFLOW.md) 

Also, the new version of this workflow is:
[new-dot-agent](/home/zeyad/Downloads/ai/shipd/olympus-tmp/new-dot-agent/) Read all files and the files under the sub-directories to ensure everything is understood.

Now after you get that, I need you to go to the actual part that you will be responsible for which is understanding what we should do in the review.

You should start by reading all files under this directory:
[review-guides](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/review-guides/) 

They have some old files from my friend who was a reviewer before me. I also asked a friend Winnie to give me her checklist and I put it under this directory. Also, the main rules like the documentation from the platform itself is within [platform-doc.md](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/review-guides/platform-doc.md) and you will find some other docs like shipd-messages.md which are pretty important to get some context.

Then I asked Claude to help me crafting my pretty good workflow to avoid that and he crafted [my-review-workflow](/home/zeyad/Downloads/ai/shipd/Shipd - Olympus/my-review-workflow/) that you need to analyze it as well.

Finally checking how we do the review is the most important and the final piece to check.

I have a folder called Reviews under my-work and it has a good structure.

Rejected/ contains the approved rejections.
Accepted/ contains the accepted reviews that I made for some submissions.
Waiting/ Containing 3 other directories that still pending as following:
   Change-Request/ contains the tasks that I requested some changes and waiting the author to address them

   Approve/ contains the tasks I approved and waiting for a manager to check my review

   Rejected/ contains the tasks that I rejected and waiting for the manager to check my rejection reason.
If there's an active review (a submission we are currently review) it will be next to those directories (Accepted, Rejected, and Waiting) and after finishing I move it to one of the Waiting directories.


Now the task itself contains pretty similar deliverables to the normal task we create, but some stuff are not present as it's not our own crafted tasks like the git history or plans, etc.

Mainly the task contains the "agent-runs" which are the agents who evaluate the task and their detailed artifacts. Also, we have the main deliverables like base_commit.txt, dockerfile, description, test patch, and the solution patch. quick-setup are a script provided on the platform to help simplifying the setup to check the task in live, but as I said before we rarely need that.

I also add a screenshot for how the review panel look like, and it's the same and repeated over the tasks, as it's rarely change. Also we have the ai-evaluation.md which is a document we get from the platform, and sometimes we have auto-review.json as well.

review.md is the file you craft within each task and it should have the same strucutre and outlines similar to other tasks, and this one had a lot of requirements as you know from your analyis to the other docs.

Previously when I started the review with claude I gave him this prompt, it can help you but it's not everything as a lot happened after that and we fixed, and improved a lot of stuff over multiple iterations and reviews, and if that prompt might help you somehow it's within [Review-sub-starter.md](/home/zeyad/Downloads/ai/shipd/olympus-tmp/Review-sub-starter.md) doc.

Generally, be concise, direct, and have good attention to small details, have a lot of skepticism and critical thinking even against your review itself, and ensure your review is complete and cover all details. Don't recommend something that violate the repo coding standards or rules.

Also, be direct about the issue, and most importantly write it in a humanized way. Most of issues comes from AI-ish stuff.
When raising a point, show the issue, then your recommendations to resolve it in actionable steps. Analyzing other tasks will help you a lot.

Check for all manager-feedback.md docs, then analyze the diretory that has this doc, and check this directory/task very well, and its history if any, becuase those are notes from managers that review our work.

I need you to develop a good sense and analyze everything and that's your only task. Develop a good sense of how a good review look like, and analyze everything to do that. Lessons, insights, and solid understanding for all small details that I might miss in this prompt is your task.

After you finish tell me that all is good and we are ready to start reviewing submissions, and we will start together.

Go ahead and do amazing work please.
