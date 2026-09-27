---
description: Generate test and solution patches with proper verification
---

# Generate Patches

## When to Use

Run after implementing tests and solution, before submission.

> **Problem-solution log:** Before starting, search `.agent/knowledge/problem-solution-log.md` for the symptoms in front of you and apply any matching solution. After a new problem is found and its fix verified, append it to Part 3 of the log (protocol: `../rules/problem-solution-log.md`).

## Steps

### 1. Prepare Environment

```bash
cd repos/{repo}
git reset .
git clean -fd && git restore .
git checkout $(head -n 1 ../../my-work/{problem}/BASE_COMMIT-{name}.txt)
```

### 2. Copy Test Files

Copy your test files from work branch:
- `test.sh` (with `chmod 755`)
- Test source files

Then force git mode tracking (important on Windows):

```bash
git update-index --chmod=+x test.sh
```

### 3. Generate Test Patch

```bash
# Stage ONLY test files
git add test.sh path/to/test_file.go

# Generate patch
git diff --cached -- test.sh path/to/test_file.go > \
    ../../my-work/{problem}/test-{name}.patch

# Verify test.sh permissions
grep "new file mode 100755" ../../my-work/{problem}/test-{name}.patch | grep test.sh
# Should find match

# Verify test.sh block shows 100755 (not 100644)
grep -A1 "diff --git a/test.sh b/test.sh" ../../my-work/{problem}/test-{name}.patch
# If 100644 appears, run chmod/update-index and regenerate

# Reset staging
git reset
```

### 4. Copy Solution Files

Copy your solution files from work branch.

### 5. Generate Solution Patch

```bash
# Stage ONLY solution files
git add path/to/solution.go path/to/other.go

# Generate patch
git diff --cached -- path/to/solution.go path/to/other.go > \
    ../../my-work/{problem}/solution-{name}.patch

# Verify no test.sh
grep "test.sh" ../../my-work/{problem}/solution-{name}.patch
# Should be empty
```

### 6. Verify Patches

```bash
# Clean repo
git reset . && git clean -fd && git restore .

# Apply test patch
git apply ../../my-work/{problem}/test-{name}.patch

# Base tests must pass
./test.sh --output_path /tmp/base.xml base

# New tests must fail
./test.sh --output_path /tmp/new.xml new
# Expected: All FAIL (feature not implemented)

# Apply solution patch
git apply ../../my-work/{problem}/solution-{name}.patch

# Base tests still pass
./test.sh --output_path /tmp/base2.xml base

# New tests now pass
./test.sh --output_path /tmp/new2.xml new
# Expected: All PASS
```

### 7. Final Checks

- [ ] Test patch has `new file mode 100755` for test.sh
- [ ] Test patch does not record `test.sh` as `new file mode 100644`
- [ ] Test patch contains NO solution code
- [ ] Solution patch contains NO test code
- [ ] Solution patch has NO AI-style comments
- [ ] Both patches apply cleanly to base commit

## Verification Commands

```bash
# Check test.sh permissions in patch
grep "new file mode 100755" test-{name}.patch

# Check for forbidden content in test patch
grep -l "compileDestructuring\|OpHasKey" test-{name}.patch
# Should be empty (no solution function names)

# Check for forbidden content in solution patch
grep "test.sh\|_test.go" solution-{name}.patch
# Should be empty
```

## Troubleshooting

**Patch won't apply:**
- Generated from wrong commit (not base)
- File conflicts from previous patches

**test.sh not executable:**
- Missing `chmod 755 test.sh` before staging
- Permission not captured in patch

**Solution appears in test patch:**
- Tests reference solution code directly
- Need build tag isolation (`//go:build featurename`)
