# Description Review Guide

Review as a human maintainer. Focus on WHAT is required, not HOW. Assign a rating from 1-7.

---

## Auto-Reject (Rate 1 and stop)

- Duplicate or already publicly solved (checked manually)
- Invalid repo: inactive, < 500 stars, bad commit hash (checked manually)
- Unsupported language or non-permissive license (checked manually)
- Plagiarized or AI-generated
- Invalid UTF-8 or unreadable
- Out of scope (trivial, repo-wide refactor, pure docs)
- Violates core submission rules

---

## Quality Criteria

**Clarity** - Problem and expected outcome are immediately obvious. No formatting or language barriers. Structure should emerge naturally from the content — don't force rigid sections with titles like "Goal", "Expected Behavior", "Test Assumptions". If the problem needs two paragraphs, use two paragraphs. If a short list helps, use one. The description should read like a real issue a maintainer would write, not a template.

**Formatting** - Markdown renders correctly. Bullet lists, headers, and code blocks must actually display as intended — not collapse into a wall of text. Common failure: the author writes `-` bullets without blank lines or proper line breaks, so all items fuse into a single unreadable paragraph. If the description *attempts* structured formatting but the markdown is malformed, it fails this criterion regardless of how good the content is. Verify by checking that list items, paragraphs, and sections are visually distinct and properly separated.

**Behavioral Focus** - Describes WHAT to build or fix, not HOW. The default framing is behavioral: specify the desired outcome and observable behavior. Implementation hints (file paths, algorithm guidance, architectural direction) are acceptable only when the behavior alone would be ambiguous or insufficient to solve the problem — not as the default approach. Descriptions that give away the solution (e.g., "add a check for X if Y occurs") tell the solver exactly where to look and are too prescriptive unless the behavior is genuinely non-obvious without that guidance.
- **Critical:** If the description includes any implementation hint, verify it is **accurate**. A hint that contradicts the tests or the actual correct approach will misdirect solvers and cause the problem to be reverted. If a hint points to the wrong file, wrong pattern, or wrong approach — flag it or remove it. A wrong hint is worse than no hint.

**Determinism** - A developer can implement correct behavior from the description alone. Success criteria are testable. Ambiguity only where multiple valid implementations exist.

**Framework Integration Constraints** - When the feature involves framework-level patterns (command composition, middleware chaining, event handling), the description must specify any constraints on HOW commands/operations are composed if the test harness requires a specific approach. If the existing codebase uses a dominant pattern (e.g., `tea.Sequence` in Bubble Tea, promise chaining, middleware wrapping) but the tests require a different pattern (e.g., returning bare commands whose results flow through the message handler), the description must make this clear. A description that says nothing about command composition while the tests silently reject the codebase's own pattern creates an unfair hidden constraint.

**Standard Library Semantic Clarity** - When the feature wraps standard-library operations that have well-documented behavior, the description must explicitly state any deviations from that behavior. Common cases:
- If batch-delete should treat nonexistent paths as errors, say so — because `os.RemoveAll` (Go), `rm -rf` (shell), `shutil.rmtree` (Python) return success for nonexistent paths by default.
- If ordering matters, specify the ordering — because OS directory listings, map iterations, and set iterations are not guaranteed to be ordered.
- If empty input should be an error vs a no-op, say so — because both are valid default behaviors.
Without explicit specification, a solver using the standard library's documented semantics writes correct code.

**Conciseness** - ~500 words max unless justified. No narrative, filler, or repeated requirements. Reads like a real GitHub issue. Prefer plain English over code snippets when describing behavior (e.g., "model updates and deletes should ..." instead of "`model.update()` and `model.delete()` should ..."). Use code references only when the exact identifier matters or plain English would be ambiguous.

**No Redundancy** - No restating repo defaults, obvious conventions, or guaranteed behavior. No "maintain backward compatibility" unless behavior actually changes. Don't list discoverable repo details (behavioral or implementation) — if the solver can find it by reading the code, it doesn't need to be in the description unless the detail is essential to understanding the problem.

**Human Wording** - Sounds human-written. No AI slop — watch for hedging phrases ("It's important to note that...", "This ensures that..."), over-formal tone, excessive qualifiers, or unnaturally thorough coverage of edge cases that no human would bother spelling out. No NOTE/TODO markers, robotic phrasing, or references to tests/tooling. The description should not frame the repo as external (e.g., "LangChain currently supports X but lacks Y...") — write as a maintainer, not an outside observer.

**Natural Tone** - The description should flow naturally, not read like a bullet-point checklist of requirements or a rapid-fire list of instructions. Multiple related behaviors should be woven together in prose where possible. If the description reads like a specification table converted to sentences, it needs rewriting.

**Proper Scope** - Realistic work, not trivial or repo-wide. Does not leak the solution. Multiple implementations possible.

