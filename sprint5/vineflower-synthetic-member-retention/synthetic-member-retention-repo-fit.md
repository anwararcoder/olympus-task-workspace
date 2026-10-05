# ✅ Repo-Fit / Scope Gate — PASS

> Verifies your task is original and fits the repo before the rest of the funnel opens.

## Summary

- **Verdict:** `PASS` · high confidence
- **Fresh:** Yes (reflects the current task version)
- **Completed:** 2026-07-31 06:26
- **Investigation:** 28 gh calls · 23 gh searches · 2 upstream requests · 101.535s

Pass. No duplicate, public implementation, removal, rejection, or repo-goal contradiction was found. One upstream issue is only a motivation/workaround precursor.

## Reasoning

The flagged prior submissions are behaviorally distinct: they concern duplicate-class selection, identifier legalization, and operand-stack simplification rather than selective retention of referenced generated declarations. Broad searches of open and closed Vineflower PRs/issues for synthetic retention, referenced synthetics, synthetic members, bridge methods, and removal settings found no public implementation of this capability, and history for the newly introduced SyntheticMemberRetention.java path is empty. Issue #522 documents the underlying missing-member symptom and a coarse workaround that disables bridge/synthetic removal globally, but it neither implements nor sketches per-member, emitted-code-aware fixed-point retention; essentially all of the task's implementation and tests remain novel. The task also aligns directly with Vineflower's stated focus on high-quality decompiler output.

## Findings (1)

### publicly-solved — Low severity

- **Claim:** Issue #522 publicly documents the missing generated-member symptom and the coarse workaround of disabling synthetic removal, but does not solve selective reference-aware retention.
- **Evidence:** "https://github.com/Vineflower/vineflower/issues/522#issuecomment-3552048534 — “Try `--remove-synthetic=0` as well”"
- **Expected:** Treat this as motivation-only prior art, not a loss of task exclusivity.
- **Why it matters:** An agent could learn that globally preserving synthetics avoids one symptom, but would still need to build the task's core emitted-code reference analysis, per-member decisions, reconstruction sensitivity, and transitive retention machinery. Estimated coverage is well under 10% of implementation work and none of the distinctive hidden-test behavior.

## Investigation Log (28 commands)

**#0** · core · ok · 531 ms — `gh api repos/Vineflower/vineflower/commits?path=src/org/jetbrains/java/decompiler/main/collectors/SyntheticMemberRetention.java --jq 'map({sha: .sha, message: .commit.message, url: .html_url})'`
→ `[]`

**#1** · core · ok · 731 ms — `gh api repos/Vineflower/vineflower/commits?path=src/org/jetbrains/java/decompiler/main/ClassWriter.java --jq '.[0:10] | map({sha: .sha, message: .commit.message, url: .html_url})'`

```
[{"message":"Fix NPE when checking generics","sha":"0d97c791265a2ec2e76485826103bffd8e4103a6","url":"https://github.com/Vineflower/vineflower/commit/0d97c791265a2ec2e76485826103bffd8e4103a6"},{"message":"Improve plugin support and hooks (#523)\n\n* Changes to plugins\n\n* More plugin work, add root processor support\n\n* Improve class pass api\n\n* Fix merge\n\n* Fix unit tests","sha":"e7b744adcd7e4c9e5fc01ec9b2da728a43cb2a8a","url":"https://github.com/Vineflower/vineflower/commit/e7b744adcd7e4c9e5fc01ec9b2da728a43cb2a8a"},{"message":"Fix infinite looping during generics checking (#549)","sha":"ce5b804f82aa8ffb3c33120f5c8b8d1584c26f8e","url":"https://github.com/Vineflower/vineflower/commit/ce5b804f82aa8ffb3c33120f5c8b8d1584c26f8e"},{"message":"Properly implement assert decompilation\n\n- Fixed asserts in interface default methods not decompiling\n- Fixed assignment asserts not decompiling properly\n- Removed empty space between asserts\n- Fixed asserts being pulled into loops\n- Fixed if statements with a single assert from creating an invalid assert\n- Added support for marking improper assert decompilation","sha":"d00eec94513d46b7ba79377a413b637c3f86a780","url":"https://github.com/Vineflower/vineflower/commit/d00eec94513d46b7ba79377a413b637c3f86a780"},{"message":"Add support for markdown javadoc (#533)","sha":"a5267e8b9f929b95e89bc1045431775c2a4642ed","url":"https://github.com/Vineflower/vineflower/commit/a5267e8b9f929b95e89bc1045431775c2a4642ed"},{"message":"Add more recor
```

