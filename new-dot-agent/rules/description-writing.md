# Description Writing — outcomes, load-bearing clauses, and the clarity trap

Exact format (the platform parses the header block):
```markdown
Language: go
Difficulty: hard
Type: feature_request

# Feature Title (3-6 words)

Add ... [behavioral prose, flowing — NO "## Description"/"## Test Assumptions" sub-headers]
```
ASCII only. No internal class/file names, no mechanism hints. Length is whatever fairness requires —
every clause must be load-bearing (move-class is 528 words, endorsed because each requirement makes
a hidden test fair). Length does NOT predict pass rate; clarity and structure do.

## The two failure modes (you must steer between them — both are measured)

**Over-clarity (the difficulty killer).** A clause that hands over a decision the agent was
supposed to DISCOVER converts difficulty into reading comprehension. call-hierarchy enumerated
"field initializer attribution, JDK callee zero-ranges" → strong agents implemented everything →
7/10, then 3/3=1.0 rollouts. For each clause ask: *"is this a fairness ANCHOR (a contract the
tests need stated) or a TELEGRAPH (a design decision the repo/tests already signal)?"* Keep
anchors; cut telegraphs. The difficulty must live in EXECUTING the contract, never in guessing it.

**Ambiguity (the fairness killer).** A clause two reasonable engineers read differently is a
defect, not difficulty. One misleading word blocks a submission (atom-media's "still take
precedence" implied pre-existing behavior; flagged "more ambiguity than genuine hardness").
Negative or relative definitions get judged ambiguous ("split from surrounding punctuation");
define text contracts POSITIVELY (token = a run of letters and digits). If a specific approach is
truly required for the tests to pass, the prompt must say so.

The stable target: **"100% clear, brutally hard to execute."** Say WHAT, completely and
unambiguously; never HOW. If clarity makes it easy, the idea was a READ/leaf — that is an
idea-selection failure (`rules/task-shape.md`), not a wording problem to solve with vagueness.
De-telegraphing a principle ("a name that appears where a type would be written...") is legitimate
ONLY when every instance stays inferable — and know that thorough agents reconstruct such
principles instantly, so it buys fairness-safe difficulty only against weaker tiers.

## Hard rules

- Write as an upstream feature specification. Do not mention the benchmark, program, solver,
  grader, difficulty tier, task, challenge, hidden suite, or submission process.
- State observable OUTCOMES: inputs, outputs, errors, persisted effects. Exact strings only for
  contracts the tests assert exactly (and then quote them in the description verbatim).
- Never imply pre-existing behavior that doesn't exist at base ("still", "continues to", "also
  honor" require the base to already do something — verify against base before using such words).
- **Degenerate fixture values must have stated semantics.** If a test exercises BlockSize=0, an
  empty list, a zero window — the description (not the hidden test) must make the rule for that
  case derivable. carve's hidden BlockSize=0 rule cost a round.
- Partial enumeration implies exhaustiveness. "such as X and Y" keeps inference open; "X, Y, and
  Z" closes the set — if the tests exercise W too, that is unfair.
- Every planned test must trace to a clause (explicit or honestly inferable). Audit
  bidirectionally before any submission: clause→test and test→clause.
- Hints (allowed per `rules/platform-bar.md`): one sentence, behavior-only, no file/function
  names, justified as inferable. A hint is a rescue lever for a 0% castor batch, not a design tool.

## Contract-locking (match assertion type to wording — mismatch is flagged)
- Tests assert an EXACT string → state that exact format in the description (verbatim).
- Tests assert CONTAINMENT → describe the required marker, keep surrounding wording flexible.
- Never mix: description implies "contains" while tests enforce exact on the same path.
- Restate a repeated error contract once ("the same constraint applies"), not per case.

## Recurring specific mistakes (each cost a real round)
- **Static-vs-dynamic framing:** extending behavior → word it so only the NEW path changed
  ("non-literal defaults are now evaluated at call time", not "defaults are now...").
- **Shadowing vs leaking:** these differ — "may shadow within the block but must not leak" is a
  precise, testable distinction; vague wording trips alignment checks.
- **Framing as external:** write from inside the project; don't open with "X currently supports Y
  but lacks Z".
- **Instruction-style / TODO-list prose:** it should read as a spec, not numbered tasks.
- **Restating existing repo behavior:** stating de-facto expectations (backward-compat, "finally
  runs first") only reduces difficulty and trips conciseness — state it only for NEW exit paths.

## A passing example (tengo-destructuring — calibrate tone/length to this)
```markdown
Language: go
Difficulty: hard
Type: feature_request

# Destructuring Bindings

Add destructuring bindings with `:=`.

Array patterns bind by position. Map patterns bind by key, including shorthand `{x}` and renaming
`{x: a}` (with optional defaults like `{x: a = 50}`). The same pattern forms are valid in function
parameters. Nested array/map patterns are supported. Rest elements (`...name`) collect remaining
array elements and must appear last; rest is not supported in map patterns. Default values
(`name = expr`) evaluate lazily and apply only when a position or key does not exist; defaults may
reference bindings established earlier in the same operation. Positions beyond an array's length and
absent map keys bind undefined. Only `:=` triggers destructuring; `=` is invalid. Compile-time
errors must include these substrings: `rest element must be last`, `cannot use destructuring with =`.
```

## Self-audit before any submission

Read the description as three personas: (1) a strong agent — what would it build first; does any
clause hand over a fork? (2) a fairness judge — could two faithful implementations diverge on any
clause? (3) the human reviewer — does any word claim base behavior that isn't there? Fix every
hit, then re-run the clause↔test trace.
