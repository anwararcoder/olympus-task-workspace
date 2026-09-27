# Lessons (dated, append-only)

- 2026-08-01 (snoop Add-a-JSON-wire-format, from-scratch Request Changes 3/1/1; auto-review gave
  3/1/0): when the auto-review scores harshly, evaluate independently and take the DIRECTION while
  correcting the SEVERITY. Its Solution 0 ("breaks existing code") pointed at a REAL regression but
  overshot: the feature is comprehensive with a legitimate 42/42 passer, so the honest score is
  Solution 1, not 0. The reference REGRESSION was triple-confirmed without any rerun: (a) the diff
  removes `import traceback` and the whole `DefaultFormatter.format_exception` method that base keeps
  at formatting.py:275 (which renders via `traceback.format_exception_only`), rebuilding the line
  from `exc_name + str(exc_value)` for BOTH text and JSON; (b) the FP adjudicator ran the
  exploding-`__str__` case and tagged `REFERENCE_WEAKER_THAN_CANDIDATE` + `SPEC_GAP_REFERENCE_ALSO_FAILS`
  (base + passer handle it, reference raises); (c) the runs tally showed NO agent deletes
  `format_exception_only` and the passer keeps it, so the reference is UNIQUELY regressed. A golden
  that refactors a SHARED path and regresses existing behavior the passer avoided = Solution finding
  (S2), and a subclass-only approach (what the passer did) is the fix. Tests 1 driven by TRIPLE
  CONVERGENCE (auto-review + verifier-audit INCOMPLETE + Test-Fairness lightbulb) on the SAME two
  stated-behavior gaps: offline source independence unenforced (the test literally NAMED
  `test_render_text_uses_json_without_source_file_access` renders with the module source still on
  disk = DEFINED-not-ENFORCED, same name-body-mismatch class as a mislabeled duplicate), and
  string-value rendering untested (all value asserts are integers where str==render, so a
  quote-stripping shortcut passes; VCA-demonstrated). Adjudicate the SKIPPABLE fairness items to
  avoid over-strictness the user warned about: depth is covered INDIRECTLY by the exact-replay tests
  (wrong depth -> wrong indentation -> replay breaks); rejecting an unknown wire_format is NOT stated
  (T5 fair bypass). VCA is now OPTIONAL/advisory (FP is the mandatory gate) but still the sharpest
  test-completeness signal - grep the current test.patch for its remedy test names (all 3 absent =
  gaps live), then adjudicate each like a judge dissent, do NOT auto-adopt its patch. New repo-fit
  gate (automated, PASS here) + plagiarism: an accepted OLDER same-language sibling (PySnooper
  output_format='json', verdict similar_idea 0.59) shares the JSON-emission CORE but this task's
  offline exact-text reader (read_events/render_text) is substantial distinct machinery -> COEXIST,
  not duplicate (different lesson taught; repo-fit + the meaningful-difference test agree). R4b: snoop
  CI is pytest-only via tox (no flake8/pylint/ruff gate in setup.cfg/tox.ini), so no lint gate to run
  - grep the repo's own config for the real gate before assuming one, like TinkerPop's absent
  checkstyle. Efficiency win: everything decisive was already platform-verified (FP ran the crash,
  VCA demonstrated the shortcuts, runs confirmed the passer) so NO forge rerun was needed; reproduce
  only a defect that ISN'T already asserted true.

- 2026-08-01 (sqlmodel Add-typed-streaming-query v3, Request Changes 3/2/1 FINAL; my draft was 3/3/2,
  owner corrected both scores): TWO scoring errors, both from under-weighting the auto-review. (a)
  CR -> the driving field is 1/3, not the go-pretty 2-with-RC split: an RC means something "has to be
  fixed" (the panel's Weak hover), so the blocking field is Weak; FieldInfo drove RC -> Solution 1.
  (b) NEVER dismiss the auto-review off a TRUNCATED summary - I read only the cut-off reasoning, called
  its Tests-1 "narrow typing coverage" flatly over-strict, and scored Tests a clean 3. Re-reading the
  FULL tests.output.issues showed a real Low point I had missed: the empty `one_or_none()` outcome is
  asserted to return None but never asserted CLOSED, though the reference closes it in its own branch
  (`if value is _EXHAUSTED: self.close(); return None`) and first()-discard + multiple-error ARE
  asserted closed - a stated-behavior terminal-closure gap on one code path = real valid-and-skipped
  Tests minor -> Tests 2. The adjudication METHOD that separates the over-strict part from the real
  residual: READ EVERY CONSUMER SIGNATURE. The auto-review's broad "fetchone/fetchmany/fetchall/
  iteration/partitions/scalars degrade to Any" is FALSE - all return `_T`-derived types
  (`_T|None`, `Sequence[_T]`, `Iterator[Sequence[_T]]`) over a shared class generic, so one
  `assert_type(mapped.first(), str|None)` pins the class and covers them by construction. The genuine
  residual is `scalar_one`/`scalar_one_or_none` -> `Any` (a reducer, not a row-yielder), left UNSCORED
  because the reference AND both passers are Any, first-column-of-heterogeneous-tuple needs TypeVarTuple
  none of them use, and a precise-typing test would FAIL the reference (apollo fails-the-reference =
  not a demandable gap, unspecified edge like the FP __table__/Scope.local cases). Meta: a green
  typing test + a harsh auto-review Tests band is the same shape as jsdom-single-stylesheet - the
  helper flagged a real gap AND some noise; work each point to the signature/branch, do not batch-
  dismiss or batch-accept. The R4b blocker below stands unchanged. -- ORIGINAL ENTRY: the blocker is the
  R4b/callback-archive class, found ONLY by running the repo's own CI gates. The graded test.sh runs
  `ty check tests/test_stream_typing_208087.py` (the new typing FILE) which PASSES on the reference, so
  the platform batch is green - but the repo's actual CI gate `ty check sqlmodel` (the whole library)
  FAILS with one error: the author's unrelated edit dropped `# ty: ignore[subclass-of-final-class]`
  from `class FieldInfo(PydanticFieldInfo)` in main.py, re-exposing a real ty error. A checker checking
  ONE file does not surface import-graph errors in the modules it imports, so a green typing test and a
  red `ty check <package>` are consistent; that is exactly why R4b (run the repo's OWN gates, every
  CI job, on base-vs-patched) is mandatory even when the hidden suite and the in-suite type check are
  green. Counterintuitive direction, so RUN it, never reason: I first hypothesized the ignore-removal
  was REQUIRED (that ty 0.0.61 no longer flags it); the base-vs-patched run proved the OPPOSITE - base
  `ty check sqlmodel` = "All checks passed", patched = 1 error, the ignore was suppressing a genuine
  error. Env confound to remember for astral tools: `ty`/`ruff` resolve the SYSTEM python by default;
  installing deps into a venv is invisible until you pass `--python <venv>` or set VIRTUAL_ENV, else
  every import shows `Unknown`/unresolved and you get hundreds of false diagnostics (201 here). ruff
  check + `ruff format --check` both passed (closed my v1 format finding), so only ty was red. Verdict
  calibration: this is NOT the excelize "second RC on a nit" (verified-true + NO-value-impact +
  out-of-scope = Solution 2 under Approve) because it BREAKS a merge-blocking CI gate = real value
  impact; the callback-archive precedent (approve reverted for a dismissed lint-gate failure) governs,
  so RC. Scored Solution 2 not 1 (the feature code is pristine; the defect is one unrelated line) with
  an RC decision (specific fixable blocker drives RC without a field at 1, go-pretty split). Two
  OVER-STRICT auto-review points correctly declined per the owner's "covered indirectly" steer:
  (1) "typing test checks a narrow subset of consumers" - false, because first/one/one_or_none/all are
  declared once over a SHARED generic `_T` (`first -> _T|None`, `one -> _T`, `all -> Sequence[_T]`), so
  `assert_type(mapped.first(), str|None)` already pins the result to StreamScalarResult[str] and makes
  one()/all() str by construction; one consumer per shape/transform is sufficient - READ the signatures
  to prove the generic is shared before honoring a coverage complaint. (2) description density - author
  tightened it and the contract is complete/accurate/load-bearing for a huge feature, so no re-ask
  (Karim word-count rule + re-ask trap). Typing-test load-bearing PROVEN by the batch, not reading:
  Nova_4 is behaviorally correct 572/573 and fails ONLY test_stream_exec_static_typing (3 runs fail it
  total). FP PASSED_WITH_WARNINGS re-derived: judge-c's duplicate-output-label probe fails identically
  on the REFERENCE (shared unstated gap, native SQLAlchemy resolves it, not an FP) and the
  select(model.__table__) shape is single-entity-vs-multicolumn-unspecified; the adjudicator's own
  170-scenario candidate-vs-reference differential found zero prompt-stated divergence. Repo-fit is now
  an automated PASS gate; the lazy transform pipeline remains the maintainer-debatable stretch but no
  ruling exists, so medium-confidence pass not a finding. Ops: sqlmodel is pure-Python, a local git
  worktree at the pin + venv (ruff + ty==0.0.61 + sqlalchemy/pydantic) runs all four gates in seconds,
  no forge needed.

- 2026-08-01 (fuite Leaks-inside-same-origin, from-scratch Request Changes 2/1/2; auto-review said
  2/1/0): the auto-review's Solution finding was DIRECTIONALLY RIGHT but severity-wrong - a
  well-built impl passing all 18 new + 32 baseline tests with ONE wrong guard on an untested edge is
  Solution 2, not 0 (0 is wholesale failure). The finding: reference `readLabel` in labelFrameTree.js
  RE-VALIDATES the stored frame label against the owner's current tag#id.classes description and
  DISCARDS it on a mismatch, so a re-described owner (id/class change between passes) is relabeled and
  its before/after records split across two frameQualifiedKeys, violating "an owner keeps its first
  one for the whole run". THE AMBIGUITY RESOLVER = the passers: I read BOTH (Orion_1 keys labels by
  the Frame object in a WeakMap and skips any already-seen frame; Orion_2 keys by the owner element's
  backendNodeId and reuses the stored assignment), and BOTH keep the label purely by IDENTITY, never
  re-deriving from the live description - so the reference is the lone OUTLIER and this is a real
  deviation, not a two-readings ambiguity (if the passers were split it would be spec ambiguity =
  Description pick-one-contract; both-agree-the-other-way = reference bug). Method to reuse: when an
  audit flags a reference-side sticky/identity bug, GREP BOTH PASSERS' implementation of the exact
  seam before scoring - a discrete code-path deviation is a keying certainty, no browser repro needed
  (user's "don't reproduce 1+1"). Why FP-PASSED + audit-Solution-finding are CONSISTENT (state it for
  the manager): the mandatory FP panel inspects the actual PASSERS, who keep by identity and are
  genuinely correct, so it rightly passed them; the auto-review inspects the REFERENCE, which carries
  the guard - not the over-strict-verifier case the owner warned about, because the reference truly
  deviates from a rule both passers satisfy. Tests 1 driven by TWO valid Test Fairness suggestions
  (advisory != skippable, Karim): (a) mid-run free-index reuse - stated ("takes the lowest index its
  description has free"), untested (no fixture inserts an owner post-measurement; destroyed-twin only
  checks survivor-keeps-index, never repopulates), reference CORRECT so a demanded test is safe and a
  monotonic-counter impl slips; (b) sticky-under-mutation - untested, and the demanded test FAILS THE
  CURRENT REFERENCE, which is the tell that it exposes the Solution bug (not a safe-to-add cell). R4b
  for a JS repo: fuite CI = `pnpm lint` (StandardJS = lint AND format in one, so no separate prettier
  gate) + `pnpm test`; ran `npx standard` on the patched worktree = exit 0, zero violations, so the
  superellipse-class clean-lint-red-format revert is absent. New automated repo-fit.md check = PASS,
  corroborated by base README ("fuite focuses on the main frame... will not find [cross-origin
  iframe/worker] leaks") documenting the exact limitation this extends. R8 CLAIM-CHECK CATCH worth
  keeping: a too-broad mutation grep (`\.className\s*=` etc.) returned 9 hits that looked like owner
  mutations but were ALL `div.className='...-leak'` leak-NODE setup, not frame-owner changes - verify
  WHICH construct matched before shipping a "no mutation" claim, and reword "the only mid-run change
  is N .remove()s" to exclude the leak-node churn. Pure-JS/Node repo = local git worktree at the pin,
  no forge (jsdom/dash rule).

- 2026-08-01 (kurbo Add-the-superellipse v6, RC 3/1/1 -> APPROVE 3/2/3; the terminal round of the
  manager-reverted task): on a manager-reverted task you re-sweep EVERY revert point against the
  current tree each round (R4b every-instance-is-a-class), not just your own last asks. All nine
  manager points closed: perimeter now Simpson arc-length + PINNED by a both-direction test
  (`perimeter_large_exponent_not_collapsed` bounds p between the inscribed lower bound and
  `4(a+b)+1e-9` at n up to 65536, so the old 14.23 overshoot fails); area guard moved to
  `1+2/n < 140` with the comment naming the real `t^(x+0.5)` overflow near x=142; fmt+comment+shared-
  constants+one-file+harness+exponent-range all fixed. RULE 10 SATISFIED CHEAPLY: I executed the two
  singular limits the suite dodges in a local throwaway worktree (cargo warm from the clippy build) -
  area(0.011..0.0145) is finite non-zero (area(0.013)=9.10e-45, not the old 0.0) and huge radii
  return inf not NaN - so "fixed by guard 140" became "executed-correct", not "correct by design".
  R4b FOR RUST IS THREE GATES not one: `cargo fmt --all --check` + `cargo clippy --all-features
  -Dwarnings` (std) + `cargo clippy --no-default-features --features libm -Dwarnings` (no_std); the
  round's new `fit_scale` added `log2`/`powi`, transcendental fns that need FloatFuncs under no_std -
  verified `log2` IS declared (common.rs:128) so no_std stayed clean, but you RUN the no_std gate,
  you don't infer it (this task reverted round 1 on a CI-red fmt gate clippy-clean hid). THE
  AREA-BAND ADJUDICATION is the model for really-uncovered-but-not-a-blocker: the log-space area
  branch (n<0.0144 or huge radii, the exact band the manager flagged) has ZERO test coverage, but
  the colyseus empirical trigger-realism check settles it - ALL TEN agents compute area in log space
  (grep each solution-patch's `fn area` guard: log_gamma/ln_gamma, none uses a 171 threshold), so the
  wrong-impl that would slip is not a shape this population writes, the reference is executed-correct,
  and no run gets it wrong => GOOD-TO-HAVE hardening (Tests 2 under Approve, colyseus really-uncovered=2-
  not-manufactured-3), NOT a valid-and-skipped RC driver. Distinguish from a live FP: check the
  PASSER'S branch (Orion_Nova_1 uses log_gamma+is_finite fallback = correct), because a blocker needs
  a wrong solution CURRENTLY passing. COUNT_LOC.PY IS A SCREEN THAT CAN CONTRADICT THE MANAGER: its
  ">= 3 implementation files" warning fought both the authoritative criteria panel (median of
  successful runs >= 2 files, this task 3) AND manager pt7 which explicitly told the author to STOP
  padding to a second file; the honest one-feature-file (superellipse.rs + lib.rs wiring) is correct,
  the screen is over-strict, do not let it reverse a manager's scope directive. FP PASSED_WITH_WARNINGS
  re-derived: judge-c's start_angle=1e9-rad/1e-10-accuracy probe fails the reference identically
  (9.999999976 vs 9.999999944) = shared f64-precision limit (ulp ~1.9e-7 at 1e9 rad), beyond-prompt,
  pinning it would be over-specification (SHARED_SPEC_GAP, not scored, consistent with v5). Terminal
  posture: the author cleanly closed all v5 asks + all 9 manager points; the lone remaining item is
  good-to-have, so a 6th RC would be the second-RC-on-a-nit failure mode - Approve with the honest
  Tests-2 note.

- 2026-07-31 (phaser Add-an-advanced-playback v2, RC->APPROVE 2/2/3): R4b "FIND THE REAL GATE FIRST"
  saved a false lint blocker. phaser's `.github/workflows/` is ONLY `lock-comments.yml` - NO CI runs
  lint/tests/tsc, so eslint is not a merge gate (unlike the dash flake8 case that reverted callback-
  archive); check what CI actually runs before treating a lint result as R4b-blocking. The real
  phaser style rule is `eslint-plugin-es5` (src must be ES5), checked cheaply by grepping the added
  src for const/let/arrow/template-literal (974 added lines were pure ES5; the only backticks were
  inside JSDoc) - no eslint run needed. eslint-version trap worth remembering: `^10.2.0` installs
  10.8.0 which is FLAT-CONFIG-ONLY and errors ERR_IMPORT_ATTRIBUTE loading a legacy `.eslintrc.json`;
  phaser's own `npm run lint` is broken against its pinned eslint (a repo bug, not the submission's).
  For a faithful gate install the LOCKED version (package-lock), not `^`-latest. Revision method
  (excelize): diffed `git show HEAD:solution.patch` first; the author added 4 files (3 typedefs +
  types/phaser.d.ts) and reworked the description to STATE all three v1 blockers. Verified each fix
  is now TEST-ENFORCED not just present: chain-overwrite -> `config.hasOwnProperty()` gate + child-
  preservation tests; reverse-silence -> new `dispatchReverseUpdate` fires TWEEN_UPDATE/onUpdate on
  live reverse while `positionAt`/setProgress stays silent + two tests; TS surface -> a `tscheck`
  fixture compiling usage.ts against the shipped phaser.d.ts WITH `@ts-expect-error` negative cases
  (mistyped values rejected), which the passing runs actually run. junit count trap: the vitest
  junit reporter DOUBLES (160 = 2x the 80 real `it(`s); reconcile against the FP's "80 passed".
  Codex-spoon FP chase both ways: reference fires onUpdate but NOT onRepeat/onYoyo during reversed
  live playback; FP panel ruled it unspecified (prompt contracts value mirroring + update
  notification, not the cycle callbacks) so Illustrations-note-not-defect; the NumberTweenBuilder
  dissent is out-of-scope (SPEC_GAP_REFERENCE_ALSO_FAILS, prompt scopes to Tween/TweenChain builders).
  Description 2 CAUGHT WHAT AUTO-REVIEW BAND-3 MISSED (the "more attention to detail" ask): the rework
  REGRESSED a v1 direct opening into a "Tweens only play forwards... Please add" current-lacks
  motivation preamble (P4 anti-pattern the description bot also flagged) + restated return/getter
  details (conciseness 2x high) = slightly verbose = 2, not a clarity defect. Tests 2 not RC: the 4
  coverage items across Test-Fairness(3, "Not Blockers") + auto-review(3) are all breadth on IMPLIED
  (reserved config keys not tweened - a basic Phaser GetProps convention, nowhere stated), WORKING-
  but-untested (no-arg setReversed; the d.ts already declares value?:boolean), or UNSTATED-parallel
  (chain mid-play rate; mid-play reverse inside repeat/yoyo) edges, reference correct on all - none is
  the msw stated-DIMENSION class, so approve-note not second-RC-on-a-nit. Criteria panel this round
  was >=2 files / >=20 msgs / >=200 LOC (looser than the 40/250 carried in memory - READ THE PANEL
  per submission; task 15/138/1012 cleared). repo-fit gate PASS: maintainer "won't build in v3 myself
  but welcome community PRs" on the NARROW Timeline-seek slice (#3362) = scoped deferral, fit clear.
  Forge is back via a 3-account pool (ZeyadNasef the new profile); standardLinux32gb has Node, so JS
  lint/tsc run directly without Docker - but here the runs already proved the tscheck, so no forge
  decision was needed (rule 6).

- 2026-07-31 (jsdom CSS-custom-property v4, final Request Changes 2/1/1 after two severity
  reversals): the owner's broad-view check correctly downgraded universal-`em` false cycles,
  non-ASCII `var()` boundaries, and quoted registration initial values to nice-to-have edges:
  the suite covers their main halves, the only genuine passer handles them, and their impact is
  narrow. The final hostile pass then found TWO different core blockers the green 88/88 suite
  and auto-review both missed. First, ordinary-property defaulting runs before substitution
  only, so `display: var(--missing, inherit)` returns literal `inherit` instead of the parent's
  display; this repeats the multi-round "compute as if literal" class on the CSS-wide-keyword
  branch. Second, pending margin/padding substitution only splits one to four whitespace tokens
  and never calls the shorthand parser, so `--m:red; margin:var(--m)` leaks `red` into computed
  margin longhands instead of defaulting; the existing invalid-longhand test uses the normal
  setter path, and the unresolvable-shorthand test covers missing substitution, so neither is
  indirect coverage. The genuine passer substitutes before keyword defaulting and parses the
  whole shorthand, proving fair tests keep solvability. Standing rule: severity pushback is a
  reason to separate exotic edges from core paths, not a reason to defend or abandon a verdict.
  Re-run the bug hunt after reclassification. A new core finding can coexist with correctly
  downgraded nice-to-haves. Author-facing structure follows the owner request: critical items
  first with actions, nice-to-haves separate, each point carrying P/T/S rule IDs.

- 2026-07-31 (kurbo Add-the-superellipse v5, Request Changes 3/1/1): severity
  follows discriminating coverage and traced numerical branches, not the
  auto-review score. The sole passer snaps valid few-ULP sweeps to an axis; the
  direct oracle uses `5e-13`, outside its roughly `1.1e-14` snap band, while the
  smaller-angle test derives both endpoints from the candidate and accepts zero
  chord plus zero length within its slack. The false-positive probe confirms
  that the candidate fails three focused cases while the reference passes all
  nine, and its waiver misapplies a helper documented only for inscribed lower
  bounds. A second independent miss sits in the golden: kurbo's fitter compares
  squared coordinates and squared tolerance, so at radius `1e-200` and
  tolerance `1e-212` both underflow to zero and it accepts each circular
  quadrant as a chord whose deviation is eleven orders too large. Extreme-scale
  length tests do not cover extreme-scale path tolerance. Literal few-ULP
  geometry and scale-safe fitting are therefore T3/T4 and S1 blockers even
  against a green automated stack.

- 2026-07-30 (thermo Add-a-flowsheet-layer, Request Changes 2/1/1): a false-positive
  probe that fails both the passer and the reference is not harmless when it directly
  contradicts the description. Here both design-spec solvers used a unit absolute floor
  for targets below one despite a relative-tolerance contract; shared failure removed the
  passer discriminator but proved an S1 golden defect and a T3 verifier gap. A prior
  review's scope fix also stopped one layer too early: changing `split_phases()` to claim
  conservation only for single-liquid flashes did not restrict the task's public
  `FlashDrum`, while the repo's `FlashVLN` supports multiple liquid phases and the golden
  still discarded every liquid after `liquid0`. Scope qualifications must reach the
  user-visible task/API boundary, not only an implementation helper's docstring. Finally,
  a boundary test must distinguish the claimed class: `max_iter=0` does not exercise
  positive cap exhaustion, and an exact relative assertion on a target above one does not
  catch an absolute-floor shortcut below one.

- 2026-07-28 (kurbo Add-the-superellipse, MY APPROVE 2/2/3 was REVERTED by the manager - the entry
  below is SUPERSEDED; this is the post-mortem). The manager was CORRECT on every point; I confirmed
  the hard ones by cheap arithmetic/grep AFTER the fact (all of which I could have done DURING). Two
  real S1 reference bugs I shipped as Solution 3: (1) PERIMETER OVERSHOOTS THE CONVEX CEILING at
  extreme n - reference returns ~14.23 at n=4096/acc=1e-6 vs true 13.998, exceeding 4(a+b)=14.0 which
  a convex shape's perimeter mathematically cannot; cause = it fits the outline at tolerance=accuracy
  and `path_segments(acc).perimeter(acc)`, but fit-DEVIATION does NOT bound arc-LENGTH error at
  singular curvature. I EXPLICITLY SET UP A PROBE FOR THIS EXACT QUESTION, abandoned it when the forge
  got flaky, and SUBSTITUTED "accurate by design, like every kurbo shape" - my O(delta) length-error
  reasoning is FALSE near corners. I even probed n=4 (too small to show it) not n=4096. Cardinal
  rule-2/rule-3 failure: I wrote "the reference itself is accurate" as an unverified assumption and
  shipped it. (2) AREA STILL RETURNS 0.0 for n in [0.012, 0.014]: the Lanczos intermediate t^(x+0.5)
  overflows f64 at arg~143 (10^309.9), NOT the true gamma point 171.6; the guard checks `1+2/n<171`
  so args 144-168 take the DIRECT path and overflow -> g2=Inf -> area=0. I READ the guard + its
  "overflows above 171.6" comment and TRUSTED it without the one-line check (149.5^142.5 > f64 max);
  the tiny-exponent test only covers n=0.01/0.05/0.1 and misses the band, so "tiny-exponent tested"
  fooled me. The manager's ORIGINAL NaN bug was never fixed, only re-thresholded. Test bounds (Tests
  should have been 1): I caught the LOOSE direction (assert wider than requested) but MISSED (a) the
  UNFAIR/FN direction - n=3 requests perimeter(1e-3) but asserts within 1e-4, so a solution honoring
  the requested accuracy FAILS; (b) the FP hole above n=8 - only a floor + a 1.05*rectangle cap, so
  returning the RECTANGLE perimeter passes; I mislabeled the inscribed floors as "collapse enforced"
  without checking the toothless upper side. R4b HALF-DONE: I ran clippy (clean) but kurbo CI ALSO
  runs `cargo fmt --all --check` which FAILS in 3 places -> CI red; R4b is lint AND format, and Rust =
  clippy + rustfmt, always both. Hygiene I read past: the signed_pow comment claims FloatFuncs "does
  not include signum" but common.rs:40 DECLARES signum (false comment, S4); gamma+ln_gamma DUPLICATE
  the 9 Lanczos constants (S3); the golden's SECOND file is just gamma dropped into common.rs while
  the passer did the whole feature in one file = the Karim "agent shorter than golden => padding"
  signal I waved through as "2 files clears the bar". META ROOT CAUSE: I ANCHORED on the green stack
  (FP genuine, auto-review 2/3/3, clippy clean) for the ACCURACY questions and let it replace
  independent stress-testing at EXTREME parameters. The FP judges probed high-n COLLAPSE (lower
  direction) and found none; I read that as "accurate at high n" - but the bug is the OVERSHOOT
  (upper direction) no check tested. On a MANAGER-REVERTED task the standing rule is the manager's
  FN-signal outranks the green stack AND you STRESS THE EXTREMES (n->0 and n->inf, both directions of
  every bound) BY EXECUTION - a reference "accurate by design" claim on a numerically-singular feature
  is worthless without probing the singular limit. If a probe is set up, RUN IT; forge-flaky is a
  reason to retry or use a local Rust build, never to substitute reasoning. Verdict should have been
  RC ~1/1/3->1 (S1 x2 math bugs + fmt-CI + false comment/dup-consts; T1 unfair+toothless bounds).