**#2** · search · ok · 783 ms — `gh search prs "synthetic retention" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 30`
→ `[]`

**#3** · search · ok · 807 ms — `gh search issues "synthetic retention" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 30`
→ `[]`

**#4** · search · ok · 810 ms — `gh search prs "synthetic retention" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 30`
→ `[]`

**#5** · search · ok · 951 ms — `gh search issues "synthetic retention" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 30`
→ `[]`

**#6** · search · ok · 739 ms — `gh search prs "bridge method" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`
→ `[]`

**#7** · search · ok · 793 ms — `gh search issues "synthetic member" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`
→ `[]`

**#8** · search · ok · 817 ms — `gh search prs "synthetic member" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`

```
[{"body":"The contents of the 1.8.0 update.\r\n\r\nChangelog:\r\n\r\nThe changelog for this version is very long, so here are the highlights:\r\n* Improved the quality and cleanliness of the output\r\n* Many fixes to generics\r\n* Many fixes to loops\r\n* Dozens of bugs and crashes fixed\r\n\r\n<details>\r\n  <summary>Click here to expand the full changelog</summary>\r\n\r\n* Added ++/-- inlining when possible\r\n* Added variable renaming when there's multiple variables with the same name\r\n* Added switch statement brace enclosing when the multiple variables are in different case branches\r\n* Added switch expression in assert support\r\n* Added `Implementation-Name: Quiltflower` to jar manifest (thanks jnp!)\r\n* Added formatting on complex if-else chains (thanks Earthcomputer!)\r\n* Changed some default options: generic signatures and synthetic members are now hidden by default, pattern matching is enabled, and ternary-in-if is disabled \r\n* Improved default branch hiding on switches when it's an empty fallthrough\r\n* Improved generic casts on ternaries\r\n* Improved generic casts on assigns\r\n* Improved ternary type inference when one branch is null\r\n* Improved detection of explicit generic invocations, such as Comparator.<...>comparing()\r\n* Improved variable merging in loops (improved variable liveness calculation)\r\n* Improved if-else statement structure to prevent highly nested if-else statements\r\n* Improved conversion of labeled continues to breaks to produc
```

**#9** · search · ok · 834 ms — `gh search issues "remove synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 50`

