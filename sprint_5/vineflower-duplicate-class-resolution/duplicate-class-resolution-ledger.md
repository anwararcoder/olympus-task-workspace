# Duplicate Class Resolution Ledger

This ledger is append-only. The foundation plan and draft remain unchanged evidence of
the earlier hypothesis.

## 2026-07-24 - Activation and authority refresh

- The user explicitly activated the Vineflower backup.
- Re-read the current review guides, workflows, standards, `.agent`,
  `new-dot-agent`, all active task evidence, all accepted sprint4 task histories, and
  three recent accepted human reviews.
- Revalidated live Vineflower `master` at
  `b8273988af850e8cfb234ca08d129058502b032f`; it matches the foundation pin.
- Issue #416 is open and has no comments or competing implementation.
- `develop/1.13.0` contains no relevant structural input/output change.
- The 2024 duplicate race fix is base behavior, not a configurable origin policy.

## 2026-07-24 - Contract correction

The foundation's unconditional "one archive per family" rule was rejected. Vineflower
deliberately tolerates incomplete or inconsistent inner-class metadata, and neither
the JVM nor `IContextSource` defines archive-level family ownership.

The retained hard invariant is narrower and output-driven:

1. exact binary-name duplicates select one origin;
2. an exact duplicate in an own-source metadata family activates a family anchor;
3. classes combined into that decompiled family cannot then be selected from a
   different own origin; and
4. families with no exact duplicated binary name retain existing split behavior.

Family identity uses `InnerClasses` and `EnclosingMethod`, never the spelling of `$`.
Libraries remain per-name lookup inputs because they are not emitted as own source
families.

## 2026-07-24 - Vertical slice and defects found

The first vertical slice added first/last/error, exact-byte identity, lazy probing,
source precedence, reload state, warnings, and selected-sink output. Focused execution
found and repaired:

- `last` initially marked a name seen before checking the selected unit, causing the
  winner to disappear from own-class enumeration.
- reload cleared parsed classes but did not re-register root units in the resolver.
- direct tests initially skipped Vineflower's explicit attribute-registry
  initialization, so real `InnerClasses` and `EnclosingMethod` attributes were
  discarded by the fixture harness.
- a recursive `ConcurrentHashMap.computeIfAbsent` design could update the same cache
  during enclosing-class resolution; it was replaced with a synchronized
  double-checked miss path.
- late source registration cleared exact-name entries but could retain an obsolete
  family origin and parsed class.
- the first family implementation rejected a nonduplicate outer/member split. The
  family lock now activates only when an exact name has candidates from more than one
  own origin.

The public-behavior harness now constructs the context through the existing
`Fernflower` option surface. New tests therefore compile on the clean base and fail on
missing behavior rather than referring to a golden-only resolver type or helper.

## 2026-07-24 - Focused verification and mutation evidence

- Reference feature suite: 21 JUnit scenarios, pass.
- Baseline suite: Vineflower's existing `LazyLibraryTest`, pass. Its two existing
  Java 8 fixture sources are compiled by the focused task without realizing every
  repository test-data toolchain.
- Public API end-to-end path:
  `Fernflower.addSource` -> class processing -> selected source sink, pass.
- Thread counts 1 and 4 produce the same winner and sink ownership.
- `git diff --check`: pass.
- Official `review-guides/count_loc.py`: 415 meaningful production lines in the
  generated solution patch, above the current approximately 380-line hard-task
  threshold.

Executed mutations:

| Mutation | Discriminating result |
| --- | --- |
| bypass family-origin enforcement | duplicated-family and missing-member tests fail |
| write every unit through global `getClass` | structural and public end-to-end sink tests fail |
| keep resolver state across reload | changed positive/negative reload test fails |
| keep an established family winner after adding a third origin | strengthened late-registration test fails |

The initial late-registration test used only one origin before the addition and
survived its mutant. It was corrected to establish a duplicate family winner first;
the revised test kills stale family state.

## 2026-07-24 - Clean patch four-state

Both patches passed `git apply --check --whitespace=error-all` independently at the
exact detached base. After applying only the test patch:

- baseline task: exit 0;
- feature task: exit 1 with 17 of 21 scenarios failing behaviorally.

After applying the solution patch:

- baseline task: exit 0;
- feature task: exit 0 with all 21 scenarios passing.

The original repository clone was verified clean at the pinned SHA after an initially
misdirected test-patch application was immediately reversed. All four-state execution
then occurred only in `/tmp/vf-four-state.geCBTl`.

Strict test-guide review then caught that the first base mode used a task-authored
compatibility class rather than an existing repository test. The test patch was
regenerated to run upstream `LazyLibraryTest`, and the complete four-state was repeated
successfully in `/tmp/vf-four-state-final.RUvHGj` with the same 17-of-21 clean-base
feature failure.

## 2026-07-24 - Remaining gates

Do not create local stand-ins for platform artifacts. Still required:

- platform repo-fit/similarity and author decisions;
- a normal agent panel with at least one legitimate pass and no more than 40% pass
  rate;
- false-positive, AI-evaluation, auto-review, fairness, and human-review results.

If the first panel is 0%, inspect whether agents converge on the family-activation or
output-ownership seam before changing the contract. If a false-positive judge objects
to broad family atomicity, compare against the final bounded clause and the explicit
nonduplicate split control; do not restore the rejected unconditional rule.

## 2026-07-24 - Remote Docker and full regression

The first remote Docker run exposed missing offline `testFixtures` artifacts. Gradle's
`dependencies` report resolved metadata but did not materialize the JARs. The final
test patch adds a build-only copy task over the normal and test-fixture runtime
configurations; the Dockerfile runs it and removes the temporary copies in the same
layer, leaving the Gradle artifact cache without executing tests.

The exact final artifact set passed the standard remote verifier on the
`Zeyad-Nasef` forge:

- base plus test patch, upstream `LazyLibraryTest`: pass;
- feature suite on clean base: fail as intended;
- upstream `LazyLibraryTest` with solution: pass;
- feature suite with solution: 21/21 pass;
- every container ran with `--network none`.

Returned XML is preserved under `.verify/out/`.

The first broad `./gradlew build` used the Codespace's default Java 25.0.2 and failed
in Kotlin 2.0's Java-version parser (`IllegalArgumentException: 25.0.2`). Vineflower's
official CI matrix is Java 17 and 21. Re-running the unchanged checkout with the
already provisioned Temurin 17 runtime passed:

- `BUILD SUCCESSFUL in 2m 23s`;
- 49 actionable tasks;
- main tests, plugin tests, Javadocs, archives, Jacoco, and all Java/Kotlin/Groovy/
  Scala/Jasm test-data compilation completed.

Both logs are preserved as `.verify/full-build.log` and
`.verify/full-build-java17.log`. Remote images and the exact task namespace were
removed after copying evidence. The forge was not stopped because another agent still
had an SSH session.

## 2026-07-24 - Final grader-contract correction

The final interface audit found that the predecessor harness treated
`--output_path` as a directory. It now roots itself at the repository and writes one
JUnit XML document to the exact requested file. An absolute-path invocation from
outside the repository passes.

The same audit applied the live per-test fail-to-pass rule, not merely the aggregate
four-state exit code. Four positive controls were already green on the base:

- metadata-defined local-class anchoring;
- a metadata-linked split with no exact duplicate;
- a repeated entry from one origin; and
- own-source precedence over libraries.

Those controls remain asserted, but each is now grouped with its related missing
duplicate-resolution behavior. The suite has 17 JUnit scenarios: all 17 fail
behaviorally on the pinned base and all 17 pass with the solution. A fresh detached
local four-state also passes the upstream `LazyLibraryTest` before and after the
solution.

The normal remote verifier built and ran the first image, then exhausted the shared
forge's remaining disk while creating its second image. No task verdict was inferred
from that infrastructure failure. With no active containers, the documented low-disk
flow rebuilt the exact same patches sequentially, removed only this task's image and
inactive builder cache between states, and ran every container with `--network none`:

- base plus test patch: exit 0;
- new plus test patch: exit 1, 17/17 failures;
- base plus solution patch: exit 0; and
- new plus solution patch: exit 0, 17/17 passes.

The four exact returned XML files are under `.verify/out/`. The predecessor XML is
preserved under `.verify/out-pre-f2p-contract/` so the evidence history is not
silently rewritten.

The closing craftsmanship sweep removed the unused `familyRoot` component from the
private resolution record. Family provenance remains local to selection and
diagnostics; no behavior or public surface changed.

