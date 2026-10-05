# Immutables — Typed Value Pointers for Enclosed Value Families — Plan

> Repository: `immutables/immutables` · Base: `45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e` (== repos/immutables HEAD)
> Problem: `value-pointers` · Work dir: `my-work/immutables-value-pointers/`
> Source idea: `immutable-tmp-plan.md` §2.1 (rev. 3 LEAD) — typed value pointers: parse/render string
> paths, resolve, focused update with identity preservation.
> Calibration: the fold campaign band (fold accepted at 402-422 official count_loc, 47 tests, 2/10
> legit passes + FP-panel PASS; structural-patch accepted 595 eff at 10%; binary at 610 eff).
> Target: official count_loc ~550-800, 45-55 tests, pass rate inside the owner's ~20% ask.
> Status: W1 plan. All platform numbers live ONLY in `olympus-tmp/new-dot-agent/rules/platform-bar.md`.

## 1. What it is

For an eligible `@Value.Enclosing` umbrella (one declaring at least one family: a non-generic nested
abstract type with two or more non-generic nested `@Value.Immutable` implementations), the processor
generates a public final companion class named `<Umbrella>Pointers` in the umbrella's package:

- a nested immutable `Pointer` value parsed from / rendered to a compact string form (round-trip
  guaranteed, RFC-6901-shaped: leading `/` per step, `~0`/`~1` escaping, `""` = the root pointer);
- `Pointer parse(String)` / `String render(Pointer)` — `parse` throws a nested
  `MalformedPointerException` naming the offending character position;
- `Object resolve(Object root, Pointer p)` — walks steps by the SHAPE of the value at hand and
  returns the addressed value, with a tri-split miss taxonomy as distinct nested exceptions:
  `PointerMissException` (structural: absent attribute on the runtime implementation, index past the
  end, absent map key, empty optional, descent through null) vs `PointerTypeException` (shape
  mismatch: step at a non-descendable value, non-canonical index at a list, descent into
  set/multiset/multimap/sorted or non-string-keyed map) vs `MalformedPointerException` (parse only);
- `Object update(Object root, Pointer p, java.util.function.UnaryOperator<Object> op)` — applies the
  operator at the addressed position and rebuilds ONLY the single spine, with two hard identity
  invariants: every value and container off the spine is carried into the result as the SAME instance
  (`==`), and an operator result that is equal to the existing value returns the ORIGINAL root
  instance unchanged.

```java
@Value.Enclosing
interface Ast {
  interface Expr {}
  @Value.Immutable interface Lit extends Expr { int value(); }
  @Value.Immutable interface Add extends Expr {
    List<Expr> terms(); Optional<Expr> carry(); Map<String, Expr> bindings(); }
}
// generated: public final class AstPointers {
//   public static final class Pointer { ... }
//   public static Pointer parse(String s) { ... }        // "/terms/2/bindings/a~1b"
//   public static String render(Pointer p) { ... }
//   public static Object resolve(Object root, Pointer p) { ... }
//   public static Object update(Object root, Pointer p, UnaryOperator<Object> op) { ... }
//   public static final class MalformedPointerException extends RuntimeException { ... }
//   public static final class PointerMissException extends RuntimeException { ... }
//   public static final class PointerTypeException extends RuntimeException { ... }
// }
```

## 2. The full behavioral contract (every test-pinnable choice, decided up front)

### 2.1 String form (total grammar)
- `""` parses to the root pointer (zero steps). Any other pointer starts with `/`; each step is the
  text between separators. A step's text uses `~1` for `/` and `~0` for `~`; any other use of `~`
  (dangling, `~2`...) is malformed. A non-empty string not starting with `/` is malformed. Malformed
  reporting: MalformedPointerException with the 0-based character position in the message.
- Render is the exact inverse and the ONLY rendering (escape exactly `~` and `/`); render(parse(s))
  == s for every accepted s, parse(render(p)) equals p. Empty steps are legal (they can name an
  empty-string map key; on a value they miss, since no attribute is named "").
- Pointer value semantics: `Pointer` instances from equal strings are equal (equals/hashCode);
  `toString()` returns the rendered form. (Stated in description; tested.)

