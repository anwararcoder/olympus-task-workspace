# ✅ False-Positive Review Report

> Passing runs must hold up under the false-positive review panel: each
> evaluated passing run is probed by a judge panel plus an adjudicator.

## Check Summary

- **Result:** `PASSED_WITH_WARNINGS`
- **Runs evaluated:** 1 — false positives: 0, genuine passes: 1
- **Requested:** 2026-10-17 17:54
- **Completed:** 2026-10-17 18:12
- **Token cost:** 8
- **Criterion status:** warn — Passed with caveats
  - The panel upheld the pass but flagged caveats — a dissenting judge, a run it couldn't review, or an inconclusive verdict. Not blocking; a reviewer may want to read the panel notes.

---

## Orion #11 — ✅ Genuine pass · high confidence

- **Run:** `rd7d6z0y6ekx7wczqe5g7tm8qs8gf365` | **Agent:** Orion | **Judge dissent:** Yes | **Panel duration:** 17m 28s

### Adjudicator — ✅ Genuine pass · high confidence

The candidate meets every behavior the prompt states, and the hidden suite passes when re-run. The only real difference from the reference is that repair rewrites stored.rules even when default.allowStoreUpdate=false. If that interaction matters, add it to the prompt (for example: 'repair requires allowStoreUpdate=true') and add a hidden test; as written, it is an unspecified design choice.

**Probe re-run reasoning:**

I re-ran the hidden verifier (test.sh new) on clean + candidate + test.patch: 46/46 passed. Judge-a found no fair discriminator; its two candidate-only failures (an unreadable file, and repair with allowStoreUpdate=false) cover behavior the prompt does not specify. Judge-c's single discriminator, repairDoesNotRewriteTheIndexWhenStoreUpdatesAreDisabled, does discriminate. I re-ran it: the candidate fails (index shrinks from 58 to 32 bytes) and the reference passes. But the probe is not fair. The prompt never mentions allowStoreUpdate and says without condition that 'When set to repair broken entries will be discarded'. In the clean code, allowStoreUpdate only gates save(). How repair should interact with that lock is an unspecified design choice. The reference rejects the combination and the candidate lets the explicit repair opt-in win. Neither choice is required, so this failure does not show the candidate missing a stated requirement.

**Independent read (before panel evidence):** ✅ Genuine pass

Before reading any critique, I checked the candidate against each behavior the prompt requires. It has the ignore/repair property with ignore as the default. It reloads the cached index from disk on repair. It treats an entry as broken when the target is not a regular file directly in the folder or the name is an invalid path. It treats empty or line-break-only files as resolved. It detects sharing by equal names and by Files.isSameFile, and shared entries take precedence. It deletes symlink ta…

**Panel assessment (adjudicator's view of each judge):**

- **judge-a** (trust: trusted, fair probe: Yes, discriminates: No) — Says true_positive and I agree. Its prompt-grounded probes (sharing through links outside the folder, symlink chains, hard links, forgetting a file shared by name) pass on the candidate. Its two candidate-only failures are on unspecified edges, and it correctly did not count them. I did not re-run …
- **judge-c** (trust: distrusted, fair probe: No, discriminates: Yes) — I re-ran the probe. The candidate fails 1/7 (repairDoesNotRewriteTheIndexWhenStoreUpdatesAreDisabled) and the reference passes 7/7. It is over-flagging: the probe enforces a contract between repair and allowStoreUpdate that the prompt does not state, while the prompt says plainly that repair discar…

**Tags:** `OVERFLAGGED`, `RERAN_PROBE`, `PANEL_AGREED_WITH_ME`, `SOLO_FP_REJECTED`, `UNDERSPECIFIED_EDGE`

### judge-a — ✅ Genuine pass · high confidence · probe fairness: questionable

Real solve. The candidate meets every prompt-stated integrity behavior; it differs from the reference only on an unreadable file and on repair with allowStoreUpdate=false, neither of which the prompt specifies.

**Details / suggested hardening:**

Solid implementation. Optional hardening: decide explicitly how repair interacts with allowStoreUpdate=false (reject, skip, or document that repair overrides it), and treat unreadable violation files as kept rather than aborting initialization.

- **Discriminator found:** No
- **Falsification attempts:** 8
- **Requirements checked:** 8 (0 failed)
- **Duration:** 5m 20s

### judge-c — ❌ False positive · medium confidence · probe fairness: fair

False positive: repair rewrites stored.rules despite allowStoreUpdate=false; six other probe areas hold.

**Details / suggested hardening:**

Repair initialization bypasses the existing `default.allowStoreUpdate=false` prohibition and rewrites the index while dropping a broken entry. Preserve the index or refuse repair when updates are disabled; the targeted probe shows the candidate-only failure.

- **Discriminator found:** Yes — `repairDoesNotRewriteTheIndexWhenStoreUpdatesAreDisabled`
- **Falsification attempts:** 6
- **Requirements checked:** 6 (1 failed)
- **Duration:** 14m 54s
