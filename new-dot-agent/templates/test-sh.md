# test.sh — the grader contract (copy, then adapt)

`test.sh` is what the platform runs. Hard rules: executable (`new file mode 100755` in the patch —
`100644` is a generation failure), supports `--output_path <path>` (writes JUnit XML there), `base`
and `new` modes, fail-fast, NO `--bail`, NO dependency installs, NO `-mod=vendor` (agents corrupt
vendor → FAIL_TEST_BROKEN, which is OUR fairness violation). `base` runs the repo suite (excluding
the hidden tests + any known-flaky tests); `new` runs ONLY the hidden suite.

## Go

```bash
#!/bin/bash
set -eo pipefail

cd "$(dirname "$0")"

OUTPUT_PATH=""
MODE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output_path)
            OUTPUT_PATH="$2"
            shift 2
            ;;
        base|new)
            MODE="$1"
            shift
            ;;
        *)
            echo "Usage: $0 --output_path <path> {base|new}"
            exit 1
            ;;
    esac
done

if [[ -z "$MODE" ]]; then
    echo "Usage: $0 --output_path <path> {base|new}"
    exit 1
fi

run_tests() {
    local test_args=("$@")
    if [[ -n "$OUTPUT_PATH" ]]; then
        GOWORK=off go test -v "${test_args[@]}" 2>&1 | go-junit-report -set-exit-code > "$OUTPUT_PATH"
    else
        GOWORK=off go test "${test_args[@]}"
    fi
}

case "$MODE" in
    base)
        run_tests ./... -count=1 -timeout 10m
        ;;
    new)
        run_tests -tags=featurename -run ^TestFeatureContract_ ./... -count=1 -timeout 10m
        ;;
esac
```

## JVM (Maven) — adapt from a real JVM task; the contract is identical

The mechanics differ (surefire writes per-class XML you concatenate into `--output_path`), but the
two modes and the JUnit-XML output are the same. Key invocations (offline, single fork to dodge the
reused-JVM flake):

```bash
# common: MVN="mvn -B -o -Dmaven.repo.local=$M2 -DforkCount=1 -DreuseForks=false -DfailIfNoTests=false"
# base mode: run everything EXCEPT the hidden suite (+ known-flaky), exclusions are unanchored alternation
#   $MVN test -Dtest='!Hidden_abc123_Test,!KnownFlakyTest'
# new mode: run ONLY the hidden suite
#   rm -rf target/surefire-reports ; $MVN test -Dtest='Hidden_abc123_Test'
# then concatenate target/surefire-reports/TEST-*.xml into $OUTPUT_PATH
```

Notes that have cost real rounds: PATH must include `mvn` (InferConfig-style child-`mvn` calls hit
the network offline → ExceptionInInitializer on ~all base tests, looks like regression but is
environmental); cap heap (`MAVEN_OPTS=-Xmx950m -DargLine=-Xmx950m`); `GOTOOLCHAIN`/JDK pinned from
the repo's CI, not its pom `source` level; record the exact recipe in the repo knowledge file.

## Verify the harness itself (four-state) before trusting any result — see `workflows/w4-verify.md`.
