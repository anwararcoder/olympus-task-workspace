# Freeze store integrity maintenance

**Category**: Feature Request

Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.

`default.fileNames` names new files and defaults to `random`. With `description`, the name derives deterministically from the rule description, with each `\r\n` counting as `\n`. Names differ per rule and, when the description contains a whole word of 4 to 120 ASCII letters or digits, keep such a word, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`.

Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor. A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store, even as a default of the given `Properties`, is rejected. When a rule is stored, either kind of strategy is given its description exactly as it is, `\r\n` line breaks included. A strategy that yields no name is rejected as soon as a name is needed.

`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted.

An entry is broken when its resolved path is not a regular file directly in the folder, including when its name is not a valid path at all. An entry is resolved when the file its name leads to yields no violations, as a file of line breaks alone (`\n`, `\r\n` or a lone `\r`) does. Violation files keep their current format, in which a carriage return inside a stored violation stays part of that violation's text. An entry is misplaced when its name is not its rule's derived one. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied.

Entries recording the same name are shared, even if nothing exists under it. Entries whose names reach the same file are shared too, including through a symbolic or hard link and when that file is outside the folder. Entries whose rules derive one name are colliding. Apart from the index, a regular file directly in the folder that no entry's name leads to, directly or through a symbolic link, is unowned. The store leaves shared entries and unowned files alone and never moves a colliding or occupied entry, though it still discards one that is broken or resolved. An entry both shared and something else stays shared. Entries whose rule descriptions differ only in their line breaks are still separate entries.

`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed. `repair` needs `default.allowStoreUpdate` and is rejected without it.

`fail` changes nothing, rejecting initialization unless the index and folder agree. A folder whose absent index may be created is examined as if that index were empty, and a rejection does not even create it. The `fail` report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name. `fail` does not need `default.allowStoreUpdate`.

An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined. The folder itself may be reached through a link.

Storing a rule writes its violations to the file its entry's name leads to, even through a symbolic link. The store rejects that write, leaving the index and the folder as they were, if the name leads to the index (under any spelling or through a symbolic or hard link), leads anywhere but directly into the folder, or, for a rule that has no entry yet, already names something or is recorded by another entry. Under `repair`, saving no violations for a known rule forgets that rule instead. Its entry is removed, and so is its file unless another entry shares that file. A shared file is kept and only the entry removed, even when that entry's name leads outside the folder. Under `repair`, saving no violations for an unknown rule stores nothing. If the file cannot be deleted, the save is rejected and the entry stays. A rule with violations keeps its entry.

Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress.
