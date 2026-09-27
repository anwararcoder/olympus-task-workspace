# Task directory — the file-naming contract

Each task lives under `my-work/{repo-name}-{problem-name}/`. Repo-level knowledge lives separately
in `my-work/repos-knowledge/`. Names matter — the platform and the QA audit key off some basenames.

## Repository-native deliverables

Every deliverable must read as material written for the upstream repository. Do not put benchmark
names, program names, difficulty-tier labels, solver language, grading language, or phrases such as
"this task" and "this challenge" in the description, patches, Dockerfile comments, helper names,
test targets, fixture names, output directories, diagnostics, or generated identifiers.

Use names derived from the repository behavior instead, such as
`duplicateClassResolutionTest` or `cacheRuntimeClasspathDependencies`. Ordinary technical terms
that belong to the repository or build tool remain valid; for example, Gradle's `tasks.register`
API is not meta framing. Required external coordinates are also exempt, including the approved
base-image repository used by `FROM`.

Plans, ledgers, downloaded reports, run traces, and reviewer notes are internal records. Never copy
their framing into a deliverable or present those records as upstream PR material. Before every
submission, scan the five deliverables as a class for prohibited framing; fixing one visible
identifier while leaving the same prefix elsewhere is incomplete.

| File / dir | Purpose |
|---|---|
| `{problem-name}-plan.md` | Immutable idea + plan from W1 (the empirical-gates evidence) |
| `{problem-name}-ledger.md` | Append-only event log (W0→W8); see `rules/documentation-ledger.md` |
| `{REPO}-{problem-name}.md` | The description (the deliverable) |
| `test-{problem-name}.patch` | Test patch (tests + fixtures + `test.sh`, `test.sh` = `new file mode 100755`) |
| `solution-{problem-name}.patch` | Reference solution (`src/main`-side only) |
| `Dockerfile-{problem-name}` | Build/test image (matching `olympus-base-*`) |
| `BASE_COMMIT-{problem-name}.txt` | Line 1: base commit SHA. Line 2: GitHub repo URL |
| `{problem-name}-auto-review.json` | Downloaded auto-review artifact, when available |
| `{problem-name}-agents-runs/` | Saved per-run artifacts from platform batches (below) |
| `{problem-name}-diamond-artifacts.md` | QA: env description + solution explanation + grouped test summary |
| `{problem-name}-QA/` | QA: per-run success/failure evaluations |
| `{problem-name}-ai-evaluation.md` | Optional cross-run evaluation |
| `{problem-name}-human-reviews.md` | Reviewer feedback + our point-by-point responses |
| `{problem-name}-next-plan.md` | Next-iteration strategy (with the lever ledger), when iterating |
| `commit-message.txt` | Transient side file for the commit-message workflow (Phase A) |
| `onboarding-doc.md` | Zero-context handoff snapshot, kept current across sessions |

Per-run artifact shape (basenames vary slightly; locate by wildcard):
```
{problem-name}-agents-runs/{problem-name}-agent-N/
    *-eval-result.json   *-trajectory.json|md   *-solution.patch
    *-junit-baseline.xml *-junit-new.xml        *-metadata.txt
```
