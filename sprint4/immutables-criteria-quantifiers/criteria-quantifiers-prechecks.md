**Task Type**: Olympus

Mars criteria: n/a

Olympus criteria: Median of successful agent runs: ≥2 files, ≥40 messages, ≥250 LOC

This task numbers: Median files: 16, messages: 236, LOC: 870

---

**Plagiarism Review**:

```json
{
  "inputsFingerprint": "9f92343393e4edd48163edf2e84ec63eb925ecb5c2d7321f049a87b8da81c9cc",
  "overall": "distinct",
  "perCandidate": [
    {
      "authorUsername": "anothersitara",
      "candidate_summary": "In Siddhi, enables a count state element to be used on either side of logical AND/OR in pattern and sequence queries by adding dedicated pre-/post-state processors, a specialized inner runtime, and parser/ API changes so count operands collect events and satisfy conjunctions/disjunctions per their min/max bounds while keeping indexed selection behavior.",
      "confidence": 0.95,
      "contentAuthoredAt": 1782387383187,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": true,
      "meaningful_differences": [
        "Different repositories and domains: Immutables Criteria (Java criteria/matcher engine with in-memory and MongoDB backends) vs Siddhi (CEP engine for event streams).",
        "Submission adds iterable element quantifiers all() and none() (beside any()) to the Criteria matcher API and implements their execution semantics both in-memory and in MongoDB translation, including array handling, null/missing behavior, and quantified boolean composition within elemMatch scopes.",
        "Candidate allows a count state element to act as either operand of logical AND/OR in Siddhi pattern/sequence queries, changing the grammar, query API types, and adding pre-/post-state processors and inner runtimes to control when a count operand satisfies and how collected events are exposed; no collection element matcher or Mongo translation involved.",
        "Submission modifies Path typing, CriteriaContext quantify plumbing, IterableMatcher API surface, ExpressionInterpreter’s iterable/array operators, and Mongo FindVisitor’s quantified rendering; candidate modifies Siddhi’s state machine, parser grammar (ANTLR), and state runtime coordination for count with logical operators."
      ],
      "one_liner": "They each extend quantifier semantics in separate query systems, but in different repositories and at different layers with unrelated APIs and behaviors.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "accepted",
      "reason": "The patches target different systems and surfaces: the submission augments Immutables Criteria’s iterable matcher API and its in-memory/Mongo backends with all()/none() semantics, while the candidate changes Siddhi’s stateful pattern/sequence logic to allow count operands under AND/OR with new processors and grammar. There is no shared file, API, or purpose-matched surface; any similarity is limited to the generic notion of quantification and boolean composition, which is too broad to constitute the same task.",
      "similarity": 0.5412542819976807,
      "submission_summary": "Extends Immutables Criteria to support iterable quantifiers all() and none() alongside any(), plumbing a generic quantify() through CriteriaContext/IterableMatcher, executing them in the in-memory interpreter (including arrays) and rendering correct quantified elemMatch queries in MongoDB with three-valued logic and scalar/string operators. Also adjusts Path to carry Type, and updates code generation to correctly create nested iterable creators.",
      "title": "Count quantifier as a logical pattern and sequence operand",
      "verdict": "distinct"
    },
    {
      "authorUsername": "roaamohamedd46",
      "candidate_summary": "Adds a trailing WHERE clause to TinkerPop’s GQL MATCH: extends the grammar, parses to a WhereExpression AST (comparisons, IN lists, IS NULL/NOT NULL, AND/OR/NOT with precedence), validates variable references, and evaluates it with three‑valued logic during execution to keep only rows where the condition is true.",
      "confidence": 0.94,
      "contentAuthoredAt": 1784206643004,
      "evalStatus": "ok",
      "evidence_gaps": [],
      "isOlder": false,
      "meaningful_differences": [
        "Different repositories and domains: Immutables Criteria (including MongoDB translation) vs. Apache TinkerPop GQL grammar and executor.",
        "Submission adds iterable quantifiers any/all/none at the element level (including nested quantifiers) across Iterables and arrays, with corresponding in‑memory evaluation and MongoDB $elemMatch/type semantics; candidate adds a trailing WHERE clause over whole MATCH rows with comparisons/IN/NULL and precedence, no collection quantifiers or MongoDB translation.",
        "Submission modifies matcher APIs (IterableMatcher), CriteriaContext, Path typing, in‑memory ExpressionInterpreter, and Mongo FindVisitor; candidate modifies the ANTLR grammar (GQL.g4), introduces a WhereExpression AST and evaluators, and wires it through QueryGraph, planner, and executor.",
        "Submission handles array vs iterable parity in IS_EMPTY/HAS_SIZE/CONTAINS and preserves legacy flat ANY equality semantics; candidate focuses on cross‑type numeric comparisons, IN list behavior, AND/OR/NOT with three‑valued propagation, and variable/parameter resolution errors.",
        "Submission also updates code generation (CriteriaModel) for nested iterable creators; candidate performs variable‑reference validation in WHERE and filters only rows that evaluate to true."
      ],
      "one_liner": "Each adds richer boolean filtering to a different query system: one introduces element-quantified collection matchers to Immutables Criteria (with in‑memory and MongoDB execution), while the other adds a top‑level WHERE clause to TinkerPop’s GQL MATCH with three‑valued logic.",
      "overlap": {
        "same_repo": false,
        "shared_apis": [],
        "shared_description_claims": [],
        "shared_test_behaviors": []
      },
      "problemStatus": "draft",
      "reason": "The patches target unrelated codebases and surfaces: one extends Immutables Criteria’s iterable matcher API and its execution engines (in‑memory and MongoDB) to support ANY/ALL/NONE with element‑scoped semantics; the other extends TinkerPop’s GQL by adding a WHERE grammar, AST, and evaluator applied to full MATCH results. Although both mention three‑valued logic and boolean composition, those are generic concerns; there is no shared file, API, or purpose‑matched behavior. They teach different debugging lessons and can co‑exist.",
      "similarity": 0.5200218558311462,
      "submission_summary": "Extends Immutables Criteria to support collection quantifiers any(), all(), and none(), wiring them through the matcher API and CriteriaContext, executing them in the in‑memory interpreter (including arrays) with refined three‑valued logic, and translating them to MongoDB queries using $elemMatch/type while preserving legacy ANY semantics. Also adjusts Path typing and code generation to handle nested iterable element creators.",
      "title": "WHERE clause filtering for GQL match()",
      "verdict": "distinct"
    }
  ],
  "reusedFromPriorRun": true
}
```

