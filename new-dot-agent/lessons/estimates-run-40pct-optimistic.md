# estimates-run-40pct-optimistic

**Plan-stage LoC and difficulty estimates run ~40% optimistic. MEASURE the hardest fork by
building it in a throwaway worktree before freezing any plan; an unmeasured number is fiction.**

## Evidence (as of 2026-06-11)
- `java-encapsulate-field`: 8 genuinely independent forks, plan estimated ~850 non-empty LoC;
  the honest build came out at **451** — each fork was a 10-30-line branch the JDK's primitives
  make trivial once recognized. Recognition-hard but implementation-thin.
- `osctrl-carve-integrity`: "hard to balance, simple to implement" — the effective solution was
  ~341 LoC and hit the auto-review size floor, forcing a late scope addition (CLI surface).
- Counter-example showing the cure works: `jte-precompile-maintenance` Gate B (2026-06-11)
  measured the spike at 124 effective LoC and honestly projected 450-650 — BELOW the bar — which
  forced the deepening decision BEFORE the build instead of after it.
- The cure for thinness is never padding: it is a single stated CONSTRAINT that forces a real
  algorithm (the codeforces principle).

## Applies at
W1 Gate B (validation spike) and the W3 re-measure.

## Rule it shaped
`rules/idea-crafting.md` Gate B, `rules/task-shape.md` kill questions 8-9.
