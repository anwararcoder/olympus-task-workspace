# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-23 05:23
- **Investigation:** 30 gh calls · 23 gh searches · 2 upstream requests · 52.2949s

Pass: exact upstream feature discussion exists, but it is an open request/sketch rather than a public solution; no duplicate, removal, rejection, or off-scope contradiction was found.

## Reasoning

The exact capability is requested in upstream issue #3180, but that issue contains only API/configuration brainstorming and no working implementation to crib. The maintainer explicitly leaves the capability open and invites a contribution. Searches across open/closed PRs for the feature, issue number, proposed option names, mapstruct.properties, and collection-mapping terminology found no implementation PR; code search found neither proposed submission key, and history for the newly introduced implementation-configuration class is empty. Thus public material covers motivation and a rough configuration idea, but essentially none of the hard work exercised by the tests: classpath resource loading, duplicate-preserving Java-properties parsing, type/generic/constructor validation, later-round deferral, and integration across direct properties, streams, factories, and capacity construction. The older same-repo 'immutable collections' task is materially distinct: it adds dedicated Guava immutable target-type mappings and builder machinery, whereas this task globally substitutes concrete implementations for existing supported JDK interface results. The other retrieved candidates are unrelated. The capability is also aligned with MapStruct's collection-mapping purpose and is not contradicted by repository policy.

## Findings (1)

### publicly-solved — Low severity

- **Claim:** Upstream issue #3180 publicly motivates this exact configurable-collection-implementation capability and sketches a properties/processor-option direction, but provides no working code and explicitly leaves implementation open.
- **Evidence:** "https://github.com/mapstruct/mapstruct/issues/3180 — “Currently we do not have support for a property file like I mentioned. However, considering the fact that there are different issues asking for configuring MapStruct in a specific way having some kind of a property file or some other SPIs might be a way to achieve this.”"
- **Expected:** Treat this as precursor/motivation overlap only, not an already-solved task.
- **Why it matters:** An agent could discover the desired high-level direction, but would still need to build virtually all implementation machinery and behavior covered by the hidden tests, so this does not defeat exclusivity.

## Investigation Log (30 commands)

**#0** · core · ok · 543 ms — `gh api /repos/mapstruct/mapstruct/commits?path=processor/src/main/java/org/mapstruct/ap/internal/model/common/ImplementationType.java`

```
[{"sha":"4d9894ba25ba4e17c76211409f951f4cce956b3e","node_id":"C_kwDOAEQ2o9oAKDRkOTg5NGJhMjViYTRlMTdjNzYyMTE0MDlmOTUxZjRjY2U5NTZiM2U","commit":{"author":{"name":"Obolrom","email":"65775868+Obolrom@users.noreply.github.com","date":"2024-09-02T08:26:48Z"},"committer":{"name":"GitHub","email":"noreply@github.com","date":"2024-09-02T08:26:48Z"},"message":"#3113 Use LinkedHashSet, LinkedHashSet new factory methods for java >= 19","tree":{"sha":"0a79acce035dd6045d426392a0feaeb4ce5ce6df","url":"https://api.github.com/repos/mapstruct/mapstruct/git/trees/0a79acce035dd6045d426392a0feaeb4ce5ce6df"},"url":"https://api.github.com/repos/mapstruct/mapstruct/git/commits/4d9894ba25ba4e17c76211409f951f4cce956b3e","comment_count":0,"verification":{"verified":true,"reason":"valid","signature":"-----BEGIN PGP SIGNATURE-----\n\nwsFcBAABCAAQBQJm1XbICRC1aQ7uu5UhlAAA7KUQAB9WkmGO5qWfZwJlCGrsXoOt\nHxkg5JZF9kwvrepu/CWX67mApfMu1L/QIw1c7Rhc6jWBGDxiLYnE8Z/8Vml9G0Xb\nHSy4A0AcU7iij4ZtJaMDZ4iCzg8DbyritZXSG5vMgKRAaH3rZobSVMRZQrFV+I9y\nSbcTNaXhY+Op8++YGZoyy96HdYNgs/beV7WGWHYDant8asyFJHMzc7nrW2mzSVX9\nTxMzFGMNh47VVzZNs3QoCB4fol91VWOEFEFk4+3Air7hrBrHzd5W8isXjVvIGFH8\n3EenHap8Mx+styz+bW96Y2fAkpAcTFWAStglkzkHSjMvMsgQVDX//vPplmLjZxos\niwbQAMnsqS4OALIP3yE/Eb3/2bTtYl4h4/9IkY7Ia9oqzjyGDaD5FO10m/Y3QBdZ\n6B6qBFb0RcTfuoglBtSriX7pxXNmkD95PagORiEFwNvxp+pHw1Gn0seCbooq8WNp\nu3XSgbTsK0m6eg+sVlzJQt7oSkAaKXpZyUd39t78bd5X/DAR1SRaU1udWT3U1ONc\n8Hrc14YWIGFEYPfrTZojjDnT5rsAGKIyCNCe8FwqYr942ggIW9T80QSdvio/Z+ey\nfN4soYvBPg7jQedzRijdb7b
```

