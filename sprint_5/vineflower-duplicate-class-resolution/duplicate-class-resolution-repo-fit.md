# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-28 14:25
- **Investigation:** 18 gh calls · 12 gh searches · 2 upstream requests · 105.595s

Pass: distinct from the prior candidate, not publicly solved or declined, and explicitly motivated by an open maintainer-authored enhancement issue.

## Reasoning

No corpus duplicate is present: the only flagged prior submission concerns automatic identifier legalization and changes renaming/output-reference machinery, whereas this task builds duplicate-origin selection, byte comparison, family coherence, lazy-probe caching, and output ownership in StructContext. Upstream investigation found no open or closed Vineflower PR implementing duplicate-class strategies, no history for the newly introduced DuplicateClassResolver.java path, and current upstream StructContext still retains the original first-encountered behavior. The sole directly relevant upstream artifact is open issue #416, which requests improved duplicate handling and suggests failure/preference strategies but contains no code or comments; it is motivation/approval of the feature, not a publicly cribbable solution or rejection. The task is aligned with Vineflower's stated focus on decompiler quality, speed, and usability.

## Findings (1)

### publicly-solved — Low severity

- **Claim:** An upstream maintainer-authored issue publicly states the broad motivation and suggests strategy-based duplicate handling, but provides no implementation or design machinery covering the task.
- **Evidence:** "https://github.com/Vineflower/vineflower/issues/416 — "Currently (1.11-develop) we handle duplicate classes by using the first encountered class, which could be VM implementation defined. We should provide different strategies for handling this, such as failing decompilation or preferring the most correct class.""
- **Expected:** Treat issue #416 as motivation and evidence of repo alignment, not as a public solution.
- **Why it matters:** The high-level feature idea is public, but an agent must still build essentially all tested behavior: deterministic origin tracking, exact-byte conflict semantics, own/library precedence, family anchoring, lazy caching/invalidation, concurrency, warnings, and sink ownership. This does not defeat solution exclusivity.

## Investigation Log (18 commands)

**#0** · search · ok · 694 ms — `gh search prs "duplicate class" --repo vineflower/vineflower --state closed --json number,title,url,body,author --limit 50`
→ `[]`

**#1** · search · ok · 694 ms — `gh search issues "duplicate class" --repo vineflower/vineflower --state closed --json number,title,url,body --limit 50`
→ `[]`

**#2** · search · ok · 851 ms — `gh search prs "duplicate class" --repo vineflower/vineflower --state open --json number,title,url,body,author --limit 50`
→ `[]`

**#3** · search · ok · 900 ms — `gh search issues "duplicate class" --repo vineflower/vineflower --state open --json number,title,url,body --limit 50`

```
[{"body":"Currently (1.11-develop) we handle duplicate classes by using the first encountered class, which could be VM implementation defined. We should provide different strategies for handling this, such as failing decompilation or preferring the most correct class.","number":416,"title":"Improve handling of duplicate classes","url":"https://github.com/Vineflower/vineflower/issues/416"}]
```

**#4** · core · ok · 387 ms — `gh api /repos/vineflower/vineflower/commits?path=src/org/jetbrains/java/decompiler/struct/DuplicateClassResolver.java`
→ `[]`

**#5** · core · ok · 579 ms — `gh api /repos/vineflower/vineflower/commits?path=src/org/jetbrains/java/decompiler/struct/StructContext.java`