### 2.2 Resolution (step applied by the shape of the current value/position)
- Root must be a generated implementation of the umbrella's nested `@Value.Immutable` types that is
  itself non-generic; anything else (hand-written impl of the abstract type, a generic
  implementation's instance, an unrelated object, null) throws IllegalArgumentException. Runtime
  classification is exact-class (generated impls are final).
- Step at a family/impl value = attribute selector over the RUNTIME implementation's attributes,
  declared AND inherited. No attribute of that name on that implementation -> miss.
  - REGULAR attribute: position = the attribute's value. If that value is itself a nested
    implementation of the same umbrella, further steps descend into it (the value actually present
    decides what is addressable below — static family typing does not limit descent).
  - OPTIONAL attribute (jdk/guava/fugue/javaslang flavors): the step addresses the CONTENT; empty ->
    miss. Descent continues through the content by its shape.
  - LIST or ARRAY attribute: the step addresses the container value itself; the FOLLOWING step must
    be a canonical index (`0`, or nonzero digit then digits; no sign, no leading zeros; int range):
    canonical index past the end -> miss; non-canonical step text at a container -> type mismatch.
    Elements descend by their shape.
  - MAP attribute with String keys (plain Map kind only): following step = key (after unescaping);
    absent key -> miss. Values descend by their shape.
  - SET / SORTED SET / MULTISET / MULTIMAP / SORTED MAP / non-String-keyed MAP attributes: the
    attribute step resolves to the container value (terminal); any further step -> type mismatch.
  - NULLABLE attribute holding null: resolving THAT position returns null; any step THROUGH it ->
    miss.
  - Any further step at a non-descendable value (a String, a primitive box, a foreign object, a
    container element that is itself a container) -> type mismatch.
- resolve of the root pointer returns the root.

### 2.3 Update (single-spine rebuild + identity discipline)
- Walks like resolve (same taxonomy thrown on the way); applies the operator to the addressed value
  (which may be null at a nullable position).
- If the operator result is equal (Objects.equals) to the existing value -> return the ORIGINAL root
  (same instance, nothing rebuilt). This is the deep no-op short-circuit.
- Otherwise rebuild bottom-up along the spine only: element replaced inside a copied list/array/map
  (map copy preserves iteration order and all other entries; list/array copy carries all other
  element references), attribute replaced via the implementation's wither; each parent level rebuilt
  by ITS wither only. Every value/container off the spine is the same instance in the result.
- Type discipline: an operator result that does not fit the position's type -> PointerTypeException,
  root untouched. A null result is legal ONLY at a `@Nullable` position; elsewhere ->
  PointerTypeException, root untouched.
- update at the root pointer applies the operator to the root itself (result must be an addressable
  implementation value or equal -> returned as the new root; null/non-fitting -> the taxonomy above).

### 2.4 Generation boundary
- Companion generated ONLY for `@Value.Enclosing` types declaring >= 1 family (non-generic nested
  abstract member with >= 2 non-generic nested immutable implementations). Others receive nothing
  (tested absence). Generic implementations are not addressable (root -> IAE; as values -> terminal).
- Zero corpus blast radius inherited from fold's measured proof (same family predicate; fold ledger:
  "no corpus umbrella eligible"). Re-verified at Gate B.

## 3. Why this is hard at its core (the withheld work; primitives-lens audit)

- The repo hands over per-attribute withers/builders and (from fold, now upstream-invisible to
  agents at this base: fold is NOT in the base) nothing else: NO path grammar, NO parser/renderer,
  NO per-kind positional resolve, NO spine rebuild, NO identity discipline. All of it is net-new
  emitted-code design.
- The famous-spec risk (JSON Pointer / RFC 6901) is real and priced in: the ESCAPING GRAMMAR is
  recallable, but the graded core is repo-specific OUTPUT DESIGN — typed resolution against
  generated impls (kind matrix x optional flavors x nullable x inherited attributes), single-spine
  wither/builder rebuild with `==` off-spine preservation and equals short-circuit, the tri-split
  taxonomy kept total across every kind x step shape — plus the proven template-DSL execution wall
  (fold/binary/structural: ~60% of every batch dies at FAIL_SYNTAX/INTEGRATION before semantics).
  Binary held 1/12 castor on a textbook-recallable TLV codec: the wall + matrix carries Olympus
  difficulty even when the algorithm is famous. Gate C gauntlet must confirm regardless.
