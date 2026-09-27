# Upstream check and repo fit

Two different questions. Upstream is searchable; fit is judgment grounded in the repo (Karim:
"for pure repo alignment that's mostly on you and ur judgement").

## Upstream (duplicate / already solved / maintainer ruling)

Local gh is 2.4.0: the global `gh search` command does NOT exist. Use per-repo forms.

```
# PRs and issues, all states, per keyword (run 3-5 keyword variants:
# feature name, API names from the patch, close synonyms)
gh pr list    --repo OWNER/REPO --state all --search "KEYWORD" --limit 15
gh issue list --repo OWNER/REPO --state all --search "KEYWORD" --limit 15

# Discussions (only reachable via GraphQL)
gh api graphql -f query='query{ search(query:"repo:OWNER/REPO KEYWORD", type:DISCUSSION, first:8){ discussionCount nodes{... on Discussion{title url}} } }'

# Issues+PRs in one shot with counts (good for a hard zero)
gh api graphql -f query='query{ search(query:"repo:OWNER/REPO KEYWORD", type:ISSUE, first:8){ issueCount nodes{ __typename ... on Issue{number title state} ... on PullRequest{number title state} } } }'

# Open a hit
gh pr view N --repo OWNER/REPO --comments
gh pr diff N --repo OWNER/REPO
```

Empty results need a sanity check before you trust them: run one broad keyword ("filter",
"broadcast") and confirm the repo returns anything at all, and check issues are enabled
(`gh repo view OWNER/REPO --json hasIssuesEnabled,pushedAt`).

In the local clone (faster and offline):

```
git cat-file -t BASE_SHA                          # commit exists
git merge-base --is-ancestor BASE_SHA HEAD        # pinned to real history
git log -S "SymbolName" --oneline                 # was/is this ever implemented
git log BASE_SHA..HEAD --oneline -- path/         # did upstream add it after base
grep -rn "feature-keyword" docs/ README.md        # already documented = duplicate
```

Also grep docs/CHANGELOG for "by design", "won't", "not supported": a documented refusal is a
maintainer ruling even without an issue.

## Repo fit (the judgment call)

Answer in one or two lines, grounded in the repo, not vibes:

1. What existing mechanism does the feature extend? Name it. (msw rooms: ws.link already shares
   clients across runtimes over a BroadcastChannel; rooms subset that same list. ormar subqueries:
   the repo advertises Django-style filters and builds on SQLAlchemy core.)
2. What is the real-world precedent a maintainer would recognize? (Socket.IO rooms; Django
   Subquery/OuterRef/Exists.)
3. Which part is the most opinionated or invented? Name it and decide whether the description
   pins it well enough to be fair. This is the part a maintainer would debate; if there is no
   such part, say so.
4. Repo health: active issues vs dependabot-only commits (maintenance mode is a soft note, not a
   blocker; the platform only requires a commit in the last 12 months).

Winning pushback pattern, if the author contests: show the behavior is already the repo's own
pattern elsewhere, with file:line (the osctrl PR #813 precedent). A behavior that fights
documented repo behavior blocks by default; concede fast when a reviewer shows that.
