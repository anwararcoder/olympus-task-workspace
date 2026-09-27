# over-clarity-vs-ambiguity

**The description must steer between two measured failure modes: a clause that hands over a
design decision converts difficulty into reading comprehension (over-clarity), while a clause two
engineers read differently is a blocking defect (ambiguity). Target: 100% clear, brutally hard to
EXECUTE.**

## Evidence (as of 2026-06-10)
- Over-clarity: `java-call-hierarchy` enumerated its graded behaviors ("field initializer
  attribution, JDK callee zero-ranges") → strong agents implemented everything → 7/10 castor,
  then rollouts 1.0. A FAIRNESS FIX once RAISED its pass rate to 7/10 — clearly-stated mechanical
  contracts add no difficulty; the population just implements them.
- Ambiguity: `sorg-atom-media-ownership` — the single word "still" ("still take precedence")
  falsely implied pre-existing base behavior; flagged as "more ambiguity than genuine hardness",
  a BLOCKING defect; 4 of 9 failing runs failed only on that clause's reading.
- Ambiguity: `sorg-search-index` — negative/relative text definitions ("split from surrounding
  punctuation") judged ambiguous three runs in a row; positive definitions ("a token is a run of
  letters and digits") passed.

## Applies at
W3 description writing + the W4 persona self-audit.

## Rule it shaped
`rules/description-writing.md` (the two failure modes section).