- The naive implementation (split on '/', rebuild whole tree via builders everywhere, one exception
  type) compiles and passes happy-path round-trips but fails: escaping/adversarial keys, canonical
  index rules, the `==` identity cluster, the no-op short-circuit, and the tri-split taxonomy.

## 4. Fork table (each an independent failing cluster; ablation-provable)

| # | Fork | Naive/bypass choice -> observable failure | Killing observable |
|---|------|-------------------------------------------|--------------------|
| P1 | Parse/render round-trip incl. escapes | split('/')/no escapes | keys containing '/', '~', '~0' literal, unicode; render inverse |
| P2 | Malformed taxonomy w/ positions | lenient parse | dangling '~', '~2', missing leading '/', position in message |
| P3 | Per-kind resolve matrix | only regular attrs | list/array/map/optional/nullable/inherited fixtures |
| P4 | Canonical index discipline | Integer.parseInt | "01"/"-1"/"+1"/overflow at list -> type mismatch; in-range/past-end split |
| P5 | Tri-split miss taxonomy | one exception for all | distinct exception classes per scenario matrix |
| P6 | Single-spine rebuild w/ off-spine `==` | deep rebuild/copyOf everywhere | `==` asserts on siblings at every level incl. container elements |
| P7 | No-op deep short-circuit | always rebuild | op returning equal value -> same root instance |
| P8 | Map rebuild order + other entries | HashMap/put-order loss | iteration order preserved, updated key keeps position |
| P9 | Runtime-shape descent (family-typed positions) | static-type routing | deeper impl held in supertype-typed attribute: its own attrs addressable |
| P10 | Non-descendable kinds + generic/foreign boundary | descend everything | set/multiset/multimap/sorted descent -> type mismatch; generic root -> IAE; absence for ineligible umbrellas |
| P11 | Null discipline | NPE leaks | null resolve at nullable; miss through null; op-null legality split |

Cascade: P1+P3+P5 share one design commitment (typed walk with total taxonomy) and route >50% of the
planned suite; P6+P7 share the spine-rebuild commitment (the anti-bypass cluster).

## 5. Bypass audit (each cheap pass path -> its killing test)

B1 split('/') parser: P1/P2 kill. B2 regex-only index parse: P4 kills. B3 whole-tree rebuild
(builder.from at every node recursively): P6 kills (off-spine `==`), P7 kills (no-op). B4 single
exception type: P5 kills. B5 equals-based classification of root (instanceof abstract type): P9/P10
kill (hand-written impl must IAE; exact-class required). B6 static-type attribute routing: P9 kills.
B7 skip optional flavors: per-flavor fixtures kill. B8 HashMap rebuild: P8 kills. B9 reflection-based
generic walker inside generated code (Class.getMethod at runtime): behaviorally faithful alternate
design — must PASS if it honors every contract (fairness); it is harder than codegen, not a shortcut;
identity + taxonomy + canonical index still force the full design. B10 mutate-through-serialization
(rebuild via copyOf(toString))— fails P6 trivially. Every remaining pass path implements the full
contract.

## 6. Design locks (stated verbatim in the description; the contract-locking lesson)

- Names: `<Umbrella>Pointers` (public final, umbrella package), nested `Pointer`,
  `MalformedPointerException`, `PointerMissException`, `PointerTypeException`; statics `parse`,
  `render`, `resolve`, `update` with the exact parameter shapes above (`java.util.function.UnaryOperator`).
- Grammar: leading-`/` steps, `~0`/`~1`, `""` = root, canonical index form, empty step legal.
- Identity invariants: off-spine `==`, equal-result -> same root; map order preservation.
- Taxonomy assignment per §2.2/§2.3 (each arm stated in behavioral prose, no exception-hierarchy
  prescription beyond the three names + IAE for foreign roots).
