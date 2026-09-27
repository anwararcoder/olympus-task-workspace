# Workflow Onboarding — what changed, why, and how YOU operate it

_For the owner. Temporary doc — once this is second nature, the system itself
(`WORKFLOW.md` + `rules/` + `workflows/` + `lessons/`) is everything an agent needs._

---

## 1. The honest diagnosis of the old workflow (what the deep analysis found)

Your instincts were right more often than the outcomes suggest. The pain came from FIVE structural
gaps, not from bad execution:

1. **You measured the binding constraint last.** The diamond bar is the thorough-agent CEILING
   (rollout partial-reward median), but your pipeline discovered it after full build, castor
   calibration, sometimes after QA. secret-rotation was finalized — QA done, human review settled —
   then reverted on three 1.00 rollouts. semantic-tokens burned ~11 iterations before three
   independent 1.00 batches proved the ceiling. call-hierarchy saw a 1.00 at v3 and still spent
   rounds on levers. **Fix: W2 difficulty-preflight — rollouts on a vertical slice of the core,
   BEFORE the build. This is the single biggest change. Do not skip it, ever.**
2. **Repo choice optimized hygiene, not shape.** Stars/maintainers/license are necessary but
   predict nothing. java-language-server passed every hygiene check and consumed FOUR task
   attempts, because an LSP server backed by javac is a READ machine. sorg — one maintainer —
   produced your only true diamond, because it OWNS state with a lifecycle. **Fix: the seam
   inventory in W0; a repo needs ≥2 STATE/cascade-EDIT seams or it's out.** (Your "avoid giant
   orgs / very popular repos" instinct stays — it's correct for plagiarism/duplicate risk.)
3. **Plans asserted; nothing measured.** LoC estimates ran ~40% optimistic; "this will be 2/10"
   was theory; leaf-value shapes (secret-rotation) were detectable with an hour of arithmetic.
   **Fix: the three empirical gates in W1 — cascade arithmetic on paper, the hardest fork BUILT
   and measured, and a naive-agent gauntlet (a fresh strong agent attacking the draft
   description). Estimates are now banned where a measurement is possible.**
4. **The platform numbers in your docs went stale and contradictory** (400 vs 700 vs 850 LoC;
   "rollouts are reflection, not a gate"; "Go/Rust/TS/Python"; "0% unacceptable" vs
   hints-allowed). Agents anchored on whichever stale number they read first. **Fix: ALL numbers
   live in `rules/platform-bar.md` with a dated changelog; every other doc references it. When the
   platform announces a change, you edit one file.**
5. **Precheck and QA fix rounds were undocumented**, and lessons lived in one assistant's memory.
   **Fix: `{problem-name}-ledger.md` (one line per platform interaction — ten seconds), the lever ledger, and the
   `lessons/` registry that W8 forces into the rules. The file system is now the memory; any
   provider picks it up.**

What you were already doing RIGHT and the system keeps: multi-session separation (planner /
executor / critical reviewer — now formalized as builder-never-self-certifies in W4), the
uniqueness preflight, Phase A/B commit discipline, the start-qa.md manual (absorbed as
`rules/qa-authoring.md`), and the powerful-prompt idea doctrine (absorbed and extended in
`rules/task-shape.md` + `rules/idea-crafting.md`).

## 2. How to operate it (your side of each stage)

Every stage = a FRESH chat + one short invocation. Templates (adapt freely):

- **W0:** "Read `new-dot-agent/WORKFLOW.md`, then execute `new-dot-agent/workflows/w0-select-repo.md`
  for these candidate repos: <links>. Write the dossiers."
- **W1:** "Read `new-dot-agent/WORKFLOW.md`, then execute `w1-craft-idea.md` against
  `my-work/_repos/<repo>-dossier.md`. I want the plan with measured Gate A/B/C evidence."
  Then a SECOND fresh chat: "Red-team `my-work/<task>/<task>-plan.md` per w1 step's skeptic role."
- **W2:** "Execute `w2-difficulty-preflight.md` for `my-work/<task>/`." → You submit the slice,
  run Diamond Checks, download rollout trajectories, paste them back. The agent gives you
  GO / DEEPEN / KILL with evidence. **Respect a KILL. It is the system paying you weeks.**
