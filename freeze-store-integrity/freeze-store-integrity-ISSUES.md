# Solution & Code
1/3
Completed
Substantial, well-scoped implementation with broad passing coverage, but canonicalizing nonexistent targets conflates distinct names in both sharing and collision classification, causing repair to retain broken entries and skip a required safe move.

The solution touches four production Java files (`RuleDescriptionFileNames.java`, `RuleViolationFileNameStrategyFactory.java`, `StoreIntegrity.java`, and `TextFileBasedViolationStore.java`), one source documentation file, and its synchronized generated HTML rendering; it adds no solution-side tests or unrelated configuration. The production scope is substantive and generally follows repository patterns, and both configured checks pass (42 baseline and 145 new tests). End-to-end tracing nevertheless exposes one repeated classification mechanism that violates the stated distinction between identical recorded names and distinct names that reach an existing same file. `StoreIntegrity.namesDenotingOneFileTwice` canonicalizes names before establishing identity, even when the canonical target does not exist. Consequently, a direct missing name and a different dangling symlink to it are treated as shared rather than broken. The same helper is reused for derived-name collisions, so a safe absent destination and a distinct dangling-link destination aimed at it are treated as colliding; this prevents the safe misplaced entry from being moved even though only the dangling-link entry is occupied. These are concrete repair-mode failures on public initialization paths, not speculative lint concerns. The two instances are reported separately because they independently use the same faulty equivalence in recorded-name and derived-name classification.

Issues

S1 — broken/shared classification
High
verifySolution
Repair keeps two broken entries when one records an absent direct name and the other records a distinct dangling symlink to that absent path, because nonexistent canonical targets are treated as one shared file.

The suite separately proves that one dangling-link entry is broken and that exact duplicate missing names are shared, but it never combines a distinct dangling-link spelling with the absent target spelling. Thus all 145 tests pass while the distinction promised by the description is untested.

Expected: Because the entries record different names and no regular file exists for either name to reach, both entries should be classified as broken; `repair` should discard both mappings, while leaving the dangling link itself alone.

Failing case: Create `stored.rules` with `alpha=missing` and `beta=alias`, create `alias` as a symbolic link to the absent `missing`, then initialize with `default.integrity=repair`. Both mappings remain instead of being discarded.

Wrong impl caught: `namesDenotingOneFileTwice` uses canonical `File.equals` before `Files.isSameFile`, so it treats distinct names for a nonexistent target as shared even though there is no same regular file to reach.

Promise cited: “An entry is broken when its resolved path is not a regular file directly in the folder...” and “Entries recording the same name are shared, even if nothing exists under it. Entries whose names reach the same file are shared too...”

Load-bearing check: In the new `StoreIntegrity.classify`, `sharedNames` is built by `namesDenotingOneFileTwice(entries.values())`; that helper first applies `denotedFileOf`/`getCanonicalFile`, making `missing` and dangling `alias -> missing` equal, and `findingFor` returns `SHARED` before checking `isOwnedFile`. Without that nonexistent-target canonical equality, both entries reach the broken check and are discarded.

artifact_line: com.tngtech.archunit.library.freeze.FreezeStoreMaintenance_e448f3_Test::anEntryNamingADanglingLinkIsBroken()

S1 — misplaced/colliding classification
High
verifySolution
Repair can fail to move a safely misplaced entry when another rule derives a distinct dangling-link name aimed at the first rule's absent destination, because the two different derived names are incorrectly classified as colliding.

The tests cover a dangling derived name as occupied and exact same-name derivation as colliding in isolation, but not a safe derived destination combined with a distinct dangling-link derived destination. The current green suite therefore misses this composition.

Expected: The rule deriving the absent direct name should be classified as misplaced and moved there. The rule deriving the already-existing dangling-link name should be classified as occupied and left on its legacy file.

Failing case: Use a custom strategy that derives `safe` for rule A and `alias` for rule B; make `alias` a dangling symlink to absent `safe`, and give A and B separate nonempty legacy files. Initializing with `repair` leaves A on its legacy name instead of moving it to `safe`.

Wrong impl caught: The collision set represents canonical target identity, including nonexistent targets, rather than whether two rules actually derive the same name; it therefore lets an occupied dangling alias contaminate an independently safe move.

Promise cited: “Entries whose rules derive one name are colliding.” “A misplaced entry is occupied when its derived name already names something...” and “`repair` ... moves a misplaced entry's file to its derived name...”

Load-bearing check: `StoreIntegrity.classify` applies the same `namesDenotingOneFileTwice` helper to `derivedNames.values()`. Canonicalization equates absent `safe` with dangling `alias -> safe`, and `findingFor` checks `collidingNames` before deciding whether each destination is misplaced or occupied. That early collision classification is exactly what suppresses A's required move.

artifact_line: com.tngtech.archunit.library.freeze.FreezeStoreMaintenance_e448f3_Test::aDerivedNameADanglingLinkOccupiesIsNotTakenOver()