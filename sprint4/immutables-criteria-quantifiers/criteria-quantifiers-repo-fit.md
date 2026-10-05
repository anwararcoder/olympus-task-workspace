# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-21 03:10
- **Investigation:** 30 gh calls · 15 gh searches · 2 upstream requests · 140.268s

Pass: this is a distinct, repo-aligned implementation of a long-requested but still unsolved Criteria capability; prior stub removal was not removal of working functionality and explicitly anticipated later implementation.

## Reasoning

The flagged prior submissions are different tasks in different repositories: one concerns event-count operands in Siddhi logical patterns, and the other adds GQL WHERE filtering; neither shares this task's Criteria matcher API, in-memory quantifier evaluation, or MongoDB translation machinery. Upstream investigation found the exact open request, immutables/immutables#1210, but no public implementation of all()/none(), no rejection, and no removal of a working capability. Commit d3943127359015bf0c27ef92001b866af4a12c41 removed only methods whose bodies threw UnsupportedOperationException, explicitly to avoid advertising unsupported features, and said they would be implemented later. A maintainer then stated in issue #1210, “We do plan implementing it, if there is enough interest from users.” The pinned tree contains ALL and NONE expression operators but exposes only any() in IterableMatcher, consistent with an unfinished, repo-aligned capability rather than an already solved or declined one. Searches across open/closed PRs and issues by IterableMatcher, quantifier, and collection-matching terms found no PR carrying this solution. Therefore none of the three existence-drop categories is established.

## Investigation Log (30 commands)

**#0** · core · ok · 570 ms — `gh api /repos/immutables/immutables/commits?path=criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java`

```
[{"sha":"aeb0a7c10f491501ac21723d8627948a9576c805","node_id":"MDY6Q29tbWl0MTEyMzM5OTY6YWViMGE3YzEwZjQ5MTUwMWFjMjE3MjNkODYyNzk0OGE5NTc2YzgwNQ==","commit":{"author":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2020-11-26T03:08:32Z"},"committer":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2020-11-26T18:31:27Z"},"message":"Add support for any() operator in IterableMatcher (sub-array matching).\n\nCurrently not implemented in backends, just on API level.","tree":{"sha":"28c30e0ac8fa90db13963508359ee66a9a3cc338","url":"https://api.github.com/repos/immutables/immutables/git/trees/28c30e0ac8fa90db13963508359ee66a9a3cc338"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/aeb0a7c10f491501ac21723d8627948a9576c805","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/immutables/immutables/commits/aeb0a7c10f491501ac21723d8627948a9576c805","html_url":"https://github.com/immutables/immutables/commit/aeb0a7c10f491501ac21723d8627948a9576c805","comments_url":"https://api.github.com/repos/immutables/immutables/commits/aeb0a7c10f491501ac21723d8627948a9576c805/comments","author":{"login":"asereda-gs","id":25229979,"node_id":"MDQ6VXNlcjI1MjI5OTc5","avatar_url":"https://avatars.githubusercontent.com/u/25229979?v=4","gravatar_id":"","url":"https://api.github.com/users/asereda-gs","html_url
```

**#1** · core · ok · 602 ms — `gh api /repos/immutables/immutables/commits?path=criteria/mongo/src/org/immutables/criteria/mongo/FindVisitor.java`