---

**Test Fairness**

Coverage Suggestions (2) - Not Blockers

Advisory only — these don't affect the check result.

Mongo arrays
Add at least one real Mongo execution test for `all()` / `none()` on object arrays or primitive arrays, since arrays are prompt-stated but current Mongo hidden coverage focuses on `List` fields.

Nested `any()` on invalid inner non-arrays
Add a Mongo test where an inner collection reached from an outer quantified element stores a scalar/non-array value and is queried with nested `any()`, to directly cover the prompt’s special rule that `any()` inside a new quantifier scope must not match non-array stored values.

Raw output:

```json
{
  "completed": true,
  "coverageSuggestions": [
    {
      "area": "Mongo arrays",
      "suggestion": "Add at least one real Mongo execution test for `all()` / `none()` on object arrays or primitive arrays, since arrays are prompt-stated but current Mongo hidden coverage focuses on `List` fields."
    },
    {
      "area": "Nested `any()` on invalid inner non-arrays",
      "suggestion": "Add a Mongo test where an inner collection reached from an outer quantified element stores a scalar/non-array value and is queried with nested `any()`, to directly cover the prompt’s special rule that `any()` inside a new quantifier scope must not match non-array stored values."
    }
  ],
  "error": "",
  "executionTimeSeconds": 374.435184,
  "message": "All hidden tests are fair.",
  "overall": "The hidden tests are fair overall. The prompt is unusually specific about quantified semantics, null/missing handling, same-element correlation, arrays, nested scopes, and Mongo execution, and the repo already exposes the relevant DSL and existing `any()` patterns. The API-shape tests are also discoverable from public interfaces (`IterableMatcher`, `Disjunction`, `WithMatcher`, `NotMatcher`) and existing `any()` tests. I did not find a hidden assertion that depends on an unstated implementation detail or a behavior that a careful engineer could not reasonably infer from the prompt plus repository.",
  "taskSummary": "The task is to add two new collection quantifiers, `all()` and `none()`, everywhere the Criteria DSL already exposes iterable/array element matching via `any()`. They must return the same element matcher type as `any()`, preserve fluent composition (`with`, `not`, `and`, `or`, nested field access, string matchers, optionals, collection predicates), and implement precise quantified semantics in both the in-memory interpreter and MongoDB query execution. Key prompt-stated edge cases are: empty collections/arrays satisfy `all()` and `none()` but not `any()`; null/missing runtime collections satisfy none of the three; null elements or null/missing nested values never count as a matching element, even for negative predicates; decisive `or` / `and` short-circuiting must win over missing values; nested quantifiers keep separate element scopes; arrays behave like iterables; Mongo must execute real find queries with same-element correlation and preserve legacy flat positive `any()` behavior outside the new quantified scopes.",
  "tests": [
    {
      "evidence": "`IterableOperators.ALL` already exists as a binary operator in `criteria/common/src/org/immutables/criteria/expression/IterableOperators.java:41-48`. Existing `any()` is implemented by emitting `Expressions.binaryCall(IterableOperators.ANY, path, right)` in `criteria/common/src/org/immutables/criteria/matcher/CriteriaContext.java:148-161`, and `IterableMatcher.any()` exposes that quantified element matcher in `criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java:57-59`. Adding `all()` beside `any()` with the analogous operator node is the repo's discoverable form.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_ApiTest.allProducesUsableTypedMatcher",
      "qualityCheck": "Fair but shallow API smoke test; it checks public expression shape, not internals.",
      "verifies": "Calling `StringHolderCriteria.stringHolder.list.all().is(\"x\")` produces a query filter tree that contains `IterableOperators.ALL` and an `Operators.EQUAL` leaf."
    },
    {
      "evidence": "`IterableOperators.NONE` is already defined in `criteria/common/src/org/immutables/criteria/expression/IterableOperators.java:46-49`. The existing iterable quantifier pattern is visible from `CriteriaContext.any()` in `criteria/common/src/org/immutables/criteria/matcher/CriteriaContext.java:148-161`, and scalar matchers already emit `IN`/`EQUAL` leaves under quantified scopes in existing `any()` tests such as `criteria/mongo/test/org/immutables/criteria/mongo/FindVisitorTest.java:115-119`.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_ApiTest.noneProducesUsableTypedMatcher",
      "qualityCheck": "Fair and specific; it pins the public filter form implied by the existing `any()` architecture.",
      "verifies": "Calling `StringHolderCriteria.stringHolder.list.none().in(\"x\", \"y\")` produces a query filter tree that contains `IterableOperators.NONE` and an `Operators.IN` leaf."
    },
    {
      "evidence": "The DSL's no-arg disjunction is a public matcher feature in `criteria/common/src/org/immutables/criteria/matcher/Disjunction.java:29-36`. Quantified expressions already return back to the root criteria after a terminal predicate, and cross-root `or(...)` composition with `any()` is exercised in `criteria/common/test/org/immutables/criteria/personmodel/AbstractPersonTest.java:631-641`. The prompt also says `and` / `or` composition must remain usable inside the quantified surface.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_ApiTest.quantifiedMatcherRetainsRootDisjunction",
      "qualityCheck": "Fair regression test for fluent API continuity; slightly overlaps broader runtime tests.",
      "verifies": "`list.all().is(\"x\").or().value.is(\"fallback\")` yields a filter containing `IterableOperators.ALL`, `Operators.OR`, and `Operators.EQUAL`."
    },
    {
      "evidence": "`IterableMatcher` is explicitly parameterized as `<R, S, V>` and `any()` returns `S` in `criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java:29-30,57-59`, so returning the same element matcher type is the discoverable contract. `WithMatcher.with(...)` and `NotMatcher.not(...)` are public DSL features in `criteria/common/src/org/immutables/criteria/matcher/WithMatcher.java:41-48` and `criteria/common/src/org/immutables/criteria/matcher/NotMatcher.java:39-43`. Existing object-quantifier usage via `.pets.any().name...` and `.pets.any().with(...)` / `.not(...)` is already exercised in `criteria/common/test/org/immutables/criteria/personmodel/AbstractPersonTest.java:624-667` and `criteria/mongo/test/org/immutables/criteria/mongo/FindVisitorTest.java:123-149`.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_ApiTest.objectQuantifiersKeepTheirGenericMatcherContract",
      "qualityCheck": "Fair and high-value: it checks the public generic/fluent contract, not a private implementation detail.",
      "verifies": "On `IterableMatcher`, both `all()` and `none()` have the generic return type equal to the interface’s second type parameter; on `PersonCriteria.person.pets`, invoking each quantifier returns an object whose `name` field can be used for `is(\"fluffy\")`, whose `with(...)` call produces a quantified filter containing the quantifier operator plus `AND` and both equality constants `\"fluffy\"` and `\"buddy\"`, and whose `not(...)` call produces a quantified filter containing the quantifier operator plus `NOT` and equality constant `\"fluffy\"`."
    },
    {
      "evidence": "Array attributes are already modeled as `IterableMatcher.Template<...>` in generated-criteria expectations such as `criteria/common/test/org/immutables/criteria/processor/CriteriaModelProcessorTest.java:142-144,189,231-235`. Array element typing is explicitly supported by `Matchers.iterableTypeArgument(...)` in `criteria/common/src/org/immutables/criteria/matcher/Matchers.java:49-64` and tested in `criteria/common/test/org/immutables/criteria/matcher/MatchersTest.java:46-55`. The prompt also explicitly says object arrays and primitive arrays follow the same quantified rules.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_ApiTest.generatedArrayMatchersExposeUsableQuantifiers",
      "qualityCheck": "Fair API-surface test; good coverage for generated array matchers.",
      "verifies": "Generated matchers for `String[]` and `int[]` expose `all()` and `none()`, and `arrayQuantifier.is(...)` produces filters containing the expected quantifier operator and `Operators.EQUAL`."
    },
    {
      "evidence": "The prompt states: \"`any()` matches when at least one element satisfies the predicate, `all()` matches when every element satisfies it, and `none()` matches when no element satisfies it. An empty collection or array therefore matches `all()` and `none()`, but not `any()`.\" It also explicitly requires these semantics in the in-memory backend.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.publicMatcherMethodsHaveDistinctRuntimeSemantics",
      "qualityCheck": "Fair and direct truth-table smoke test.",
      "verifies": "For an in-memory `list.all().is(\"x\")` filter, a holder with `['x','x']` matches, `['x','y']` does not, and `[]` matches; for `list.none().is(\"x\")`, `['a','b']` matches, `['x','y']` does not, and `[]` matches."
    },
    {
      "evidence": "The prompt says the returned quantified matcher keeps scalar comparisons usable and that \"the quantified surface also includes string prefix, containment, suffix, and length checks.\" It separately defines `all()` / `none()` semantics and requires them to work in the in-memory backend.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.generatedStringMatchersExecuteInsideQuantifiers",
      "qualityCheck": "Fair and concrete; good user-visible coverage of the string matcher surface.",
      "verifies": "Within in-memory quantified string element matchers: `all().startsWith(\"a\")` matches `['alpha','amber']` but not `['alpha','beta']`; `none().contains(\"ph\")` matches `['amber','echo']` but not `['alpha','echo']`; `all().endsWith(\"a\")` matches `['alpha','beta']` but not `['alpha','echo']`; `none().hasLength(5)` matches `['four','six']` but not `['alpha','four']`."
    },
    {
      "evidence": "The prompt explicitly says: `all()` and `none()` are available wherever Criteria exposes an iterable element matcher; within the returned matcher, scalar comparisons, nested object fields, and `with`, `not`, `and`, and `or` remain usable; the quantified surface includes optional presence/absence and collection empty/non-empty/size/containment checks; and empty collections satisfy `all()` and `none()`.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.generatedObjectMatchersRetainTheirQuantifierAtRuntime",
      "qualityCheck": "Fair and strong, though dense; it bundles many public-surface regressions into one test method.",
      "verifies": "In the in-memory backend, `all`/`none` on `pets` preserve quantified semantics for: `pet.name.is(\"fluffy\")`; `pet.address.isPresent()`; `not(pet.name.is(\"fluffy\"))`; `pet.collar.tags.isEmpty()` / `.notEmpty()` / `.hasSize(1)` / `.contains(\"rescue\")`; and in each of those families, an empty outer `pets` collection vacuously matches `all` and `none` while mixed/non-matching cases fail exactly as asserted."
    },
    {
      "evidence": "The prompt requires `all()` to return the same matcher type as `any()` and says `and` / `or` composition remains usable on the quantified surface. Existing matcher composition is part of the public DSL.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.generatedQuantifierSurvivesRootDisjunctionAtRuntime",
      "qualityCheck": "Fair; checks a real fluent-API edge rather than internals.",
      "verifies": "The in-memory filter from `list.all().is(\"x\").or().value.is(\"fallback\")` matches a holder whose list is all `x`, matches a holder whose root `value` is `fallback` even when the list is mixed, and rejects a holder where neither branch is true."
    },
    {
      "evidence": "The prompt gives exactly these quantifier semantics and explicitly calls out vacuous truth for empty collections/arrays.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.scalarTruthTableAndVacuousTruth",
      "qualityCheck": "Fair, thorough, and non-brittle.",
      "verifies": "For a manually built in-memory quantified expression over `List<String>`, `ANY/ALL/NONE` on equality to `\"x\"` produce the full truth table: all-`x` => `true/true/false`, mixed => `true/false/false`, none-`x` => `false/false/true`, empty => `false/true/true`."
    },
    {
      "evidence": "The prompt states that negative predicates are still element predicates and that \"a null element ... is not a match, including for a negative predicate; it therefore fails `all()` for that element but does not defeat `none()` when no element produces true.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.notEqualScalarTruthTableAndBoundaries",
      "qualityCheck": "Fair and important; it prevents the common mistake of treating negative predicates as matching nulls.",
      "verifies": "For in-memory `NOT_EQUAL \"x\"` under `ANY/ALL/NONE`, all-non-`x`, mixed, all-`x`, and empty follow the corresponding truth table, and a collection containing only `null` yields `ANY=false`, `ALL=false`, `NONE=true`."
    },
    {
      "evidence": "The prompt defines `all`/`none` in terms of whether every / no element makes the predicate evaluate to true, independent of the specific scalar operator family, and explicitly says a predicate belongs to one element at the quantifier where written.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.scalarOperatorFamiliesUseAllAndNoneMatrices",
      "qualityCheck": "Fair matrix-style test; a bit redundant with the simpler truth-table checks, but it broadens operator coverage.",
      "verifies": "For in-memory quantified predicates using `IN`, `>= \"m\"`, explicit `NOT(EQUAL \"x\")`, and `OR(EQUAL \"x\", EQUAL \"y\")`, `ALL` matches only the all-true and empty cases while `NONE` matches only the no-true and empty cases; mixed cases match neither."
    },
    {
      "evidence": "The prompt says: \"A null or missing runtime collection matches none of the three quantifiers; it is not treated as empty.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.nullCollectionMatchesNoQuantifier",
      "qualityCheck": "Fair and essential edge case.",
      "verifies": "A `null` runtime collection matches none of `ANY`, `ALL`, or `NONE`, both for an equality predicate and for a `NOT_EQUAL` predicate."
    },
    {
      "evidence": "The same prompt sentence covers nested paths too: \"A null or missing runtime collection matches none of the three quantifiers; it is not treated as empty.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.nullIntermediateCollectionMatchesNoQuantifier",
      "qualityCheck": "Fair nested-path regression test.",
      "verifies": "When the quantified path reaches a nested collection field whose runtime value is `null`, `ANY`, `ALL`, and `NONE` all evaluate to false."
    },
    {
      "evidence": "The prompt explicitly says \"values from different elements cannot be combined to satisfy a compound predicate\" and that element-level equality compares the whole element. For the exact acceptance of only the shared instance in-memory, `ExpressionInterpreter` uses `Objects.equals(left, right)` for `EQUAL` in `criteria/inmemory/src/org/immutables/criteria/inmemory/ExpressionInterpreter.java:199-200`; the local `Entry` type in the test has no custom `equals`, so only the same instance can satisfy the predicate.",
      "fairness": "Repo-discoverable",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.compoundPredicateCannotCombineDifferentElements",
      "qualityCheck": "Fair, but it mixes two distinct behaviors in one method; both are still user-visible and discoverable.",
      "verifies": "An in-memory quantified `AND(left=='A', right=='Y')` over `entries` does not become true by combining two different elements; `NONE` is true when no single element satisfies it. The same test also requires whole-element `EQUAL` to use ordinary object equality: the exact same `Entry` instance matches, while a distinct `new Entry(\"A\",\"X\",null)` with identical field values does not."
    },
    {
      "evidence": "The prompt says: \"A null element, or a missing or null value reached within an element, is not a match, including for a negative predicate... Within a compound predicate, a true `or` branch or false `and` branch is decisive even if another branch reaches a missing or null value, regardless of branch order.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.missingNestedValueDoesNotSatisfyPredicate",
      "qualityCheck": "Fair and high-value; it checks the tricky null-propagation rules the prompt singled out.",
      "verifies": "If a quantified object element has `detail == null`, then both `detail.code == \"ok\"` and `detail.code != \"ok\"` are non-matching for that element, giving `ANY=false`, `ALL=false`, `NONE=true` when only such elements exist. The test also requires short-circuit semantics: `OR(left=='A', right=='Y')` is true when one branch is true even if the other branch hits a missing/null value, in either branch order; and `NOT(AND(left=='A', right=='Y'))` is true when one branch is false even if the other branch hits missing/null, in either order."
    },
    {
      "evidence": "The prompt says nested quantifiers may be mixed when reached through an object field, \"each quantifier keeps its own element scope,\" and \"empty inner collections follow the same truth rules.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.mixedNestedQuantifiersKeepTheirOwnScopes",
      "qualityCheck": "Fair and directly tied to the prompt's nested-scope requirement.",
      "verifies": "Nested in-memory quantifiers keep separate scopes: `ALL(groups, ANY(numbers, 1))` matches only when every group has some `1`; `NONE(groups, ALL(numbers, 1))` matches only when no group is entirely `1`s; `ANY(groups, NONE(numbers, 9))` can be satisfied by one group with no `9`s, including an empty inner collection."
    },
    {
      "evidence": "The prompt states that each predicate belongs to one element at the quantifier where it is written and that nested quantifiers reached through object fields keep one scope per quantifier.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.nestedQuantifierAndSiblingUseTheSameOuterElement",
      "qualityCheck": "Fair and important same-element-correlation test.",
      "verifies": "For an outer `groups` quantifier, a compound predicate `group.label == \"ok\" AND ANY(group.numbers == 1)` must be satisfied by the same outer `Group`; splitting those truths across different groups does not satisfy `ANY` or `ALL`, while `NONE` becomes true in the split case and on the empty outer collection."
    },
    {
      "evidence": "The prompt explicitly says: \"Object arrays and primitive arrays follow the same rules as iterable values\" and separately says null runtime collections/arrays are non-matching for all three quantifiers.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.objectArraysUseTheSameTruthTable",
      "qualityCheck": "Fair and directly on-point for the requested array surface.",
      "verifies": "`String[]` under `ANY/ALL/NONE` follows the same quantified truth table as iterables for all-match, mixed, no-match, empty-array, and null-array cases; specifically, empty arrays give `false/true/true` and null arrays give `false/false/false`."
    },
    {
      "evidence": "Same prompt support: primitive arrays must follow the same rules as iterable values, with empty arrays vacuously satisfying `all` and `none`, and null arrays matching none of the quantifiers.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.primitiveArraysUseTheSameTruthTable",
      "qualityCheck": "Fair coverage of the primitive-array half of the requirement.",
      "verifies": "`int[]` under `ANY/ALL/NONE` follows the same truth table as iterables for all-match, mixed, no-match, empty-array, and null-array cases."
    },
    {
      "evidence": "The prompt explicitly says: \"Inherited collection predicates such as `isEmpty()`, `notEmpty()`, `hasSize()`, and `contains()` treat arrays and iterable values alike.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_InMemoryTest.arrayCollectionLeafPredicatesUseIterableSemantics",
      "qualityCheck": "Fair; good boundary test for the non-quantified array surface that the prompt explicitly preserved.",
      "verifies": "For array-valued criteria fields, inherited collection predicates behave like iterables: `isEmpty`, `notEmpty`, `hasSize(2)`, and `contains(...)` on `String[]` and `int[]` accept and reject the asserted array values exactly as the corresponding iterable predicates would."
    },
    {
      "evidence": "The prompt states the `any/all/none` truth rules, that a null or missing runtime collection matches none of the three quantifiers, and that in MongoDB a non-array stored value is non-matching for the new `all()` and `none()` scopes. It also explicitly requires execution as real MongoDB find queries, not just rendering.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.scalarAllAndNoneExecuteCompleteTruthTables",
      "qualityCheck": "Fair, strong integration coverage, and non-brittle because it compares sorted ids from inserted fixtures.",
      "verifies": "Real Mongo find queries for `ALL(values == 'x')`, `NONE(values == 'x')`, `ALL(values != 'x')`, and `NONE(values != 'x')` return exactly the asserted `_id` sets: only `matching` and `empty` for `allX`; only `non_matching` and `empty` for `noneX`; only `non_matching` and `empty` for `allNotX`; only `matching` and `empty` for `noneNotX`, with `null`, missing, and non-array stored values excluded."
    },
    {
      "evidence": "The prompt says a null element is not a match \"including for a negative predicate; it therefore fails `all()` for that element but does not defeat `none()` when no element produces true.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.scalarOperatorFamiliesRejectNullElements",
      "qualityCheck": "Fair and useful; it checks several operator families against the same null-element rule.",
      "verifies": "For real Mongo queries under `ALL`/`NONE`, null array elements never count as satisfying `IN`, `NOT_IN`, or `>= 10`: `ALL` matches only the fully true and empty documents, while `NONE` includes the no-true, null-only, and empty documents but excludes mixed documents and arrays containing a matching value plus `null` when at least one element evaluates true."
    },
    {
      "evidence": "The prompt explicitly includes string prefix/containment/suffix/length checks in the quantified surface, says string length counts every character including line breaks, and says missing/null values reached within an element are not matches. It also requires Mongo execution inside quantified scopes.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.stringElementMatchersRemainUsableInsideAllAndNone",
      "qualityCheck": "Fair and detailed; strong user-visible Mongo coverage.",
      "verifies": "Real Mongo queries under `ALL`/`NONE` correctly handle element-level `startsWith`, `contains`, `endsWith`, and `hasLength`; empty arrays vacuously match `ALL` and `NONE`; null string elements do not satisfy the predicate and therefore can still allow `NONE`; `hasLength` counts newline characters (`'ab\\ncd'` has length 5 and `'a\\n'` has length 2); and the same `startsWith` semantics apply when the element predicate reads a nested object field like `entries.left`."
    },
    {
      "evidence": "The prompt says \"A predicate belongs to one element at the quantifier where it is written, so values from different elements cannot be combined to satisfy a compound predicate.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.compoundScalarPredicatesStayInsideOneElementScope",
      "qualityCheck": "Fair and important same-element-correlation test.",
      "verifies": "For real Mongo queries over scalar arrays, `ALL(values, startsWith('a') AND endsWith('a'))` matches only `all_both` and `empty`, and `NONE(...)` matches `split`, `neither`, and `empty`, meaning separate elements cannot be combined to satisfy the `AND`."
    },
    {
      "evidence": "The prompt explicitly requires that the matcher API and semantics work in MongoDB query translation and says rendering a filter is not sufficient: the named element operations must execute as real MongoDB find queries inside quantified scopes. It also states that missing/null values reached within an element are not matches and that empty inner collections use the same truth rules.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.generatedNestedMatcherChainExecutesAsMongoFind",
      "qualityCheck": "Fair and especially valuable because it exercises the generated fluent DSL end-to-end against Mongo.",
      "verifies": "A real Mongo find for the generated DSL expression equivalent to `person.pets.all().with(pet -> pet.collar.tags.none().is(\"rescue\"))` returns exactly `all_clean` and `empty_pets`, excluding `contains_rescue` and `missing_tags`."
    },
    {
      "evidence": "The prompt states: \"An equality predicate written on the element itself compares the entire element value; an element with additional or missing fields is not equal.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.wholeDocumentElementEqualityDoesNotDegradeToPartialFieldMatching",
      "qualityCheck": "Fair and precise; good guard against accidental field-subset matching in Mongo.",
      "verifies": "For a quantified element predicate equal to the exact BSON document `{left:'A',right:'B'}`, `ALL(documents, exact)` matches only `exact`, `all_exact`, and `empty`; `NONE(documents, exact)` matches `partial`, `extra`, `different`, `null_element`, and `empty`, so extra or missing fields are not treated as equal."
    },
    {
      "evidence": "The prompt says negative predicates on ordinary fields outside quantifier scopes must keep their existing missing/null behavior. The repo shows ordinary `NOT_EQUAL` on Mongo renders as `$ne` in `criteria/mongo/src/org/immutables/criteria/mongo/FindVisitor.java:188` and `criteria/mongo/test/org/immutables/criteria/mongo/FindVisitorTest.java:48-52`. Under standard Mongo query semantics, `{status: {$ne: 'blocked'}}` matches documents whose field is missing or has a different value, including null.",
      "fairness": "Standard external semantics",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.topLevelNotEqualKeepsLegacyMissingAndNullBehaviorBesideAll",
      "qualityCheck": "Fair regression test; it depends on well-known Mongo `$ne` semantics rather than hidden harness behavior.",
      "verifies": "A top-level Mongo `status != 'blocked'` filter still matches documents where `status` is missing or null, and combining it with `ALL(values == 'x')` reduces the result set to `allowed_all`, `missing_all`, and `null_all`."
    },
    {
      "evidence": "The prompt explicitly says: \"Legacy flat positive `any()` queries must continue to match an equal scalar stored field value,\" while the new quantified-scope rules apply only inside new quantifier scopes. Existing flat-positive-`any()` rendering is also visible in `criteria/mongo/test/org/immutables/criteria/mongo/FindVisitorTest.java:109-132`.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.legacyAnyBranchStaysFlatBesideAll",
      "qualityCheck": "Fair and important backward-compatibility coverage.",
      "verifies": "When a query is `ANY(values == 'x') OR ALL(scores >= 10)`, real Mongo results include a scalar stored `values:'x'` document (`scalar_any`), an array `values:['x']` document (`array_any`), and a document satisfying the `ALL(scores >= 10)` branch (`all_only`); negating that whole disjunction returns only `neither`."
    },
    {
      "evidence": "The prompt's same-element rule applies equally to object arrays: different fields from different elements cannot be combined to satisfy one quantified predicate, and truth depends on whether that element's predicate evaluates true.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.compoundObjectPredicatesStayInsideOneElementScope",
      "qualityCheck": "Fair and strong; it covers both `AND` and `OR` on object elements.",
      "verifies": "For real Mongo queries over object arrays, `ALL(entries, left=='A' AND right=='Y')` matches only `all_both` and `empty`, `NONE(...)` matches `split`, `left_only`, `neither`, and `empty`; and for `OR`, `ALL` matches `all_both`, `split`, `left_only`, and `empty` while `NONE` matches only `neither` and `empty`."
    },
    {
      "evidence": "The prompt says: \"Within a compound predicate, a true `or` branch or false `and` branch is decisive even if another branch reaches a missing or null value, regardless of branch order.\"",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.decisiveBooleanBranchesOverrideMissingValuesRegardlessOfOrder",
      "qualityCheck": "Fair and directly targeted at an easy-to-get-wrong semantic corner.",
      "verifies": "Under real Mongo `ALL`/`NONE`, `OR(left=='A', right=='Y')` treats a true branch as decisive even if the other branch is missing, in either branch order; and `NOT(AND(left=='A', right=='Y'))` treats a false branch as decisive even if the other branch is missing, again regardless of order. The accepted `_id` sets are exactly the asserted ones."
    },
    {
      "evidence": "The prompt expressly says missing/null values inside an element are not matches \"including for a negative predicate\" and therefore do not make an element satisfy `all`, while still allowing `none` when no element evaluates true.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.negativeObjectLeavesUseTrueOnlySemantics",
      "qualityCheck": "Fair and valuable negative-predicate regression test.",
      "verifies": "For real Mongo queries over object arrays, element-level `left != 'x'` and `left notIn ['x','z']` count only actual true evaluations: `ALL` matches only `present_true` and `empty`; `NONE` matches `present_false`, `null_leaf`, `missing_leaf`, `false_and_missing`, and `empty`, so null or missing leaves are not treated as satisfying the negative predicate."
    },
    {
      "evidence": "The prompt requires scalar comparisons, explicit negation, and composition to remain usable inside quantifiers, and it defines quantified truth in terms of which elements evaluate to true while missing/null inner values are non-matching.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.positiveInExplicitNotAndComparisonBoundsExecute",
      "qualityCheck": "Fair matrix test; broad but still user-facing.",
      "verifies": "Real Mongo quantified queries correctly execute element-level `IN ['x','z']`, explicit `NOT(left == 'x')`, `score >= 10`, and `score < 10`, with `ALL` matching only the asserted all-true and empty documents and `NONE` matching only the asserted no-true / null / missing / empty documents."
    },
    {
      "evidence": "The prompt includes optional presence/absence and collection empty/non-empty checks in the quantified surface, says missing/null reached within an element is not a match, and says empty collections satisfy `all` and `none`.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.optionalAndIterableStatesAreComplemented",
      "qualityCheck": "Fair and explicit about two different leaf-operator families inside quantifiers.",
      "verifies": "Within real Mongo quantified scopes, `IS_PRESENT`, `IS_ABSENT`, `IS_EMPTY(tags)`, and `NOT_EMPTY(tags)` produce exactly the asserted `_id` sets: present/missing/null optionals are distinguished as asserted, and null/missing `tags` do not satisfy either collection-state predicate while empty outer collections still vacuously match `ALL` and `NONE`."
    },
    {
      "evidence": "The prompt says collection size and containment checks are part of the quantified surface, empty inner collections follow the same truth rules, and null/missing runtime collections are non-matching rather than empty.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.collectionLeafPredicatesExecuteInsideQuantifierScopes",
      "qualityCheck": "Fair and directly aligned with the prompt's collection-leaf requirements.",
      "verifies": "For real Mongo queries over `entries`, element predicates `tags.hasSize(1)` and `tags.contains('x')` execute inside quantified scopes so that `ALL` and `NONE` return exactly the asserted ids, with empty outer arrays vacuously matching `ALL`/`NONE`, but outer `null`/missing collections not matching, and inner null/missing `tags` not counting as true."
    },
    {
      "evidence": "The prompt covers same-element correlation, nested boolean composition, and null/missing inner-value handling. The accepted sets are direct instances of those stated rules.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.nestedBooleanTreesAreComplementedWithinOneElementScope",
      "qualityCheck": "Fair and useful; it checks more complex boolean trees without coupling to implementation details.",
      "verifies": "For real Mongo quantified predicates `leftA AND (rightB OR score>5)` and `leftA OR (rightB AND score>5)`, `ALL` and `NONE` return exactly the asserted ids, including rejecting the `split` document for the `nestedAnd` case because different elements cannot be combined, and treating missing/null inner fields as non-matching."
    },
    {
      "evidence": "The prompt says nested quantifiers may be mixed through object fields, each quantifier keeps its own scope, empty inner collections use the same truth rules, null/missing runtime collections match none of the quantifiers, and in Mongo a non-array stored value is non-matching for the new quantified scopes and for `any()` inside a new quantifier scope.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.mixedNestedQuantifiersKeepEveryCollectionScope",
      "qualityCheck": "Fair and strong; this is one of the core semantics the task asked for.",
      "verifies": "Real Mongo queries for `ALL(groups, ANY(numbers == 1))`, `NONE(groups, ALL(numbers == 1))`, and `ANY(groups, NONE(numbers == 1))` return exactly the asserted ids, including the special cases for empty outer collections, empty inner collections, inner null/missing/non-array values, and outer null/missing/non-array values."
    },
    {
      "evidence": "The prompt states that nested quantifiers reached through object fields keep one scope per quantifier and that sibling predicates at the outer quantifier belong to the same outer element.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.nestedQuantifierAndSiblingStayOnTheSameOuterElement",
      "qualityCheck": "Fair and highly relevant to same-element correlation in nested scopes.",
      "verifies": "For a real Mongo outer quantifier over `groups`, the compound predicate `label == 'ok' AND ANY(numbers == 1)` must be satisfied by the same outer `Group`: `ANY` matches `all_good` and `one_good`, `ALL` matches `all_good` and `empty`, and `NONE` matches `split`, `neither`, `inner_invalid`, and `empty`."
    },
    {
      "evidence": "The prompt says nested quantifiers reached through an object field keep one scope per quantifier and explicitly calls out nested quantifiers through object fields. This test is a concrete same-name path variant of that stated rule.",
      "fairness": "Prompt-stated",
      "name": "CriteriaQuantifiers_6f90c2_MongoTest.sameNamedCollectionsSeparatedByAPlainObjectStayScoped",
      "qualityCheck": "Fair and subtle; good protection against path-prefix scoping bugs.",
      "verifies": "A real Mongo query for `ALL(outer numbers, NONE(holder.numbers == 1))` matches exactly `matching`, `inner_empty`, and `empty_outer`, proving that the inner `numbers` collection under `holder` is scoped separately from the outer `numbers` collection even though the field names repeat."
    }
  ],
  "unfairTestCount": 0,
  "verdict": "PASS"
}
```

---

**Shipd Bot Description Warnings**

> "A collection or array whose element is itself a collection or array"

Soften or remove this exclusion. The hidden tests exercise nested quantifiers reached through object fields, but they do not pin down behavior for direct collection-of-collections inputs. A lighter replacement would be: "No special handling is required for direct collection-of-collections cases unless it falls out naturally."

**Conciseness Warnings**

```json
{
  "status_reasoning": "There are 5 suggestions total, including a HIGH-priority removal of an over-specified block. Per the rules, any high-priority item or 3+ suggestions requires a request_changes verdict.",
  "suggestions": [
    {
      "priority": "high",
      "quote": "and return the same element matcher type as `any()`. Within that returned element matcher, scalar comparisons, nested object fields, and `with`, `not`, `and`, and `or` composition remain usable. The quantified surface also includes string prefix, containment, suffix, and length checks; optional presence and absence checks; and collection empty, non-empty, size, and containment checks.",
      "suggestion": "Remove this whole block. The return type should mirror `any()` by default, and all listed element operations are already available on existing element matchers and remain unchanged; the solver can see this from the codebase. Listing every supported leaf predicate is over-specified noise."
    },
    {
      "priority": "medium",
      "quote": "An element satisfies its predicate only when evaluation produces true.",
      "suggestion": "Remove – tautological filler that adds no actionable information beyond what a predicate means."
    },
    {
      "priority": "medium",
      "quote": "Inherited collection predicates such as `isEmpty()`, `notEmpty()`, `hasSize()`, and `contains()` treat arrays and iterable values alike. Empty inner collections follow the same truth rules.",
      "suggestion": "Remove – redundant with earlier statements that arrays follow iterable semantics and that empties satisfy `all()`/`none()`. These behaviors are already encoded in existing matchers and visible in the codebase."
    },
    {
      "priority": "medium",
      "quote": "Nested quantifiers reached through object fields keep one scope per quantifier.",
      "suggestion": "Remove – duplicate of the earlier sentence stating each quantifier keeps its own element scope. Keep the earlier occurrence and drop this repetition."
    },
    {
      "priority": "medium",
      "quote": "and negative predicates on ordinary fields outside quantifier scopes keep their existing missing and null behavior.",
      "suggestion": "Remove this clause – it’s a generic “preserve existing behavior” directive. The specific legacy rule to keep (`any()` matching a scalar stored field) is already stated and should remain; this extra clause is an obvious default."
    }
  ],
  "summary": "- **[HIGH]** Delete: “and return the same element matcher type as `any()`. Within that returned element matcher, scalar comparisons, nested object fields, and `with`, `not`, `and`, and `or` composition remain usable. The quantified surface also includes string prefix, containment, suffix, and length checks; optional presence and absence checks; and collection empty, non-empty, size, and containment checks.” Rationale: mirroring `any()`’s return type is obvious from the existing API; enumerating all supported leaf predicates is over-specified and discoverable from the codebase.\n- **[MEDIUM]** Delete: “An element satisfies its predicate only when evaluation produces true.” Rationale: tautological and adds no actionable guidance.\n- **[MEDIUM]** Delete: “Inherited collection predicates such as `isEmpty()`, `notEmpty()`, `hasSize()`, and `contains()` treat arrays and iterable values alike. Empty inner collections follow the same truth rules.” Rationale: redundant with prior statements (arrays follow iterable semantics; empties satisfy `all()`/`none()`); behavior is already in existing matchers.\n- **[MEDIUM]** Delete: “Nested quantifiers reached through object fields keep one scope per quantifier.” Rationale: duplicate of earlier “each quantifier keeps its own element scope” – keep the first mention only.\n- **[MEDIUM]** Delete clause: “and negative predicates on ordinary fields outside quantifier scopes keep their existing missing and null behavior.” Rationale: generic “don’t change existing behavior”; unnecessary given the more specific legacy `any()` requirement that remains.",
  "verdict": "request_changes"
}
```