**#1** · search · ok · 792 ms — `gh search prs "mapstruct.properties" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 30`
→ `[]`

**#2** · search · ok · 794 ms — `gh search prs "mapstruct.properties" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`
→ `[]`

**#3** · search · ok · 878 ms — `gh search prs "collection implementation" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`

```
[{"createdAt":"2021-07-11T12:40:45Z","number":2512,"title":"PR for issues #131, #2438, #366","url":"https://github.com/mapstruct/mapstruct/pull/2512"},{"createdAt":"2014-04-13T11:29:26Z","number":201,"title":"refactoring model for PropertyMapping, MapMapping and Iterable Mapping","url":"https://github.com/mapstruct/mapstruct/pull/201"}]
```

**#4** · search · ok · 914 ms — `gh search issues "collection implementation" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 30`
→ `[]`

**#5** · search · ok · 921 ms — `gh search issues "collection implementation" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`

```
[{"createdAt":"2023-06-20T16:45:18Z","number":3313,"title":"FR: Work with lazy scalar property of hibernate3+","url":"https://github.com/mapstruct/mapstruct/issues/3313"},{"createdAt":"2019-09-02T17:21:32Z","number":1885,"title":"Inheritance errors","url":"https://github.com/mapstruct/mapstruct/issues/1885"}]
```

**#6** · search · ok · 950 ms — `gh search prs "collection implementation" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 30`
→ `[]`

**#7** · search · ok · 801 ms — `gh search prs "custom collection" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 50`
→ `[]`

**#8** · search · ok · 814 ms — `gh search issues "custom collection" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2015-12-08T20:17:20Z","number":706,"title":"Provide a way to customize templates","url":"https://github.com/mapstruct/mapstruct/issues/706"}]
```

**#9** · search · ok · 818 ms — `gh search prs "custom collection" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 50`
→ `[]`

**#10** · search · ok · 846 ms — `gh search prs "configurationFile" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 50`
→ `[]`

**#11** · search · ok · 893 ms — `gh search issues "implementation type" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2017-06-12T05:58:16Z","number":1223,"title":"Use EnumSet as Implementation Type if result type is a set of enums","url":"https://github.com/mapstruct/mapstruct/issues/1223"},{"createdAt":"2016-07-05T19:46:20Z","number":827,"title":"Add some checks to Mappers#getMapper()","url":"https://github.com/mapstruct/mapstruct/issues/827"},{"createdAt":"2021-03-16T05:21:26Z","number":2384,"title":"Mapping Collection defaults to type ArrayList","url":"https://github.com/mapstruct/mapstruct/issues/2384"},{"createdAt":"2021-07-17T10:36:50Z","number":2519,"title":"[Feature] - Vavr Collection support in Mapstruct","url":"https://github.com/mapstruct/mapstruct/issues/2519"},{"createdAt":"2023-02-28T10:30:43Z","number":3180,"title":"Customize the types used for collection mappings","url":"https://github.com/mapstruct/mapstruct/issues/3180"}]
```

**#12** · search · ok · 985 ms — `gh search issues "custom collection" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2021-05-06T09:26:19Z","number":2432,"title":"Feature Request: Always use Collection<T> when performing addAll() ","url":"https://github.com/mapstruct/mapstruct/issues/2432"}]
```

**#13** · core · ok · 1413 ms — `gh issue view 366 --repo mapstruct/mapstruct --comments`

```
author:	agudian
association:	member
edited:	false
status:	none
--
This is basically a duplicate of #131. There's some stuff that we need to think about, but I also still find it worth exploring.

