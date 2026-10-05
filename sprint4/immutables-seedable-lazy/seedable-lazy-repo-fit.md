# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-26 13:03
- **Investigation:** 17 gh calls · 13 gh searches · 1 upstream requests · 137.472s

Pass. This is a distinct generator capability that remains unsolved upstream. Open issue #1137 is motivation/precursor material only and does not defeat exclusivity.

## Reasoning

The flagged prior submissions are behaviorally distinct: compact binary serialization, structural diffs, generated pointers, and cross-repo immutable-collection mapping do not implement seedable lazy attributes or reuse this task's provenance-tracking machinery. Upstream investigation found the exact feature request in open issue #1137, but it contains only use cases and discussion—no working implementation, PR, commit, or maintainer rejection. Searches for the issue number, “lazy default,” and “seedable lazy” found no PR or implementing commit; touched-path history likewise showed no forward implementation or removed capability. At the pinned commit the processor explicitly rejects combining @Value.Lazy with @Value.Default, confirming the capability is absent. The task fits the repository's core purpose of generating builders, copy-with methods, lazy attributes, and modifiable values.

## Findings (1)

### publicly-solved — Low severity

- **Claim:** An open upstream issue requests the same core lazy-default behavior, but provides no implementation and has no maintainer resolution.
- **Evidence:** "https://github.com/immutables/immutables/issues/1137 — “To allow to be optionally passed in with the builder, but if not passed in Lazily compute it.”"
- **Expected:** Treat this as public motivation only, not a public solution.
- **Why it matters:** Agents can discover the motivation and intended basic behavior, but cannot crib the substantial implementation required for seed provenance, generated copies, modifiables, serialization, and diagnostics.

## Investigation Log (20 commands)

**#0** · core · ok · 639 ms — `gh api /repos/immutables/immutables/commits?path=value-processor/src/org/immutables/value/processor/Immutables.generator --jq '.[0:20] | map({sha: .sha, message: .commit.message, url: .html_url})'`

```
[{"message":"#1663 WIP semicolon","sha":"06b52eab0bb2b00bd0507636c0712e3cb89310f5","url":"https://github.com/immutables/immutables/commit/06b52eab0bb2b00bd0507636c0712e3cb89310f5"},{"message":"#1663 WIP optional+nullable+shim","sha":"89db9cefa0666b48039d73750909ceb661632837","url":"https://github.com/immutables/immutables/commit/89db9cefa0666b48039d73750909ceb661632837"},{"message":"#1640 Where.WITH_COPY for copy methods","sha":"f3fe649b15d96500f8d1c93ad02cace88747cf13","url":"https://github.com/immutables/immutables/commit/f3fe649b15d96500f8d1c93ad02cace88747cf13"},{"message":"#1636 propagating fallback type annotation to parameter (with* and builder.* initializers)","sha":"1285ea26b2897b95b2ce948a16176b4031221a50","url":"https://github.com/immutables/immutables/commit/1285ea26b2897b95b2ce948a16176b4031221a50"},{"message":"#1635 discontinuing NotThreadSafe annotations on generated classes","sha":"6ea8644c979cd67efac3892650175d150a342aef","url":"https://github.com/immutables/immutables/commit/6ea8644c979cd67efac3892650175d150a342aef"},{"message":"#1630 staged builder + static builder factory","sha":"5066e0fb425a0aee04a312da5fb9f0a9d606af58","url":"https://github.com/immutables/immutables/commit/5066e0fb425a0aee04a312da5fb9f0a9d606af58"},{"message":"#1618 static start method","sha":"58483d498711b87fe9dd214b5bab172664f5b276","url":"https://github.com/immutables/immutables/commit/58483d498711b87fe9dd214b5bab172664f5b276"},{"message":"Merge pull request #1615 from dkaukov/jackson
```

**#1** · search · ok · 727 ms — `gh search prs "Lazy Default" --repo immutables/immutables --state open --json number,title,url,body,createdAt --limit 30`
→ `[]`

**#2** · search · ok · 797 ms — `gh search prs "Lazy Default" --repo immutables/immutables --state closed --json number,title,url,body,createdAt --limit 30`
→ `[]`

