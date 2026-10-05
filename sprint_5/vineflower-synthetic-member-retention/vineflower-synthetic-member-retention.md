Language: java
Difficulty: hard
Type: feature_request

# Reference-Aware Synthetic Retention

Add a `reference-aware-synthetic-retention` option, disabled by default, so users can prevent emitted Java from referring to a generated declaration its own output leaves out. When enabled, apply the new decision only to generated declarations that the active removal and reconstruction settings would otherwise omit: synthetic fields, methods, and member classes, and bridge methods. Declare each such member if the emitted Java of its file refers to it, and preserve its omission otherwise. Make that decision from the Java produced by the selected reconstruction settings. Where reconstruction consumes every reference to a generated member, that member remains omitted; where references remain, it is declared under the combination of reconstruction settings that produced them. When the option is disabled, output is unchanged.

A reference is a use of a member by emitted Java code that is itself part of the output. Omitted code refers to nothing, so a generated member reachable only from another omitted member is itself omitted. Text that is not code refers to nothing either, including comments and literal contents. One output file is decided as a whole: a member declared on the outermost class of a file and referred to only from a member class, local class, anonymous class, or lambda body within that same file is referred to.

Retention is decided per member. Declaring one generated member is no reason to declare its unreferenced siblings. Output that needs no generated declarations must not gain any, member for member.

The decision is deterministic for the same input: repeated runs and separate decompiler contexts agree on the same retained members, and a further round, over output that has been compiled again, agrees as well.
