# Previous Reviews

## v8 — Ishaan S — revision_requested — 2026-07-07 17:35

Quality score: 6

Problem Description - (3/3) Clean

Tests - (2/3) Minor
The suite is broad, but it misses an important requirement interaction. It only tests constructor-built values with BinTuple, whose constructor attributes are String, int, and List<String>. The prompt says constructor-built values work and separately promises arrays, multisets, multimaps, sorted maps/sets, bimaps, and nested generated immutables. Add constructor-only fixtures covering at least nested generated immutables and a few non-list container/array shapes, and assert those generated classes expose and round-trip through writeTo/readFrom

Solution & Code - (2/3) Minor
The reference solution does not satisfy the full prompt. ValueAttribute.isBinaryConstructorFit() allows constructor-only binary generation only for primitives/strings/enums, optionals, list, set, and plain map. That means constructor-only immutables with arrays, multisets, multimaps, sorted/bimap shapes, or nested generated immutable attributes silently do not receive writeTo/readFrom, even though those shapes are described as supported and the prompt says constructor-built values work. Either implement those constructor combinations or narrow the prompt and tests.

---

## v9 — Ishaan S — revision_requested — 2026-07-08 07:50

Quality score: 6

Problem Description - (3/3) Clean

Tests - (2/3) Minor
A passing solution still mishandled @Nullable stored attributes and nested generated immutable attributes whose nested type declares type parameters. Add focused fixtures for those cases and rerun agents. Also rename the HIDDEN variable in test.sh, test artifacts should avoid hidden/meta wording. (you can check the same in the false positive check under general requirements)

Solution & Code - (3/3) Clean

---

## v10 — Ishaan S — revision_requested — 2026-07-09 09:38

Quality score: 6

Problem Description - (2/3) Minor
Prompt feels a bit too long

Tests - (2/3) Minor
The behavior coverage is strong, but the harness still loses useful failure detail in JUnit when Maven fails before Surefire reports are produced. In failing agent runs, the XML only says the base/new tests were missing from JUnit, while the real compiler error is only in the text log. Please make test.sh preserve Maven/compiler output in the generated JUnit failure body so failures are actionable from the platform artifacts.

Solution & Code - (3/3) Clean

---

## v12 — Ishaan S — revision_requested — 2026-07-10 10:11

Quality score: 3

Problem Description - (1/3) Weak
The activation and auxiliary semantics are unclear. The prompt promises the methods on every eligible immutable, but the reference silently requires the separate org.immutables:serial artifact, and required @Auxiliary attributes cannot simply be recomputed. State the activation model, correct the auxiliary rule, and trim the unchanged 540-word description below 500 words.

Tests - (1/3) Weak
The v12 JUnit fallback did not resolve the previous issue: compile failure rollouts still produce only “tests were missing from the JUnit XML,” with the compiler diagnostics confined to test-log.txt. Add coverage for a value-only consumer, required auxiliary attributes, boxed scalars, colliding attribute tags, and existing same-signature methods.

Solution & Code - (1/3) Weak
The reference has several reproduced correctness and compatibility failures: required auxiliary values cannot be read, boxed scalar attributes and colliding names lose the binary API, a pre-existing final writeTo(DataOutput) causes generated Java not to compile, and ordinary value consumers receive no binary methods. Fix those cases and avoid exposing BinaryWire as an unrequested public helper unless it becomes an explicit API.

---

## v13 — Ishaan S — approved — 2026-07-20 01:40

Quality score: 7

Problem Description - (3/3) Clean

Tests - (3/3) Clean

Solution & Code - (3/3) Clean
