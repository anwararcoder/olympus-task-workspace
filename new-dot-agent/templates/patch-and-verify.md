# Patch generation, verification & workspace — exact commands

## Workspace isolation (always — never edit the shared clone)
Multiple sessions may run on the same repo; touching `repos/{repo}` corrupts patch regeneration.
```bash
WORK=$(mktemp -d)
git clone --no-local "repos/{repo}" "$WORK/{repo}" && cd "$WORK/{repo}"
git checkout $(head -n 1 .../my-work/{repo}-{problem}/BASE_COMMIT-{problem}.txt)
# (or: git worktree add --detach $WORK/{repo} <base>)
git apply .../test-{problem}.patch .../solution-{problem}.patch   # to resume from current state
# edit, regenerate, verify ONLY here; copy patches back; discard $WORK when done.
```

## Generate (test patch and solution patch are disjoint)
```bash
git checkout $(head -n 1 BASE_COMMIT-{name}.txt)
chmod 755 test.sh && git update-index --chmod=+x test.sh        # track the execute bit
git add test.sh path/to/test_file.ext
git diff --cached -- test.sh path/to/test_file.ext > test-{name}.patch
git reset
git add path/to/solution_file.ext
git diff --cached -- path/to/solution_file.ext > solution-{name}.patch
```

## Verify the patches
```bash
grep -A1 "diff --git a/test.sh b/test.sh" test-{name}.patch     # must show: new file mode 100755
grep -l "Dockerfile\|<solution symbol>" test-{name}.patch       # test patch: no solution/Dockerfile
grep "test.sh" solution-{name}.patch                            # solution patch: no test files
git apply --check --whitespace=error test-{name}.patch
git apply --check --whitespace=error solution-{name}.patch
```
**Safety-diff** every regenerated patch against its predecessor: the only changes should be exactly
what you intended. Read the solution patch as a reviewer for dead code (added symbols never
referenced) and diff noise (reformatted unrelated lines).

## Fresh four-state apply (the real proof — run in the Dockerfile)
```bash
cd repos/{repo}; git reset .; git clean -fd && git restore .
git checkout $(head -n 1 BASE_COMMIT-{name}.txt)
git apply test-{name}.patch
./test.sh --output_path /tmp/base.xml base   # S1: base PASS
./test.sh --output_path /tmp/new.xml  new    # S2: new FAIL (absent behavior, compiles)
git apply solution-{name}.patch
./test.sh --output_path /tmp/base2.xml base  # S4: base still PASS (no regression)
./test.sh --output_path /tmp/new2.xml  new   # S3: new PASS
```

## Encoding gotcha (Windows)
PowerShell `>` writes UTF-16 LE BOM that `git apply` rejects. Use `cmd /c "git diff ... > file.patch"`.
Patches must be UTF-8 (no BOM), LF line endings.

## Forbidden in the task directory
No `PLAN.md`/`SUMMARY.md`/`CHECKLIST.md`/`READY.md`, no debug/log files, no ad-hoc notes. Iteration
memory lives in `{problem-name}-ledger.md`, `{problem}-next-plan.md`, and `commit-message.txt` only.