```
[{"sha":"e46c6493aa343ceb7d6bec390bb238944f6f248e","node_id":"C_kwDOAKtqzNoAKGU0NmM2NDkzYWEzNDNjZWI3ZDZiZWMzOTBiYjIzODk0NGY2ZjI0OGU","commit":{"author":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2026-03-22T00:14:52Z"},"committer":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2026-03-22T00:55:32Z"},"message":"Add fieldName helper method to FindVisitor class","tree":{"sha":"c403d2faaefa4c649fbd44e54514c9ddc53ef17d","url":"https://api.github.com/repos/immutables/immutables/git/trees/c403d2faaefa4c649fbd44e54514c9ddc53ef17d"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/e46c6493aa343ceb7d6bec390bb238944f6f248e","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/immutables/immutables/commits/e46c6493aa343ceb7d6bec390bb238944f6f248e","html_url":"https://github.com/immutables/immutables/commit/e46c6493aa343ceb7d6bec390bb238944f6f248e","comments_url":"https://api.github.com/repos/immutables/immutables/commits/e46c6493aa343ceb7d6bec390bb238944f6f248e/comments","author":{"login":"asereda-gs","id":25229979,"node_id":"MDQ6VXNlcjI1MjI5OTc5","avatar_url":"https://avatars.githubusercontent.com/u/25229979?v=4","gravatar_id":"","url":"https://api.github.com/users/asereda-gs","html_url":"https://github.com/asereda-gs","followers_url":"https://api.github.com/users/asereda-gs/foll
```

**#2** · search · ok · 804 ms — `gh search issues "criteria quantifier" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 50`
→ `[]`

**#3** · search · ok · 836 ms — `gh search prs "criteria all none" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 50`
→ `[]`

**#4** · search · ok · 858 ms — `gh search prs "criteria quantifier" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 50`
→ `[]`

**#5** · core · ok · 596 ms — `gh api /repos/immutables/immutables/commits?path=criteria/common/src/org/immutables/criteria/expression/Path.java`

```
[{"sha":"b0ca724928f8b8f10137d8df989ff09dff5db507","node_id":"C_kwDOAKtqzNoAKGIwY2E3MjQ5MjhmOGI4ZjEwMTM3ZDhkZjk4OWZmMDlkZmY1ZGI1MDc","commit":{"author":{"name":"elucash","email":"e.lucash@gmail.com","date":"2026-02-18T19:50:39Z"},"committer":{"name":"elucash","email":"e.lucash@gmail.com","date":"2026-02-18T19:50:39Z"},"message":"#1635 eradicating more of ThreadSafe/NotThreadSafe annotation","tree":{"sha":"86e75f730be71c31fd4798921e2c4a0bda202e34","url":"https://api.github.com/repos/immutables/immutables/git/trees/86e75f730be71c31fd4798921e2c4a0bda202e34"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/b0ca724928f8b8f10137d8df989ff09dff5db507","comment_count":0,"verification":{"verified":true,"reason":"valid","signature":"-----BEGIN SSH SIGNATURE-----\nU1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgHY9veq6moe/c2h3sIZVuMGtXbh\n1Ya8TSaXCl3GFaFLUAAAADZ2l0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5\nAAAAQI0jVG9A7ldunhD5gAZ3tXfr+rdM09NqyN37LlHhrEaxTZgS4fZgwdGAauhhiOnxFg\nAfYxRtLCROdh5qqtD1Zwg=\n-----END SSH SIGNATURE-----","payload":"tree 86e75f730be71c31fd4798921e2c4a0bda202e34\nparent 1285ea26b2897b95b2ce948a16176b4031221a50\nauthor elucash <e.lucash@gmail.com> 1771444239 -0500\ncommitter elucash <e.lucash@gmail.com> 1771444239 -0500\n\n#1635 eradicating more of ThreadSafe/NotThreadSafe annotation\n","verified_at":"2026-02-18T19:50:45Z"}},"url":"https://api.github.com/repos/immutables/immutables/commits/b0ca724928f8b8f10137d8df989ff09dff5db507","html_url":"ht
```

**#6** · core · ok · 644 ms — `gh api /repos/immutables/immutables/commits?path=criteria/inmemory/src/org/immutables/criteria/inmemory/ExpressionInterpreter.java`

