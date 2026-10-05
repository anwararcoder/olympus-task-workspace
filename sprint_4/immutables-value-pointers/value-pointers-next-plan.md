# value-pointers next plan (v8) - close the eligibility CLASS, ship

> Immutable plan stays `value-pointers-plan.md`. This supersedes the executed v7 next-plan.
> Phase A (this commit, tag v7): the 46-test artifacts as submitted and judged, the 12-run
> batch (1 Orion pass), the FAILED false-positive report (derived-only eligibility), fresh
> prechecks, and this plan. Phase B (next): the v8 close below, verified with light local
> checks only.

## Current state

All checks are green except one: Test Fairness says "All hidden tests are fair" (the flagged
assertion is gone), Verify Solution and Solution Quality passed (the batch ran), the
description sits at 505 words (advisory WARNING only), and the 12-run batch produced a
legitimate-looking 46/46 pass (agent-11, Orion). The false-positive panel then failed that
pass, high confidence, on ONE vector:

- A copy=true implementation whose only attributes are @Value.Derived has NO settable
  attributes, so the repo's own isUseCopyMethods() is false: it does not generate modified
  copies. Per the stated veto ("whose implementations, whether or not they belong to the
  family, do not all generate modified copies, receive nothing") such a family must get no
  companion. agent-11 applies its copy check only when settable attributes exist, so a
  derived-only family wrongly receives a companion. Judge-b's DerivedOnly probe was executed
  on both worktrees: candidate generates DerivedOnlyPointers (probe exit 1), the REFERENCE
  generates nothing (probe exit 0). Reference correct; suite blind.
- judge-c's whole-container element items self-tagged SPEC_GAP_REFERENCE_ALSO_FAILS and were
  overruled. That corner (erasure element checks) stays monitored grey: adding a test there
  fails our own reference and four-state. Never touch it.

## What has been blocking this task, through the whole history

1. v1-v2 (two 0% rounds): unfairness and over-stacked difficulty - a harness race, one
   ambiguous overflow cell, and two walls (obscure optional flavors, misfit-erasure pins).
   Fixed by the mktemp-isolated harness, dropping the walls, and the three-artifact
   downward alignment (desc + tests + reference together).
2. v3-v4: the era of silent-wrong corners. First legit pass, but the (newly required) FP
   panel found the int-overflow index wrap; closing it surfaced the next passer with two more
   untested taxonomy corners (family-only roots, BiMap opacity). Root cause: the fixture
   surface was narrower than the promise surface.
3. v5: the one clean panel (PASSED_WITH_WARNINGS, genuine Orion pass). The human review and
   auto-review then demanded six completeness fixes - stated-but-unenforced behaviors (null
   at element positions, unconditional public visibility, mixed copy family) plus harness
   and wording items.
4. v6-v7 rounds: the eligibility boundary began eating rounds. The panel walked from
   copy=false in-family (MixedCopy, auto-review) to copy=false non-family (Loose, the
   agent-8 FP) - each fix enforced the probed INSTANCE, not the class.
5. v8-v10 rounds: the platform's solution-quality checker found two real reference gaps
   (null inside containers walking to the wrong exception; withers emitted for non-settable
   attributes), and the no-forge constraint produced two self-inflicted one-line breaks (a
   checker-type cast, a template DSL precedence misparse) that each cost a full check cycle.
   Both fixed; a fairness over-pin (negative pointer equality) removed; lazy coverage added.
6. Now (v7 tag): the THIRD member of the same eligibility class - settables-empty
   (derived-only) implementations. Three FPs on one class because the class was never
   enumerated: every condition that makes isUseCopyMethods() false. And three different
   passers implemented three different wrong APPROXIMATIONS of "generate modified copies"
   instead of finding the repo's own concept - the description let them guess.

The meta-lesson (this is how exhaustive-fold escaped the identical trap and got accepted in
sprint4): when the panel confirms an FP, mirror its exact executed probe as a fixture + test,
replay-prove surgically, never weaken anything, and make the underlying rule impossible to
approximate wrongly - then resubmit. bean-to-map's v8-v9 recovery used the same rhythm.

## The v8 close (test patch + one description phrase; SOLUTION UNTOUCHED)

### W1 - Derived-only family fixture (the class member that fired)

- New fixture `Stamp.java` (package-private, hashed package): a two-implementation family
  where BOTH impls have only @Value.Derived attributes (no settable attributes, copy left
  on):

      @Value.Enclosing
      interface Stamp {
        interface Mark {}
        @Value.Immutable
        interface Seal extends Mark {
          @Value.Derived
          default int code() { return 7; }
        }
        @Value.Immutable
        interface Print extends Mark {
          @Value.Derived
          default String ink() { return "k"; }
        }
      }

- Test: `check(absent("StampPointers"));` folded into companionShapeAndForeignSibling next to
  the other absence asserts.
- Reference evidence: the panel already built the reference on judge-b's identical probe
  shape and it generated nothing (probe exit 0). No reference change.
- Class enumeration (so no fourth round on this boundary): isUseCopyMethods() is false when
  (1) copy=false in-family - tested (NoCopy, MixedCopy); (2) copy=false non-family - tested
  (Loose.Shim); (3) no settable attributes - THIS fixture; (4) implementation-hidden styles -
  deliberately NOT fixtured (style-exotic, zero corpus presence, and W2 pins the rule
  conceptually); documented residual, monitored.

### W2 - Bind the veto to the repo's own concept (the user-sanctioned hint)

- Veto clause: "do not all generate modified copies, receive nothing." ->
  "do not all generate modified copies (the `with` methods), receive nothing."
- Why fair: withers are the repo's documented, user-visible generated API - this converts a
  phrase three passers approximated three different wrong ways into a lookup of an
  observable concept. This is the clarity-as-solvability lever (the overflow-anchor
  playbook), sized at +4 words (~509 platform words; length stays advisory).
- Explicitly refused (documented for the reviewer cycle): both conciseness asks to delete
  the family-membership qualifiers - those are the anchor phrases the FP adjudicators
  themselves quoted to ground the agent-8 and derived-only rulings; fairness anchors outrank
  conciseness (established precedent). The Dockerfile wrapper/mvn WARNING stays untouched
  (advisory; the build is demonstrably safe; an edit would re-stale every check). Both
  Shipd-bot description quotes are stale against current bytes (known quotes-previous-round
  behavior).

## Verification (light local, per owner constraint; no forge, no full builds)

1. Offline single-module compile IF the local repository has the dependencies
   (check ~/.m2 first): `mvn -o -q -pl value-processor compile` in the patched worktree with
   a capped heap - this compiles PointerModel.java AND parses/compiles Pointers.generator,
   killing both no-forge risk classes (Java types, template DSL). If dependencies allow,
   also `mvn -o -q -pl value-fixture -am test-compile`: runs the processor over the fixtures,
   generating and compiling every companion plus the test class - the exact class of failure
   (withBadge) that cost a cycle. If ~/.m2 lacks the artifacts, degrade to static gates and
   say so explicitly.
2. Static gates regardless: scoped patch regeneration from a pristine re-apply, solution
   byte-identical guard, git apply --check --whitespace=error + combined apply, ASCII,
   forbidden tokens, disjoint write sets, test.sh 100755, @Test count, description word
   count, and a line-by-line delta review against the committed patches.
3. Fail-on-base reasoning: the new fixture is interfaces + base annotations (compiles on
   base; builders generated by the base processor); the absence assert lives in the
   already-failing-on-base companion test.
4. The platform's Verify Solution check remains the executed gate before any batch.

## Expected outcome and the honest tail

- The confirmed vector is closed by the panel's own probe shape; the rule is now stated in
  repo vocabulary; nothing weakened; judge-c's grey corner untouched.
- Closing the FP fails agent-11 by design, so known passers reset to zero until the fresh
  batch. Solvability rests where it did every round the panel passed: the reference, the
  stated rule (now lookup-able), and the demonstrated Orion ceiling - agent-11 was one
  eligibility condition away, and the two prior Orion passers each landed after the
  equivalent anchor shipped.
- Residual risk, stated plainly: the panel may find a fifth corner somewhere in this task's
  wide surface; but the eligibility class - which produced three of the five FPs - is now
  enumerated and closed, the taxonomy corners are fixtured, the reference-side gaps are
  fixed, and the remaining grey corners are all SPEC_GAP-protected. This is the same
  position exhaustive-fold shipped and got accepted from.

## Deliverable/commit discipline

- Phase B edits ONLY: test-value-pointers.patch (W1) and immutables-value-pointers.md (W2).
  Solution and Dockerfile byte-untouched. Ledger and human-reviews stay as committed.
- v8 stays UNCOMMITTED on tag v7; owner reviews, submits, and the checks + batch + panel
  decide.
