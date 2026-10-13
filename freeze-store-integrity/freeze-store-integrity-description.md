# Freeze store integrity maintenance

**Category**: Feature Request

Ensure the `TextFileBasedViolationStore` maintains the integrity of its `stored.rules` index and files.

When naming files with `default.fileNames` it will default to `random`. Using `description` will produce a deterministic name based on the rule description, where all instances of `\r\n` are considered `\n`. Each rule will produce a different name. If there is a full word of 4 to 120 ascii letters and/or numbers, one such word will be used in the name, even if it appears late in a long description. Built-in file names will consist of only ascii letters, numbers, underscores and dashes. They will be at most 200 characters and never equal `stored.rules`.

Otherwise this value should be the fully-qualified name of a class that implements `RuleViolationFileNameStrategy` and has a public no-argument constructor. A strategy passed into the store's constructor will also name files. If you specify `default.fileNames` for such a store it will not be accepted, even if it is only a default of the given `Properties`. When storing a rule, both strategies will receive its description as it was written, including any `\r\n`. If a strategy generates no file name it will fail once a name is required.

`default.integrity` must be exactly one of `repair`, `fail` and `ignore`. Defaulting to `ignore` which checks nothing. `repair` and `fail` will check the index and folder during initialization. Any other value will fail stating the acceptable values.

If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path. If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved (`\n`, `\r\n` or just `\r`). The violation file format has not changed, so a `\r` inside a violation stays part of its text. If an entry's file name does not match the name its rule would generate it is misplaced. A misplaced entry is occupied if the name it generates already exists, is being used by another entry or points outside the folder. An entry that points to the name it would generate will never be occupied.

Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder. Entries that generate the same name are colliding. Any regular file directly in the folder that is not pointed to by an entry, directly or through a symbolic link, is unowned. Not including the index.

The `TextFileBasedViolationStore` will not touch any shared entries or unowned files. It will never move an entry that is colliding or occupied, but will still discard one that is broken or resolved. If an entry is shared and anything else it will remain shared. Two rules already in the index that only differ in line breaks stay separate entries. However when storing or loading a rule the line breaks will be considered equal.

When set to `repair` broken entries will be discarded. Resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well. A misplaced entry will have its file moved to the correct name. If it is a symbolic link the file it points to will be moved. Only if an entry was modified will the index be saved. To use `repair` you must enable `default.allowStoreUpdate`, or it will fail.

`fail` will not change anything. It will fail during initialization if the index and folder do not match. If there is no index but one could be created the folder will be checked as if the index was empty. If it fails the index will not be created, not even briefly. When `fail` fails it will state all entries in any state and all unowned files. It will list all broken, then resolved, then shared entries, followed by unowned files. Misplaced, colliding and occupied entries can appear anywhere. Within each state, entries will be ordered by rule description and unowned files by name. You do not need `default.allowStoreUpdate` to use `fail`.

If there is no index and `default.allowStoreCreation` is false or the index is not a regular file directly within the folder it will fail before checking anything. The folder can be a link to another folder.

When a rule is saved it will write its violations to the file its entry points to. Even if that is a symbolic link. The store will fail to save a rule and leave the index and folder as they were if its file name points to the index. This includes a symbolic or hard link to it or a different spelling of its name. The same applies if the name points to a location that is not directly within the folder, or if the rule has no entry and its generated name points to something or is being used by another entry.

If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder. If using `repair` and saving no violations for an unknown rule nothing will be saved. If it cannot delete the file it will fail to save and leave the entry. If there are violations the rule will be saved.

Multiple stores in the same process can initialize and save rules concurrently. It will always leave a readable index and a folder that contains only the index and files from surviving entries. No store will check on a save that is currently happening.
