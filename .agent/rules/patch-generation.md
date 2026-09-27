---
description: Patch generation commands and verification sequence
---

# Patch Generation Rules

## Generation Process

```bash
# 1. Ensure you're on base commit
git checkout $(head -n 1 my-work/{problem}/BASE_COMMIT-{name}.txt)

# 1.1 Ensure test.sh execute bit is tracked in git
chmod 755 test.sh
git update-index --chmod=+x test.sh

# 2. Apply your changes (copy files from work branch)

# 3. Stage test files only
git add test.sh path/to/test_file.go

# 4. Generate test patch
git diff --cached -- test.sh path/to/test_file.go > my-work/{problem}/test-{name}.patch

# 5. Reset staging
git reset

# 6. Stage solution files only
git add path/to/solution_file.go path/to/other_solution.go

# 7. Generate solution patch
git diff --cached -- path/to/solution_file.go > my-work/{problem}/solution-{name}.patch
```

## Test Patch Verification

```bash
# Must find test.sh with executable permissions
grep "new file mode 100755" test-{name}.patch | grep test.sh

# Must NOT have wrong mode for test.sh
grep -A1 "diff --git a/test.sh b/test.sh" test-{name}.patch
# If this shows 100644, fix mode and regenerate patch

# Must NOT contain solution code
grep -l "solution_function" test-{name}.patch  # Should be empty

# Must NOT contain Dockerfile or description
grep -l "Dockerfile\|Description" test-{name}.patch  # Should be empty

# Leak rule (applies to BOTH patches): no challenge/quest/olympus paths, no program names
grep -inE "challenge|quest|olympus|shipd|\bmars\b" test-{name}.patch solution-{name}.patch  # Should be empty

# Must be clean for strict whitespace apply
git apply --check --whitespace=error test-{name}.patch
```

## Solution Patch Verification

```bash
# Must NOT contain test files
grep "test.sh" solution-{name}.patch  # Should be empty

# Must NOT contain AI comments (unless repo style)
grep -E "//.*comment|/\*.*\*/|#.*comment" solution-{name}.patch  # Check carefully

# Must be clean for strict whitespace apply
git apply --check --whitespace=error solution-{name}.patch

# Optional hygiene checks (recommended)
# - UTF-8 without BOM
# - LF line endings
```

## Fresh Verification Sequence

```bash
# Start clean
cd repos/{repo}
git reset .
git clean -fd && git restore .

# Verify base commit
git checkout $(head -n 1 ../../my-work/{problem}/BASE_COMMIT-{name}.txt)

# Apply test patch
git apply ../../my-work/{problem}/test-{name}.patch

# Run base tests (must PASS)
./test.sh --output_path /tmp/base.xml base

# Run new tests (must FAIL)
./test.sh --output_path /tmp/new.xml new

# Apply solution patch
git apply ../../my-work/{problem}/solution-{name}.patch

# Run base tests (must still PASS)
./test.sh --output_path /tmp/base2.xml base

# Run new tests (must PASS)
./test.sh --output_path /tmp/new2.xml new
```

## Common Mistakes

1. **Generating from work commit**: Patch shows wrong diff
2. **Including solution in test patch**: Tests reference solution code
3. **Missing test.sh permissions**: `new file mode 100755` required
4. **test.sh recorded as 100644**: force execute bit in git (`git update-index --chmod=+x test.sh`) and regenerate test patch
5. **Including test in solution patch**: Patches overlap
6. **Windows encoding/line-ending artifacts**: patch applies with warnings or fails in strict mode
7. **PowerShell `>` redirect creates UTF-16**: On Windows, use `cmd /c "git diff ... > file.patch"` instead of PowerShell's `>` operator which creates UTF-16 LE BOM files that `git apply` rejects
8. **Dead code in solution patch**: Review the patch for unused opcodes, handlers, constructors, or methods that are defined but never called. Human reviewers will flag these. Grep for any symbols added in the patch and verify they're actually referenced

## Dockerfile Template

```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-go:latest
ENV GOBIN=/usr/local/bin
WORKDIR /app
COPY . .
RUN GOWORK=off go mod download
RUN go install github.com/jstemmer/go-junit-report/v2@v2.1.0
CMD ["/bin/bash"]
```

> **IMPORTANT (Go repos):** Use `go mod download` (NOT `go mod vendor`). Module cache is resilient to agent modifications. `-mod=vendor` in test.sh causes `FAIL_TEST_BROKEN` when agents corrupt vendor directory.

Rules:
- Use the matching language-specific `olympus-base-*` image for new submissions
- Keep every authored Docker stage, variable, target, cache helper, path, and temporary-file name
  repository-native. Do not use program, benchmark, difficulty-tier, solver, grader, task, or
  challenge framing in custom identifiers. The required base-image coordinate is exempt.
- Install dependencies at build time
- Works with `docker run --network none`
- `WORKDIR /app` exactly (other paths break imports, editable installs, and relative paths)
- Last instruction is `CMD ["/bin/bash"]`
- Must build and work WITHOUT `test.patch` or `solution.patch` applied; the platform applies them after the build. Never prewarm or reference files that only the patches create.
- NO comments (house style; the official template's comments are guidance only)
- **NO test execution in the Dockerfile** — the Dockerfile rubric rejects `RUN go test` / `RUN pytest` / `RUN npm test`. Tests run at grade time, not image build (and the test source may not even be present at build). Prewarm only with builds or dependency resolution (`go build ./...`, `go mod download`, `gradlew testClasses`).
- Rebuild the image (Build Image) after any Dockerfile change; checks and rollouts always use an image matching current content.
- **Avoid unpinned `apt-get install`** (reproducibility warning) and `|| true` masking. Rely on tools already in the base image; if a CGO toolchain (gcc) is required for tests, the language base image already provides it.

Available language-specific images:
- `public.ecr.aws/d3j8x8q7/olympus-base-python:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-typescript:latest` (TypeScript and JavaScript)
- `public.ecr.aws/d3j8x8q7/olympus-base-rust:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-go:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest`
- `public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`