```
[{"sha":"19a5b12be438352c4e3aa045af82d173ea17d2f8","node_id":"C_kwDOFKaknNoAKDE5YTViMTJiZTQzODM1MmM0ZTNhYTA0NWFmODJkMTczZWExN2QyZjg","commit":{"author":{"name":"Jasmine Karthikeyan","email":"25208576+jaskarth@users.noreply.github.com","date":"2026-04-26T14:42:23Z"},"committer":{"name":"Jasmine Karthikeyan","email":"25208576+jaskarth@users.noreply.github.com","date":"2026-04-26T14:42:23Z"},"message":"Allow for introspection of units","tree":{"sha":"e67f96df311e1323d12cdce524929fef61994466","url":"https://api.github.com/repos/Vineflower/vineflower/git/trees/e67f96df311e1323d12cdce524929fef61994466"},"url":"https://api.github.com/repos/Vineflower/vineflower/git/commits/19a5b12be438352c4e3aa045af82d173ea17d2f8","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/Vineflower/vineflower/commits/19a5b12be438352c4e3aa045af82d173ea17d2f8","html_url":"https://github.com/Vineflower/vineflower/commit/19a5b12be438352c4e3aa045af82d173ea17d2f8","comments_url":"https://api.github.com/repos/Vineflower/vineflower/commits/19a5b12be438352c4e3aa045af82d173ea17d2f8/comments","author":{"login":"jaskarth","id":25208576,"node_id":"MDQ6VXNlcjI1MjA4NTc2","avatar_url":"https://avatars.githubusercontent.com/u/25208576?v=4","gravatar_id":"","url":"https://api.github.com/users/jaskarth","html_url":"https://github.com/jaskarth","followers_url":"https://api.github.com/users/jaskarth/followers","followin
```

**#6** · search · ok · 735 ms — `gh search prs "class strategy" --repo vineflower/vineflower --state closed --json number,title,url,body --limit 50`
→ `[]`

**#7** · search · ok · 765 ms — `gh search prs "duplicates" --repo vineflower/vineflower --state open --json number,title,url,body --limit 50`
→ `[]`

**#8** · search · ok · 792 ms — `gh search prs "duplicates" --repo vineflower/vineflower --state closed --json number,title,url,body --limit 50`
→ `[]`

**#9** · search · ok · 805 ms — `gh search prs "class strategy" --repo vineflower/vineflower --state open --json number,title,url,body --limit 50`
→ `[]`

**#10** · core · ok · 1109 ms — `gh issue view 416 --repo vineflower/vineflower --comments`
→ `(no output)`

**#11** · core · ok · 402 ms — `gh api /repos/vineflower/vineflower/issues/416`

```
{"url":"https://api.github.com/repos/Vineflower/vineflower/issues/416","repository_url":"https://api.github.com/repos/Vineflower/vineflower","labels_url":"https://api.github.com/repos/Vineflower/vineflower/issues/416/labels{/name}","comments_url":"https://api.github.com/repos/Vineflower/vineflower/issues/416/comments","events_url":"https://api.github.com/repos/Vineflower/vineflower/issues/416/events","html_url":"https://github.com/Vineflower/vineflower/issues/416","id":2472122049,"node_id":"I_kwDOFKaknM6TWZbB","number":416,"title":"Improve handling of duplicate classes","user":{"login":"jaskarth","id":25208576,"node_id":"MDQ6VXNlcjI1MjA4NTc2","avatar_url":"https://avatars.githubusercontent.com/u/25208576?v=4","gravatar_id":"","url":"https://api.github.com/users/jaskarth","html_url":"https://github.com/jaskarth","followers_url":"https://api.github.com/users/jaskarth/followers","following_url":"https://api.github.com/users/jaskarth/following{/other_user}","gists_url":"https://api.github.com/users/jaskarth/gists{/gist_id}","starred_url":"https://api.github.com/users/jaskarth/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/jaskarth/subscriptions","organizations_url":"https://api.github.com/users/jaskarth/orgs","repos_url":"https://api.github.com/users/jaskarth/repos","events_url":"https://api.github.com/users/jaskarth/events{/privacy}","received_events_url":"https://api.github.com/users/jaskarth/received_events","type":"User","user_view_type":"public","s
```

**#12** · core · ok · 417 ms — `gh api /repos/vineflower/vineflower/contents/src/org/jetbrains/java/decompiler/struct/StructContext.java?ref=HEAD --jq .content`

