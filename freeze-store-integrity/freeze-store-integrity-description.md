# Freeze store integrity maintenance

**Category**: Feature Request

Ensure the `TextFileBasedViolationStore` maintains the integrity of its `stored.rules` index and files.

`default.integrity` can be `repair`, `fail` or `ignore`. Defaulting to `ignore` which checks nothing. `repair` and `fail` will check the index and folder during initialization.

If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path. If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved.

Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder. Any regular file directly in the folder that is not pointed to by an entry, directly or through a symbolic link, is unowned. Not including the index.

The `TextFileBasedViolationStore` will not touch any shared entries or unowned files. If an entry is shared and anything else it will remain shared.

When set to `repair` broken entries will be discarded. Resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well.

`fail` will not change anything. It will fail during initialization if the index and folder do not match. When `fail` fails it will state all entries in any state and all unowned files.

If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder. If using `repair` and saving no violations for an unknown rule nothing will be saved. If it cannot delete the file it will fail to save and leave the entry. If there are violations the rule will be saved.

Multiple stores in the same process can initialize and save rules concurrently. It will always leave a readable index and a folder that contains only the index and files from surviving entries. No store will check on a save that is currently happening.