```
[{"body":"## Vineflower version\r\n`vineflower-1.10.1.jar`\r\n\r\n## Describe the bug\r\nMy enum:\r\n```java\r\npublic enum TestEnum {\r\n\tTHING1(10f),\r\n\tTHING2(20f),\r\n\tTHING3(30f);\r\n\r\n\tpublic final float f;\r\n\tTestEnum(float f) { this.f = f; }\r\n}\r\n```\r\n\r\nCompiled with `Temurin-21.0.3+9`.\r\n\r\nDecompiled with vineflower-1.10.1.jar --remove-synthetic=false --decompile-enums=false\r\n\r\n```java\r\npublic final class TestEnum extends Enum<TestEnum> {\r\n   public static final TestEnum THING1 = new TestEnum((float)\"THING1\", 0, 10.0F);\r\n   public static final TestEnum THING2 = new TestEnum((float)\"THING2\", 1, 20.0F);\r\n   public static final TestEnum THING3 = new TestEnum((float)\"THING3\", 2, 30.0F);\r\n   public final float f;\r\n   // $VF: synthetic field\r\n   private static final TestEnum[] $VALUES = $values();\r\n\r\n   public static TestEnum[] values() {\r\n      return (TestEnum[])$VALUES.clone();\r\n   }\r\n\r\n   public static TestEnum valueOf(String name) {\r\n      return Enum.valueOf(TestEnum.class, name);\r\n   }\r\n\r\n   private TestEnum(float param1, int nullx, float f) {\r\n      super(var1, nullx);\r\n      this.f = f;\r\n   }\r\n\r\n   // $VF: synthetic method\r\n   private static TestEnum[] $values() {\r\n      return new TestEnum[]{THING1, THING2, THING3};\r\n   }\r\n}\r\n```\r\n\r\n<details><summary>Decompiled with cfr-0.152.jar --sugarenums false</summary>\r\n\r\n```java\r\n/*\r\n * Decompiled with CFR 0.152.\r\n */\r\npublic
```

**#10** · search · ok · 916 ms — `gh search prs "remove synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`

```
[{"body":"This also may allow for easier work on combination flags, like perhaps a `--no-removal` which would apply `--no-remove-bridge --no-remove-synthetic --no-remove-getclass --no-remove-empty-try-catch --no-remove-imports` or something like that","number":235,"title":"Add long option names & update help message","url":"https://github.com/Vineflower/vineflower/pull/235"}]
```

**#11** · search · ok · 919 ms — `gh search issues "remove synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`

```
[{"body":"## Vineflower version\n\n1.11.2\n\n## Describe the bug\n\nMissing attributes and methods after decompilation\n\n## Additional information\n\n<img width=\"1204\" height=\"509\" alt=\"Image\" src=\"https://github.com/user-attachments/assets/6454921a-7abd-45a3-913b-ab8fd51b0a28\" />","number":522,"title":"Missing attributes and methods after decompilation","url":"https://github.com/Vineflower/vineflower/issues/522"},{"body":"I do not see any documentation of the options to use with quiltflower.jar. All I see is the usage string when I run the jar.\r\n\r\n```\r\nUsage: java -jar quiltflower.jar [-<option>=<value>]* [<source>]+ <destination>\r\nExample: java -jar quiltflower.jar -dgs=true c:\\my\\source\\ c:\\my.jar d:\\decompiled\\\r\n```\r\n\r\nPerhaps, there should be a paragraph at least (in the wiki?) as to how to use it and a link to that paragraph on the README.md. ","number":260,"title":"Missing documentation of quiltflower.jar options","url":"https://github.com/Vineflower/vineflower/issues/260"}]
```

**#12** · search · ok · 984 ms — `gh search issues "bridge method" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 50`

```
[{"body":"## Vineflower version\n\n1.11.2\n\n## Describe the bug\n\nMissing attributes and methods after decompilation\n\n## Additional information\n\n<img width=\"1204\" height=\"509\" alt=\"Image\" src=\"https://github.com/user-attachments/assets/6454921a-7abd-45a3-913b-ab8fd51b0a28\" />","number":522,"title":"Missing attributes and methods after decompilation","url":"https://github.com/Vineflower/vineflower/issues/522"},{"body":"I do not see any documentation of the options to use with quiltflower.jar. All I see is the usage string when I run the jar.\r\n\r\n```\r\nUsage: java -jar quiltflower.jar [-<option>=<value>]* [<source>]+ <destination>\r\nExample: java -jar quiltflower.jar -dgs=true c:\\my\\source\\ c:\\my.jar d:\\decompiled\\\r\n```\r\n\r\nPerhaps, there should be a paragraph at least (in the wiki?) as to how to use it and a link to that paragraph on the README.md. ","number":260,"title":"Missing documentation of quiltflower.jar options","url":"https://github.com/Vineflower/vineflower/issues/260"}]
```

**#13** · search · ok · 1046 ms — `gh search prs "remove synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 50`

```
[{"body":"Converts lambdas to method references when javac compiles a method reference to a lambda, removes synthetic instance variable, and removes `Objects.requireNonNull`.","number":532,"title":"Convert lambdas to method references when javac compiles a method reference to a lambda","url":"https://github.com/Vineflower/vineflower/pull/532"}]
```

**#14** · search · ok · 794 ms — `gh search issues "missing synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`
→ `[]`

**#15** · search · ok · 806 ms — `gh search issues "synthetic compile" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 100`
→ `[]`

**#16** · search · ok · 818 ms — `gh search issues "missing synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 100`
→ `[]`

**#17** · search · ok · 824 ms — `gh search issues "synthetic compile" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`
→ `[]`

**#18** · search · ok · 871 ms — `gh search prs "synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`

```
[{"body":"Converts lambdas to method references when javac compiles a method reference to a lambda, removes synthetic instance variable, and removes `Objects.requireNonNull`.","number":532,"title":"Convert lambdas to method references when javac compiles a method reference to a lambda","url":"https://github.com/Vineflower/vineflower/pull/532"}]
```

**#19** · search · ok · 935 ms — `gh search prs "synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 100`

```
[{"body":"## Describe the bug\n\n\\`ExprUtil.getSyntheticParametersMask\\` looks up a constructor by descriptor on the wrapper for the target class. If the lookup returns null it throws \\`RuntimeException(\\\"Constructor X.<init>Y not found\\\")\\` — the exception bubbles all the way up to \\`Fernflower.getClassContent\\`'s try/catch and aborts the **entire enclosing class** of the call site with a \\`\\$VF: Unable to decompile class\\` stub.\n\n### Real-world trigger (Kotlin plugin)\n\n\\`KConstructor.writePrimaryConstructor\\` resugars a Kotlin default-args super call by stripping the trailing \\`DefaultConstructorMarker\\` parameter:\n\n\\`\\`\\`java\n// org/vineflower/kotlin/struct/KConstructor.java:309\nKUtils.removeArguments(invocation, DEFAULT_CONSTRUCTOR_MARKER);\nbuf.append(invocation.appendParamList(indent + 1));\n\\`\\`\\`\n\n\\`removeArguments\\` mutates the invocation's \\`stringDescriptor\\` from \\`(ZILkotlin/jvm/internal/DefaultConstructorMarker;)V\\` to \\`(ZI)V\\`. The subsequent \\`appendParamList\\` call then runs:\n\n\\`\\`\\`java\n// org/jetbrains/java/decompiler/modules/decompiler/exps/InvocationExprent.java:982\nmask = ExprUtil.getSyntheticParametersMask(newNode, stringDescriptor, lstParameters.size());\n\\`\\`\\`\n\nExprUtil dutifully looks up \\`<init>(ZI)V\\` on the target class — and that constructor never existed; the target only has \\`<init>()V\\`, \\`<init>(Z)V\\`, and the synthetic \\`<init>(ZILDefaultConstructorMarker;)V\\`. The throw at lin
```

**#20** · core · ok · 1324 ms — `gh issue view 522 --repo Vineflower/vineflower --comments`

```
author:	Earthcomputer
association:	contributor
edited:	false
status:	none
--
This is because javac has generated a *bridge method* which looks a bit like this:
```java
// bridge method
@Override
public Object call() {
  return (Object) this.call();
}

public String call() {
  // user defined method
}
```

The obfuscator has then obfuscated the user-defined method. Vineflower hides bridge methods by default, when you deobfuscate, you need to detect the user-defined methods that the bridge methods are calling, and rename them to be the same as the bridge method.

Vineflower has a setting to disable the removal of bridges. If you set `--remove-bridge=0` on the command line, you will also no longer have this issue.
--
author:	KweezyCode
association:	none
edited:	true
status:	none
--
@Earthcomputer i tried `java -jar vineflower-1.11.2.jar --remove-bridge=false minecraft_server_exc.jar newout` and `java -jar vineflower-1.11.2.jar --remove-bridge=0 minecraft_server_exc.jar newout1`
it still generates this:

```
package net.minecraft.server;

import java.util.concurrent.Callable;

class CrashReportJavaVMVersion implements Callable {
   CrashReportJavaVMVersion(CrashReport var1) {
      this.a = var1;
   }

   public String a() {
      return System.getProperty("java.vm.name") + " (" + System.getProperty("java.vm.info") + "), " + System.getProperty("java.vm.vendor");
   }
}
```

am i doing something wrong? also attribute `this.a` is missing
--
author:	Earthcomputer
association:	contri
```

**#21** · core · ok · 533 ms — `gh api repos/Vineflower/vineflower/commits?path=src/org/jetbrains/java/decompiler/main/extern/IFernflowerPreferences.java --jq '.[0:15] | map({sha: .sha, message: .commit.message, url: .html_url})'`

```
[{"message":"Add include classes option and external test","sha":"f76b862df979ab4de67148e4a874a81c4677f87b","url":"https://github.com/Vineflower/vineflower/commit/f76b862df979ab4de67148e4a874a81c4677f87b"},{"message":"Add --method-to-decompile option (#519)","sha":"376b155e52243dd9df2af10e3b055365a1c1fdf9","url":"https://github.com/Vineflower/vineflower/commit/376b155e52243dd9df2af10e3b055365a1c1fdf9"},{"message":"Include Java Runtime classes by default","sha":"aaee2ab9ee882ed3239adec85e81a93747edf5fa","url":"https://github.com/Vineflower/vineflower/commit/aaee2ab9ee882ed3239adec85e81a93747edf5fa"},{"message":"Initial if statement prettifier based on heuristics","sha":"ea380dc73cf5398e407156e3e17b9d34054ac0a8","url":"https://github.com/Vineflower/vineflower/commit/ea380dc73cf5398e407156e3e17b9d34054ac0a8"},{"message":"Add flag to detect wrong variable merges (#477)\n\n* Add flag to detect wrong variable merges\n\n* Copy dec file from ci","sha":"2e50dfff3a266336c930f4b36ba98ecbc8ee26ba","url":"https://github.com/Vineflower/vineflower/commit/2e50dfff3a266336c930f4b36ba98ecbc8ee26ba"},{"message":"Record pattern matching (#368)\n\nCo-authored-by: coehlrich \u003ccoehlrich@users.noreply.github.com\u003e","sha":"868c468c09004ea9095ef1d91d9a810556c05532","url":"https://github.com/Vineflower/vineflower/commit/868c468c09004ea9095ef1d91d9a810556c05532"},{"message":"Decompiler option access API (#418)\n\n* Add a programmatic way of getting all options, including plugin options\r\n\r\n*
```

**#22** · search · ok · 744 ms — `gh search prs "referenced synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 100`
→ `[]`

**#23** · search · ok · 750 ms — `gh search prs "remove bridge" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`
→ `[]`

**#24** · search · ok · 766 ms — `gh search prs "referenced synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`
→ `[]`

**#25** · search · ok · 812 ms — `gh search issues "referenced synthetic" --repo Vineflower/vineflower --state open --json number,title,url,body --limit 100`
→ `[]`

**#26** · search · ok · 866 ms — `gh search issues "referenced synthetic" --repo Vineflower/vineflower --state closed --json number,title,url,body --limit 100`
→ `[]`

**#27** · core · ok · 1179 ms — `gh issue view 522 --repo Vineflower/vineflower --json state,createdAt,closedAt,url,title,comments --jq '{state,createdAt,closedAt,url,title,comments:[.comments[]|{author:.author.login,body:.body,url:.url}]}'`

```
{"closedAt":"2025-11-19T10:41:40Z","comments":[{"author":"Earthcomputer","body":"This is because javac has generated a *bridge method* which looks a bit like this:\n```java\n// bridge method\n@Override\npublic Object call() {\n  return (Object) this.call();\n}\n\npublic String call() {\n  // user defined method\n}\n```\n\nThe obfuscator has then obfuscated the user-defined method. Vineflower hides bridge methods by default, when you deobfuscate, you need to detect the user-defined methods that the bridge methods are calling, and rename them to be the same as the bridge method.\n\nVineflower has a setting to disable the removal of bridges. If you set `--remove-bridge=0` on the command line, you will also no longer have this issue.","url":"https://github.com/Vineflower/vineflower/issues/522#issuecomment-3552008816"},{"author":"KweezyCode","body":"@Earthcomputer i tried `java -jar vineflower-1.11.2.jar --remove-bridge=false minecraft_server_exc.jar newout` and `java -jar vineflower-1.11.2.jar --remove-bridge=0 minecraft_server_exc.jar newout1`\nit still generates this:\n\n```\npackage net.minecraft.server;\n\nimport java.util.concurrent.Callable;\n\nclass CrashReportJavaVMVersion implements Callable {\n   CrashReportJavaVMVersion(CrashReport var1) {\n      this.a = var1;\n   }\n\n   public String a() {\n      return System.getProperty(\"java.vm.name\") + \" (\" + System.getProperty(\"java.vm.info\") + \"), \" + System.getProperty(\"java.vm.vendor\");\n   }\n}\n```\n\nam i doing
```
