# Binary Serialization - next plan (v16 checkpoint -> final contract alignment)

> This file is the post-checkpoint execution contract. After the v16 commit and tag, execute it
> without rewriting this plan or `commit-message.txt`; the resulting submission artifacts stay
> uncommitted.

## Exact current state

Two states must not be conflated:

1. The platform-exported snapshot in `Compact-binary-form-for/` contains the v16 constructor
   scalar-evolution/collision close. It produced 2/10 passing runs and all current platform
   reports.
2. The top-level task files additionally contain the unsubmitted v17 advisory close: a middle
   unknown builder field, constructor missing list/map/optional values, and constructor collection
   element/map-key mismatches. Those additions have not yet been platform-evaluated.

The solution patch is unchanged from v9. Its constructor eligibility gate declines a type when
the count of stored non-auxiliary attributes differs from the generated constructor arguments.
That makes `BinCtorDefaulted` safe but API-free. Nova #2 instead generates the API, serializes the
defaulted non-parameter `size`, then discards the decoded value and recreates the object with
`of(key)`. Nova #8 safely declines the shape.

Current external results:

- AI evaluation: PASS, 20% (2/10).
- False-positive review: FAILED, one confirmed false positive and one genuine pass.
- Auto-review: revision requested; description 2, tests 1, solution 0, agents 3.
- Test fairness: PASS; plagiarism/distinctness: PASS.
- Focused suite: 38 methods.

## Root cause and decision

The blocker is a contract-test-golden mismatch, not insufficient general difficulty:

| Layer | Current behavior | Defect |
|---|---|---|
| Description | Says constructor-built scalar attributes receive the form and broadly inherit default behavior | Requires `BinCtorDefaulted` |
| Test | Checks the API pair conditionally and round-trips only `of("k")` | A lossy API passes because 7 becomes 7 |
| Golden | Declines the shape | Contradicts the broad description |
| Nova #2 | Generates a lossy form | Confirmed false positive |
| Nova #8 | Safely declines | Genuine under the all-or-nothing rule |

Do **not** add constructor-default support to the golden in this iteration. Requiring it would
reject both historical passers and predict a 0/10 replay. Instead, make the intended constructor
surface explicit: required constructor support covers stored non-auxiliary attributes that are
constructor parameters. A type with an additional defaulted stored attribute may safely receive
neither method; if a solver elects to generate the form, it must preserve every value.

This is a legitimate scope boundary, not a loophole. Constructor-only values with scalar, enum,
optional, list, set, and map parameters remain required and are deeply tested across round-trip,
missing, mismatch, unknown-field, and collision behavior. The only relaxed claim is a shape the
golden has always intentionally declined.

## Phase B changes

### B1 - align constructor eligibility prose to the golden

In the supported-shapes paragraph, replace the broad constructor sentence with behavior
equivalent to:

> Constructor-built values receive the form when every stored non-auxiliary attribute is a
> constructor parameter and those parameters are scalars, enums, optionals, lists, sets, or maps.

Keep the universal all-or-nothing sentence: an implementation that cannot serialize a value
faithfully must emit neither method. Keep the constructor evolution sentence, but read it within
the newly explicit supported surface. The existing constructor evolution fixtures all consist of
constructor parameters, so no test or promised behavior is lost.

### B2 - close the exact false-positive discriminator

In `constructorBuiltValueWithVariedShapesRoundTrips`, preserve the either/or API check for
`ImmutableBinCtorDefaulted`, then strengthen the present branch:

1. Round-trip the default `ImmutableBinCtorDefaulted.of("k")` value.
2. Create `defaulted.withSize(19)` and require that non-default value to round-trip unchanged.

This is the panel's reproduced discriminator. It is fair under both allowed outcomes:

- no API: golden and Nova #8 pass safely;
- API present: every stored value must round-trip, so Nova #2 fails.

Do not make method presence unconditional; that would contradict B1 and eliminate the genuine
passer for no additional corruption protection.

### B3 - remove low-level tag derivation prescription

Rewrite the wire paragraph around observable behavior:

- attributes match by stable per-attribute tags rather than declaration order;
- renaming an attribute does not make it match by position;
- distinct attributes remain distinguishable, and collisions either resolve safely or disable
  the form;
- framing skips unknown fields without desynchronizing later known fields.

Do not require how a tag is derived. This resolves the auto-review P6 issue while retaining every
existing rename, reorder, collision, and middle-unknown-field assertion.

### B4 - retain the unsubmitted v17 matrix close

Keep all current top-level additions:

- `BinEvoMid` and the later-known-field assertion after an unknown middle field;
- `BinCtorEvoD`/`BinCtorEvoE`;
- constructor missing list/map/optional defaults;
- constructor collection-element and map-key mismatch defaults;
- constructor scalar missing/mismatch, forward skip, and tag collision cells from v16.

These close the current precheck and auto-review coverage suggestions without adding test methods
or new prose obligations.

## Predicted replay

| Historical passer | Final expected result | Evidence |
|---|---|---|
| Nova #2 | FAIL | Generated read decodes `sizeBinaryValue` but returns `of(keyBinaryValue)`; panel reproduced 19 -> 7 |
| Nova #8 | PASS | Eligibility declines constructor types with settable-after-construction attributes; panel already accepted the safe decline |
| Golden | PASS | Existing constructor-argument-count gate declines `BinCtorDefaulted`; all required constructor-parameter evolution cells use initialized locals |

Expected historical replay: 1/10 (10%). This preserves a nonzero, <=40% pass rate while removing
the only confirmed false-positive passer. The other eight runs already fail clean full-reactor
generation for concrete implementation defects unrelated to this change.

## Execution and verification

1. Apply B1-B3 only to the top-level description and test patch; leave the solution patch and
   immutable `binary-serialization-plan.md` unchanged.
2. Inspect the delta against v16: one constructor boundary edit, one tag-language edit, and one
   non-default round-trip assertion; retain all B4 additions.
3. Run light local gates:
   - `git apply --check --whitespace=error` for test and solution patches on the exact base;
   - `bash -n` for the patched `test.sh`;
   - focused method count remains 38;
   - no forbidden markers, non-ASCII drift, overlapping test/solution writes, or mode loss.
4. Statistically replay the discriminator against the golden, Nova #2, and Nova #8 using their
   eligibility and generated reconstruction paths.
5. Because B4 has not yet been platform-evaluated, run one isolated four-state remote verification
   (`base+tests` fail, `base` pass, `solution` pass, `solution+tests` pass) if a forge account is
   available. Do not run parallel full builds or touch another agent's namespace.
6. Record verification evidence only in the ordinary submission artifacts that require it. Do not
   rewrite this plan or `commit-message.txt` after the checkpoint.

## Submission gate

The task is ready to submit when the exact discriminator is present, the description matches the
golden boundary, all light gates pass, and the isolated four-state run is green (or, if remote
verification is unavailable, the handoff explicitly distinguishes local readiness from the
remaining external gate). The final artifact changes must remain uncommitted on top of tag v16.