- 2026-07-28 (kurbo Add-the-superellipse v2, manager-reverted-after-auto-approve -> APPROVE 2/2/3):
  the discipline on a manager revert is FIXED-AND-ENFORCED, not fixed. The revert named a reference
  bug hidden by loose tests (n=10 quarter arc misses its axis endpoint by 5.72e-4 at tol 1e-6). I
  verified BOTH halves: the reference now snaps exact axis angles in `eval` (axis_sin_cos -> (1,0)
  at pi/2 so signed_pow(0, 2/n)=0, killing the (6.12e-17)^0.2~=5.7e-4 drift), AND the suite now has a
  discriminating catcher `quarter_arc_axis_endpoint_within_tolerance_high_exponents` asserting
  err<=1e-6 at n=10 (read the exact assertion, not the test name) - a non-snapping solution fails it.
  Same for the NaN-area bug: `area()` switches to ln_gamma once 1+2/n>=171 (n=0.01 -> arg 201 stays
  finite) AND `area_finite_at_tiny_exponents` pins n=0.01. PARTIAL-ADDRESS is the nuance: the manager
  listed THREE loose areas (high-exp, partial arcs, cusps); the author tightened only high-exp, leaving
  arc arclen at rel 1e-4 while requesting perimeter(1e-9) and cusp-reach at <=1e-2. Held it a Tests-2
  minor NOT a re-block: the reference is accurate BY DESIGN (path_segments(acc).perimeter(acc) tracks
  the tolerance like every kurbo shape, corroborated by FP arc-accuracy probes), collapse is enforced
  by inscribed lower bounds, outline geometry pinned to 2*tol down to 1e-5, so a slipping solution is
  coarse-but-not-wrong = user's non-catastrophic bar. Signal hierarchy on a revert: the manager's CORE
  FN-signal (hidden bug) was resolved; a residual that hides NO bug is a mention-for-alignment, not a
  re-block. Precision tell that separates "conservative test" from "masked limitation": the reference
  value 3.077086233544460 is carried to 16 digits, so the 1e-4 assertion width is DELIBERATE, not
  value-limited - a masked-limitation reading would need the reference to actually miss 1e-9, which
  its fit-and-measure design does not. R4b lint on Rust: kurbo CI runs `cargo clippy -- -D warnings`
  across std/no_std-libm/wasm (a real merge gate test.sh skips); ran it on the forge (base clean +
  patched clean under --features std AND --no-default-features --features libm), superellipse + the two
  common.rs gamma additions add ZERO warnings; the math patterns clippy flags (unreadable_literal,
  many_single_char_names, excessive_precision) are already on kurbo's crate allow-list, so read-level
  confidence was high but I ran it anyway on a manager-reverted approve. Forge Rust one-time rustup
  install was cached (~12s), base clippy warmed the target dir so the patched re-check was 1.24s -
  fast-but-real (the "Checking kurbo ... Finished" + rc=0 under -D warnings is the proof it compiled
  superellipse.rs, not a stale cache). New repo-fit gate PASS reused: issue #551 (nicoburns, a
  linebender contributor) REQUESTS exactly SuperEllipse/SuperEllipticalArc = strong alignment, no
  upstream impl, not a duplicate. FP PASSED_WITH_WARNINGS: judge-c multi-turn (~8-turn, |sweep|~51rad)
  negative-sweep collapse is CANDIDATE-only + build-flaky + an unrequested edge (prompt frames "one
  swept segment", hidden tests cap +/-2pi); reference fits every quadrant across the range = no
  reference defect, overruled correctly. Description over-prescriptiveness (common::gamma + perimeter-
  method mandates) FIXED = behavior-level now; residual opening typo + run-on + verbose quadrature
  advice = Description 2 (P4), don't RC on verbosity (Karim). Auto-review 2/3/3 was close but I held
  Tests 2 not 3 (the arc/cusp looseness it waved through) - more attention than the auto-reviewer is
  the job. Writing per owner: cite the platform-doc ID per point (P4/T3), NO "N blocking M nice-to-have"
  summary line, approve reasons illustrate the defect with zero recommendations, quoted-description
  text ("Add a...") is not a recommendation. Efficiency: read the 129KB test.patch via a structured map
  subagent then verified the load-bearing assertions myself; only forge work was the clippy gate (the
  callback-revert lesson) - the reference correctness, tolerance facts, and endpoint/area enforcement
  were all reading-provable.

- 2026-07-28 (temporalio/temporal Persisted-cluster-member-exclusions v2, RC->APPROVE 3/2/3; re-review
  where fixing the blockers EXPOSED a new harness bug the fresh runs caught): all three v1 findings
  closed and each verified by the new MECHANISM, not the green suite. Finding 1 (unfair pagination-cycle
  test) closed via the manager's DESCRIPTION-side option: the description now states "a pagination
  sequence that repeats any earlier page token, including a multi-token cycle... must terminate without
  partial publication," which makes the seen-token requirement discoverable, and the run evidence proves
  the fix landed (cycle test 9/9-fail -> 2-fail). Findings 2/3 closed with load-bearing tests (reinstate
  not-a-uuid -> InvalidArgument; multi-page returns 2 hosts across 2 pages and asserts both excluded,
  killing a reset-per-page accumulator). The author also ADDED a clause+test together (PassiveConvergence:
  non-serving processes converge within the periodic interval) - re-audited bidirectionally and fair
  (enforces the already-implied "every resolver" cluster-wide convergence; two observers, 8s explicit vs
  20s periodic, public API, no mechanism dictated; not scope creep). THE RE-REVIEW CATCH: "re-run the
  full standard, the author may break something else" paid off - the reworked scripted store
  (scriptedExclusionListD31C7E) now panics "close of closed channel" when a solution reloads a scenario
  (signalProgress closes activeProgress, but pendingProgress is created once per setScenario and a fresh
  token="" load re-assigns activeProgress to the already-closed channel -> double close). Real T2
  determinism defect, eval marked tests_deterministic:false. BUT it only crashes solutions that reload
  eagerly (Orion_2/4, whose coupling-of-ordinary-refresh-to-exclusion-load ALSO fails
  ReadFailureDoesNotBlockDraining + StopCancelsInitialLoad), never the reference or the 2 passers, and
  changed no outcome -> APPROVE with Tests 2, NOT a second RC (owner's verified-true + no-value-impact +
  author-cleanly-closed-real-blockers = note-under-approve rule; a panicking test looks RC-worthy but
  crashing only already-buggy solutions with zero grade impact makes it a robustness note). Signal
  hierarchy applied: verifier-audit was STALE (07-26, did not re-run this round) so IGNORED per owner
  ("if not updated it didn't run"); the mandatory FP re-ran and PASSED CLEAN (2 genuine Orion passers, no
  dissent, up from PASSED_WITH_WARNINGS); the 4 fresh Test-Fairness suggestions all adjudicated skippable
  (concurrent-idempotency + mutation-failure-publication = unspecified; real-backend execution =
  infeasible in the --network=none sandbox and schema structure already checked; page_size bounds = FP
  already ruled negative-size a reasonable underspecified default). Second harness quirk noted not scored:
  Nova_4's Cassandra ScanCAS-no-op fake is agent-fault primary (its ScanCAS usage is unsafe) and Orion_3
  passes the Cassandra test, so the fake does not fail faithful solutions = coverage-depth limitation, not
  a fairness defect. Repo-fit PASS (#11108 hedged ringpop-vs-persistence architecture objection = PR-time
  design note, not a block; base-behind-upstream churn is adjacent, feature not landed). Efficiency per
  owner: no forge/build (solution unchanged from the Solution-3 round, FP-genuine, all findings verifiable
  by reading + the fresh runs); diffed HEAD:artifacts first (solution byte-identical), re-tallied the fresh
  07-28 batch, adjudicated by reading. Author-facing kept concise (204 words) issue->why-not-blocking with
  no how-to under the approve; Illustrations carry the mechanism-level evidence.

- 2026-07-26 (terragrunt Add-exclude_dependents, from-scratch Request Changes 3/2/3; VCA-filtering by
  PASSER-CODE reachability, and a terse-golden LOC call): the RC rests on ONE cell where the VCA + the
  Test-Fairness lightbulb + the auto-review all AGREE and it maps to a stated clause - write-back of an
  explicit `exclude_dependents = false`. The other 2 VCA gaps (find-text cascade, list-tree cascade)
  are CONTRIVED, proven by reading the 2 passers' ACTUAL code (the cbor-v2 reachability gate, not the
  audit's word): both passers filter find in discoveredToFound with `if unit.Excluded(){continue}` and
  NO format branch, and keep list's base `if opts.Format != FormatDot {continue}` which drops excluded
  units for text/tree/long alike (tree covered by the catch-all, not tree-specific code) - the two
  passers' seams are BYTE-IDENTICAL, the strongest reachability evidence. The write-back cell is real
  because the write-back is BESPOKE PER-ATTRIBUTE (`if ptr!=nil {SetAttributeValue}` per attr), so a
  `!=nil && *ptr` truthiness emit is a normal Go slip that drops false, and the only WriteTo test
  round-trips `true` only (the other `false` fixtures drive inheritance/cascade, not serialization) -
  stated (R4 appear-like-peers-carrying-the-value), reference-correct (presence check mirrors
  exclude_dependencies), reachable, zero coverage => valid-and-skipped fairness returns per Karim =>
  Tests 2 (suite exhaustive, one cell) + RC decision (go-pretty split). Both passers avoided the slip
  (mirror the peer), so NO live FP, but a valid uncovered stated cell returns regardless. Same-origin
  dual-direction (fairness lightbulb 2) = FAIR BYPASS: structurally needs the origin and unit to be
  mutual dependencies (a CYCLE the DAG rejects) AND the description never pins which reason wins at
  equal origin+distance (traverse.go BFS is deterministic-by-walk-order) - tell the author to SKIP it
  (go-pretty name-the-do-not-add). FP judge-c destroy-spelling dissent (`plan --destroy` double-dash,
  `-destroy=true` inline) overruled correctly = SPEC_GAP_REFERENCE_ALSO_FAILS, description names only
  single-dash apply -destroy/plan -destroy (codex chase-both-ways: reference fails identically =
  unspecified). LOC method on a TERSE golden: count_loc lenient 323 INCLUDES 26 docs(.mdx)+schema.json
  lines and does NOT strip Go imports/braces; strict production ~200-230, UNDER the 250 golden-floor,
  BUT the platform criteria is "successful-run MEDIAN >=250" = 661 here (passers 611-711 raw), which
  CLEARS - so disclose BOTH numbers, tag Lines-of-code, flag for the manager's size call, do NOT
  hard-block a criteria-passing genuinely-hard feature (2/10) that just factors well against existing
  infra (Leonard's "not trivial padded" spirit); the golden-floor-vs-successful-median tension is the
  manager's judgment. Schema-sync (R10) is guarded by a BASE test the solution legitimately edits
  (report_test.go ExpectedSchema gains the 2 new reasons alongside schema.json) - a _test.go in the
  solution patch is NOT auto-suspect when it keeps a base assertion in sync. Efficiency (owner steer):
  NO forge/probe - the RC is a coverage gap provable by reading, passer-code-read settled reachability,
  and the deterministic-BFS read settled the cycle case; R4b golangci-lint DEFERRED to the pre-approval
  round (RC-on-tests, temporal precedent), noted for the owner. repo-fit new check PASS reused: gh code
  search `exclude_dependents`=0 + `git log -S` over exclude.go empty = feature not landed (base==HEAD
  24 Jul); closed PR #3821 was rename-only with a nil-deref typo, not cribbable; issue #3823 open with
  maintainer inviting a community PR = alignment. Cited T3 for the gap.

- 2026-07-26 (temporalio/temporal Persisted-cluster-member-exclusions, manager-reverted-after-auto-approve,
  from-scratch Request Changes 3/1/3): the headline finding is an UNFAIR TEST that NO automated completeness
  check can catch, because they are all FP-direction ("can a broken solution pass") while an unfair test is
  FN-direction ("does a FAITHFUL solution fail"). FP(clean, inspects only the actual passer) + Verifier-Audit
  (INCOMPLETE, constructs broken solutions) + Test-Fairness ("all hidden tests are fair") ALL missed the
  pagination-cycle test; only the manager + a run-level read caught it. So on any manager-reverted task, the
  manager's FN-direction fairness signal OUTRANKS a green FP/audit/fairness stack - anchor to it, but VERIFY
  independently. Verified the unfairness at FOUR levels (the standard for calling a test unfair): (1) the
  description is silent on the required mechanism (says only "cannot make forward progress", never "detect a
  repeated page token with a seen-set"); (2) the scripted store returns cycle-a/cycle-b/cycle-a then BLOCKS on
  <-ctx.Done() on the repeat, so only a full seen-token-set terminates - a previous-token compare or a bounded
  loop HANGS; (3) the repo's OWN idiom contradicts it: monitor.go:326-350 is a bounded for{} stopping at
  len(set)>=500 with zero token tracking, so a repo-faithful solver hangs; (4) the reference itself is forced
  into the exact undiscoverable approach (seenPageTokens := make(map[string]struct{}), abort-on-repeat), which
  IS the proof the test dictates one mechanism. Run evidence is the smoking gun: 9/9 failing runs die on this
  ONE test, 3 at 57/58 (everything else correct) - the atom-media "agents tripped at this exact part in every
  run" signature, and fixing it lifts ~3 runs to ~4/10=40% at the cap, so the 1/10 "difficulty" is largely an
  artifact of the unfair test, not genuine hardness. Fix keeps the requirement without dictating the mechanism:
  store returns an ERROR/terminal page on the repeat so any terminating impl passes (test-side, preferred over
  description-edit). VCA-filtering under the owner's "audit is over-strict, FP is mandatory" steer: of 4 audit
  gaps, Gap 3 (reinstate-malformed) is REAL (corroborated FOUR ways: manager + audit + Test-Fairness suggestion +
  auto-review's own Tests-2; stated R3; reference validates it; zero covering test) and Gap 1 (successful
  multi-page never tested, so a reset-per-page accumulator publishing only the final page passes; stated
  R12/R14; grep-confirmed absent) is REAL; Gap 2 (WorkerService resolver untested) is OVER-STRICT because the
  reference filters through a GENERIC IsExcluded(hostID) so "skip one resolver" is not a realistic slip (read
  the filter design before adopting an audit's broken-impl - realistic-slip check, colyseus/kube-ovn); Gap 4
  (schema host_id-in-PK) folded into coverage suggestions. FP judge-c dissent (Stop doesn't cancel a
  publish-blocked refresh) overruled correctly = reference-also-fails unspecified edge (codex chase-both-ways).
  New repo-fit check: PASS but flags a HEDGED maintainer objection to the persistence-vs-ringpop architecture on
  the open enhancement issue #11108 - not a block (hedged "seems like", open, no won't-have, no alternative
  published), an Other-notes design point per the socid repo-fit-blocks-only-on-duplicate/strict-ruling/
  contradiction rule. Efficiency wins the owner asked for: no forge (RC rests on tests, not solution hygiene -
  deferred the golangci-lint R4b gate to the pre-approval round with a note); no count_loc (a 2500-line 4-store
  feature obviously clears 250); reproduced ONLY the needed reads (test cycle mechanics, repo monitor.go idiom,
  reference seen-set, generic filter). Author-facing kept the fragile test.patch line numbers OUT (named the
  test + mechanism + the stable repo monitor.go:326-350); Illustrations carry the line-level evidence for the
  owner. Cited T5 (undiscoverable-behavior) for the unfair test, T3 (wrong-solution-passes) for the two gaps.

- 2026-07-26 (fxamacker/cbor Register-one-Go-type v2, drafted RC 3/1/3 -> CORRECTED to APPROVE 3/2/3 on
  the owner's "are you SURE that wrong solution can occur, or is it tested indirectly?" - the trigger-
  realism check I skipped). I scored the shared-decode-after-removal gap a Tests-1 blocker off the VCA's
  "a broken solution passes" + a fairness lightbulb, WITHOUT verifying the broken solution is a shape a
  real solver writes for THIS architecture (my own colyseus rule). Checked the code: base syncTagSet is
  ONE map `t map[reflect.Type]*tagItem`, Remove is a single `delete(t.t,type)`, encode reads t[type] and
  decode (getTypeFromTagNum) SCANS t - so removal deletes the one entry both directions read, and decode-
  after-removal + Alternatives-nil follow automatically. Reference AND all 4 passers add ZERO lines to
  Remove, build NO separate decode index, decode by scanning that same t (verified per patch). The VCA's
  mutant (tombstone encode+ownership, forget a SEPARATE decoder reverse-lookup) needs an index the base
  doesn't have and nobody built = CONTRIVED. Plus the suite already tests shared decode of ADDITIONS
  (proves the shared DecMode reads the live map), so a single-map solution that passes encode-after-removal
  CANNOT fail decode-after-removal. => not a stated-and-reachable FP hole => good-to-have, Tests 2, Approve
  (mention as a non-blocking note, NO recommendation per the approve convention + owner instruction). THE
  RULE burned in: a VCA/lightbulb "wrong solution passes" is necessary but NOT sufficient for a blocker;
  before scoring Tests 1 you MUST verify the broken impl is REACHABLE given the reference+passers' actual
  data structures (grep every real impl's version of the exact seam), because the audit CONSTRUCTS a mutant
  in an architecture that may not be the one anyone writes. "Is it tested indirectly / can it occur" is the
  gate. This is spoon-v4 + colyseus in a new dress (I even cited colyseus in my own draft and still skipped
  the check). Everything else in the round stands, kept below for the method:
- 2026-07-26 (fxamacker/cbor Register-one-Go-type v2, method notes; first VCA+FP+fairness+repo-fit
  reconciliation on a re-review, with owner steer "VCA is redundantly too strict, FP is the mandatory
  one"): the four completeness signals form a HIERARCHY, don't average them. FP (mandatory, PASSED_WITH_
  WARNINGS, 2 genuine) answers "is the ACTUAL passer genuine". Test-Fairness lightbulb (Karim's return-
  rule) is the manager-binding coverage signal. VCA (optional, 9 gaps) answers "could a BROKEN solution
  pass" and is a LEAD POOL, not a verdict. The real finding is the ONE gap where VCA and the Fairness
  lightbulb AGREE AND it maps to a STATED clause: shared decode-after-removal. The other 8 VCA gaps
  targeted unspecified/closed-list behavior - and the FP adjudicator EXPLICITLY ruled the carrier-
  incomplete one (VCA Gap 3) unfair ("the rejection list is closed: empty/duplicate/inverted-range/
  reserved/already-owned; carrier-capability is not in it", and a passing agent doesn't do it, so a
  test there fails the passer). So: use FP-adjudication + Fairness-lightbulb + stated-clause to FILTER
  the VCA's over-strict list down to the real cell, and say so for the owner (I flagged 1 of 9, named
  why the other 8 are skippable). The removal gap is the msw/IMPORTRANGE both-directions class on a
  clause the author ADDED this round ("shared modes reflect additions AND removals; removal releases
  the numbers"): removal touches two maps (type->tag encode, tag->type decode), the suite tested only
  encode (marshal-after-removal) + re-registration, so decode-after-removal and post-remove Alternatives-
  nil are uncovered - re-audit every ADDED description clause bidirectionally caught it. Verify-the-fixes:
  diffed HEAD-vs-working FIRST, all v1 blockers closed and each confirmed by READING the fix code, not
  the green suite: encode bug (checkAlternativeTagNumber now derefs ptr/iface before the type lookup),
  decode bug (parseToValue validates the registered tag before the Unmarshaler dispatch, restores d.off),
  dead getTagItemFromTagNum removed, both asked tests present AND load-bearing (the 2 selectively-failing
  agent runs fail exactly on unset-carrier-encode + unmarshaler-wrong-tag). R4b Go-lint faithful base-vs-
  patched on the forge (golangci-lint v2.10.1, repo-pinned in .github/workflows/safer-golangci-lint.yml):
  base 0, patched 0 (was 18 last round) = prior blocker cleaned; the .golangci.yml delta was two
  exclusions SCOPED to the mandated-underscore test package only, legitimate not blanket-suppression -
  read the config scope before crying gaming. FP overruled dissents chased against the REFERENCE (codex
  rule): both candidate-specific (judge-b's DecTag regression is in the candidate's getTypeFromTagNum,
  which the reference never touches - the reference's DecTag guard is in the Unmarshaler-dispatch path and
  only skips VALIDATION not RESOLUTION; judge-c = the unspecified Gap 3), reference clean; "reference
  stricter than prompt" (validates carriers) is extra safety not a defect. R8 claim-check CAUGHT a wrong
  convention claim: I wrote "the variadic signature is discoverable from the repo's Add(opts,type,num)
  convention" but base Add is MANDATORY-FIRST (opts,type,num,...nestedNum) which pulls toward the FAILING
  mandatory-first shape 4 agents took; the pure-variadic AddAlternatives(opts,type,nums...) is discoverable
  from the DESCRIPTION ("several interchangeable tag numbers") not Add - always grep the actual sibling
  signature before asserting a convention. Signature ambiguity here is fair difficulty (description
  disambiguates, 4/10 solved) not a blocker, and NOT worth a description signature-pin (over-specification,
  woodpecker). Score-vs-decision (go-pretty/sbi): Tests 2 not 1 because the reference is now CORRECT on
  everything and the suite is exhaustive (62 tests), the gap is a specific removal-direction slice; RC
  decision because valid-skipped fairness returns. Solution 3 (both bugs fixed, lint clean, dead code gone,
  reference correct). Pass rate 40% sits exactly on the cap and rests on one solver (Nova 4/4, Vega 0/6) -
  disclosed for the owner. Repo-fit PASS re-verified: #508 open+motivation-only, no PR, base 4 dependabot/
  CI commits behind master (none touch tag.go/the feature) = feature not landed, pin fine. Stale-artifact
  catch: bundled ai-evaluation.md was 07-24 (my v1 round), used the fresh 07-25/26 runs+FP+VCA+repo-fit.

- 2026-07-26 (react-native Expose-component-branch v6, RC->APPROVE 3/3/3, terminal round after 5 RCs;
  owner clarified the CHECK AUTHORITY had flipped: the VERIFIER COMPLETENESS AUDIT is now DEPRECATED
  as "redundantly strict, never passes" and the FALSE-POSITIVE panel is the mandatory authority again -
  so do NOT let a VCA-only gap drive a score). All three v5 blockers closed with REAL fixes, verified
  not re-litigated (excelize): (1) the static/non-static ordering bug FIXED with the right pattern -
  partition + ONE global stable_sort = BUG (the sort overrides the partition for unequal keys, which
  is exactly what made the v5 reference wrong), partition + sort EACH SIDE INDEPENDENTLY
  (stable_sort(begin,firstNonStatic) then stable_sort(firstNonStatic,end)) = CORRECT (boundary
  survives regardless of order index); a C++ sort-composition gotcha worth keeping. (2)+(3) the two
  test gaps closed with real BODIES not renamed titles - grep-confirmed Transform::RotateZ(quarter +
  45deg) clippers and Transform::Scale(-1,1,1) mirror, 9 and 6 assertions where there were 0 (diff
  bodies, IMPORTRANGE rule). FP re-derivation: PASSED_WITH_WARNINGS, 3 genuine, the solo judge-c NaN
  dissent (RejectsNonFiniteQueryCoordinates) overruled as UNSPECIFIED-edge - the SAME call I made in
  v5 (gap 4), so FP-adjudicator and reviewer converged, which validates the v5 read; judge-b's fair
  rotated-clipper probe passes on both = independent confirmation the transformed-clipper geometry is
  correct. The one lingering item (smaller-fixed-tolerance, VCA gap 3) I did NOT score: it is flagged
  ONLY by the deprecated over-strict VCA, the reference is exact-zero-compliant, the mandatory FP
  cleared it, and NO genuine passer uses a slipping tolerance (realistic-slip check fails - colyseus/
  kube-ovn) - so it is an Illustrations owner-note, not a Tests deduction; adopting a deprecated-too-
  strict check's finding as a real minor would be the exact over-strictness the owner just removed.
  all-3s earned (terminal-approve precedent: verified closure of every prior finding across 5 rounds,
  the ordering fix is correct CODE not just a green suite) - did NOT manufacture a minor to hedge the
  history (dishka). clang-format under an approve when test.sh does NOT run it (base builds a gtest,
  not the lint) and the owner said avoid the forge: surface it as a pre-merge confirm reminder (not
  buried = not the callback mistake; not cloned = proportionate for a formatting pass on a compile-
  clean tree) rather than cloning the RN monorepo. Efficiency: no forge, spot-checks + the mandatory
  FP + the ordering-fix code read decided everything.

- 2026-07-25 (pykka Atomic-cancellation v3, Request Changes 3/1/2; NEW verifier-audit check +
  FP-vs-audit reconciliation): the platform replaced the post-rollout false-positive check with a
  pre-rollout VERIFIER-AUDIT that probes whether a broken-but-plausible solution passes the current
  suite and SHIPS a proposed remedy test patch (verifier-audit/verifier-audit.md +
  proposed-changes.diff). It is the authoritative test-completeness signal now; read it like a
  finding, not a badge. Here it demonstrated 5 high-plausibility gaps (BaseException-hook-strands-
  running [crash]; failed-cancel-of-running-wrapper-still-cascades; cascade-skips-completed-direct-
  source; rejected-cancel-leaks-cancellation-details; keyword-only-`*`-not-enforced), each with a
  broken impl + probe + evidence + a validated remedy (applies, fails-on-base, reference-passes ->
  65 tests). DECISIVE INTAKE CHECK: grep the CURRENT test.patch for the remedy test names - author
  applied NONE (still 51 funcs/60 cases, the exact audited suite), so all 5 gaps are LIVE = Tests 1
  driver. All 5 were TEST gaps not solution bugs (read the code: cancel(reason=None, *, cascade=False)
  keyword-only, `except BaseException` restoring PENDING, unconditional `source.cancel()` per distinct
  source), so the fix is additive tests only - Karim valid-and-skipped => return. FP-vs-verifier-audit
  are NOT contradictory and the review must say so for the owner (the user asked "why is FP passing
  then"): FP(PASSED_WITH_WARNINGS) asks is the ACTUAL PASSER genuine (yes; judge-c's global-cross-DAG-
  dedup dissent overruled, reference fails identically = unspecified edge, distinct from the audit's
  DIRECT-source gap), verifier-audit asks could a BROKEN solution pass (yes, 5 ways). R4b gate paid
  off again with the FAITHFUL BASE-VS-PATCHED DIFF (sbi method, mandatory): patched ruff = 23 findings
  but BASE already emits 6 CPY001 + 1 RUF100 (config artifacts under select=ALL, EXCLUDE) -> ~16
  patch-introduced (SLF001 x4 UNSUPPRESSED though author suppresses the SAME rule in _actor.py,
  PERF203 x2 on required callback-isolation loops, C901 on get, SIM102; + 7 test-file + format),
  roughly the SAME set v2 flagged = clean-the-gates ask NOT addressed = Solution 2 (gate-red on correct
  code is a note not a driver per sbi, but a PERSISTING lint ask across rounds is a real minor). mypy +
  basedpyright clean. VERIFY-THE-FIXES across rounds paid off: v2's two asks (two-distinct-pending-
  sources join test; cascade keyword-only + closure-inspection) BOTH landed (the join test is now the
  dominant agent failure 8/9; explicit _set_cancel_sources replaced closure inference), so score the
  DELTA not the whole. LOC recovered: author expanded 231 -> ~250 (count_loc 271 lenient, strict
  245-253 straddling the floor on whether 12 abstract API stubs count) = disclose-both-numbers, no
  longer the blocker (go-pretty borderline rule). Efficiency note (owner said hybrid-when-needed only,
  repo is TINY pykka not react-native which was a different task): most of this was static (read
  patch + audit + description); the ONE genuinely-can't-do-statically thing was ruff select=ALL, run
  on the forge. Dominant run failure (cascade tests, agents call private `_cancel` not public overridable
  `cancel()`) = fair difficulty on a stated per-source-attempt contract.

- 2026-07-25 (react-native Expose-component-branch v5, RC 3/1/2; first encounter with the VERIFIER
  COMPLETENESS AUDIT, the new check that REPLACED the false-positive panel): the VCA is the automated
  "does a broken-but-plausible solution pass" analysis I do by hand - it CONSTRUCTS adversarial broken
  impls and runs them against the suite, returns INCOMPLETE with demonstrated gaps, and proposes a
  test patch. Treat its verdict like an FP-panel dissent, NOT gospel: adjudicate EACH gap against the
  STATED requirements. Here 5 gaps, author bypassed all; I sided with the check on 2 and the author on
  3. Real (blocker): transformed-clipper visible-rect (R6) and mirrored/negative-scale winding (R12) -
  both stated, both reference-CORRECT (clips via computeVisualCorners+localToQuery; containsPoint uses
  the winding-independent !(hasPos && hasNeg)), both with ZERO covering test (grep-confirmed), so a
  plausible shortcut (untransformed-clip box / one-sided !hasNegativeCrossProduct) passes = wrong
  solution passes on a stated rule = the CR bar. Fair bypass: NaN/infinity (R17 non-finite is NOWHERE
  in the description = unspecified, reference guards it defensively anyway) and the Flow-contract probe
  (source-text scan, reference already declares the Spec). Lesser: smaller-fixed-tolerance (R12
  explicitly bans fixed cutoffs, suite catches 1e-5 via a 2e-6-twice-area view but not 1e-7 = real but
  low plausibility = Other-notes good-to-have). The two author-pushback fallacies to name explicitly:
  TESTED-INDEPENDENTLY != COMBINATION-COVERED (transforms tested, clipping tested, but the bug lives in
  the transformed-clipper COMBINATION the separate tests never reach) and DEFINED != ENFORCED (the
  winding rule is stated but nothing FAILS the one-winding solver). FP-vs-VCA reconciliation for the
  manager: FP PASSED (2 genuine) because it only inspects ACTUAL passing runs and no agent happened to
  write the shortcut; the VCA CONSTRUCTS the shortcut, so FP-clean + VCA-incomplete are consistent and
  the VCA is the stronger completeness signal. Author-admitted bug I could NOT pin statically (rule 2
  held): the static/non-static ordering partition-then-sort LOOKS like the sort overrides the partition
  for unequal order index, BUT the MountsStaticSiblings...IgnoringTheirOrderIndex test passes with a
  high-order-index (99) static, so the basic case works and the real failing combination is subtler -
  did NOT fabricate a mechanism, acknowledged the self-report and asked for fix+covering test (react-
  native too heavy to clone for a bug already admitted). Revision hygiene (excelize): diffed HEAD vs
  working copy FIRST - the author closed EVERY v4 ask (nested-clip test IntersectsVisibleRectsAcross...,
  isZero->exact-zero == Float{0}, Flow Spec 9-field, coordinate-clause in desc, LOC 276->343 as the
  feature grew genuine scope), so this RC is genuinely NEW (VCA gaps + admitted bug), not re-litigation
  - the excelize "second RC on a nit after a real blocker closed" failure mode does NOT apply because
  these are demonstrated FP holes, not nits. Scores: Description 3 (v4 coordinate ask now stated), Tests
  1 (two demonstrated FP holes = "missing needed tests the completeness check flagged"), Solution 2
  (acknowledged ordering bug, rest substantial+correct). Efficiency: no forge - VCA already executed the
  demonstrations, statics confirmed reference-correctness + zero-coverage, and the admitted bug needed
  no proof.

- 2026-07-24 (excelize Volatile-aware-formula v2, RC -> APPROVE 3/3/2): re-review of a REVISION, and
  the first move must be establishing that fact. I nearly re-litigated the v1 numbers against v2
  artifacts: the re-fetch silently replaced every file (solution.patch 538 -> 814 lines, calcdeps.go
  202 -> 404, ai-evaluation.md replaced by prechecks.md, the FP run swapped from Nova#7 to Orion#1,
  suite 84 -> 115 nodes) while review.md still sat at the v1 timestamp. The tell was file mtimes plus
  the single git commit; ALWAYS diff `git show HEAD:solution.patch` against the working copy before
  re-deriving anything, and never conclude "my earlier read was truncated/corrupted" when the cheaper
  explanation is that the artifact changed. Both v1 solution findings read as flat wrong against v2
  (single-cell INDIRECT now calls recordCalcCellDep; cellResolver now reads ctx.disableCalcCache fed
  from the MERGED per-call options) - because the author fixed them, not because I mis-probed.
  Re-verify a fixed finding by PROBE not by diff-reading: both came back clean (CalcDependents(A1)=
  [Sheet1!B1], CacheHits 1 -> 0). LOC: v1 205 strict was a correct block, v2 is 333 strict / 474
  count_loc, and the count is only trustworthy when the awk brace regex is the broad
  `^[{}()\[\],;]+$` - a narrower closing-brace-only pattern is what produced the v1 "~217" wobble.
  Leonard's list is the source of truth and says do not be pedantic, so publish both numbers. New
  R4b habit that paid: `go test -race` on a caching feature adding a mutex + five sync.Maps (clean),
  and walking every remaining caller of the OLD helper - auto-review's lone Low S2 (clearCalcCache
  still clears only the 3 result caches while 8 mutators call it) is factually true but the eight
  are all out of stated scope (UnmergeCell/AddTable/DeletePivotTable/copySheet/SetDefinedName...) and
  the dangerous direction (deps lost while results survive) is structurally impossible since
  discardCalcResult/clearSheetCalcCache always clear both sides. Verified-true + no-value-impact +
  out-of-scope = Solution 2 note under an Approve, NOT a second RC; a second RC on a nit after the
  author cleanly closed a real blocker is the reviewer failure mode here. Also: a judge-c style FP
  dissent can go MOOT across a revision (the v2 reference now shifts caches on structural edits, the
  exact contract judge-c demanded), so re-derive panel caveats against the CURRENT artifacts.

- 2026-07-24 (pykka Atomic-cancellation v2, REQUEST CHANGES 3/1/1): when a
  requirement says every distinct direct source is affected, single-source cases and a
  duplicated-source `join(source, source)` do not prove fan-out. The submitted suite also had a
  two-source case, but made the first source already running and asserted only the final pending
  source cancelled. Replacing the reference's full join source list with only its final source
  still passed all 48 tests, turning the gap into a demonstrated core false-negative. Use the
  smallest adversarial mutation that matches the missing quantifier instead of reproducing every
  obvious behavior. Resubmission artifacts can disagree internally: the current raw runs were
  48 tests and 4/10 passes while the old AI evaluation still narrated 18 tests and 2/10, so prefer
  raw JUnit/current prechecks and explicitly mark stale summaries unused. The callback-revert R4b
  sweep found separate static-check regressions: pristine Ruff check/format, basedpyright, and ty
  were clean while the patch introduced failures in both production and tests. Treat formatting
  and contained cleanup as minor rather than using them to force Solution 1; this round's core
  behavior works, so the keyword-only mismatch and fragile closure inference support Solution 2.
  The manager's anti-nitpick LoC caveat also matters at the boundary: subtracting only the explicit
  7 imports, 7 punctuation-only lines, and 5 standalone control-only lines gives 231, while public
  exports, type aliases, and abstract API declarations remain counted. Give the author the number
  and threshold, not an exclusion essay. Closure-cell inspection is still not explicit dependency
  wiring: a hook that merely captures an unrelated Future becomes an accidental cascade target.
  Trace wrapper provenance and wire sources at construction sites, including wrappers outside the
  main future module.

- 2026-07-24 (kube-ovn Drain-live-IPPool-changes v2, APPROVE 3/2/2): a restart
  regression can prove restored state without proving that the controller will ever continue the
  lifecycle. The new test made a deletion-marked pool unavailable, then called the delete handler
  directly; it never inspected the delete item `InitIPAM` must enqueue. Trace both state and
  routing whenever the requirement says work "begins" after startup. This stayed Tests 2 rather
  than a blocker because the reference and the only genuine passer both enqueue correctly and no
  current pass exploits the gap. Also audit the scope of a concurrency fix, not only whether it
  closes the race: retaining both the subnet lock and IPAM's global write lock across OVN and
  Kubernetes calls fixes the prepare/commit window but can stall allocator work on unrelated
  subnets, a Solution-2 availability concern. R4b remained clean on the changed surface:
  repository-pinned golangci-lint reported zero issues for both affected package trees,
  modernize was clean, and all eight changed Go files were gofmt-clean.

- 2026-07-22 (skvm Primitive-substitution, from-scratch APPROVE 3/3/2; LLM-driven compiler-pass feature,
  no agent-runs dir): R4b on a Bun/TypeScript repo = the lint gate is `bun run typecheck` (tsc --noEmit),
  NOT eslint/biome - skvm ships neither (grep package.json scripts + config files BEFORE assuming a
  gate; only tsconfig.json present). Decisive: `bun test` passing does NOT prove tsc-clean (Bun
  transpiles without full type-checking), so running tsc separately IS the callback-revert class -
  ran it on the patched tree (rc 0) with a pristine-base control (rc 0) = the type gate a maintainer's
  CI runs stays green. Forge needed bun installed first (`curl -fsSL https://bun.sh/install | bash`,
  the generic codespace lacks it). tsconfig had noUnusedLocals:false, so tsc flags NEITHER unused
  locals NOR unused exports - the dead export (`selectAlternative` in viability.ts, 0 callers across
  src+test+patches; runner uses assessAlternatives+inline reduce) was caught ONLY by the manual
  dead-code read (py-pglite is_locked class). Hardened CR bar held on the one real reference gap: the
  elimination helper is INCOMPLETE for a purpose lacking both a code AND a text ability (eliminate.ts
  computes missing langs, and once matching code blocks exist it `return`s those removals and stops
  before the sectionBody/prose branch, so the prose survives) - flagged by ai-eval 3x AND a judge-a FP
  probe ("text-ability elimination preserving supported code: candidate pass, REFERENCE FAIL"). Still
  a Solution-2 MENTION not a CR: a strict test would fail the reference itself (reference-shared blind
  spot, not a wrong-solution-passes-what-reference-gets-right hole), untested + narrow, zero rollouts
  trip it - the excelize 3-gaps precedent exactly. FP both-ways re-derivation paid: BOTH judge-c solo
  dissents (Orion#1 purpose-id-vs-description heading collision; Orion#3 YAML-`#`-comment-as-heading +
  python3 fence) were candidate-specific heuristics on contrived prompt-ungrounded inputs, and the
  REFERENCE is the more robust side (resolves description-before-id; has a whole-section fallback) - but
  reading ALL the FP prose (judge-a's aside, not just the adjudicator verdict) is what surfaced the real
  mixed-case gap. Fairness lightbulb (text-substitution untested) SKIPPABLE = covered transitively:
  substitution is one generic section-rewrite path with no code-vs-text branch, exercised thoroughly by
  the code-ability substitution tests - verified the shared-path claim in code before calling it
  covered-elsewhere. AGENT-RUNS ARRIVED AFTER the first-pass review (dir absent at review time, fetched
  after) and the owner asked to re-vet - always re-check the dir before finalizing a no-runs verdict.
  Vetting the 13 corroborated everything: all baselines 16/16 green, ZERO gaming (no hidden-hash/token/
  fixture-string in any patch), no hidden-test-file edits, base-test edits were benign pass-count bumps
  (`["1","2","3"]`->`["1","2","3","4"]`) the golden doesn't make. Golden BASE-GREEN proven WITHOUT a
  rerun (rule 6): 4 runs (Nova_1/4/6/7) add the pass but DON'T touch registry.test.ts and still show
  16/16 - exactly the golden's shape, so an unmodified registry.test.ts passes with the appended pass #4
  (its exact-list test resolves tokens ["1","2","3"]=passes 1-3, unaffected by #4). Dominant failure
  (test "rewrites only the targeted content", 10/13) adjudicated SUBTLE-BUT-FAIR not ambiguity via the
  woodpecker evidence-in-hand test: the description says an edit whose original TEXT is present is
  applied and only an INAPPLICABLE one is skipped, so the agents' lexical-heading-match gate is an
  ADDED assumption (the golden trusts the planner's supplied original, applying it even when the section
  doesn't resolve from purpose metadata). Forge flakiness (cp connection-drops, /tmp dir vanishing) is
  not worth fighting when the runs already decide base/fail-on-base/pass-on-solution. repo-fit.md new
  gate cross-checked first-hand: base pin 1-behind main, that commit
  = PR #101 (requiresTcp, orthogonal, touches the 2 shared files incidentally), feature absent upstream
  => benign pin; the pin PREDATES #101 so the pass reads ctx.tcp unconditionally (clean at base, only a
  forward-rebase detail). No agent-runs dir: the run tally/failure-patterns/passing-run-ids lived in
  ai-evaluation.md (subagent-extracted) - when there's no agent-runs, ai-eval + FP ARE the run evidence.
  Style (owner asks, applied): approve => author-facing issue-only + "not blocking", NO recommendations,
  no local-tooling names author-facing (typecheck/forge live in Illustrations as the repo's OFFICIAL CI
  gate), bare tag with no trailing text, motivational/summary opener in Illustrations for the manager;
  reworded a draft "so it slips through" to avoid wrong-solution-passes framing under an approve. LOC
  438 lenient over 250 = not a floor case, no hand-recount (only recount when NEAR the floor).

- 2026-07-22 (ezno Add-checking-for-switch, from-scratch APPROVE 2/2/3; a large HARD Rust
  compiler-checker feature where the R4b lint gate was the whole risk and resolved to a toolchain
  confound). PROCESS MISS (owner caught): I ran the agent-runs check ONCE at intake, saw the dir
  absent, and carried "no agent-runs" all the way to the shipped review - but the platform
  POPULATED agent-runs AFTER intake (dir mtime later than my review), so the runs WERE there by
  finalization. RE-CHECK agent-runs right before writing the verdict, never trust an
  early-intake absence; the run tally is the realistic-slip evidence for every fairness cell and
  the only place a hidden second-passer or a gap-exploiting pass shows up. When the runs did land
  they CONFIRMED the verdict (no hidden blocker): 1/10 pass (Nova_Nova_9, genuine per FP, ~701
  added lines across 13 files = COMPARABLE to the golden's ~703 so tests-not-weak/golden-not-padded,
  Karim LOC signal), all baselines green, dominant failure no_default_preserves_prior_variable_value
  7/10 (the explicitly-stated certainty cell) and the near-passer (33/34) blocked ONLY on it =
  fair difficulty not ambiguity. The decisive realistic-slip check the runs enabled: NO run fails
  either scope test or the return-stops-the-fall test, and BOTH the passer and near-passer
  `hoist_statements` clause declarations into ONE shared switch scope exactly like the reference,
  so per-clause scoping (the impl that would slip the cross-clause-visibility gap) is used by zero
  runs and the two lightbulbs are empirically good-to-have, not holes. Until the runs arrived,
  fail-on-base rested on the base rejecting switch as `thing: "Switch statement"` (diff removes it)
  + reference 34/34+61/61. R4b lint on a RUST repo: the gate is `cargo fmt --all --check` +
  `cargo clippy` (grep .github/workflows/rust.yml; test.sh ran nextest ONLY = the callback blind
  spot). Both FAILED on the patched tree and BOTH were pure toolchain/base confounds, proven by
  re-running on PRISTINE BASE: fmt flagged one untouched base parser file identically (rc=1, same
  Diff-in block base and patched = a rustfmt-version artifact, forge rust 1.96 vs ezno's ~Oct-2025
  code), and clippy died on a base-dependency compile error (`u32->u32` cast in ezno-parser,
  identical rc=101/37-warnings base and patched) BEFORE ever reaching the checker. To force clippy
  PAST a deny-erroring dependency into the target crate: `RUSTFLAGS="--cap-lints=warn" cargo clippy
  -p <crate>` (caps the dep's deny to warn so it compiles, then grep the TARGET's own files) - the
  new switch.rs came back 0 warnings = clippy-clean; the 4 findings in modified files were the
  repo's pervasive cast_possible_truncation warnings (base carries 89) at line numbers outside the
  patch's added regions. Author's proactive `#[allow(clippy::too_many_arguments/needless_range_loop/
  cast_possible_truncation)]` = evidence they ran clippy; that is how a clean pass looks. The
  SERIALIZED-SURFACE class (the other callback revert leg) was handled BY DESIGN and is worth
  recognizing as a strong approve signal: LocalInformation is binary-serialised into the shipped
  definition cache, so the author DERIVED has_left_since from events instead of storing a field
  (no layout change) and declared Event::Switch LAST in the enum (variant indices stay stable) -
  both documented in-code. STALE desc-bot resolved a lightbulb: the Shipd description bot quoted
  "share a single block scope" / "nearest enclosing loop or switch" (absent from the current text);
  the author already SOFTENED "single block scope" -> "a scope of their own", which DELIBERATELY
  makes cross-clause visibility a non-requirement -> the cross-clause-visibility fairness lightbulb
  is a SKIP (a test there pins behavior the spec intentionally leaves open); the two negatives that
  ARE stated (no-outlive, no-clobber) are both tested. Verdict-bar held on TWO judge/edge leads,
  neither a CR: FP judge-c's case-VALUE-expression side-effect replay is unspecified (prompt treats
  case values as values), and the union-argument probes hit a PRE-EXISTING todo!("nested, get
  latest") at invocation.rs:213 (base file the solution never touches - grep confirmed 0); and
  judge-b's "candidate more correct than reference on fallthrough-into-default narrowing" is real
  (golden's remaining_after_cases overwrites the default's narrowing, dropping the fall-through
  value) but sits at an AMBIGUOUS rule intersection (either-way-joined vs default-excludes-cases)
  the spec never pins, uncovered because the fall-into-default test uses a LITERAL discriminant
  where remaining_after_cases returns None and the overwrite never fires = Illustrations note, not
  scored (spoon-v4/MCP: reference reading defensible on an unpinned cell). Conciseness-bot
  request_changes DECLINED: its two HIGH deletions target the break/return + post-statement-join
  paragraphs that ANCHOR the tested unreachable-after-exit and certainty contracts (6 agents failed
  certainty) = contract-anchoring, bots decide nothing, tests do (IMPORTRANGE). Description 2 for
  ONE grammatical run-on ("A clause control can arrive at either way sees the two entry paths
  joined"), NOT the density (density justified for a whole control-flow subsystem per Karim +
  ai-eval "failures semantic not ambiguous"). Tests 2 for the one good-to-have return-unreachable
  cell (shared has_left_since/is_finished mechanism = low realistic slip). LOC 703 count_loc >> 250
  even brace-discounted so no recount (only recount NEAR the floor). Comment density 16% vs peer
  iteration.rs 11% = design-rationale not slop (ai-eval "comments explain only genuinely subtle
  constraints"). repo-fit.md gate digested first-hand: no checker switch.rs upstream, issue #100
  lists switch as untested, PR #238 is PARSER-only not checker type-checking, feature absent at main.

- 2026-07-22 (gopdf Gradient-fills-and, from-scratch APPROVE 3/2/3; dense PDF feature, every lead
  resolved to a non-blocker under the hardened CR bar): the review was five candidate findings and
  ALL FIVE failed the "wrong/incomplete solution passes a STATED behavior the reference gets right"
  test, the discipline the owner wants before any CR. (1) FP judge-c: duplicate stop exactly at
  offset 0/1 + Extend loses the end color because gradientSegments drops the empty [0,0] stitching
  interval - reference SHARES it, SPEC_GAP_REFERENCE_ALSO_FAILS, hidden suite doesn't pin the
  degenerate endpoint = manager-note in Illustrations for alignment, not a defect (spoon-v4 class).
  (2) FP judge-b NaN/Inf over-strict = defensible unspecified edge, never under-rejects. (3) Fairness
  lightbulb "duplicate-offset parity only on fill" = COVERED TRANSITIVELY: fill/stroke/draw all sort
  through the same normalizeGradientStops (prepareGradient called by both registerGradientPattern and
  registerGradientShading), so the fill dup-offset test exercises the shared code = skip with grounds
  (py-pglite base-manager transitive-coverage shape). (4) Fairness lightbulb "invalid-call state
  preservation" = genuinely uncovered (no test that a FAILED setter leaves the prior active gradient
  intact) BUT atomicity is correctly implemented (setters validate in prepareGradient BEFORE touching
  curr.activeFillGradient), the reference preserves it, the sole passer does too (FP-clean), and it is
  a narrow robustness surface = Tests-2 good-to-have not CR (identical to py-pglite's flag-plumbing
  cell). (5) ai-eval "soft mask keyed by page dimensions" caveat = CORRECT behavior mis-flagged: dedup
  keys include the page-height coord flip + mask page box, so same-size pages reuse one mask
  (TestGrxd4AlphaMultiPageDedup) while a different page size correctly gets a new mask sized to cover
  (TestGrxd4AlphaMaskPageExtent accepts bigger BBox OR opaque backdrop) - not a gap. Go-specifics:
  gopdf CI is CodeQL-only, NO gofmt/vet gate, so the R4b "repo's own lint gate" is thin, but ran
  gofmt -l + go vet + go build on a LOCAL worktree (go 1.25 local, apply solution.patch, deps download
  fine) = all clean, no dead helpers (every gradient.go helper >=2 refs) - do it anyway, it is the
  callback-revert class and gofmt/vet are official Go tools not our scripts. LOC 838 lenient over 250
  floor with the golden LEANER than the 903 median passer (healthy pykka-inverse), Go brace inflation
  irrelevant because far from the floor (only hand-recount when NEAR it, per excelize). Effort
  discipline the owner asked for paid: did NOT rebuild four-state (ai-eval's 10 rollouts + baseline-
  preserved establish it) or run PDF-output probes (FP-clean + 267-test tolerant suite + full code
  read settle reference correctness); the ONLY thing reproduced was the one gate the platform checks
  skip (gofmt/vet). No agent-runs dir AT FIRST: run/fairness
  initially read from ai-evaluation + FP panel and flagged as a gap; the owner pushed, the runs
  arrived, and I re-did R5 properly on the raw junit - DO NOT rest a verdict on ai-eval/FP summaries
  when the raw runs can still be fetched, a from-scratch verdict needs them. Raw R5 fully corroborated
  the summary-based approve: passer Nova_7 vetted genuine (903-line independent impl, its OWN
  single-file gradient.go with different type names and layout from the golden = not a copy, zero
  hidden-test-name/platform-token/hardcoded-output hits, no base-test edits, validates-before-mutate
  so it does not exploit the state-preservation gap = FP-realism confirmed), all 10 baselines green
  (no regression, raw-confirmed), errors=0 everywhere (real assertion mismatches not harness), and
  failures concentrate on exactly 3 STATED behaviors (nil/wrong-length alpha must error 8/9, no
  zero-width stitching bound on equal offsets 6/9, soft mask must cover the shape 3/9) - concentrated
  but each discoverable + reference-correct + no single test failed by ALL runs = fair difficulty on
  the hard parts, not undiscoverable ambiguity; matched the ai-eval-sourced failure description
  exactly, so nothing was hidden. Tolerant-assertion suite is a POSITIVE (evaluates the
  emitted PDF color function, resolves coords through the /Matrix, 0.01 tolerance, exact-byte only in
  the 2 determinism tests) = no over-pinning, recognize as non-issue. repo-fit.md (new automated
  check) PASS with a Medium "upstream-ahead" finding (base 12 commits behind) cross-checked not
  trusted: the 12 ahead-commits are all Justify-text touching gopdf.go in unrelated regions, new
  gradient files have empty upstream path history = benign, old pin reintroduces nothing. Writing per
  the owner's restated asks: approve => Tests-2 note is issue+effect+"Not blocking" with NO how-to,
  Solution 3 gets no reason, Other notes "None.", Tags "None." (no text after a bare tag), the
  roadmap/"clean approve, one good-to-have" opener + all forge/tool facts live in Illustrations, never
  author-facing.

- 2026-07-22 (py-pglite Persistent-Data-Directory, from-scratch APPROVE 3/2/2; SAME-REPO calibration
  from the sibling Add-bulk-row-loading review transferred wholesale and saved the whole R4b setup):
  when a repo already has a reviewed sibling in Reviews/Accepted, its lint-gate map is reusable -
  py-pglite gate = `pre-commit run --all-files` = ruff-check + ruff-format + bandit(-c pyproject) +
  hygiene hooks, ruff 0.12.0 / bandit 1.8.6 pinned in .pre-commit-config, ruff ignores F401/E402/E501,
  pure-Python so a throwaway venv + git apply both patches beats any forge/DB. Result here was FULLY
  GREEN (ruff check clean src+tests, ruff format 0 drift unlike the sibling's test-file drift, bandit
  no issues - and its config only runs B201/B301 so it is near-vacuous, worth knowing, debug-statements/
  trailing-ws/final-newline hooks clean) => the callback-revert lint class is fully clear, a strong
  approve signal. Verdict-bar discipline (owner's hardened CR bar = wrong/incomplete solution PASSES a
  stated behavior, or catastrophic defect): the fairness lightbulb #1 (--pglite-reuse-db flag only
  tested for registration+default, never that setting it drives fixture reuse; every reuse test drives
  reuse_db=True directly so a flag-registered-but-not-wired impl passes all 31) IS technically an
  incomplete-solution-passes cell, BUT it is a minor CLI-convenience surface whose core reuse is
  exhaustively covered, the sole passer wires it correctly (FP-realism via the passing run: Nova_4
  getoption->PGliteConfig(reuse_db=True)->fixture), and all three quality checks rated it non-blocking
  => Tests 2 good-to-have, NOT a CR (same shape as the sibling's conflict_columns cell -> Tests 2 +
  approve). The other two lightbulbs skipped with grounds: base-manager persistence is covered
  TRANSITIVELY (SQLAlchemy managers inherit the base PGliteManager._prepare_data_dir path, so a base
  bug fails those tests), and extension-mismatch recovery shares the exact lock-release-leave-untouched
  mechanism already tested for a corrupt dir. FP PASSED_WITH_WARNINGS judge-c dissent (candidate leaks
  native PermissionError on unreadable dir / UnicodeDecodeError on non-UTF8 marker where reference
  wraps) re-derived BOTH ways: filesystem faults are outside the prompt's enumerated error cases
  (held / not-a-usable-db / lacking-extension + narrowly-defined malformed marker = non-object top level
  OR non-string extension entry), the reference DOES wrap them (verified in code: _entries and _read_json
  translate OSError->PGliteDataDirError, from_dict returns None for exactly the two enumerated cases), so
  it is extra defensiveness a non-wrapping solution still passes => no hole. Solution 2 for one dead
  helper (is_locked, 0 callers anywhere incl. tests; sibling diagnostic fns current_owner/describe ARE
  used by manager logging) - ruff does NOT flag unused module-level functions so the lint gate misses
  it, exactly why the manual dead-code sweep is still needed even when lint is green. Marker tests are
  impl-agnostic (walk the tree for any JSON object holding the extension list, not the reference's
  .pgctl path) = fair, no over-pinning - a good pattern to recognize as NON-issue. Difficulty fair not
  ambiguous: 8/9 failing runs trip persistence-with-reuse-off (agents treat reuse_db=False as
  do-not-persist) + restart-reuse-report, both plainly stated and reference-correct = discoverable-hard.
  Efficiency wins the user asked for: LOC 764 lenient is FAR over the 250 floor so no strict recount
  (unlike the pykka/react-native compact-under-floor cases - only recount when NEAR the floor); reading
  the 3 core files + coverage matrix + run tally + the one lint run decided everything, no forge, no DB,
  no probes needed because the reference correctness was settled by FP-clean + comprehensive-suite +
  code-read. repo-fit.md PASS cross-checked (_persistence.py empty upstream commit history = genuinely
  new/absent at main; Sep-2025 pin reintroduces nothing since the feature is absent). Writing style per
  the owner's restated asks: approve => author-facing notes are ISSUE-ONLY + "not blocking", NO
  recommendations (recommendations are CR-only), no praise intro ("the suite is thorough" cut), no
  local-tooling names author-facing (venv/ruff live in Illustrations as the repo's OFFICIAL gate), no
  text after a bare tag, roadmap/motivational opener lives in Illustrations for the manager.

- 2026-07-22 (excelize Volatile-aware-formula, from-scratch Request Changes 3/2/2; LOC-floor driver on
  a COMPACT-but-COMPLEX Go feature, threading the user's correctness-CR-bar against the workflow's
  LOC gate): the two rules govern different things and both were honored - the correctness bar (a CR
  needs a wrong-solution-passes FP hole or a catastrophic defect) meant the THREE confirmed reference
  gaps were mentions not CR drivers, while the separate LOC-floor gate (sub-floor golden = RC, msw/
  pykka) drove the verdict. Golden manager-strict ~217 < 250 floor, but count_loc.py said 288 = PASS;
  the ENTIRE 71-line gap was pure standalone braces (46 in calcdeps.go alone) that count_loc keeps and
  a manager drops - Go's brace density inflates count_loc badly, so on a Go golden near the floor,
  recount by hand and expect count_loc to over-read by ~25%. Corroboration that the golden is genuinely
  under (not a mis-count): the sole passer wrote 575 impl lines vs the golden's 530 raw, natural
  solutions run larger = pykka inverse signal, and it lands the golden under while a normal solution
  clears. Verdict-bar discipline on 3 gaps, NONE a CR: (1) single-cell INDIRECT("A1") reads via
  GetCellValue and skips recordCalcDep, so CalcDependents(A1)=[] while range INDIRECT via parseReference
  records [Sheet1!C1] - probe-confirmed, but no wrong value (INDIRECT cells are volatile/always fresh)
  and a test pinning it FAILS the reference = solution-side not demandable-test (spoon-v4); (2) per-call
  DisableCalcCache leaks: CalcCellValue uses merged options.DisableCalcCache (calc.go:919) but inner
  cellResolver gates formulaArgCache on file-level f.options.DisableCalcCache (calc.go:1891/1929), so
  2nd calc of B1=A1+1 (A1 a formula) logs CacheHits 0->1 - probe-confirmed, stats-only, no wrong value;
  (3) shared-formula member invalidation (FP judge-c) fails the REFERENCE identically (12 vs 101),
  unspecified (shared formulas not in prompt), FP-ruled follow-up = Illustrations owner-note only. All
  three are untested/unspecified edges where the reference is incomplete or shares the gap, so zero are
  "a wrong solution passing a stated behavior the reference gets right." Reproduce-only-what's-needed
  paid: 2 tiny Go probes (INDIRECT dep, per-call CacheHit) settled both leads in seconds vs reasoning;
  no forge (pure-Go local clone at the pin, go1.25). R4b on a Go repo: the lint gate is `go vet ./...`
  (excelize CI has NO golangci/checkstyle - grep .github/workflows before assuming); vet+gofmt clean,
  base regression green with golden, and the serialized-surface sweep = new unexported File cache
  fields + runtime-only Options.DisableCalcCache never reach a marshal path (no xlsx leak). New
  repo-fit.md automated gate (25 gh calls, PASS) corroborated first-hand: base 32931c3 == current master
  tip (fully fresh), no duplicate PR/issue, feature EXTENDS the base calcCache from #2144/#2242 = right
  shape, maintainer xuri active. Dominant failure 8/10 = row_restyle (agents invalidate SetCellStyle
  but miss SetRowStyle/SetColStyle) = discoverable-from-repo difficulty, fairness-rated fair. Framed the
  RC per the owner style ask: motivational roadmap ("only one thing blocks, and it is scope not
  correctness"), separate paragraph per gap, defects-only author-facing, minor gaps explicitly marked
  non-blocking so the manager sees LOC is the sole driver. PROCESS MISS (owner caught, corrected same
  sitting): I grepped ai-evaluation.md for the verdict/pass-rate line and skipped the body - WRONG,
  READ THE AI-EVAL IN FULL. Its two failing checklist items ("Solution meets all requirements" =
  per-call gap; "Tests cover required behavior" reasoning ENUMERATES the omissions) named three
  coverage gaps mapping to the fairness lightbulbs: nested per-call disable, INDIRECT reporting, AND
  structural-deletes-in-reporting; skimming missed the third. The ai-eval checklist item REASONING is
  where the specific findings live, not the verdict line. Re-derived on re-read: probed structural
  deletes and the reference IS correct after recalc (CalcDependents(A5)=[Sheet1!E4], IsVolatileCell
  true post-RemoveRow/RemoveCol) = fair addable coverage symmetry (unlike INDIRECT, would NOT fail the
  reference), so a Tests note not a Solution gap. Bonus corroboration in the ai-eval body worth
  mining: its passing run already routes per-call into formulaArgCache = the reference fix is proven
  achievable; and it explicitly does NOT weigh golden-LOC (its PASS and the LOC-RC coexist, pykka
  split). Rule: on every review read the FULL ai-eval + FP + fairness bodies, not the summary lines -
  their per-item reasoning is where the real coverage/solution findings are.

- 2026-07-22 (py-pglite Add-bulk-row-loading, from-scratch APPROVE 3/2/3; the callback-revert R4b
  lint sweep FIRED but resolved to a mention, not a CR): ran the repo's real lint gate on the patched
  clone before scoring (test.sh runs pytest ONLY, so lint is ungraded, the exact callback blind spot).
  py-pglite's gate = `pre-commit run --all-files` in CI (ci.yml) = ruff-check + ruff-format + bandit +
  hooks. Result: ruff-CHECK clean on src AND tests, bandit clean, hooks clean, but ruff-FORMAT would
  reformat 6 test files (pure line-wrapping of >88-char asserts) -> `pre-commit --all-files` fails ->
  CI red on the patched tree. KEY CALIBRATION: distinguish ruff-CHECK errors (F841 = the callback
  class, a real lint error that also hid a missing assertion) from ruff-FORMAT drift (cosmetic,
  auto-fixable with one `ruff format`, zero semantic change, here test-only while src is clean). The
  callback F841 class does NOT even apply here because py-pglite ruff ignores F401/E402/E501 and there
  was no unused var. Per the owner's CR bar (CR = a wrong/incomplete solution PASSES, i.e. an FP hole,
  OR a catastrophic solution defect), a cosmetic test-file format drift is NEITHER -> surface it as a
  fix-before-merge hygiene note in Other notes + Illustrations (manager alignment, author runs
  `ruff format tests/`), do NOT CR. Install the repo's PINNED tool versions (ruff 0.12.0 / bandit
  1.8.6 from .pre-commit-config) into a throwaway venv, `git apply` both patches, run, then
  `git checkout` - pure-Python linters need no forge/DB. FP-HOLE REALISM via the whole run population:
  "loading must succeed at any size" is a genuine under-test (Postgres caps a statement at 65535 bind
  params; the largest test is 500 rows = 1000 params, which an UNCHUNKED single INSERT also passes),
  but a subagent grep of ALL 10 runs' insert mechanism showed 10/10 chunk under a 65535/width cap
  (0 COPY, 0 unbounded) -> no realistic unchunked impl exists -> good-to-have (add a >65535-param
  test), NOT a hole (colyseus rule: 10/10-do-it-right = theoretical gap). Serialized-leak sweep for a
  DB loader = does it write unrequested columns or mutate serialized manager state? Clean (writes only
  resolved columns, json.dumps only for json/jsonb, returns a count). Conciseness-bot request_changes
  DECLINED: "at any size" ANCHORS the chunking contract and "invalid...raise a dedicated error"
  ANCHORS the error-condition set (naming the error CLASS != naming the conditions) - both
  contract-anchoring, bots contradict, tests decide (IMPORTRANGE). FP PASSED_WITH_WARNINGS dissent =
  GENERATED ALWAYS AS IDENTITY explicit-key insert, candidate AND reference fail identically
  (SPEC_GAP_REFERENCE_ALSO_FAILS), outside serial/identity-by-default "explicit keys" semantics =
  unspecified edge, skip. New repo-fit.md gate digested first-hand (26 gh calls, no bulk-load/insert/
  seed/COPY upstream, corpus tasks are ORM upserts elsewhere or same-repo txn-isolation with no
  reusable ingestion) = distinct; old base pin (Sep-2025 merge, ~10mo) OK because touched paths carry
  maintenance-only and the feature is absent at main (no reintroduction). Tests 2 = one real
  fairness-flagged coverage cell (conflict_columns validation exercised only on valid targets;
  update-with-missing/nonexistent/non-unique conflict_columns -> PGliteBulkLoadError untested, ref
  validates the missing case at options.__post_init__ so a non-wrapping impl slips) in an otherwise
  comprehensive 66-test suite; atomicity lightbulb SKIPPED (unstated rollback contract). Difficulty
  fair not ambiguous: 8/9 failing Novas trip ONLY the SQLAlchemy shared-engine path (inherit generic
  bulk_load -> 2nd connection to single-connection PGlite), discoverable from get_engine's documented
  "Returns a shared engine instance to prevent connection timeouts" constraint; ai-eval concurs.

- 2026-07-22 (react-native Expose-component-branch, from-scratch Request Changes 2/2/3 driven by the
  GOLDEN LOC FLOOR - second pykka-class in three days, so LOC-floor-on-a-hard-compact-task is now a
  standing first-pass check): a whole-artifacts review (no clone; react-native too heavy) settled the
  verdict on size, not fairness. The golden is a clean, correct, ADDITIVE Fabric hit-test (0 removed
  lines, every spec clause maps to code, FP 2-genuine-no-dissent + ai-eval + auto-review all "no
  grounded defect") but ~204 meaningful production lines (count_loc lenient 243, both under the 250
  floor). THE R8 RULE-2 CATCH that matters: I first relayed a subagent's "passers ~206, same as
  golden" and my own strict recount gave passers 143/152 - SMALLER than the golden, not equal. Re-count
  the LOC claim yourself with ONE consistent strict filter across golden+passers before shipping the
  number, because it is the driver; and passer-SMALLER-than-golden is the pykka agents-smaller signal
  whose two readings (golden padded / weak tests) are BOTH refuted here (golden's extra ~50 lines are
  real struct helpers, and the suite is strong: 8/10 fail on one real overflow-clip cell), so it
  confirms "intrinsically compact feature under the floor" = RC-with-bump-choice, tag Lines-of-code,
  never approve-with-note even at 20% pass and ai-eval "ship" (the criteria median 442 counts each
  agent's ~230-line added TEST file, which is why the panel median clears 250 while production does
  not - always split production vs test lines on a small-solution task). Verdict-bar discipline held
  on everything else (the owner's "CR only for a wrong/buggy solution passing or a catastrophic
  defect"): the 8/10 overflow-clipping failure is FAIR difficulty (discoverable from "reflect what is
  rendered" + "through an ancestor's overflow area" even though "overflow:hidden" is not verbatim;
  ai-eval agent_blame_unfair=false) = NOT a CR; the Hidden-trait coverage gap (spec says "hidden or
  display:none", only display:none tested) is real but both passers guard the trait so nothing slips =
  Tests 2 good-to-have, not an independent blocker; the two Test-Fairness lightbulbs (stale non-root
  node = same single getNewestCloneOfShadowNode call already covered; arg-type validation = unspecified)
  = skip. Description 2 for the one redundant/prescriptive sentence ("implementable in the existing C++
  binding layer") the conciseness bot HIGH + description bot both flagged, and the FIRST line already
  scopes it. R4b maintainer-lens on a non-linted-by-test.sh repo: test.sh base runs a C++ gtest, NOT
  the repo lint, so unlike MCP the lint gate is NOT settled by base-green; react-native runs clang-format
  in CI (seen in the repo-fit commit log) so I FLAGGED it as an author-confirm item rather than
  dismissing it (the callback lesson) or cloning the RN monorepo just for a formatting nit that cannot
  change an RC verdict - flag-don't-bury is the proportionate move under an RC, run-it is mandatory
  only under an approve. Serialized-surface-leak sweep clean (the JSI binding returns the requested
  branch array, mutates no shared/serialized object). New repo-fit.md gate digested + cross-checked
  first-hand: PASS is right, and the log surfaced that the author (coado) is a real RN hit-testing
  contributor (PR #46099 transform-inversion) extending their own area, distinct from the touch-target
  findNodeAtPoint = strong fit. Efficiency: no forge earned its cost here - FP+ai-eval+additive-diff+
  clause-read decided correctness, the run tally decided LOC-parity and fairness, and the only
  reproductions worth doing were greps and a strict LOC recount.

- 2026-07-22 (apify/mcpc MCP-Completion-Argument, from-scratch APPROVE 3/2/3; my draft was RC on an
  error-wording pin and the owner's "is it really critical / why would no check catch it" push
  REVERSED it - the fifth time an over-flagged wording/lightbulb cell has been corrected to approve,
  so this is now a hard reflex, not a nuance). The withdrawn finding: two tests require an unknown-
  prompt error to contain "not found"; 8/10 agents emitted "Unknown prompt: <name>" + Available list
  + Did-you-mean and failed only on that word. I built a whole "description-primed contradiction"
  case (desc opens with "Unknown prompt ... names should be rejected", golden mixes "Prompt not
  found" vs "Unknown completion context argument", near-passer blocked only on it) and it was WRONG
  on the decisive leg: GRAMMAR of the clause. "Unknown [prompt/resource/argument/context] NAMES
  should be rejected ... matching the CLI's existing style" - "Unknown" modifies "names" (WHICH names
  to reject = unknown ones), it does NOT prescribe the message TEXT; the message rule is "match the
  CLI's existing style", and that style is uniform for a named resource (Tool not found, Session not
  found, Profile not found). So "Prompt not found" is DISCOVERABLE; 2 agents produced it, and the
  near-passer had "not found" in its trajectory 33x and slipped = integration DIFFICULTY (woodpecker
  evidence-in-hand rule applies straight, I had inverted it). Fair-but-hard, regex-flexible, reference
  correct, two automated checks + 3 manager rounds all cleared it = NOT a blocker. THE VERDICT BAR
  (owner, restated): a CR needs a wrong/incomplete/buggy solution to PASS (an FP hole), or a
  catastrophic solution defect. A FALSE-NEGATIVE (correct solutions fail on discoverable-but-hard
  wording) is difficulty, not a CR - do not confuse "some agents fail" with "unfair". Before writing
  CR on any wording/format cell, run the owner's own gut-check: "why did FP + Test-Fairness + ai-eval
  all rule it fair, is it really damaging enough to fail the submission, and if it's that minor why am
  I CR-ing" - if the answer is "it's minor", MENTION it in Illustrations for manager alignment and
  APPROVE, do not CR. Author-facing sections carry DEFECTS ONLY; a fair-but-strict cell and covered
  good-to-haves are Illustrations notes, never an author ask. The callback-archive revert defined the
  ACTUAL blocker classes to hunt instead (both were boring hygiene I'd have to MISS, not fairness):
  (1) the repo's own LINT GATE red on the patched tree (Dash: F841 unused-var in a TEST file that
  `flake8 dash tests` rejects) - here test.sh base runs the repo's real `pnpm run lint` and all 10
  runs are base-green, and mcpc eslints src-only matching its own CI so a test-file unused var is not
  even a maintainer blocker (contrast Dash whose lint covers tests); (2) a SERIALIZED-SURFACE LEAK
  (Dash: clientside `source` shipped into the `/_dash-dependencies` response) - swept here: proxy
  advertises `completions` only if `upstreamCapabilities?.completions` (no fabricated capability),
  result returned unchanged, _meta preserved, no unrequested field on any external response. Those
  two sweeps are the R4b maintainer-PR lens and they are where reverts actually come from. The one
  real minor kept = a coverage gap the Test-Fairness check itself flagged: the core-unit test asserts
  RESULT _meta but not REQUEST _meta forwarding into the SDK (the CLI test mocks McpClient so it never
  checks McpClient->SDK), so a client dropping request _meta slips = Tests 2 note, not blocking (ref
  forwards it, minor). Method notes: verify each prior-round manager ask landed against CURRENT
  artifacts (v4's made-up-count / session-framing / private-design pins all genuinely fixed) before
  hunting new issues; digest+cross-check the new repo-fit.md gate first-hand (upstream-ahead 3 commits
  = README/UI/keychain only). Efficiency: base-green already decided lint/dead-code/four-state and
  FP-clean+comprehensive-suite decided reference correctness, so the forge earned nothing here (the
  lint re-run failed on node-version env and was redundant anyway); the reproductions that DID earn
  their cost were pure greps (near-passer trajectory, golden error wording, proxy capability gate).

- 2026-07-22 (pykka Atomic-cancellation, from-scratch Request Changes 3/2/3; LOC-floor is the driver on
  a HARD-but-COMPACT task): the golden's own meaningful count is the floor, NOT the agent median. Here
  the platform criteria "median of successful runs >= 250 LOC" PASSES at 443.5, but the reference is a
  very tight ~80-100 meaningful-line state machine (count_loc lenient 102; by-file +80 _threading/+18
  _future(mostly 4 NotImplementedError stubs+docstrings)/+7 _actor/+3 _exceptions/+2 wiring; manager-
  strict ~80), far under 250. The rule is explicit and the msw precedent binds: golden strict < floor
  = Request Changes with the bump choice, NEVER approve-with-note - even when difficulty is real (20%
  pass) and ai-eval says "ship" (ai-eval does not evaluate the golden-LOC floor, it called the ref
  "compact"; that is corroboration, not a waiver). Agents-4x-larger-than-golden is the inverse of the
  weak-test signal: it means the ref is minimal, not that tests are weak (suite here is strong). Frame
  it fairly author-facing: name the bump surface (cancellation callbacks / cascading cancel into the
  wrapper source chain / cancel-with-reason), say the feature is hard and the SIZE is the problem, and
  that a golden under the floor is a common revert cause. TAG "Lines of code" (LOC drives the decision).
  R4b on a heavily-linted Python repo = run ALL its gates: pykka CI runs mypy + basedpyright + ruff-
  format + ruff-check with select=["ALL"] (4 gates, not 1); all clean on the patched tree (author's
  `# noqa: SLF001` on the intentional private `_set_running_or_notify_cancel()` access is the correct
  suppression). Concentration-is-not-ambiguity disambiguation (the atom-media guard): 8/10 runs failed
  ONLY test_concurrent_get_hook_waiter_honors_own_timeout (hook must get the caller's exact timeout=1,
  not a deadline-adjusted 0.999998) - FAIR because base _future.py:76 forwards `_get_hook(timeout)`
  directly and the description requires existing timeout behavior stay compatible, so it is discoverable
  base-preservation, not an unstated wording pin; verify the base behavior at the cited line before
  calling a concentrated failure unfair, and ai-eval independently rated it fair. Fairness-lightbulb
  triage with the colyseus realistic-slip check: set_get_hook-after-cancel is a REAL uncovered stated
  behavior (fairness bot + ai-eval both flag it) = Tests 2, but 10/10 agents guarded it (grep every
  run's seam) so no wrong solution slips => good-to-have ask under the RC, not an independent blocker;
  the other 2 suggestions (repeat-cancel on wrappers, done/cancelled on derived) run the SAME inherited
  ThreadingFuture.cancel()/done() already covered on bare+request futures = skip (covered elsewhere).
  FP judge-c solo dissent (concurrent waiter must see a failed hook execution's error vs a retry's
  success) chased against the reference per codex-spoon: adjudicator re-ran it, FAILS THE REFERENCE
  IDENTICALLY (assert value == error), and "wait for that same execution" never specifies failure
  propagation to a passive waiter => unspecified edge, no reference defect. New automated repo-fit.md
  check (verdict PASS, 30 gh calls) verified independently (gh PR/issue search = only dependabot + a
  2020 scheduler; futures gaining cancel/cancelled/done mirror concurrent.futures + Akka) - treat it
  like any bot: corroborate, don't defer. Pure-Python repo, all of it ran in a local venv at the pin,
  no forge; fail-on-base certain by inspection (new tests use pykka.CancelledError + future.cancel(),
  neither exists at base).

- 2026-07-20 (tinkerpop Cross-phase-type/label-scope v2, RC->APPROVE 3/2/3; first R4b application on a
  JVM repo, run BEFORE scoring per the callback-archive revert): the maintainer-PR lint gate for a
  Maven/Apache repo is apache-rat (license headers) + maven-enforcer, NOT checkstyle/spotbugs
  (TinkerPop configures neither, so those -Dcheckstyle.skip/-Dspotbugs.skip flags in test.sh are
  no-ops - grep the poms for the plugin artifactId before assuming a gate exists). RAN rat:check on
  the patched gremlin-core = rc 0, all headers approved (the v1 ASF-header ask now GATE-verified, not
  eyeballed); the only file rat flagged was my own injected probe (remove injected test files before
  the clean gate run). Enforcer disambiguation = the lambda-test pattern again: enforce fails via
  `validate` but fails IDENTICALLY on pristine base (JDK 21 vs repo Java 11), so env not solution;
  and enforcer:enforce invoked STANDALONE errors "no rules configured" (rules bind to the pom
  execution, so trigger via a phase like validate, not the bare goal). Author-response patterns worth
  recognizing: (1) they did a BROADER dead-code sweep than I asked (removed 6 members vs the 3 I
  flagged) - the every-instance-is-a-class handled author-side; verify the extra removals are truly
  dead (no dangling caller -> else compile breaks; ofList() removal was safe because FoldStep uses
  ofListOf()). (2) they converted my empty-catch finding into a MESSAGE-SUBSTRING contract stated in
  the description ("a type violation message contains 'type'; a label-scope one contains 'label'") +
  a case-insensitive assertRejectedWithReason helper. This pins error wording (T7 territory) but is
  ALLOWED because the description states it - and the decisive fairness proof is the FRESH BATCH:
  grep every run's junits for the message-assert failure form ("Expected rejection reason to
  contain"), found ZERO across 16 runs / 23 failures (all behavioral: 15 under-rejections + 4
  over-rejections), so the stated-message-contract is fair, not an atom-media wording trap. A stated
  output-wording pin is fair iff no counted agent fails on the wording - and the batch answers that
  empirically, don't reason it. Pushback CONCEDED with source verification (the winning-pushback
  shape): author declined re-adding StandardVerificationStrategyTest because its
  {repeat(out().choose(...)).times(5)} @Parameterized name={0} renders BranchStep.traversalPickOptions
  (a HashMap:53) in hash order -> non-deterministic node id -> flaky gate not correctness gate;
  verified all three cites in the clone, conceded (T2 determinism covers a non-deterministic DISPLAY
  NAME even when the assertion is deterministic). Terminal-approve rigor: mutation-PROVED the new
  select-by test load-bearing (single-key-emits-map mutant drops 138->136, failing exactly the new
  testO_selectSingleKeyByEmits... test) rather than confirming-present; and the FP PASSED_WITH_WARNINGS
  Scope.local dissent re-derived as an unspecified edge (prompt never mentions Scope.local, its
  list-rejection rule makes the candidate's over-rejection defensible, reference correctly emits a
  number, a test there would fail the sole passer) = skip, matching the fresh Test-Fairness raising
  ZERO lightbulbs. Tests stayed 2 not 3 on a REAL citable duplicate (testF_whereSubSeeded... is
  byte-identical to testF_wherePassthrough; testD_selectYieldsLabelType == testLabel_L1) with a
  name-body mismatch - a verifiable minor, not an invented one (dishka line holds: don't invent, but
  a real duplicate IS a 2 under Karim's any-real-minor rule). Forge ops: gremlin-core rat/enforcer/
  137-test cycle ~30-90s each with warmed deps; git-apply-created files aren't tracked so
  `git checkout -- <file>` can't revert a mutated new file (clean+reapply between mutations).

- 2026-07-20 (sbi Bayesian-Synthetic v2, Approve 3/2/2; TWO-part lesson: run every gate, THEN
  calibrate its severity - I drafted RC and the owner's severity framework corrected it to
  Approve-with-note): PART 1, run the repo's OWN gates plural. sbi's `lint.yml` runs ruff AND
  `pyright sbi` (blocking, no continue-on-error); I ran ruff green last round and nearly approved,
  running pyright caught a real miss. FAITHFUL DIFF METHOD (torch-absent pyright LIES - phantom
  `float|None` operator error that vanished with torch, 3 phantom base errors while CI base is
  green): CPU-only torch (`--index-url .../whl/cpu`, ~190MB not the 1GB CUDA default) + runtime
  deps, remove any pyrightconfig override so the repo's `[tool.pyright]` basic mode applies, run on
  BASE and PATCHED, diff EXCLUDING reportMissingImports (optional backends the venv omits, CI
  installs). Result: base 0, patched +1: `synthetic_likelihood_potential.py:167` on
  `self.prior.log_prob(theta)` missing the `# type: ignore` every sibling uses (likelihood_based:115,
  ratio_based:105); `prior` is `Optional[Distribution]`. PART 2 (the calibration, owner-corrected):
  a gate-red finding is NOT automatically a return. The return bar is FP-hole-on-stated-behavior OR
  critical defect; otherwise mention-with-Approve. This pyright miss is correct code, one-line
  cosmetic suppression, no FP hole, no behavioral defect, and the task grades through test.sh NOT
  the repo CI - so it is a Solution 2 NOTE under an Approve, not an RC driver. My draft treated
  "callback got reverted over a lint failure => RC any CI-red" - WRONG read of that revert: the
  callback F841 was ALSO dead test code hiding an uncovered id-case block, PLUS a browser-endpoint
  data leak (behavioral + coverage defects), not a pure type-suppression on working code. The
  transferable lesson from callback was RUN THE GATE AND SURFACE what it finds (done), not
  block-on-everything-it-flags. Do not over-correct a revert into strictness; separate "is it real"
  (yes, run the gate) from "is it a blocker" (only FP-hole/critical). The serialization-leak half of
  callback had no analog and I proved it: `_pseudo_marginal_mcmc` stores the same two attrs base
  `_slice_np_mcmc` sets, `__getstate__` already nulls `_posterior_sampler` on pickle, no
  `__getstate__`/`__repr__`/to_json touched, library has no HTTP surface. Standing rules: (1) for ANY
  Python repo grep `.github/workflows` for pyright/mypy/flake8/ruff and run EACH blocking one on a
  base-vs-patched diff ("I ran ruff" != "I ran the gates"); (2) a green hidden suite says nothing
  about type/lint gates; (3) but a gate-red on correct code is a note, not a return, unless it hides
  an FP hole or behavioral/coverage defect the way the callback F841 did.

- 2026-07-20 (jsdom CSS-custom-property v2 re-review, Request Changes 3/2/1; my v1 was 3/2/2): the
  R4b re-sweep rule ("one flagged instance is a class; re-sweep on new code") found the round's
  blocker, and it was a member of the exact class I flagged in v1 but only half-probed. v1 I flagged
  "substituted values don't go through the literal pipeline" via the CASE-normalization symptom
  (display:BLOCK, 10PX) and scored Solution 2. This round the author fixed normalization (setter
  round-trip) but not INVALIDATION, and the same class's INVALID-value direction crashes:
  `color: var(--x)` with `--x` a non-color (notacolor, 12px) throws `TypeError: val is not iterable`
  out of getComputedStyle (unvalidated substituted value reaches serializeColor), while the literal
  drops to initial. MISS OWNED: I should have probed invalid-substituted-value-into-typed-longhand
  (especially color, which serializes) in v1, not just case; when you flag "value skips the literal
  pipeline," probe the INVALID and CRASH directions too, not only case/format. RULE reinforced: a
  crash in a read API on a plausible input (a mistyped custom property in color) is a blocker
  regardless of test-suite green (maintainer-PR lens); the reference is a graded deliverable.
  Chasing every OVERRULED FP dissent against the reference paid off a third time: judge-c's two
  probes (margin-shorthand-var + a later longhand override collapses the other sides to initial
  instead of reading the shorthand; malformed `var(--missing junk,...)` name accepted as valid) both
  reproduced on the reference (adjudicator tag REFERENCE_FAILS_IDENTICALLY), and judge-b's aside
  "candidate meets/exceeds reference on color coercion" was the pointer straight at the crash.
  Verify-the-fixes was clean otherwise: all 5 v1 asks delivered and verified (cross-sheet +
  removal tests present and passing; base 40->45 with css-parsing-errors.js green; case-norm fixed
  for keyword case; both dead exports gone), and the author's UNASKED complex addition (a static
  hasReferenceCycle graph closing the unevaluated-fallback cycle I had flagged owner-only) was
  stress-tested clean: 9 non-cycle/edge probes, zero over-detection. New WORKFLOW R4b lint gate run
  for the first time on a JS repo: jsdom flat-config eslint on every patched+new file, exit 0,
  proven live by injecting an unused var and watching no-unused-vars fire. Fairness stayed clean:
  ai-eval PASS explicitly rated the unevaluated-fallback cycle test FAIR ("prompt says cycles apply
  even inside fallbacks", kills 8/13), so the 20->7% pass-rate drop is added difficulty not
  ambiguity - the corner I called "contested" in v1 is fair once the description states it and the
  reference implements it. Pure-JS repo so local isolated worktree (npm ci + npm run prepare) did
  lint + four-state + probes; forge still down on billing (HTTP 402), and remember jsdom/Node repos
  never need it.

- 2026-07-20 (sbi Bayesian-Synthetic v2, Approve 3/2/3 closing my v1 RC; first clean application of
  the new R4b lint gate): the v1 re-simulation blocker was closed with a discriminating test and the
  proof it BIT was the FP-panel delta, not a local run: v1's panel carried a judge-c caching dissent
  on the caching passer, v2's panel has NO caching dissent and pass rate fell 40->20%, i.e. caching
  solutions now fail the added test. Read the FP panel across rounds as an A/B on your own fix.
  R4b executed as mandated: ruff 0.9.0 (the repo's PINNED version - lint results vary by version, so
  match it) check + format --diff on every patched file, GREEN. The catch that could have bitten:
  the hidden test file `bsl_test_d3b8f1a06e94.py` does NOT match the `test_*.py` per-file-ignore
  (starts with `bsl_`, not `test_`), so the FULL select set applies to those 917 lines with no test
  relaxation - the distinctive-hash filename that dodges quest-leakage also forfeits the test
  per-file-ignore, so ALWAYS run ruff on it, never assume test-file leniency. Ruff needs no torch
  (standalone binary), so the lint gate is cheap even when the full env is a ~1GB CUDA-wheel install
  I skipped. Sub-item discipline (pynguin v4): my v1 re-simulation ask had two atomic parts (twice-
  at-same-theta AND duplicate-rows-in-one-batch); the author delivered the first (closes the
  DEMONSTRATED persistent-cache exploit) and not the second (a within-batch-dedup solution still
  slips). Called it Tests 2 good-to-have under Approve, NOT another RC: exotic trigger (continuous
  sampler proposals are never duplicate; only a hand-built batch on the exposed potential hits it),
  no v2 passer exhibits it (checked both passers' batch handling - both process one theta at a time),
  and the terminal-shape rule (go-pretty: fixed+verified blocker flips to Approve-with-a-precise-2,
  not an infinite RC loop). Honest-score reconciliation for the recurring 2-vs-3 question: a real
  uncovered form of a stated behavior that I MYSELF flagged in v1 is a real minor (=2), not invented-
  to-hedge (dishka) and not pedantry-below-the-line; but exotic+undemonstrated keeps it a benign note
  under Approve, not a blocker. Author over-delivered on the lightbulb too (semiparametric got two
  sharp behavioral tests - multimodal-KDE-marginal ordering + copula-not-marginal shrinkage - the
  fair way to cover an impl-defined mode without pinning the bandwidth). Solution delta was docs +
  a typed Literal only (estimator/sampler byte-identical to v1, re-verified by grepping the delta for
  the math symbols), so the v1 term-by-term Ghurye-Olkin check carried without re-reading. Difficulty
  concentration held fair: 7/10 fail on the repo-standard `mcmc_parameters` build_posterior kwarg
  (every sbi inference class exposes it; reference + both passers wire it), ai-eval independently
  rules it "repository-inferable" PASS - discoverable-convention slip = difficulty, not ambiguity.
  Staleness clean this round (junit 48 = v1's 43 + 5 new, fresh run-ids), but I checked because the
  dishka round got bitten by a stale v1 agent-runs dir.

- 2026-07-19 (dash Callback-archive-import v6 MANAGER-REVERTED after my Approve; postmortem, two
  misses both self-inflicted): the manager (Abdelrahman) reverted a finalizing approve on two
  points I had the evidence for and dismissed. MISS 1 = REPO LINT GATE eyeballed instead of run. The
  test file left `id_archive = id_source.export_callback_archive()` assigned-never-used (F841); the
  repo's `npm run lint` runs `flake8 dash tests`, F841 is in the `.flake8` select list, and the
  tests/* per-file-ignores only covers E722/F811, so CI is RED. I had literally written in my v5
  Illustrations "that dangling loop is a cleanup worth doing but does not affect grading" - I SAW
  the smell and ruled on grading without running the gate. RULE: when you see a lint/type smell in a
  graded patch, RUN the repo's actual gate (flake8/.flake8, ruff/.ruff.toml, mypy) and check its
  per-file-ignores; "does not affect grading" is never an eyeball call. Bonus: the F841 block was a
  `for` over `('', {}, {'':1})` asserting nothing = dead test code, the fix (assert on the value)
  also closes the coverage. MISS 2 = SHARED-STATE PROPAGATION not audited (R4). The solution did
  `callback_list[-1]["clientside_function"]["source"] = clientside_function`, and since
  `dependencies()` returns `to_json(self._callback_list)`, every clientside callback now shipped its
  JS source in the `/_dash-dependencies` HTTP response - a surface the prompt never asks to carry
  source and EXPLICITLY guards for a different field ("Do not expose prevent_initial_call_mode
  through /_dash-dependencies"). Fix was one line (copy the dict before mutating). I scored Solution
  3, having verified the mutation achieved its goal (source in archive) but never traced the OTHER
  readers of the shared `_callback_list`. RULE (msw generalized): any mutation of a shared/serialized
  object gets a full reader trace - grep every reader of that object and check each observable
  surface (serialization, HTTP, introspection); a description that guards an endpoint for field X is
  a TELL that endpoint is sensitive to any new field on the serialized object. Both misses share a
  root: I reasoned/eyeballed where I should have executed (run the linter) and traced (follow the
  data flow).

- 2026-07-19 (dishka Explicit-Finalizer v2, Approve 3/3/3 after my v1 RC; first application of the
  Callback revert lessons): the author bumped scope exactly as asked (async finalizers + two-param
  exception-forwarding + arity + exception-threading) and fixed all 31 v1 lint/type findings. I ran
  the two Callback gates first: ruff (full CI invocation) + mypy both fully green on src AND tests
  (the v1 items gone: Iterator->Generator, both _exits noqa'd, both inline imports at top); and the
  R4 propagation audit came back CLEAN (finalizers() exposes only DependencyKey, never the callable;
  _exits read only by __exit__; no dishka analog of the Dash /_dash-dependencies leak). All-3s
  earned by a mutation battery on BOTH new behavior (wants_exception-False 7 fail, arity-off 2,
  async-reject-off 1, async-never-awaited 7) and carried behavior (skipped-scope 2, dedup 1,
  wrong-value 25, anchored-walkup 30), plus probes of every new clause incl. the airtight
  anchored-exception test (inner scope raises KeyError, anchored finalizer stays dormant, gets the
  OUTER exception at anchor close). Did NOT invent a minor to hedge the history (dishka never-invent):
  the typing.Self finalizers() edge (FP judge-c) reproduced on the reference but is unspecified
  (Self is the factory's literal return annotation, no clause pins normalization, FP-adjudicated
  non-defect) and both fairness suggestions are skippable (ExitError-shape over-pins "whatever it
  raises" T7; defaulted/keyword-only arity is an unspecified edge, callable-object already covered).
  LOC judgment: v1's 172-clearly-under became v2 borderline (count_loc 286, strict band 224-273
  straddling 250); count_loc clears and the bump is real work (Leonard spirit), so not RC again, but
  I flagged the strict band for the owner as the one lever back. STALENESS CATCH worth keeping: the
  local agent-runs dir was STALE v1 (junit 113 not 127, v1 run-ids) while prechecks/ai-eval/FP were
  fresh v2 - verify junit testcase-count and run-ids against the current suite before citing any run
  data; and both auto-review.json AND the fresh ai-evaluation kept quoting the stale "172 LOC" (the
  LOC counters did not recount for v2). Pure-Python so a local venv did four-state + linters +
  mutations + probes; no forge.

- 2026-07-19 (callback-archive Dash APPROVE REVERTED by manager Abdelrahman; both revert points
  were maintainer-PR-lens defects I never ran, NEITHER was the atomicity minor I spent the round
  adjudicating): the whole round went into flip-flopping RC->Approve->Tests-1->Tests-2 over a
  mutation-proven-but-structurally-unnatural rollback coverage gap (correct final call: Tests 2,
  0/10 agents produce clear-on-failure because the two natural structures avoid it), while two
  cheap mechanical sweeps that a real PR review runs went undone. (1) LINT GATE: the test file's
  dangling `id_archive = id_source.export_callback_archive()` (a loop that exports 3 component-id
  cases and asserts nothing) is `F841`; `.flake8` has F in select and tests per-file-ignores only
  E722/F811, so `flake8 dash tests` (a `npm run lint` step) red-lines with the patch. I HAD SEEN
  the dangling loop and written "cosmetic, does not affect grading, not author-facing" -- exactly
  the wrong call; the manager reviews the PR, not just the graded suite. RUN the repo's own linter
  on the patched tree; never eyeball dead/unused code as harmless. (2) SHARED-SPEC MUTATION CLASS:
  `register_clientside_callback` did `callback_list[-1]["clientside_function"]["source"] = js` on
  the same spec dict `_callback_list` holds and `dependencies()` serialises, so every inline
  clientside callback shipped its full JS source into `/_dash-dependencies`, unrequested and
  explicitly guarded elsewhere (the `prevent_initial_call_mode` clause). I HAD FLAGGED the identical
  `prevent_initial_call_mode` leak a round earlier, confirmed it moved to callback_map, and did not
  re-sweep the class when new source-injection code touched the same object. Fix in v7 = copy the
  dict (`dict(callback_list[-1]["clientside_function"])`) before setting source. META-LESSON: a
  hard adjudication is not where reverts come from; boring maintainer hygiene is. Budget the R4b
  sweep (run the linter; grep every write to any externally-serialised shared object; re-run both
  greps every round) BEFORE agonising over a bucket-a/bucket-b minor. "One flagged instance is a
  class" (new-dot-agent) applies to REVIEWING others' code too, across rounds. New WORKFLOW.md R4b
  encodes both sweeps.

- 2026-07-19 (turfjs Grid-coordinates-across v3, re-review after a contentious FP debate, APPROVE
  3/2/2; my draft was RC and the owner's "aren't these all minor?" push exposed a valid-and-skipped
  OVER-CALL): the airtight close for a "did the fix land AND does a test pin it" round is a
  MUTATION PROOF THAT NAMES ONE TEST. Both prior-round false positives (bare-position mutate
  returns a new array; mgrsGrid accepts a Norway zone-31-corners/zone-32-interior bbox) were fixed
  in code AND newly tested; reverting each fix on the forge failed EXACTLY its pinning test (corner-
  only mgrsGrid -> `not ok 1246 bbox whose interior crosses the widened Norway zone rejected`, one
  test; new-array mutate -> `not ok 14/15/18/19 ... mutate:true returns the same array`), which is
  the fingerprint that the fix is load-bearing and the test discriminates. Confirm the disputed
  zone geometry by executing zoneNumber, not by eyeballing the bbox (my first "valid single-zone"
  probe `[-1,50,1,52]` actually straddled the 0-meridian zone 30/31 seam and correctly threw). THE
  CORRECTION: a Test-Fairness lightbulb is NOT a valid-and-skipped returner just because it names a
  STATED behavior UNCOVERED ON ONE SURFACE and a second check (auto-review T4) echoes it; Karim's
  carve-out is covered-elsewhere OR implausible-wrong-impl, and BOTH held here. The four projection
  fns test named-ellipsoid + malformed-object-reject but not valid-custom-accept, yet: (a) COVERED
  BY COMPOSITION - grid.ts resolveGridEllipsoid is pure `getEllipsoid(ellipsoid)`, the malformed
  `{a:1}` throw only fires THROUGH getEllipsoid so the delegation is exercised, getEllipsoid's
  custom-object accept is directly tested, and a custom object and its named equivalent yield the
  identical {a,e2} (forge: custom == named International1924 byte-for-byte on all four); (b)
  IMPLAUSIBLE wrong impl - the only slip is "reject every object on the projection layer", which
  contradicts the very delegation the malformed test covers and which neither proj4-backed passer
  wrote. A mechanical coverage flag (fairness lightbulb, auto-review T4) states the gap but does
  NOT model the delegation; the reviewer must trace the composition before scoring it a returner.
  Two platform checks agreeing on a MECHANICAL gap is not two checks agreeing it BLOCKS. Lesson
  mirrors faithful-folding: prove the wrong-impl is plausible AND uncovered before an RC; here it
  was neither, so the fix-round with both real FPs closed is an APPROVE with the thin spot as a
  Tests-2 note. Under Approve, sub-3 reasons are action-free notes (react rule): Tests 2 = "a thin
  spot, not a gap", Solution 2 = duplicated UTM/UPS core + no-LICENSE + stale-lockfile stated as
  issue+effect+"minor and not blocking", no imperatives. REPO-INTEGRATION items (Elabyad
  maintainer-merge lens) are Solution-2 MINORS here, NOT decision drivers, because they do not run
  in the graded harness: `pnpm install --frozen-lockfile` reproduces ERR_PNPM_OUTDATED_LOCKFILE
  (golden never touches pnpm-lock.yaml, all ten agents do) and turf-mgrs ships no LICENSE while all
  115 packages carry one and packages/turf/test.ts checks each - both are merge-finalization, added
  when the real upstream PR opens, not task defects; do not let them alone carry an RC once the
  graded FPs are fixed. Base RE-PIN forward (fbf3942 Jul-2 -> aef8169 Jul-17, near-head) with the only two
  intervening commits untouching the feature dirs = clean freshening, run the BASE..HEAD scan to
  confirm it is not the reintroduce-landed-work fraud pattern. FP PASSED_WITH_WARNINGS with all
  three judges completing this round (vs only judge #1 last round, the exact point that broke the
  author's "the check is green" argument): re-derived every solo-judge-c dissent as underspecified
  (f=0 sphere, lat-84 one-sided-finite-difference metric throw, UPS-factors-no-UTM-throw) or
  REFERENCE_ALSO_FAILS (impossible-32X, 7-boundary-neighbors = zone-specific validity, the
  undiscoverable class), none a stated-contract violation. Narrowed codex's 11 solution items to 3
  by re-reviewing from scratch: most were fixed, the rest were untested edges codex had already set
  aside; a re-review inherits nothing unverified. Forge ops (turfjs pnpm monorepo): test.sh calls
  bare `tsx` which the Dockerfile installs with `npm install -g tsx@4.19.4`; a raw clone without it
  makes four-state falsely exit 1 with "tsx: command not found" (use `npx tsx` for standalone
  probes but install -g before any test.sh run). New-package source files are UNTRACKED, so `git
  checkout -- <file>` cannot revert a mutation; save a pristine copy first. Non-frozen `pnpm
  install --ignore-scripts` + the test.sh per-package build order (helpers -> mgrs -> projection
  closure) builds the dist the probes import in ~40s.

- 2026-07-19 (tinkerpop Cross-phase-type/label-scope verification, from-scratch Request Changes
  3/2/2): the near-miss blocker was an EXCLUDED base test that FAILS WITH THE SOLUTION, which reads
  exactly like "don't exclude valid tests your solution breaks" (T1) - but LambdaRestrictionStrategyTest
  failed 9/18 IDENTICALLY on the PRISTINE BASE under the same JDK 21 (its lambda detection is
  JDK-version-sensitive; repo targets 11), so the exclusion is legitimate, not a regression. Always
  re-run an excluded/failing base test on the pristine base with the SAME toolchain before scoring it
  a solution regression (rule 2 + JVM-JDK-from-CI); the corroborating tell was that the golden touches
  NONE of the failing steps (Order/Select/Choose/Sack/Lambda* grep=0), so a golden cause was
  mechanistically implausible. The sibling exclusion (StandardVerificationStrategyTest) PASSED on both
  base and solution = unnecessary-but-harmless narrowing, a good-to-have re-include, not a breakage.
  RC driver was a VALID Test Fairness lightbulb on STATED behavior that survives the full rigor:
  single-key select().by() positive typing is uncovered, and single-key vs multi-key select are
  SEPARATE code branches (SelectOneStep vs SelectStep), so the tested multi-key seed case does not
  cover single-key, and the one single-key negative test has bound==incoming type so it cannot
  discriminate an emit-a-map or seed-from-incoming impl; the description explicitly splits "single-key
  emits its by-modulator's output type" from "several keys yields a map", so single-key-emits-map is a
  realistic wrong impl that passes all 137 tests = returns per Karim. Demand-safety proven BOTH sides
  (apollo): probed the golden (accepts the bound!=incoming discriminator V().as(a).out().count().
  select(a).by(out()).out()) AND read the sole passer's analyzeSelectOne (seeds the by from the bound
  label). Lightbulb #1 (repeat invalid-body V().repeat(outE())) was a do-not-add on a STRONGER ground
  than "unspecified": it does not COMPILE in the typed Gremlin DSL because repeat(Traversal<?,E>)
  requires an E-preserving body - check whether a suggested test is even expressible before
  adjudicating it. FP PASSED_WITH_WARNINGS overruled dissent chased both ways: the adjudicator's
  "reference wrongly rejects a valid times(1)" did NOT reproduce on the golden (probe: times(1)/times(2)/
  no-times all accept), so it was a candidate remark, not a reference bug; both judge-c discriminators
  (VertexProperty-as-Element, repeat-depth tracking) are unspecified corners. Solution stayed correct
  on a full probe battery (no reference defect on any stated behavior), so Solution 2 rests only on
  dead lattice members (VALUE_OBJECT enum never produced -> 2 unreachable branches; ofVertexProperty()/
  getKinds() zero callers), found by grep total-refs=1 = definition-only. Stale-artifact hygiene: the
  Shipd description-warnings bot quoted "Element type rule."-style headings absent from the current
  description, and the per-run eval-result narratives cited a stale suite version (named tests that
  pass in the current 137-test junit) - used the actual test.patch + junit + probes. Prior-reviewer
  handoff = first-review posture: 3 of 4 v1 asks delivered+verified (ASF headers, select.by clause,
  broadened base), the 4th (empty-catch assertRejected discarding the VerificationException message)
  persists = second Tests point. Repo fit strong/native: TinkerPop ships a family of opt-in
  VerificationStrategy singletons; the new one registers only in the name-map + GraphSON, never the
  default set (no behavior change). Architecture observation NOT scored: golden distributes type decls
  across 38 step files via a new TypeInferringStep interface where the passer did it centrally in 5
  files - larger merge surface a maintainer might question, but consumed-not-dead, so an Illustrations
  note not a deduction (sqlite-utils don't-impose-taste). Forge ops: tinkerpop gremlin-core -am builds
  in ~45s with warmed deps, but surefire needs NETWORKED maven (drop -o) unless test-scoped deps are
  pre-cached; probe traversals must compile against the typed DSL (repeat/fold generic bounds bite).

- 2026-07-19 (dishka Explicit-Finalizer, from-scratch Request Changes 3/2/2): the RC driver was the
  MEANINGFUL-LOC FLOOR, and this is the first round it fired since the msw revert, so the discipline
  is worth recording. The golden is ~172 effective production LOC (count_loc lenient), ~130 once the
  ~40 repeated `finalizer=`/`finalizer_scope=` propagation lines + duplicated @provide overload
  params are stripped per the manager list; floor is 250. Corroborated THREE ways before I trusted
  it: count_loc (172), my hand count (191 added minus ~40 boilerplate), and the platform's OWN
  auto-review.json (`category: loc`, `severity: High`, "172 effective added lines ... below the 250
  floor"). The trap to resist: the same auto-review SYNTHESIS softens it to "advisory given the
  difficult 1/10 solve, no revision required solely for this heuristic" - that is the exact
  note-and-approve posture the msw revert killed, so an automated check AGREEING on the number while
  DISAGREEING that it blocks is not cover to approve. The passer-parity check turned padding-vs-small
  into small: the only passing agent's src-only production code is 175 lines, ~same as the golden, so
  the feature is intrinsically small, not inflated -> bump scope (Mars retired, no downgrade path),
  never reject (difficulty is real). Second finding class, and the reusable one for this repo family:
  RUN THE REPO'S OWN GATED LINTERS, and a from-scratch task can FAIL them where a polished revision
  (the sibling dishka Lifecycle-Observer task) passed. dishka CI (.github/workflows/setup.yaml) runs
  `ruff check` then `mypy` as gates before tests; base src is ruff-clean, the solution adds exactly 4
  (`PLC0415` x2 inline imports both avoidable since builder.py already imports dishka.provider at top,
  `SLF001` on owner._exits WITHOUT the repo's customary noqa, `E501` at 80 chars) and one real
  `mypy --strict` error (`_gen()` annotated Iterator[None] then `.send()` called - Iterator has no
  send, should be Generator); the test file adds 26 (E501-dominant + N818 _FinalizerErrorFallback +
  S110). Prove NEW-vs-inherited by stashing the patch and linting base (clean), and confirm the base
  repo's noqa CONVENTION exists (10+ `# noqa: SLF001` lines) so "missing noqa" is a real
  inconsistency not a taste call. These hold Solution/Tests at 2, not the RC driver, and absent the
  LOC issue this is Approve 3/2/2 (linters-not-clean = 2 per the sibling precedent). Suite strength
  earned Tests-behavior-3 by a 10-mutant battery (every stated clause caught: validation reverts
  1-3 fails, anchored walk-up disabled 27, wrong-value 25, no-register 55, two behavior-neutral
  mutants green) + empty Test Fairness lightbulb; the 2 is purely the ruff hygiene, stated as
  "conventions pass, not a coverage gap". FP judge-c (callable object as Provider class attribute
  used as finalizer) reproduced to a THIRD outcome (resolves fine on the reference, matching neither
  judge-c's "reference passes discriminator" nor the adjudicator's "0 factories both") = exotic
  unspecified corner, no action. Pure-Python so a local venv did everything (four-state, linters,
  mutations, probes); honest note that local base collects 491 vs platform 519 on missing optional
  integration deps (the standing dishka gap), decisive states verified directly. R8 caught a
  fabricated Env-Quality claim in my draft (I wrote "mvn-style tooling" copied from the spoon task;
  the real check is STALE, pytest passes offline, only `python -m build` fails on setuptools pins) -
  no-line-no-claim applies to the OPTIONAL checks too, open the section before describing it.
  Co-existence clean: same-repo siblings (observer-hooks events, cache invalidate()) are distinct
  feature slots from a per-dependency finalizer callback, both draft, different lessons; upstream
  clean (base==HEAD so gh API not range scan; no finalizer PR/issue, base has zero finalizer concept).

- 2026-07-19 (sqlmodel Add-typed-streaming-query, first-review-from-scratch Request Changes 3/1/1;
  my draft was 3/2/2 with a lint-gate driver and the owner's "if nothing's blocking why CR, you
  probably missed the real issue" push exposed BOTH errors). The real blocker was a GOLDEN BUG on a
  stated requirement that the ai-evaluation had flagged (two red checklist items: "Solution meets
  all requirements", "Tests cover behavior") and I had under-executed: the description says
  `yield_per` rejects non-positive/boolean/non-integer values "as an argument OR execution option",
  the golden validates only the ARGUMENT (`validate_yield_per(yield_per)`) and `effective_yield_per`
  forwards `execution_options["yield_per"]` unchecked -> reproduced `{"yield_per": -5}` returns ZERO
  batches (silent empty result), 0/True accepted as unset, 2.5/"3" raise a deep TypeError not the
  stated ValueError. This is the Pluggable-IMPORTRANGE one-directional-coverage class I am supposed
  to never repeat: I DID check the yield_per arg-vs-option matrix but only the "sets the default"
  direction (partitions==[2,2,2]); the "rejects invalid" direction I noted and never ran. EXECUTE
  BOTH directions of every stated equivalence, and when the platform's own ai-eval marks a checklist
  item red, chase that FIRST - it named the exact bug. The demanded test is clean by apollo
  both-sides: the sole passer (Nova #7) runs validate_yield_per on the combined arg-or-option value
  (its patch lines 78-82, verified not relayed), so the test keeps the valid solution and exposes
  only the golden; solvability holds. Solution 1 + Tests 1 (golden violates a stated requirement /
  its own bug passes the uncovered cell), not 2/2. SECOND error: I led the whole CR on the golden
  failing the repo's ruff-format + ty CI gates (real, reproduced with pinned ruff 0.15.20/ty 0.0.56,
  base clean) - but a lint/format/type-gate failure the platform does not grade and agents are not
  scored on is Solution-2 HYGIENE, a secondary note, NOT a standalone RC driver; I over-weighted it
  the same way spoon v4 over-weighted an ambiguous clause. When the only stated driver is
  "golden fails the repo's linter", stop and hunt for a real functional/coverage blocker before
  landing the CR. The lint finding stays in the review as a secondary Solution-2 item (ty gate =
  Astral's ty not mypy, found via scripts/lint.sh + .pre-commit-config.yaml; solution's
  `# type: ignore[code]` are mypy syntax vs the repo's `# ty: ignore`). Laziness triage held
  (colyseus): "streams instead of buffering" is uncovered but 4/5 failing agents + the passer stream
  via generators, so no realistic impl slips = good-to-have not blocker. Repo-fit re-analyzed after
  the push (my first pass buried it): no upstream dup, no maintainer ruling, but README documents a
  "thin layer... all SQLAlchemy's power underneath" and the transforms (map/filter/flat_map/take/
  skip/enumerate) are a foreign mechanism SQLAlchemy lacks (upstream-repo-fit Q3), repo in
  maintenance mode, community norm = wrapper libs (disc #1930) - a real concern, surfaced as
  Other-notes + Repo-fit tag, but NOT the hard blocker (socid: opt-in/additive/no-ruling is
  "heavier than taste"). Meta: a green FP check (PASSED, no dissent) does NOT mean no golden bug -
  the FP panel probes the PASSING run, not the reference; the ai-evaluation checklist is the channel
  that catches reference-meets-requirements gaps, read it fully every time. Pure-Python, four-state +
  all probes in a local venv, base==HEAD so gh for the upstream sweep.

- 2026-07-19 (pymongo opt-in-write-validation, manager-reverted v3-approve, re-review REJECT 0/0/0
  repo-fit): the reviewer who CANNOT reach the ruling channel must still resolve it, not defer it
  across rounds. Ziad ran three rounds (RC/RC/approve) each closing on "GitHub Issues+Discussions
  are disabled and we can't query JIRA, so should we reject or accept?" and shipped an approve with
  the fit question open; the manager did the JIRA search and reverted. Lesson: JIRA is PUBLIC-
  BROWSABLE (jira.mongodb.org/browse/PYTHON-NNNN via WebFetch), GitHub PRs stay viewable via gh even
  when Issues are disabled (gh pr view N returns state+mergedAt+comments), and the driver-spec repo
  (mongodb/specifications) is public, so an "issues disabled" repo is NOT an un-checkable repo -
  the R6 upstream sweep has three live channels here. Verified every manager citation first-hand
  before landing (timefold rule, and a reject must be airtight): PYTHON-2346 "replace_one does not
  validate all keys for update operators" = Works as Designed (the EXACT feature), PYTHON-1932/PR
  #479 closed-unmerged with behackett "disabled checking for dots and dollar signs across the
  board" in 3.12/4.0, PYTHON-1708/PR #385 Won't Fix, CRUD spec "driver only needs to check the
  first element ... the server will throw an error", and the base repo's own
  validate_ok_for_update (common.py:613) implements exactly that first-element `$` check. socid
  three-gate test kept it from being taste: gate 2 (strict maintainer rule) + gate 3 (contradicts a
  documented invariant) both FIRE, so it clears the "heavier than the maintainer wants" trap. Opt-in
  default-off does NOT cure a philosophy reject when the objection is categorical (drivers must not
  duplicate server validation = false confidence + inevitable drift; the hardcoded query-operator
  allowlist false-rejects any operator the server later adds) - read the maintainer's REASON, not
  just the default-behavior surface. Fairness on a reverted-approve: the author had cleanly fixed
  every prior-round craft item across three rounds (Decimal128 accepted, find_one_and_* scope creep
  removed, pipeline unknown-passthrough, copyright header, docstrings, isort, mypy generics) and the
  batch is healthy (1/10, 62/62 passer, baselines 483/483, FP one-genuine-pass), so the reject note
  leads with "the idea is the blocker, not the code" and gives the reusable fix (search JIRA for
  Won't-Fix/WaD before authoring a driver feature) - a duplicate/philosophy reject is never softened
  to RC so the author swaps the feature in-place (ohm rule), and the 0/0/0 is convention with the
  craft findings preserved in Illustrations for a possible overrule. Reject short-circuits deep
  R3/R4 but I still ran LOC (611>250), the run tally, and the plagiarism axis (mongomock candidate
  distinct: in-memory execution vs pre-flight validator) so the manager sees a complete pass. Pin
  ancestor of main, 17 behind, feature not landed = declined-not-shipped; no build needed (rule 6),
  said so. One check I attributed not re-ran: ruff format --check (not local, reject doesn't rest
  on it) - verification rule 9, state a check's status from the owner/manager not a guess.

- 2026-07-19 (sbi Bayesian-Synthetic-Likelihood, from-scratch Request Changes 3/2/3): the RC driver
  was a stated CORE behavior with zero coverage that a COUNTED PASSER demonstrably exploited, sourced
  from an FP judge-c dissent the adjudicator left unresolved (verdict rendered "unknown" while the
  aggregate counted the run genuine, PASSED_WITH_WARNINGS). The behavior: the description's first
  paragraph says the potential "re-simulates at every proposed parameter, reusing the estimate
  already held at the current parameter" (reuse scoped to the current param only); Nova_4 (PASS,
  43/43) shipped a persistent theta-keyed `_likelihood_cache` + within-batch dedup, so a repeated or
  duplicated parameter returns a frozen estimate - verified in its own solution-patch, not relayed.
  This is the CSS single-stylesheet pattern (stated behavior, zero coverage, passer exploits it, fair
  test closes it) and Leonard's exact FP definition, so RC even though caching still RECOVERS the
  posterior in the tested regime - the tell that it is a real defect not a benign mechanism is the
  EXPOSED public API (`synthetic_likelihood_based_potential` "for a custom sampler"): a caller using
  the potential in their own sampler gets stale estimates, an observable contract break. Contrast the
  spoon v4 correction: there the "side effect" line was NEVER DRAWN by the description (ambiguity ->
  approve); here re-simulation is EXPLICIT and scoped -> violation, not ambiguity. Demanded-test
  safety proven by reading before asking (apollo both-sides): reference has no cache (single
  `self.simulator()` call, fresh every eval), and the other value-passing passers' "cache" is only a
  docstring for the legitimate per-chain-state freeze in the SAMPLER (freeze belongs in the sampler
  variable, not the potential) - so the test keeps reference + valid passers, drops only the cacher
  (4/10 -> 3/10, still solvable). Scores stayed 3/2/3: Description and Solution had NO real minor
  after a term-by-term math check (Ghurye-Olkin `b(k)`/M/exponents all exact) and a bug hunt, so I
  did not invent one to hedge the RC (dishka never-invent rule); the single Tests cell in an
  otherwise-exhaustive suite is a 2 with an RC decision (go-pretty score-vs-decision split), not a 1.
  Second Tests cell = a real lightbulb: every shrinkage assertion uses the FACTORY directly, no test
  drives shrinkage THROUGH BSL, so a BSL that drops the forward passes (grep-enumerated all `BSL(`
  constructions). Fair-difficulty call on a 5/6 failure CLUSTER (init_strategy rejected): discoverable
  (desc says "returns an sbi MCMCPosterior", reference+4 passers use the real one) and self-inflicted
  (failing agents added `raise TypeError` on unknown kwargs) = integration difficulty, not a hidden
  requirement (woodpecker evidence-in-hand test). Ops: sbi is pure-Python but torch pulls ~1GB CUDA
  wheels on a CPU box; a counted-passer's exploit code + its green run is STRONGER evidence than a
  local mutation, so rule 6 said skip the build (it would only reconfirm). Pass rate 4/10 sits exactly
  at the 40 cap with failures concentrated in integration friction - held the bar, noted for the
  manager in Illustrations. Upstream clean (no BSL/synthetic-likelihood PR/issue/discussion); base ==
  current main so a BASE..HEAD scan proves nothing, used the gh API instead (timefold rule).

- 2026-07-19 (colyseus Tick-Locked-Command, from-scratch APPROVE 3/2/3; my draft said RC 3/2/3 on
  the two Test Fairness lightbulb cells and the OWNER'S "is it clearly in the description / blocking
  vs good-to-have" push flipped it, because BOTH cells fail the blocker test on rigor I skipped in
  the draft). Two independent errors, each the exact trap the earlier lessons warn about:
  (1) REACHABILITY before demanding a "both fire" ordering test. The combined session+global trim
  cell is UNREACHABLE: staging keeps total <= maxPending, a session trim removes exactly one, so
  after it total <= maxPending-1 and the global cap (checked >=) can never also bind on the same
  stage; reference (single session drop) and passer (session loop then global loop) both preserve
  the invariant, so a two-trim test would FAIL the reference. The fairness bot described a scenario
  that cannot occur = overly strict = skip (Karim). I had "traced" it as reachable in the draft
  without executing the arithmetic - a coverage suggestion is not a gap until you prove the scenario
  can happen in a correct impl. (2) TRIGGER REALISM is empirical (pynguin rule) and the agent
  patches answer it: the arrivalOrder-cross-tick cell is genuinely uncovered and stated ("gate-global
  from 0"), but ALL ELEVEN runs (pass + ten fails) declare one gate-global counter and reset only on
  close - nobody resets per tick, because a single counter is the path of least resistance for the
  wording. No realistic impl slips it => good-to-have breadth (bucket-b, Tests 2), NOT an RC driver.
  Grep every run's impl of the exact seam before scoring a coverage hole a blocker; "a wrong impl
  could pass" needs the wrong impl to be a shape someone actually writes. Net: a valid-and-skipped
  fairness item only returns the submission when the skipped behavior is stated AND a realistic wrong
  impl slips AND the scenario is reachable; failing any leg it is good-to-have (mention under Approve,
  no how-to) or skip-with-grounds. Karim's "overly strict OR covered elsewhere = skip" includes
  "describes an unreachable case" and "no realistic impl gets it wrong". Score stayed Tests 2 (the
  cross-tick cell is really uncovered, so not a manufactured 3) with Approve. Probe note: colyseus is
  a pnpm monorepo whose uWebSockets native binary needs GLIBC_2.38 the solve agents lacked, so a
  Docker four-state was disproportionate; the reachability proof was arithmetic on the invariant and
  the realism proof was reading all 11 patches - no build needed, and say so in Illustrations. Both
  FP judge-c dissents re-derived against the reference and dismissed as unspecified corners:
  throwing-epoch-hook (reference swallows via settleHook, prompt pins throw-handling only for admit;
  validation-atomicity holds because reconfigure validates synchronously before the enqueued op) and
  bad-options-on-already-open (reference validates unconditionally at Room.ts before the same-handle
  check, candidate skips, but "reject leaving closed" is scoped to from-closed and "returns the same
  handle" governs the open case = two faithful readings). Repo-fit judgment call: a same-repo `prediction` BRANCH with a `room.input()` experiment
  grep-hit for input symbols but is a CLIENT-SIDE prediction/reconciliation buffer in packages/sdk,
  complementary to this SERVER-SIDE staging gate, unmerged and 4 months old = distinct, not a
  duplicate (read the branch file's role, do not stop at the grep hit; connected-subrange rule). base
  == master tip (0 behind) so a BASE..HEAD scan proves nothing; used gh commits-since to confirm
  nothing landed. Description density fair for a whole-subsystem feature; declined the conciseness
  request_changes and description-warnings because the flagged closed-state and snapshot/hook-field
  enumerations are asserted field-by-field by hidden tests (contract-anchoring, jsdom-CSS precedent).
  Suite strength shown by the batch, not assumed: new-suite pass count spans 0/97..97/97 so the tests
  bite, near-passers (94/97) fail the subtle remove-before-awaiting-onInputPendingTrim ordering, 1/11
  overall. Solution 3 earned by a full 9-file read with every stated clause traced, not a green suite.

- 2026-07-19 (jsdom CSS-custom-property v1, from-scratch Request Changes 3/2/2): the RC driver was
  the SINGLE-STYLESHEET blind spot, an msw-class dimensional gap the platform's Test Fairness
  flagged and I confirmed by admit-test: all 67 hidden tests register inside one stylesheet, so a
  registry built from only styleSheets[0] passes everything while failing cross-sheet last-wins;
  and the removal test's title says "or its stylesheet" but only calls deleteRule, never removing
  the <style> element. Both are stated behaviors, both valid-and-skipped => returns per Karim.
  Safety proven before asking: probed the reference (removal 96px->1in, cross-sheet 7px/3px) AND
  read both passers' registry code (both loop styleSheets._list), so the added tests reject no
  valid solution and do not threaten solvability (apollo both-sides check). Forge was DOWN (HTTP 402
  billing on both codespaces); jsdom is pure JS so a LOCAL isolated worktree (git worktree at the
  pin + npm ci + npm run prepare) built it and ran every probe - remember pure-JS/Node repos never
  need the forge, only the Docker/JVM ones do. Chased BOTH overruled FP dissents against the
  reference (the codex-spoon rule): judge-c (keyword canonicalization) reproduced and became the
  Solution-2 note (substituted values skip specified-value case normalization: display:var(--x) with
  --x:BLOCK computes BLOCK not block; 10PX not 10px; colors reparse so they match) - but a hardening
  test there FAILS both passers, so it is a reference/description fix, never a demanded test (apollo
  judge-c mirror). judge-b (cycle closing only through an UNEVALUATED fallback: --a:var(--c,var(--b));
  --b:var(--a); --c:5px -> reference 5px, candidate '') reproduced too and the FP adjudicator called
  the reference "buggy", but I did NOT score it: the clause "even inside a fallback" is operationally
  DEFINED by the hidden test (--a:var(--b,safe);--b:var(--a,safe), primary refs + literal fallback,
  which the reference passes via an inCycle flag), the unevaluated-fallback-edge is an exotic corner
  the description does not pin, and browser-truth is genuinely contested (lazy fallback is defensible)
  - an adjudicator's "buggy" verdict on an ambiguous clause is an owner note, not an author ask.
  Description density on a genuinely huge feature (CSS custom properties + @property) is fair (Karim
  word-count rule); declined the conciseness request_changes and the description-warnings "still
  present" trims because the flagged clauses (readonly, cssText-omit) are TESTED and contract-
  anchoring, and the bot's "not tested" was stale. Base-mode blast radius note: base ran
  basics/fragment/methods (0 getComputedStyle refs) for a parser+computed-style change; the existing
  css-parsing-errors.js suite would give the touched area a real regression check (additive change so
  low risk, a robustness suggestion not a blocker). count_loc 540 golden vs 889/1164 passers = golden
  leaner, healthy.

- 2026-07-19 (dishka Lifecycle-Observer-Hooks, first-review-from-scratch APPROVE 3/3/3 after 4 prior
  reviewer rounds all RC on solution/tests): an all-3s on a multiply-RC'd task is defensible ONLY
  when earned by a mutation battery, not by reading a green suite. I reverted eleven stated behaviors
  one at a time on a snapshot of the solution and every discriminating clause bit (stop-on-first
  finalize=2 fail, parent-includes-self=16, no-prebuilt-observe=1, gen-notify-before-register=1,
  markers-observed=3, alias-variant-not-unframed=2, alias-body-emits-event=8, async-child-no-inherit=1,
  seq-constant=4, when-selector-not-framed=4, depth-zero=12); two behavior-neutral mutants stayed green
  and confirmed the harness does not false-positive. That IS the evidence for Tests 3 (msw-v3/
  risinglight precedent: all-3s allowed after mutation scrutiny finds nothing above pedantry; do NOT
  invent a minor to force a 2). Mutation hygiene that mattered twice: (a) VERIFY THE MUTANT ACTUALLY
  BIT before trusting a survivor - my first async-inheritance mutation string did not match (grep for
  the inserted marker showed absent), read as a coverage gap, and only re-doing it at all 3 child
  sites revealed the test catches it; a surviving mutant is worthless until you confirm it changed
  behavior. (b) SCOPE THE MUTANT TO A NATURAL WRONG IMPL: forcing `_is_observed(alias)=True` survived
  because the alias body never calls the observe hook (behavior-neutral reframe), whereas making the
  alias body actually emit an event (the realistic bug) failed 8 tests; an artificial mutant that
  happens to be behavior-neutral is not a gap. Lightbulb triage on this task = all three non-gaps:
  default-omitted-observers is covered by all 501 base tests calling make_container without observers;
  async inheritance by an existing nested async test (mutation-confirmed); both-errors-surfaced is
  BEYOND the stated "does not stop remaining observers or teardowns" (read the exact clause, then the
  exact test assertions - the finalize-error tests assert all-ran/both-finalized, never both-surfaced),
  so it pins unspecified behavior = do-not-add. FP PASSED_WITH_WARNINGS re-derivation, three overruled
  solo dissents, all object-lifetime/provenance corners the description never pins: the discipline is
  to CHECK ON THE GOLDEN what you can (the `if not observers: return` guard = the memory-retention flag
  is candidate-only; `_observe_prebuilt` passes parent=None/depth=0 by construction = the static-eval-
  chain probe is non-discriminating), reproduce the NORMAL paths by probe (generator LIFO, lazy chain
  provenance both correct), and NOT overclaim you "reproduced" the exotic probe when you actually read
  the mechanism - the R8 fresh-eyes gate caught exactly that overstatement in my draft (a reentrant
  probe that hit a cache and proved nothing) and I rewrote it to say read-vs-run precisely. A SPEC_GAP
  where golden + every passing agent CONVERGE and only the adversarial probe demands otherwise is
  bucket-c unspecified (go-pretty), not the react status-0 spec-fork (which needed two FAITHFUL readings
  to diverge); convergence is the discriminator between "note it" and "skip it". Repo-check closure is
  part of the maintainer-merge bar (Elabyad): prior rounds flagged ruff + mypy, so I ran BOTH under the
  repo's own config (`select=["ALL"]`, mypy) on the changed files - clean, which is what let Solution
  reach 3; run the repo's actual linters, do not eyeball. Pure-Python DI task ran entirely in a local
  venv (pytest 9.0.3 / pytest-asyncio 1.4.0), no forge needed; honest note when local base collects
  fewer than the platform (missing optional integration deps) - base-green then rests on the 10 runs at
  501/501, fail-on-base and pass-on-solution verified locally (the decisive states).

- 2026-07-18 (pynguin callable v6, terminal Approve 3/3/3 closing a six-round arc): the cheapest
  airtight closure proof for a revert-style ask is BLOB-HASH IDENTITY - the fixed test.sh carries
  the exact index hash (164771bb) of the last known-good version, so "reverted byte-exactly" is one
  grep, no re-execution of the unchanged combination needed (the v5 suite ran locally, the trio ran
  32/32, and the fresh batch's ten 4256-node baselines prove the restore live in-image). Second
  live-catch confirmation of the arc's central claim: the restored tests caught TWO fresh runs this
  very batch (over-broad convert branches failing test_convert_type_hints[A/Any/NoneType cells]),
  the asked-fix-becomes-discriminator pattern for the third time on this task. FP-panel discipline
  compounding: the round's SPEC_GAP_REFERENCE_ALSO_FAILS tag re-derived to a SHARED unstated edge
  (defaulted positional treated as required by reference AND candidate identically; the stated
  CallableType model has no optionality slot, the same stated-by-composition logic as the varargs
  cell, in the opposite direction) - the tag is a lead, and when both families agree and nothing
  pins the cell, it is not a golden-vs-description mismatch and carries no deduction. Probe
  re-derivation caught two unfair solo-judge probes again (next_float pinned into the 15% fallback
  tail; monkeypatched randomness.choice against stochastic mutation the suite bounds with 50-try
  loops). All-3s on a six-round task follows the IMPORTRANGE terminal precedent: earned by
  execution-proven closure of every prior finding plus written adjudications for every contested
  cell, stated explicitly in Illustrations so the manager sees the confidence is scrutiny, not
  fatigue - and no minor is manufactured to hedge the history.

- 2026-07-18 (spoon faithful-constant-folding v4 CORRECTED RC->Approve 2/2/3 on the owner's
  where-is-the-blocker question; supersedes the RC framing in the entry below, the probes and
  method stand): the blocker's STATED leg must survive a hostile reading before anything is
  scored a violation. My draft read "an operand that may have a side effect is never discarded"
  as forbidding the reference's `(x/y)*0 -> 0` fold; the sentence's own enumeration (array
  access, constructor call, call hidden in an index) never draws the may-throw-arithmetic line,
  the author drew it knowingly (their suite's x/x rationale proves throws-awareness), the
  conservative passer drew it oppositely and is equally green, and the FP adjudicator had
  formally ruled the cell non-blocking and not-required-by-task while upholding both passes. An
  adjudicator's TASTE remark ("reference is actually unfaithful") is not a contract ruling; the
  formal verdict line is. Definitional ambiguity on an enumerated clause = open corner (react
  status-0 class) = Description 2 disclosure note under an Approve, never an S1 violation; and
  when BOTH divergent families are represented among green runs, the wrong-solution leg is empty
  by construction. Checks-did-not-flag is evidence, not deference: FP judges run-level
  legitimacy, fairness judges hidden-test fairness, and neither owns unstated corners, so their
  silence on one is consistent with either disposition; what they DID formally rule (non-blocking)
  binds harder than what their prose implies. A lightbulb suggestion that would fail the current
  reference is unfair-as-written, not valid-and-skipped: it cannot force an RC, and its
  do-not-add-as-written grounds live in Illustrations per the issues-only convention. Same
  session hygiene: the approve rewrite keeps the executed evidence (probes, closure mutant,
  control cells) in Illustrations as the per-clause enforcement map plus named residual risks,
  and drops every wrong-solution-passes phrase from author-facing text per the msw
  self-contradiction rule.

- 2026-07-18 (spoon faithful-constant-folding v4, RC 3/2/2): an OVERRULED FP-panel dissent can carry
  the round's Solution finding from the REFERENCE side: judge-b's division-purity probe was ruled
  unfair to the candidate, but the adjudicator's cross-check reported the reference folding
  `(x/y)*0`, `(x%y)*0`, `(x/y)-(x/y)` to 0 (drops the y==0 ArithmeticException); re-derived by my
  own probes incl. the short-circuit variant `(x/y==1) && false -> false`, root = isPure recursing
  through DIV/MOD binaries. Chase every overruled dissent BOTH ways: against the candidate (was the
  overrule right) and against the reference (what did the probe reveal about the golden). Fix-safety
  proof came free from the batch: the conservative passer (uniform DIV/MOD-effectful) is 94/94 +
  2029/0, so the guard change cannot zero solvability. Second finding shape worth naming: the
  KEEP-vs-WRAP control probe: when a clause covers a rewrite family and the guard exists on the
  operand-keeping branches only, probe the wrapping branches WITH a keep-side control (`Boolean
  b ^ false` stays, `b ^ true` -> `!b`), a two-cell executed proof that the guard is missing, not
  misread; pair the contingent lightbulb test with the fix ordering explicitly (adding it first
  would fail the reference). Closure method confirmed again: re-running the PRIOR round's mutant
  against the new suite gave the exact four-test kill fingerprint. Conciseness bot wrong on NEWNESS
  twice in one round (demanded deleting the factory-typing and printer sentences as "existing
  behavior"; base sets no factory type, that is issue #5334's ask, and base prints `--5`); grep base
  before honoring any removal. Healthy author-response class to closed enumerations: v4 REMOVED the
  v3 extras (`x|x`, logical self-folds, `x%1`, single `+x`) instead of stating them, and pinned the
  exclusions with negative-contract tests. Forge ops: codespace /tmp is wiped on restart, keep
  drivers self-sufficient (clone-if-missing) and recreate the workspace before cp.

- 2026-07-16 (pynguin callable v5, Request Changes 3/1/3): a TEST.SH COMMENT'S TECHNICAL CLAIMS GET
  EXECUTED like any other claim, and this one was false three ways: it justified deselecting three
  base tests as "index-parametrized node IDs renumber when CallableType adds a Callable case", but
  the parametrize lists are static literals, the base file has ZERO `Callable` occurrences, and all
  32 cases pass with the solution applied (run, not read). The deselected trio was also proven
  load-bearing in the wild (v3's Nova #1 over-broad convert branch was caught by exactly those
  cases), so the deselect removes a live regression net on a false premise = Tests 1, restore-and-
  delete-the-comment. Bonus in the same comment: "See REVISIONS.md round 28" cites the author's
  private revision journal, absent from the base tree - grep the repo for any file a patch comment
  references; process leakage into graded artifacts is the platform's own no-quest-references rule.
  My draft's second blocker was RETRACTED on the owner's is-it-really-blocking push, and the
  correction is the round's real lesson: STATED-BY-COMPOSITION IS STATED. The unasked new test pins
  that varargs annotations are ignored ((*args: str) -> int matches Callable[[int], int]); five runs
  failed on it alone and mypy rejects that reading, so I called it an unstated cell. Wrong lens:
  fairness is judged against the DESCRIPTION'S OWN MODEL, not external typing standards, and the
  behavior follows from composing two stated clauses ("a *args/**kwargs signature has unknown
  parameters" is unconditional + "an unknown-parameter callable acts as a wildcard for compatibility
  in subtype checks and generator lookup") while the stated CallableType API has no slot that could
  even carry the annotation; the annotation-checking reading contradicts a THIRD clause ("Fitting
  follows the same variance as any callable subtype check"). My raw-signature-side-check steelman
  broke on that third clause. The three-source verification that settled it: derive from the model,
  read the checker's independent ruling (ai-eval: fair, a hint "would merely repeat language already
  in the task"), and sweep every tripped trajectory for deliberation (zero hits = unreflected slip
  against language in hand = difficulty, the woodpecker standard). Do all three BEFORE writing a
  fairness blocker on a dominant cell; and never ask for a description clause that repeats existing
  language (over-specification, the woodpecker corollary). Also confirmed: baseline-count arithmetic
  is a cheap deselect detector (4256 -> 4224 = 32 = exactly the three tests' cases); a pass rate
  halving right after unasked suite additions is the tell to hunt the new tests first; and an FP
  PASSED_WITH_WARNINGS solo dissent was again out-of-contract (keyword-only params: unmentioned in
  the prompt and the REFERENCE mishandles them symmetrically - a shared unpinned edge is not a
  discriminator, per the adjudicator and my own re-derivation).

- 2026-07-16 (pynguin callable v4, Request Changes 2/3/3; owner caught a v3 miss): VERIFY-THE-FIXES
  WALKS SUB-ITEMS, not asks. v2's Description item 2 had two halves (code spans whole + sentences
  break naturally); the author delivered half in v3 and I scored Description 3 without re-walking
  the other half, so the still-broken hard-wraps ("Given a", "into", "Also expose", "A reused
  value's statement is" dangling at line ends) sailed through a round and the owner had to flag
  them. Decompose every prior ask into its atomic requirements and tick each one against the
  current artifact; a half-delivered ask is an OPEN ask and returns the submission like any other
  skipped item. The RC framing that makes a formatting-only round defensible: the driver is
  "a v2 review ask unaddressed after two rounds and a direct reminder", not "new cosmetic nit",
  and the requested edit is whitespace plus one hedge with zero contract clauses touched (staleness
  is the only cost, say so in Illustrations). Closure verification stayed cheap under time pressure
  by re-running only the KILL-mutants for the prior asks (defaults mutant dies on the extended
  test, ANY-return mutant dies 3/3 on the new str-based test) plus mypy with a walk-up on the one
  residual error (identical message at pristine 2058 vs patched 2185, and 2185 is base
  convert_type_hint code shifted by the insertion, so zero errors on added lines). Honest 3s after
  an RC history: Tests/Solution got 3 because every prior gap is mutation-killed and the delta is
  exactly the asked fixes; the one blemish (a six-line narrating comment, the only comment in a
  932-line test file, explaining a probability-pinned mock I verified is accurate) stayed unscored
  per the never-invent-a-minor rule. Also: a description-warning bot block can quote the PREVIOUS
  round's wording (stale against the current description); and "should be able to" in a spec is a
  hedge worth folding into an already-open description edit, not a standalone item.

- 2026-07-14 (pynguin callable v3, Request Changes 3/2/2; my draft said Tests 1 and the owner's
  "is it really blocking?" push exposed TWO over-claims in one reason, both caught by finishing the
  bucket test instead of stopping at "a mutant passes"): (1) MUTANT CONSEQUENCE MUST BE EXPORTED, NOT
  ASSUMED - my "generates a value even for a None return type" mutant renders `var_0 = None` then
  `lambda *args, **kwargs: var_0`, i.e. the callback still returns None; one extra statement, zero
  behavior change. Run the mutant's OUTPUT through the feature's real export/execution path before
  calling it a wrong result. (2) TRIGGER REALISM IS AN EMPIRICAL QUESTION, and the agent patches
  answer it: all ten independently wrote `if not isinstance(return_type, NoneType):
  _create_or_reuse_variable(return_type, ...)`, so the "return value built from an unrelated type"
  mutant, though a genuinely wrong result, is a shape nobody plausibly writes when the description
  states it and the base factory makes the correct path the path of least resistance. Passer
  correctness never cures a gap (mold), but the msw discriminator still needs BOTH halves: non-exotic
  trigger AND wrong result. Grep the failing runs' implementations of the exact seam before scoring a
  coverage hole a blocker. Result: the gap stays an asked good-to-have, Tests 2 not 1, and the RC is
  carried by the VALID uncovered fairness suggestion (make_callable_type defaults: a mutant changing
  only the return_type default from Any to None passes 54/54) per Karim's valid-and-skipped rule plus
  the socid precedent that lightbulb edges keep Tests at 2. Method that stands: after any test
  DELETION, re-derive what that cell enforced and mutate the reference to see what now slips (here
  the author aligned desc+reference+tests DOWNWARD without being asked, correctly, but left the
  return-value contract uncovered; the deleted test must NOT come back, it asserts behavior the
  reference no longer has, so the ask is a replacement guard). Ask fairly: pynguin's numeric tower
  yields `bool` for an `int` return type (the FP judges hit exactly this, tried the strict int probe,
  and dropped it because it fails the REFERENCE), while `str` is deterministic 60/60, so the ask names
  the property and the trap instead of prescribing a fixture. New standing check worth its cost: RUN
  THE REPO'S OWN CI GATES against the patched tree with a pristine control - pynguin gates mypy in CI
  and the patch adds four mypy errors on added lines (two unused `# type: ignore[arg-type]` in the new
  structural_eq methods; a `list[tuple[object, object]]` in FunctionReferenceLocalSearch.search making
  both write-backs incompatible-type) while the pin is clean for those files and ruff adds zero. That
  is an executed Solution-2 no platform check reports, and it is a second, independent "a maintainer
  would not merge this" reason under the RC. Also: an FP-panel solo dissent chased to code was an
  UNPINNED OPEN CHOICE, not a finding (reference enforces the fixed-prefix minimum inside
  `_SubtypeVisitor.visit_callable_type`, which `get_functions_for` calls; the candidate short-circuits
  is_subtype and enforces the prefix in its own fitting path; `convert_type_hint` never builds the
  hybrid, so only a hand-made `make_callable_type` exposes it and both readings satisfy every stated
  behavior) - no action, and a test there would pin an unstated cell and fail a legitimate passer.
  Executed-matrix paid off in the SKIP direction too: the lightbulb's "opposite matching direction" is
  covered elsewhere, proven by a mutant returning False for is_subtype(unknown, concrete) failing two
  get_functions_for tests. Env trap: a local venv at Python 3.10 renders `lambda :` with a space from
  `ast.unparse`, so the known-empty-arity export test fails in every local run and every mutant;
  establish that artifact once (both passers are 54/54 in the image) and read every mutant against it.
  Style correction from the same round (applies to ALL reviews): author-facing reasons carry the
  DEFECT then the FIX, never the process ("I ran the suite against two mutated references" is
  Illustrations material); one issue, a few short sentences, no narration.

- 2026-07-14 (apollo-client built-in list helpers v2, Request Changes 3/1/2): the round-2 blocker
  was the lightbulb item I had waved through in v1 as "optional", and the mutation is what turned it
  from a suggestion into a blocker: replacing the reference's `startIndex < 0` incompleteness guard
  with `Math.max(0, endIndex - last)` left the full 45-test suite GREEN while a short backward slice
  came back reported as complete, and 5 of the 10 runs in the batch had written exactly that clamp.
  Re-adjudicate EVERY carried lightbulb item against the current batch instead of copying the prior
  call; a skip is only earned by an executed admit-test. Two safety checks that made the ask clean:
  the golden reports incomplete (so the demanded test cannot fail a valid solution) and the SOLE
  passer also guards correctly (so hardening does not zero out solvability) -- always run both before
  demanding a test, because the mirror case appeared in the same review: the FP panel's overruled
  judge-c dissent (passer skips first-write cursor dedup) was REAL but I did NOT ask for it, since
  the trigger is a malformed connection no server emits and a test for it would have failed the only
  passing agent, taking the task to zero passes. Execution also KILLED my own strongest lead: I
  expected `prependPagination`/`mergeUnique` to violate the stated "dropping evicted entries" clause
  because they ship no read function, but a probe showed the cache drops dangling refs on its own
  (read returned A,C after evicting B) -- the Pluggable-IMPORTRANGE rule cuts both ways, an unexecuted
  asymmetry is not a finding either. Fairness of a 9/10-failing test is settled by the repo, not by
  the failure count: base `relayStylePagination.merge` splices a `before` page at its anchor
  (pagination.ts:225-226) in the same file the new helper is appended to, so the behavior is
  discoverable and the cluster is difficulty; the same read also exposed the Solution-2 (the new merge
  prepends to the head instead of splicing at the anchor, probe-proven wrong order + wrong re-read).
  A criteria change can WITHDRAW a prior round's blocking ask: v1's LOC bump-or-Mars (375 vs the old
  400 floor) is moot at the 250 floor, and that withdrawal is one of the rare cleared-gate facts that
  DOES belong in author-facing Other notes, because silence would have the author padding scope.
  Manager rule landed 2026-07-14: cite the violated platform-doc IDs (T3/T4/S2...) in every reason.

- 2026-07-13 (react Support-URL-and-Fetch v2, Approve 2/2/3, owner refinement of the approve
  shape): under an Approve, EVERY sub-3 reason is a note without recommendations (the lazygit
  Solution-only rule generalizes to Description and Tests), and Other notes carries no
  bot-adjudication cautions (a rejected conciseness verdict is Illustrations material only,
  nothing for the author to act on under an approve). The reviewer's burden that replaces the
  asks: an explicit per-clause enforcement map in Illustrations proving no incomplete or buggy
  solution passes the shipped suite, with the residual risk named (here: the only silent-pass
  shape on the status-0 spec gap is a deliberate status clamp no run exhibited). Also confirmed
  this round: a SPEC_GAP_REFERENCE_ALSO_FAILS caveat from the required FP check files as a
  Description 2 note (spec-vs-solution placement per the msw rule) when no hidden test pins
  either direction and both support and reject pass; and the v1 base-mode ask proved live in the
  wild (4 FAIL_REGRESSION runs under the full-file base mode, one passing all 16 hidden tests
  while breaking 7 base keying/debug-info tests, the exact false-pass class the thin filter
  admitted).
- 2026-07-13 (univer Pluggable-IMPORTRANGE terminal round, Approve 3/3/3 closing the v5-revert +
  v6-RC arc): the way you EARN a clean approve on a reverted task is to make the closure
  mutation-proven, not reasoned. The core solution was byte-identical to v6 (verified by extracting
  both patches and diffing; only locale translations changed), so the whole review reduced to: did
  the new tests kill the exact wrong-solution I flagged? I re-applied my own v6 mutant (registration
  stores keys raw) on the forge and confirmed the v7 suite now fails the two tests I named
  (`register $B$2 / request B2` and the listRanges-canonical test) while the single-cell test still
  passes on the mutant, the precise fingerprint of the closed gap. Then a second mutant (drop the
  sheet-scoping guard) confirmed scoping is enforced too. THREE 3s were the honest call only because
  the full bidirectional matrix ran green on the pristine reference AND both plausible mutants died;
  I wrote that reasoning into the Illustrations rather than manufacturing a minor to hedge the
  history (writing-style: never invent a 2). Other reusable bits: (a) an FP PASSED_WITH_WARNINGS
  dissent about a HELPER API called with `{rangeText:'A1', sheetName:'Beta'}` was out-of-contract
  (prompt says unqualified rangeText implies sheetName undefined) and agent-side, re-derived by
  tracing the reference's getRangeLookupKeys, not relayed; (b) the FP report's "Nova #1" ordinal is
  NOT the local folder Nova_Nova_1, match by run-id (it was Nova_Nova_4); (c) ai-eval "N runs" can
  exceed the downloaded set (11 vs 10) because the platform counts an invalid/empty run, ratio
  unaffected; (d) a conciseness bot can SOFTEN across rounds (request_changes -> minor_suggestions)
  as a description converges, still declined because the trims unpin contract clauses.

- 2026-07-13 (timefold usage-weighted connected ranges, post-manager-revert resubmission, Reject):
  a manager revert on upstream-duplication grounds is judged on the resubmission's CENTER, not its
  polish: re-derive every citation first-hand (PR diff read in full, maintainer comments verbatim,
  issue sketch, discussion), then ask whether the current version's deltas create a new central
  problem; here every delta (reduceSubranges, incremental captured usage) was the maintainer's own
  written review feedback on the cited PR, and "maintainer feedback implemented" is deeper
  continuation, not differentiation. Walk-up rule paid off at intake: base has a class literally
  named ConnectedSubrangeIterator, which nearly read as feature-already-in-tree; its next() loops
  until the active count reaches zero and returns whole ConnectedRangeImpl components (call sites
  getConnectedRangeStartingAt / getNewConnectedRanges), so the name is a 2024 rename artifact, not
  the submission's per-window concept. Concept-name grep hits in base are resolved by reading the
  enclosing type's role, in both directions (false already-in-base is as costly as false absent).
  Clone-pinned-at-base trap: when fetch-info clones at the pin, HEAD == BASE and a BASE..HEAD range
  scan silently proves nothing; the nothing-landed-since-pin proof is a gh API commits query with
  path+since filters against upstream. Channel blind spot to remember: plagiarism check "skipped,
  no_candidates" plus bot auto-approve (skip_human_review) is exactly the combination that let this
  reach finalizing; upstream-side duplication is invisible to the related-submissions checker, so
  on any bot-approved task the R6 upstream sweep is the un-delegable human part. Batch shape for
  the record: 9/9 failing runs failed the identical four duplicate-retraction tests while all ten
  solved the other 37 cells, the signature of a publicly documented design plus a complete
  description; under the reject that stayed recorded context, not a driver.

- 2026-07-13 (spoon faithful-constant-folding v3, RC 2/2/3): the executed-matrix rule caught its
  first pre-submission revert-class hole: the v3 description's "When one side is a literal"
  umbrella states position-independence for EVERY rewrite, the suite pinned literal-on-right for
  all but three cells, and a literal-right-only mutant passed 56/56 while the probe suite failed
  it and passed the reference; the platform fairness lightbulb independently named the same cells
  (derive the matrix yourself FIRST, then use the lightbulb as convergence evidence, not source).
  Two method corollaries. (1) MUTANT SCOPE = CLAIM SCOPE: my mutant gated only the numeric branch,
  so `true == b` still simplified under it; the draft claimed the mutant broke the boolean mirrors
  too and the R8 claim-check caught the over-claim; enumerate which cells a mutant actually
  disables (read its control-run violation list) before writing the cell list author-facing;
  reading-proven cells get stated as absence-of-assertion with the mutant as executed
  representative. (2) A multi-run driver log interleaves probe output: a [VIOLATION] line in a
  combined tail can belong to the mutant CONTROL run, not the reference (my C3 scare); fetch
  per-run logs before reacting. Recurrence-one-level-down confirmed again (IMPORTRANGE pattern):
  v1's mirrored-regrouping ask came back as the unqualified grouping sentence vs the
  sign-preserving-only implementation (2-x+3, 3-(x+2) recorded untouched by probe; filed as
  Description 2 pick-one-contract per the msw rule). New-clause blast radius is a base-mode
  question too: the v3 diff grew into DefaultJavaPrettyPrinter while base mode still ran only
  EvalTest; the safe-ask proof is running the repo's printer suites against the applied solution
  on the forge (green, incl. one pre-existing @Disabled skip verified at base). Constructed-node
  print risks (arithmeticNegate building NEG(NEG(x)) with no re-cancel) dissolve against BOTH
  printer paren paths (default parent-unary rule + RoundBracketAnalyzer YES) but only for
  operator operands, negative LITERALS lacked protection, which is exactly what the author's
  bracket fix adds; execute the print probe anyway. Forge ops: spoon-core needs no docker for
  reference probes, plain networked Maven + sdkman JDK 21 compiles and runs targeted suites in
  ~50s; work under /tmp (109G) not the 79-percent-full overlay.

- 2026-07-12 (athens Stored-Artifact-Integrity v4, Approve 3/2/2; first full application of the
  executed-matrix rule): enumerate every stated transition/equivalence as a MATRIX and execute the
  cells the suite doesn't reach on the REFERENCE (forge probes): save-transition 2x2 (the
  Save-then-SaveVersion reverse cell) and record-vs-artifacts grid (the record+partial per-backend
  cell); the executed partial probe is what separated "Tests 2 breadth" from "hole" (reference
  classifies correctly, only per-backend coverage missing). Matrix scoping includes REACHABILITY:
  base mongo.Save rejects existing versions (KindAlreadyExists), so the legacy-overwrite
  transition is unreachable on mongo and its missing invalidation is correct, not a gap. Forge
  ops: verify-remote.sh's two-image four-state dies on disk for vendored-Go repos (each image
  bakes the vendor tree; prune first, the forge accumulates junk); the platform-faithful lean
  shape is ONE pristine-tree image + `git apply` of both patches in-container (COPY ships .git),
  which also proves the dockerfile's works-without-patches requirement. Compile-fail-on-base is
  the correct Go shape when a prior round demanded direct compile-time calls of new symbols; the
  harness must synthesize the per-test JUnit (grep func names from the test files) - verified
  live: 108 enumerated failures + exit 1 on base, real assertion output in failure bodies
  post-solution. A conciseness-bot HIGH item can be wrong about NEWNESS, not just
  contract-locking: it called the new SaveVersion validation clause "existing behavior
  discoverable in the codebase" while `func SaveVersion` has zero base matches; grep base for
  existence before honoring any removal ask. Two walk-up saves: external-client
  panic-on-EscapePath is the base sibling's own idiom (client.go:87), and the stasher's
  Semver=="" fallback is load-bearing for the BASE suite (the mock fetcher returns empty Semver;
  Nova #6's trajectory derived the same constraint) - check base-suite compatibility before
  calling a guard unexplained defensive code. Fresh-batch pattern confirming pynguin: prior-round
  asks became the dominant discriminators (the legacy-save pair failed in all nine failing
  junits, four runs failed ONLY it); stated-clause concentration with a legitimate passer and a
  clean FP panel is difficulty, not ambiguity.

- 2026-07-12 (univer Pluggable-IMPORTRANGE v5 APPROVE REVERTED by manager; v6 re-review RC 3/2/3):
  the revert class is ONE-DIRECTIONAL COVERAGE OF A STATED EQUIVALENCE, and it is now a mandatory
  R3/R4 audit: every clause of the form "X and Y refer to the same thing" (single-cell C1/C1:C1,
  absolute $A$1/A1, trimmed identifiers) gets a register-side x request-side matrix, and BOTH
  directions get EXECUTED, not read. The v5 miss: I noticed the single-cell test covered only
  register-C1/request-C1:C1, wrote it off as "minor breadth" in my head, and never ran the inverse;
  register C1:C1 + request C1 hit #REF! because registration stored raw keys while only the request
  side canonicalized. A NOTICED asymmetry that is not executed is not adjudicated: probe it or ask
  for the test, never dismiss it silently. Corollaries from the v6 pass: (a) the SAME class
  recurred one level up in the author's own fix round (new absolute-marker clause tested request-
  side only; a string-collapse mutant passed 33/33 while register-$B$2/request-B2 returned #REF!;
  proven by forge mutation + probes, reference correct, so Tests 2 + RC per go-pretty score-vs-
  decision split); audit every ADDED clause bidirectionally too. (b) Title-diffing under-reports
  test deltas: the token-dispose coverage arrived as an in-place BODY reshape of the cache test
  (two-disposable sequence) with the title unchanged; diff bodies, not titles. (c) Forge probes on
  a pnpm monorepo need the dependent package's workspace closure too (filtered install broke the
  hidden spec's cross-package source imports; widen --filter, or the false FAIL is your harness).
  (d) The author canonicalized my previously-adjudicated open choices (token dispose, empty lists)
  by STATING them; re-audit every newly stated clause instead of carrying the old "unpinned" call.
- 2026-07-12 (Add-Atomic-JetStream reply postmortem, author accepted the reject but corrected one
  claim): before quoting ANY code line in an author-facing rebuttal, WALK UP to the enclosing
  function/branch and name it; my dedup rebuttal quoted real lines that lived in
  fastBatchRegisterSequences (the non-atomic path) while arguing about atomic batches, whose
  checkMsgHeadersPreClusteredProposal REJECTS duplicates (error 10201). A grep hit proves the text
  exists, never what path executes it; the enclosing-scope walk is now part of the claim check for
  every quoted line, same family as the cleo context-pull rule.

- 2026-07-11 (ohm rule-alternative-coverage, RC flipped to Reject on the next round): two misses in
  my RC that the codex re-review caught, both verified true by me afterward. (1) MONOREPO TARGET
  CHECK is now mandatory at R0 for any multi-package repo: read the touched package's package.json
  (name + private) and the repo's release/migration docs BEFORE grading anything. Here
  packages/ohm-js was renamed ohm-js-legacy and marked private:true by merged PR #555 (2026-02-14),
  the public ohm-js is packages/runtime (v18 wasm), and doc/releases/ohm-js-18.0.md lists Matcher,
  pexprs, and grammar.rules under Removed APIs, the exact surfaces the solution and tests use. A
  feature added to a private retired package reaches no user and no maintainer would merge it;
  that is a documented ruling, not reviewer taste, and nothing in the submission is fixable in
  place (v17 retarget = new base = new submission; v18 = new design). I had even read the
  package.json name field (used it to explain the pnpm filter) and never checked private: reading
  a file for one purpose is not reading it for the fit question. (2) The plagiarism candidate
  AUTHOR field is part of the co-existence test: the older accepted coverage task was by the SAME
  author, which puts the case under the frostdb same-author standard (shared engine = shared slot,
  deltas like one-shot lifecycle/merge/ratios are bookkeeping, older accepted keeps the slot). My
  coexist call weighed API-shape differences over the 4 shared purpose-matched surfaces and 3
  shared GRADED test behaviors; shared graded behaviors outrank surface deltas (hocuspocus rule),
  and same-author changes the question from "can these coexist" to "is this the same idea sold
  twice". Also: a duplicate reject is never softened to RC so the author can swap the feature
  in-place; review history must stay attached to one idea (archive and pivot).

- 2026-07-12 (nats-server Add-Atomic-JetStream, reject HELD through dispute; one rebuttal claim
  WRONG and conceded): rule-2 context-pull applies to MY OWN dispute rebuttals, not just intake
  findings. Refuting the author's "#7391 rejects duplicate IDs" I grepped duplicate/skip in
  jetstream_batching.go, quoted the skip-and-ack PubAck path, and never walked UP to the enclosing
  function: it was fastBatchRegisterSequences (the NON-atomic fast path), while the atomic path
  rejects via checkMsgHeadersPreClusteredProposal -> NewJSAtomicPublishContainsDuplicateMessageError
  (batching.go:608/616, test :568). The fastBatch fields (sseq/pseq/pending) were visible in my own
  excerpt and should have triggered the check. In a subsystem with SIBLING VARIANTS (atomic vs fast
  batch; sync vs async paths), any behavior claim must name which variant the evidence belongs to.
  A dispute round RAISES the verification bar: every rebuttal sentence gets re-derived fresh, since
  the author will check each one (this author did, correctly). Concede a verified correction fast
  and in writing, amend the review record the same sitting, and restate that the verdict legs are
  untouched; a wrong mechanism claim inside a right verdict erodes exactly the credibility a
  borderline reject needs. Also confirmed here: the disputed-similarity method (concede the true
  scoping point, refute with variant-correct code cites, turn the differentiator on the
  submission's own artifacts: per-server files, zero cluster tests) converted the author to
  withdraw and pivot to a new task voluntarily.

- 2026-07-11 (univer Pluggable-IMPORTRANGE v3, Approve 3/2/3 after my v1 RC): four lessons. (1)
  Platform bots can CONTRADICT each other on the same sentence: the description-warnings bot
  suggested the exact wiring sentence the author adopted, then the conciseness bot's
  request_changes demanded deleting it as its high item; the tests decide (4/10 runs failed on the
  function-list surface that sentence anchors), so the trim was declined with grounds and the
  warning exposed as STALE (it quotes text absent from the current description). (2) An FP-panel
  judge remark ("candidate more correct than the reference on disposal lifecycle") is a lead, not
  a verdict: chased to code, the reference's name-scoped dispose matches the description's literal
  "unregisters that source", token-dispose is the other faithful reading, no hidden test pins
  either, both families pass 29/29 -> unpinned open choice, no action; the remark encoded one
  reading. (3) A fairness checker's QUALITY note can be the round's only real finding: the
  "rejects non-rectangular registered offline source results" test keys the ragged grid under B1
  but requests B1:C2, so both the drop-at-registration and accept-verbatim families reach #REF!
  via ordinary lookup miss and the assertion checks nothing; re-derive the key-vs-lookup-key match
  yourself before adopting, AND check whether any strengthening is safely fair before asking (here
  a matching-key assert would reject the pad family the FP adjudicator explicitly upheld, so it
  stays a Tests-2 note with no how-to). (4) De-prescribing a module path is fair when a
  registry-import convention forces the location (function-map.ts imports all 35 lookup functions
  from ./name dirs; the class sits in the single 12-name export list, binding the helpers to the
  same module) AND the fresh batch corroborates (10/10 runs materialized the pinned path; the one
  wipeout had the module and skipped the listed helper exports, a verbatim contract miss). Also:
  re-adjudicate carried v1 notes instead of copying them (the error-literal-argument note
  DISSOLVED: the current "non-string ... arguments produce #VALUE!" clause states that outcome);
  and a criteria change moots a prior LOC choice (v1 strict 320-340 failed the 400 floor, clears
  250 now; cleared gate = no note, no tag).

- 2026-07-11 (pynguin callable v2, Request Changes 2/2/2): an OVERRULED solo FP-panel dissent can
  still be the round's MAIN finding: run-level fairness and submission-level contract are separate
  questions. The adjudicator upheld Nova #5 because the prompt "favors the candidate's lenient
  reading" of mixed variadic signatures, which is precisely the proof that reference and
  description disagree on a realistic untested cell (reference enforces a fixed-prefix minimum the
  prompt never states; a counted passer implements the lenient reading; the judge probe
  discriminates them). Spec-vs-reference fork = Description finding with the pick-one-contract
  choice (msw rule), the covering test rides the chosen side, and the same-cell lightbulb item is
  folded in (one root cause, one place). Round-2 pattern to expect: the author fixes the asks
  cleanly and the new blocker lives in the UNASKED improvements (here is_subtype strictification +
  prefix rule + strict Any-return, all shipped with zero new coverage and a now-stale CallableType
  docstring). Also: a v1 ask can become a live discriminator in the very next batch (the asked
  lambda-LS behavior test killed 3/10, including a factory-instead-of-references LS, vindicating
  the "like other statement references" clause the conciseness bot wanted deleted twice); and a
  base suite can guard integration itself (base test_namingscope parametrizes Callable, so
  forgot-the-naming-visitor agents fail BASELINE by exactly 2, an agent-fault fingerprint worth
  recognizing before suspecting the env).

- 2026-07-11 (lazygit persist-command-log v7, Approve 3/2/2; owner corrections on the draft): two
  placement/framing rules. (1) A fair, addable test suggestion (lightbulb good-to-have) is a TESTS
  finding: it goes in the Tests reason and caps the field at 2 (Minor), never in Other notes with a
  3; the iceberg manager note ("minor gaps are approvable but reduce the tests score to 2") is the
  calibration. (2) Under an APPROVE, Solution reasons carry NO recommendations: state the issue and
  its effect, say it is minor and not blocking, stop; fix directions are for RC rounds only (extends
  mold-v4's no-action-step-lists rule from framing to an outright ban). Also from this round:
  criteria changed (Olympus now 40% pass cap, median >= 250 LOC / >= 40 messages / >= 2 files, Mars
  retired; stale "Mars" task-type tags in old-UI prechecks are ignored) and platform-panel.md still
  needs the rewrite; the new false-positive check's PASSED_WITH_WARNINGS = overruled solo dissents,
  and each caveat must be re-derived (one here was a golden-vs-description mismatch worth a Solution
  2, the SPEC_GAP_REFERENCE_ALSO_FAILS tag is the tell); regenerated patches with shifted hunk
  offsets and new pre-image hashes can still apply cleanly at the old pin (offsets are advisory),
  so test apply at the pin before calling a silent rebase; quick-setup.sh's checkout line is the
  ground truth for the platform's pin.

- 2026-07-10 (Author-defined-CodeDeploy v3, SAM, Approve 3/2/3): when a repo GENERATES artifacts the
  patch ships (SAM: `make schema` regenerates samtranslator/schema/schema.json AND
  schema_source/sam.schema.json from the pydantic models and CI diffs them), the decisive
  craftsmanship check is running the repo's own generator against the submitted models and diffing
  byte-for-byte; v5/v6 never ran it, and it both proves the schema edits are generation-exact and
  settles that those files are GENERATED for LOC purposes. Corollary: count_loc.py counts schema
  JSON as meaningful (721 here), so on generated-artifact repos the honest strict number is
  production-code-only after stripping generated files too (420, still clearing 400; passer larger,
  healthy). Unasked round deltas deserve reading: the author's fixture swap DeploymentStop ->
  DeploymentSuccess was a fairness improvement (drops the only coupling to the trigger-event
  allowlist edge, since authored triggers are never validated and both events sit in the golden's
  set), and the description edit that stated the dimension contract also FIXED a latent
  surprise-test (missing-Threshold rejection existed since v6 but was unstated until this round's
  "a missing Threshold is an error" clause). A platform Task Quality UNCERTAIN (trigger-event
  allowlist "not discoverable") is re-derived against what the tests actually pin: accepting
  DeploymentSuccess/Failure + rejecting "Boom" is satisfied by any plausible allowlist, and zero
  of 15 runs tripped there, so the eval's general-contract worry does not bind the graded surface.
  Fresh-batch corroboration for a prior ask: the v6 missing-increment-block test failed 4/15 fresh
  runs (load-bearing in the wild); the other two new cells needed the mutation proof instead.

- 2026-07-10 (woodpecker secrets-masking v2 FINAL: Approve 3/2/3 after THREE passes; the two
  entries below are the superseded intermediate calls, kept for the method lesson): a
  signature/shape fairness question is adjudicated by TWO primary-evidence checks run BEFORE any
  verdict, and both of my flips happened because I skipped them. (1) Enumerate the HOME PACKAGE's
  exported signature conventions: base server/pipeline has ~20 exported funcs, every one
  (ctx, store, entity, payload-last), UpdateStepStatus(ctx, store, step, state) the literal
  sibling, so the hidden tests' order is repo-discoverable and the pin is FAIR by the discoverable
  category; the osctrl enumerate-all-analogous-paths rule applies to signatures too. (2) Read the
  tripped agents' TRAJECTORIES: both divergent agents had step_status.go/pipeline_status.go/
  UpdateStepStatus in context BEFORE writing entries-mid-list, deliberated nothing, and NO agent
  in the batch perceived signature ambiguity (grep hits were prompt boilerplate; the one real
  ambiguity remark was Nova_10 reasoning correctly through newline-vs-block holdback) ->
  unreflected slip against evidence-in-hand = integration difficulty, NOT a wording trap;
  atom-media differs precisely because its agents demonstrably REASONED into the trap and the repo
  offered no resolution. Corollary on description craft: pin only what the repo cannot answer
  (New([]string) in a NEW package = correct pin) and leave what the repo demonstrates (additions
  to an EXISTING package follow its convention); my pin-the-signatures ask was pushing toward
  over-specification, the platform-doc's other failure direction. Meta: oscillating with owner
  pushback = evidence deficit, not calibration; anchor on the written test WITH the primary
  evidence, then hold. Checker verdicts can be right while their prose is thin: re-derive the
  eval's pattern claims, but do not override a fair verdict without primary evidence the tools
  lack. Owner style rules from the same exchange: no meta process-advice paragraphs in Other notes
  (the at-cap rerun warning was cut as AI-ish); no redundant severity labels when the sentence
  already carries it ("good to have rather than needed" cut).
- 2026-07-10 (woodpecker secrets-masking v2 CORRECTED Approve->Request Changes on the owner's
  is-it-blocking question; SUPERSEDED same day by the FINAL entry above, the FN-mirror standard
  below stays valid but its application here failed on missing primary evidence): the blocker test has a FALSE-NEGATIVE mirror I under-applied: a
  missing/ambiguous description pin is a blocker when a PLAUSIBLE FAITHFUL implementation FAILS
  on a choice the text leaves open, exactly as a missing test is a blocker when a plausible wrong
  one passes. Evidence bar met at n=1 decisive: Nova_8 passed all 47 runnable tests incl. all four
  real server endpoints and lost its verdict to MaskLogEntries' unpinned payload POSITION; the
  killer proof of no-signal was PER-FUNCTION INCONSISTENCY (both tripped agents put entries
  mid-list in MaskLogEntries yet text LAST in MaskErrorText: same reader, same sentence, two
  orders = coin flip, not an alternative convention). Weight it by what rests on it: the batch sat
  exactly at the 20% cap, so the difficulty qualification partly rested on a run failed by wording
  (the atom-media class). Approve-framing self-contradiction check runs in the FN direction too:
  writing "one run failed on that alone" in a reason and approving is blocker language (mold-v4
  rule mirrored). Why the platform tools missed it: the fairness checker validates asserted
  BEHAVIOR per clause (all server tests honestly "Prompt-stated") and never models compile-shape
  freedom; the eval's pattern prose OVERGENERALIZED ("The prompt names these APIs exactly" true
  for the package path, false for the arg order) - re-derive eval pattern claims against the
  actual prompt before adopting them. Score-vs-decision split per go-pretty v3: Description stays
  2 (one cell, one-sentence fix, otherwise exceptional), decision RC because the cell is required.
  Under RC, Other notes may carry a factual rerun risk (pinning may lift the at-cap pass rate).
  Owner style rules landed same round: author-facing text mentions only good-to-have items (never
  which suggestions to skip; skip reasoning lives in Illustrations), and nice-to-haves get NO
  how-to when they cannot admit an incomplete solution.
- 2026-07-10 (woodpecker secrets-masking v2, draft Approve 2/2/3, SUPERSEDED same day by the RC
  correction above; the verify-the-fixes mechanics below still hold): verify-the-fixes via
  the recycled dir's OWN git history (git diff <v1-commit> -- artifact) gives exact per-artifact
  deltas and proves no-tests-deleted in one command; previous-reviews.md now carries the platform
  copy of prior rounds. All five v1 asks landed as discriminating changes (the asked Done test
  failed 2 fresh runs = load-bearing in the wild; the New([]string) pin dropped the variadic trip
  6->0). The signature-ambiguity class RECURS one level down each round (v1 constructor shape ->
  v2 payload POSITION in MaskLogEntries: 2 runs put entries mid-list, one failed ONLY on that);
  handled per terminal-shape as Description 2 advice (state full arg lists if editing again), not
  a third re-stale, because the eval rules it agent-side, every test is rated fair, and the
  idiomatic payload-last default carried 8/10 runs. Passer base-test edits need the PRISTINE-file
  check even when additions-only at a glance: both v2 passers appended cases and preserved the
  " IS " expectation (clean), unlike v1's Orion rewrite. A missing-package block is not always the
  same package: Nova_2's 18-missing was the masker package built into package shared instead of
  the STATED pipeline/shared/masker path (verbatim contract miss, agent-side); always list the
  missing names before naming the cause. ElementTree trap: `c.find('failure') or c.find('error')`
  is WRONG (childless elements are falsy), use `is not None`. Script-fetched prechecks now include
  a Dockerfile-guidelines check that can misdetect the language ("TypeScript project" on a
  Go-graded task); manager ruling same day: dockerfile warnings are fine when the build is safe
  and agents run. Baseline-red run = read the failing base test first (Nova_10 broke TestExecDummy
  itself, agent-side like socid's Base:F).
- 2026-07-10 (woodpecker secrets-masking, Olympus, Request Changes 2/2/3): the platform grader
  SYNTHESIZES a per-test failure for every expected test absent from a run's junit-new.xml ("new
  tests were missing from the JUnit XML (exit code N)"), verified in Nova_2's XML; so a test.sh
  that skips non-compiling hidden-test packages (here: masktest dirs importing the solution's new
  package) is NOT an FP hole; check a failing run's XML for that marker before flagging a
  compile-skip harness. A counted PASSER can rewrite an EXISTING base test's expectation to absorb
  a base-behavior regression, and the diff can look additions-only: Orion_Nova's pure-plus hunk
  inserted a new expect line for the old case and re-used the old expect line for an appended new
  case; the tell is context-line reuse, the proof is diffing against the PRISTINE base file
  (bcf4099) plus baseline-green implying the impl matches the EDITED expectation. That passer
  divergence (masking the space-padded " IS " secret base trims to short) doubled as the live
  wrong-solution proof for the missing trim-edge hidden test. Shared-trip-point calibration: 6/10
  runs guessed variadic for an unpinned constructor while hidden tests compile against New([]string);
  ai-eval pre-adjudicated "subtle but fair"; since NO verdict flipped on it alone (each also failed
  a behavioral test), it stayed a Description 2 signature-pin ask, not a fairness blocker
  (atom-media's forced-change bar = runs failing ONLY on the point). An undocumented base-mode
  package omission can be ENVIRONMENTALLY FORCED: server/api tests need mattn/go-sqlite3 and the
  image pins CGO_ENABLED=0, so check the driver/env before flagging a touched-package exclusion.
  Upstream noise pattern again: a stale one-day DRAFT PR by a maintainer (hash-based masking so
  secrets are not SENT to agents, #4384, self-reported broken) is a different problem from masking
  VALUES in logs; the repo's own lineage (#147, #671/#700, #2680) plus active trust-boundary
  hardening (#6308, #6759) settled fit positively.
- 2026-07-10 (backfill note): the 2026-07-08..10 reviews ran on codex while this file sat at
  07-07; the entries below port every non-redundant lesson from those sessions. Codex's own
  distilled copies stay at ~/.codex/memories/ (MEMORY.md, skills/olympus-review-workflow/SKILL.md,
  rollout_summaries/) and the raw sessions at ~/.codex/sessions/2026/07/.
- 2026-07-09 (Managed-FTS-Lifecycle, sqlite-utils, approved 3/3/2): never prescribe an explicit
  test FILENAME in an ask (the platform convention is a hash/ID suffix against collisions, and
  naming one could contradict another submission's work); an ask I am not sure should be done is
  stated as a bare minor with NO recommendation (the docs cog regeneration); a clean quest-name
  grep with no other finding is silence, not a point (issues only); heavy platform reuse of a repo
  is fine when plagiarism doesn't flag it. Standing owner check on every review: an old base pin
  reintroducing upstream-landed work = heavy warning to the author (ban on repeat).
- 2026-07-09 (Deferred-foreign-key, peewee, manager-reverted bot review, Reject corrected to RC):
  on a manager-reverted review run a full from-scratch pass and ANCHOR verdict severity to the
  manager's own signal: he requested changes, so my Reject overshot; the repo-fit blocker got
  scoped to exactly the ops conflicting with the maintainer ruling (#2409 SQLite table-rebuild
  migrator) with the rest kept fixable. A ~5-year-old maintainer comment is weak evidence alone;
  intensify the search (gh + web) before it drives a verdict.
- 2026-07-09 (Author-defined-CodeDeploy round 2): a previous-review.md dropped into the dir is
  FYI, not state: verify each old item against the CURRENT artifacts. Optional checks the author
  didn't rerun (env quality, auto-review, false positive): never imply their status, write
  stale/not-rerun.
- 2026-07-08/09 (Recurring-Tasks, gantt, 3 RC rounds): a style complaint lands only when it names
  the actual artifacts and the concrete repo-standard mismatch (the note stuck once it cited the
  rec_traps test files and narrowed to comments restating the test name); "AI-ish" in the abstract
  bounces. Round-3 owner directive refining the 07-03 ruff verify-the-fixes lesson: verify the
  fixes point-by-point AND re-run the full standard on the current artifacts; the author may break
  something else, round 1 may have missed something, and a changed base commit = full re-verify.
  Never let fixed-asked-items bias the round toward approve.
- 2026-07-08 (Plugin-Owned-Highlight, Chatterino, RC): the upstream sweep looks for something
  solving the feature FULLY OR PARTIALLY, never "touches the same files"; an adjacent draft PR
  that does not do the same job is noise, cut it. Env-quality FAIL: one Other-notes line and point
  the author at the check's agent trajectory to spot the actual issue. Owner rewrote three long
  paragraphs into short points: one issue, a few short sentences, actionable; "this is too much"
  is a rewrite trigger.
- 2026-07-08 (Structured-flag-matching v1, socid): prior-reviewer handoff = first-review posture,
  and an issue the previous reviewer missed that still exists is raised normally. Every
  recommendation must fit the grading sandbox (docker --network=none). Description-edit asks are
  LAST RESORT: any description change is critical and can break the whole task; prefer test- or
  solution-side fixes. The summary sent to the owner quotes the checked-in review.md, never a
  draft (a draft-vs-file score contradiction got caught).
- 2026-07-08 (Subquery-Flattening, SQLAlchemy, RC x2): one root cause = one finding in one place,
  even when two channels report it (a description warning and a fairness suggestion pointing at
  the same gap do not become two items). The author-side "Solution Approach" field is not
  reviewed, it is optional context. Optional env quality: pass is better than fail even if
  optional; worth an Other-notes mention when the round is already RC.
- 2026-07-08 (describe-a-document/printpdf, 4 rounds to Approve): the dockerfile is rarely
  reviewed: environment adequacy is the bar, and even the optional env-quality check failing is
  routinely ignored. A real minor tied to the solution goes UNDER Solution with a 2, never into
  notes beside a 3. Owner re-review doctrine: each change can affect other parts, nothing is
  assumed fine without re-evaluation. Mutation probes (five named mutants, all failing) are the
  approve-grade proof that a previously flagged bug class is now enforced.
- 2026-07-08 (Infer-FLOPs, pytensor Mars, approved 3/2/3): the lane comes from prechecks.md's
  owner-pasted header and can change mid-review (re-read when told). auto-review.json can be
  factually WRONG, not just stale: it claimed "No Dockerfile in submission" while one existed and
  called a running test a no-op; verify its claims against artifacts before citing any. Author-
  facing wording stays behavioral ("a real in-place operation"); mechanism names (destroy_map)
  stay in Illustrations.

- 2026-07-07 (socid-extractor structured-flag-matching, from-scratch Mars, Request Changes 3/2/3):
  the decisive axis on a well-built feature-add was REPO FIT, and it needed the upstream helper to
  surface, not gh alone. gh found no duplicate and no ruling (clean), but reading CONTRIBUTING +
  schemes.py + the maintainer's own minimal PR (#207 url pre-check was a substring check, NOT a
  DSL) showed the repo deliberately keeps scheme-matching to 5-15 line declarative substring flags
  and solves the exact shadowing/false-positive problem this feature targets BY CONVENTION (manual
  ordering, unique flags). A 430-line matching DSL is a philosophy stretch even though it is
  additive/opt-in and no maintainer ruled against it -> not a hard reject (debatable + real problem
  + no ruling + risk of rejecting a clean build), so flagged as the Other-notes repo-fit concern +
  bare Repo-fit tag and let the concrete two-test gaps drive the mechanical RC. Repo fit is judgment
  (Karim): read the docs' stated philosophy and the maintainer's demonstrated taste, not just search
  for a duplicate. The clean RC driver: TWO valid-and-uncovered fairness lightbulb edges on STATED
  behavior (extract_best no-match must return {} not None; diagnose(None) must return [] not raise)
  -> a valid skipped lightbulb returns the submission regardless of field scores (Karim), and both
  are edges so Tests stays 2 not 1. Prescriptive-description-that-names-API = Description 3 when the
  hidden tests DIAL that surface and it is not repo-discoverable (grep base for the DSL symbols = 0);
  the lazy-import test pattern (importlib.import_module inside a helper) keeps the file collectable
  on base while failing at runtime, which is the correct fail-on-base technique for a new module.
  Ran real four-state in a venv (106 new pass / 121 base pass) and it caught nothing new but proved
  the TikTok/Facebook scheme edits do not regress base; batch split 2-pass/9-missed-requirement is
  the core-enforcement proof (no core mutation needed). Meets Olympus scope (657 LOC/7 files/96 msgs,
  18% pass) despite Mars submission -> Illustrations note the upgrade option, do not push (Mars is
  valid). Base:F runs were agents breaking base themselves, not a base problem.
  CORRECTION (owner pass): I OVER-WEIGHTED repo fit. A repo question blocks only on (1) already
  implemented upstream = duplicate (shipped / open-merged PR / requested issue), or (2) a STRICT
  maintainer rule against it ("by design"/"won't"/out-of-scope), or (3) a real CONTRADICTION of a
  documented invariant. "Heavier than the maintainer's minimalist taste" is NONE of those: it is my
  taste, not the standard, and the bar is "would a maintainer PLAUSIBLY accept," which an opt-in
  feature solving a documented problem clears. Here: not a duplicate (grep base = 0, no PR/issue/
  discussion), no rule, and opt-in so flags-only schemes still work (no contradiction) -> fit is
  CLEAR. Dropped the Other-notes concern AND the Repo-fit tag; a checked-and-clean fit is an
  Illustrations line, never an author-facing note (issues-only). Decision stayed RC purely on the
  two valid uncovered lightbulb tests. Ask the two gating questions FIRST (duplicate? strict rule?);
  only raise fit to the author when one is yes, never on style/scale alone.
- 2026-07-07 (foundry forge-fmt NatSpec normalize, from-scratch RC 3/2/2): the FP-hole for a
  reflow/format feature is "tests check that WRAPPING happened, never that lines FIT the width" --
  the sort-tested-by-permutation shape: doc_line_count>=N + contains(), zero `<= line_length`
  assertions (grep-proven). Width is the load-bearing stated property, so an uncovered valid
  lightbulb on it returns the submission (Karim's rule) even though BOTH passers happened to
  reflow correctly (Nova_2 passes max_space_left(prefix_len) as budget); passer-correctness never
  cures a gap on the core property. Scored Tests 2 + RC per the corpus convention (Add-local-OpenAI
  v1 precedent: stated requirement unenforced -> Tests 2, not 1). Rust-specific LOC trap: a src
  file can carry a big inline `#[cfg(test)] mod tests` (here 408 of natspec.rs's 917 lines);
  count_loc.py does NOT strip it (reported 897) so it overcounts by ~400 -- honest strict was 405,
  right on the 400 floor, passers 263/309. And `test.sh new` ran `--test <integration_target>`,
  which never compiles/runs those inline lib tests, so the golden's own width-asserting tests grade
  nothing; always read what test.sh actually invokes. Solution-2 finding: a formatter that
  canonically reorders MORE tags (BlockKind ranks moved @custom/@inheritdoc) than the description
  states (@param/@return only) is behavior-beyond-spec. Foundry facts: base fmt suite is
  `--test formatter`; forge-doc PRs (#14580, #11696) are a different subsystem from forge-fmt;
  #11761 natspec_style is a distinct style-enforcement feature served by the base docs_style field;
  crates/fmt/src has no license headers. Didn't build (heavy offline Rust, spaced path); the width
  gap is absence-of-assertion, provable by reading, so no run needed.
  CORRECTIONS (owner pass): (1) an internal Tag pairs 1:1 with an author-facing Other-notes item;
  LOC that CLEARS gets no Other-note AND no "Lines of code" tag (the math stays in Illustrations
  only) -- do not tag a cleared gate. (2) Do NOT ask an author to switch to the repo's exact-output
  fixture convention (foundry `fmt_tests!`/testdata `*.fmt.sol`) when exact-output would pin the
  golden's specific line-breaks + full canonical tag order (incl. the beyond-spec @custom/@inheritdoc
  move) and thus fail valid alternative agent solutions; for a GRADED formatter task the behavioral-
  assertion style is correct, ask only for the missing behavioral property. Repo-standard-alignment
  cuts both ways: never ask for something that would over-pin or fight repo/feature correctness.
  (3) A width/bound assertion on a reflow feature must exclude EVERY single unsplittable token
  (long plain WORD too, not just inline-code/links) or the asked test false-negatives a correct
  solution (the golden puts any overlong atom alone); the lightbulb's own wording missed the long-word
  case -- sharpen an asked test so it cannot reject a valid solution.

- 2026-07-07 (sqlite-utils v2, UNIQUE-transform WRONGLY flagged then RETRACTED): before a finding
  gets a score OR a placement, it must pass the is-it-really-an-issue gate, and a recommendation
  must never fight a DELIBERATE repo design. I flagged "uniques= creates tables that break under
  transform" and recommended "carry UNIQUE through like CHECK" -- wrong: base transform raises
  TransformError by design on any index with no CREATE INDEX statement (db.py re-add-indexes:
  `if index_sql is None: raise`), which IS a UNIQUE auto-index, so carrying UNIQUE would mean
  bypassing the guard. When the current design has a fair reason (here: auto-indexes can't be
  reconstructed, so it errors with an actionable message), scoping around it is a FAIR choice, not
  a defect -> Solution back to 3, drop the note entirely (issues-only; a fair non-issue gets no
  author sentence, only an Illustrations line). READ the repo mechanism (grep the guard, confirm
  it is intentional) before recommending its removal. The placement rule from the retracted lesson
  still holds ONLY for confirmed real issues: an actionable defect about the submitted code goes in
  the Solution field, not Other notes -- but confirm it is a defect first.
- 2026-07-07 (sqlite-utils CHECK/UNIQUE v2, Request Changes): the FP-hole standard generalizes to
  a whole re-review as a MUTATION SWEEP. For each behavior a round claims to fix, revert the fix in
  the applied tree and run the suite: M1 rename-rewrite off = 2 fail (enforced), M2 drop-removal
  off = 1 fail (enforced), M4 without-rowid off = 1 fail (enforced), M5 collate off = 5 fail
  (enforced), but M3 two-checks-per-column off = 0 fail (UNENFORCED). The golden was correct on all
  five (reproduced), so only the mutation exposed that a plausible solution keeping one CHECK per
  column passes the whole suite on a stated behavior ("transform carries existing CHECK
  constraints") = blocker, Tests 1. Repro proves the golden works; mutation proves the SUITE
  enforces it; you need both. Also: a permissive assertion silently un-enforces a fix
  (test_parse_default_null accepts "NULL"|""|None, so the v1 empty-string bug still passes) -- grep
  the actual assert, do not trust the test name. Similarity/coexistence (Karim): the Adjacent tag
  is not a verdict; read the per-candidate meaningful_differences and decide COEXISTENCE (different
  repo + different core + only generic-technique overlap = coexist, not reject). Notable: fixing my
  v1 asks (add WITHOUT ROWID preservation + rename/drop rewriting) is what flipped Distinct->
  Adjacent by adding recreation-preservation overlap with a Piccolo submission -- incidental
  technique, not core, so still coexist. A PR that post-dates the submission (766) is a
  manager-awareness tag + an Other-notes alignment note, never counted against the author (Discord
  ruling). And verify a suspected new bug is not PRE-EXISTING base behavior before flagging: the
  UNIQUE-through-transform TransformError raises identically on clean base, so it is a scope note,
  not a golden defect.

- 2026-07-07 (mold debug-names v4, approve-framing corrected by owner): approving while the review
  text says "a solution that violates a stated clause passes" is a self-contradiction, even for a
  benign minor -- that is blocker language. The fix is to SPLIT the clause: the mutual-exclusion
  REJECTION is enforced (the `! $CC` assertion fails a non-rejecting solution), only the diagnostic
  MESSAGE is loose (driver's "ld returned 1" satisfies `[ -s err ]`), so no WRONG-OUTPUT solution
  passes; the only slip is a correct-rejection-minus-message, which is benign. Owner rule for the
  two modes: if a buggy/wrong-OUTPUT solution can pass -> do NOT approve, illustrate how it passes +
  actionable steps (RC); if approving -> GUARANTEE no wrong-output case (state the per-clause
  enforcement map explicitly in Illustrations) and mention the benign minors WITHOUT action-step
  lists and WITHOUT "a wrong solution passes" framing. Author-facing minor reasons must be CLEAR
  enough to act on (name the exact symbol/locations: std::tuple at the sort + patch vector, include
  dropped) but phrased as a note, not a prescriptive multi-step fix. "incomplete/buggy" in the owner
  standard means broken OUTPUT/missing functionality, not a missing courtesy message.
- 2026-07-07 (mold debug-names v4, APPROVED after the v3 correction): the v3 bucket-a blocker
  (single-entry-per-name passes) was fixed the healthy way, a discriminating test not a reword:
  pr-dn-dup-name links two objects each defining struct S and awk-asserts the "S" name block has
  exactly two DW_IDX_compile_unit lines with two distinct values, so a single-entry index (1 line)
  fails -eq 2. Two-way proof without a build: the assertion COUNTS entries (logically certain), and
  the batch splits 7-pass/3-fail (passers pass with 0 fails, Nova_1/2/3 fail it), which proves the
  awk parses real llvm output and separates correct from incorrect, i.e. the test is not
  trivially-green. Batch split is a valid substitute for build+mutate when the pass/fail ratio is
  non-degenerate. A stderr diagnostic test can be silently weak: `2> err; [ -s err ]` is satisfied
  by the COMPILER DRIVER's own "ld returned 1 exit status", so it never isolates the tool's message
  -- but that is bucket-b (contrived silent-mold mutant, benign consequence: link still fails,
  driver still informs), so tighten-not-block. New author edit to watch: an IWYU regression --
  #include <tuple> removed while std::tuple still used; compiles transitively (golden gate proves
  it), so no functional risk but a legit Solution-2 hygiene minor introduced THIS round. Terminal
  shape held: once the bucket-a test lands and is corroborated, Approve with honest 2s (weak
  diagnostic assertion, dropped-used-include), do not RC again over bucket-b edges.
- 2026-07-07 (msw rooms v4, APPROVED, terminal shape): the v3 FP blocker (memberless-room state
  leak) was fixed the healthy way: author added exactly the two asked tests (ST8 state, MOD7
  moderator twin) AND a directly-stating clause ("A runtime holds a room's state and moderators
  only while it has members in that room"), solution byte-identical, nothing removed. Verified with
  a 3-way mutation (whole clone reset+reapply between each): golden passes both; drop the state
  guard -> only ST8 fails; drop the moderator guard -> only MOD7 fails. Each test catches exactly
  its guard. Batch corroboration is the strongest signal a fix is load-bearing in the wild: ST8 and
  MOD7 each fail in 5 of 11 real failing runs, i.e. 5 agents that the v3 suite would have passed
  buggy are now caught. THE CALIBRATION THAT MATTERED: a fresh lightbulb item ("host no-op": does
  setHost-to-current fire a spurious hostchange?) mutation-showed a wrong impl passes 91/91 (emit
  hostchange unconditionally in setHost) -- but that is NOT automatically a blocker like ST8. Apply
  the bucket-a vs bucket-b discriminator BEFORE escalating: bucket-a (RC) = realistic/non-exotic
  trigger AND a wrong RESULT or persistent wrong state (ST8 leaked state on any late runtime + any
  setState; mold missing index entries); bucket-b (Approve, Tests 2) = exotic trigger (re-promoting
  the already-current host) OR a benign transient effect with the CORRECT result (host is right,
  just one extra event). "A wrong impl passes" is necessary but not sufficient for a blocker; the
  consequence-severity and trigger-realism decide. Do not frame a bucket-b as "a wrong solution
  passes" (that is blocker language, contradicts the Approve) -- frame it as an unpinned no-op edge
  worth tightening, with the mutation kept in Illustrations as due diligence. Terminal-shape rule
  held: once the round-N bucket-a blocker is fixed+verified, flip to Approve even though the
  lightbulb keeps producing bucket-b edges; a benign edge never overrides it. H5 already testing
  the removal-no-op is the precedent that made the setHost-no-op a fair, in-scope tightening ask
  rather than an invented one.
- 2026-07-07 (sqlparse bind-params v2, completeness pass caught a finding I first under-reported):
  when the owner asks for "complete so nothing blocks a round 3", run BOTH consistency directions
  as a matrix, not a spot check. Described-name -> exported+tested caught nothing; the REVERSE
  (solution public symbol -> described? tested?) caught a whole orphan pile the author left when
  they SLIMMED the description between rounds: get_marker/get_style/get_name/get_position on the
  node, inventory first/repeated/statement/named_items/positioned_items, rewrite-result
  first/statement, plus extract_parameter_positions -- all defined, undescribed, untested. My first
  Solution reason named only one of them. Method: `def NAME` in solution x `NAME(` in tests x NAME
  in description, then a call-site count in the solution to separate DEAD (0 internal uses) from
  undescribed-but-internal (getall had 2, so it stays). Two grep traps to avoid: a `\b` inside a
  regex character class is a backspace, not a word boundary (silent wrong matches), and substring
  hits lie (`first`/`repeated`/`statement` matched "first-seen"/"repeated named"/"statement_index"
  in prose) -- always grep the method form `NAME(`, not the bare word. Also verified the coverage
  matrix cheaply and completely: disambiguation contexts all covered except quoted identifiers,
  rewrite targets qmark/numeric_qmark(via StringIO)/numeric_dollar/named only. When a False-Positive
  report and a fresh lightbulb both point at gaps, they are the same story from two angles; state
  the FP finding as the Tests blocker (reference the FP check by name for authority) and do NOT also
  leave it as an "optional / nice to do" pointer elsewhere -- that contradicts the blocker.

- 2026-07-07 (sqlparse bind-params v2, Mars re-review, RC on a False-Positive hole): the new
  False-positive precheck report is a REPRODUCE-FIRST signal, not a relay. The panel said the sole
  passing agent (Nova_Nova_9) drops qmark `?` after BETWEEN/IS via a preceding-keyword allowlist; I
  reproduced it in a venv against the REAL hidden suite: golden passes 23/23 and returns ('?','?'),
  the passer passes 23/23 but returns ('?',)/()/`between ? and $1`. A wrong solution passing on a
  STATED behavior (only JSON `?`/`?|`/`?&` are non-placeholders, so BETWEEN ? is qmark) = Tests 1 /
  Request Changes, and here it is not hypothetical, it is the only counted pass. Method that made
  it airtight: apply test+golden then test+passer to the clone, run the suite AND a targeted probe
  for the untested position, then git restore. Second finding from the owner's "check deliverable
  consistency" ask: diff the description's exposed-API list against the solution's exports and the
  test usages -- extract_parameter_positions was exported+defined but dropped from the description
  and never tested = unrequired export = Solution 2 (the def-only "1 ref" in a reference-count scan
  flags these). Tier: a Mars downgrade moots the 400-LOC floor (100 floor, 604 meaningful clears),
  so a prior LOC-driven RC evaporates; re-review fresh. When the ONLY passing run is the false
  positive, note that hardening the tests will drop it to zero legitimate passes and ask for a
  re-run to reconfirm solvability (golden proves solvable; the platform still wants an agent pass).

- 2026-07-07 (msw rooms v3 CORRECTED Approve->Request Changes on owner's minor-vs-blocker
  question): I scored the missing remote-guard test as Tests-2/Approve by filing it as "no test for
  a correct fix = coverage nicety". WRONG lens. The right lens is the FP test: a missing test is a
  minor (2) only when what slips through is inefficiency or an edge covered elsewhere; it is a
  blocker (1, RC) when a PLAUSIBLE wrong solution passes the whole suite on a STATED requirement.
  "no test for the fix" and "a wrong solution passes" are the SAME fact viewed from opposite ends;
  always state it from the wrong-solution end and run the blocker test. Proof that settled it:
  golden minus the one handleRemoteRoomState guard line (literally the reference's own pre-round
  version, so maximally plausible) passes all 89 tests, yet an orphan probe shows a memberless late
  runtime holding state {status:'playing'} for a room not even in link.rooms -- violating the
  stated "memberless room has no state". The batch's single passer happening to handle it right
  does NOT cure the gap; the suite must ENFORCE the contract, not rely on the passer's virtue.
  Mutation+probe is the finisher: MUT-B (wrong soln passes suite) AND orphan-probe (same wrong soln
  is observably broken) together = airtight "wrong solution passes". Meta: when a fix I asked for
  lands in CODE with no test, do not default to Approve-with-2; mutate the fix out and probe -- if
  the mutant passes the suite and fails the probe, it is a blocker. The manager's "any minor -> 2"
  is the FLOOR of strictness, not the ceiling; a stated-invariant FP hole is a 1.

- 2026-07-07 (msw rooms v3, APPROVED after two RC rounds): the v2 reword-and-delete dodge was
  actually fixed this round (room:reset broadcast + LC4 cross-runtime reset test), and the
  finishing move was the MUTATION PROOF, not the read: neuter the room:reset postMessage in the
  applied tree, run LC4, confirm it FAILS (load-bearing) while LC5 still passes. A requested fix
  that lands in CODE but has NO test is Tests-2, provable by reverse mutation: remove the new guard
  (handleRemoteRoomState), suite stays 89/89 green => the fix is uncovered, a regression ships
  unseen. Distinguish that gap from bucket-c: the remote "no members, no state" behavior is
  DERIVABLE by composing two stated clauses (late runtime has no members + setState-with-no-members
  does nothing), so it is a real coverage note, whereas same-key concurrent-write winner is
  genuinely unspecified (tell the author to SKIP it). A 9/9-failing test is not automatically a
  wall: HX1/HX2 mapped to the explicit "every runtime names the same host and successor" and
  asserted AGREEMENT between runtimes, not a specific algorithm, so any order-independent election
  passes = legitimate hard core; the ai-eval reached the same verdict. Pass rate can DROP
  round-over-round (2/10 -> 1/10) as the author adds hard forks; fine while >=1 and <=cap. all-3s
  allowed after mutation-level scrutiny finds nothing (do NOT invent a minor to force a 2 under the
  manager's strictness note; give the 2 only where a real gap exists, here Tests). Tooling: msw
  dev deps (undici 8) need Node 22, local 20.10 dies on webidl.util.markAsUncloneable; and
  `git checkout -- <file>` after a per-file mutation reverts that file to BASE (drops the solution
  patch), leaving an inconsistent tree that fails everything (botched my MUT-C) -- reset the WHOLE
  clone and re-apply both patches between mutations.

- 2026-07-07 (mold debug-names v3, Request Changes): I FIRST scored this Approve and the owner
  caught the go-pretty v3 category error live: I argued the single-entry-per-name mutant was
  "contrived because golden + both passers all accumulate multi-entry", but who-implemented-it-right
  answers AMBIGUITY, never SUITE-STRENGTH. The mutation standard governs: a single-entry solution
  passes all 26 tests and emits an index MISSING entries, and the trigger is not exotic (a struct or
  typedef in a shared header appears in every including CU), so it is an incomplete-solution-passes
  hole on a stated clause = bucket-a required = Request Changes. The terminal-shape rule (approve
  after the round-2 blocker) covers buckets b/c only; it never overrides a bucket-a FP hole. THE
  DISCRIMINATOR between this and the iceberg approvable-Tests-2 (matrix breadth): iceberg had an
  independent oracle (evaluator equivalence) that still failed wrong solutions, so the gap was only
  breadth; here the behavior has ZERO coverage so --verify never runs on the exposing shape. My
  v1/v2 "verify covers duplicate-CU" was the same error (verify-would-catch-it is not
  suite-enforces-it). When a passer-pool sample all implement a clause right, that is NOT evidence
  the suite enforces it; only a discriminating test (or a passer that got it WRONG and still passed)
  proves strength. Still true from the draft: case-folding hash was pinned by verify recomputing on
  the incidental uppercase name "P"; the author's edit left a stale comment (Solution-2); the
  uncompressed_data retention is a load-bearing companion to the find_section read.

- 2026-07-06 (go-pretty colgroups v4, approved): a "the fix closes the FP hole" claim gets the
  same mutation proof the finding did, not reasoning: apply golden in a worktree, flip the exact
  operator (merge && -> ||), confirm the new test FAILS on the mutant and PASSES clean. That is
  what turned "the test looks right" into certainty. Fresh-batch staleness check when the suite
  count changed (74 -> 77): grep testcase count in every junit-new.xml AND git-status the runs
  dir; both must show the new number. The regenerated fairness lightbulb splits cleanly into
  three buckets and only one is ever an ask: (a) stated-clause gap a wrong impl slips (required),
  (b) transitive edge of a pinned contract (good-to-have, Tests stays 2), (c) UNSPECIFIED
  interaction the description never defines (do NOT ask; testing it pins unstated behavior, the
  unfair direction) -- name (c) to the author so they don't blindly add the suggestion. After the
  round-N blocker is fixed and verified, the decision flips to Approve even if the lightbulb keeps
  producing edge items; approve-with-a-precise-2 is the terminal shape, not an infinite RC loop.
- 2026-07-05 (go-pretty colgroups v3, challenge round CORRECTED): my first defense of the merge
  gap was wrong, and the owner's second push exposed the category error: golden/passer both
  writing the and-condition answers the AMBIGUITY question (is the clause fair?), never the
  SUITE-STRENGTH question (do the tests enforce it?). The grading standard is the mutation
  standard: deliberately wrong code must fail; an either-flag fold passes all 74 tests (verified
  by walking every same-caption adjacency), so the suite certifies a solution that violates the
  stated word "both" = FP hole on a stated clause = Request Changes, regardless of who happened
  to implement it right. Partial sibling enforcement does not cover a DISTINCT stated
  sub-contract (the mutual-opt-in boundary is its own behavior, not a shade of the fold). The
  manager's approvable-minor class is breadth-beyond-coverage (property rows, title-case), never
  a stated-clause violation passing. Score vs decision separate cleanly: Tests stays 2 (one cell,
  six-line fix, suite otherwise strong) while the decision is RC because that cell is required.
- 2026-07-05 (go-pretty colgroups v3, approved): manager calibration is now explicit (iceberg
  feedback): ANY real minor keeps the section at 2, including pure coverage-breadth items
  (canonical-ordering matrices, property-based rows); approve-with-a-precise-2 is the target
  shape, all-3s only when three rounds of hunting left nothing above the pedantry line. A
  round-N lightbulb can be a SHARPER version of a round-N-1 skip (merge both-set vs either-set:
  the v2 structural argument only killed the ignore-the-flag shape); re-adjudicate and own the
  refinement instead of carrying the skip. Asked-for tests becoming live discriminators in the
  next batch (footerSeparateFooterOff killed 3 runs, TSV quoting killed 2) is the cleanest proof
  a review ask was load-bearing; record it. A NEWER same-repo pending sibling in related-subs
  runs keep-the-original in THIS submission's favor and belongs to the sibling's reviewer. And
  the v3 probe closing the loop (golden now renders exactly what the v2 passer did) is the
  verification shape for any behavior fix: re-run the round-N-1 probe, expect the passer's output.

- 2026-07-05 (mold debug-names v2): the passer-diff oracle caught a SECOND golden omission in the
  same task (v1 unit_type skip, v2 the docs/mold.md man-page entry); when a solution adds a
  user-facing CLI option, check the repo's option-doc convention (mold documents every flag in
  docs/mold.md) as consumer-surface completeness. A repo-parity gap is strongest when the sibling
  file contains the literal fix (gdb-index.cc:629 reads CompressedSection::uncompressed_data where
  the golden's find_section skips compressed chunks and ships a present-but-empty index); pair the
  solution ask with the sibling test's twin (gdb-index-compress-output.sh). The interaction-flag
  sweep generalizes go-pretty's Options.X lesson: for a linker, probe the new feature against
  --compress-debug-sections, --gnu-debuglink, -gsplit-dwarf. Partial delivery of a base-suite ask
  is acceptable when the chosen subset covers the touched machinery and the omitted siblings test
  code the patch never touches; write that ground instead of re-asking for the family.

- 2026-07-05 (msw rooms v2, polish round): polishing another session's draft caught a false
  finding that survived its whole analysis: the Category line was flagged as a Description defect
  despite the standing platform-toggle rule; on any cross-session polish, re-check each finding
  against the lessons file, not just the wording. A spec-vs-solution mismatch is a DESCRIPTION
  finding (the clause promises what the solution does not do; qualify-or-restore is the author
  choice), even when the evidence came from a test-side lightbulb; placing it under Tests buries
  the choice. auto-review staleness is never author-facing (the author cannot rerun it from the
  form; note it in Illustrations); env-quality reruns are optional, never demanded. The doc
  template has no preamble slot: round context lives in Illustrations, the platform fields open
  directly with the reason.

- 2026-07-05 (msw rooms v2): an author can dodge a propagation ask by REWORDING the reset clause
  ("every link's rooms" -> "its links' rooms") and DELETING the machinery that exposed the symptom
  (catch-up + CU1-8), while the indicting clause ("every runtime observes identically") stays; on
  round 2, diff the description clause-by-clause and re-run the R4 propagation audit before
  trusting any delivered-ask claim. Deleted tests are a first-class delta item: classify each as
  asked-trim (R9/R10, regression pair) vs coverage regression (ISO, H7, CU set) and re-open the
  stated cells they covered. The finishing combo that made this round stick: grep-zero (no
  room:reset type) + live probe in the patched clone (PROBE-A remote member survives reset;
  PROBE-B orphan statechange with zero members) + passer divergence (Nova_5 implemented the
  propagating semantics the golden lacks, suite passes both). A fairness-lightbulb item the GOLDEN
  itself would fail (late-runtime hydration) is never skippable; it means spec and solution
  disagree, not that coverage is thin. Guard-asymmetry is a repeatable bug class in remote-apply
  handlers: local mutator checks (room exists, member exists), remote handler applies blindly;
  audit each local/remote pair. Tooling honesty: `ls dir | head && echo OK || echo missing` lies
  (pipeline exit code), and my LOC type-block tracker ran away twice; use the official counter
  plus a hand tally, and record both.

- 2026-07-05 (go-pretty colgroups v2, polish round): a LOC that PASSES the gate is silence in
  author-facing sections (no Other-notes paragraph, no tag); the math and the channel
  recommendation live in Illustrations only. Owner rule reaffirmed: mention LOC to the author only
  when something is unusual. Author-facing test asks read best as three beats: what is missing,
  what wrong implementation slips through, the one test to add; and each finding paragraph opens
  with the defect in one plain sentence before any mechanism. A recurring line worth keeping: tell
  the author the Test Fairness coverage suggestions deserve analysis every round, with this
  round's hit rate as the proof.
- 2026-07-05 (go-pretty colgroups v2, deep re-pass): the PROBE is the finishing move for a
  passer-vs-golden divergence: grep found the passer gating SeparateFooter where the golden greps
  to zero references, and a two-worktree run with SeparateFooter=false produced two different
  outputs that both pass all 71 tests; quote the executed evidence, then remove the worktrees and
  git-status the clone. Calibrate msw-class findings by STATEDNESS: a deviant golden on a stated
  dimension is Solution 1 territory (msw), on an unstated dimension it is Solution 2 plus a paired
  description+test ask. The authoring-playbook lens is a real checklist (padding tells, hygiene
  tells 100755/no-RUN-go-test, fork-signature independence across runs, dump-then-assert, the
  build-tag seam being accepted when the API IS the feature and platform checks pass it); run it
  once per submission and record the cleared items, they answer the manager's "what did you rule
  out". Style options are a standing untested-column generator for rendering libraries: for every
  Options.X the touched section honors, probe X=false.

- 2026-07-05 (risinglight SSI v2, approved): an author can resolve an "observable effect or
  accepted-counter" fork by DELETING the ungraded machinery instead of growing the contract;
  grade the convergence (golden 661->532 strict, passer gap 290-vs-661 -> high-300s-vs-532), not
  the shrink. The healthy pattern for a description edit is clause+test in the same round (the
  handle-survival clause shipped WITH vacuum_reclaim_keeps_a_live_handle_write; contrast iceberg
  where the clause arrived testless). A stated clause can make a DESIGN load-bearing: handles
  survive vacuum forbids naive physical rewrite, so what reads as scope reduction is actually the
  contract choosing sides; check the new clause against every implementation family before
  calling it softer. FAIL_INTEGRATION_ERROR triage again: agent omitted a required public
  re-export = agent-side, blocker false. All-3s given only after every prior ask was re-verified
  by grep/read and the fresh lightbulb came back empty.

- 2026-07-05 (go-pretty colgroups v2): a review finding can come back as the next round's hidden
  discriminator (the v1 empty-header-row bug became noGroupsEmptyHeaderHTML and killed 9/11 runs);
  adjudicate it like any stated-clause trap (stated in the description + not universal + some runs
  clear it = fair), and expect authors to weaponize review findings. Hunt description ambiguity by
  REPO-PRECEDENT PULL: "FromColumn anchors at an explicit column" is ambiguous precisely because
  ColumnConfig.Number is source-based, so the wrong reading has in-repo gravity; one word (visible)
  plus one combo test closes it. Tolerant-by-design assertions with a comment ("whether it emits a
  default align attribute is left to the implementation") are the fix shape for exact-form
  unfairness; look for them before re-flagging. Borderline LOC protocol used: my-method 412 vs
  conservative ~392 vs passer 460 = disclose both numbers in Other notes, recommend the reviewer
  channel, never silently pick a side.

- 2026-07-04 (scrapy snapshot v4): reviewing another reviewer's draft is rule 2 all over again:
  two of its claims died on grep ("storage-kind still open" when the delta contains bad_storage;
  "no helper test ever passes a path" when lines 538/573 pass manifest_path to load and replay).
  Adjudicate fairness items against the CURRENT batch's artifacts, never a carried narrative.
  The complete skip-profile for a lightbulb item: sibling cells of the same stated disjunct
  enforced + wrong shape structurally contrived + zero sightings in the passer pool; with that
  written, the item is a minor note under an Approve, not a valid-and-skipped return trigger.
  And when a draft proposes a decisive check but does not run it, RUN IT before deciding (both
  passers' loaders were Mapping | str | Path, two greps, two minutes).

- 2026-07-05 (scrapy snapshot v4): variable names lie; type the argument before adjudicating a
  path-input lightbulb (bad_path was a MUTATED MAPPING, so the helper never sees a path-typed
  snapshot anywhere and the stated or-paths disjunction was CLI-only enforced; the same grep that
  named the variable would have skipped a valid item). A minus-line in an existing base test can
  be a benign mixin ADDITION to a class-bases tuple; read the hunk before calling it weakening.
  A skipped-minor from the previous round carries forward as minor, it does not escalate; and a
  lightbulb item skipped twice with the same admit-test gains evidence each round (passer choices
  tuples), say so instead of re-arguing from scratch. Tier context: after a manager conservative-
  LOC ruling, an author submitting the SAME task as Mars is following the ruling, not dodging it;
  note the consistency (passers still under 400 conservative), raise no issue.

- 2026-07-04 (ollama files-api round 3, tier flip): when a submission moves lanes mid-review
  (Mars -> Olympus), re-grade EVERY tier-scoped statement from earlier rounds: the golden LOC
  check re-anchors to the 400 strict floor (575 clears), the difficulty framing re-anchors to
  20%, and prior "acceptable for the Mars bar" observations get restated, not carried. Structural
  skip arguments must be checked per-case: 206-ETag skips because enforced 200+304 assertions
  FLANK the range fork (header forced onto the shared path), while round-1's metadata-200 was
  valid because its 200 side had zero enforcement; write the distinction down before a manager
  asks. A passer integrating more idiomatically (envconfig) is a LEAD on golden pattern-deviation,
  not a finding, until base greps rule: server/routes.go:93 reads OLLAMA_EXPERIMENT raw, so the
  golden's os.Getenv has in-file precedent. And check `git status` INSIDE the clone after
  tooling: a stray package-lock.json diff (60 lines) appeared from ambient tooling, unrelated to
  patches; restore before claiming clean.

- 2026-07-04 (iceberg simplify v3, approved): grep for the FIX'S INTENT, not your suggested
  syntax: "add form assertions" arrived as isinstance(result, NotIn), and `== NotIn(` matched
  nothing; a narrow grep nearly called a delivered fix missing. Adjudicate lightbulb edge-cases
  against repo CONSTRUCTOR guarantees (In.__new__ returns EqualTo for singletons and AlwaysFalse
  for empty, so the suggested singleton tests would assert the repo, not the solution). A re-pin
  turns a prior Other-notes remark into a spec+solution+test triplet to verify as a unit, and it
  re-scopes the base whitelist question (upstream incremental tests live in an already-listed
  file). A build-time `python -c "import boto3"` line is the strongest possible refutation of an
  env-quality "missing dependency" claim: the image cannot exist without the import succeeding.

- 2026-07-04 (cleo dispute round): an author's "it wasn't a duplicate when I created it" timeline
  claim is answerable from the report itself: convert every candidate's contentAuthoredAt (ms
  epoch) to dates and compare to the submission's creation; here the accepted Typer task was
  authored 2026-04-18, 2.5 months before the author's June 30, and ALL five candidates predated
  him (newest June 6), so nothing "slipped in" between creation and review. Argue from created
  order (the Older tag's basis), never from acceptance dates the artifacts do not contain, and
  note the keep-the-original rule gives the same outcome for accepted-vs-new and
  pending-vs-pending. Version pickers matter: identical inputsFingerprint on v0 and v1 proves the
  flag existed from the first snapshot, not from a re-run.

- 2026-07-04 (ollama files-api round 2): a skipped lightbulb item can RETURN with sharper wording;
  re-adjudicate on the standard, not your prior call, and OWN a flip in the author-facing reason
  ("round 1 called it skippable; that call was wrong") so the author is not blamed for following
  the earlier review. The disabled-cap case is the template: "positive X does Y" states the
  complement, and the naive-parse impl (unset errors to disabled, explicit "0" becomes a
  reject-all cap) is the plausible FN. Passers can prove a contested cell is mechanism-not-luck
  (all three used Header.Values("Range") multi-field checks). And a failure concentration can
  HARDEN across rounds (7/7 failing runs on one test, 21/22 groups green) while staying fair when
  the rule is stated and a minority derives it; record that difficulty rests on one cell as an
  internal observation, not an author action.

- 2026-07-04 (ollama files-api, Mars): the panel screenshot can be a STALE TEMPLATE (msw rooms
  title + pre-filled 3/2/2 on a totally different task); never read tier or scores from it, derive
  tier from the run numbers (30% clears Mars <=30 but fails Olympus <=20; 68 median messages fails
  Olympus 80). Quest-name leakage into shipped test code (olympus* helpers, TestOlympusOpenAIFiles_)
  is a real repo-convention flag; the hash filename suffix (690ff0) is the accepted distinctive-name
  practice, do not conflate. Dead-EXPORT audit for a Go package: a store exposing 11 methods the
  middleware never calls (NewFileStore/Create/Len/Has/TotalBytes/IDs/Snapshot/...) is unrequired
  public surface = Solution 2; confirm each has zero real call sites and that test.patch hits are
  collisions (CreatedAt, Content-Length, HasPrefix). Per-endpoint fairness gap: content-200 ETag
  asserted, metadata-200 ETag not, so a wrong retrieve handler passes = needed lightbulb. Four-state
  proven locally in a base worktree (new suite 404s on base, green with golden, touched pkgs green).

- 2026-07-04 (risinglight SSI, challenge round): grep the PASSERS' mechanism for any contract
  whose observable is thin; both passers vacuumed by pure counting (a tally field, a reclaimed
  flag) and passed every vacuum test, which upgraded "LOC gap" into "the reclamation contract is
  bookkeeping" and proved the lost-delete anomaly golden-only (no rowset drop, no stale handle).
  A passer-mechanism probe answers "what does the suite actually require" better than reading the
  golden. Owner rules landed this round: tags are BARE, concern text goes in Other notes; and a
  stale Other-notes ask (env quality) must be deleted the moment the owner reports it green, not
  left for the manager to trip on.
- 2026-07-04 (risinglight SSI): a softened contains() assertion sitting next to a commit-ok
  assertion on a rewrite/moved-data path is where LOST WRITES hide; grep otherwise-exact suites
  for contains( and re-derive the exact final set by hand. The dead-plumbing hunt found the
  smoking gun: a struct field constructed empty at its only call site (TxnEffects.deleted_rowsets)
  made the exact guard for the masked anomaly unreachable; write-only fields are not just noise,
  they mark unfinished semantics. Repo fit can be settled by the base code itself: the
  transaction_manager doc comment states SI/SSI as the engine's planned phase, stronger than any
  issue link. Forge ops for Rust: jemalloc's configure dies on paths with spaces (never build
  under "Shipd - Olympus" locally); the forge image ships NO Rust and cargo is not on the
  non-login ssh PATH, install rustup once (now done, pinned nightly cached) and export
  $HOME/.cargo/bin in every remote command.

- 2026-07-04 (cleo option groups): two grep substring traps in ONE review: method names matched
  test FUNCTION names (test_command_rejects_conflicting_options), and `name=` matched the string
  "username"; both leads died on context pull. Extend rule 2: a grep hit is a call site only when
  the pulled context shows an invocation. Passer-LOC oracle at its clearest: 274-strict passer vs
  644-strict golden with all tests green means the delta (5 dead methods + untested named-group
  machinery + descriptor fields no test reads) is not graded scope; that is a Solution finding,
  not test weakness, when the base+new suites are otherwise strong. Strongest lightbulb form
  again: the app-level visibility suggestion would FAIL the shipped golden (JSON/MD app views
  drop groups while the text view was fixed), so a "coverage suggestion" can be a solution-bug
  detector. CORRECTED same day by the owner: dedup is per PROGRAMMING LANGUAGE, not per repo;
  cross-repo same-language same-feature-slot adjacency does NOT co-exist (Typer accepted holds
  the Python option-groups slot; a rejected Click sibling in the same report was the pool
  precedent, not a mystery), so the review flipped to Reject. Rule: run the co-existence test at
  language-pool scope; "different repo, zero shared surfaces" is not a defense; a candidate
  list's accepted-vs-rejected statuses can reveal the pool's prior ruling on the very idea. On
  reject, preserve the deep-pass RC findings in Illustrations for a possible overrule.

- 2026-07-04 (hocuspocus batching, reject): run the upstream sweep BEFORE settling a
  platform-side overlap verdict; the borderline Adjacent-sibling case (pending, not accepted,
  mechanisms genuinely different) was settled by a merged PR instead: #1118 added flushDelay
  batching to the exact file and send path the submission patches, 8 days AFTER the author's pin
  (v4.3.0), answering open issue #629. Recipe that nailed it: gh pr list --search on the feature
  nouns, then git log --all -S <symbol> in the clone to place the merge relative to base, then
  check whether the leftover delta (here ack/seq/resend) could stand alone (it contradicts the
  merged time-based design, so no). Shared GRADED test behaviors in the related-subs report are a
  stronger overlap signal than shared seams or clauses (frostdb had none, this had two). A
  release-tag base pinned days before the solving merge is not bad faith, say "the pin sits just
  behind the merge" not "dodge".

- 2026-07-04 (mold debug-names): when a description states a default-off, check the suite for a
  NEITHER-flag link, not just an explicit-off one; a default-on implementation passed this entire
  suite because the disable test passes both flags. Quantify base-mode thinness against the repo's
  real suite (here 8 of 502 scripts, skipping all 10 gdb-index siblings next to the touched
  passes.cc lines). The passer-diff oracle also works in reverse as a GOLDEN bug-finder: the only
  passing agent skipped the skeleton dwo_id (8 bytes) that the golden's walker ignores, turning a
  reading-based suspicion into confirmed evidence. Upstream fit can be settled by one issue thread
  when the owner speaks (mold #840: "we probably should create it").

- 2026-07-03 (frostdb linkage, reject): duplicate adjudication method that held up: (1) read the
  Related Submissions + Plagiarism sections fully, then re-verify their quotes in the actual
  description/solution (the three template clauses and four code seams were all confirmable by
  grep); (2) apply the co-existence test: what does an agent learn from this that the older
  accepted sibling does not teach; if the tier-qualifying substance is the shared scaffolding and
  only the edge predicate/state machine changed, they cannot co-exist and the older one stays;
  (3) scope the reject honestly: name which candidates do NOT count against the author (different
  repo/mechanism) so the manager sees calibration, and flag the same-template pending sibling for
  its own reviewer. An "Adjacent/distinct-exercises" checker verdict does not bind the reviewer;
  same-author template stamping on one repo is reject-grade per Leonard's announcement. On
  rejects, fields carry 0 per the guide, with one line noting the zeros reflect the verdict, not
  craftsmanship, and full R3/R4 depth is skipped since rejection short-circuits.

- 2026-07-03 (typestat v3): wall-time under parallel suite contention is not perf evidence. Three
  heavy mutation suites in ONE vitest invocation produced "10 failed" then "2 failed" timeout
  regressions that vanished when the suite ran alone (golden equal-or-faster than base in the
  control). Any timing/perf claim needs an isolated single-suite run, base vs golden, same
  invocation shape. Second occurrence of non-CI snapshot self-heal turned it into an author-facing
  ask: test.sh should export CI=true so included snapshot suites enforce instead of rewrite.
  Capture discipline: grep "Tests |Test Files" summaries, never tail -N, after two truncation
  misses. And the lightbulb REGENERATES each batch; adjudicate the new set fresh with written
  admit-tests instead of assuming continuity (round-3's conflicting-writes item died to a
  two-sided-coverage argument: nested pins per-path merging, typedElements pins element union).

- 2026-07-03 (go-pretty colgroups, finalize round): repeated the typestat-v2b class of error once
  more: "prechecks.md has no Env Quality section" became "it never ran", and the owner had run it
  green. HARD RULE: never state a platform check's status from a missing artifact section; only
  from an explicit verdict line or the owner. Also: description feedback must cite the WRITING
  RULES first (direct action opening, no motivation, no external framing) with accuracy points as
  support, not lead with "the claim is wrong". And two audit upgrades worth keeping: base golden
  files are fairness evidence for exact-form assertions (base emits align attrs on th, so the
  <th>G2</th> literal rejects repo-consistent output), and the passer's patch can prove the FIX
  SHAPE for a golden bug (passer kept the guarded no-groups path the golden clobbered).
- 2026-07-03 (go-pretty colgroups): passer LOC PARITY is the strongest LOC evidence: when the sole
  passing agent's strict count lands within a line of the golden (261 vs 260), the size is
  intrinsic to the scoped feature, so sub-400 means scope change or Mars, not cleanup. Also: check
  a description's opening CLAIM against the repo's actual capabilities before accepting the
  premise (go-pretty's AutoMerge header rows already produce shared captions in console/HTML, so
  "cannot group columns under a shared caption" was false; feature still distinct via first-class
  API + CSV/MD/TSV). And when the ai-eval marks a test group "borderline", adjudicate it yourself:
  the exact-form `<th>G2</th>` assertion was enforcing an attribute absence the spec never stated.

- 2026-07-03 (iceberg simplify v2, final): the "**Category**: ..." line in a downloaded
  description.md is a PLATFORM TOGGLE the author selects, rendered into the text, not author
  prose; never flag it. Reason boxes exist only under 3: a 3 gets score+confidence and nothing
  else author-facing (fixes-verified evidence goes in Illustrations). When a stated-form gap is
  found, check the near-miss junits for whether any run actually produced the bad shape and say
  which kind of proof you have (constructive counter-example vs observed); and re-run the
  passer-diff oracle on EVERY round's passer, not just the first.
- 2026-07-03 (iceberg simplify v2): a description fix can CREATE a test gap: the author answered
  "insufficiently reduced" failures by stating canonical output forms (single NotIn/In/StartsWith),
  which the equivalence+count oracle does not enforce; Not(In) and Not(StartsWith) are row-equivalent
  and the count helper looks through Not, so they pass while violating the new clause. After any
  description edit, re-run the stated-vs-enforced check on the ADDED clauses. Also: adjudicate an
  Env Quality FAIL against the junit evidence chain before treating it as real (conftest hard-imports
  + dev-group deps + fresh junits proved both harness modes run in the image; the checker's bare
  whole-tree pytest can never collect there by design since the Dockerfile prunes pyspark), and
  answer keep-old-base with the ruff three facts, running git fetch first so the facts are today's.

- 2026-07-03 (scrapy snapshot v3): a grep hit is a lead, not a finding: `required=True` on
  --target-cache-dir in two PASSING agents looked like a live contract violation, but the full
  command files showed argparse subparsers with the requirement scoped to replay; inspect stayed
  optional. Read the whole context before relaying any grep-shaped claim (rule 2). The same full
  read UPGRADED the needed-test argument: the wrong implementation is a one-line copy-paste from
  the adjacent replay subparser, which is stronger plausibility evidence than any n=3 passer
  survey. Also: a red readiness Difficulty row can be STALE relative to a tier downgrade (30%
  fails Olympus, fits Mars <=30); grade against the tier the submission now targets and say the
  row predates the downgrade instead of calling the gate red.

- 2026-07-03 (scrapy snapshot v2): cmp test.patch and solution.patch FIRST on every download; here
  they were byte-identical (test.patch had received a solution copy) and the real hidden suite had
  to be recovered from quick-setup.sh's heredoc, which is the platform-generated ground truth
  (verified: embedded solution matched the local file, embedded test names matched the fresh
  junits). Also: a readiness Difficulty row can flip red on a resubmission (20% -> 30% after the
  author removed the dominant-trap test), so re-read the readiness table on every round instead of
  carrying the previous verdict forward; and FAIL_INTEGRATION_ERROR verdicts can be ordinary
  agent-side API mismatches, read the summaries before treating them as environment blockers.

- 2026-07-03 (typestat v2b): git-diff staleness checks only work on TRACKED files. auto-review.json
  was an untracked v1 leftover, so `git diff` showing nothing meant "not tracked", not "unchanged",
  and the claim "byte-identical to v1" was wrong; the current platform view has no auto-review for
  the task at all. Run `git ls-files <file>` before claiming a file did or did not change, and
  when an artifact is absent from the platform view, say absent, not stale.
- 2026-07-03 (typestat v2): two false-positive traps in one re-review. (1) vitest outside CI
  auto-updates snapshots: a three-suite run reported "1 failed" and left a .snap modified, which
  read as a golden regression in an author-excluded suite; under CI=true with a pristine snapshot
  it was 25/25 both states. Claim regressions only from CI-mode runs. (2) junit test-name
  truncation merged two tests ("widens object annotations from nested" prefixes both the
  nested-writes and nested-destructuring names) and made one look like a 9/10 universal failure.
  Also: diff the eval/auto-review files in git before trusting them; here both were byte-identical
  to v1 (42/8 counts vs the real 37/10), so the platform checks on file described the previous
  artifact set, which alone bars an approve.
- 2026-07-03 (ruff layers round 2b): the passing agent's diff is an ORACLE for golden omissions:
  diff what the passer touched against what the golden touched; the delta here (ruff.schema.json,
  regenerated by the agent, absent from the golden, siblings present in the file, generator in
  crates/ruff_dev) was a real Solution 2 that every automated check missed. Also: adjudicate each
  fairness-lightbulb item with a WRITTEN admit-test (covered-elsewhere / implausible-in-stack /
  valid) instead of a blanket skip; in Rust, serde uniform structs make per-kind field omission
  implausible, which is a legitimate language-grounded skip reason.
- 2026-07-03 (ruff layers round 2): a re-review is verify-the-fixes, not re-review-from-scratch:
  walk the v1 asks one by one against the revised artifacts (grep each marker), hunt NEW issues
  only in the changed regions, and demand fresh runs when the hidden suite changed (here the
  author shipped a fresh batch; junit-baseline going 2 -> 21 testcases PROVED the new base mode
  executes in the platform image). Answer a keep-old-base question with three facts: feature still
  absent at HEAD, `git apply --check` on today's main, range scan of the touched dirs for
  reusable/conflicting work; if all clear, old base is acceptable and re-pin stays optional.
  Reviewer-Instruction-Guide.md is now the source of truth (base runs existing repo tests;
  rejection only for duplicate/public-solution; all-3s must be high-confidence).

- 2026-07-03 (typestat shapes): when the description states a general rule and every test fixture
  exercises only its special case (empty {} / [] placeholders), build the matrix with annotation
  state as a COLUMN; the whole non-empty column was untested and the golden itself failed one cell
  (annotated arrays never widen; shouldSkipNode drops built-in Array/Set/Map). Proven by a probe
  fixture run through the repo's own runMutationTest, not by reading. Also: check what test.sh
  base actually selects against the repo's test tree; `vitest run src` silently excluded all 15
  test/*.test.ts mutation suites, so I ran the most-affected one with the golden myself (green).
  Toolchain note: corepack pnpm is broken on this machine; `npx -y pnpm@<pinned>` under nvm node
  22 works.

- 2026-07-01 (assessment, ormar): an agent's "write-only attribute" claim shipped unverified and
  was wrong (`OuterRef._resolved_column` is read on the return path). Rule 2 in
  rules/verification.md exists because of this.
- 2026-07-01 (assessment, ormar): golden LOC at 375 vs 400 floor was absorbed silently. The
  author must get the choice: bump or downgrade. Rule 5.
- 2026-07-01 (assessment, pactum): feedback read AI-ish despite an explicit humanize pass, and a
  real bug (broken `@array` generator) was missed while cataloguing dead code. Bug-hunt pass
  (rule 3) and hand-written prose (writing-style.md) exist because of this.
- 2026-07-02 (panel change): 21-check Yes/No list replaced by three 0-3 scores with per-field
  reasons under 3; internal reasoning box removed, reasoning goes to Other notes; tags are
  internal. rules/platform-panel.md is the source of truth.
- 2026-07-02 (msw rooms): tier comes from the criteria panel targets, not the docker image name
  (a mars-base image shipped an Olympus-qualified task). Also: a new lifecycle hook is only real
  if the base repo calls it; handlers-controller.ts:109 `'reset' in handler` made the rooms reset
  wiring live, and finding that call site is what separated "clean" from "dead code".
- 2026-07-02 (msw rooms): honest 2s beat inflated 3s. Description with `--` artifacts and heavy
  clause density is the literal "2 Minor" hover line; scoring it 3 with the finding in notes reads
  as grade inflation to managers.
- 2026-07-02 (msw rooms, submitted version): LOC always goes in Other notes, never inside a scored
  field's text (Karim's field guidance). State counted numbers plainly and let the per-field
  confidence selector carry the uncertainty; hedges like "in case I calculated it incorrectly"
  weaken the review. Avoid internal jargon ("behavioral tone") in author-facing reasons. Pending
  optional checks (Env Quality / Harbor rebuild) are worth one actionable line in Other notes.
- 2026-07-02 (iceberg simplify): before endorsing ANY conciseness trim of a description, grep the
  tests for a clause that pins it; "giving the same result as simplify(expr)" looked redundant but
  a test asserts exactly that equality. A definitional clause ("agree on every row" = what
  equivalent means) is not redundancy. The removal razor: cut only what can NEVER mislead.
- 2026-07-02 (iceberg simplify): dead code in the solution is a Request Changes trigger, exactly as
  rules/platform-panel.md already says; do not drift to Approve because items feel individually
  small. Also decisive: judging a fairness-check (light-bulb) suggestion VALID forces Request
  Changes on its own, since managers return valid-and-skipped suggestions anyway (Karim).
- 2026-07-02 (iceberg simplify): never prescribe "add a comment" as a fix; state the defect (here:
  one call site swallows simplify errors, the other calls it unguarded, so they disagree on whether
  it can raise) and the acceptable directions, and leave the implementation to the author.
- 2026-07-02 (sqlparse params): apply the STANDARD, not the previous review's outcome. Two
  fairness-lightbulb suggestions looked like the tengo pair, but both underlying behaviors were
  covered by other tests (int-key via inventory[1]/getall(1); empty-query via require_style), and
  Karim's carve-out makes covered-elsewhere gaps skippable notes, not blockers. Blocker test: is
  a PLAUSIBLE wrong implementation caught nowhere else? Also: golden LOC floor is 400 (the ~380
  in count_loc.py/check_loc.md is stale), and the panel's long-horizon LOC row is raw diff lines,
  so a green row can hide a real meaningful-LOC failure (546 raw vs 336 meaningful here). And
  prechecks files can carry another task's check output (a Conciseness block quoting the iceberg
  description); verify quoted text exists in THIS description before acting on any check verdict.
- 2026-07-03 (ruff layers): an auto-review "upstream N commits ahead, diff overlaps" flag is
  resolved with three greps, not a browser: grep HEAD for the feature symbols (absent = not
  recreated), git log the overlap files in the range (benign = hot shared files), and read the
  on-topic upstream issues for rulings (positive maintainer signals here). Also: precheck files
  can carry stale blocks pasted from a DIFFERENT submission; grep the quoted sentences against the
  actual description before acting on them. And "base mode" that only runs newly-written smoke
  tests runs ZERO existing repo tests; check the repo's own test dir for a suite covering the
  files the solution refactors.
- 2026-07-02 (tengo dunder): verify the RUN STORY from the run artifacts, not the eval summaries.
  Reading the failing diffs found the literal misread in agent code (`if !isMapObject(left)`), and
  the passing diff was grepped for cheat signals directly. Also: "N runs" on the platform includes
  invalid/empty ones; the downloaded set is the valid runs, frame the numbers accordingly. And run
  the official count_loc.py before flagging LOC; a stricter hand count (328) nearly false-flagged a
  golden the official tool passes at 419.
- 2026-07-02 (ts-to-zod variadic): the bug all checks missed was proven by RUNNING the patched
  worktree, not by reading: a tiny generate() repro showed shared-`seen` cycle guarding collapses
  `[...A, ...A]` to z.tuple([z.any(), z.any()]) silently and false-positives under strictTuples.
  Predict-from-source then prove-by-run is the pattern (fail-on-base was also predicted from base
  code, then confirmed 27/27). Also: a fairness-lightbulb's own example can be non-discriminating
  (its `A = [...number[], string]` errors alone); sharpen the example before relaying it to the
  author, or the added test proves nothing.
- 2026-07-02 (scrapy snapshot, final): the admit-test for a fairness-lightbulb suggestion is what
  the gap lets through AND whether that is caught anywhere else, and "wrong behavior on a stated
  rule" includes MISSING STATED SURFACE, not only wrong semantics. A command documented to ship
  --gzip/--on-conflict with zero coverage anywhere is needed-and-skipped (Tests 1, return),
  especially when the eval's failure patterns show agents actually failing on CLI integration.
  Cosmetic metadata drift with everything material pinned (middleware snapshot spider-name) stays
  a minor rider that cannot drive the decision alone. Process lesson: I oscillated RC to Approve
  to RC under owner push-back; anchor on the written blocker test FIRST (plausible wrong
  implementation caught nowhere else?), then weigh evidence, and never grade a stated surface as
  plumbing. Passing-agent corroboration at n=2 is weak evidence in either direction.
- 2026-07-02 (msw rooms REVERTED after Approve; both manager claims verified true). Miss 1: the
  spec made room state global across runtimes and said resetHandlers clears every link's rooms,
  but resetRooms() clears only local maps (solution.patch:590-595, no postMessage) while every
  other mutation broadcasts (join/leave/close/host), and the next room:sync-state even resurrects
  what reset cleared. LC1-LC3 are all same-runtime, so the suite never touches the cross-runtime
  x reset cell, and no auto check flagged any of it. Root cause: I verified reset() was CALLED
  (call-site trace) and stopped; wiring is not semantics (verification rule 8). Countermeasures
  now mandatory in the workflow: R3 coverage matrix (behavior x stated dimension; an empty cell
  on a stated dimension is a gap even when the fairness check is silent) and R4 propagation audit
  (every shared-state mutation broadcasts or is a remote-apply handler). Miss 2: golden LOC. The
  manager counts meaningful production lines minus comments, imports, braces, export-only wiring,
  blanks, boilerplate = 360-371; my lenient count said 398 and count_loc.py said 505. Floor is
  400, and a sub-400 strict count is Request Changes with bump-or-downgrade, not "at the floor,
  proceeds". The criteria panel's 1072 LOC row is raw agent diff and was never this gate.
  Meta-lesson: both misses were process, not data; every needed fact was in the artifacts, the
  workflow just never forced the two audits. Reconciles the tengo-dunder LOC note: count_loc.py
  screens against false flags, but the DECISION number is the strict manager-list count.
- 2026-07-02 (ts-to-zod variadic, revision): author-facing sections carry ISSUES ONLY (owner rule,
  now in writing-style.md and the template): no "suite is strong" openers, no clean-bill Other
  notes; positives live in Illustrations, and an issue-free Other notes says "None." Also flipped
  a covered-elsewhere call to needed via the R3 matrix plus live evidence: eval pattern 2 (five
  agents' index logic ran on written elements, caught only because the positional cell was tested)
  proves the same wrong split passes in the empty number/union-index cells. When failure patterns
  show agents making exactly the split a gap would admit, the gap is needed, not a combination
  nicety. And probe the golden on every test you demand before demanding it; all three probes
  passed here (union with inherited rest, union index on flattened, strict report naming only the
  outer tuple).
- 2026-07-26 (Atomic-cancellation v4, Approve 3/3/2): DON'T trust a static diff for a lint verdict
  when a real gate exists on the forge. I read the v3->v4 test.patch and saw TC003 moved to
  TYPE_CHECKING, PT011 gained match=, PLW1641 gained __hash__, and "5 noqa added", and nearly wrote
  "Ruff is cleaned" with Solution 3. The forge base-vs-patched run said otherwise: production
  PERF203 x2 STILL fire because the # noqa: PERF203 sits on the `for` line while PERF203 anchors to
  the inner `try`, so the suppression misses AND the two directives report unused (RUF100 x2); the
  test file still carries EM102/FBT001/FBT003/PLR0915 and wants ruff format on two files. A noqa
  present in the diff is not a noqa that suppresses - placement matters, and only running the gate
  proves it. Lesson: seeing a suppression token in a patch is necessary, not sufficient; run the
  actual gate. Second: a cosmetic gate-red on correct code (hides no FP hole, no coverage gap;
  mypy+pyright green) is a Minor (Solution 2) + aligned Other note, NOT a Request Changes - matches
  the sbi lesson (gate-red on correct code = note, not return) and Karim (real minor = 2 not 3),
  and stays an Approve. Third: honor the panel only where it's CONFIRMED - the owner gave me
  Description 3/3 and Tests 3/3 but the Solution line was cut off, so docking Solution to 2 for the
  gate residual contradicts nothing. Fourth: LOC criterion is the MEDIAN OF SUCCESSFUL RUNS
  (688 here) vs the 250 floor, NOT the golden solution's own count (277); my v3 "straddling 250"
  note had wrongly gated on the golden count. Fifth, the good news: the 5 verifier-audit gaps were
  closed with the exact validated remedy tests (diffed vs proposed-changes.diff; FP re-ran at 65
  hidden tests), and FP went PASSED_WITH_WARNINGS -> PASSED clean, so the mandatory check plus
  closed gaps carry the Approve even with the cosmetic residual.
- 2026-07-27 (Add-exclude_dependents v2, Approve 3/3/3): reaffirms Atomic-cancellation's RUN-the-gate
  in a Go setting, with a concrete new fact. I nearly wrote a callback-style RC on the read that all
  52 new b7f1e9 test funcs omit t.Parallel() while the base tests in those packages use it and
  paralleltest is enabled in .golangci.yml. The forge gate said 0: golangci-lint v2's paralleltest
  DEFAULTS TO ignore-missing, so it never flags a missing t.Parallel() unless the config sets it
  true. Static lint reads about parallel-test are false until the gate runs. Then a FULL-config
  base-vs-patched (all ~50 linters, seven touched pkgs) confirmed the real verdict: base 49 issues,
  patched 49, ZERO on patch-introduced files (protection.go + b7f1e9 tests) and ZERO new on modified
  sources = R4b clean. Second, the terminal-approve shape: my v1 blocker (write-back must round-trip
  an explicit false, not truthiness-drop) is closed and load-bearing (the false + omitted assertions
  fail the shortcut), the author's UNASKED expansion (a whole prevent_destroy reporting slice) audited
  correct (pure-lexical cause, deterministic, precedence-guarded by `if unit.Excluded(){continue}`,
  both precedence directions load-bearing at 5/6 failing runs), and the lone verifier-audit residual
  (prevent_destroy cause at unequal graph distance) is VCA-only + reference-correct + no-passer-slips
  (4/4 passers lexical-only, 2 keep distance machinery deliberately out of that path) = owner
  good-to-have in Illustrations, NOT a Tests deduction (react-native v6 precedent). All-3s earned;
  don't manufacture a minor to hedge when mutation scrutiny finds nothing above the audit's pedantry.
- 2026-07-27 (Add-whole-program, Request Changes 2/1/2): a broad "multiple readers" coverage
  suggestion can contain one skippable generic case and one blocking integration branch; adjudicate
  them separately. Here, assignment/guard/control readers all go through the general port rewriter,
  so another reader count is hardening, but an invoke output binding uses dedicated logic in the
  legitimate passer: remove the binding, synthesize a comb group, and write the constant to the
  caller destination. Omitting that branch loses the write while every current hidden constant-
  output test stays green, so the invoke cell is T3/T4 even though Test Fairness called the combined
  suggestion advisory. A clean FP does not close this gap when the sole evaluated passer implements
  the missing branch correctly; FP tests whether that passer deserved its pass, not whether an
  unrepresented omission can pass. Also reaffirmed the format lesson on the forge: Calyx's exact
  `cargo fmt --all -- --check` gate produced patch diffs, so score the cosmetic S2 issue from gate
  evidence without making it the return driver.
- 2026-07-27 (Add-whole-program v3, Request Changes 3/1/1): severe automated findings still need
  language-level validation. The score-0 claim that a caller can use an instance input directly as
  `if instance.input` was impossible: Calyx keeps that port `Direction::Input`, while control
  conditions require `Direction::Output`; the legal own-input case uses the reversed `_this` port
  and the generic rewriter already covers it. Rejecting that false lead exposed the real blocker in
  the false-positive report: its panel executed an FSM probe that both candidate and reference fail,
  then excused it by claiming `ast_to_ir` cannot produce FSMs. The repository contradicts that
  premise end to end (`fsm` is surface grammar, the parser collects it, `ast_to_ir` preserves it in
  `Component::fsms`, and control enables it). The golden's liveness, constant analyses, and rewrite
  paths all skip that sibling collection, so live ports/refs and state-specific drives are missed.
  New rule: "reference also fails" settles only FP discrimination; it never proves golden
  correctness. When a shared-failure probe maps to the prompt, validate REACHABILITY against the
  parser/converter before accepting an adjudicator's "lowered/unreachable" rationale.
- 2026-07-28 (Add-whole-program v4, Request Changes 3/1/1): a PASSED false-positive evaluation can
  contain stronger evidence against the golden than a clean solution auto-score. Here the FP panel
  approved a legitimate passer but explicitly found two fair cases where it was more correct than
  the reference: a ref primitive used as an invoke target, and an instance activated structurally
  as well as through an invoke-only constant. Tracing the reference confirmed both: invoke bindings
  were counted but the target cell itself was not recorded as a ref mention; constant qualification
  counted invokes but not the sibling `@go` activation path. New rule: always inspect candidate-
  better-than-reference notes inside a PASSED FP report, and distinguish a cell's use as an operation
  target from uses appearing in that operation's arguments. Also adjudicate automated cross-product
  suggestions against repository validity and shared mechanisms: the proposed local `@external`
  fixture was illegal outside the entrypoint, while separate `@clk`/`@reset` cases duplicated the
  already shared interface-port path; only the independently omitted FSM cleanup/rewrite branch was
  a material additional verifier gap.
- 2026-07-28 (Add-whole-program v6, Request Changes 1/1/1): author rebuttals must be split claim by
  claim. The `@external` and `@done` omissions were genuinely justified by Calyx validity and port
  direction, but that did not settle the author's ref-binding question: “binding counts as a
  mention” can mean original syntax or only a binding that survives fixed-point pruning. The
  author's cascade is coherent, so an automated Solution 0 was not a proven code bug; the correct
  finding is P4 plus a discriminator test until temporal semantics are explicit. Separately, when a
  returned defect is repaired with a new carrier scan, enumerate every carrier again. The new
  structural-`@go` helper covered assignments, groups, static groups, and FSMs but missed invoke
  output destinations, even though the legitimate passer handled that path. Finally, inspect
  shared candidate/reference failures inside a passing FP report: “both fail” only removes the
  candidate discriminator. It does not excuse the golden retaining a component input used only as
  a dead memory read address, which conflicts with the prompt's observable-state rule.
- 2026-07-29 (Add-whole-program v7, Request Changes 3/1/3): when an ambiguity is resolved by
  choosing one side, the new verifier must defeat the exact implementation that was legitimate
  under the old wording. The description now makes every stateful primitive input live, but the
  added `comb_mem_d1` test still fits the old passer's `name.contains("reg") ||
  name.contains("mem")` heuristic. The prior panel had already executed the real discriminator,
  `std_mult_pipe`, and proved that heuristic drops the source while the reference keeps it. This is
  the superellipse threshold miss in another form: a boundary test exists, but its chosen point
  dodges the known failing family. Also, a fresh unanimous FP pass does not close verifier
  completeness when it evaluates only a new correct passer; carry forward discriminators from
  earlier panels after the contract changes. Conversely, reject automated gaps that cannot form a
  valid source program: Calyx well-formedness forbids the suggested pair of unconditional drivers
  to one output.
- 2026-07-30 (Generate-Safe-Typed-SQL, Request Changes 2/1/1): a PASSED FP report's "safe
  superset" can identify a missing golden requirement, not merely harmless candidate hardening.
  The evaluated passer protected `CONIN$` and `CONOUT$`, while the reference and verifier covered
  only the common Windows device names. The description required the whole Windows-device class,
  and Microsoft's DOS-device API lists both omitted names, so the candidate/reference divergence
  exposed a real S1 and T3/T4 gap. Re-derive every claimed superset against class-level wording and
  authoritative domain rules. This review also sharpened the successful-agent LOC check: the
  platform's 389-line median included roughly 200 lines of agent-authored tests per passer, while
  their lenient production counts were only 152 and 176. When the task panel reports raw diff LOC,
  remove agent tests before deciding the scope gate; a duplicated golden resolver cannot make a
  164-line median into an Olympus-sized task.
- 2026-07-30 (ISPC function attributes, Request Changes 2/1/1): an automated high-severity syntax
  omission still needs semantic adjudication against both the task's exemptions and the target
  language. The claimed missing `alloca()` effect was not a golden defect: ISPC defines it as
  temporary stack-frame storage, LLVM's `memory(none)` permits effects confined to local
  allocations, and the task exempts purely local stack storage. The real golden defects came from
  tracing context through the generic AST walk. Descending into an implicit reference or an
  unevaluated `sizeof` operand charged a read that never occurs; unioning provenance from both
  operands of every binary expression tainted boolean and comma results; and ignoring termination
  carried aliases across impossible switch-case paths. New rule: for effect and provenance
  analyses, a child-node grep hit is only evidence after proving that the child is evaluated and
  that its value contributes to the parent result. Pair every positive violation test with
  valid, result-sensitive and control-termination counterexamples.
- 2026-07-31 (ISPC function attributes v2, Request Changes 2/1/1): fixing one control-flow example
  does not establish that a lexical AST walk has become a sound flow analysis. The revision
  separated flat switch cases around `break`, but still ignored `goto` edges and merged state from
  `if` branches that had already returned; it could therefore both miss a real escape and invent
  one on an impossible continuation. Audit every transfer family after a flow fix: fallthrough,
  return, break, continue, and label/goto, in both false-negative and false-positive directions.
  Also enumerate expression forms independently of result categories: changing binary provenance
  to inspect result type fixed comparisons and pointer subtraction, but `UnaryExpr` remained absent,
  so returning `++p` still escaped silently. Finally, when a description newly assigns directions
  to effects, a test that only checks `none` is not load-bearing: any nonzero classification passes.
  Require each directional boundary under the contract that distinguishes it.
- 2026-07-31 (Generate-Safe-Typed-SQL v2, Request Changes 3/1/1): testing a downstream builder
  directly can prove its transformation while missing that the repository's real producer rejects
  the input first. Both hidden suites constructed `SqlQueryOutput` and called `buildTypedSql`;
  Prisma's public `generate --sql` path calls `readTypedSqlFiles` first, which rejects non-
  identifiers and every `$`-prefixed basename. The golden and one platform-labelled passer
  therefore passed 19/19 while core examples such as `find-user.sql` and `$runtime.sql` never
  reached their resolvers. New rule: for a feature that broadens accepted input, trace from the
  public entrypoint through every pre-validation gate, and require at least one test to traverse
  that path. A PASSED_WITH_WARNINGS FP result is not clean when its passing candidate shares the
  same upstream bypass. The revision also reconfirmed that regenerated passers do not reset LOC:
  their raw 424/501-line patches contained 241/289 test lines, leaving only 158/190 meaningful
  production lines and the same scope failure as v1.
- 2026-07-31 (kurbo superellipse v5, Request Changes 3/1/1): scale normalization must cover every
  numerical path, not only the operation named in the previous finding. The author normalized
  perimeter integration, but outline fitting still passed raw coordinates and tolerance into a
  repository fitter that compares squared distances. At radius 1e-200 both the chord error and
  tolerance squared become zero; at radius 1e200 both become infinity. In both cases a quarter
  circle is accepted as a straight chord while missing the requested tolerance by many orders.
  New rule: whenever the contract spans extreme scales, enumerate every place that squares,
  multiplies, or subtracts scaled values, and test the observable result in normalized units.
  Finiteness, endpoints, and bounding boxes do not verify geometric accuracy. This round also
  repeats the threshold-chasing lesson: reducing an outline allowance from 2x to 1.3x does not
  close a known 1.068x violation, and moving a near-axis case from a 1e-9 snap band to 5e-13 does
  not cover a new passer's 1e-14 band. A returned behavior class needs a discriminator inside the
  known failing region, not merely a closer sample.
- 2026-07-31 (ISPC function attributes v4, Request Changes 2/1/1): an AST-level validator is not
  automatically target independent when it runs after AST optimization. Here `programCount`
  carries `TARGET_WIDTH`, and symbol, binary, and selection folding can discard a violating arm
  before the conformance walk. A cross-target test with only target-neutral expressions cannot
  detect that ordering defect. When diagnostics must match across targets, trace the analysis
  relative to every target-dependent transform and include an explicit-width discriminator whose
  selected arm changes. Also include assignment expressions in result-provenance matrices:
  testing `a = p` as a statement does not cover the pointer value produced by `return (a = p)`.
  A reference and all credited passers sharing the same analysis placement is not correctness
  evidence when the placement contradicts the task contract.
