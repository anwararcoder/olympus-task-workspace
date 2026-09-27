# Solution Writing — repo-faithful, dead-code-free, honestly sized

Size targets: see `rules/platform-bar.md` (and remember: LoC is an OUTPUT of forks/layers, an
input only of padding — padding "catches zero agents" and reviewers reject it on sight). Files:
6-8+ across genuinely distinct layers; the old "10-15+" guidance was inflated.

## Repo-faithful style (the #1 human-review flag class)

- **Comment density matches the repo, measured** — count it (e.g. java-language-server's
  ErrorProvider has ~1 comment per 196 lines; sorg is terse Go). Default to almost none. A comment
  only states a constraint the code cannot show.
- No AI tells: no banner/divider comments, no em-dash connectives, no "seasoned engineer" prose,
  no over-explanation, no `// call the helper` narration. ASCII only.
- No dead code: every symbol on a tested, executed path. Unused helpers, stored-but-unread fields,
  defined-but-never-called functions are flagged EVERY time (newsletter was dinged for three
  unused helpers even while being accepted).
- No diff noise: zero reformatting of unrelated lines, no cosmetic/unicode churn. Regenerate and
  read your own patch as a reviewer before every submission.
- Idiom: use the repo's existing primitives and conventions (the repo's own error wrapping, its
  helper layers, its naming). When the repo offers two APIs, prefer the one its own siblings use —
  agents are graded against discoverable convention, and so are we.

## Engineering standards reviewers explicitly check (each cost a real run or note)

- **Path canonicalization** when paths act as identity (`filepath.Abs` — absolute-vs-relative
  spellings of the same file must agree).
- **Atomic writes** (temp + rename) wherever a failure mid-write must leave the previous artifact
  intact; failed regeneration must not destroy what was being replaced.
- **Ownership-scoped deletion**: cleanup deletes only what a previous run RECORDED writing — never
  glob-pattern guessing (which deletes user files).
- **Durable state across processes** when the contract implies it ("a previous successful build
  wrote") — in-memory tracking dies with the process.
- **Validate before side effects**: reject BEFORE creating sessions/IDs/network calls when the
  prompt says "refused with no X created" (7/10 agents failed exactly this on carve — and the
  reference must model it perfectly).
- Narrow type checks (no overly-broad interface matches that intercept legitimate values).

## Honest disclosure

If the reference uses an artifact the prompt never names (a sidecar metadata file, an extra
column), it must be one valid choice among several — tests must not require it — and the QA
solution-explanation must disclose it as such.

## The reference is also a contestant

Run the full hidden suite against the reference under the exact `test.sh` the platform will use
(four-state, `workflows/w4-verify.md`). The reference passing 100% is a hard gate; the reference
itself getting a stated rule silently wrong has happened (an anon-supertype double-emit) and such
behaviors are either genuine forks or bugs — decide consciously, never ship them unexamined.
