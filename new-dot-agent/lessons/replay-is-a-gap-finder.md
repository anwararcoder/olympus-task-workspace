# replay-is-a-gap-finder

**Replaying saved agent solutions proves whether a candidate fork BITES (someone fails it), is a
WALL (everyone fails it), or is a NO-OP (everyone passes it) — it never measures a pass rate or
difficulty. Only fresh platform batches measure difficulty.**

## Evidence (as of 2026-06-10)
- `java-semantic-tokens`: the saved samples passed ~everything locally while live platform agents
  failed ~1/3 of tests (a Nova batch later went 0/10 on the same suite). Local replay portfolios
  systematically overestimate the population.
- Used CORRECTLY, replay killed bad forks cheaply: the package/FQN cascade idea died when 4/4
  replayed agents matched the reference byte-for-byte on every fair case (a no-op); the
  member-access fork was confirmed because a replayed opus-tier agent dropped every intermediate
  chain link while two others passed (bites + not a wall).
- It also cannot see description rewordings or model fresh agents — both proven blind spots.

## Applies at
W5 §3 (probe before shipping any fork) and W1 Gate C interpretation.

## Rule it shaped
`workflows/w5-platform-iteration.md` §3, `workflows/w4-verify.md` §1 (replay discipline note).
