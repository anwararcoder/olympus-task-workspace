# Criteria Collection Quantifiers Plan

## Objective

Add typed `all()` and `none()` collection quantifiers beside Criteria's existing `any()` matcher. The API and semantics must work through generated matchers, the in-memory backend, and MongoDB without changing standalone legacy `any()` behavior.

- Repository: `https://github.com/immutables/immutables.git`
- Base commit: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e`
- Verification model: local inspection and patch generation; all builds, tests, and mutations in the isolated Codespace forge
- Commit policy: do not commit or tag this work

## Current State

The task artifacts are mechanically complete and ready for a fresh platform submission. The production solution was left unchanged during the final audit because its exact bytes already passed the full reactor and no concrete production defect was found.

The final iteration corrected three artifact-level blockers:

1. Five focused compatibility controls passed on the base revision. Olympus requires every focused test case to fail, error, or skip before the solution, so those redundant controls were removed. Existing baseline tests already cover the same legacy `any()` behavior.
2. `criteria/common/pom.xml` added APIGuardian only for tests. A disposable offline probe proved the focused API fixtures compile and pass without it, so the dependency and POM change were removed.
3. The description repeated generic compatibility and scope disclaimers. It was shortened while retaining all non-obvious observable behavior.

`Universal-and-negative/` remains untouched as historical evidence from the initial platform submission.

## Behavioral Contract

- `any()` requires at least one true element predicate, `all()` requires every element predicate to be true, and `none()` requires no true element predicate.
- Empty collections and arrays satisfy `all()` and `none()`, but not `any()`.
- Null, missing, or invalid runtime collections satisfy none of the quantifiers.
- Object arrays, primitive arrays, and directly nested collection or array layers follow the same rules as iterables.
- Compound predicates remain correlated to one element at their quantifier scope.
- Missing or null nested values are non-true, including under negative predicates.
- Quantifiers can be nested and mixed at arbitrary collection depth, with an independent scope at every level.
- Existing element-matcher operations remain usable through generated `all()` and `none()` matchers.
- MongoDB preserves array-domain checks, same-element correlation, nested scope, and the established flat positive standalone `any()` behavior.

## Artifact Map

### Solution patch

- `criteria/common/src/org/immutables/criteria/expression/Path.java`
- `criteria/common/src/org/immutables/criteria/matcher/CriteriaContext.java`
- `criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java`
- `criteria/inmemory/src/org/immutables/criteria/inmemory/ExpressionInterpreter.java`
- `criteria/mongo/src/org/immutables/criteria/mongo/FindVisitor.java`
- `value-processor/src/org/immutables/value/processor/meta/CriteriaModel.java`

### Test patch

- `criteria/common/test/org/immutables/criteria/matcher/CriteriaQuantifiers_6f90c2_ApiTest.java`
- `criteria/inmemory/test/org/immutables/criteria/inmemory/CriteriaQuantifiers_6f90c2_InMemoryTest.java`
- `criteria/mongo/test/org/immutables/criteria/mongo/CriteriaQuantifiers_6f90c2_MongoTest.java`
- `test.sh` (`100755` in the patch)

The patches have zero overlapping paths. No production file or POM is present in the test patch.

## Final Evidence

| Gate | Result |
| --- | --- |
| Upstream freshness | Live `master` still equals the pinned base; issue #1210 remains open and PR #1526 does not implement `all()` or `none()` |
| Patch hygiene | Exact-base apply checks pass with `--whitespace=error`; combined `git diff --check` is clean |
| Base artifact | SHA-256 `70bbff7cae77b414c309edf86eaa3992728e86debf6b2fb4bac8a3dc69e167eb` |
| Dockerfile | SHA-256 `d1d6b4d227609754a7489c2ba2687160e94e5ee672fcf68a2ff8fc8c90c8e631` |
| Description | SHA-256 `abf68ffad7672641bb439e12ce2fd49014489f5b55cd292a5d258f518b5438a6` |
| Test patch | SHA-256 `fb2ef55186f70d9905a3fdd56676594f2ce9141d215d69d79ce6e520bf412c79` |
| Solution patch | SHA-256 `682d79f6b90f1e68cff3419d15890a89ffef0c900329077814979a0986d33095` |
| S1: base + tests | 424 tests, 0 failures, 0 errors, 7 existing skips |
| S2: focused before solution | 46 tests: 1 failure, 45 errors, 0 skips, **0 passes** |
| S3: focused after solution | 46 tests, 46 passes, 0 failures/errors/skips |
| S4: baseline after solution | 424 tests, 0 failures, 0 errors, 7 existing skips |
| Exact Docker images | Test image `sha256:274f5eb745cdfbf3c1d1d606cbb494b87d7ba9e7de48093087ed0cfeeba51e6e`; solution image `sha256:7d6dfee70279dbf313e4f3b2e44c8dacd8bab324418f7315daf08b7287863a73` |
| Full reactor | Unchanged solution bytes passed all 34 modules: 1,407 tests, 0 failures/errors, 24 existing skips |
| Mutation sensitivity | Focused tests rejected `ALL -> ANY`, dropped outer context, eager unknown return, removed Mongo array guard, and inverted fieldless collection-leaf truth |
| Meaningful production LOC | Conservative count remains 539 across six production files |

The final baked-image XML and logs are stored under `.verify/final-baked/`; supporting build and mutation logs are under `.verify/final-rerun/`.

## Submission Sequence

1. Upload the five canonical task artifacts: description, base commit, Dockerfile, test patch, and solution patch.
2. Compare the uploaded bytes with the recorded hashes before trusting any evaluation.
3. Run environment, fairness, overlap, and solution checks.
4. Run the agent batch and inspect trajectories, not only the aggregate pass rate. The live Olympus bar requires at least one legitimate solve while retaining the current difficulty limits.
5. Run the required False Positive evaluation against passing solutions.
6. If any artifact changes after upload, regenerate its hash and repeat the affected verification gate.

Platform agent trajectories, pass rate, successful-run medians, and False Positive adjudication cannot be produced locally. They remain post-submission acceptance gates, not missing artifact work.