**#3** · search · ok · 927 ms — `gh search issues "Lazy Default" --repo immutables/immutables --state closed --json number,title,url,body,createdAt --limit 30`

```
[{"body":"we have an immutable template that looks like below, but it fails because the generated code for the `withNewValue` fails to compile:\n\ntemplate:\n\n``` java\n@Immutable\npublic interface AbstractUpdater {\n  String getNewValue();\n  String getOldValue();\n\n  @Lazy\n  default boolean isDifferent() {\n    return !Objects.equals(getNewValue(), getOldValue());\n  }\n}\n```\n\n`withNewValue` generates bad code, because there are two `String newValue`s:\n\n``` java\n  public final ClientTiersDiffSection withNewValue(String newValue) {\n    if (this.newValue.equals(newValue)) return this;\n    String newValue = Objects.requireNonNull(newValue, \"newValue\");\n    return new ClientTiersDiffSection(this.clientTierDiffType, newValue, this.oldValue);\n  }\n```\n","createdAt":"2016-08-15T17:02:34Z","number":416,"title":"fields named `newValue` can cause compilation failures","url":"https://github.com/immutables/immutables/issues/416"},{"body":"immutables encodings work great for us, but `@Encoding.Init` clauses don't apply on fields annotated with `@Value.Default`. I can understand why, default values have a different initialization, but in the end default values can also be initialized in the builder, even though the user doesn't _have_ to do it.\r\n\r\nif we give up the `@Value.Default` then the encoding feature is applied, and we can specify a default value in the encoding, but we are now reduced to one default value per type, not a default value per field use.\r\n\r\nTha
```

**#4** · core · ok · 935 ms — `gh api /repos/immutables/immutables/commits?path=value-processor/src/org/immutables/value/processor/meta/AccessorAttributesCollector.java --jq '.[0:20] | map({sha: .sha, message: .commit.message, url: .html_url})'`

```
[{"message":"#1602 Check methods with plain constructor","sha":"31988c123f895e695eb96c032a780b0c499801b7","url":"https://github.com/immutables/immutables/commit/31988c123f895e695eb96c032a780b0c499801b7"},{"message":"JSpecify \u0026 typeuse: there's no end to this...","sha":"fcc5b5cdfdfd0d9142379e56f77a394b7f543cc9","url":"https://github.com/immutables/immutables/commit/fcc5b5cdfdfd0d9142379e56f77a394b7f543cc9"},{"message":"fixes #1488, a follow up to PR #1541","sha":"742347423d81728a43b845952d52dccb3cc5867d","url":"https://github.com/immutables/immutables/commit/742347423d81728a43b845952d52dccb3cc5867d"},{"message":"comprehensive record support: wip","sha":"4a3a7caf031abbfb1dc35b6474ae3b2194476510","url":"https://github.com/immutables/immutables/commit/4a3a7caf031abbfb1dc35b6474ae3b2194476510"},{"message":"Introduce special logic for Eclipse Compiler (ECJ) in RepositoryModel.\n\nTypes and elements are handled differently in ECJ. Had to create\nspecial branches.\n\nFixes #1175","sha":"417c4752a2da391acb1f928e488f090c09fe384b","url":"https://github.com/immutables/immutables/commit/417c4752a2da391acb1f928e488f090c09fe384b"},{"message":"Emit compile error when using @Value annotations on records","sha":"d9d51a403e577b21809b3e9a46692c3a1c8cc484","url":"https://github.com/immutables/immutables/commit/d9d51a403e577b21809b3e9a46692c3a1c8cc484"},{"message":" + fix misspellings","sha":"b048050b1cb806d1a7bf9957040d9a0dce8844dd","url":"https://github.com/immutables/immutables/commit/b048
```

**#5** · search · ok · 969 ms — `gh search issues "Lazy Default" --repo immutables/immutables --state open --json number,title,url,body,createdAt --limit 30`

```
[{"body":"I was working on a problem such as the following;\r\n\r\nTo allow to be optionally passed in with the builder, but if not passed in Lazily compute it.\r\n\r\n```\r\nFoo fooTheFirst  = ImmutableFoot.builder()\r\n\t\t\t\t\t\t\t\t.value1(\"1\")\r\n\t\t\t\t\t\t\t\t.value2(\"2\")\r\n\t\t\t\t\t\t\t\t.build();\r\n\r\nFoo fooTheSecond = ImmutableFoot.builder()\r\n\t\t\t\t\t\t\t\t.value1(\"1\")\r\n\t\t\t\t\t\t\t\t.value2(\"2\")\r\n\t\t\t\t\t\t\t\t.bar(new Bar())\r\n\t\t\t\t\t\t\t\t.build();\r\n\r\nfooTheFirst.getBar(); // returns lazily computed default Bar\r\nfooTheSecond.getBar(); // returns instance of Bar\r\n```\r\n\r\nI know this seems very similar to the normal `Default`. Perhaps this is a logic error, and I'm just not thinking straight? I just want to create an instance of `Bar` once and use it for the life of the Immutable. Unless provided in the builder.","createdAt":"2020-01-12T11:00:28Z","number":1137,"title":"A lazy default?","url":"https://github.com/immutables/immutables/issues/1137"},{"body":"When configuring `underrideToString = \"underrideToString\"` and defining the following:\n```java\npublic interface Example {\n    @Lazy\n    default String underrideToString() {\n        ...\n    }\n}\n```\nThis is generated in the immutable class:\n```java\n  @Override\n  public String toString() {\n    return Example.super.underrideToString();\n  }\n```\nAnd the method executes every time instead of lazily.\n\nThe lazy implementation for underrideToString is also gener
```

**#6** · core · ok · 425 ms — `gh api /repos/immutables/immutables/issues/1137 --jq '{state,title,html_url,created_at,closed_at,body}'`

```
{"body":"I was working on a problem such as the following;\r\n\r\nTo allow to be optionally passed in with the builder, but if not passed in Lazily compute it.\r\n\r\n```\r\nFoo fooTheFirst  = ImmutableFoot.builder()\r\n\t\t\t\t\t\t\t\t.value1(\"1\")\r\n\t\t\t\t\t\t\t\t.value2(\"2\")\r\n\t\t\t\t\t\t\t\t.build();\r\n\r\nFoo fooTheSecond = ImmutableFoot.builder()\r\n\t\t\t\t\t\t\t\t.value1(\"1\")\r\n\t\t\t\t\t\t\t\t.value2(\"2\")\r\n\t\t\t\t\t\t\t\t.bar(new Bar())\r\n\t\t\t\t\t\t\t\t.build();\r\n\r\nfooTheFirst.getBar(); // returns lazily computed default Bar\r\nfooTheSecond.getBar(); // returns instance of Bar\r\n```\r\n\r\nI know this seems very similar to the normal `Default`. Perhaps this is a logic error, and I'm just not thinking straight? I just want to create an instance of `Bar` once and use it for the life of the Immutable. Unless provided in the builder.","closed_at":null,"created_at":"2020-01-12T11:00:28Z","html_url":"https://github.com/immutables/immutables/issues/1137","state":"open","title":"A lazy default?"}
```

**#7** · search · ok · 706 ms — `gh search issues "seedable lazy" --repo immutables/immutables --state open --json number,title,url,body,createdAt --limit 100`
→ `[]`

**#8** · search · ok · 714 ms — `gh search issues "seedable lazy" --repo immutables/immutables --state closed --json number,title,url,body,createdAt --limit 100`
→ `[]`

**#9** · search · ok · 732 ms — `gh search prs "lazy default" --repo immutables/immutables --state open --json number,title,url,body,createdAt --limit 100`
→ `[]`

**#10** · search · ok · 737 ms — `gh search prs "1137" --repo immutables/immutables --state closed --json number,title,url,body,createdAt --limit 30`
→ `[]`

**#11** · search · ok · 866 ms — `gh search prs "lazy default" --repo immutables/immutables --state closed --json number,title,url,body,createdAt --limit 100`
→ `[]`

**#12** · search · ok · 993 ms — `gh search prs "1137" --repo immutables/immutables --state open --json number,title,url,body,createdAt --limit 30`
→ `[]`

**#13** · core · ok · 1238 ms — `gh issue view 1137 --repo immutables/immutables --comments`

```
author:	schallee
association:	none
edited:	false
status:	none
--
So I am interested in this as well. Perhaps I'm just not seeing how to do this. 

In my case I'm dealing with parsing data which may be reserialized quickly and repeatably. For instances created without being parsed the serialized version is @Value.Lazy. It would however make sense to just save the serialized version when parsing so that it does not need to be serialized again. Is there a way to provide a lazy value that happens to be available at construction time so it is not recomputed?

Thanks
--
author:	singhbaljit
association:	none
edited:	true
status:	none
--
👍 . This would be very useful to not recreate/reprocess attributes (although only once) if they're already known at construction.

Another way to think about this:
`Value.Default` = `Value.Derived` + value that can be provided/overridden at construction
? = `Value.Lazy` + value that can be provided/overridden at construction
--
author:	dbz120896
association:	none
edited:	false
status:	none
--
Another example is this: 
```
    @Value.Lazy
    @Value.Default
    default JsonNode getErrorNode() throws JsonProcessingException {
        return MAPPER.valueToTree(getError());
    }

    @Value.Lazy
    @Value.Default
    default Throwable getError() throws JsonProcessingException {
        return MAPPER.treeToValue(getErrorNode(), Throwable.class);
    }
```
--
```

**#14** · denied · FAILED · 0 ms — `gh api /search/commits -f q='repo:immutables/immutables 1137' -H 'Accept: application/vnd.github+json' --jq '.items | map({sha, message: .commit.message, url: .html_url})'`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#15** · denied · FAILED · 0 ms — `gh api /search/code -f q='repo:immutables/immutables "isGenerateSeedableLazy"' --jq '.items | map({name,path,html_url})'`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#16** · denied · FAILED · 0 ms — `gh api /search/code -f q='repo:immutables/immutables "@Value.Lazy" "@Value.Default"' --jq '.items | map({name,path,html_url})'`
→ `ERROR: `gh api -f` not allowed (sends a request body; GET only)`

**#17** · search · ok · 351 ms — `gh api '/search/commits?q=repo%3Aimmutables%2Fimmutables%201137' -H 'Accept: application/vnd.github+json' --jq '.items | map({sha, message: .commit.message, url: .html_url})'`
→ `[]`

**#18** · search · ok · 394 ms — `gh api '/search/code?q=repo%3Aimmutables%2Fimmutables%20isGenerateSeedableLazy' --jq '.items | map({name,path,html_url})'`
→ `[]`

**#19** · search · ok · 445 ms — `gh api '/search/code?q=repo%3Aimmutables%2Fimmutables%20%22%40Value.Lazy%22%20%22%40Value.Default%22' --jq '.items | map({name,path,html_url})'`

```
[{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/value-fixture/src/org/immutables/fixture/serial/SomeSer.java","name":"SomeSer.java","path":"value-fixture/src/org/immutables/fixture/serial/SomeSer.java"},{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/value-fixture/src/org/immutables/fixture/modifiable/Companion.java","name":"Companion.java","path":"value-fixture/src/org/immutables/fixture/modifiable/Companion.java"},{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/.archive/CHANGELOG.md","name":"CHANGELOG.md","path":".archive/CHANGELOG.md"},{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/value-processor/src/org/immutables/value/processor/meta/AccessorAttributesCollector.java","name":"AccessorAttributesCollector.java","path":"value-processor/src/org/immutables/value/processor/meta/AccessorAttributesCollector.java"},{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java","name":"ValueAttribute.java","path":"value-processor/src/org/immutables/value/processor/meta/ValueAttribute.java"},{"html_url":"https://github.com/immutables/immutables/blob/45a9d4c5399ad06c40c96bedc6679f4ff57b4f8e/value-fixture/src/org/immutables/fixture/annotation/AbstractDeeplyImmutable
```
