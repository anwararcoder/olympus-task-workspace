# Configurable Collection Implementations - Post-v5 Submission Repair Plan

## Current state and decision

The post-v4 candidate passed platform prechecks and difficulty calibration. Fourteen run bundles are
archived, but the platform correctly excluded one verifier-broken run from the working pool. The
gradeable population is therefore 13 runs:

- one `PASS_LEGITIMATE`;
- eleven `FAIL_MISSED_REQUIREMENT`; and
- one `FAIL_REGRESSION`.

The effective legitimate pass rate is `1/13` (7.7%). The passer preserves all 3,641 classified
baseline tests and passes all 51 focused invocations. The false-positive panel independently
reproduced 51/51 and adjudicated the pass as genuine with high confidence. This proves the task is
solvable, and the population is safely below the 40% ceiling.

The task is not submission-ready because auto-review found one material test-coverage gap. The
description requires configured implementations for collection results materialized from streams,
but the current stream fixture checks only factory precedence; it does not prove that a configured
implementation is used when no factory applies. Auto-review consequently returned
`revision_requested` with a single High-severity T4 issue while rating the description, reference
solution, and agent-run signal clean.

Two additional fairness defects are established by run evidence:

1. the excluded run correctly received `FAIL_TEST_BROKEN` because both solver and verifier created
   `WithClasspathResources` with incompatible `value()` types, producing five test-compilation
   errors before production behavior ran; and
2. a gradeable failing run used the valid diagnostic cause `implementation type is not a class`,
   while the verifier accepted only `concrete`, `interface`, `abstract`, or `instantiable`.

This document is the immutable post-v5 strategy. After the v5 checkpoint, record execution in the
ledger and leave the repaired submission artifacts uncommitted. Do not rewrite this plan or
`commit-message.txt` during execution.

## Exact v5 submission manifest

| Artifact | SHA-256 |
| --- | --- |
| Description | `c51dd22207bf61addfd5fa97170108e996eea351b089c22dfbdc6656752dac4c` |
| Test patch | `2c2f952bbb4714d9a88e81bfd045e53046547901635e2bde1f7e4ffcd1e5323e` |
| Solution patch | `4662cb17de0caba59553ec8a7193185c2b08cccd7628ff1437437bb4b672f560` |
| Dockerfile | `045350f5c216e79a809e6d2321458530e7ce13d8b367cc709b68a8c9dbb62cd3` |
| Auto-review | `c06f6ddb5868ceec69cd241c335b801eb03fa688c9eae5dc30683f6fe96e2e42` |
| False-positive evaluation | `90bddbb8fc00b798da6229e6664337f1104f81f3ea7ac5570cd20bb13a7cdd30` |
| Base commit | `7ad5f9e56e9896c8f165d509b0cff8916061e85e` |

All fourteen evaluator JSON files, JUnit XML files, candidate/workspace patches, logs, metadata,
trajectories, and run records belong to the checkpoint evidence. The test-broken run is useful
fairness evidence but is not part of the 13-run difficulty denominator.

## Goal of the repair

Produce a test-only successor that:

- closes the one explicit stream-materialization coverage gap;
- composes with the independently created plural classpath-resource helper instead of failing
  during test compilation;
- accepts semantically equivalent interface-kind diagnostics;
- preserves all existing functional discriminators, clean-base polarity, and invocation-scoped
  resources;
- leaves the already approved public contract and correct reference implementation unchanged; and
- is ready for platform verification without a local solver replay or a long local/remote build.

The no-factory stream assertion is not a new requirement. It directly tests the existing sentence
about stream materialization. Multiple Nova runs already implemented and locally exercised
configured stream construction without a factory while failing the separate factory-precedence
branch. Adding this oracle therefore closes a false-positive hole without introducing a novel
architectural obstacle for Nova.

## Repair 1 - isolate the repeatable annotation container

The hidden `WithClasspathResource` annotation is repeatable through the generic top-level name
`WithClasspathResources`. One solver independently introduced the same natural name with
`String[] value()`, while the hidden container requires `WithClasspathResource[] value()`. Java
cannot make those APIs a compatibility superset because an annotation member cannot be overloaded
by return type.

Replace only the hidden container mechanism with a collision-resistant form:

- prefer a nested container inside `WithClasspathResource`, or use a task-suffixed container name;
- keep the singular annotation's existing `value()`, `name()`, and `target()` compatibility API;
- keep the current repeatable behavior for the one selected-over-default method that needs two
  resources; and
