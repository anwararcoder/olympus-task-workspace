# Solution Review Guide

Review as a strict human maintainer. Solution must implement only what is asked - correctly and safely. Do not assume intent or guess behavior. Assign a rating from 1-7.

---

## Auto-Reject (Rate 1)

- Invalid git patch or conflicts with tests
- Breaks base tests (`test.sh base` fails)
- Contains tests, Dockerfile, or unrelated changes
- Requires new dependencies or internet access
- Contains malicious code
- Trivial one-liner that doesn't demonstrate real work
- Fundamentally out of scope or misaligns with repo philosophy

---

## Quality Criteria

**Correctness** - Solves the problem exactly as described. Handles all edge cases. No hardcoded or test-specific values. No cheating to pass tests. No conceptual misunderstanding. When implementing spec-defined features (TC39, RFC, etc.), naming, tagging, and behavior must match the spec exactly (e.g., @@toStringTag values, method names, prototype identity).

> Scope conformance to the stated round-trip target. If the description says "write files that X can read back," do NOT flag deviations from the broader format spec (e.g., OOXML, RFC) unless they break the stated round-trip. For example, omitting xml:space="preserve" is not a bug if the target reader doesn't require it and the tests pass. External spec conformance beyond the stated target is informational, not mandatory.

**Completeness** - All requirements implemented. No missing behavior. No extra behavior beyond what's asked. No unrelated edits or out-of-scope file changes.

**No Over-Engineering** - Solution proportional to the problem. No speculative logic for scenarios not in the description. No unnecessary abstractions or indirection. Simple and direct preferred over clever and complex.

**Unrequired Code Audit** - Every new function, type, interface, middleware, helper, constant, and export in the patch must trace back to a specific requirement in the description. If a symbol exists in the patch but is not required by the description and not tested, it is unrequired code and must be flagged. This includes: helper functions that could be inlined, types/interfaces that are never enforced by tests, middleware or wrapper layers not asked for, factory functions or builder patterns when a direct approach suffices. Even 10-20 lines of unrequired code is a significant issue. Count the unrequired lines and report the total.

**Repo Pattern Alignment** - Aligns with repo architecture, idioms, and existing patterns. Async/sync behavior preserved. No global state issues, hidden side effects, or contradictions with existing documentation. Must extend existing infrastructure (prototypes, intrinsics, base classes) rather than creating replacements - new constructors/prototypes that shadow existing ones break instanceof, type hierarchies, and future features.

**Prototype Chain & Wiring Verification** - When a solution registers new constructors, prototypes, or intrinsics using builder/factory APIs, do NOT assume the builder method names match their effect. Trace through the builder's actual implementation to verify what each method does. Specifically check:
- Does `Constructor.prototype` point to the correct existing intrinsic? (e.g., `Iterator.prototype === %IteratorPrototype%`, not a new object)
- Does `Constructor.__proto__` point to `Function.prototype`? (unless spec says otherwise)
- Does `instanceof` work for all existing objects that should match? (e.g., `[].values() instanceof Iterator` must be true)
- Are static methods placed on the constructor, not the prototype? Are prototype methods on the prototype, not the constructor?
- Builder methods like `.prototype()`, `.inherits()`, `.static_method()`, `.method()` may target different objects (constructor vs prototype vs __proto__). Read the builder source to confirm which object each method modifies. A method named `.prototype()` might set `__proto__` instead of the `.prototype` property.

**Code Quality** - Clean, readable, maintainable. No dead code, unused functions, or leftover comments. No magic strings. Descriptive variable names. No unreachable branches. Follows repo conventions and style. Doc comment density must match the repo: add doc comments when the repo uses them on similar code; omit them when peer files (same layer/visibility) have none. Function-level JSDoc/doc-comments on every internal helper in a file where sibling files have zero is a style violation.

> Do NOT flag guarded type casts or narrowing conversions as unsafe when a preceding numeric guard demonstrably makes the operation safe. For example, `v as i64` after `v.abs() < 1e15` is safe because 1e15 is well within i64::MAX (~9.2e18). Only flag if the guard is insufficient or missing.

**AI Slop Detection** - No AI-generated comments (NOTE, TODO, obvious restatements). No robotic/templated patterns inconsistent with the repo. Code reads like it was written by someone familiar with the codebase. No verbose boilerplate where the repo uses concise idioms. Hallmark AI tell: adding JSDoc/doc-comments to every function in an internal file when peer internal files have none — this inflates LOC and is stylistically inconsistent.

**Error Handling** - Graceful handling of invalid inputs. Clear user-facing error messages (not silent failures unless specified). Optional operators only suppress errors when explicitly intended. Type errors not ignored. No silently swallowed errors.

**Silent Behavior Changes** - Watch for code that "works" but changes meaning, modifies data subtly, or hides problems instead of reporting them.

**No Regressions** - Existing functionality works. `test.sh base` and `test.sh new` pass. No structural breakage to existing modules or interfaces.

**Round-Trip & Data Preservation (if applicable)** - No information loss or implicit structure modification. Full reconstruction of original input possible. Flag flattening, key reordering, or semantic changes during transformation.

**Format Logic Correctness (if applicable)** - Output format matches requested format. No accidental fallback to defaults. Serialization matches actual data shape.

---

## Red Flags