That cleanup produced final solution-patch hash
`20501fc39e7ba3e0ed1ea510748bcc70db05756772c6b74a22242c9e4fdb1af0`.
The two solution-bearing Docker states were rerun on that exact hash with
`--network none`; the upstream baseline and all 17 feature scenarios passed. The
unchanged test-patch states retain their exact-hash remote evidence, including 17/17
base failures. Finally, the exact current test and solution patches passed
`./gradlew build --stacktrace` on Temurin 17 in 2m10s with all 49 tasks executed. The
refreshed log replaces the predecessor success log at
`.verify/full-build-java17.log`.

## 2026-07-25 - Platform build-order and precheck correction

The first platform build failed before a task container could run. Reproducing the
platform sequence identified the cause: Olympus builds the Docker image from the
untouched pinned repository and injects the test patch only afterward, but the
Dockerfile invoked `cacheOlympusDuplicateClassDependencies`, a task defined by that
not-yet-injected test patch. The clean-base build therefore failed with:

```text
Task 'cacheOlympusDuplicateClassDependencies' not found
```

The former remote verifier had applied the test patch before building the image, so
it could not detect this ordering defect. The corrected Dockerfile defines a
build-only init-script task itself. That task resolves the existing
`testRuntimeClasspath` and `testFixturesRuntimeClasspath` configurations without
running tests or changing the repository. An empty-cache A/B check established why
both are required: compiling main and test-fixture classes alone left the JUnit
launcher, JUnit engine, and Kotlin runtime unavailable offline; resolving both runtime
configurations made the same patched baseline execution pass with networking disabled.

A second platform-faithful check found that setting `GRADLE_USER_HOME=/opt/.gradle`
inside the Dockerfile did not survive the login environment used by agents. The base
image's `/etc/profile.d/gradle.sh` restores `/opt/gradle-cache`, so dependencies warmed
under `/opt/.gradle` were invisible to login-shell execution. The Dockerfile now uses
and grants read/execute access to the base image's canonical `/opt/gradle-cache`.
Direct and login shells both report that path and can invoke the Gradle wrapper with
`--offline` and `--network none`.

The platform-generated precheck report is preserved verbatim because it is historical
platform evidence. Its blocking predictable-path result has been corrected with the
random suffix generated by `openssl rand -hex 3`: the test is now
`DuplicateClassResolution_49e03e_Test.java`, with the class, Gradle include, and patch
all updated consistently. The report's five conciseness suggestions were also
adjudicated in the description:

- the nonduplicate metadata case is stated as an observable positive control rather
  than a generic “retain existing behavior” instruction;
- reload describes discarded duplicate-resolution and lazy-probe results without
  listing implementation cache buckets;
- context isolation and concurrency are one externally meaningful requirement;
- the redundant name-selection lead-in is absent; and
- output ownership no longer mentions preprocessing.

These edits do not remove contract behavior. In particular, the no-exact-duplicate
case must remain because it prevents an overbroad family-coherence implementation and
is one of the clean-base positive controls grouped with a failing feature scenario.

The Docker pinning warning is nonblocking and generic. The repository's wrapper fixes
Gradle at 9.2.1, and its declared plugin and dependency versions are fixed (the JUnit
launcher inherits the fixed JUnit BOM version). Adding a new dependency-locking
regime would be an unrelated repository policy change; rerun the platform check
against the corrected Dockerfile instead.

## 2026-07-25 - Exact final remote verification

The final image was built from the untouched pinned base before either patch was
injected. Four containers then applied the relevant patches and ran with
`--network none`:

- baseline with test patch: exit 0, upstream `LazyLibraryTest` 1/1 pass;
- feature suite on base: exit 1, all 17 scenarios fail;
- baseline with solution: exit 0, upstream `LazyLibraryTest` 1/1 pass; and
- feature suite with solution: exit 0, all 17 scenarios pass.

The exact result was:

```text
PLATFORM_ORDER_FOUR_STATE base-test=0 new-base=1 base-solution=0 new-solution=0
RESULT: PLATFORM-ORDER FOUR-STATE HELD
```

The Docker build log and four returned XML files are preserved under `.verify/`.
The exact current patches also passed the strict clean-base patch application check,
`git diff --check`, and a fresh `./gradlew --no-daemon build --stacktrace` on Temurin
17.0.19:

```text
BUILD SUCCESSFUL in 2m 19s
49 actionable tasks: 49 executed
FINAL_JAVA17_BUILD_STATUS=0
```

Final artifact hashes:

```text
test patch     5593a5005d4aa9ee0d5e5e566893c4c34cbf1c974d443d7186a15f540ac13305
solution patch 20501fc39e7ba3e0ed1ea510748bcc70db05756772c6b74a22242c9e4fdb1af0
```

Only the exact task-specific remote image and verification namespaces were removed
after the evidence was copied. No forge-wide prune or shared-service interruption was
performed.

## 2026-07-26 - Env-quality root cause, fairness repair, and verifier-audit adjudication

Artifacts after this round:

```text
description    944da0c2cfb201a362f6aeea36581de40ed391cc39255f56976aceaf065975fe (unchanged)
test patch     16a78858d940186d288713e6336892259df3fc5e34dcc2f3d8a442ab3eacd5bf (changed)
solution patch 20501fc39e7ba3e0ed1ea510748bcc70db05756772c6b74a22242c9e4fdb1af0 (unchanged)
Dockerfile     4a5c366d87346414d8979d185123a6e7e1bdaa8f2873005cb4831c11da40a82d (changed)
```

### Env Quality: reproduced, root-caused, and partly repaired

The failing check was reproduced exactly, not inferred. The trajectory's first error is
`/opt/gradle-cache/wrapper/dists/gradle-9.2.1-bin/<hash>/gradle-9.2.1-bin.zip.lck
(Permission denied)`. Two facts explain it:

- the env-quality sandbox runs the repository as a NON-ROOT user, while the four-state grader
  runs as root, so this class of defect is invisible to the four-state; and
- the base image ships `/opt/gradle-cache` as `drwxrwxrwt`, but the wrapper distribution our
  build downloads is created by root with mode 755, and the previous
  `chmod -R a+rX` added read and directory-execute only, never write.

Two further root-owned obstacles were found by iterating in a container built on the real base
image with a faithful root-owned `/app`:

- Gradle chmods its own daemon registry (`Could not set file mode 700 on
  /opt/gradle-cache/daemon/9.2.1`), which only the owning user may do, so a root-warmed daemon
  directory can never be reused by another user; and
- the root-created project state `/app/.gradle` blocked `fileHashes.lock`.

The Dockerfile now removes the root-created transient state and grants write access:
`rm -rf /opt/gradle-cache/daemon /opt/gradle-cache/.tmp /app/.gradle && chmod -R a+rwX
/opt/gradle-cache /app`. Verified: under the old `a+rX` a non-root user reproduces the exact
reported `.lck` failure; under the new rule the same user runs the Gradle wrapper successfully,
and in the final baked image a non-root `./gradlew --version` reports Gradle 9.2.1.

This also removes a latent solvability risk: had solver agents run non-root, every run would
have died at the wrapper before touching the feature.

### Env Quality: the residual limitation is upstream-native, measured not assumed

After the permission chain is cleared, `./gradlew test` still fails offline with
`Cannot find a Java installation ... matching {languageVersion=11} ... No cached resource ...
available for offline mode`. This is a property of the repository, not of the task:
`build.gradle:132` creates test-data source sets for Java 8, 9, 11, 16, 17, 21, and 25, each
pinned with `javaToolchains.compilerFor`, `testClasses` depends on `testDataClasses`, and the
`test` task feeds `TestDataRuntimesProvider` launchers for all seven versions while being
`upToDateWhen { false }`. The base image ships only JDK 17, and settings.gradle resolves those
toolchains through the network-dependent foojay plugin.

Provisioning one toolchain was measured on the forge: JDK 11 alone costs 499 MB in
`/opt/gradle-cache/jdks`, so the six missing versions are roughly 3 GB of extra image. That
change is not made here: it is unverifiable on the only available forge, it risks the platform
build on end-of-life JDK availability, and the current four-state is green. The task's own
harness deliberately avoids the problem by compiling its fixtures with `options.release`
instead of a toolchain, which is why base and new modes run offline.

### Test Fairness FAIL repaired (5 unfair tests, one class)

