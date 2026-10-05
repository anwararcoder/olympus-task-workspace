# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-28 16:37
- **Investigation:** 25 gh calls · 19 gh searches · 2 upstream requests · 153.738s

Pass: distinct from the precompiler-maintenance candidate, not publicly solved or declined upstream, and aligned with the repository's existing JSP migration tooling.

## Reasoning

No existence-level disqualifier was found. The only same-repo prior candidate concerns incremental precompiler artifact maintenance in the runtime/compiler modules; this submission instead adds dependency-ordered, read-only JSP batch planning, virtual conversion, staleness detection, and transactional filesystem commit/rollback in the two JSP converter artifacts. Although both use content snapshots and failure restoration, their task behavior, modified surfaces, parsing machinery, and solver work are materially distinct, so they legitimately coexist. Broad open/closed GitHub searches for JSP, JSP converter, migration, batch migration, transactional behavior, and convertTag found no public PR or issue carrying a working implementation of this capability and no maintainer rejection. Touched-path history showed no JspMigrationPlan or StaleJspMigrationPlanException history and no later implementation on the converter paths; the Jakarta converter has only its initial insertion. The repository explicitly contains and documents JSP migration converter artifacts, so transactional batch migration is aligned with repository scope. No evidence of prior removal was found.

## Investigation Log (25 commands)

**#0** · search · ok · 1146 ms — `gh search prs "batch migration" --repo casid/jte --state closed --json number,title,state,url,createdAt --limit 50`
→ `[]`

**#1** · search · ok · 1278 ms — `gh search prs "JSP converter" --repo casid/jte --state closed --json number,title,state,url,createdAt --limit 50`

```
[{"createdAt":"2021-07-18T13:33:17Z","number":109,"state":"merged","title":"Pull request for issue 104: putParametersOnSeparateLines option was implemented.","url":"https://github.com/casid/jte/pull/109"},{"createdAt":"2023-10-13T20:00:42Z","number":288,"state":"merged","title":"Use MkDocs for project documentation","url":"https://github.com/casid/jte/pull/288"},{"createdAt":"2021-08-02T17:05:17Z","number":110,"state":"closed","title":"Bump ant from 1.10.9 to 1.10.11 in /jte-jsp-converter","url":"https://github.com/casid/jte/pull/110"},{"createdAt":"2021-02-03T19:36:14Z","number":48,"state":"merged","title":"Bump ant from 1.9.15 to 1.10.9 in /jte-jsp-converter","url":"https://github.com/casid/jte/pull/48"},{"createdAt":"2020-09-26T05:39:41Z","number":17,"state":"merged","title":"Bump ant from 1.8.2 to 1.9.15 in /jte-jsp-converter","url":"https://github.com/casid/jte/pull/17"}]
```

**#2** · search · ok · 1339 ms — `gh search prs "JSP converter" --repo casid/jte --state open --json number,title,state,url,createdAt --limit 50`
→ `[]`

**#3** · search · ok · 1446 ms — `gh search issues "JSP converter" --repo casid/jte --state open --json number,title,state,url,createdAt --limit 50`
→ `[]`

**#4** · search · ok · 1495 ms — `gh search prs "batch migration" --repo casid/jte --state open --json number,title,state,url,createdAt --limit 50`
→ `[]`

**#5** · search · ok · 1568 ms — `gh search issues "JSP converter" --repo casid/jte --state closed --json number,title,state,url,createdAt --limit 50`

