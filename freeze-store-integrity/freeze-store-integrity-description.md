# Freeze store integrity maintenance

**Category**: Feature Request

Add integrity maintenance to `TextFileBasedViolationStore` for its `stored.rules` index and its violation files, plus a setting for naming new violation files.

That setting, `default.fileNames`, defaults to `random`. With `description`, the name is derived deterministically from the rule description, with each `\r\n` counting as `\n`. Names differ per rule, and when the description contains a whole word of 4 to 120 ASCII letters or digits, the name keeps such a word, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens, are never longer than 200 characters, and are never `stored.rules`.

Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor. A strategy passed to the store's constructor names files the same way, and a store built with one rejects `default.fileNames`, even when the setting only comes from the defaults of the given `Properties`. When a rule is stored, either kind of strategy gets its description exactly as it is, `\r\n` line breaks included. A strategy that yields no name is rejected as soon as the store needs a name from it.

The second setting, `default.integrity`, takes exactly `repair`, `fail` or `ignore` and defaults to `ignore`, which examines nothing. With `repair` or `fail` the store examines the index and the folder while initializing. Any other value is rejected with a message naming the three accepted values.

An entry is broken when its resolved path isn't a regular file directly in the folder, which includes a name that isn't a valid path at all. If an entry isn't broken but the file its name leads to yields no violations, the entry is resolved; a file of nothing but line breaks (`\n`, `\r\n` or a lone `\r`) yields none. Violation files keep their current format, in which a carriage return inside a stored violation stays part of that violation's text. When an entry's name is not the one its rule derives, the entry is misplaced, and a misplaced entry is occupied if its derived name already names something, is recorded by another entry, or escapes the folder. An entry that already records its derived name is never occupied.

Entries that record the same name are shared, even when nothing exists under that name. The same goes for entries whose names reach the same file, including through a symbolic or hard link and when that file lies outside the folder. When rules derive the same name, their entries are colliding. A regular file directly in the folder is unowned when no entry's name leads to it, directly or through a symbolic link, and the index itself is never unowned.

The store leaves shared entries and unowned files alone. It never moves a colliding or occupied entry, but it still discards one that is broken or resolved. An entry that is shared and also in another condition stays shared. Entries already in the index whose rule descriptions differ only in their line breaks remain separate entries, although storing or reading a rule looks its description up with each `\r\n` counting as `\n`.

Under `repair` the store discards broken entries, and it discards resolved entries together with the files they name; when that name is a link, the link's target is deleted along with the link. `repair` also moves a misplaced entry's file to its derived name, and when the entry names a link, it moves the file the link points to instead of the link. It writes the index only when an entry has changed, and it needs `default.allowStoreUpdate`: without that, initialization is rejected.

`fail` changes nothing and rejects initialization unless the index and the folder agree. If the index is absent but may be created, the folder is examined as if the index were empty, and a rejection does not create it at all. The `fail` report names every entry in any condition and every unowned file. Broken entries come first, then resolved entries, then shared entries, and unowned files last; misplaced, colliding and occupied entries may appear anywhere in the report. Within a condition, entries are ordered by rule description and files by name. `fail` doesn't need `default.allowStoreUpdate`.

An absent index without `default.allowStoreCreation`, or an index that isn't a regular file directly in the folder, is rejected before anything is examined. Reaching the folder itself through a link is fine.

Storing a rule writes its violations to the file its entry's name leads to, following a symbolic link if the name is one. The store rejects the write and leaves the index and the folder as they were when the name leads to the index (under any spelling, or through a symbolic or hard link) or anywhere other than directly into the folder. For a rule that has no entry yet, the store also rejects the write, again leaving the index and the folder as they were, when the name already names something or is recorded by another entry.

Under `repair`, saving no violations for a known rule forgets that rule instead: its entry is removed, and so is its file unless another entry shares that file. If that file can't be deleted, the save is rejected and the entry stays. A shared file is kept and only the entry is removed, even when that entry's name leads outside the folder. Under `repair`, saving no violations for an unknown rule stores nothing, and a rule that still has violations keeps its entry.

When several stores initialize or save at the same time in one process, the index stays readable, the folder ends up holding only the index and the files of surviving entries, and no store examines a save that is still in progress.
