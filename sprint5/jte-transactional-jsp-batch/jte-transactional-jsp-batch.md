Language: java
Difficulty: hard
Type: feature_request

# Transactional JSP Batch Migration

Add planned batch migration to both JSP converter artifacts. `JspToJteConverter.planTags(Collection<String>, Consumer<Converter>)` accepts a non-empty collection of root-relative `.tag` paths and returns a migration plan. `getConversionOrder()` and `getDeletes()` return normalized absolute `Path` values, while `getWrites()` maps normalized absolute paths to their final UTF-8 content. These collections are immutable.

Planning does not change the filesystem. It finds dependencies from parsed custom-tag invocations, including invocations in approved inlined includes; an approved include path is resolved against the converter's resource base and must resolve beneath the JSP root. JSP comments do not create dependencies. Parser setup, suppressions, and `getNotConvertedTags()` apply to every selected tag. Dependencies are converted before their dependents against a virtual view of earlier conversions: each step takes the lexically first root-relative path whose dependencies are already converted, so input order does not affect the plan. A cycle reports a deterministic closed path.

Planning rejects null or empty input, null or blank paths, normalized duplicates, absolute paths, paths outside the JSP root, non-`.tag` inputs, missing or non-regular inputs, selected symbolic links, approved includes outside the JSP root, ambiguous selected invocation names, colliding generated destinations, destinations outside the JTE root, and destinations whose path is already taken, including by a symbolic link; each of these is an `IllegalArgumentException`. Unresolved non-suppressed tags and parse, setup, or conversion failures also reject the whole plan, and a failure thrown by the parser setup consumer surfaces unchanged rather than wrapped.

The plan writes each generated JTE template and the final content of every affected `.jsp`, `.jsp.inc`, and `.tag` file under the JSP root, with a file that is rewritten several times represented once. It deletes every selected JSP tag; deleted files and unchanged scanned files are not writes. Each generated template uses the same parser setup and per-tag conversion rules as existing one-tag conversion.

Before its first mutation, `commit()` compares the content of every selected, included, and usage-scanned file with the planning snapshot and verifies that every generated destination is still absent. Timestamp equality does not make changed content current. Staleness throws `StaleJspMigrationPlanException`; `getChangedPaths()` returns all changed normalized absolute paths, each listed once, in lexical order, and no planned mutation occurs.

A successful plan commits only once. If an `IOException` occurs after mutation begins, commit restores every affected path, including directories it created, to its exact pre-commit bytes or absence before rethrowing the original failure. Failures during that restoration are attached as suppressed exceptions. Successful commits leave no temporary files, unrelated paths remain untouched, subclass hooks keep working, and the `javax` and Jakarta artifacts provide equivalent behavior.