```
[{"createdAt":"2024-05-13T13:28:39Z","number":358,"state":"closed","title":"Provide jte-jsp-converter for Jakarta","url":"https://github.com/casid/jte/issues/358"},{"createdAt":"2021-07-17T19:39:16Z","number":107,"state":"closed","title":"JSP Converter - Better c:forEach support","url":"https://github.com/casid/jte/issues/107"},{"createdAt":"2021-07-16T18:34:16Z","number":99,"state":"closed","title":"JSP Converter - Bug in JSP tag usage detection","url":"https://github.com/casid/jte/issues/99"},{"createdAt":"2021-07-16T21:55:15Z","number":101,"state":"closed","title":"Unable to convert string concatenation in JSP EL expression","url":"https://github.com/casid/jte/issues/101"},{"createdAt":"2021-07-17T13:36:04Z","number":102,"state":"closed","title":"JSP to JTE conversion error: Unknown AST node class org.apache.el.parser.AstListData","url":"https://github.com/casid/jte/issues/102"},{"createdAt":"2021-07-06T11:54:37Z","number":90,"state":"closed","title":"JteStringContent is nowhere to be found","url":"https://github.com/casid/jte/issues/90"},{"createdAt":"2021-07-17T14:14:46Z","number":103,"state":"closed","title":"JSP conversion: closing tag isn't being converted","url":"https://github.com/casid/jte/issues/103"},{"createdAt":"2021-07-17T14:32:12Z","number":104,"state":"closed","title":"Output tag parameters on separate lines","url":"https://github.com/casid/jte/issues/104"},{"createdAt":"2021-06-30T09:24:25Z","number":89,"state":"closed","title":"Use maven-compiler-plugin Ja
```

**#6** · core · ok · 2877 ms — `gh api "/repos/casid/jte/commits?path=jte-jsp-converter/src/main/java/gg/jte/convert/jsp/StaleJspMigrationPlanException.java&per_page=100" --jq '.[] | [.sha,.commit.author.date,.commit.message,.html_url] | @tsv'`
→ `(no output)`

**#7** · core · ok · 2990 ms — `gh api "/repos/casid/jte/commits?path=jte-jsp-converter/src/main/java/gg/jte/convert/jsp/JspMigrationPlan.java&per_page=100" --jq '.[] | [.sha,.commit.author.date,.commit.message,.html_url] | @tsv'`
→ `(no output)`

**#8** · core · ok · 3075 ms — `gh api "/repos/casid/jte/commits?path=jte-jsp-converter/src/main/java/gg/jte/convert/jsp/JspToJteConverter.java&per_page=100" --jq '.[] | [.sha,.commit.author.date,.commit.message,.html_url] | @tsv'`

```
03f724f6ac5130df2cb081017c7b0a41b018cb80	2023-07-07T12:44:05Z	Fix replace usages of converted JSPs with no parameters and only a body content	https://github.com/casid/jte/commit/03f724f6ac5130df2cb081017c7b0a41b018cb80
60519888ebe10eaad2f2c58d5550e84c931056de	2022-04-27T15:36:41Z	Adjust JSP converter for less strict jte 2 template structure	https://github.com/casid/jte/commit/60519888ebe10eaad2f2c58d5550e84c931056de
92d03dbbfd36c0126de5bfc8a7ff67c6f9e1975b	2021-07-18T13:28:37Z	Issue 104: putParametersOnSeparateLines option was implemented.	https://github.com/casid/jte/commit/92d03dbbfd36c0126de5bfc8a7ff67c6f9e1975b
2ddba28b3bcd119fa27d1b6c6f5f0fc388f6988a	2021-07-17T17:44:43Z	#103 JSP bridging tags with body are closed correctly when replacing usages after conversion	https://github.com/casid/jte/commit/2ddba28b3bcd119fa27d1b6c6f5f0fc388f6988a
390919807cd101a2b4ee88dd16baead8a6777ab3	2021-07-09T05:23:43Z	Fix build errors	https://github.com/casid/jte/commit/390919807cd101a2b4ee88dd16baead8a6777ab3
c8e11f13ecaaeadab685f278c5d1f62b52e242d5	2020-10-12T19:34:27Z	Allow to override reading of JSP file for conversion.	https://github.com/casid/jte/commit/c8e11f13ecaaeadab685f278c5d1f62b52e242d5
eb37b967029dc06c64269300d18e068715cc2375	2020-10-09T13:09:12Z	Do not fail for jsp tags marked to be manually converted, fix and test	https://github.com/casid/jte/commit/eb37b967029dc06c64269300d18e068715cc2375
61d1d56cc972b52278ba8c8b787053d76bad7945	2020-10-09T12:58:40Z	Do not fail for jsp tags
```