The precheck summary line reads "Coverage Suggestions (3) - Not Blockers", but the raw report is
`"verdict": "FAIL"` with `"unfairTestCount": 5`. All five are one class: failure presentation
pinned beyond the prompt and beyond anything discoverable in the repository, which has no
pre-existing duplicate-resolution error or warning template. Repairs, all behavior-preserving:

- exception subtypes are no longer pinned; the tests require a failure
  (`RuntimeException`) instead of `IllegalStateException`/`IllegalArgumentException`;
- message fragment ORDER is no longer asserted except where the prompt states it, namely the
  stable order of two ignored origins in a warning;
- literal label wording is gone (`family <name>`, the literal word `error`, the rejected value
  `middle`, and the exact suffix `; family family/Outer`);
- the family-root assertions now strip the member name before checking the root, so they still
  discriminate root from member without pinning any format; and
- the top-level `$` case no longer asserts a family-root label, because with no family the
  reported root is unspecified.

The invalid-option test now asserts only what the prompt states: the accepted values
`first`, `last`, and `error` appear.

### Verifier audit adjudicated, not accepted wholesale

Nine of the ten demonstrated gaps are real: each names an explicitly stated clause, the
reference is correct, and no test covered it. Their remedies were adopted.

Gap 1 (non-String option value must be rejected rather than throwing ClassCastException) is
BYPASSED with grounds. The repository's own idiom casts option values directly:
`Fernflower.java:58` does `(String) properties.get(LOG_LEVEL)` and
`DecompilerContext.java:127` does `Integer.parseInt((String) getProperty(key))`, so a non-String
value fails the same way for existing options. The reference only satisfies the probe because it
happens to use `String.valueOf`. Requiring the new option to be more defensive than every option
in the repository is an undiscoverable assertion, and the audit's own R17 derives that duty from
the same sentence as R2 rather than from the prompt.

One audit defect was found: its proposed patch reports `new (no solution): FAILED (27 tests,
1 passed, 26 failed)`, and that base-passing test shipped in the proposal.
`anonymousClassUsesEnclosingMethodFamilyMetadata` anchored the family in the FIRST origin under
`last`, which coincides with base first-wins behaviour, so it passed without the feature. It was
restructured to register the duplicate anonymous class first and the root-bearing origin second
under `first`, so the metadata anchor must override both the strategy and base behaviour. It now
fails on base and still discriminates the anonymous EnclosingMethod family logic.

### Harness contract fix

`test.sh` resolved a relative `--output_path` after `cd "$(dirname "$0")"`, so a relative path
landed in the repository root instead of the caller's directory. It now captures `INVOKE_DIR`
first and rebases relative paths. Verified in-container from `/tmp/callerdir`: the XML is written
to the caller's directory and nothing is left in the repository root.

### Platform-order four-state on the exact refined bytes

The image was built from the untouched pinned base and the patches applied afterwards, matching
platform build order. Suite is 26 focused tests.

```text
S1 base + test patch   -> baseline   1/1 pass          exit 0
S2 base + test patch   -> new       26 tests, 26 fail  exit non-zero
S3 + solution patch    -> baseline   1/1 pass          exit 0
S4 + solution patch    -> new       26/26 pass         exit 0
```

Every focused test fails on base, satisfying the per-test fail-to-pass rule. XMLs are preserved
under `.verify/out/`.

### Forge discipline

The `Zeyad2003` forges are unusable (HTTP 402 until the quota resets), so work ran on the
`Zeyad-Nasef` forge, which also holds another task's `contrast-safe-style-v4-r4b` evidence. No
container, image, or directory belonging to that task was touched, and the shared
`olympus-base-jvm` image was preserved. Only inactive build cache and this task's own image,
containers, and directories were removed; disk was returned to 1.9 GB free. During the run the
root overlay hit 100%, which produced `No space left on device` errors that read like permission
failures; the writable paths were redirected to `/tmp` (a separate 118 GB volume) rather than
attributing an infrastructure limit to the task.

### Open items for the owner

- Env Quality will still report FAIL while `./gradlew test` needs six absent JDK toolchains.
  Shipping them costs roughly 3 GB of image; the alternative is to record the limitation as
  upstream-native. This is a scope decision, not a defect.
- Every platform check is stale after this round: the test patch and Dockerfile changed.
  Prechecks, fairness, verifier audit, and repo fit must be rerun before agents.

## 2026-07-26 (second pass) - Env Quality solved, verifier audit closed, suite at 31 tests

Platform re-ran every check on the previous round's bytes. Results confirmed that round's
diagnosis and repairs:

- Test Fairness: **PASS**, `unfairTestCount: 0` ("All hidden tests are fair"), down from FAIL with
  five unfair tests. The over-pinned failure-presentation class is closed.
- Env Quality: still FAIL, but the reported cause moved exactly where the previous round predicted:
  "requires multiple Java toolchains (including Java 11 via Foojay auto-provisioning) but only JDK
  17 is installed". The permission chain is fixed; the toolchain wall is what remained.
- Verifier audit: INCOMPLETE with five new gaps on the 26-test suite.

### Env Quality is now solved, and it was our infrastructure

The previous round concluded the toolchain requirement was probably not worth paying. That was
re-examined rather than restated, and it turned out to be wrong: the wall is surmountable and the
fix is ours to make.

Measured on the forge with a Gradle home on the large `/tmp` volume so disk was not the limit:

- foojay resolves every version the build needs: temurin 8, oracle 9, adoptium 11, OpenJDK 16,
  system 17, adoptium 21, and adoptium 25;
- the JDKs cost 2.8 GB with their archives, and 1.75 GB once `*.tar.gz` is deleted after
  extraction, so the warmed home is 2.6 GB in total;
- two dependency sets are missing from a `testClasses`-only warm and must be resolved explicitly:
  the JaCoCo agent (`jacocoAgent`/`jacocoAnt`, pulled in because `test` is instrumented) and the
  test runtime classpaths of **all** projects, since `./gradlew test` also runs the three plugin
  subprojects.

With that warm plus the permission repair, the decisive check passes:

```text
docker run --network none --user 1000:1000 ... ./gradlew --no-daemon --offline test
BUILD SUCCESSFUL in 54s
41 actionable tasks: 4 executed, 37 up-to-date
```

That is the exact shape the env-quality agent runs: offline, non-root, `./gradlew test`, on the
pinned base with no patches. The Dockerfile now performs the same warm, deletes the JDK archives
in the same layer, and then removes root-created transient state and grants write access.

Side effect worth recording: this also removes a real solvability risk. The env-quality sandbox is
described as the environment solver agents get, and it runs non-root. Before this repair a
non-root agent could not start the Gradle wrapper at all, and even after that it could not run the
repository's own test suite. Agents can now build and run the full suite offline and iterate
against it.

### Verifier audit adjudicated (5 gaps)

Four are real and were adopted unchanged: they are grounded in stated clauses, the reference is
correct, and each fails on the clean base.

- `addingSourceInvalidatesPositiveErrorDecision` - "Adding another context source invalidates
  affected class and family decisions".
- `mixedConflictReportsAllHighestTierOrigins` - "An `error` conflict identifies every conflicting
  highest-tier origin"; a mixed set still names all three.
- `mixedWarningListsAllIgnoredOriginsInStableOrder` - "ignored origins in stable order", with both
  the byte-identical loser and the differing loser listed.
- `exactByteDifferencesTriggerError` - "`error` rejects candidates only when their exact classfile
  bytes differ"; a minor-version byte counts.

The fifth, `identicalDuplicatesDoNotWarnForFirstOrLast`, tests a real rule (the warning clause is
scoped to *differing* candidates) but the proposed test **passes on the clean base**: with no
duplicate resolution there are no warnings, so asserting "no warning" is trivially satisfied. The
audit shipped it anyway and its own validation log admits it: `new (no solution): FAILED (31
tests, 1 passed, 30 failed)`. This is the second consecutive audit to ship a base-passing remedy,
so its proposals continue to need this check rather than trust.

It was repaired rather than dropped: the fixture now pairs the byte-identical duplicate with a
*differing* sibling class in the same two origins and asserts exactly one warning, naming the
differing class. The identical pair is still proven silent, and on the clean base the assertion
fails because no warning is emitted at all.

### Description

Two bots independently flagged "fail deterministically"; the adverb pins no separate testable
behavior, so it was removed (322 body words, ASCII). The other suggestions were refused with
grounds: "Keep resolution state per decompiler context" is load-bearing for
`separateDecompilerContextsKeepIndependentStrategies` and the audit's own
`delayedLookupUsesItsOwningDecompilerContextStrategy`, and deleting it would orphan enforced tests;
the concurrency clause is behavioral and is pinned by
`threadCountDoesNotChangeSelectionOrSinkOwnership`, while the suggested rewording would name
`saveContext()` and make the prose more prescriptive, not less.

