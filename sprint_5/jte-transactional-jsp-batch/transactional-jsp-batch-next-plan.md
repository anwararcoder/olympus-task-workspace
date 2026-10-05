# Transactional JSP Batch - next plan (v4 -> v5): nothing is blocking; optional hardening only

> Written after the fifth agent round, the first in which every acceptance gate passes. The
> immutable plan stays `transactional-jsp-batch-plan.md`. This supersedes the v4 next plan.

## 1. Where the task stands

| Gate | Result |
| --- | --- |
| Prechecks | 15 successful, 1 warning |
| Scope Gate | **PASSED** - distinct, not upstream-solved, aligned with the repo's JSP migration tooling |
| Verify Tests / Verify Solution | green, **P2P 921 / F2P 82** - every new cell is fail-to-pass |
| Verify Flakiness | green |
| Test Fairness | **PASS, ALL 82 TESTS FAIR** |
| Task / Solution / Description Quality | green |
| Environment Quality | not run by design - stales only on a Dockerfile edit, and the Dockerfile is unchanged |
| Fair task | no run flagged the task unfair or broken |
| Solvable | **1/10 solved** |
| No cheating / No environment blockers | none detected |
| **False positives** | **PASSED with caveats**, pass upheld over 1 dissenting judge |
| Minimum runs | **10/10** |
| Difficulty | **Hard, 10%**, inside the 40% ceiling |
| Long-horizon | median **12 files, 90 messages, 1644 LOC** |
| Verifier Completeness Audit | INCOMPLETE, 3 demonstrated gaps - **advisory, not a requirement** |

**No gate is blocking. The task is ready for review.** The only outstanding item is the advisory
audit, and the reasoning for not acting on it this round is in section 3.

## 2. What this round proved

**The write-scope class closed without becoming a wall.** Pass rate moved 18% -> 10% exactly as the
v4 next plan predicted: both v4 passers carried a genuine violation of a stated clause and went red,
while a fresh architecture still reached a full legitimate pass. Solvability never depended on the
reference alone.

**Fairness is genuinely fixed, not suppressed.** Four consecutive fairness FAILs on this task were
one defect class - FORM instead of PROPERTY, appearing as an exact message, then an exception type,
then an occurrence count. Every cell written since round 12 asserts a property, and every advisory
has been filtered by a single question: *does a naive-but-correct implementation pass this cell by
default?* Both new write-scope cells and the relaxed cycle assertions were rated fair on their first
exposure to the judge.

**The panel's dissent was overruled on the merits.** judge-c objected on hard-link aliasing. The
adjudicator ruled it unstated: the prompt's link handling is entirely about symbolic links,
"unrelated paths remain untouched" concerns files outside the migration set rather than inode
aliases, the reference tolerates the case only incidentally via atomic temp-file-and-move, and
in-place writing is a valid strategy as written. This is a **monitored grey**: it must not be pinned
by a test unless the description states it first.

## 3. The three audit gaps - real, deliberately deferred

All three are WRONG RESULT / HIGH PLAUSIBILITY and each is backed by a probe the reference passes
and a broken build fails, so none is noise. Each is a "reference green, suite silent" cell.

| # | Gap | Why it is fair to close |
| --- | --- | --- |
| G1 | An approved include whose directory entry is beneath the JSP root but whose **symlink target** is outside; a default `Files.isRegularFile(path)` follows it and consumes an out-of-root resource | Containment *is* stated ("must resolve beneath the JSP root"); the audit attacks containment only, not a symlink rule, and v4 already shipped a usage-symlink cell that establishes symlink-aware containment as in scope |
| G2 | Dependency discovery through **nested** approved includes - an invocation inside an approved include that is itself inside another | Every shipped include cell is single-level. The prose says "includes invocations in approved inlined includes" and limits nesting nowhere; an inlined include is by definition textually inlined, so recursion is entailed. A worklist implementation passes by default; only a single-level scan fails |
| G3 | Rollback must rethrow the **exact** original `IOException` instance, not an equivalent wrapper | Identical class to the parser-setup identity cell adopted in v4. "Rethrows the original failure" is stated, and `throw e;` is the naive path - wrapping is the extra work, so it passes by default |

