# Review Workflow (entry point)

Read this first. It is the only orchestration file; everything else is referenced from here.
When the owner says "review this submission per my-review-workflow", run the stages below in order.
All current numbers, panel fields, and score definitions live in `rules/platform-panel.md`; never
trust a number found anywhere else (including `reference/`, which keeps the old 1-7 scale docs for
their criteria lists, not their scales). Live platform docs (platform-doc.md, shipd-messages.md,
Reviewer-Instruction-Guide.md) are read from `../review-guides/`; the owner's updates land THERE,
so re-read the governing docs at the start of every round.

Standing policy, non-negotiable:

- Subagents gather data (counts, tallies, greps, gh searches). They never score, never write
  feedback, and nothing they report gets relayed without opening the file and confirming it
  yourself. See `rules/verification.md` for why.
- Everything sent to the platform is written by hand, in plain direct language. Style rules and
  banned patterns are in `rules/writing-style.md`.
- The output document always follows `templates/review-template.md`, one section per platform
  field, plus an Illustrations section for the owner.

## Stages

**R0 - Intake.** Inventory the artifacts (description, test.patch, solution.patch, dockerfile,
prechecks, auto-review, ai-evaluation, agent-runs, criteria panel, repo clone, base commit).
Confirm the base commit exists in the clone and is an ancestor of HEAD. Read the criteria panel to
fix the tier: the tier is set by which target is met (Olympus target met = Olympus), never by the
docker base image name. The criteria panel arrives as the owner-pasted header of prechecks.md; it
is a platform export the owner maintains, can go stale mid-review, and can carry another task's
blocks, so confirm any mismatch with the owner. The task dir may be recycled: its git log can open
with the previous review's commits (the log is the round journal). The dockerfile is inventoried,
not graded: environment adequacy is the bar. Standing fraud check: when the base pin is old, scan
BASE..HEAD for upstream work landing the same feature; a pin used to reintroduce landed work gets
the author a heavy warning.

**R1 - LOC gate.** Use the current golden-solution floor in `rules/platform-panel.md`, counted the
way managers count: strip blanks, comments, braces and punctuation-only lines, imports,
export-only wiring, type-only declarations, boilerplate, and test code. Run
`reference/count_loc.py` only as a lenient screen; historical hard-coded floors in older lessons
are not current authority. The criteria panel's successful-run LOC row describes agent diffs, so
also compute the meaningful golden count with the same exact-state manifest used by the review.
Strict count under the live floor = Request Changes; note-and-approve is not an option. Compare the
golden to each passing agent's diff as a padding or weak-test signal, not as a substitute for the
floor.

**R2 - Description.** Judge with `reference/check_description.md` criteria against the current
0-3 rubric, and phrase description feedback in the vocabulary of
`../olympus-tmp/new-dot-agent/rules/description-writing.md` (direct action opening, no motivation,
no external "X supports Y but lacks Z" framing, anchors vs telegraphs, no implied pre-existing
behavior); accuracy findings support the rule, they do not replace it. Karim's rules: concise, non-prescriptive unless undiscoverable, natural prose, no
external framing, no code snippets where plain English works, word count scales with feature size.
Cross-check every stated behavior against the tests. Formatting artifacts (`--`, non-ASCII, broken
markdown) are real deductions: that is the literal "2 Minor" line.