The quality check's one remaining note is that some assertions count lazy probe reads. That is
kept: caching is an explicit requirement ("Cache positive and negative lazy probes"), the counter
lives on the test's own `MemorySource` double rather than on production API, and a probe count is
the only black-box observable of caching.

### Four-state on the 31-test suite

```text
S1 base + test patch   -> baseline   1/1 pass           exit 0
S2 base + test patch   -> new       31 tests, 31 fail   exit 1
S3 + solution patch    -> baseline   1/1 pass           exit 0
S4 + solution patch    -> new       31/31 pass          exit 0
```

Zero tests pass on base, so the per-test fail-to-pass rule holds for every added cell. XMLs are in
`.verify/out/`.

Final hashes:

```text
description    59d34e029c6f00c2...
test patch     190700a7e3a346d1...
solution patch 20501fc39e7ba3e0... (unchanged since 2026-07-24)
Dockerfile     053eacd2d08fa6fb...
```

### Verification boundary, stated honestly

The four-state above ran against the base image with the fully warmed Gradle home mounted, which
is the same dependency and toolchain set the new Dockerfile bakes, and the offline non-root
`./gradlew test` ran the same way. The new image itself was **not** rebuilt end to end: the only
usable forge has 1.9 GB free and the warmed image needs roughly 2 GB more, while the second
account's Codespaces are blocked by billing until the quota resets. Every command the Dockerfile
runs was executed successfully in that environment, but a full `docker build` of the final image
is still outstanding and should be run once disk or quota allows.

### Forge

Work stayed on the `Zeyad-Nasef` forge alongside another task's `contrast-safe-style-v4-r4b`
evidence, which was not touched, and the shared `olympus-base-jvm` image was preserved. Heavy
state was kept on the separate 118 GB `/tmp` volume instead of the full root overlay.

## 2026-07-26 (third pass) - stable-order ambiguity confirmed and closed