**#9** · search · ok · 3255 ms — `gh search prs "convertTag" --repo casid/jte --state closed --json number,title,url,body --limit 50`
→ `[]`

**#10** · search · ok · 3323 ms — `gh search prs "convertTag" --repo casid/jte --state open --json number,title,url,body --limit 50`
→ `[]`

**#11** · search · ok · 3353 ms — `gh search issues "migration" --repo casid/jte --state open --json number,title,url,body --limit 50`

```
[{"body":"With Spring validation, when a form entry has an error Spring adds a `BindingResult` to the model with the key similar to `org.springframework.validation.BindingResult.myEntry`. However there isn't a way to reference the model entry via a `@param`\r\n\r\n```\r\n@param org.springframework.validation.BindingResult.myEntry: org.springframework.validation.BeanPropertyBindingResult\r\n```\r\n\r\nSince there are dots in the variable name that isn't allowed.\r\n\r\nWould a PR for the Spring integration that changes the dots for underscores be welcome?\r\n\r\nI'm looking to see if there are other options as well...","number":362,"title":"Unable to handle model properties that contain dots (`.`)","url":"https://github.com/casid/jte/issues/362"}]
```

**#12** · search · ok · 3910 ms — `gh search issues "migration" --repo casid/jte --state closed --json number,title,url,body --limit 50`

```
[{"body":"I'm using jte for templating emails and reports. But my app is all REST API. It would be nice if it's possible to skip registering the bean JteViewResolver based on a property: `gg.jte.web=false` that should disable any MVC related components.","number":514,"title":"Skip ViewResolver registration based on property","url":"https://github.com/casid/jte/issues/514"},{"body":"In Thymeleaf it's possible to render a part of a template using the syntax \"<template_name> :: <fragment_name>\". Do you think this is something that would be possible in JTE?\r\n\r\nThe \"obvious\" solution to this is to simply extract the fragment into its own JTE template, but that can oftentimes lead to an explosion of template files.\r\n\r\nIn my mind the ideal solution would be that you can mark a part of a JTE template as a fragment which, when the template is compiled into a Java class, is itself compiled into its own Java class (so one Java class for the template as a whole and another for the fragment). The fragment Java class would then be included/called from the parent Java class. This way the fragment Java class can perhaps be called on its own, to only render that part?\r\n\r\nNo idea if this is feasible but a use case where this is very handy is when using something like HTMX. A Javascript framework that allows any HTML element to perform HTTP actions and handle the returned HTML. This HTML is often a smaller part of the page the user is on (i.e. the fragment I described above). An
```

**#13** · core · ok · 1569 ms — `gh api "/repos/casid/jte/commits?path=jte-jsp-converter-jakarta/src/main/java/gg/jte/convert/jsp/JspToJteConverter.java&per_page=100" --jq '.[] | [.sha,.commit.author.date,.commit.message,.html_url] | @tsv'`

```
f85582e26e6ec42399f2c82747d8f8062314efa9	2024-05-13T13:31:02Z	Initial insert of jte-jsp-converter-jakarta module	https://github.com/casid/jte/commit/f85582e26e6ec42399f2c82747d8f8062314efa9
```

**#14** · search · ok · 2023 ms — `gh api "/search/code?q=planTags+repo%3Acasid%2Fjte" --jq '.items[] | [.name,.path,.html_url] | @tsv'`
→ `(no output)`

**#15** · search · ok · 2101 ms — `gh search issues "transactional" --repo casid/jte --state open --json number,title,url,body --limit 100`
→ `[]`

**#16** · search · ok · 2144 ms — `gh search issues "transactional" --repo casid/jte --state closed --json number,title,url,body --limit 100`
→ `[]`

**#17** · search · ok · 2175 ms — `gh search prs "JSP" --repo casid/jte --state closed --json number,title,url,body,author --limit 100`