--
author:	gunnarmorling
association:	member
edited:	false
status:	none
--
Yes, it's an interesting idea. I'm no huge fan of the instance-of calls, but I guess there is no way around them.

--
author:	sjaakd
association:	contributor
edited:	false
status:	none
--
If such functionality is implemented, we could possibly drop #319 as well. 

IIUC: what we actually try to implement is automatic generation of factory methods that @agudian  implemented earlier (see `org.mapstruct.ap.test.factories.GenericFactory`). Can we use the 'forgedmethod' mechanism to achieve this? How would we establish which classes to include in the 'instance-of if statements'

--
author:	milanov
association:	none
edited:	false
status:	none
--
Hi guys, is there any development on this issue (or the referenced #131 )? In case not, what would you recommend for an ad-hoc implementation of this looks like? The use case is exactly the one described here: converting between parallel class hierarchies of Entity/Dto objects:

```
  Person                 PersonDto
  /    \                  /    \
Man   Woman           ManDto   WomanDto
```

And the method I would like to implement is `List<? extends PersonDto> peopleToDtos(List<? extends Person> people)`?

--
author:	amitjindal
association:	none
edited:	false
status:	none
```

**#14** · core · ok · 1475 ms — `gh pr view 2512 --repo mapstruct/mapstruct --comments`

```
author:	filiphr
association:	member
edited:	false
status:	none
--
Wow, thanks a lot for this PR @Zegveld. I haven't gotten around in reviewing this (picking the low hanging fruits first). However, we would look into this to make the 1.5.0.Beta2 release
--
author:	filiphr
association:	member
edited:	false
status:	commented
--
Just finished with the review on this one. Really nice work @Zegveld. 

I've left some comments inline and I have some more general comments here.

I see that you are using the `_bugs` folder. We use this usually for actual bugs, not new features. I would suggest instead to use `subclassmapping` as top package and put your test there. You can then use different sub packages to show different use cases. In addition to that I am looking at the tests for #131 and #366. Correct me if I am wrong, but the only difference is the fact that in #131 `Vehicle` is not abstract, right?

Let's try to merge these things together and use the same source types and different target types. Perhaps you can also rename the source to `VehicleEntity` or somehow else, in order to avoid using full qualified names in the tests to make it more readable.

Can we also add some fixture tests, to see how the generated code looks like? As you know we strive to generate code which looks human readable 😄 .

Can we also add some erroneous tests to test the non happy paths for the new messages.

I am really excited in getting this in the upcoming 1.5. 

------
Something that could be good,
```

**#15** · core · ok · 456 ms — `gh api /repos/mapstruct/mapstruct/issues/3180 --jq '{title,body,state,html_url,created_at,closed_at,state_reason}'`

```
{"body":"### Use case\n\nMapping from one DTO domain to DB domain. Once mapped to DB entities, POJO's are serialized with DB specific serializers that don't support certain Java types [Geode Pdx Serialization](https://geode.apache.org/docs/guide/114/developing/data_serialization/gemfire_pdx_serialization.html). More than a limitation it is a design decision:\r\n\r\n\"Differences between Geode Serialization (PDX or Data Serializable) and Java Serialization\r\nGeode serialization (either PDX Serialization or Data Serialization) does not support circular object graphs whereas Java serialization does. In Geode serialization, if the same object is referenced more than once in an object graph, the object is serialized for each reference, and deserialization produces multiple copies of the object. By contrast in this situation, Java serialization serializes the object once and when deserializing the object, it produces one instance of the object with multiple references.\"\r\n(from [Data Serialization Options in Geode documentation](https://geode.apache.org/docs/guide/114/developing/data_serialization/data_serialization_options.html) )\r\n\r\nThis results in serialization problems when the resulting mapping contains LinkedHashMaps, while with our legacy manual mapping code, based on HasMap, there was no issue.\r\n\n\n### Generated Code\n\nA way to configure, either generally, or specifically for a certain attribute, what implementation of the collection objects is to be used to perf
```

**#16** · search · ok · 786 ms — `gh search prs "3180" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`
→ `[]`

**#17** · search · ok · 788 ms — `gh search prs "3180" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 30`
→ `[]`

**#18** · search · ok · 788 ms — `gh search prs "collection mappings" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2025-09-21T12:10:22Z","number":3935,"title":"#3708 Support `CollectionMappingStrategy` on `@BeanMapping` and `@Mapping`","url":"https://github.com/mapstruct/mapstruct/pull/3935"}]
```

**#19** · search · ok · 787 ms — `gh search issues "Customize types collection" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`
→ `[]`

**#20** · search · ok · 961 ms — `gh search prs "collection mappings" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2022-08-28T12:39:23Z","number":2992,"title":"#2952 Do not treat a getter as an alternative write accessor when using CollectionMappingStrategy#TARGET_IMMUTABLE","url":"https://github.com/mapstruct/mapstruct/pull/2992"},{"createdAt":"2021-04-04T17:49:52Z","number":2403,"title":"Conditional mapping","url":"https://github.com/mapstruct/mapstruct/pull/2403"},{"createdAt":"2014-02-03T21:29:39Z","number":123,"title":"#119 integration test JAXB","url":"https://github.com/mapstruct/mapstruct/pull/123"},{"createdAt":"2017-04-21T17:57:55Z","number":1183,"title":"#1154 Add SPI for excluding types/elements from automatic sub-mapping generation","url":"https://github.com/mapstruct/mapstruct/pull/1183"},{"createdAt":"2017-05-22T07:10:34Z","number":1209,"title":"#1170 Fix wildcards in collection adder mappings","url":"https://github.com/mapstruct/mapstruct/pull/1209"},{"createdAt":"2016-11-24T22:19:31Z","number":967,"title":"#966 Avoid missing newlines between methods and multiple newlines…","url":"https://github.com/mapstruct/mapstruct/pull/967"},{"createdAt":"2016-11-22T21:00:08Z","number":964,"title":"#962 Java 8 Stream conversions to Collections","url":"https://github.com/mapstruct/mapstruct/pull/964"},{"createdAt":"2018-04-28T16:06:38Z","number":1465,"title":"#1453 Make sure that we always create non bound collection","url":"https://github.com/mapstruct/mapstruct/pull/1465"},{"createdAt":"2018-09-27T19:17:54Z","number":1618,"title":"#1306 Add new NullValuePropertyMapping
```

**#21** · core · ok · 1320 ms — `gh issue view 3180 --repo mapstruct/mapstruct --comments`

```
author:	asjp1970
association:	none
edited:	false
status:	none
--
I would like to have advice on how to implement this, or if is of any interest at all, before I start working on a pull request for it. I've pointed a possible way to do it, but there are probably better ways.
So I would like to have the feedback from the experienced contributors. thanks!
--
author:	filiphr
association:	member
edited:	false
status:	none
--
@asjp1970 have you tried defining `@ObjectFactory`?

You can use

```
@ObjectFactory
public static <K, V> Map<K, V> creteMap() {
        return new HashMap<>();
}

@ObjectFactory
public static <V> Set<V> creteSet() {
        return new HashSet<>();
}
```

You can define this in a util class and make this available to your mappers.

---

Apart of that we could look into allowing people to define their own implementation types for different types. The implementation approach could be something similar like https://github.com/mapstruct/mapstruct/issues/3197#issuecomment-1510188570, providing some `mapstruct.properties` file that we can get during compilation and / or expose compilation options such as `implementation.type.<fqn>` e.g. `implementation.type.java.util.Map=java.util.HashMap`



--
author:	asjp1970
association:	none
edited:	true
status:	none
--
@filiphr, I'm about to try with @ObjectFactory; probably it will work but not sure in the way I'd like it to work: by having it in one configuration and NOT in all the mappers.
As a matter of fact, this is what
```

**#22** · core · ok · 478 ms — `gh api /repos/mapstruct/mapstruct/commits?path=processor/src/main/java/org/mapstruct/ap/internal/option/CollectionImplementationConfiguration.java`
→ `[]`

**#23** · search · ok · 495 ms — `gh search code "mapstruct.configurationFile" --repo mapstruct/mapstruct --limit 50 --json path,url`
→ `[]`

**#24** · core · ok · 543 ms — `gh api /repos/mapstruct/mapstruct/commits?path=documentation/src/main/asciidoc/chapter-6-mapping-collections.asciidoc --jq '.[0:10] | map({sha:.sha,message:.commit.message,url:.html_url})'`

```
[{"message":"#3240 Add Support for Java21 SequencedSet and SequencedMap","sha":"2c84d04463a3ec2edd6c05e726a579b4ba936847","url":"https://github.com/mapstruct/mapstruct/commit/2c84d04463a3ec2edd6c05e726a579b4ba936847"},{"message":"Fix documentation typo and code polish (#3787)","sha":"8f962919117c30c95165e5349314c0adea455d8f","url":"https://github.com/mapstruct/mapstruct/commit/8f962919117c30c95165e5349314c0adea455d8f"},{"message":"#2303 Generated code should use iteration order preserving LinkedHash(Map|Set) instead of Hash(Map|Set)","sha":"2be536bb65d220495b8d7f7f224451f1d59a1bb9","url":"https://github.com/mapstruct/mapstruct/commit/2be536bb65d220495b8d7f7f224451f1d59a1bb9"},{"message":"#607 Mapping Iterable\u003c?\u003e object to an object instead of collection","sha":"26f62b7ef0f8592196ef342b7fad450a64ae4751","url":"https://github.com/mapstruct/mapstruct/commit/26f62b7ef0f8592196ef342b7fad450a64ae4751"},{"message":"Fix minor typos","sha":"4480e0f367b4a34a448d16c9c0f39c0640742d49","url":"https://github.com/mapstruct/mapstruct/commit/4480e0f367b4a34a448d16c9c0f39c0640742d49"},{"message":"#991 Split reference guide source into an adoc file per chapter","sha":"ba90c95f232b144f6b73033e3371e7f8a9e65f56","url":"https://github.com/mapstruct/mapstruct/commit/ba90c95f232b144f6b73033e3371e7f8a9e65f56"}]
```

**#25** · search · ok · 742 ms — `gh search code "mapstruct.collectionImplementation" --limit 50 --json repository,path,url`
→ `[]`

**#26** · search · ok · 760 ms — `gh search prs "implementation.type.java.util.Map" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 30`
→ `[]`

**#27** · search · ok · 773 ms — `gh search prs "properties file" --repo mapstruct/mapstruct --state closed --json number,title,url,createdAt --limit 50`
→ `[]`

**#28** · search · ok · 917 ms — `gh search prs "implementation.type.java.util.Map" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 30`
→ `[]`

**#29** · search · ok · 989 ms — `gh search issues "properties file" --repo mapstruct/mapstruct --state open --json number,title,url,createdAt --limit 50`

```
[{"createdAt":"2023-02-28T10:30:43Z","number":3180,"title":"Customize the types used for collection mappings","url":"https://github.com/mapstruct/mapstruct/issues/3180"},{"createdAt":"2023-03-24T12:55:20Z","number":3211,"title":"Option to prevent fluent setter style","url":"https://github.com/mapstruct/mapstruct/issues/3211"},{"createdAt":"2015-11-26T17:34:23Z","number":702,"title":"retain annotations at runtime","url":"https://github.com/mapstruct/mapstruct/issues/702"}]
```

## Run History (1)

| # | Verdict | Status | Completed | Refunded | Job |
|---|---------|--------|-----------|----------|-----|
| 1 | pass | completed | 2026-07-23 05:23 | No | `nx76tsgjchstb1bjwr8w1wrhhx8b381d` |
