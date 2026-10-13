# Freeze store integrity maintenance

**Category**: Feature Request

Ensure the `TextFileBasedViolationStore` maintains the integrity of its `stored.rules` index and files.

A `RuleViolationFileNameStrategy` passed into the store's constructor gives the name each rule would generate. With the default random names no entry is ever misplaced. If a strategy generates no file name it will fail once a name is required.

`default.integrity` must be exactly one of `repair`, `fail` and `ignore`. Defaulting to `ignore` which checks nothing. `repair` and `fail` will check the index and folder during initialization. Any other value will fail stating the acceptable values.

If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path. If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved. If an entry's file name does not match the name its rule would generate it is misplaced. A misplaced entry is occupied if the name it generates already exists, is being used by another entry or points outside the folder. An entry that points to the name it would generate will never be occupied.

Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder. Entries that generate the same name are colliding. Any regular file directly in the folder that is not pointed to by an entry, directly or through a symbolic link, is unowned. Not including the index.

The `TextFileBasedViolationStore` will not touch any shared entries or unowned files. It will never move an entry that is colliding or occupied, but will still discard one that is broken or resolved. If an entry is shared and anything else it will remain shared.

When set to `repair` broken entries will be discarded. Resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well. A misplaced entry will have its file moved to the correct name. If it is a symbolic link the file it points to will be moved. Only if an entry was modified will the index be saved. To use `repair` you must enable `default.allowStoreUpdate`, or it will fail.

`fail` will not change anything. It will fail during initialization if the index and folder do not match. If there is no index but one could be created the folder will be checked as if the index was empty. If it fails the index will not be created, not even briefly. When `fail` fails it will state all entries in any state and all unowned files. You do not need `default.allowStoreUpdate` to use `fail`.

If there is no index and `default.allowStoreCreation` is false or the index is not a regular file directly within the folder it will fail before checking anything. The folder can be a link to another folder.

When a rule is saved it will write its violations to the file its entry points to. Even if that is a symbolic link. The store will fail to save a rule and leave the index and folder as they were if its file name points to the index. This includes a symbolic or hard link to it or a different spelling of its name. The same applies if the name points to a location that is not directly within the folder, or if the rule has no entry and its generated name points to something or is being used by another entry.

If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder. If using `repair` and saving no violations for an unknown rule nothing will be saved. If it cannot delete the file it will fail to save and leave the entry. If there are violations the rule will be saved.

Multiple stores in the same process can initialize and save rules concurrently. It will always leave a readable index and a folder that contains only the index and files from surviving entries. No store will check on a save that is currently happening.
