# seam-legality-or-0-of-34

**A feature whose natural home is a daemon/async path, or whose correct decision is not
discoverable from the description + public API, reads as a uniform 0% failure — and description/
hint levers cannot fix it. Execute the discoverability proof per fork; never just declare it.**

## Evidence (as of 2026-06-10)
- `osctrl-carve-integrity` v1: reclamation was specified as a background daemon sweep; 34/34
  agents built it correctly IN THE DAEMON — which a base-symbols-only test cannot drive — and
  0/34 passed. ~8 days were then spent on description/hint levers chasing what was a test-seam
  fault, not difficulty. The plan had a "base-legal seam proof" section that was declared
  satisfied but never actually executed for this fork.
- The grafted fix (an artificial operator endpoint) carried fairness ambiguity for months.
- Signature to recognize: >50% of failing runs share ONE root cause = ambiguity/seam fault until
  proven otherwise (the platform's own guidance says the same).

## Applies at
W0 testability check per seam, W1 per-fork discoverability proofs, W5 §1 (uniform-failure row).

## Rule it shaped
`rules/repo-selection.md` §3, `rules/idea-crafting.md` "Discoverability proof",
`rules/test-writing.md` §2, `rules/task-shape.md` anti-pattern (f).