```
[{"author":{"id":"MDQ6VXNlcjgyOTA5NzE=","is_bot":false,"login":"izogfif","type":"User","url":"https://github.com/izogfif"},"body":"","number":109,"title":"Pull request for issue 104: putParametersOnSeparateLines option was implemented.","url":"https://github.com/casid/jte/pull/109"},{"author":{"id":"MDQ6VXNlcjQ1NzY=","is_bot":false,"login":"marcospereira","type":"User","url":"https://github.com/marcospereira"},"body":"## What?\r\n\r\ntl;dr\r\n\r\nUse [MkDocs](https://www.mkdocs.org/), [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/), and [mike](https://github.com/jimporter/mike) to write, publish, and version the docs.\r\n\r\n## Current state\r\n\r\nSee <https://marcospereira.github.io/jte/>.\r\n\r\n## How it works\r\n\r\nI will add plenty of links here so that it can function as a reference later.\r\n\r\n### Overall\r\n\r\nThe docs are now [searchable](https://squidfunk.github.io/mkdocs-material/setup/setting-up-site-search/?h=search), ~~[versioned](https://squidfunk.github.io/mkdocs-material/setup/setting-up-versioning/)~~, offer [light/dark modes](https://squidfunk.github.io/mkdocs-material/setup/changing-the-colors/#color-palette-toggle), present [code snippets](https://squidfunk.github.io/mkdocs-material/reference/content-tabs/#grouping-code-blocks) for Java and Kotlin, have [fast navigation](https://squidfunk.github.io/mkdocs-material/setup/setting-up-navigation/?h=instant#instant-loading), automatically generated [table of contents](https://squidfunk
```

**#18** · search · ok · 2207 ms — `gh search prs "JSP" --repo casid/jte --state open --json number,title,url,body,author --limit 100`
→ `[]`

**#19** · search · ok · 2393 ms — `gh api "/search/code?q=JspMigrationPlan+repo%3Acasid%2Fjte" --jq '.items[] | [.name,.path,.html_url] | @tsv'`
→ `(no output)`

**#20** · search · ok · 2402 ms — `gh api "/search/code?q=%22StaleJspMigrationPlanException%22" --jq '.items[] | [.repository.full_name,.path,.html_url] | @tsv'`
→ `(no output)`

**#21** · core · ok · 2941 ms — `gh issue view 358 --repo casid/jte --comments`

```
author:	casid
association:	owner
edited:	false
status:	none
--
Preview released with 3.1.11
--
```

**#22** · search · ok · 849 ms — `gh search issues "JSP" --repo casid/jte --state open --json number,title,url,body --limit 100`

