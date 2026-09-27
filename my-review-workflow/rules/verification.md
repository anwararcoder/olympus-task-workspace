# Verification discipline

Manager feedback from the assessment produced these rules. They are cheap and they are the
difference between a reviewer and a relay.

## 1. Agents are helpers, not reviewers

Subagents do mechanical work: LOC counts, run tallies, greps, gh searches, listing candidates.
Judgment (scores, fairness calls, repo-fit calls, the written text) is mine. The manager warning
was explicit: leaning on agents as the actual reviewer just re-runs the auto-review.

## 2. No claim ships unverified

Every factual assertion in the review gets confirmed in the file or shell before it ships,
especially the sharp ones: "never read", "never called", "dead code", "unreachable", "N of M runs
failed on X", "no upstream PR". The `OuterRef._resolved_column` lesson: an agent called it
write-only, it was read on the return path, the manager caught it. If I cannot point to the line,
the claim does not go in.

## 3. Hunt the bug the tests missed

One explicit pass over the solution asking only "where is the functional bug?" before scoring.
The pactum review missed a broken `@array` generator while cataloguing dead code. Checklists find
noise; the bug hunt finds defects. Trace the riskiest paths by hand (sync logic, election,
lifecycle hooks, error paths).

## 4. Trace new hooks to their call site

Any new override, callback, or lifecycle method in the solution must be traced to the base-repo
code that invokes it, quoted with file:line. If the framework never calls it, it is dead wiring
even when tests pass for another reason. (msw rooms: WebSocketHandler.reset() is live because
handlers-controller.ts:109 does `'reset' in handler` then calls it.)

## 5. Surface LOC to the author, always, and act on it

If the golden sits at or under the tier floor, the author hears it with the choice: bump scope or
take the downgrade. Silently absorbing it (or silently downgrading) is the mistake from the ormar
review. Surfacing alone is not enough either: a strict count under 400 is Request Changes, not a
note under an Approve; "398, at the floor, proceeds" got the msw review reverted at the manager's
360-371 count. Also compare passing agents' diff size to the golden: agent much smaller = weak
tests or padded golden; agent bigger = healthy.

## 6. Build only when it decides something

Runs plus the golden already prove base-green, fail-on-base, pass-on-solution. Rebuild the docker
image only when a finding depends on something the artifacts cannot show (excluded base suites
possibly broken by the solution, a suspected flake). Say in the review whether it was built and
why.

## 7. Fresh-eyes gate

The last read of the review doc happens after the analysis is done, checking only two things:
claims (rule 2) and tone (rules/writing-style.md). Anything new found there goes back through the
loop, not patched inline in the middle of submitting.

## 8. Wiring is not semantics

Tracing a hook to its call site proves it executes, not that it satisfies the spec. After the
call-site check, test the effect against every dimension the description states. msw rooms:
reset() was genuinely invoked by resetHandlers(), but it cleared only the local runtime's maps
while the description made room state global across runtimes; the review verified the call, never
the scope, and the submission was reverted. The two structured audits that catch this class are
the R3 coverage matrix (behavior x stated dimension) and the R4 propagation audit (every
shared-state mutation broadcasts or is a remote-apply handler). Run both whenever the description
uses words like global, shared, every runtime, all links, or synchronized.

## 9. Platform artifacts are inputs, not oracles

prechecks.md is the owner's paste of the platform panel: it can go stale mid-review and can carry
another task's blocks. auto-review.json has been factually wrong twice (claimed no Dockerfile
existed; called a running test a no-op). The review-panel screenshot is a stale template. JUnit
test names truncate. Any claim sourced from these gets re-verified against the real artifacts
before it ships, and a check's status is stated only from an explicit verdict line or the owner,
never from a missing section.

## 10. A set-up probe gets run; reasoning never substitutes for a verification you started

If you decide a question needs execution and write the probe, RUN it. Forge flaky, billing 402, a
slow build: retry, or build locally (pure-Python venv, `cargo`/`go`/`npm` in a worktree), never
swap in an assumption and ship. The kurbo-superellipse revert: I set up a probe for "does the
reference honour its accuracy at high n," abandoned it when the forge went flaky, wrote "accurate
by design, like every kurbo shape," and scored Solution 3; the reference in fact returned a
perimeter of 14.23 above the 14.0 convex ceiling at n=4096. "Accurate by design" and "correct by
construction" are the exact phrases that mark an unverified assumption on the one path that
mattered. Numerically singular features (n->0, n->inf, tolerance->0, empty/huge inputs) get their
SINGULAR LIMITS executed, both ends, and get checked against an invariant that must always hold (a
convex perimeter <= its bounding-rectangle perimeter; a probability in [0,1]; a monotone series
that cannot decrease). The FP/auto-review stack does not test these: its probes here were all
FP-direction or collapse-focused and every one missed the overshoot.

## 11. Distrust numeric thresholds and comments; verify against the actual code path

A magic number in a guard, a tolerance, an overflow point, or a "this is safe above X" comment is a
claim, not a fact. Check it against the actual implementation, not the textbook. kurbo-superellipse:
the area guard branched on `1 + 2/n < 171` with a comment "gamma overflows above ~171.6", but the
specific Lanczos code overflows in its `t.powf(x+0.5)` intermediate at argument ~143 (149.5^142.5 >
f64 max), so n in [0.012, 0.014] took the direct path and returned area 0.0  -  the original bug
re-thresholded, not fixed, and the tiny-exponent test dodged the band. One line of arithmetic
(`is 149.5^142.5 > 1.8e308?`) settles it. When a guard picks a branch by a constant, ask "at what
input does THIS implementation actually break," and confirm a test lands inside the dangerous band,
not just near it.