**R3 - Tests.** Judge with `reference/check_test.md` against the 0-3 rubric. First artifact, not
optional: the coverage matrix. Rows are every operation the description names; columns are every
dimension it states (cross-runtime, multi-link, lifecycle/reset, late-start catch-up, error
paths). Fill each cell with the covering test or mark it EMPTY. An empty cell on a stated
dimension is a test gap even when the fairness light bulb is silent; msw rooms had reset tested
locally and multi-link but never cross-runtime, no check flagged it, and the review got reverted
for it. Then the non-negotiables: fail-on-base holds, deterministic (async paths must wait, no
shared-state bleed), assertions strong enough that a wrong solution fails, no hidden requirements,
repo test structure and naming (check sibling test files in the clone before calling a deviation).
Fairness suggestions: valid and skipped = the author gets it back; overly strict or covered
elsewhere = a note. Every tolerance/bound gets checked in BOTH directions (kurbo-superellipse
revert): an assertion TIGHTER than the accuracy the call requests fails a faithful solution
(unfairness, T5); a bound LOOSER than the requested accuracy fails to verify the contract; and a
one-sided bound (a floor with no matching tight ceiling, or vice versa) lets the degenerate answer
pass (permissiveness, T3, e.g. above n=8 only an inscribed floor and a 1.05*rectangle cap, so
returning the plain rectangle perimeter passed). Walk the whole oracle table and name which of
those each cell is; a passing green suite hides all three.

**R4 - Solution.** Read the whole patch yourself, line by line, with `reference/check_solution.md`
in mind. Three mandatory hunts beyond the checklist: (1) a real functional bug the tests may not
reach (the missed `@array` lesson). (2) Dead wiring: any new hook, override, or callback must be
traced to the base-repo call site that invokes it; grep the clone, quote the line. Tracing proves
it RUNS, not that it does what the spec's scope demands, so after the call site, check the effect
against every dimension the description states (msw: reset() was genuinely called, but it cleared
one runtime while the spec made room state global). (3) Propagation audit whenever state is shared
across runtimes, processes, or tabs: list every method that mutates the shared state and confirm
each one either emits the propagation message or is the remote-apply handler. A local-only
mutation of state the description calls global is a solution bug; msw's resetRooms() cleared local
maps while join/leave/close/host all broadcast, and the next sync-state resurrected what it
cleared. Check comment/JSDoc density against the actual peer files, not against taste, and verify
each comment's factual CLAIMS (kurbo: a comment said the no_std FloatFuncs trait "does not include
signum" while common.rs declares it; a false justification comment is S4). (4) Numerically singular
or accuracy-driven features get their SINGULAR LIMITS executed, both ends (n->0 and n->inf,
tolerance->0, empty/huge input), and checked against an invariant that must always hold: a convex
perimeter cannot exceed its bounding-rectangle perimeter, a probability stays in [0,1], a guard's
magic threshold matches where THIS implementation actually breaks (kurbo shipped a perimeter of
14.23 above the 14.0 convex ceiling at n=4096, and an area of 0.0 in an exponent band the guard's
171 threshold mis-covered because the Lanczos code overflows at ~143). "Accurate by design" is an
unverified assumption, not a check; see rules/verification.md 10-11.

**R4b - Maintainer PR-merge lens (mandatory, added after the callback-archive revert
2026-07-19).** Elabyad's rule: read the two patches as an incoming PR and ask what stops a merge,
independent of what the graded `test.sh` runs. Two sweeps that both failed here, both cheap:
1. RUN THE REPO'S OWN LINT AND FORMAT GATES, do not eyeball them, and run EVERY gate its CI runs,
   not just one. Lint and format are usually SEPARATE gates and both red-line a PR: Rust =
   `cargo clippy -- -D warnings` AND `cargo fmt --all --check`; JS = eslint AND prettier; Python =
   ruff/flake8 AND the formatter (black / `ruff format --check`); Go = `go vet` AND `gofmt -l`. Open
   the repo's CI workflow (`.github/workflows`) and enumerate its lint/format/check jobs; running
   only one is the kurbo-superellipse miss (clippy was clean, so I stopped, and `cargo fmt --all
   --check` failed in three places -> CI red -> revert). Also find the config the linter uses
   (`.flake8`, `.eslintrc`, `ruff.toml`, `pyproject`, `.pre-commit-config.yaml`, `rustfmt.toml`,
   the `lint` script in package.json / Makefile). A test-file `F841` unused-variable was in my own
   notes as "cosmetic, does not affect grading" and it red-lined `flake8 dash tests`, which reverted
   an approve. Dead/unused/lint-failing/misformatted code in EITHER patch is a real finding even
   when the hidden suite is green; "does not affect grading" is not a reason to drop it, because the
   manager reviews it as a PR.
