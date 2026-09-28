# Freeze store integrity maintenance

**Category**: Feature Request

Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.

`default.fileNames` names new files and defaults to `random`. With `description`, the name derives deterministically from the rule description. Names differ per rule and, when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`.

Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor. A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store, even as a default of the given `Properties`, is rejected. When a rule is stored, either kind of strategy is given its description exactly as it is, `\r\n` line breaks included. A strategy that yields no name is rejected as soon as a name is needed.

`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted.

An entry is broken when its resolved path is not a regular file directly in the folder, including when its name is not a valid path at all. It is resolved when that file yields no violations, as a file of line breaks alone (`\n`, `\r\n` or a lone `\r`) does. A carriage return inside a stored violation stays part of that violation's text. An entry is misplaced when its name is not its rule's derived one. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied.

Entries recording the same name are shared, even if nothing exists under it. So are entries whose names reach one file, as through a symbolic or hard link, even a file outside the folder. Entries whose rules derive one name are colliding. Apart from the index, a regular file directly in the folder that no entry's name leads to, directly or through a symbolic link, is unowned. The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved. An entry both shared and something else stays shared.

`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed. `repair` needs `default.allowStoreUpdate` and is rejected without it.

`fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index. Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name. `fail` reports whether or not `default.allowStoreUpdate` is set.

An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined. The folder itself may be reached through a link.

Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link. Storing is rejected, leaving the index and the folder as they were, when that name leads to the index under any spelling or through a symbolic or hard link, when it leads anywhere but directly into the folder, or when it names something its own entry does not record. Under `repair`, saving no violations for a known rule forgets that rule instead. Its entry is removed, and so is its file unless another entry shares that file. Saving no violations for an unknown rule stores nothing. If the file cannot be deleted, the save is rejected and the entry stays. A rule with violations keeps its entry.

Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress.
