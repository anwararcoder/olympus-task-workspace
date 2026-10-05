# Previous Reviews

## v1 — Shipd Bot (Auto Review) — approved — 2026-07-31 18:07

Quality score: 6

Problem Description - (3/3) Clean

Tests - (2/3) Minor
The suite strongly covers the retention semantics with AST-level assertions, recompilation and behavioral checks, default-disabled behavior, reconstruction/removal interactions, all requested member categories, nested scopes, transitive dependencies, dead omitted code, non-code text, and deterministic round trips. The verified bounded omission is public option registration: the tests use the option as a raw string but do not assert that DecompilerOption.getAll() exposes it with boolean metadata and default 0, so an implementation could satisfy these tests without properly registering the user-facing option.

Solution & Code - (3/3) Clean

Other notes:

The task showed healthy difficulty rather than unfairness: one agent completed it, while seventeen substantive attempts preserved baseline behavior and reached 11 of 13 new tests before converging on the same inheritance-resolution mistake—matching the token's apparent Child owner directly instead of resolving the generated declaration on Parent. The description already defines references in ordinary emitted-Java terms, and superclass/interface information is available in the repository, so this is a benign implementation blind spot rather than a missing requirement. No leakage, overlap, publicly shipped fix, environment blocker, or contested-run discrepancy was reported.
