# Overview

We support Java and C++ now\! Please use the new images:   
`public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest`  
`public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest`

We’ve tested this (examples Dockerfiles below) for the following repos:

* [https://github.com/apache/commons-lang](https://github.com/apache/commons-lang) (Maven 3.9.9; OpenJDK 17\)  
* [https://github.com/mockito/mockito](https://github.com/mockito/mockito) (Gradle 8.14.2; OpenJDK 17\)  
* [https://github.com/ben-manes/caffeine](https://github.com/ben-manes/caffeine) (Gradle 9.5.0; OpenJDK 17\)  
* [https://github.com/jqlang/jq](https://github.com/jqlang/jq) (clang 21; autoconf 2.71; automake 1.16.5; libtool 2.4.7; make 4.3)  
* [https://github.com/libuv/libuv](https://github.com/libuv/libuv) (clang 21; cmake 4.3.2; ninja 1.13.2; make 4.3)  
* [https://github.com/ben-manes/caffeine](https://github.com/ben-manes/caffeine) (clang++ 21; cmake 4.3.2; ctest 4.3.2)

**Tips & Footguns**

* Like submitting for other languages: the agent does not have internet access, so make sure all build / dev dependencies are installed ahead of time.  
* Cache must be writable. chmod \-R a+rX makes Gradle's daemon fail on lock files. Always a+rwX or 1777\.  
* Default JDK is 17, not 25\. Opt into JDK 25 by setting ENV JAVA\_HOME=/opt/jdk-25 in your problem's Dockerfile only when you specifically need 19+ features.  
* For Gradle, run ./gradlew \--no-daemon test \--tests \_\_nope\_\_ to compile the task graph to pull all test dependencies without running any of the tests

**Reference**  
This base image has the following common tools pre-installed:

**C/C++ toolchain**

* gcc / g++ 12 (Debian apt)  
* clang / clang++ 21 (LLVM apt repo at apt.llvm.org)  
* clang-tidy 21, clang-format 21  
* CMake 4.3.2 (Kitware binary)  
* Ninja 1.13.2 (upstream binary)  
* make, autoconf, automake, libtool, pkg-config  
* bison, flex  
* gdb  
* GoogleTest 1.17.0 (built \+ installed to /usr/local)  
* doctest 2.5.2 (single header at /usr/local/include/doctest.h)  
* libsnappy-dev (leveldb)  
* tcl (redis)

**JVM build tools**

* Maven 3.9.9 (Apache binary; replaces apt's 3.8.7)  
* Gradle 9.5.0 (default, /usr/local/bin/gradle wrapper script)  
* Gradle legacy versions (also installed at /opt/gradle-X.Y.Z): 8.10.2, 8.14.2, 8.14.3, 9.0.0  
* Pre-warmed Gradle cache at /opt/gradle-cache (mode 1777, hardlinked into /etc/skel/.gradle so \`useradd \-m model\` inherits it):  
  * com.gradle.develocity 4.4.1 (Gradle 9.5)  
  * com.gradle.develocity 4.0.2 (Gradle 9.5 \+ Gradle 8.10.2)  
  * com.gradle.develocity 4.2 (Gradle 8.14.2)  
  * Wrapper distributions for: 8.10.2, 8.14.2, 8.14.3, 9.0.0, 9.5.0 (with .ok markers)  
* Envs set:  
  * GRADLE\_USER\_HOME=/opt/gradle-cache  
  * JAVA\_HOME=/usr/lib/jvm/default-jdk (→ JDK 17\)  
  * JDK25\_HOME=/opt/jdk-25

# Java Examples

[https://github.com/apache/commons-lang](https://github.com/apache/commons-lang)

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest
WORKDIR /app
COPY . .
RUN java -version && javac -version && mvn -version
RUN mvn -B -Drat.skip=true -DfailIfNoTests=false test
CMD ["/bin/bash"]
```

[https://github.com/mockito/mockito](https://github.com/mockito/mockito)

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest
WORKDIR /app
COPY . .
RUN java -version && javac -version
RUN if [ -f ./gradlew ]; then \
        chmod +x ./gradlew && \
        ./gradlew --no-daemon --warning-mode=none assemble compileTestJava || true ; \
        ./gradlew --no-daemon --warning-mode=none dependencies --configuration testRuntimeClasspath || true ; \
        ./gradlew --no-daemon --warning-mode=none test --tests "__olympus_no_match__" || true ; \
        rm -rf /etc/skel/.gradle && cp -al /opt/gradle-cache /etc/skel/.gradle ; \
        chmod -R a+rwX /etc/skel/.gradle /opt/gradle-cache ; \
    fi

CMD ["/bin/bash"]
```

[https://github.com/ben-manes/caffeine](https://github.com/ben-manes/caffeine) 

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest
WORKDIR /app
COPY . .
RUN java -version && javac -version
RUN if [ -f ./gradlew ]; then \
        chmod +x ./gradlew && \
        ./gradlew --no-daemon --warning-mode=none assemble compileTestJava || true ; \
        ./gradlew --no-daemon --warning-mode=none dependencies --configuration testRuntimeClasspath || true ; \
        ./gradlew --no-daemon --warning-mode=none test --tests "__olympus_no_match__" || true ; \
        rm -rf /etc/skel/.gradle && cp -al /opt/gradle-cache /etc/skel/.gradle ; \
        chmod -R a+rwX /etc/skel/.gradle /opt/gradle-cache ; \
    fi
CMD ["/bin/bash"]

```

# C++ Examples

[https://github.com/jqlang/jq](https://github.com/jqlang/jq) 

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest
WORKDIR /app
COPY . .
RUN clang --version && autoconf --version | head -1
CMD ["/bin/bash"]
```

[https://github.com/libuv/libuv](https://github.com/libuv/libuv) 

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest
WORKDIR /app
COPY . .
RUN clang --version && cmake --version
CMD ["/bin/bash"]
```

[https://github.com/nlohmann/json](https://github.com/nlohmann/json)

```
FROM public.ecr.aws/d3j8x8q7/olympus-base-cpp:latest
WORKDIR /app
COPY . .
RUN clang++ --version && cmake --version
RUN git clone --depth 1 --branch v3.1.0 https://github.com/nlohmann/json_test_data.git /opt/json_test_data
ENV FETCHCONTENT_SOURCE_DIR_JSON_TEST_DATA=/opt/json_test_data
CMD ["/bin/bash"]
```