The alignment warning ("'Stable order' for ignored origins is vague; tests enforce registration
order") was checked rather than accepted, and it is **true and material**.

- `mixedWarningListsAllIgnoredOriginsInStableOrder` requires the ignored origins
  `mixed-warning-identical` then `mixed-warning-different`, which is registration order.
  Sorted order is the reverse (`different` < `identical`), so an implementation that lists ignored
  origins in a sorted-but-deterministic order satisfies the prompt's "stable order" as written and
  still fails the test.
- The older `warningIsSemanticOrderedAndEmittedOncePerDecision` uses `origin-a` then `origin-b`,
  where registration and sorted order coincide, so it could never expose the ambiguity. The gap
  only became load-bearing when the verifier-audit test was adopted.

Fix: the description now says "ignored origins in **registration** order", reusing the ordering
vocabulary paragraph 1 already establishes ("root registration order and child-context list
order"). Child-context ordering was deliberately not added to this sentence: no test exercises
ignored origins spanning child contexts, and promising it would create an unenforced clause.

### Same-class sweep across the whole suite

Every order-sensitive and format-sensitive assertion was enumerated and checked against a clause:

- ordered message assertions: exactly two, both about ignored origins, both grounded once the
  clause above is explicit;
- exact-string/affix assertions: none remain (the `endsWith("; family family/Outer")` and literal
  `family <name>` pins were removed in the first pass);
- order-sensitive list equality: twelve `assertEquals(List.of(...), sink...)` sites. Eleven are
  single-element, where order is meaningless. One was not:
  `assertEquals(List.of(DUPLICATE, "sample/FirstOnly"), first.sink.classNames)` pinned the order in
  which a sink receives classes, which no clause states. It now asserts size 2 plus a `Set`
  comparison, keeping the stated "return every selected own class once" property while dropping the
  unstated emission order. The file already used that `Set.copyOf` form elsewhere, so this matches
  local convention.

### Re-verification (test patch changed, so the four-state was re-run, not assumed)

```text
S1 base + test patch   -> baseline   1/1 pass           exit 0
S2 base + test patch   -> new       31 tests, 31 fail   exit 1   (zero passed on base)
S3 + solution patch    -> baseline   1/1 pass           exit 0
S4 + solution patch    -> new       31/31 pass          exit 0
```

Final hashes:

```text
description    20366916f7f7087e...
test patch     2215a8f677d1db20...
solution patch 20501fc39e7ba3e0... (unchanged since 2026-07-24)
Dockerfile     053eacd2d08fa6fb...
```

Forge left with zero containers, only the shared base image, 1.9 GB free, and the other task's
`contrast-safe-style-v4-r4b` evidence untouched.

## 2026-07-27 - Round 2: origin identity defined and enforced, library warnings closed

Entering this round the task passed every precheck, held the four-state, and landed at 30% (3/10).
Two gates failed, and they turned out to be one defect seen from two sides.

### The false positive was a description defect, not only a test gap

Nova #3 was confirmed a false positive for keying origin identity on `IContextSource.getName()`.
Nova #6 has the *identical* flaw and was overruled as unfair, on the grounds that "the prompt itself
identifies origins by name and never contemplates same-named sources."

Two adjudicators, one prompt, opposite verdicts. That is the tell: the description used the word
"origin" throughout and never defined it. The ambiguity - not either candidate - was the defect.

Repository evidence that identity, not name, is the native semantics:

- `IContextSource.getName()` is documented only as "Get a human-readable name to identify this
  context source". No uniqueness contract.
- `ContextUnit` overrides neither `equals` nor `hashCode`, so it has identity semantics.
- `StructContext.addSpace` (`StructContext.java:241-243`) mints a fresh `ContextUnit` per call and
  appends it to an ordered `List<ContextUnit>`. Two same-named sources are unambiguously two units.
- The reference already keyed on the object: `Map<String, Set<ContextUnit>> eagerCandidates`, and
  `candidateFrom` compares with `candidate.unit() == unit`. Names are used only for diagnostic text.

So the reference was right and the prompt was silent. Tighten, do not de-scope: de-scoping would
have meant rewriting the reference to match the flawed candidate, which is the anti-pattern of
weakening a discriminator to revive its own false positive.

### Description

One sentence added to paragraph 1, immediately after the option declaration:

```text
Each registered context source is a distinct origin: two sources may share a human-readable name
and are still separate origins.
```

A definition, not a new requirement. Reference behavior unchanged; no existing test outcome moved.
342 words, still 4 paragraphs.

### Tests: 31 -> 40

1. `sameNamedSourcesRemainDistinctOrigins` - the FP close. Two separately registered sources that
   deliberately return the same `getName()` hold byte-differing classfiles for one binary name.
   Under `last` the later source must win and own the output sink; under `error` the conflict must
   be reported. Deliberately asserts no warning text here: with both origins sharing a display name
   the warning cannot distinguish them, so pinning it would be unfair.
2. `eagerLibraryDuplicatesUseEveryStrategy` - adopted from the verifier audit but **not** as
   proposed. The audit shipped `assertEquals(1, harness.logger.warnings().size())` and nothing else;
   a bare count is not coverage. Upgraded to the full semantic-field set, and the origins were
   renamed `library-alpha` / `library-beta` so that `contains("first")` / `contains("last")` tests
   the strategy field instead of vacuously matching the origin name.
3. `lazyLibraryDuplicatesWarnWithSemanticFields` - the lazy half of the same gap, plus a second
   lookup asserting the warning is not re-emitted from cache.
4-9. Six further verifier-audit gaps adopted as written: root/child order composition, unavailable
   root anchoring under `last`, family conflict listing every alternative origin, `error` combining
   eager and lazy library candidates, byte-identical own duplicates still activating family
   coherence, and repeated same-origin entries *not* activating it.

Tests 2 and 3 also close the auto-review High (tests band 1) and the fairness "Library warning
parity" suggestion, which were the same uncovered cell reported by two independent reviewers. The
reference already warns on any differing `first`/`last` decision regardless of tier
(`warnSelection` is called whenever `distinct`), so this was a matrix-close: reference green, suite
silent.

### Grounded advisories declined

- "Delete `before processing`" (description conciseness, low). Declined: it is load-bearing.
  `optionIsDocumentedDefaultedAndValidatedBeforeInputs` rejects the invalid option at
  `new Fernflower(...)` construction, before any input is registered. Removing the phrase would
  leave constructor-time validation unstated and manufacture a fresh false positive.
- "Remove `to eager inputs and`" (description conciseness, medium). Declined: deleting it narrows
  paragraph 3 to libraries only, contradicting the own-source selection cells. With the pass rate
  about to fall, description clarity is not the thing to trade away.
- "Assert `DecompilerOption.getAll()` exposes the option" (fairness, advisory). Declined: the stated
  contract is the option's effect and its default, and the default is already pinned through
  `IFernflowerPreferences.DEFAULTS`. `getAll()` is the console help registry - repo plumbing the
  description never mentions, which a solver could skip while honoring the full semantics.

### Verification (forge, platform build order, --network none)

```text
S1  base suite  on base                     PASS
S2  new  suite  on base        40/40 FAIL   (every one of the 9 new cells is genuinely new)
S3  base suite  + reference                 PASS   (no regression)
S4  new  suite  + reference    40/40 PASS
```

Replay of saved agent patches against the 40-test suite:

```text
agent-5   40/40 PASS                      <- legitimate passer retained
agent-3    1 fail: sameNamedSourcesRemainDistinctOrigins
agent-6    1 fail: sameNamedSourcesRemainDistinctOrigins
agent-2    2 fail: addingLazySourceInvalidatesCachedNegativeProbe + the origin cell
```

The discriminator is surgical. Agents 3 and 6 fail on exactly one cell - the one targeting the
confirmed flaw - and the other eight new cells cost them nothing. Agent 5 survives all nine because
`getOriginKey()` falls through to object identity for non-file-backed sources.

### Difficulty: what the replay does and does not say

Replay projects **1/10 (10%)** - inside the band (>=1 passer, <=40%) but thinner than round 1.
Treat that as a **lower bound**, not a forecast: it measures agents that never saw the new
description. Agents 3 and 6 failed the origin cell only because the rule was unstated; it is now
stated in the first paragraph, so a fresh batch has a fair path to it that this population never had.

The 30% rate was **not** raised on purpose. `addingLazySourceInvalidatesCachedNegativeProbe` is the
only failure for three otherwise-complete runs (2, 7, 8) and the most-failed cell in the batch.
Clarifying it would likely convert all three and push the rate to roughly 60%, breaching the 40%
ceiling. Auto-review calls it subtle_but_fair and Test Fairness passes it, so it was left untouched.
It is what makes this task hard rather than merely long.

### Forge

The Codespace's Docker was on a 32 GB device with 1.9 GB free - not enough for this image. Docker's
data-root was moved to the 118 GB `/tmp` volume with the shared base image **copied**, not moved, so
`/var/lib/docker` is untouched and a Codespace restart reverts to the original setup with the base
image intact. No containers were running at switch time and the only image present was the shared
base, so no other session lost anything. The other task's `contrast-safe-style-v4-r4b` evidence was
left alone.

Final hashes:

```text
description    c325c43ff77bbc3c...
test patch     57f7b8dd68665b7c...
solution patch 20501fc39e7ba3e0... (still unchanged since 2026-07-24)
Dockerfile     053eacd2d08fa6fb... (unchanged)
```

### Addendum (2026-07-27) - unavailable-root warning field closed

A later advisory pair was adjudicated. "Own-over-library cache invalidation" was **declined as
redundant**: invalidation is already proven own-to-own
(`addingASourceInvalidatesCachedClassAndFamilySelections`) and library-to-library
(`addingLazySourceInvalidatesCachedPositiveSelection`), and tier precedence at resolution is proven
by `librariesRespectSourcePrecedenceRegistrationOrderAndCaching`; re-resolution after invalidation is
the same code path that applies precedence, so the composition is forced by the covered halves.

"Unavailable-root warning path" was **adopted - it was a real gap**. A sweep of all 13
warning-asserting tests found exactly one assertion in the whole suite that isolates the family-root
field, the `.replace(...).contains(...)` line in
`familyWarningIdentifiesMetadataRootAndAnchoredSelection`, and there the root *is* available. Every
other warning assertion uses a top-level binary name where `familyRoot == className`, so
`contains(name)` is satisfied by the binary-name field alone and the family field is invisible. Both
tests that exercise the unavailable-root path never looked at warnings at all.

Why it mattered: paragraph 4 requires the *metadata* family root. An implementation deriving that
field from the **anchor** instead of from `InnerClasses` metadata agrees with the available-root case
and diverges only when the root is unavailable - metadata says `family/Siblings`, anchor-derived says
`family/Siblings$One`. Reference green, description explicit, suite silent: the same shape as B2.

Closed by adding three assertions to `unavailableRootLastAnchorsStrategySelectedDuplicate` - no new
fixture, no new source. The warning is selected by filtering for the member name rather than by index
or count, so the cell does not depend on how many warnings an implementation emits. The family-root
assertion strips `$One`/`$Two` before checking for `family/Siblings`, so it pins the field without
pinning any message format. Strategy is deliberately not asserted here: `last-members-origin`
contains the substring `last`, which would make it vacuous.

Verified statically, not on the forge (owner asked to skip a rerun):

- reference: `$One` has two own candidates with differing bytes, so `distinct` holds; strategy `LAST`
  selects `last-members-origin`; `findFamilyRoot` returns `family/Siblings` from metadata; the root
  resolves empty so `anchor = selected.unit()`, which is among the candidates, so no family conflict
  is raised and `warnSelection(className, familyRoot="family/Siblings", ...)` is reached.
- agent-5 (the solvability anchor) still passes: its family loop computes
  `String root = findRoot(members, parents, duplicate)` and, when the root is unavailable, swaps only
  `anchorName` to the activator while still passing `root` to
  `warnIfDiffering(anchorName, anchorCandidates, anchorCandidate, root)` - so it reports
  `metadata family root=family/Siblings`, satisfying the assertion.
- fail-on-base is unaffected: the cell already fails on base and added assertions cannot change that.

Suite stays at 40 tests. Description and solution patch unchanged - paragraph 4 already said
"metadata family root", so this was enforcement catching up to a stated contract, not a new
requirement.

## 2026-07-27 (round 3, on tag v2) - reload family coverage closed, audit adjudicated

Round 2 landed: FP review **PASSED_WITH_WARNINGS** (0 false positives, 2 genuine), Test Fairness
PASS, repo-fit PASS, 2/10 working pool = 20%, medians 6 files / 241 messages / 724 LOC. One blocker
remained: auto-review tests band 1, issue T4.

### The blocker

`reloadRefreshesPositiveAndNegativeDecisions` covers an eager selection and a lazy negative probe.
Family invalidation was covered only for source addition, never across `reloadContext()`. An
implementation that clears class and probe caches on reload but keeps a stale family anchor passed
all 40 tests while violating paragraph 3. Test Fairness raised the same gap independently
("reloadContext family-cache rebuild"), and the verifier audit found a neighbouring reload hole.
Three reviewers on the reload path.

### Six cells added (40 -> 46)

1. `reloadRebuildsFamilyAnchoring` - the T4 close. `family-origin-a` holds only the member,
   `family-origin-b` holds root and member, strategy `first`: the family anchors to b and the member
   loads from b. Then a `put` gives origin a the root, `reloadContext()` runs, `first` now selects a,
   and both root and member must come from a. A stale anchor returns b's member. Uses only the
   existing `put` helper - no fixture change. Keeps the root **available** on both sides of the
   reload, so it never touches the multi-duplicate/unavailable-root corner that two FP judges called
   underspecified (they noted the reference is order-dependent there).
2. `libraryDuplicatesDoNotActivateOriginCoherence` - audit gap 1, adopted as proposed. Coherence is
   own-only ("among own sources"); a unified resolver throws a spurious family conflict for
   libraries.
3. `invalidatedSelectionEmitsANewWarningForTheNewDecision` - audit gap 4, adopted as proposed. The
   reference has no permanent warn-dedup set: `registerUnit` clears `resolutions` and `familyOrigins`,
   so a re-resolve genuinely re-warns.
4. `reloadDiscardsPositiveLazyProbeResults` - audit gap 2, **redesigned**. The audit's own validation
   shows its version passing on the pristine base (`new (no solution): 44 tests, 1 passed, 43
   failed`), because base `getClass` already caches via `computeIfAbsent` and base `reloadContext()`
   already clears it - the cell measured base behaviour, not the feature. Redesigned with **two**
   lazy libraries under `last` so the cached value is a real duplicate-resolution decision; base
   returns the first `lazyUnits` match, so it now fails on base.
5. `invalidOptionNearMissesAreRejected` - audit gap 3, **reduced** to `"first "`, `"firstly"`,
   `"error!"`. Dropped `""`: an empty value plausibly reads as "unset, use the default", and this
   repository already uses the empty string as a meaningful option value (the suite's own harness
   sets `INCLUDE_JAVA_RUNTIME` to `""`). Requiring it to throw pins a corner the description does not
   settle.
6. `errorDiagnosticsIgnoreLowerTierLibraryOrigins` - fairness advisory 1.
   `mixedConflictReportsAllHighestTierOrigins` registers only own sources, so nothing proved that
   lower-tier library origins are excluded from diagnostics.

### Description

One sentence into paragraph 3: "Registering a source records its candidates without resolving them;
duplicate warnings and conflicts surface when a selection is requested." 361 words, still 4
paragraphs.

This targets the recurring FAIL_TEST_MISMATCH. Auto-review already rebuts that verdict - agents band
3, "a careful combined reading avoids it ... a shared lifecycle blind spot rather than an unfair test
or evidence that the task is broken" - so it was never a blocker. But it is the second consecutive
batch where runs converged on registration-time resolution (4 of 11 here, 4 of 10 before) and each
occurrence scratches a run. The boundary was derivable from three separate clauses; now it is stated.

### Solvability

`addingLazySourceInvalidatesCachedNegativeProbe` was left untouched: it appears in 8 of 9 failures
and is the *only* failure for runs 6, 10 and 11 at 39/40. Clarifying it converts three near-solvers
at once and lands near 45%, past the ceiling. Projection after this round is roughly 27% - only
agent 3 fails exclusively on registration timing, so the description sentence flips one run while
runs 2, 5 and 8 still fail the probe cell.

**Both passers were checked cell by cell against their own patches before each cell was adopted:**

```text
                                agent-4                              agent-7
reload rebuilds family anchor   invalidateDecisions() clears         familyIndex = null in
                                familyAnchors, called on reload      reloadContext
library skips coherence         libraries take a separate            family lookup guarded by
                                selectCandidates branch              `own ? ... : null`
new warning after invalidation  invalidateDecisions() clears         invalidateForAddedUnit does
                                warnedDecisions on add               warnedDecisions.remove(name)
invalid option near misses      valueOf(toUpperCase(value))          exact switch (name)
```

### Verification (light, no forge this round, per owner instruction)

- test patch and solution patch both apply clean at the base commit; hunk header recount 1637.
- 46 tests, no duplicate method names, braces and parens balanced, both reload cells declare
  `throws IOException`.
- Each new cell reasoned to fail on the pristine base against real base semantics: `initUnit` uses
  `putIfAbsent` (first-registered wins, own upgrades over library) and `getClass` caches via
  `computeIfAbsent`.
- Each new cell traced to the description clause it enforces.

Residual risk stated plainly: this round is reasoned, not observed. One forge run would reconfirm
S2/S4 and replay agents 4 and 7.

### Not doing

- Cross-origin dedup by internal binary name (judge-c's overruled dissent): the reference and the
  pristine baseline both return the class twice, so the probe does not discriminate.
- Multi-duplicate anchor tie-breaking under `last`: two judges called it underspecified.
- Any clarification of the lazy negative-probe cache lifetime.

### Addendum (2026-07-27, later) - three advisories declined, and a self-audit that removed one of my own cells

A second fairness advisory set arrived (concurrent lookup races, deferred registration side effects,
concurrent source-addition boundary) plus a sanity warning about `@TempDir`. All were adjudicated
against the description, the reference, and the recorded run data rather than accepted on framing.
Net result: **46 -> 45 tests**. The work this round was subtractive.

#### Declined: "deferred registration side effects" - provably redundant

The proposal was to assert directly that `addSpace` logs no warning and throws no `error` conflict
until a selection is requested. Tempting, because paragraph 3 now states exactly that. But no
implementation that passes the current suite can violate it:

- Passing `invalidatedSelectionEmitsANewWarningForTheNewDecision` requires that the implementation
  have **no permanent per-name warning dedup**.
- `warningIsSemanticOrderedAndEmittedOncePerDecision` registers three differing own sources and
  requires **exactly one** warning. A registration-time warner without dedup emits one on
  `addSpace(b)` and another on `addSpace(c)` - at least two before any lookup. It fails.
- `errorRejectsDifferentHighestTierBytesWithStableOrigins` adds both sources **outside** the
  `assertThrows(..., getOwnClasses)`. A registration-time throw escapes the test body and errors it.

So both halves are already unfalsifiable by a passer - which is precisely why runs 2, 3, 5 and 8 all
fail `warningIsSemanticOrderedAndEmittedOncePerDecision`. A new cell would add zero discriminating
power and one more surface.

#### Declined: "true concurrent lookup races"

The gap is real and larger than the reviewer stated: base `saveContext()` is a sequential loop over
units and `TestFernflower` stubs `processClass`/`getClassContent`, so `THREADS=4` never creates real
concurrency here - neither half of "concurrent lookups or output processing must not change the
winner" is genuinely raced. Declined anyway. Auto-review's standing praise is "the suite is
deterministic and broad", and a latch-and-race cell is the classic source of intermittent verdicts:
an implementation that is usually correct but occasionally double-warns would grade differently run
to run, failing legitimate solvers and passing broken ones on different runs. The reference is safe
(`resolve()` double-checked under `synchronized (this)`), so the entire risk lands on candidate
grading. Trading a just-closed blocker for an open flakiness risk is a bad exchange.

#### Declined: "concurrent source-addition boundary"

No gap against the stated contract - the description claims per-context state and winner invariance
under concurrent lookups, never that `addSpace` is safe *while* lookups run. A coordinated test would
race a mutating operation against readers (worse than the above). Documenting "mutation and lookup
must not overlap" would add unenforced contract surface, which is FP-panel bait, and would be **false
about our own reference**, whose `registerUnit`/`registerClass`/`clear` are all `synchronized`.

#### Declined: the `@TempDir` sanity warning - its fix would break the build

`compilationRoot` is read from two `private static` helpers, `classBytes` and `compileClasses`, so
making the field non-static is a compile error; `@TestInstance(PER_CLASS)` is a no-op for a static
field. Static `@TempDir` has been supported since JUnit 5.4 and the repo is on 5.13.4
(`gradle.properties:6`); the field is package-private, so it avoids the `ExtensionConfigurationException`
JUnit raises for private ones. Refuted empirically as well: the four-state ran 40/40 fail-on-base and
40/40 pass-with-reference, and all 11 agent runs executed `tests=40` with two at zero failures - every
one of those builds fixtures through `compilationRoot`.

#### REMOVED my own cell: `errorDiagnosticsIgnoreLowerTierLibraryOrigins`

Added earlier the same day to close fairness advisory 1. Removed after a self-audit applying the
question "does this catch a behavioural defect, or only a presentation difference?":

1. It is a **negative message pin** (`assertFalse(message.contains("tier-library"))`) - the same
   species that caused the round-1 Test Fairness FAIL for pinning failure presentation beyond the
   prompt, and the same species the FP panel overruled judge-c for this round.
2. **Exclusivity is not stated.** Paragraph 4 requires an `error` conflict to identify *every*
   conflicting highest-tier origin - a completeness requirement. It never forbids the message from
   mentioning anything else. An implementation writing "conflict among own-a, own-b (also present in
   tier-library)" is behaviourally correct and would fail the cell.
3. **The behavioural defect is already covered.** Treating libraries as conflicting candidates is
   caught by `librariesRespectSourcePrecedenceRegistrationOrderAndCaching`, whose precedence loop
   runs `first`, `last` **and `error`** with two differing libraries plus one own source and requires
   no throw, own wins, no warnings.

No behavioural replacement is possible: the "libraries present but not conflicting" assertion *is*
that precedence loop, and any standalone "no throw" cell passes on the pristine base (base never
throws), so it could not discriminate. Fairness advisory 1 is therefore behaviourally redundant and
its remaining content is unfair to pin. Closed as bypass-with-grounds.

The remaining `assertFalse` uses in the suite are all `hasClass(...)` absence checks - behavioural,
not message content.

#### Reduced `invalidOptionNearMissesAreRejected` further: dropped `"first "`

Kept `"firstly"` and `"error!"`, which catch a real defect class (a `startsWith`/`contains` parser
accepting garbage). `"first "` only catches a *trimming* parser, which is lenient rather than broken,
and the description is silent on whitespace. Pinning it would demand strictness the prompt never
asked for. The audit's trimming mutant therefore survives - deliberate bypass with grounds.

#### Verification

Patch applies clean at base; hunk header recount 1615; 45 tests, no duplicate names, braces and
parens balanced. Description and solution patch untouched by this addendum.

---

## 2026-07-28 - v3 execution: close the two unenforced-clause blockers

Executed the v3 next plan. Test patch and description changed; **solution byte-identical to v1**
(verified by regenerating the solution diff from the worktree and diffing against the committed
patch).

### Changes

- **Task 1 (auto-review tests High #1, human Tests ask #1, fairness advisory 1):**
  `simultaneousLookupsAgreeOnOneWinnerAndResolveOnce`. Eight pooled threads meet on a
  `CyclicBarrier`, half probing `hasClass` first, then all calling `getClass` for the same duplicate.
  Asserts one winner for every thread and exactly one warning for the decision. Each worker calls
  `setCurrent(harness)` because `DecompilerContext` is a `ThreadLocal`. Bounded waits (30s) so a hung
  implementation fails instead of hanging the suite. No eager read-count assertion (see the fairness
  adjudication below). The pre-existing worker-count
  test is kept: it covers the output-processing half of the same clause.
- **Task 2 (auto-review tests High #2, human Tests ask #2, fairness advisory 2):**
  `registrationRecordsCandidatesWithoutReadingOrWarning`. After `addSpace` of two differing own
  duplicates, asserts zero `classReads` on both origins and zero warnings; then the first `getClass`
  makes reads begin (`> 0`) and emits exactly one warning. Repeats the registration half under
  `error` and asserts the conflict only surfaces at `getOwnClasses`.
- **Task 3 (verifier-audit gaps 3 + 4, one defect class):** the losing origin now also owns an
  unrelated class in `lastSelectsTheLatestOriginWithoutWritingThroughTheLoser`
  (`sample/FirstOnly`) and in `errorCoalescesIdenticalBytesAndIgnoresRepeatedEntriesFromOneOrigin`
  (`sample/SecondOnly` plus a resource). Both assert the unrelated entries still reach their own
  sink, mirroring the pattern the `first` test already used. Both switched from
  `getOwnClasses().get(0)` to `getClass(DUPLICATE)` so the marker assertion no longer depends on
  own-class ordering.
- **Task 4 (auto-review description Low P4, human Description ask):** paragraph 3 re-voiced from a
  compressed requirements list into guarantees, plus two short connective openers in paragraphs 2
  and 4. **No behavioral clause added, removed, weakened, or broadened** - all 25 clauses verified
  present after the edit. 406 words, 0 non-ASCII, 0 em dashes.

Count 45 -> 47 (two added, two extended).

### Discrimination proof (mutation probes, run locally against the reference)

| Mutant | Result |
| --- | --- |
| Base eager pre-load restored in `initUnit` | 15 failures, including the new registration cell |
| **Surgical: `registerClass` eagerly reads candidate bytes, warning still deferred** | **1 failure, exactly the new registration cell - all 45 original tests pass** |
| **Non-atomic `resolve` (drops the double-checked lock, still caches, same winner)** | **1 failure, exactly the new concurrency cell, reproduced 3/3 runs** |
| `saveContext` filters at origin scope instead of class-entry scope | 3 failures: the pre-existing `first` output test plus both extended `last`/`error` tests |

The surgical mutant is the decisive one: it is precisely the shortcut auto-review described (read and
choose during registration, defer only the exception), it passed the entire 45-test suite before this
round, and it is now caught by the new coverage alone.

### Gates

- Reference green 47/47, and stable across **five consecutive runs** (the concurrency cell is not
  flaky).
- Four-state on a pristine base worktree from the exact shipped patch bytes: S1 base+tests 1/1 pass;
  S2 new+tests on base 47/47 fail with **zero passing**; S4 base+solution 1/1 pass; S3 new+solution
  47/47 pass.
- **Sole passer replay: agent 3 stays 47/47 green.** Because tests can only remove passes, the pass
  rate is provably unchanged at 1/10 = 10%.
- **No new wall:** the two closest near-solvers (agents 1 and 7, previously 44/45) pass every new and
  extended cell and still fail only their pre-existing
  `addingLazySourceInvalidatesCachedNegativeProbe`. The new cells pin behavior competent
  implementations already have.
- Hygiene: both patches apply clean at base independently and together with `--whitespace=error`;
  `test.sh` mode 100755; `bash -n` clean; file sets disjoint; 0 non-ASCII; 0 forbidden tokens.
- Fixed a latent hygiene defect: the committed test patch carried a stale `index` blob hash
  (`e134b847`) that did not match its own content (`efd7c502`), left by hand-editing the `.patch`
  during the round-2 addendum. The patch is now regenerated from the worktree, so the recorded hash
  is truthful.

### Deliberate non-actions (recorded for the reviewer)

- Verifier-audit gaps 1 and 5 (whitespace-decorated and non-String option values) **bypassed**: they
  rest on an audit-invented requirement that the accepted-value domain is exact, which the
  description never states. The round-2 addendum had already adjudicated and dropped the `"first "`
  case with written grounds, on the reasoning that a trimming parser is lenient rather than broken.
- Verifier-audit gaps 2 and 6 **bypassed this round**: gap 6 is cosmetic, and gap 2 is a four-way
  conjunction resting on an inference rather than a stated clause.
- Fairness advisory 3 (option documentation metadata) **declined**: it would pass on both reference
  and passer, but it pins a repository convention the description never states, and
  `optionIsDocumentedDefaultedAndValidatedBeforeInputs` already covers the DEFAULTS map and
  validate-before-processing.
- No defensive byte-array cloning test: the FP adjudicator explicitly overruled that probe as an
  unfair implementation detail.
- `addingLazySourceInvalidatesCachedNegativeProbe` left untouched, so the near-solver band is
  preserved.
- Solution patch untouched (auto-review band 3, human 3/3).

### Next

Owner submits: Verify Tests, Verify Solution, auto-review (require tests band > 1 with both High
issues absent), fairness (require PASS), then a fresh batch with the required false-positive review.

### Test Fairness FAIL on the v3 test patch, and the repair (same day)

The refreshed prechecks (13:07) ran Test Fairness against the v3 test patch and returned **FAIL,
`unfairTestCount: 2`**. Both unfair entries were assertions added by this round; no pre-existing test
was implicated.

The checker split each new test into two entries and rated them separately:

| Entry | Rating |
| --- | --- |
| `registrationRecordsCandidatesWithoutReadingOrWarning` - deferral and resolution surface | Prompt-stated |
| `registrationRecordsCandidatesWithoutReadingOrWarning` - exact post-request read counts | **Not fair** |
| `simultaneousLookupsAgreeOnOneWinnerAndResolveOnce` - exact physical read counts | **Not fair** |

**Adjudicated VALID, not contested.** The description states caching for lazy probes and resolved
selections; it never states a physical read count for an eager source. A conforming implementation
could read a candidate's bytes to compare exact bytes and again to construct the class, satisfying
every stated clause while failing `classReads == 1`. That is a false negative, the exact
reject-a-correct-solution class. The checker also cites base behavior against the assertion:
`StructContext.java:257-267` preloads own classes during registration at base, so read counts are not
a stable repository contract. Root cause on our side: the assertion pinned what the reference happens
to do (its `classBytes` memo) rather than what a clause requires, and it extended a lazy-probe idiom
onto eager sources where no clause backs it.

Repair, strictly weakening (a weaker suite cannot lower the pass rate):

- `simultaneousLookupsAgreeOnOneWinnerAndResolveOnce`: removed both eager `classReads` equalities.
  Kept same-winner-for-every-thread and exactly-one-warning, which is the stated atomicity contract.
- `registrationRecordsCandidatesWithoutReadingOrWarning`: kept every `assertEquals(0, ...)` before
  selection (the checker rates that half Prompt-stated and it is what closes the auto-review
  blocker); relaxed the post-selection counts to `> 0`, asserting that reads begin only on request.

Audited afterwards: every surviving `classReads` equality in the suite is on a `lazySource(...)`
(`librariesRespectSourcePrecedenceRegistrationOrderAndCaching`, `reloadRefreshesPositiveAndNegativeDecisions`,
`addingLazySourceInvalidatesCachedNegativeProbe`), all three of which the same check rates
Prompt-stated because lazy-probe caching IS stated.

**Discrimination survived and is now cleaner** - each new cell owns a unique, prompt-grounded kill:

- eager-probe-at-registration mutant -> fails only the registration cell (via the zero-read
  assertion, which is the fair half);
- non-atomic `resolve` mutant (double-checked lock dropped, still caches, same winner) -> fails only
  the concurrency cell, via the one-warning assertion, reproduced 3/3 runs.

Honest correction to the earlier entry: the concurrency cell previously caught the registration
mutant only incidentally, because that mutation inserted its read immediately before
`classBytes.remove(className)` so the cached bytes were discarded and the counter reached 2. The
kills are now correctly separated.

Gates re-run on the final bytes: reference 47/47; four-state S1 1/1 pass, S2 47/47 fail with zero
passing, S4 1/1 pass, S3 47/47 pass; agent 3 (sole passer) 47/47 green; agents 1 and 7 fail only
their pre-existing `addingLazySourceInvalidatesCachedNegativeProbe`; both patches apply clean with
`--whitespace=error`; `test.sh` 100755; ASCII clean; no forbidden tokens; solution byte-identical;
regenerated patch blob hash `fe53d394` matches the file on disk.

Description and solution were NOT touched by this repair.

### Coverage-suggestion sweep: clause x origin-shape matrix (same day)

After the fairness repair the check regenerated its advisory list against the new suite. Rather than
answering suggestion-by-suggestion again, the whole contract was crossed against ORIGIN SHAPE
(root-eager / root-lazy / child-context / library / cross-context), because that was the axis the
earlier clause-to-test audit never varied.

Result of the matrix: the child column was empty for four clauses, but only ONE of them has a
materially distinct mechanism. Selection, error conflict, warnings and family coherence all reach the
identical resolver path regardless of whether a unit arrived as a root or as a child, and each is
already covered at root and library shape. **Output ownership is the exception**: every source builds
its own sink via `createOutputSink`, and `saveContext` iterates units calling `unit.save(...)`, so a
child origin owns a structurally separate sink. That is a real, uncovered cell.

**ADOPTED: `childOriginKeepsOutputOwnershipForItsSelectedClass`** (count 47 -> 48). Two child sources
under one parent, `last` strategy; the losing child also owns an unrelated class and a resource.
Asserts the winning child's sink alone receives the duplicate, while the losing child keeps its
unrelated class and both children keep their own resources.

- Stated: "Return every selected own class once and emit it only through its selected origin's output
  sink. Losing duplicate entries are omitted, while nonduplicate classes and non-class resources
  remain with their original inputs", plus "Each registered context source is a distinct origin".
- Uncovered before: the two existing child tests (`childContextListOrderDefinesFirstAndLast`,
  `rootRegistrationAndChildListOrderComposeLexicographically`) assert selection only and never call
  `saveContext()`.
- Reference green; assertion species identical to the existing root-shape output tests the fairness
  check already rates Prompt-stated.
- **Discrimination proven:** a mutant restricting output to root units (`unit.isOwn() && unit.isRoot()`)
  fails EXACTLY this new cell and nothing else, so the previous 47 were blind to it.
- **Zero measured cost:** agent 3 (sole passer) 48/48 green; agents 1 and 7 unchanged at their single
  pre-existing failure.

**BYPASSED, with grounds** (each probed or traced before declining):

| Suggestion | Grounds |
| --- | --- |
| Reload warning lifecycle | The rebuilt-decision warning is an INFERENCE, not a stated rule: the prompt says one warning per decision and never says a reload must re-warn. A generator that remembers it already warned for a class is defensible, so asserting a second warning risks the same false-negative class just repaired. Consequence is diagnostic-only. It is also a near-miss of an already-enforced clause: `invalidatedSelectionEmitsANewWarningForTheNewDecision` already pins fresh-warning-on-rebuild for the add-source path, which shares the rebuild mechanism. Probed anyway: the reference does emit a fresh warning and dedupes repeats, so this is a deliberate decline, not an inability. |
| Cross-context lazy-probe isolation | No fair observable exists. Making a stale cross-context probe visible needs either eager read counts (just ruled unfair this round) or the exotic setup of registering one source object in two contexts and mutating it between them. The realistic defect, a global selection cache, is already caught by `separateDecompilerContextsKeepIndependentStrategies`, which would return the wrong winner. |
| Same-name conflict reporting | The behaviour is already enforced: `sameNamedSourcesRemainDistinctOrigins` proves under `last` that two identically named sources are distinct origins (later wins, earlier's sink stays empty) and under `error` that they genuinely conflict. What remains unasserted is only how the message RENDERS two same-named origins, and the prompt never fixes that. Any assertion here (repeated entries, a disambiguating suffix, a count) pins one presentation and fails the others: that is the value-pinning class that caused the round-1 Test Fairness FAIL and was bypassed with grounds before. |

Gates on the final 48-test bytes: reference 48/48; four-state S1 1/1, S2 48/48 fail with zero passing,
S4 1/1, S3 48/48; agent 3 all green; agents 1 and 7 unchanged; both patches apply clean with
`--whitespace=error`; `test.sh` 100755; `bash -n` clean; ASCII; no forbidden tokens; solution
byte-identical; description untouched by this sweep.

### Second advisory sweep: all five suggestions adjudicated, none adopted

The check regenerated a five-item advisory list against the 48-test suite. Each was traced to the
suite and, where needed, probed. **None qualified**; all are bypassed with grounds below. Note the
checker keeps no memory of prior adjudications, which is why two items reappear.

| Suggestion | Verdict | Grounds |
| --- | --- | --- |
| Precedence independent of registration direction | Bypass | `librariesRespectSourcePrecedenceRegistrationOrderAndCaching` already runs its precedence loop over `first`, `last` AND `error` with own registered LAST. A no-tier implementation dies on the `first` iteration (it would select `eagerLibrary` where the test asserts `ownMarker`) and again on `error` (it would throw). The reversed direction is a mirror case with no new discriminating power. |
| Context-local lazy probe state (2nd appearance) | Bypass | Stated, but the realistic defect - a global selection cache - is already killed by `separateDecompilerContextsKeepIndependentStrategies` via a wrong winner. What remains requires the same `IContextSource` OBJECT registered in two contexts, a usage the prompt never describes, and would reintroduce a read-count assertion days after the read-count fairness FAIL. |
| Repeated-entry output uniqueness | Bypass (probed) | **Probed: the reference emits the repeated class exactly once (49-test probe run green).** But the reason is BASE behavior, not the feature: `ContextUnit.save` at `b8273988` already holds `Set<String> seen = new LinkedHashSet<>()` and guards `if (seen.add(cl.qualifiedName))`. The solution only added a null-check beside it. Sink once-ness is therefore inherited by every implementation, correct or broken, so the proposed assertion discriminates nothing. Also note the clause reads "Return every selected own class once and emit it only through its selected origin's output sink": the "once" attaches to Return, while the emit clause constrains WHICH sink. |
| Metadata-only local/anonymous split | Bypass | `metadataFamilyLockingPreservesLocalAndNonduplicateSplitControls` already carries BOTH controls: `memberFamily` for the `InnerClasses` path and `localFamily` for the `EnclosingMethod` path. Anonymous families run through the identical `EnclosingMethod` mechanism as local, so the suggestion is a mirror of a covered cell. |
| Reload warning lifecycle (3rd appearance) | Bypass | The rebuilt-decision warning is an inference, not a stated rule, and `invalidatedSelectionEmitsANewWarningForTheNewDecision` already pins fresh-warning-on-rebuild for the add-source path, which shares the rebuild mechanism. Probed earlier: the reference does re-warn and then dedupe, so this is a deliberate decline rather than an inability. |

Method note for future rounds: the advisory list has drifted from structural gaps (library warnings,
reload family anchoring, the two auto-review blockers) to symmetry and mirror cases, which is the
signature of a converged suite rather than of new exposure. The bar stays the four axes - stated,
reference correct, genuinely uncovered, and no conforming implementation rejected - plus a fifth
check this round made explicit: **is the behaviour guaranteed by base code the feature never
touches?** If yes, the assertion tests the repository, not the submission.

State after the sweep: 48 tests, unchanged from the child-origin round. Reference 48/48 green on the
exact shipped bytes; suite restored byte-identical after the probe; zero PROBE or MUTANT residue in
`src/` or `test/`; solution byte-identical; description untouched; shared clone clean; only the four
task worktrees remain.