- do not add module-global resources or teach production code about test harness details.

After regeneration, the hidden patch must no longer own the solver-colliding
`WithClasspathResources.java` path. Static patch inspection must show that a solver-defined plural
annotation can coexist at test-compilation time. No solver run will be reconstructed or replayed.

## Repair 2 - add the missing no-factory Stream oracle

Build on the existing stream configuration and fixtures:

1. add one collision-resistant mapper declaring `List<String> fromStream(Stream<Long> source)` and
   no object factory;
2. reuse the existing properties resource that configures `java.util.List` as `ChosenList`;
3. add one ordinary `@ProcessorTest`, retaining the repository-default javac and Eclipse variants;
4. assert exactly `ChosenList` and the mapped values `"1", "2"`; and
5. retain the existing factory-precedence method unchanged as the complementary branch.

Do not assert a synthetic source size for a Stream, add a constructor rule, or expose a repository
template or internal class. The new method must fail on pristine MapStruct because it returns the
built-in implementation and pass with the existing reference because its configured implementation
already flows through the Stream collection supplier.

The focused suite should grow from 51 to 53 compiler invocations. This addition should not raise
the pass rate; it can only reject a previously incomplete solution. Solvability remains grounded by
the existing reference architecture, the genuine passing implementation, and the several Nova
solutions that already demonstrated this no-factory branch.

## Repair 3 - accept the valid interface-kind diagnostic

Broaden only `shouldRejectInterfaceImplementationTypes` so its cause alternative also accepts
`not a class`, with an optional article if useful. Retain:

- compilation failure;
- the exact `ChosenListContract` offender; and
- a semantic cause showing that an interface is not a usable concrete implementation.

Do not relax the conflicting-duplicate cardinality or any functional construction assertion. The
affected run remains a legitimate failure because it independently misses Stream factory
precedence under both compilers.

## Preserve the approved artifacts

Do not change:

- `mapstruct-configurable-collection-implementations.md`;
- `solution-mapstruct-configurable-collection-implementations.patch`;
- `Dockerfile-mapstruct-configurable-collection-implementations`;
- resource ownership, validation, later-round, generic, constructor, exact-interface, property,
  update-target, or factory-precedence requirements; or
- the reference production/documentation worktree.

The false-positive dissent concerning a directly assignable `Iterable` bean property is not a
required repair. MapStruct constructs no result in that probe, the prompt activates replacement
only when MapStruct constructs the exact interface result, and the reference behaves identically.
Adding special construction there would create a new requirement.

Do not follow generic conciseness suggestions that remove the direct-property or Stream examples.
Those examples are load-bearing fairness clarification, and current auto-review rates the
description clean. The absent-default and never-materialized-type suggestions remain advisory:
broad baseline mode protects no-resource behavior, and the existing missing-type rejection proves
eventual failure. Docker/JDK and license warnings remain previously adjudicated scanner noise.

## Lightweight execution and verification

Work only in the existing task-owned worktree:

`/home/zeyad/Downloads/ai/shipd/worktrees/mapstruct-configurable-collection-implementations-20260721`

After the three repairs:

1. regenerate only the test patch from the test/harness/resource paths;
2. prove the description, solution patch, and Dockerfile hashes are unchanged;
3. compare changed worktree paths with test- and solution-patch paths, with no omissions, extras,
   or overlap;
4. run `git diff --check`, `bash -n test.sh`, and exact-base cached patch application with
   whitespace enforcement;
5. inspect the new mapper/test/resource linkage and the two relaxed harness/diagnostic expressions;
6. if a small focused Maven selector is already warm and completes cheaply, run only the affected
   logical methods; otherwise rely on the existing 51/51 golden plus static reference-path proof
   and let the platform execute the final suite; and
7. append hashes and evidence to the ledger.

Do not run any saved or fresh solver locally. Do not run Docker, the full repository suite, broad
regressions, a remote four-state matrix, or a remote Codespace for this test-only repair. The
platform is the authoritative empirical verifier for the final bytes.

## Platform acceptance gate

Submit the exact repaired artifacts and require:

- base/test polarity and reference/test success;
- no `FAIL_TEST_BROKEN`, environment, or diagnostic-wording false negative;
- at least one legitimate pass and no more than 40%;
- every passer to clear false-positive review; and
- auto-review to close the no-factory Stream T4 issue without identifying a new material gap.

The platform population is the only pass-rate claim. Local static evidence establishes coherence
and preserves known solvability; it does not attempt to predict or reproduce nondeterministic agent
behavior.