- Eligibility: the fold trigger sentence family (>= 1 family of >= 2 impls); nothing otherwise.

## 7. Volume (Gate B MEASURES; the gensub 174-collapse is the cautionary baseline)

Honest per-chunk projection (post-gensub calibration): PointerModel (eligibility, per-impl attribute
step tables across kinds x flavors, value/impl naming for casts+withers) ~160-240; Pointers.generator
(emitted parser/renderer + Pointer value class + exceptions + per-impl resolve dispatch + per-kind
step logic + per-impl per-kind spine rebuild + identity/short-circuit discipline) ~280-420 template
lines; ValueType hook + template binding + Processor wiring ~30-50. Projection ~470-710 official
count_loc. **Kill/escalate line: Gate B slice (parser + regular/list/map resolve + wither rebuild on
one probe family, working) measuring < ~220 official, or full projection < ~420.**

## 8. Gates

- Gate A (paper) — PASSED above: P1+P3+P5 route >50% of a 45-55-test suite by construction; the
  wall adds the free floor. Re-check against the real suite at W3.
- Gate B — build the slice in an isolated worktree, BUILD ON THE FORGE ONLY (no local mvn; owner
  disk + hybrid-cloud rule), measure official count_loc. Thresholds §7. Also re-verify corpus
  blast radius ZERO (no `*Pointers` generated for any corpus fixture).
- Gate C — zero-context strongest-model gauntlet with ONLY the draft description + repo at base.
  Questions: does it produce the full taxonomy + identity discipline unprompted? does the
  template-DSL integration fight it? Grade the FINAL artifact. KILL/DEEPEN if it lands a
  substantially-complete correct generator in one pass (famous-spec watch: RFC 6901 recall is
  expected; the kind matrix + identity + taxonomy in template DSL is what must bite).
- FP-bulletproofing (before W3 test freeze): hostile-judge fixture sweep — key equal to an escape
  sequence, empty-string vs absent key, unicode keys, `@Nullable` holding null at the addressed
  position, operator returning null at non-nullable, `01`/`-1`/overflow indexes, foreign same-name
  umbrella in a sibling package (fold T5 lesson), sorted-map/set descent, generic-impl root,
  hand-written impl root, deep mixed spine with `==` asserts at every off-spine sibling, update at
  root pointer, `Pointer` equality across parse/render round-trips. BOTH the reference and the
  hidden suite must survive every one.
- W4: four-state from final patch files on the forge + ablation (one injected bug -> exactly one
  fork cluster) + fresh-session adversarial review + apply-check/GNU-patch gates before upload.

## 9. Harness (fold verbatim)

Dockerfile cloned from `Dockerfile-exhaustive-fold` (JVM base, /opt/m2 world-writable cache, BOM +
surefire-provider dependency:get pre-caching, whole-reactor `-DskipTests install` + go-offline).
test.sh cloned from fold (FOCUS_TEST=`ValuePointers_<hex>_Test`, focused-class split base/new,
surefire XML merge, Maven-log fallback JUnit failure — reviewer-demanded, keep verbatim). Fixtures
under `value-fixture/test/org/immutables/fixture/vptr_<hex>/`, hashed basenames, base annotations
only, compile-on-base; hidden test reaches the companion reflectively (Class.forName + getMethod;
operator = java.util.function.UnaryOperator lambda — plain JDK, no Proxy needed). S2 = 100%
fail-at-runtime on base (companion absent). Expected values derived from freshly built objects
(dump-then-assert; no fixture literals in asserts — the binary value-pinning lesson).

## 10. Distinctness (the §1 landscape)

No wire format (binary), no diff/apply ops (structural-patch), no traversal/memo/dispatch-to-cases
(fold — pointers do ONE downward walk + ONE spine up; no memoization, no case methods, no bottom-up
delivery). Untaken mechanism family: addressing/parsing + focused update. Residual overlap = the
`@Value.Enclosing` trigger sentence (unavoidable; flagged for the owner's plagiarism preflight per
the menu). The owner runs the preflight on the description before submission.