2. EVERY FLAGGED INSTANCE IS A CLASS, RE-SWEEP IT WHEN NEW CODE LANDS. When you flag one defect,
   grep the whole diff for its siblings, and on every later round re-run that grep against the new
   code. Same revert: I flagged `prevent_initial_call_mode` leaking into `/_dash-dependencies`, the
   author fixed it, then a new round added `callback_list[-1]["clientside_function"]["source"] = ...`
   on the same shared spec dict that `dependencies()` serialises, and the identical leak shipped
   because I confirmed the first instance was gone without re-sweeping the class. For any state that
   reaches an external surface (a browser payload, a serialised response, a persisted file), list
   EVERY write to the shared object and confirm none adds unrequested data. This is the R4
   propagation audit generalised: mutation of a shared-serialised object is the same bug class as a
   missed broadcast.

**R5 - Runs and fairness.** Tally every agent run: verdict, baseline/new, failure reason. Cluster
the failures. Failures spread across real behavioral gaps = difficulty; every agent tripping on the
same undiscoverable point = ambiguity and it blocks. Read the passing runs' diffs for gaming
(hardcoded outputs, test-keyed branches) and for the LOC comparison from R1. Treat "Task Quality"
flags and unfair-run flags as serious; ignore the low-value per-unit AI nitpicks (Kevin's rule).
The False Positive evaluation is required by the live panel and can block. Read every passing patch,
reproduce claimed discriminators against candidate and golden when needed, and independently
re-derive every `PASSED_WITH_WARNINGS` caveat; `SPEC_GAP_REFERENCE_ALSO_FAILS` is a golden/spec lead,
not a harmless badge. Auto-review and Env Quality findings are evidence: a concrete reproducible
solution, test, fairness, or environment defect blocks on its merits even if the helper check is
otherwise advisory. State any check status only from an explicit verdict line or the owner
(verification rule 9).

**R6 - Upstream and repo fit.** Run the checks in `guides/upstream-repo-fit.md` (gh cookbook plus
local clone). Output three answers with evidence: duplicate or already solved? any maintainer
ruling or conflicting PR/issue/discussion? does the feature extend an existing mechanism of the
repo or invent a foreign one? The third is judgment, not search (Karim), so ground it in what the
repo already does and say so in one or two lines. Platform-side overlap is adjudicated at
PROGRAMMING-LANGUAGE scope (owner rule, 2026-07-04): the related-submissions pool is the
language, so an accepted same-language task holding the same feature slot blocks a re-implementation
in another repo; "different repo, different author, zero shared surfaces" is not a defense. Run
the co-existence test against the pool, and read the candidate list's accepted/rejected statuses
as possible prior rulings on the same idea.

**R7 - Score and write.** Map findings to the 0-3 rubric in `rules/platform-panel.md`, honestly:
any field with real minor notes is a 2, not a 3 with excuses. Scores under 3 get a Reason written
to the author for that section. Reasoning that used to be internal goes into Other notes (panel
change, 2026-07: there is no internal reasoning box). Fill the doc from
`templates/review-template.md`. Approve with 2s is normal; Request Changes needs each blocking item
stated as an action; Reject needs the core-idea reason per `reference/check_rejection.md`.
Recommendations follow the discipline block in `rules/writing-style.md`: root-fix direction that
respects repo standards and the offline sandbox, no exact test filenames, unsure = bare minor
without a recommendation, description edits last resort.

**R8 - Self-review gates.** Two passes before anything is submitted:
1. Claim check: every factual assertion (dead code, never called, N runs failed, exists upstream)
   gets re-opened in the file or re-run in the shell. No line, no claim.
2. Tone pass: reread author-facing text against `rules/writing-style.md`. Cut praise intros,
   filler, repetition across sections, and every non-ASCII character. If a sentence is neither a
   fact nor an action, delete it.
3. File check: the summary sent to the owner quotes the final review.md decision and scores,
   never a draft.

Then log anything new in `lessons/LESSONS.md`, same sitting.
