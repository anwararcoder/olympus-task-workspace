# context-aware-escaping is ceiling-bound AND volume-thin (a well-known-spec confirmation, n=2)

**Automatic context-aware output escaping (HTML/URL/CSS/JS) is a KILL for Diamond and fails an
800-LoC floor, for the same two reasons every time: (1) the escaping RULES are a published standard
(OWASP / contextual auto-escaping) the model recalls, and a FAIR description must state them; (2)
the CONTEXT is already resolved by the template engine's parser, so threading it is a few lines per
layer. Both halves are ceiling-bound; together they are also thin.**

## Evidence (2026-06-28, jte-url-css-escaping, W2 KILL at slice cost)

The idea: add URL + CSS contexts to jte's 4-escaper HTML auto-escaper. The plan's deepener — the
"derive-not-recall corner" — was that CSS SUB-contexts (`url(...)` vs CSS string vs bare value) are
UNREACHABLE at runtime (jte's escaper sees only the interpolated value, never the surrounding
template text), so they FORCE a compile-time extension of the parser lexer + the `setContext`
protocol + BOTH code generators. On paper this looked like jte-signature, non-recallable machinery.

W2 refuted it on both gates:
- **Gate C (ceiling): FAIL.** A fresh ZERO-CONTEXT agent (draft description + repo only) built the
  FULL contract in **~19 minutes**, INCLUDING the sub-context threading: it independently split
  runtime URL-attr routing from compile-time CSS sub-context, extended `setContext` with an additive
  default method (the exact backward-compatible design the planner derived), reused the parser's
  existing `stringLiteralQuote` state + a backward `url(` scan, preserved the `&amp;` composition and
  the 3 `javascript:` base tests, and did Kotlin parity. HIGH confidence on 4/6 areas; MEDIUM only on
  url()-heuristic robustness (a 1-2-test edge, never a cascade). Same fingerprint as
  `well-known-spec-features-are-ceiling-bound` (http-cache) and `famous-refactoring-ceiling-survives-
  the-moat` (extract-method/delegation): the description states the contract -> the agent
  reconstructs the threading no matter how subtle.
- **Gate B (volume): FAIL.** A four-state-green slice (URL attr + CSS coarse + url() sub-context +
  buffered Content; 9/9 new pass, 166/166 existing pass) measured **155 non-empty LoC**; the
  gauntlet's fuller build measured **297**. vs a >800 floor. Escaping is per-char tables + branching,
  and the engine already resolves the context — the threading collapses to a few lines per layer
  (`state-shape-predicts-cascade-not-volume`, `estimates-run-40pct-optimistic`: plan projected
  620-810, honest build ~150-300).

## Why no fair deepen escapes it (the structural argument)

The only rescue for a well-known-spec core is a derive-not-recall corner whose TRIGGER need not be
stated to be fair (`famous-refactoring-ceiling-survives-the-moat`). **Escaping has none:** every
escaping behavior is a SECURITY contract, and omitting any of it is the ambiguity/fairness killer —
so the trigger is ALWAYS stated, and a thorough agent always reconstructs the mechanism. Threading a
"sub-context" is not a hidden trigger; it is an outcome ("a value in url() is treated as a URL") the
description must name. Deepening with more contexts (srcset, meta-refresh, quoted url() forms) adds
recalled surface = RAISES rollout scores; grafting owned state onto escaping draws fairness flags
(the carve pattern). Treat the entire "context-aware escaping / output-safety" vein as ceiling-bound;
do not mine it for Diamond.

## Selection screen (add to the kill questions)
For any "make the framework escape/format/validate X correctly for context Y" idea, ask BOTH:
1. Are the rules a published standard the model recalls? (escaping=yes -> telegraphs)
2. Is the CONTEXT already computed by the framework's parser/typer and merely consumed? (jte's
   `setContext`=yes -> the threading is thin AND READ-flavored)
If yes to either, it is ceiling-bound; if yes to both (escaping), it is also volume-thin. Kill at
W1, or at the W2 gauntlet before any platform spend.

## Applies at
W0 seam classification, W1 idea pre-screen + Gate C, W2 decision.

## Rule it shaped
Strengthens `well-known-spec-features-are-ceiling-bound` to n=2 and adds the "framework already
resolved the CONTEXT" (READ-flavor) second axis. Sibling of `read-features-hit-the-ceiling`,
`state-shape-predicts-cascade-not-volume`. `rules/task-shape.md` §1 STATE/READ caveats + §5 kill
questions (a new "escaping/formatting/context-consumption" entry).
