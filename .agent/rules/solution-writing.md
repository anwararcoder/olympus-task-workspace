---
trigger: always_on
description: Solution code standards ensuring human-style professional code
globs: "**/solution-*.patch"
---

# Solution Writing Rules

## Target Metrics

| Metric | Minimum | Ideal |
|--------|---------|-------|
| Lines changed | 700+ | 900-1200+ |
| Files modified | 6+ | 10-15+ |
| Components touched | 6+ | 8-10+ |

> **Note:** Numbers are guidance. Focus on comprehensive, professional solutions that compete with accepted work.

## Official Platform Requirements (S1-S4)

- **S1** meets every requirement in the description. A golden that misses a requirement yet passes the tests means the tests are also weak.
- **S2** no regressions, follows existing code patterns; the repo's existing tests still run.
- **S3** no irrelevant changes; leave unrelated code as it is.
- **S4** no AI-generated artifacts: weird comments, unexplained defensive code, new coding patterns.

Solution Quality (a platform check) reviews completeness and code quality against the repo and lists concrete issues; fix them before agent rollouts.

## Professional Developer Mindset

Act as a professional developer who:
- Solves problems from their roots, not with workarounds
- Eliminates naive implementations through solid architecture
- Creates code that a repo maintainer would accept
- Competes against other accepted work in quality and difficulty

## Multi-Layer Requirements

Solutions MUST require work across multiple architectural layers:

| Good Pattern | Bad Pattern |
|--------------|-------------|
| Parser → AST → Compiler → VM | Single helper function |
| Tokenizer → Parser → Analyzer | One method modification |
| API → Core → Storage → Output | Simple detection logic |

**Example from tengo-destructuring:**
- `parser/expr.go` - New AST nodes
- `parser/parser.go` - Parsing logic
- `parser/opcodes.go` - New opcodes
- `compiler.go` - Compilation logic
- `vm.go` - Runtime execution

## Human-Style Code

| AI Pattern (AVOID) | Human Pattern (USE) |
|--------------------|---------------------|
| Comments on every line | Code speaks for itself |
| Generic variable names | Domain-specific names |
| Over-abstraction | Direct implementation |
| Defensive everything | Appropriate error handling |
| Verbose explanations | Concise expressions |

## Code Rules

- NO comments (unless repo has them upstream)
- NO debug statements (print, log, console)
- NO removal of upstream comments
- NO AI slop (verbose, over-commented, or obviously auto-generated boilerplate)
- Match repo's exact coding style
- Use meaningful variable names
- Handle edge cases appropriately

## Questions To Ask

1. Does this look like repo maintainer's code?
2. Would a human write this during a 4-hour session?
3. Is every line necessary?
4. Am I adding redundant implementation?
5. Does this solve the root cause?

## When to Abandon

Stop and reconsider if:
- Solution touches only 1 file
- Core logic < 150 lines
- Can describe fix in one sentence
- No new data structures needed

## Anti-Patterns

**Don't add unrelated improvements:**
```go
// BAD: Adding helper function not needed for the feature
func formatErrorNicely(err error) string { ... }

// GOOD: Only code necessary for the feature
func compileDestructuring(c *Compiler, node *ArrayLit) { ... }
```

**Don't combine previously submitted work:**
```go
// BAD: Problem B includes functionality from submitted Problem A
// → Rejection: "overlapping functionality"

// GOOD: Each problem is entirely new, independent work
```

**Don't have inconsistent dispatch paths:**
```go
// BAD: Main path coerces, fallback path skips coercion
func tryGetHook(v, index) { coerce(index); call(method, index) }
func tryEmbeddedGetHook(v, index) { call(method, index) } // no coercion!

// GOOD: Both paths apply the same processing
func tryEmbeddedGetHook(v, index) { coerce(index); call(method, index) }
```

## Verification Checklist

- [ ] 700+ added lines (BARE MINIMUM floor — Diamond-tier target is higher; see "Diamond-Tier Sizing" below)
    - [ ] 6+ files modified (floor; Diamond targets 6-8+)
- [ ] No AI-style comments
- [ ] No AI slop
- [ ] No debug statements
- [ ] Matches repo style
- [ ] No redundant code
- [ ] No dead code (unused opcodes, handlers, constructors, or methods)
- [ ] Root-cause solution

## LOC Metrics

The official bar counts only the **effective solution**: the lines an agent must actually write to implement the task and pass the tests. Blank lines, comments, generated files, padding (such as reordering unrelated code), and all test code are excluded; improving tests never moves LOC. The numeric bar lives in the submission's criteria panel (see `my-review-workflow/rules/platform-panel.md` for the current value and the manager's exclusion list). If agents solve the task in noticeably fewer lines than the golden, the golden's real count is probably lower than it looks.

The panel's long-horizon row for agent runs reads raw diff lines (ADDED lines starting with `+`), which is why a green agent-LOC row does not clear the golden's effective-LOC check. Human reviewers may measure NET.

When agents restructure existing code (replacing infrastructure), they can have high ADDED but low NET. This is legitimate work, not low effort — look at the number of files modified and agent messages as supporting evidence.

### Diamond-Tier Sizing (read this before treating 700 as "done")

700 added lines is the BASELINE-Olympus floor, NOT the Diamond target. A solution that lands at ~700-750 non-empty sits in the zone `idea-crafting.md` explicitly flags as "borderline, too risky" (`craft-idea.md`: "700 exactly is too risky; aim for 800+"). For a Diamond submission, calibrate against `idea-crafting.md` "Solution Patch Size":

- **700-900+ non-empty lines** of GENUINE logic (the target; our accepted Java Diamonds run ~850-1200).
- **6-8+ files / 5+ architectural layers** touched — not for the file count itself, but because more layers force more INDEPENDENT decisions.
- **900+ TOTAL patch lines** (including hunks/context) is where our best problems sit.

Critical: you DO NOT close a size gap by padding. Adding edge-case tests or wrapper layers to inflate the diff is the Matchstick anti-pattern (`idea-crafting.md`: a documented v2 that "added 12 trap tests, caught zero agents"). The legitimate path to more lines is **more independent semantic forks** and **more genuine ripple into EXISTING subsystems** — i.e., depth, which then naturally produces the line count. If the honest implementation lands well under the target, the feature is under-scoped: deepen the idea (forks/layers), do not pad the code.