```
[{"body":"For example, I have this absolute url of a local resource in my JSP template:\n```\n<html>\n  <head>\n    <link rel=\"stylesheet\" type=\"text/css\" href=\"${pageContext.request.contextPath}/resource/css/my_own.css\" />\n    ...\n  </head>\n  ...\n</html>\n```\nWhat is the recommended way to get the same result in a JTE template?","number":430,"title":"Migrating from JSP: contextPath / pageContext","url":"https://github.com/casid/jte/issues/430"},{"body":"I'm trying to receive the data from a form submitted as a POST request.\r\nCurrently my workaround is to get the values from `HttpServletRequest request` and its parameter map.\r\nBut i want to directly bind the returned values to a dto object like e.g. here: https://www.baeldung.com/spring-mvc-and-the-modelattribute-annotation \r\nDoes binding an entity to a form work in jte?","number":318,"title":"Receive form data in Spring Boot POST request","url":"https://github.com/casid/jte/issues/318"},{"body":"According [to the documentation of Spring Boot](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#web.servlet.spring-mvc.error-handling.error-pages) it is possible to define templates that should be used when a specific HTTP status code occurs.\r\n\r\nI have noticed when I place a `404.jte` in `src/main/resources/templates/error` it doesn't work. I have tried the same thing with Thymeleaf and that does work.\r\n\r\nDigging through the Spring code I saw that in order to resolve the error view, it g
```

**#23** · search · ok · 1155 ms — `gh search issues "JSP" --repo casid/jte --state closed --json number,title,url,body --limit 100`

```
[{"body":"I'm brand new to JTE and have just started experimenting with it inside of Spring Boot 4.0.x application as a potential JSP replacement. In the initial demo application I'm building, I ran into a corner case: having `@for` as part of a valid http/CDN path (https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.1/css/all.min.css).\n\nThe picture says it all:\n\n![Image](https://github.com/user-attachments/assets/3e2d50c5-4793-42cb-b82a-852dc626d54a)\n\nThe resulting error:\n`jakarta.servlet.ServletException: Request processing failed: gg.jte.TemplateException: Failed to compile layout/page.jte, error at line 30: Missing @endfor`\n\nOne workaround:\n\n```\n!{var fontAwesomeCss = \"https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@7.1/css/all.min.css\";}\n<link rel=\"stylesheet\" href=\"${fontAwesomeCss}\">\n```\n\n","number":530,"title":"inline @for causes compilation error","url":"https://github.com/casid/jte/issues/530"},{"body":"It would be nice to to have a setting to produce compressed ouput for HTML templates, by removing all unneeded indentations from the output.\r\n\r\nFor instance this template:\r\n```html\r\n<div>\r\n    @if(true)\r\n        <span>Hello</span>\r\n    @endif\r\n</div>\r\n```\r\n\r\nCurrently produces this output:\r\n```html\r\n<div>\r\n    \r\n        <span>Hello</span>\r\n    \r\n</div>\r\n```\r\n\r\nWith compression on, the output would be this instead:\r\n```html\r\n<div><span>Hello</span></div>\r\n```\r\n\r\nThis could save
```

**#24** · core · ok · 1713 ms — `gh api "/repos/casid/jte/commits?path=jte-jsp-converter&per_page=100" --jq '.[] | select((.commit.message|ascii_downcase|contains("remove")) or (.commit.message|ascii_downcase|contains("deprecat"))) | [.sha,.commit.author.date,.commit.message,.html_url] | @tsv'`

```
20de818e25d9e58fe72da15612235ffb9ef0098f	2023-10-21T01:56:38Z	Fix broken links (#290)\n\n* docs: Remove /latest/ from links to docs\r\n\r\nThe docs are not versioned, so there is not /latest/ path.\r\n\r\n* ci: Add workflow to validate links\r\n\r\n* docs: Fix broken links\r\n\r\n* fix: mvnrepository.com is not friendly to non-browsers user agents	https://github.com/casid/jte/commit/20de818e25d9e58fe72da15612235ffb9ef0098f
b11dca89f9a61ae26c140793d1958e191824883d	2023-10-20T04:23:44Z	Use MkDocs for project documentation (#288)\n\n* Markdown linting and a few uses of github notes\r\n\r\n* Fix/Improve grammar issues\r\n\r\n* docs: Move documentation to mkdocs structure\r\n\r\n* docs: Ignore site generated folder\r\n\r\n* ci: Add workflow to validate docs\r\n\r\n* ci: Add workflow to publish docs\r\n\r\nOnly publish docs for tags.\r\n\r\n* ci: Execute validate-docs workflow only on docs change\r\n\r\n* ci: No need to run mvn tasks when on docs changes\r\n\r\n* docs: Add link to hot-reloading\r\n\r\n* docs: remove mkdocs-macros plugin\r\n\r\n* docs: use teal color pallete\r\n\r\n* docs: site wide description\r\n\r\n* docs: add navigation progress indicator\r\n\r\n* docs: Move spring boot starters docs to /docs directory\r\n\r\nKeep the existing files so that they can point to the new docs.\r\n\r\n* docs: Update docs references to point to the new location\r\n\r\n* docs: move jsp converter docs to /docs\r\n\r\n* docs: move jte-models docs to /docs\r\n\r\n* dos: move jte-extension-
```
