# Freeze store integrity maintenance

**Category**: Feature Request

Ensure the `TextFileBasedViolationStore` maintains the integrity of its `stored.rules` index and files.

Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before. Defaulting to `ignore` which checks nothing.

If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path.

If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved.

Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder.

The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared.

When set to `repair` broken entries will be discarded.

When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well.

If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file or its entry is broken. In which case only the entry will be removed. Even if it points outside the folder. If using `repair` and saving no violations for an unknown rule nothing will be saved.

If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry.