```
[{"sha":"5ed8ded8132742aa54c07d5bd46bcffee94229bc","node_id":"C_kwDOAKtqzNoAKDVlZDhkZWQ4MTMyNzQyYWE1NGMwN2Q1YmQ0NmJjZmZlZTk0MjI5YmM","commit":{"author":{"name":"Fabian Märki","email":"fabian.maerki@bertschi.com","date":"2024-10-15T06:54:17Z"},"committer":{"name":"Fabian Märki","email":"fabian.maerki@bertschi.com","date":"2024-10-15T06:54:17Z"},"message":"Support sub-collection any() query for inmemory and mongodb","tree":{"sha":"90b93230d3b165bcaa24c06eec0abb2becd35f93","url":"https://api.github.com/repos/immutables/immutables/git/trees/90b93230d3b165bcaa24c06eec0abb2becd35f93"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/5ed8ded8132742aa54c07d5bd46bcffee94229bc","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/immutables/immutables/commits/5ed8ded8132742aa54c07d5bd46bcffee94229bc","html_url":"https://github.com/immutables/immutables/commit/5ed8ded8132742aa54c07d5bd46bcffee94229bc","comments_url":"https://api.github.com/repos/immutables/immutables/commits/5ed8ded8132742aa54c07d5bd46bcffee94229bc/comments","author":null,"committer":null,"parents":[{"sha":"4c737f7fcc3e00799b12e57f3f6abd6b3ebcd800","url":"https://api.github.com/repos/immutables/immutables/commits/4c737f7fcc3e00799b12e57f3f6abd6b3ebcd800","html_url":"https://github.com/immutables/immutables/commit/4c737f7fcc3e00799b12e57f3f6abd6b3ebcd800"}]},{"sha":"8156d5a7577364184f678dbd85def
```

**#7** · core · ok · 676 ms — `gh api /repos/immutables/immutables/commits?path=value-processor/src/org/immutables/value/processor/meta/CriteriaModel.java`

```
[{"sha":"0c2d47ec8e5f07b3f52778e1dce1c2f575e103cd","node_id":"MDY6Q29tbWl0MTEyMzM5OTY6MGMyZDQ3ZWM4ZTVmMDdiM2Y1Mjc3OGUxZGNlMWMyZjU3NWUxMDNjZA==","commit":{"author":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2020-05-02T21:14:49Z"},"committer":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2020-05-02T23:51:01Z"},"message":"Add syntax sugar to Optional matchers with is(Optional) / isNot(Optional) methods\n\nHelpful for nullable arguments which get converted to isPresent / isAbsent\nequivalent depending on optional value.\n\nvalue == Optional.empty() changed to isAbsent()\nvalue == Optional.of(123) changed to is(123)\n\nThis allows making calling API like:\n\nperson.name.is(Optional.ofNullable(nullableName));","tree":{"sha":"c693912f7e419e6d9011fd74523c4393d612b32a","url":"https://api.github.com/repos/immutables/immutables/git/trees/c693912f7e419e6d9011fd74523c4393d612b32a"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/0c2d47ec8e5f07b3f52778e1dce1c2f575e103cd","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/immutables/immutables/commits/0c2d47ec8e5f07b3f52778e1dce1c2f575e103cd","html_url":"https://github.com/immutables/immutables/commit/0c2d47ec8e5f07b3f52778e1dce1c2f575e103cd","comments_url":"https://api.github.com/repos/immutables/immutables/commits/0c2d47ec8e5f
```

**#8** · search · ok · 839 ms — `gh search prs "IterableMatcher" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 100`
→ `[]`

**#9** · search · ok · 842 ms — `gh search issues "collection matching" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`
→ `[]`

**#10** · search · ok · 849 ms — `gh search prs "collection matching" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`
→ `[]`