```
Ly8gQ29weXJpZ2h0IDIwMDAtMjAyMSBKZXRCcmFpbnMgcy5yLm8uIFVzZSBv
ZiB0aGlzIHNvdXJjZSBjb2RlIGlzIGdvdmVybmVkIGJ5IHRoZSBBcGFjaGUg
Mi4wIGxpY2Vuc2UgdGhhdCBjYW4gYmUgZm91bmQgaW4gdGhlIExJQ0VOU0Ug
ZmlsZS4KcGFja2FnZSBvcmcuamV0YnJhaW5zLmphdmEuZGVjb21waWxlci5z
dHJ1Y3Q7CgppbXBvcnQgb3JnLmpldGJyYWlucy5hbm5vdGF0aW9ucy5OdWxs
YWJsZTsKaW1wb3J0IG9yZy5qZXRicmFpbnMuamF2YS5kZWNvbXBpbGVyLm1h
aW4uRGVjb21waWxlckNvbnRleHQ7CmltcG9ydCBvcmcuamV0YnJhaW5zLmph
dmEuZGVjb21waWxlci5tYWluLmV4dGVybi5JQnl0ZWNvZGVQcm92aWRlcjsK
aW1wb3J0IG9yZy5qZXRicmFpbnMuamF2YS5kZWNvbXBpbGVyLm1haW4uZXh0
ZXJuLklDb250ZXh0U291cmNlOwppbXBvcnQgb3JnLmpldGJyYWlucy5qYXZh
LmRlY29tcGlsZXIubWFpbi5leHRlcm4uSUZlcm5mbG93ZXJMb2dnZXI7Cmlt
cG9ydCBvcmcuamV0YnJhaW5zLmphdmEuZGVjb21waWxlci5tYWluLmV4dGVy
bi5JUmVzdWx0U2F2ZXI7CmltcG9ydCBvcmcuamV0YnJhaW5zLmphdmEuZGVj
b21waWxlci5tYWluLnBsdWdpbnMuUGx1Z2luQ29udGV4dDsKaW1wb3J0IG9y
Zy5qZXRicmFpbnMuamF2YS5kZWNvbXBpbGVyLnN0cnVjdC5nZW4uZ2VuZXJp
Y3MuR2VuZXJpY01haW47CmltcG9ydCBvcmcuamV0YnJhaW5zLmphdmEuZGVj
b21waWxlci5zdHJ1Y3QuZ2VuLmdlbmVyaWNzLkdlbmVyaWNNZXRob2REZXNj
cmlwdG9yOwppbXBvcnQgb3JnLmpldGJyYWlucy5qYXZhLmRlY29tcGlsZXIu
dXRpbC5EYXRhSW5wdXRGdWxsU3RyZWFtOwoKaW1wb3J0IGphdmEuaW8uRmls
ZTsKaW1wb3J0IGphdmEuaW8uSU9FeGNlcHRpb247CmltcG9ydCBqYXZhLmlv
LklucHV0U3RyZWFtOwppbXBvcnQgamF2YS5pby5VbmNoZWNrZWRJT0V4Y2Vw
dGlvbjsKaW1wb3J0IGphdmEubmlvLkJ5dGVCdWZmZXI7CmltcG9ydCBqYXZh
Lm5pby5CeXRlT3JkZXI7CmltcG9ydCBqYXZhLm5pby5jaGFubmVscy5TZWVr
YWJsZUJ5dGVDaGFubmVsOwppbXBvcnQgamF2YS5uaW8uZmlsZS5GaWxlczsK
aW1wb3J0IGphdmEudXRpbC4qOwppbXBvcnQg
```

**#13** · core · ok · 678 ms — `gh api /repos/vineflower/vineflower/commits/b8273988af850e8cfb234ca08d129058502b032f --jq '{date:.commit.committer.date,message:.commit.message,html_url:.html_url}'`

