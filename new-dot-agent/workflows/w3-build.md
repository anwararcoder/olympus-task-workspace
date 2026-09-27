# W3 — Build the Full Deliverables

**Input:** a W2 GO (slice + observed rollout divergences). **Output:** the five deliverables (naming:
`templates/artifact-structure.md`). **Rules:** `rules/test-writing.md`, `rules/solution-writing.md`,
`rules/description-writing.md`. **Templates (copy these):** `templates/test-sh.md`,
`templates/dockerfile.md`, `templates/patch-and-verify.md`.

0. **Isolation:** never touch the shared `repos/{repo}` clone — `WORK=$(mktemp -d); git clone
   --no-local repos/{repo} $WORK/{repo}` at the recorded BASE_COMMIT (full commands in
   `templates/patch-and-verify.md`). One heavy build at a time; record toolchain mechanics in the
   repo knowledge file.
1. **Tests first, top-down by score geometry** (`test-writing.md` §1): the lifecycle scenarios
   that route through the core, then the attributable edges, then the distractor fixtures —
   including a fixture for every divergence W2's rollouts actually exhibited. Seam-legality audit
   on every observable BEFORE writing assertions. Dump-then-assert for all expected values.
2. **Description** aligned with the tests (clause↔test trace both directions), persona self-audit
   (`description-writing.md`).
3. **Solution** grown from the Gate-B/W2 spike, repo-faithful (`solution-writing.md`).
4. **Ablation pass:** prove fork independence (one injected bug → exactly one fork fails).
5. **Patches** via the exact commands in `templates/patch-and-verify.md` (generate disjoint test/
   solution patches; verify `new file mode 100755`; SAFETY-DIFF against the predecessor; the Windows
   UTF-16 BOM trap; no forbidden files in the task dir).
6. **Dockerfile** per `templates/dockerfile.md` (matching `olympus-base-*`, offline deps cached, no
   `RUN <test>`, JDK/Go pinned per the repo knowledge file). Build it; run test.sh inside it.
7. **test.sh** per `templates/test-sh.md` (`base`/`new` modes, JUnit XML to `--output_path`).

Done when: all five deliverables exist, patches apply clean on fresh base, and W4 verification has
not yet been run (that is the next, separate gate — do not self-certify).
