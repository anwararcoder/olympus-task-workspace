# Dockerfile — build/test image (copy the matching language)

Rules (all languages): use the matching `olympus-base-*` image; install deps at BUILD time so the
image works under `docker run --network none`; NO comments; **NO test execution in the Dockerfile**
(the rubric rejects `RUN go test` / `RUN pytest` / `RUN npm test` — tests run at grade time, and the
test source may not even be present at build; prewarm only with `go build ./...` / `go mod download`
/ `mvn ... -DskipTests`); avoid unpinned `apt-get install` and `|| true` masking (rely on the base
image's toolchain — it already has gcc/CGO etc.). Go: `go mod download`, never `go mod vendor`.

Custom stages, environment variables, build targets, cache helpers, paths, and temporary files must
use repository-native names. Do not copy benchmark, program, difficulty-tier, solver, grading, or
challenge vocabulary into authored identifiers. The approved base-image coordinate is an external
requirement and is the only expected program-specific text in the Dockerfile.

## Base images
```
public.ecr.aws/d3j8x8q7/olympus-base-go:latest
public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest
public.ecr.aws/d3j8x8q7/olympus-base-python:latest
public.ecr.aws/d3j8x8q7/olympus-base-typescript:latest
public.ecr.aws/d3j8x8q7/olympus-base-rust:latest
public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest
```
(In practice we ship Go and Java; the rest exist if a repo warrants it.)

## Go
```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-go:latest
ENV GOBIN=/usr/local/bin
WORKDIR /app
COPY . .
RUN GOWORK=off go mod download
RUN go install github.com/jstemmer/go-junit-report/v2@v2.1.0
CMD ["/bin/bash"]
```

## JVM (Maven)
```dockerfile
FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest
WORKDIR /app
COPY . .
RUN mvn -q -DskipTests clean install
CMD ["/bin/bash"]
```
JVM additions that have been needed on real tasks (add only when the repo requires them): pin the
JDK from the repo's CI; pre-cache the offline `~/.m2` (and surefire provider POMs) so `mvn -o` works
under `--network none`; skip known-flaky base tests via `ENV` (e.g.
`GOFLAGS`-equivalent: `MAVEN_ARGS` / a `-Dtest='!Flaky'` baked into test.sh, not the Dockerfile).