- Dead code: unused functions, no-op loops, unreachable branches
- Subtle bug: recover/fallback that changes semantics
- **Numeric correctness at the singular/extreme limit**: for accuracy-driven or numerically singular code (perimeter/area/quadrature, gamma/log-gamma, overflow guards, n->0 and n->inf), verify by EXECUTION at both limits and against an invariant that must always hold (a convex perimeter <= its bounding-rectangle perimeter; a probability in [0,1]). A magic threshold in a guard (`1 + 2/n < 171`) is a claim: confirm where THIS implementation actually breaks, not the textbook value (kurbo's Lanczos overflowed at arg ~143, not 171.6, so area returned 0.0 in a band no test covered). "Accurate by design" is not a verification (kurbo-superellipse: perimeter 14.23 above the 14.0 convex ceiling at n=4096).
- Hidden failure: silent error swallowing
- Scope creep: unrelated edits or defensive code not required by description
- Over-engineering: unnecessary abstractions or complexity
- Speculative logic: handling scenarios not in the description
- Unrequired code: functions, types, middleware, helpers, or exports that are not required by the description and not covered by tests. This includes wrapper layers, factory functions, custom type definitions, before/after hooks, and any plumbing code that the description never asked for. Flag with line count
- AI slop: robotic comments, verbose boilerplate, inconsistent patterns
- Breaking change: API contract changes without documentation
- Infrastructure replacement: creating new constructors/prototypes/globals instead of extending existing ones (breaks instanceof, prototype chains, future implementations)
- Prototype wiring bug: builder/factory API used incorrectly so that Constructor.prototype is a new object instead of the required intrinsic, or Constructor.__proto__ is wrong. Verify by tracing the builder's build() method - check what object ends up as the .prototype property vs the __proto__ chain. This is a silent bug that passes all functional tests but breaks instanceof and future features
- Identity violation: spec requires Constructor.prototype === %SomeIntrinsic% (identity, not just inheritance). If the builder creates a NEW prototype object that merely inherits from the intrinsic, instanceof breaks for all existing objects in that hierarchy
- Coverage gap: untested new behavior
- Data loss: transformation logic that loses or alters information
- Semantic drift: code that "works" but subtly changes meaning
- Regression risk: changes that could break existing functionality
- Missing doc comments: new types/functions without documentation when repo pattern requires it
- Excessive doc comments: JSDoc/doc-comments on every function in internal/private files when peer files at the same layer have none — characteristic AI-generated boilerplate that inflates LOC

---

## Cross-Check with Tests

Every behavior in `solution.patch` should be covered by `test.patch`. Flag untested or only implicitly verified logic.

---

## Review Process

1. Read `solution.patch` and understand the intended change
2. Read the actual modified files directly
3. Verify: implementation matches intent, no regressions, no structural breakage, proper error handling, no unrelated edits
4. Cross-reference with the description to confirm completeness
5. **Unrequired code audit**: List every new function, type, interface, middleware, helper, and export introduced by the patch. For each one, verify it maps to a specific requirement in the description. If it doesn't, check if it's tested. If it's neither required nor tested, flag it as unrequired code with the line count. A solution that adds ~20+ lines of unrequired plumbing (e.g., middleware wrappers, factory helpers, custom types not in the spec) is over-engineered regardless of whether it passes tests.
6. **If the solution registers new constructors, prototypes, or globals using builder/factory APIs**: trace through the builder's actual source code (not just the call site) to verify the wiring. Check that `.prototype` properties, `__proto__` chains, and `instanceof` relationships are correct. Do not trust method names - read what the builder methods actually do internally.

---

## Rating Scale

| Rating | Label | Criteria |
|--------|-------|----------|
| **1** | **Rejected** | Invalid patch, conflicts, breaks base tests, out of scope. |
| **2** | **Fundamentally Broken** | Major requirements missing, conceptual misunderstanding, regressions, structural breakage. Substantial rewrite needed. |
| **3** | **Major Quality Issues** | Incomplete implementation, design inconsistencies, visible AI slop, or significant repo pattern deviation. Heavy revision needed. |
| **4** | **Borderline** | Functionally close but awkward design, questionable edits, minor regression risk, or pattern violations. Needs changes. |
| **5** | **Good (Approvable)** | Meets all requirements. Slightly clunky or mildly over-engineered. Minor pattern deviations but no regressions or unrelated edits. |
| **6** | **Strong** | Complete and correct. Minor stylistic issues or tiny simplification opportunities. Fully aligned with repo philosophy. |
| **7** | **Exceptional** | All requirements exactly. Zero unnecessary changes. Fully idiomatic. No dead code, no speculative logic, no unrelated edits. |

- 1-3: Do not approve
- 4: Request revisions
- 5-7: Approvable (5 is minimum)

### Reviewer Shortcut (4-7 Decision Aid)

Ask: "How many quality comments would I realistically leave?"

| Answer | Rating |
|--------|--------|
| 0 meaningful improvement comments | **7** |
| 1-3 minor polish suggestions | **6** |
| Several quality comments, but still approvable | **5** |
| Requires changes before merge | **4** |

---

## Output

Write in `Feedback.md`:

```
## Rating: [N] - [Label]

## Issues Found
- [Category: Correctness / Completeness / Over-engineering / Pattern violation / Code quality / AI slop / Regression / Scope creep / Red flag] [Description of the issue]
  ```
  [relevant code snippet from solution.patch showing the problematic code]
  ```

## Summary
[1-3 sentences on why this rating was given]
```

Rules: Only fix-required issues. Be direct, specific, human-like. No generic commentary. Don't propose implementations. Reference exact code locations.
