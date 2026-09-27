# W0 — Select Repo

**Input:** candidate GitHub repos (owner supplies or agent searches). **Output:**
`my-work/_repos/{repo}-dossier.md` per candidate + a ranked verdict. **Rule:**
`rules/repo-selection.md`.

1. Hygiene screen (fast, kill cheaply): license, ~500-5000 stars, activity, real test dirs.
   Drop the maintainer-count heuristic; drop giant-org repos (public-discussion/duplicate risk).
2. Clone each survivor; build and run the FULL test suite twice in a clean offline container.
   Record: toolchain pins, build time, flaky tests + skip recipe, network needs. A repo that
   cannot run offline-deterministic is OUT now — this failure discovered later costs a task.
3. **Seam inventory** (the real work): enumerate candidate feature seams; classify each
   READ / EDIT / STATE (`rules/task-shape.md` §1); for each non-READ seam run the 3-question
   testability check (synchronous base-named entry point? base-readable observable?
   base-symbols-only test compiles on base, fails at runtime?).
4. Verdict: repo is eligible only with **≥2 surviving STATE or cascade-EDIT seams**. Write the
   dossier (template in the rule). Rank candidates by surviving-seam quality, not star count.
5. Maintain the portfolio: 2-3 eligible repos at dossier level; ideas compete across repos. When a
   repo's seams are exhausted, write RETIRED in its dossier with the reason — never mine a retired
   repo for weaker ideas.

Done when: the owner has dossiers with ranked seams and picks where W1 starts.