```
{"date":"2026-04-29T00:12:35Z","html_url":"https://github.com/Vineflower/vineflower/commit/b8273988af850e8cfb234ca08d129058502b032f","message":"Release 1.12.0 (#566)\n\n* Start 1.12.0\n\n* [Kotlin] Fix some generics issues\n\n* Reduce filesizes, update Kotlin metadata to 2.1.20 (#473)\n\n* Reduce filesizes, update Kotlin metadata to 2.1.20\n\n* Fix issue with unintended additional metadata removals\n\n* [Kotlin] Fix full decompiler crash caused by missing Protobuf classes in metadata jar\n\nThis was a fix from regenerating after https://github.com/Vineflower/kt-metadata-minifier/commit/592068d931757e71583e41f72c6653aa9f792070\n\n* Fix do while loops inside of other loops being negated (#486)\n\n* Fix do while loops inside of other loops\n\n* Fix testjava11stringconcat\n\n* Fix test4\n\n* Adjust publishing for new Central endpoint (#490)\n\n* chore(build): Adjust publishing for new Central endpoint\n\n* chore(build): Bump test-only deps, use lazy task realization in a few places\n\n* chore(build): gradle 9.0.0\n\n* Get children methods for vararg calls (#483)\n\n* Recursively get methods through getMethodRecursive\n\n* fix test\n\n* bump ci\n\n* Improve decompiling fields (#482)\n\n* Clean up field writing to reduce redundancies\n\n* Add line numbers to field declarations when feasible\n\n* Port changes to Kotlin plugin\n\n* Revert failing tests\n\nThese reverted versions fail on my machine, but Actions might think otherwise\n\n* Handle Kotlin's statements and their frequent s
```

**#14** · search · ok · 1594 ms — `gh search issues "duplicate-class-strategy" --state closed --json repository,number,title,url,body --limit 100`