**#11** · search · ok · 909 ms — `gh search issues "IterableMatcher" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2023-04-12T15:10:38Z","number":1457,"state":"open","title":"Criteria ClassCastException: IterableMatcher$1Local -> PetCriteriaTemplate","url":"https://github.com/immutables/immutables/issues/1457"},{"createdAt":"2020-08-05T19:47:18Z","number":1210,"state":"open","title":"All/none/any functionality in IterableMatcher","url":"https://github.com/immutables/immutables/issues/1210"}]
```

**#12** · search · ok · 979 ms — `gh search prs "IterableMatcher" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2020-08-04T16:28:10Z","number":1207,"state":"merged","title":"Fix repository generation for custom generic types","url":"https://github.com/immutables/immutables/pull/1207"}]
```

**#13** · search · ok · 978 ms — `gh search issues "IterableMatcher" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2017-04-05T14:06:24Z","number":594,"state":"closed","title":"Mongo: Query on Embedded/Nested Documents by attribute","url":"https://github.com/immutables/immutables/issues/594"}]
```

**#14** · search · ok · 1179 ms — `gh search prs "all() none()" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2020-08-04T16:28:10Z","number":1207,"state":"merged","title":"Fix repository generation for custom generic types","url":"https://github.com/immutables/immutables/pull/1207"}]
```

**#15** · core · ok · 1254 ms — `gh pr view 1644 --repo immutables/immutables --comments`

```
author:	asereda-gs
association:	member
edited:	false
status:	none
--
Thanks for this PR.

