# Previous Reviews

## v1 — Forbidden Murk — revision_requested — 2026-07-28 08:35

Quality score: 5

Problem Description - (2/3) Minor
The description is dense and templated, making it read more like a generated specification than a maintainer request. Consider rewriting it in a more natural issue voice without changing any behavioral requirements. Change the internal resolution/invalidation wording into guarantees about deterministic source selection, family coherence, caching, reload behavior, and output ownership.

Tests - (1/3) Weak
* Add a real concurrent-lookup test for the deterministic-resolution guarantee. Register differing duplicate candidates, run `getClass(DUPLICATE)` / `hasClass(DUPLICATE)` concurrently from multiple threads, and assert a single stable winner, exactly one warning, and stable probe counts such as `classReads`. The concurrency guarantee currently has no discriminating coverage.
* Add a deferred-registration test. After `addSpace` registers two differing own duplicates, or an error-strategy conflict, assert that no warning has been emitted and the sources have not been read before the first `getClass` / `getOwnClasses` request. Then verify that resolution triggers the expected warnings and reads. This directly covers the requirement that registration records candidates without resolving them.

Solution & Code - (3/3) Clean

---

## v2 — Forbidden Murk — approved — 2026-07-29 13:00

Quality score: 6

Problem Description - (3/3) Clean

Tests - (2/3) Minor
coverage for duplicate resolution after `reloadContext()`. Resolve a differing duplicate, reload the context, resolve it again, and assert exactly one new warning is emitted after the reload while repeated post-reload lookups emit no additional warnings.

Solution & Code - (3/3) Clean

---

## Manager — Leonard Tng — approve — 2026-07-29 21:35

(affects score, previous status: finalizing_review)