- **W3 → W4:** builder chat executes w3; a fresh chat executes w4 (verification + adversarial
  review). You only submit after a w4 green with pasted four-state evidence.
- **W5:** every time platform results land: "Results attached. Execute `w5-platform-iteration.md`."
  Always download trajectories/artifacts first — scores alone misled us twice.
- **W6/W7:** as before (start-qa flow), now with the pre-QA huddle and class-sweep discipline.
- **W8:** at every terminal event: "Execute `w8-retrospective.md`." Five minutes that compound.

**What only YOU can do:** platform submissions/runs and downloads; the GO/KILL/downgrade/pivot
decisions (agents recommend with arithmetic, you decide); keeping `rules/platform-bar.md` current
when announcements land; supplying the QA test-group list; Discord/reviewer communication.

## 3. Provider notes (the system is provider-agnostic; these are accelerators)

- **Any provider:** everything is plain markdown + shell; state is files. To onboard any tool,
  point its entry file at this system (CLAUDE.md / AGENTS.md / equivalent containing one line:
  "Authoring work follows `new-dot-agent/WORKFLOW.md`; read it first.").
- **Claude (your Max plan):** use Opus/strongest for W1/W2-analysis/W4-review (judgment-heavy);
  Sonnet is fine for W3 execution against a strong plan. Plan Mode is ideal for W1 (it forces
  research-before-writing). Subagents are excellent for the parallel sweeps this system needs
  (W4's fairness+craftsmanship sweeps, W5 batch categorization — one agent per run). Background
  bash fits the long mvn/go builds. The naive-agent GAUNTLET must be a clean context: a fresh
  chat (or fresh worktree + subagent) given ONLY the description and repo — never the plan.
- **Codex/others:** AGENTS.md is auto-loaded — point it here; use its exec mode for long builds;
  same fresh-session discipline for gauntlet and red-team roles.
- **Superpowers plugin:** its brainstorming/TDD/verification skills overlap this system's W1/W3/W4;
  treat OUR rules as authoritative for task-authoring specifics (it doesn't know the platform), and
  its skills as generic reinforcement. No conflict, but don't let a generic skill override a rule.
- **Model-switching:** because dossiers/plans/ledgers/lessons are files, switching providers
  mid-task costs nothing beyond the new session reading the ledger + onboarding doc.

## 4. Extensibility (new requirements WILL appear)

When the platform changes something: (1) edit `rules/platform-bar.md` + changelog; (2) run a mini
W8 ("does this invalidate any rule/workflow logic?"); (3) only then resume tasks. When you learn a
new failure mode: lesson file + INDEX line + the rule edit, same sitting. The system's health
metric is simple: **no lesson may live only in a chat.**

## 5. Honest expectations & caveats

- This system makes you kill MORE ideas, earlier. W1/W2 will reject most candidates — that's the
  design. The wins: no more finalize-then-revert, no more 11-iteration calibration ping-pong, and
  every kill produces a transferable lesson for a few days' cost.
- The diamond bar at <0.6→0.4 with partial reward is genuinely brutal: it demands newsletter-shaped
  ideas (owned state, cascade through most of the suite). Those are rare per repo. Expect the
  portfolio (2-3 repos at dossier level) to matter — and expect that a good idea failing W2 is
  usually still a solid NORMAL Olympus task: shipping it there (like call-hierarchy and
  semantic-tokens) is a win, not a defeat, when chosen at slice-cost instead of after months.
- I could not read your other providers' chat logs; the diagnosis rests on the repo's docs, git
  histories, run artifacts, my own session memory of these tasks, and the three deep audits run
  today (newsletter exemplar; rules-staleness audit; process autopsy of call-hierarchy /
  carve-integrity / secret-rotation). Where the old `.agent/` docs and this system disagree, this
  system is current — the old tree stays untouched so in-flight tasks keep their references; adopt
  per-task, then retire the old tree when nothing references it. (Same reason I did NOT overwrite
  `standards/WORKFLOW.md`: the new single source is `new-dot-agent/WORKFLOW.md`; copy it over the
  old one whenever you're ready.)