Can you please add tests in `FindVisitorTest` to confirm expression tree?
--
author:	elucash
association:	member
edited:	false
status:	none
--
```
Error:  Failed to execute goal org.apache.maven.plugins:maven-compiler-plugin:3.14.0:compile (default-compile) on project criteria-mongo: Compilation failure: Compilation failure: 
Error:  /home/runner/work/immutables/immutables/criteria/mongo/src/org/immutables/criteria/mongo/FindVisitor.java:[462,16] [UnusedMethod] Private method 'applyDeMorgansLaw' is never used.
Error:      (see https://errorprone.info/bugpattern/UnusedMethod)
Error:    Did you mean to remove this line?
Error:  /home/runner/work/immutables/immutables/criteria/mongo/src/org/immutables/criteria/mongo/FindVisitor.java:[416,16] [UnusedMethod] Private method 'buildLeafCondition' is never used.
Error:      (see https://errorprone.info/bugpattern/UnusedMethod)
Error:    Did you mean to remove this line?
Error:  -> [Help 1]
```
--
author:	asereda-gs
association:	member
edited:	false
status:	none
--
Thank you!
--
```

**#16** · core · ok · 1344 ms — `gh issue view 1642 --repo immutables/immutables --comments`

```
author:	rgatbert
association:	contributor
edited:	false
status:	none
--
I struggled over 3 other edge cases for which I added tests and a fix
--
```

**#17** · core · ok · 415 ms — `gh api /repos/immutables/immutables/issues/1210`

```
{"url":"https://api.github.com/repos/immutables/immutables/issues/1210","repository_url":"https://api.github.com/repos/immutables/immutables","labels_url":"https://api.github.com/repos/immutables/immutables/issues/1210/labels{/name}","comments_url":"https://api.github.com/repos/immutables/immutables/issues/1210/comments","events_url":"https://api.github.com/repos/immutables/immutables/issues/1210/events","html_url":"https://github.com/immutables/immutables/issues/1210","id":673803663,"node_id":"MDU6SXNzdWU2NzM4MDM2NjM=","number":1210,"title":"All/none/any functionality in IterableMatcher","user":{"login":"cal-brown","id":9221108,"node_id":"MDQ6VXNlcjkyMjExMDg=","avatar_url":"https://avatars.githubusercontent.com/u/9221108?v=4","gravatar_id":"","url":"https://api.github.com/users/cal-brown","html_url":"https://github.com/cal-brown","followers_url":"https://api.github.com/users/cal-brown/followers","following_url":"https://api.github.com/users/cal-brown/following{/other_user}","gists_url":"https://api.github.com/users/cal-brown/gists{/gist_id}","starred_url":"https://api.github.com/users/cal-brown/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/cal-brown/subscriptions","organizations_url":"https://api.github.com/users/cal-brown/orgs","repos_url":"https://api.github.com/users/cal-brown/repos","events_url":"https://api.github.com/users/cal-brown/events{/privacy}","received_events_url":"https://api.github.com/users/cal-brown/received_events","type":"User"
```

**#18** · core · ok · 451 ms — `gh api /repos/immutables/immutables/issues/1210/comments`

```
[{"url":"https://api.github.com/repos/immutables/immutables/issues/comments/669483893","html_url":"https://github.com/immutables/immutables/issues/1210#issuecomment-669483893","issue_url":"https://api.github.com/repos/immutables/immutables/issues/1210","id":669483893,"node_id":"MDEyOklzc3VlQ29tbWVudDY2OTQ4Mzg5Mw==","user":{"login":"asereda-gs","id":25229979,"node_id":"MDQ6VXNlcjI1MjI5OTc5","avatar_url":"https://avatars.githubusercontent.com/u/25229979?v=4","gravatar_id":"","url":"https://api.github.com/users/asereda-gs","html_url":"https://github.com/asereda-gs","followers_url":"https://api.github.com/users/asereda-gs/followers","following_url":"https://api.github.com/users/asereda-gs/following{/other_user}","gists_url":"https://api.github.com/users/asereda-gs/gists{/gist_id}","starred_url":"https://api.github.com/users/asereda-gs/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/asereda-gs/subscriptions","organizations_url":"https://api.github.com/users/asereda-gs/orgs","repos_url":"https://api.github.com/users/asereda-gs/repos","events_url":"https://api.github.com/users/asereda-gs/events{/privacy}","received_events_url":"https://api.github.com/users/asereda-gs/received_events","type":"User","user_view_type":"public","site_admin":false},"created_at":"2020-08-05T20:24:09Z","updated_at":"2020-08-05T20:24:09Z","body":"It is true that currently one can't filter on nested lists. \r\nWe do plan implementing it, if there is enough interest from users. ","aut
```

**#19** · search · ok · 762 ms — `gh search prs "1210" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 100`
→ `[]`

**#20** · search · ok · 776 ms — `gh search prs "1210" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2020-08-04T16:28:10Z","number":1207,"state":"merged","title":"Fix repository generation for custom generic types","url":"https://github.com/immutables/immutables/pull/1207"}]
```

**#21** · search · ok · 783 ms — `gh search issues "all none any" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 100`

```
[{"createdAt":"2020-08-05T19:47:18Z","number":1210,"state":"open","title":"All/none/any functionality in IterableMatcher","url":"https://github.com/immutables/immutables/issues/1210"}]
```

**#22** · search · ok · 858 ms — `gh search prs "All none any functionality" --repo immutables/immutables --state open --json number,title,url,state,createdAt --limit 100`
→ `[]`

**#23** · core · ok · 1165 ms — `gh issue view 1210 --repo immutables/immutables --comments`

```
author:	asereda-gs
association:	member
edited:	false
status:	none
--
It is true that currently one can't filter on nested lists. 
We do plan implementing it, if there is enough interest from users. 
--
```

**#24** · core · ok · 361 ms — `gh api /repos/immutables/immutables/contents/criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java?ref=d3943127359015bf0c27ef92001b866af4a12c41^`

```
{"name":"IterableMatcher.java","path":"criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java","sha":"50ee89e8f9a7c66ca4302f9dc7a17025e2926417","size":2593,"url":"https://api.github.com/repos/immutables/immutables/contents/criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java?ref=d3943127359015bf0c27ef92001b866af4a12c41%5E","html_url":"https://github.com/immutables/immutables/blob/d3943127359015bf0c27ef92001b866af4a12c41%5E/criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java","git_url":"https://api.github.com/repos/immutables/immutables/git/blobs/50ee89e8f9a7c66ca4302f9dc7a17025e2926417","download_url":"https://raw.githubusercontent.com/immutables/immutables/d3943127359015bf0c27ef92001b866af4a12c41%5E/criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java","type":"file","content":"LyoKICogQ29weXJpZ2h0IDIwMTkgSW1tdXRhYmxlcyBBdXRob3JzIGFuZCBD\nb250cmlidXRvcnMKICoKICogTGljZW5zZWQgdW5kZXIgdGhlIEFwYWNoZSBM\naWNlbnNlLCBWZXJzaW9uIDIuMCAodGhlICJMaWNlbnNlIik7CiAqIHlvdSBt\nYXkgbm90IHVzZSB0aGlzIGZpbGUgZXhjZXB0IGluIGNvbXBsaWFuY2Ugd2l0\naCB0aGUgTGljZW5zZS4KICogWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRo\nZSBMaWNlbnNlIGF0CiAqCiAqICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGlj\nZW5zZXMvTElDRU5TRS0yLjAKICoKICogVW5sZXNzIHJlcXVpcmVkIGJ5IGFw\ncGxpY2FibGUgbGF3IG9yIGFncmVlZCB0byBpbiB3cml0aW5nLCBzb2Z0d2Fy\nZQogKiBkaXN0cmlidXRlZCB1bmRlciB0aGUgTGljZW5zZSBpcyBkaXN0cmli\ndXRlZCBvbiBhbiAiQVMgSVMiIEJBU0lTLAogKiBXSVRIT1VUIFdBUlJBTlRJ\nRVMgT1IgQ09O
```

**#25** · core · ok · 412 ms — `gh api /repos/immutables/immutables/commits/d3943127359015bf0c27ef92001b866af4a12c41/pulls`
→ `[]`

**#26** · core · ok · 461 ms — `gh api /repos/immutables/immutables/commits/d3943127359015bf0c27ef92001b866af4a12c41 --jq '.files[] | {filename,status,patch}'`

```
{"filename":"criteria/common/src/org/immutables/criteria/matcher/IterableMatcher.java","patch":"@@ -28,22 +28,6 @@\n  */\n public interface IterableMatcher\u003cR, S, V\u003e extends Matcher {\n \n-  default S all() {\n-    throw new UnsupportedOperationException();\n-  }\n-\n-  default S none() {\n-    throw new UnsupportedOperationException();\n-  }\n-\n-  default S any() {\n-    throw new UnsupportedOperationException();\n-  }\n-\n-  default S at(int index) {\n-    throw new UnsupportedOperationException();\n-  }\n-\n   default R contains(V value) {\n     return Matchers.extract(this).applyAndCreateRoot(e -\u003e Expressions.call(IterableOperators.CONTAINS, e, Expressions.constant(value)));\n   }","status":"modified"}
{"filename":"criteria/common/test/org/immutables/criteria/personmodel/PersonTest.java","patch":"@@ -16,34 +16,29 @@\n \n package org.immutables.criteria.personmodel;\n \n-import org.junit.jupiter.api.Disabled;\n import org.junit.jupiter.api.Test;\n \n import java.time.LocalDate;\n \n-@Disabled(\"used for compile-time testing only\")\n-public class PersonTest {\n+class PersonTest {\n \n   @Test\n-  public void collection() {\n-    PersonCriteria crit = PersonCriteria.person\n-            .pets.any().name.notEmpty()\n-            .age.atLeast(11)\n+  void collection() {\n+    PersonCriteria crit = PersonCriteria.person;\n+    PersonCriteria crit2 = crit.age.atLeast(11)\n             .fullName.startsWith(\"John\")\n             .isActive.isTrue()\n-\n
```

**#27** · core · ok · 465 ms — `gh api /repos/immutables/immutables/commits/aeb0a7c10f491501ac21723d8627948a9576c805 --jq '{message:.commit.message,html_url,files:[.files[]|{filename,status,patch}]}'`

```
{"files":[{"filename":"criteria/common/src/org/immutables/criteria/matcher/CriteriaContext.java","patch":"@@ -17,7 +17,9 @@\n package org.immutables.criteria.matcher;\n \n import org.immutables.criteria.expression.Expression;\n+import org.immutables.criteria.expression.Expressions;\n import org.immutables.criteria.expression.ImmutableQuery;\n+import org.immutables.criteria.expression.IterableOperators;\n import org.immutables.criteria.expression.Path;\n import org.immutables.criteria.expression.Query;\n import org.immutables.criteria.expression.Queryable;\n@@ -141,6 +143,24 @@ public CriteriaContext or() {\n     return new CriteriaContext(previous, state.withCombiner(Combiner.or()));\n   }\n \n+  /**\n+   * Build {@link IterableMatcher#any()} sub-matcher.\n+   */\n+  public CriteriaContext any() {\n+    Path path = path();\n+    Class\u003c?\u003e newType; // new path starts at this root\n+    try {\n+      newType = (Class\u003c?\u003e) Matchers.iterableTypeArgument(path.returnType());\n+    } catch (IllegalArgumentException|ClassCastException e) {\n+      throw new IllegalArgumentException(String.format(\"At path %s for %s\",\n+              path.toStringPath(), path.returnType()), e);\n+    }\n+\n+    Path newPath = Path.ofClass(newType);\n+    Combiner combiner = ((left, right) -\u003e Expressions.binaryCall(IterableOperators.ANY, path, right));\n+    return new CriteriaContext(previous, state.withCombiner(combiner).withPartial(newPath));\n+  }\n+\n   @Override\n   public
```

**#28** · core · ok · 480 ms — `gh api /repos/immutables/immutables/commits/d3943127359015bf0c27ef92001b866af4a12c41`

```
{"sha":"d3943127359015bf0c27ef92001b866af4a12c41","node_id":"MDY6Q29tbWl0MTEyMzM5OTY6ZDM5NDMxMjczNTkwMTViZjBjMjdlZjkyMDAxYjg2NmFmNGExMmM0MQ==","commit":{"author":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2019-09-17T21:56:24Z"},"committer":{"name":"Andrei Sereda","email":"25229979+asereda-gs@users.noreply.github.com","date":"2019-09-17T22:00:28Z"},"message":"Remove unimplemented methods on IterableMathcer: all / none / any / at\n\nAvoid confusing user with unsupported features.\n\nThese feature will be implemented later","tree":{"sha":"88e33aaa10fb5fdd5894176540ffc482f1795f0e","url":"https://api.github.com/repos/immutables/immutables/git/trees/88e33aaa10fb5fdd5894176540ffc482f1795f0e"},"url":"https://api.github.com/repos/immutables/immutables/git/commits/d3943127359015bf0c27ef92001b866af4a12c41","comment_count":0,"verification":{"verified":false,"reason":"unsigned","signature":null,"payload":null,"verified_at":null}},"url":"https://api.github.com/repos/immutables/immutables/commits/d3943127359015bf0c27ef92001b866af4a12c41","html_url":"https://github.com/immutables/immutables/commit/d3943127359015bf0c27ef92001b866af4a12c41","comments_url":"https://api.github.com/repos/immutables/immutables/commits/d3943127359015bf0c27ef92001b866af4a12c41/comments","author":{"login":"asereda-gs","id":25229979,"node_id":"MDQ6VXNlcjI1MjI5OTc5","avatar_url":"https://avatars.githubusercontent.com/u/25229979?v=4","gravatar_id":"","url":"https://api.github.
```

**#29** · search · ok · 727 ms — `gh search issues "removed all none" --repo immutables/immutables --state closed --json number,title,url,state,createdAt --limit 100`
→ `[]`

## Run History (2)

| # | Verdict | Status | Completed | Refunded | Job |
|---|---------|--------|-----------|----------|-----|
| 1 | pass | completed | 2026-07-21 00:39 | No | `nx7c1r3emwbfetaaq0n9zsmvrs8awe4y` |
| 2 | pass | completed | 2026-07-21 03:10 | No | `nx772ematvdsa7m40hp0der0kx8aztf2` |
