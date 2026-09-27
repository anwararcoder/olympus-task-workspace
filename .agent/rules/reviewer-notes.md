---
description: Guidelines for when and how to use Reviewer Notes
---

# Reviewer Notes Rules

## Purpose

Reviewer Notes are a space to justify our approach for the human reviewer if they raise a point that we have strong justification for regarding the nature of the problem itself. They are communicated via Discord message to the reviewer — **not** as a section in the description file.

**Key Points:**
- Reviewer Notes are **NOT** a section in the description file
- They are sent to the human reviewer via Discord only when they raise a concern
- They justify design decisions that might seem unusual but are intentional
- They should be convincing and concise

## When To Use

1. **When a human reviewer raises a concern**: Justify why a tested behavior is correct
2. **Build tag questions**: Explain why tests need `//go:build` isolation
3. **Error format questions**: Justify testing specific error messages or patterns
4. **Test design questions**: Explain why certain tests exist (e.g., backward compatibility tests, regression tests)
5. **Omitted documentation concerns**: Explain why something is intentionally not in description

## When NOT To Use

- Don't preemptively add reviewer notes to the description file
- Don't provide implementation hints
- Don't summarize the description
- Don't add AI-style explanations

## How To Use

When a human reviewer raises a concern:

1. Evaluate whether the concern is valid (needs a fix) or justified (our approach is correct)
2. If justified, prepare a concise response explaining the reasoning
3. Send via Discord to the reviewer
4. Document in the human-reviews tracking file with status: **Justified**

## Common Justification Patterns

| Reviewer Concern | Justification Approach |
|------------------|----------------------|
| "Tests reference solution code" | Build tag isolates feature tests from base |
| "Exact error strings are brittle" | Error messages are part of user-facing contract; existing tests follow same pattern |
| "This test seems like a surprise" | Behavior is inferable from description clause X |
| "Why backward compatibility tests?" | Guards against parser regressions outside destructuring positions |

## Length Guideline

Keep each justification to 1-2 sentences. Be convincing, not verbose.