**Repo Philosophy Alignment** - The described feature or change fits the repository's existing design philosophy, patterns, and conventions. A feature can be "in scope" but still misaligned — e.g., adding business logic to a hooks-only framework, or OOP patterns to a functional library. The description should propose work that a real maintainer would plausibly accept.

---

## Red Flags


- **Broken formatting / wall of text**: the description attempts to use markdown structure (bullets, headers, numbered lists) but the syntax is malformed — e.g., `-` list items without proper line breaks, so all bullets collapse into a single dense paragraph. The content may be technically present but is unreadable. If the rendered output is a wall of text, flag it regardless of content quality.
- **External framing**: the description reads as if written by an outsider describing the repo (e.g., "LangChain currently supports X but lacks Y...", "The library provides..."). Descriptions should read like an internal maintainer writing an issue — the author is *inside* the project.
- **Listicle / instruction-list style**: the description is a rapid-fire list of bullet points or numbered demands rather than natural prose. It reads like a spec sheet, not a problem description. Each sentence feels like a standalone requirement with no connective flow.
- **Unnecessary code snippets**: the description uses inline code for identifiers when plain English would be clearer and more natural (e.g., "`model.update()` and `model.delete()` should..." instead of "model updates and deletes should..."). Code references are fine when the exact name matters; flag when they're used as a crutch.
- **Over-specified discoverable details**: the description restates implementation details or behavioral facts that the solver would trivially discover by reading the codebase. Only flag when the detail adds no value — some context-setting is acceptable.
- **Overly prescriptive / solution leakage**: description tells the solver exactly how to implement instead of describing the desired behavior (e.g., "add a check for X if Y occurs" instead of describing the observable problem). Prescriptive descriptions reduce the challenge to mechanical transcription. Flag unless the behavior is genuinely non-obvious without implementation guidance.
- **Misleading implementation instruction**: description tells solver to do X (e.g., "add a tag constant to file Y"), but doing X would actually break existing behavior or fail tests. The correct solution uses a different approach entirely. This is a revert-worthy issue — if following the description's own instructions produces a broken result, the description is defective.
- Task is unclear without tests (insufficient)
- Undefined terms used without context
- Unrelated behaviors bundled in one paragraph
- No indication of what triggers the issue
- **Missing composition constraints**: the feature involves framework-level command/operation composition (Bubble Tea commands, Express middleware, React hooks), the codebase has a dominant pattern for this, but the description says nothing about which composition pattern to use. If the test harness can only handle one specific approach, this omission creates a hidden trap.
- **Ambiguous standard-library semantics**: the description specifies a function signature (e.g., `BatchDelete(paths []string) (int, []error)`) but does not state the error semantics for edge cases where the standard library has a well-defined behavior that differs from what the tests assume (e.g., `os.RemoveAll` returns nil for nonexistent paths, but tests expect an error). The description must disambiguate.

---

## Rating Scale

| Rating | Label | Criteria |
|--------|-------|----------|
| **1** | **Rejected** | Duplicate, invalid scope, or violates submission rules. |
| **2** | **Fundamentally Broken** | Missing key requirements or major conceptual confusion. |
| **3** | **Major Quality Issues** | Ambiguities, incomplete requirements, clear test misalignment. |
| **4** | **Borderline** | Noticeable ambiguity, structural awkwardness, or partial test misalignment. Needs clarification. |
| **5** | **Good (Approvable)** | Clear and complete but somewhat verbose or structurally imperfect. Tight test alignment. |
| **6** | **Strong** | Extremely clear. Only minor verbosity or phrasing improvements possible. Tight test alignment. |
| **7** | **Exceptional** | Fully deterministic, zero ambiguity, concise, perfectly test-aligned, clean structure. |

- 1-3: Do not approve
- 4: Request revisions
- 5-7: Approvable (5 is minimum)

---

## ⚠️ Cross-Check: Description vs Tests

If the description contains ANY implementation hints (file names, specific constructs to add, architectural guidance):

1. Read the tests and verify that following the description's instruction would actually produce code that passes all tests
2. Check that the instruction doesn't conflict with existing behavior the tests expect to preserve (e.g., type guards, instanceof checks, existing APIs)
3. If following the instruction would break tests or existing behavior → flag as **misleading implementation instruction** and require removal or rewrite

A description that misdirects a solver into a broken implementation is worse than one that gives no implementation hints at all.

---

## Output

Write in `Feedback.md`:

```
## Rating: [N] - [Label]

## Issues Found
- [Each issue: Missing / Ambiguous / Redundant / Test misalignment / Red flag]

## Summary
[1-3 sentences on why this rating was given]
```

Rules: Be specific, reference exact phrases, don't invent issues, don't suggest implementations, keep it concise.