**Why they were not adopted this round.** A ten-run batch was already in flight against these exact
82-cell bytes when the audit landed. Accepting the proposed patch overwrites the test patch,
re-stales every check the round had paid for, and strands that batch - and the batch was the one
permitted rollout. Independently, the proposal is a **full verifier replacement touching five files
including `test.sh` and both `FailingPathFileSystem` fixtures**, none of it locally gate-run; this
task's two TEST_MISMATCH verdicts both came from adopting check output without a local four-state.

## 4. If a hardening round is wanted (optional, test patch only)

Hand-build the three cells; do not accept the proposed patch.

### H1. Approved include reached through a symlink leaving the JSP root (both artifacts)

Place an approved include beneath the JSP root that is a symbolic link whose target sits outside,
plan a batch that references it, and assert no out-of-root path is a write key and its bytes are
unchanged after commit.

Use the **lenient shape already proven** by `CommitDoesNotWriteThroughAUsageSymlinkLeavingTheJspRoot`:
tolerate either refusing the plan or skipping the link, and fail only on actual out-of-root
consumption or mutation. Do **not** assert `IllegalArgumentException` - the prompt names symbolic
links only for selected tags and occupied destinations, and the reference's real rule is broader
than any prose we have (it also rejects symlink includes pointing *inside* the root). Asserting the
exception type would re-create the surprise-test shape that produced three fairness FAILs.

### H2. Dependency discovery recurses through nested approved includes (both artifacts)

Approved include A includes approved include B; B contains the only invocation of a selected tag.
Assert the dependency is discovered - as **plan order** (dependency precedes dependent), the same
property form the existing include cells use - not as an internal edge set.

### H3. The rollback rethrow preserves exception identity (both artifacts)

Hold the injected `IOException` in a sentinel and assert `isSameAs` on what `commit()` throws, exactly
as the parser-setup cell does. Keep the existing restored-state and suppressed-exception assertions.

## 5. Deliberate non-actions, with grounds

- **Description: unchanged.** Description Quality is green and the round is fully passing. The
  rejection enumeration an earlier auto-review called checklist-like is load-bearing - every item is
  a tested `IllegalArgumentException` - and it has now survived five fairness evaluations.
- **Reference solution: unchanged.** Solution Quality is green and no blocker was ever a reference
  defect.
- **Dockerfile: unchanged**, which is what keeps Environment Quality out of the funnel.
- **Hard-link aliasing: not to be pinned.** The panel itself ruled it unstated. Closing it would
  require stating it in the description first, and the description is not being touched.
- Previously refused advisories, not to be re-litigated: non-dangling destination symlink (zero
  discrimination), self-cycle reporting (a recursive reading is defensible, so it fails the
  passes-by-default filter), destination ancestor races (the suggestion hedges its own expectation),
  included-file disappearance (requires an unstated missing-file-to-stale mapping).

## 6. Verification standard for any future round

Unchanged and non-negotiable, all on the final bytes:

- reference-green on the full suite, the hard gate;
- fail-on-base with zero passing cells and zero compile errors;
- discriminator replay: each confirmed false positive fails exactly its own cell and nothing else;
- keep-genuine replay: a near-solver gains no new failing cell;
- both patches apply at the exact base with `--whitespace=error`, separately and together; `test.sh`
  stays 100755; patch stays ASCII; write sets stay disjoint.

Restore mutated files from a file backup, never `git checkout` - that drops the solution patch.

## 7. Stop rules

- Do not adopt an advisory cell that a naive-but-correct implementation would fail.
- Do not accept a proposed verifier patch without running the local gate battery on it first.
- Do not assert an exception type where the prompt states only an outcome.
- Do not edit the description or the reference to make a new cell fit; if a cell fails the reference,
  stop and report.
- Run the Verifier Completeness Audit **before** the dynamic checks and the batch, not after -
  accepting it re-stales everything below it.