```
[{"body":"**Priority:** P3 · **Category:** Investigation · **Effort:** M · **Suggested commit:** `docs(core): sync-async duplication strategy`\n\n## Problem statement\n\nNearly every stream/reader/writer type is duplicated as `Foo.cs` + `Foo.Async.cs` with\nhand-mirrored logic (100+ file pairs). Every bug fix must be applied twice; the audit found\ndivergences (Issue 7: sync uses `stackalloc`, async allocates). This is the single largest\nmaintenance risk in the codebase, but any consolidation is high-effort/high-risk — so this\nissue is a **written evaluation only**, no code.\n","number":98,"repository":{"name":"sharpcompress","nameWithOwner":"nzbdav/sharpcompress"},"title":"investigation(core): evaluate strategies for sync/async partial-class duplication","url":"https://github.com/nzbdav/sharpcompress/issues/98"},{"body":"## Context\nPart of Group D (ADR 0001 duplication-elimination): eliminating home-grown pub/sub in favor of the canonical `event_bus` L0 package. This follows the same pattern already landed for `SimpleEventBus` → `event_bus` (PR #34, merged 2026-07-16, SHA `b1fba7e4`), which introduced the `hb_compat` adapter approach used elsewhere in this repo.\n\n## Current state\n- `strategy_framework/executors/events.py` defines an independent `EventBus` class (`_handlers: dict[str, list[Callable]]`, `subscribe`/`unsubscribe`/`emit`, per-handler exception suppression+logging) plus 4 frozen dataclasses (`OrderFilledEvent`, `OrderCancelledEvent`, `OrderFailedEvent`, `Pr
```

**#15** · search · ok · 2004 ms — `gh search issues "duplicate-class-strategy" --state open --json repository,number,title,url,body --limit 100`

```
[{"body":"> 🤖 AI-generated — created by an automated pipeline. Review before acting on this.\n\n**Source:** Follow-up from grooming of issue #509 (COULD_HAVE)\n\n**Context**\nWhile addressing the critical bug in #509 (duplicate `<staticContent>` blocks in IIS web.config causing site-wide 500 errors), a related architectural pattern was identified in the sibling rewrite-rules producer classes.\n\nThe `classes/Webp/RewriteRules/IIS.php` and `classes/Avif/RewriteRules/IIS.php` classes use the same underlying architecture via `classes/WriteFile/AbstractIISDirConfFile.php`, which exhibits the same root-cause issue: the `get_node()`/`prepend_node()` methods perform blind-prepend operations without deduplication logic.\n\nThis can produce duplicate `<preConditions>` singleton node collisions in generated IIS rewrite rules. While #509 was kept focused on the `<staticContent>` fix, this issue was explicitly scoped out per user decision during grooming.\n\n**Suggestion**\nApply the same fix pattern from #509 to the rewrite-rules classes. Reference the root-cause analysis in .ai/issues/509/spec.md for `AbstractIISDirConfFile.php` behavior details.\n\n**Acceptance Criteria**\n- [ ] `classes/Webp/RewriteRules/IIS.php` generates unique `<preConditions>` nodes without duplicates\n- [ ] `classes/Avif/RewriteRules/IIS.php` generates unique `<preConditions>` nodes without duplicates\n- [ ] `AbstractIISDirConfFile.php` deduplication behavior is aligned with #509 fix strategy\n\n**Related Issues
```

**#16** · search · ok · 3228 ms — `gh search prs "duplicate-class-strategy" --state closed --json repository,number,title,url,body --limit 100`

```
[{"body":"## What changed\n\n`extract_matches` could report the hidden toast strings **\"Removed from Favourites\"** and **\"Copied\"** as both players' names. Every Dafabet match card embeds these toast divs (favourite toggle + copy-game-code confirmations), and they carry the same `truncate` + `text-th-rb-*` classes that Strategy 1 matches on — and they appear **earlier in the card DOM** than the real name divs. When that happened for two unrelated matches, the duplicate detector compared identical bogus strings and fired a 100%-confidence false alert (seen 2026-07-21 07:51: \"Removed from Favourites vs Copied\" flagged as a duplicate of itself; the report filename showed the real players were different).\n\n## Why this approach\n\n- **New Strategy 0 — stable `data-testid` hooks.** Each card is `data-testid=\"event-<id>\"` and player names sit in `div[data-testid^=\"scoresbar-opponent-\"]`. The toast divs have their own distinct testids (`favourite-toggle-message`, `game-code-copied-message`), so this strategy structurally cannot pick up toast text, and testids survive CSS rebrands that have already broken class-based selectors twice.\n- **Defence in depth.** The toast strings are also denylisted in `looksLikeName`, so the existing class-based (Strategy 1) and structural (Strategy 2) fallbacks reject them too if Strategy 0 ever misses.\n- Strategy 2's trigger no longer depends on `foundViaClass`, so it doesn't overwrite a successful Strategy 0 result; \"Not started\" detect
```

**#17** · search · ok · 3740 ms — `gh search prs "duplicate-class-strategy" --state open --json repository,number,title,url,body --limit 100`

```
[{"body":"## Summary\n\nThis pull request adds comprehensive documentation for the Fan Chart consolidation project addressing **Request 0012927: Consolidate Fan charts types and features to extend Report choices**.\n\n## Documentation Added\n\nThis PR includes four comprehensive markdown files that analyze the current Fan Chart implementations and propose a consolidation strategy:\n\n### 📋 Files Added\n1. **FANCHART_CONSOLIDATION_ANALYSIS.md** - Detailed technical analysis of current state\n   - Architecture overview of all fan chart components\n   - Feature comparison matrix across chart types\n   - Code duplication metrics and analysis\n   - Current implementation patterns\n\n2. **FANCHART_IMPLEMENTATION_PLAN.md** - Comprehensive implementation roadmap\n   - 12-week phased implementation plan\n   - Detailed code changes for each phase\n   - Architecture diagrams and class hierarchies\n   - Migration strategy and backward compatibility\n\n3. **FANCHART_SUMMARY.md** - Executive summary and benefits overview\n   - Project objectives and success criteria\n   - High-level architecture comparison\n   - Benefits analysis (code reduction, maintainability, user experience)\n   - Risk assessment and mitigation strategies\n\n4. **FANCHART_DIFFERENCES.md** - Detailed comparison of implementations\n   - Configuration differences across chart types\n   - Feature availability matrix\n   - Data structure comparisons\n   - Method signature differences\n   - Code duplication metrics\n\n## 🎯
```

## Run History (2)

| # | Verdict | Status | Completed | Refunded | Job |
|---|---------|--------|-----------|----------|-----|
| 1 | pass | completed | 2026-07-28 13:01 | No | `nx75n1n87hznnqd78j273eqys18bdq9f` |
| 2 | pass | completed | 2026-07-28 14:25 | No | `nx78grbszd2nb8ep73hrzetk2h8bcfcf` |
