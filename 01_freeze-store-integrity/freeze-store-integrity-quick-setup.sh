cat <<'EOSCRIPT' | bash
#!/bin/bash

# Clone repository and checkout commit
git clone https://github.com/tng/archunit archunit-kh76b5kmd3qae2eprydzvb9k4x8cve47 --recurse-submodules
cd archunit-kh76b5kmd3qae2eprydzvb9k4x8cve47
git checkout ab6a677dd4b678f0ab1d9481df17222916705170

# Create challenge branch
git checkout -b shipd-challenge/kh76b5kmd3qae2eprydzvb9k4x8cve47-v17

# Write problem description (reference only)
cat > problem.md << '__SHIPD_PROBLEM_CONTENT__'
Add integrity maintenance for `TextFileBasedViolationStore`'s `stored.rules` index and files.

`default.fileNames` names new files and defaults to `random`. With `description`, the name derives deterministically from the rule description. Names differ per rule, and each keeps a whole word of 4 to 120 letters or digits, even one that comes late in a long description. Built-in names use only ASCII letters, digits, underscores and hyphens. They never exceed 200 characters and are never `stored.rules`. Any other value is the fully-qualified name of a `RuleViolationFileNameStrategy` implementation with a public no-argument constructor. A strategy that yields no name is rejected as soon as a name is needed. A strategy given to the constructor names files the same way, and configuring `default.fileNames` for such a store is rejected.

`default.integrity` accepts the exact values `repair`, `fail` and `ignore`, and defaults to `ignore`, which examines nothing. `repair` and `fail` examine the index and the folder while initializing. Any other value is rejected, naming the three accepted.

An entry is broken when its resolved path is missing, a directory, outside the folder, or not a regular file directly in it. An entry is resolved when the file at that path yields no violations, including a file holding only line breaks, whether `\n`, `\r\n` or a lone `\r`, although a carriage return inside a stored violation stays part of its text. An entry is misplaced when its name is not its rule's derived one. Two entries recording the same name are shared, even if nothing exists under that name. So are two entries whose recorded names resolve to one file, as when one links to that file. One derived name two rules share is colliding. A misplaced entry is occupied when its derived name already names something, is recorded by another entry, or escapes the folder; an entry recording its derived name is never occupied. Apart from the index, a regular file directly in the folder that no entry records is unowned. The store leaves shared entries and unowned files alone. It never moves a colliding or occupied entry, but still discards one that is broken or resolved. An entry both shared and something else stays shared.

`repair` discards broken entries. It discards resolved entries with the files they name, deleting a link's target with the link. It moves a misplaced entry's file to its derived name, moving a link's target rather than the link. It writes the index only when an entry changed. `fail` changes nothing, rejecting initialization unless the index and folder agree, and a rejection does not even create an absent index. Its report names every entry in any condition and every unowned file. It reports broken, resolved and shared entries, then unowned files, in that order, and may place misplaced, colliding and occupied entries anywhere in it. Within a condition it orders entries by rule description and files by name. `repair` needs `default.allowStoreUpdate` and is rejected without it. `fail` reports either way. An absent index without `default.allowStoreCreation`, or one not a regular file directly in the folder, is rejected before anything is examined.

Storing a rule never writes over the index, anything outside the folder, or a file its own entry does not record. Such a save is rejected, leaving the index and the folder as they were. Under `repair`, storing no violations forgets a known rule, discarding its entry and its file unless another entry shares that file, and stores nothing for an unknown rule. If that file cannot be deleted, the save is rejected and the entry stays. A still violated rule keeps its entry.

Stores initializing or saving concurrently in one process leave a readable index and a folder holding only the index and survivors' files, and no store examines a save still in progress.
__SHIPD_PROBLEM_CONTENT__

# Create and apply test patch
cat > test.patch << '__SHIPD_PATCH_CONTENT__'
diff --git a/archunit/build.gradle b/archunit/build.gradle
index 5a735be8..d3be6219 100644
--- a/archunit/build.gradle
+++ b/archunit/build.gradle
@@ -152,3 +152,58 @@ assemble.dependsOn compileJdk9mainJava
 test.finalizedBy(jdk9Test, jdk16Test, jdk25Test)
 
 [spotbugsJdk9test, spotbugsJdk16test, spotbugsJdk25test]*.enabled = false
+
+def freezeMaintenanceTestOutput = layout.buildDirectory.dir("classes/java/freezeStoreMaintenanceTest")
+def freezeBaselineTestOutput = layout.buildDirectory.dir("classes/java/freezeStoreBaselineTest")
+
+tasks.register("compileFreezeStoreMaintenanceTest", JavaCompile) {
+    ext.minimumJavaVersion = JavaVersion.VERSION_1_9
+
+    dependsOn classes, compileJdk9mainJava
+    source = files("src/test/java/com/tngtech/archunit/library/freeze/FreezeStoreMaintenance_e448f3_Test.java")
+    classpath = files(sourceSets.main.output) + configurations.testCompileClasspath
+    destinationDirectory = freezeMaintenanceTestOutput
+}
+
+tasks.register("compileFreezeStoreBaselineTest", JavaCompile) {
+    ext.minimumJavaVersion = JavaVersion.VERSION_1_9
+
+    dependsOn classes, compileJdk9mainJava
+    source = files(
+            "src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreTest.java",
+            "src/test/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStoreConcurrencyTest.java",
+            "src/test/java/com/tngtech/archunit/library/freeze/FreezingArchRuleTest.java")
+    classpath = files(sourceSets.main.output) + configurations.testCompileClasspath
+    options.sourcepath = files("src/test/java")
+    destinationDirectory = freezeBaselineTestOutput
+}
+
+tasks.register("freezeStoreMaintenanceTest", Test) {
+    ext.minimumJavaVersion = JavaVersion.VERSION_1_9
+
+    dependsOn compileFreezeStoreMaintenanceTest
+    testClassesDirs = files(freezeMaintenanceTestOutput)
+    classpath = files(freezeMaintenanceTestOutput, sourceSets.main.output) + configurations.testRuntimeClasspath
+    useJUnitPlatform()
+    outputs.upToDateWhen { false }
+    filter {
+        includeTestsMatching "com.tngtech.archunit.library.freeze.FreezeStoreMaintenance_e448f3_Test"
+    }
+}
+
+tasks.register("freezeStoreBaselineTest", Test) {
+    ext.minimumJavaVersion = JavaVersion.VERSION_1_9
+
+    dependsOn compileFreezeStoreBaselineTest
+    testClassesDirs = files(freezeBaselineTestOutput)
+    classpath = files(freezeBaselineTestOutput, sourceSets.main.output) + configurations.testRuntimeClasspath
+    useJUnitPlatform()
+    // invocations of different parameterized tests would otherwise be reported under the same name
+    systemProperty "junit.jupiter.params.displayname.default", "{displayName} [{index}]"
+    outputs.upToDateWhen { false }
+    filter {
+        includeTestsMatching "com.tngtech.archunit.library.freeze.TextFileBasedViolationStoreTest"
+        includeTestsMatching "com.tngtech.archunit.library.freeze.TextFileBasedViolationStoreConcurrencyTest"
+        includeTestsMatching "com.tngtech.archunit.library.freeze.FreezingArchRuleTest"
+    }
+}
diff --git a/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezeStoreMaintenance_e448f3_Test.java b/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezeStoreMaintenance_e448f3_Test.java
new file mode 100644
index 00000000..d4da992a
--- /dev/null
+++ b/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezeStoreMaintenance_e448f3_Test.java
@@ -0,0 +1,3373 @@
+/*
+ * Copyright 2014-2026 TNG Technology Consulting GmbH
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *     http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+package com.tngtech.archunit.library.freeze;
+
+import java.io.File;
+import java.io.FileInputStream;
+import java.io.FileOutputStream;
+import java.io.IOException;
+import java.net.URISyntaxException;
+import java.nio.charset.StandardCharsets;
+import java.nio.file.Files;
+import java.nio.file.Path;
+import java.nio.file.Paths;
+import java.nio.file.StandardWatchEventKinds;
+import java.nio.file.WatchEvent;
+import java.nio.file.WatchKey;
+import java.nio.file.WatchService;
+import java.nio.file.attribute.PosixFilePermissions;
+import java.util.AbstractList;
+import java.util.ArrayList;
+import java.util.Arrays;
+import java.util.Collections;
+import java.util.LinkedHashMap;
+import java.util.LinkedHashSet;
+import java.util.List;
+import java.util.Locale;
+import java.util.Map;
+import java.util.Properties;
+import java.util.Set;
+import java.util.concurrent.CountDownLatch;
+import java.util.concurrent.TimeUnit;
+import java.util.concurrent.atomic.AtomicInteger;
+
+import com.google.common.base.Splitter;
+import com.tngtech.archunit.ArchConfiguration;
+import com.tngtech.archunit.core.domain.JavaClasses;
+import com.tngtech.archunit.core.importer.ClassFileImporter;
+import com.tngtech.archunit.lang.ArchRule;
+import com.tngtech.archunit.lang.EvaluationResult;
+import org.junit.jupiter.api.Test;
+import org.junit.jupiter.api.io.TempDir;
+import org.slf4j.LoggerFactory;
+
+import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.classes;
+import static org.assertj.core.api.Assertions.assertThat;
+import static org.assertj.core.api.Assertions.assertThatThrownBy;
+
+class FreezeStoreMaintenance_e448f3_Test {
+
+    private static final String INDEX = "stored.rules";
+    private static final AtomicInteger REQUESTS_YIELDING_NO_NAME = new AtomicInteger();
+
+    @TempDir
+    Path tempDir;
+
+    // ---------------------------------------------------------------- the setting
+
+    @Test
+    void absentSettingExaminesNothingWhileRepairDiscardsTheSameBrokenEntry() {
+        File store = folder("store");
+        index(store, "a rule", "gone");
+
+        Properties withoutSetting = properties(store);
+        initialize(withoutSetting);
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).isEmpty();
+    }
+
+    @Test
+    void ignoreExaminesNothingWhileRepairDiscardsTheSameBrokenEntry() {
+        File store = folder("store");
+        index(store, "a rule", "gone");
+
+        initialize(integrity(store, "ignore"));
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).isEmpty();
+    }
+
+    @Test
+    void ignoreExaminesNothingSoRepairStillFindsEveryCondition() {
+        File store = folder("store");
+        String sharedFile = file(store, "shared", "some violation");
+        String resolved = file(store, "resolved", "");
+        String misplacedRecorded = file(store, "misplaced-legacy", "a remaining violation\n");
+        String occupiedRecorded = file(store, "occupied-legacy", "another remaining violation\n");
+        index(store, "broken rule", "gone", "resolved rule", resolved,
+                "shared entry one", sharedFile, "shared entry two", sharedFile,
+                "misplaced rule", misplacedRecorded, "occupied rule", occupiedRecorded);
+        write(new File(store, "unowned-file"), "hand written");
+        write(new File(store, derivedNameOf("occupied rule")), "written by hand");
+
+        Map<String, byte[]> before = new LinkedHashMap<>();
+        for (String fileName : fileNames(store)) {
+            before.put(fileName, bytesOf(new File(store, fileName)));
+        }
+
+        initialize(derivedNames(store, "ignore"));
+
+        assertThat(fileNames(store)).as("ignore neither moves, deletes, nor writes anything")
+                .isEqualTo(new ArrayList<>(before.keySet()));
+        for (Map.Entry<String, byte[]> entry : before.entrySet()) {
+            assertThat(bytesOf(new File(store, entry.getKey())))
+                    .as("bytes of %s unchanged by ignore", entry.getKey()).isEqualTo(entry.getValue());
+        }
+
+        initialize(derivedNames(store, "repair"));
+
+        String misplacedDerived = derivedNameOf("misplaced rule");
+        Properties afterRepair = entries(store);
+        assertThat(afterRepair).as("ignore had examined nothing, so repair still finds every condition")
+                .doesNotContainKey("broken rule")
+                .doesNotContainKey("resolved rule")
+                .containsEntry("shared entry one", sharedFile)
+                .containsEntry("shared entry two", sharedFile)
+                .containsEntry("misplaced rule", misplacedDerived)
+                .containsEntry("occupied rule", occupiedRecorded);
+        assertThat(fileNames(store)).containsOnly(INDEX, sharedFile, misplacedDerived,
+                occupiedRecorded, derivedNameOf("occupied rule"), "unowned-file");
+        assertThat(contentOf(new File(store, derivedNameOf("occupied rule")))).isEqualTo("written by hand");
+        assertThat(contentOf(new File(store, misplacedDerived))).isEqualTo("a remaining violation\n");
+    }
+
+    @Test
+    void unknownValueIsRejectedAndNamesTheAcceptedValues() {
+        File store = folder("store");
+        index(store, "a rule", file(store, "violations", "some violation"));
+
+        assertThatThrownBy(() -> initialize(integrity(store, "prune")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("ignore")
+                .hasMessageContaining("repair")
+                .hasMessageContaining("fail");
+    }
+
+    @Test
+    void valuesNearAnAcceptedValueAreRejected() {
+        File store = folder("store");
+        index(store, "a rule", file(store, "violations", "some violation"));
+
+        for (String nearMiss : Arrays.asList("Repair", "repair ", "repairs", "IGNORE", "failed")) {
+            assertThatThrownBy(() -> initialize(integrity(store, nearMiss)))
+                    .as("value '%s'", nearMiss)
+                    .isInstanceOf(RuntimeException.class);
+        }
+    }
+
+    @Test
+    void failAcceptsAConsistentStoreAndRejectsAnInconsistentOne() {
+        File consistent = folder("consistent");
+        String kept = file(consistent, "kept", "some violation");
+        index(consistent, "a rule", kept);
+        initialize(integrity(consistent, "fail"));
+
+        File inconsistent = folder("inconsistent");
+        index(inconsistent, "another rule", "gone");
+        assertThatThrownBy(() -> initialize(integrity(inconsistent, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("another rule");
+        assertThat(entries(inconsistent)).containsOnlyKeys("another rule");
+    }
+
+    @Test
+    void repairLeavesAConsistentStoreUntouchedAndRepairsAnInconsistentOne() {
+        File consistent = folder("consistent");
+        String kept = file(consistent, "kept", "some violation");
+        index(consistent, "a rule", kept);
+        initialize(integrity(consistent, "repair"));
+        assertThat(entries(consistent)).containsOnlyKeys("a rule");
+        assertThat(fileNames(consistent)).containsOnly(INDEX, kept);
+
+        File inconsistent = folder("inconsistent");
+        index(inconsistent, "another rule", "gone");
+        initialize(integrity(inconsistent, "repair"));
+        assertThat(entries(inconsistent)).isEmpty();
+    }
+
+    // ---------------------------------------------------------------- broken entries
+
+    @Test
+    void anEntryWhoseFileIsAbsentIsBroken() {
+        File store = folder("store");
+        String present = file(store, "present", "some violation");
+        index(store, "absent rule", "not-there", "present rule", present);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("present rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, present);
+    }
+
+    @Test
+    void everyBrokenEntryIsDiscarded() {
+        File store = folder("store");
+        String present = file(store, "present", "some violation");
+        index(store, "first broken", "gone-one", "second broken", "gone-two",
+                "third broken", "gone-three", "present rule", present);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("present rule");
+    }
+
+    @Test
+    void anEntryRecordingADirectoryIsBroken() {
+        File store = folder("store");
+        assertThat(new File(store, "a-directory").mkdir()).isTrue();
+        index(store, "directory rule", "a-directory");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(new File(store, "a-directory")).isDirectory();
+    }
+
+    @Test
+    void anEntryEscapingTheStoreFolderIsBrokenAndNothingOutsideIsTouched() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "outside.txt");
+        write(outside, "precious");
+        index(store, "escaping rule", "../outside.txt");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(outside).exists();
+        assertThat(contentOf(outside)).isEqualTo("precious");
+    }
+
+    @Test
+    void anEntryRecordingAnAbsolutePathIsBrokenAndThatFileSurvives() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "absolute.txt");
+        write(outside, "precious");
+        // an absolute name denotes that very path, even where its last part also names a file in the store folder
+        String inFolder = file(store, "rooted-e448f3", "a violation\n");
+        index(store, "absolute rule", outside.getAbsolutePath(), "rooted rule", "/" + inFolder);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(outside).exists();
+        assertThat(contentOf(outside)).isEqualTo("precious");
+        assertThat(contentOf(new File(store, inFolder))).isEqualTo("a violation\n");
+    }
+
+    @Test
+    void anEntryRecordingANestedNameIsBrokenAndThatFileSurvives() {
+        File store = folder("store");
+        File nestedDir = new File(store, "nested");
+        assertThat(nestedDir.mkdirs()).isTrue();
+        File nested = new File(nestedDir, "violations");
+        write(nested, "");
+        index(store, "nested rule", "nested/violations");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(nested).exists();
+    }
+
+    @Test
+    void anEntryRecordingANameNoPathCanHoldIsBrokenBesideAHealthyOne() {
+        File store = folder("store");
+        String healthy = file(store, "healthy", "a remaining violation\n");
+        index(store, "alpha rule", "bad\u0000name", "beta rule", healthy);
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .as("the report names the entry instead of stumbling over its name")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("alpha rule");
+        assertThat(entries(store)).containsOnlyKeys("alpha rule", "beta rule");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("beta rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, healthy);
+        assertThat(contentOf(new File(store, healthy))).isEqualTo("a remaining violation\n");
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void anEntryRecordingAnotherSpellingOfAFileDirectlyInTheFolderIsNotBroken() {
+        File store = folder("store");
+        String violations = file(store, "violations", "a remaining violation\n");
+        index(store, "dotted rule", "./" + violations, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("the name resolves to a regular file directly in the folder")
+                .containsOnlyKeys("dotted rule");
+        assertThat(contentOf(new File(store, violations))).isEqualTo("a remaining violation\n");
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "ignore"));
+        assertThat(reader.getViolations(rule("dotted rule"))).containsExactly("a remaining violation");
+    }
+
+    @Test
+    void anEntryNamingALinkOutOfTheStoreFolderIsBrokenAndItsTargetSurvives() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "linked-target");
+        write(outside, "precious");
+        link(new File(store, "link-to-outside"), outside);
+        index(store, "linked rule", "link-to-outside");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(contentOf(outside)).isEqualTo("precious");
+
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void anEntryNamingALinkToAFileInTheStoreOwnsThatFile() {
+        File store = folder("store");
+        String target = file(store, "target", "a remaining violation\n");
+        link(new File(store, "link-to-target"), new File(store, target));
+        index(store, "linked rule", "link-to-target", "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("linked rule");
+        assertThat(contentOf(new File(store, target))).isEqualTo("a remaining violation\n");
+
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void aLinkNoEntryRecordsSurvivesRepairTogetherWithItsTarget() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "outside-target");
+        write(outside, "precious");
+        link(new File(store, "stray-link"), outside);
+        index(store, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(new File(store, "stray-link")).exists();
+        assertThat(contentOf(outside)).isEqualTo("precious");
+
+        initialize(integrity(store, "fail"));
+    }
+
+    // ---------------------------------------------------------------- resolved entries
+
+    @Test
+    void anEntryNamingADanglingLinkIsBroken() {
+        File store = folder("store");
+        link(new File(store, "dangling"), new File(tempDir.toFile(), "never-created"));
+        index(store, "dangling rule", "dangling");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+    }
+
+    @Test
+    void anEntryWhoseFileHoldsNoViolationsIsDiscardedTogetherWithItsFile() {
+        File store = folder("store");
+        String empty = file(store, "empty", "");
+        index(store, "resolved rule", empty);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
+
+    @Test
+    void aResolvedEntryNamingALinkDiscardsTheFileTheLinkPointsAt() {
+        File store = folder("store");
+        String target = file(store, "target", "");
+        link(new File(store, "link-to-target"), new File(store, target));
+        index(store, "resolved rule", "link-to-target");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).as("the file the entry owned is gone, not just the name that pointed at it")
+                .containsOnly(INDEX);
+        assertThat(Files.isSymbolicLink(new File(store, "link-to-target").toPath()))
+                .as("the link that named the file is gone as well, not left behind dangling").isFalse();
+
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void aFileHoldingOnlyLineBreaksIsResolvedWhileAViolationKeepsItsEntry() {
+        File store = folder("store");
+        String lineBreaks = file(store, "linebreaks", "\n\n\n");
+        String violating = file(store, "violating", "some violation\n");
+        index(store, "line break rule", lineBreaks, "violating rule", violating);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("violating rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, violating);
+    }
+
+    @Test
+    void aFileOfWindowsLineBreaksIsResolvedLikeOneOfUnixLineBreaks() {
+        File store = folder("store");
+        String windows = file(store, "windows", "\r\n\r\n");
+        String carriageReturns = file(store, "carriage-returns", "\r\r");
+        String unix = file(store, "unix", "\n\n");
+        String kept = file(store, "kept", "a violation\r\n");
+        index(store, "windows rule", windows, "carriage return rule", carriageReturns, "unix rule", unix, "kept rule", kept);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("every line-break-only file is resolved, whichever line breaks it holds")
+                .containsOnlyKeys("kept rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+    }
+
+    @Test
+    void carriageReturnsInsideStoredViolationsAreKeptWhileAFileOfLineBreaksAloneIsResolved() {
+        File store = folder("store");
+        index(store, "line break rule", file(store, "line-breaks", "\r\r\n"));
+        ArchRule ruleWithCarriageReturns = rule("a rule whose violations hold carriage returns");
+        List<String> violations = Arrays.asList("left\rright", "up\r\ndown", "plain");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "ignore"));
+        writer.save(ruleWithCarriageReturns, violations);
+        assertThat(writer.getViolations(ruleWithCarriageReturns))
+                .as("a carriage return inside a violation is part of its text").containsExactlyElementsOf(violations);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("only the file holding nothing but line breaks is resolved")
+                .containsOnlyKeys(ruleWithCarriageReturns.getDescription());
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "fail"));
+        assertThat(reader.getViolations(ruleWithCarriageReturns)).containsExactlyElementsOf(violations);
+    }
+
+    @Test
+    void anEntryHoldingOneViolationIsNotResolvedWhileAnEmptyOneIs() {
+        File store = folder("store");
+        String oneViolation = file(store, "one", "a single violation\n");
+        String empty = file(store, "none", "");
+        index(store, "keeps violations", oneViolation, "no violations", empty);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("keeps violations");
+        assertThat(fileNames(store)).containsOnly(INDEX, oneViolation);
+    }
+
+    // ---------------------------------------------------------------- shared references
+
+    @Test
+    void aNameRecordedTwiceIsSharedAndNeitherEntryNorFileIsDiscarded() {
+        File store = folder("store");
+        String shared = file(store, "shared", "");
+        index(store, "first rule", shared, "second rule", shared, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("first rule", "second rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared);
+    }
+
+    @Test
+    void twoEntriesReachingOneFileByDifferentNamesShareItAndNeitherIsDiscarded() {
+        File store = folder("store");
+        String shared = file(store, "shared", "");
+        link(new File(store, "beside-the-shared-file"), new File(store, shared));
+        index(store, "first rule", shared, "second rule", "beside-the-shared-file", "broken rule", "gone");
+
+        // here the one file lies outside the folder, reached by one name directly and by the other through a link
+        File reachingOut = folder("reaching-out");
+        File outside = new File(tempDir.toFile(), "outside.txt");
+        write(outside, "");
+        link(new File(reachingOut, "outside-link"), outside);
+        index(reachingOut, "alpha rule", "../outside.txt", "beta rule", "outside-link", "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        initialize(integrity(reachingOut, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("first rule", "second rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared, "beside-the-shared-file");
+        assertThat(entries(reachingOut)).as("entries reaching one file outside the folder")
+                .containsOnlyKeys("alpha rule", "beta rule")
+                .containsEntry("alpha rule", "../outside.txt")
+                .containsEntry("beta rule", "outside-link");
+        assertThat(Files.isSymbolicLink(new File(reachingOut, "outside-link").toPath()))
+                .as("the link one of them records").isTrue();
+        assertThat(outside).as("the file both of them reach").exists();
+    }
+
+    @Test
+    void twoEntriesNamingOneFileThroughHardLinksShareItAndNeitherIsDiscarded() {
+        File store = folder("store");
+        // both are ordinary names of files directly in the folder, and both name one and the same file
+        String first = file(store, "first-name", "");
+        hardLink(new File(store, "second-name"), new File(store, first));
+        index(store, "alpha rule", first, "beta rule", "second-name", "broken rule", "gone");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("alpha rule")
+                .hasMessageContaining("beta rule");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("entries reaching one file by hard links, empty as that file is")
+                .containsOnlyKeys("alpha rule", "beta rule")
+                .containsEntry("alpha rule", first)
+                .containsEntry("beta rule", "second-name");
+        assertThat(fileNames(store)).containsOnly(INDEX, first, "second-name");
+    }
+
+    @Test
+    void aSharedNameHoldingNoViolationsIsNotDiscardedEither() {
+        File store = folder("store");
+        String shared = file(store, "shared-empty", "");
+        String resolved = file(store, "resolved", "");
+        index(store, "first shared", shared, "second shared", shared, "resolved rule", resolved);
+
+        // the rules sharing the file derive one name, or names something else already occupies
+        File colliding = folder("colliding");
+        String collidingShared = file(colliding, "shared-empty", "");
+        index(colliding, "first shared", collidingShared, "second shared", collidingShared,
+                "resolved rule", file(colliding, "resolved", ""), "broken rule", "gone");
+        Properties oneDerivedName = integrity(colliding, "repair");
+        oneDerivedName.setProperty("default.fileNames", ConstantFileNames.class.getName());
+        File occupied = folder("occupied");
+        String occupiedShared = file(occupied, "shared-empty", "");
+        String firstOccupant = file(occupied, derivedNameOf("first shared"), "written by hand");
+        String secondOccupant = file(occupied, derivedNameOf("second shared"), "written by hand");
+        index(occupied, "first shared", occupiedShared, "second shared", occupiedShared,
+                "resolved rule", file(occupied, "resolved", ""), "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        initialize(oneDerivedName);
+        initialize(derivedNames(occupied, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("first shared", "second shared");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared);
+        assertThat(entries(colliding)).as("shared entries whose rules derive one name")
+                .containsOnlyKeys("first shared", "second shared")
+                .containsEntry("first shared", collidingShared)
+                .containsEntry("second shared", collidingShared);
+        assertThat(fileNames(colliding)).containsOnly(INDEX, collidingShared);
+        assertThat(entries(occupied)).as("shared entries whose derived names are occupied")
+                .containsOnlyKeys("first shared", "second shared")
+                .containsEntry("first shared", occupiedShared)
+                .containsEntry("second shared", occupiedShared);
+        assertThat(fileNames(occupied)).containsOnly(INDEX, occupiedShared, firstOccupant, secondOccupant);
+    }
+
+    @Test
+    void failNamesSharedEntriesAndChangesNothing() {
+        File store = folder("store");
+        String shared = file(store, "shared", "some violation");
+        index(store, "alpha rule", shared, "beta rule", shared);
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("alpha rule")
+                .hasMessageContaining("beta rule");
+        assertThat(entries(store)).containsOnlyKeys("alpha rule", "beta rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared);
+    }
+
+    @Test
+    void anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair() {
+        File store = folder("store");
+        index(store, "first shared", "vanished", "second shared", "vanished", "lone broken", "also-gone");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("lone broken")
+                .hasMessageContaining("first shared")
+                .hasMessageContaining("second shared");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store))
+                .as("entries sharing a name nothing exists under stay shared, so repair discards only the lone broken one")
+                .containsOnlyKeys("first shared", "second shared");
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
+
+    // ---------------------------------------------------------------- unowned files
+
+    @Test
+    void anUnownedFileSurvivesRepairWhileABrokenEntryIsDiscarded() {
+        File store = folder("store");
+        index(store, "broken rule", "gone");
+        write(new File(store, "notes.txt"), "written by hand");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX, "notes.txt");
+        assertThat(contentOf(new File(store, "notes.txt"))).isEqualTo("written by hand");
+    }
+
+    @Test
+    void failNamesUnownedFilesAndChangesNothing() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "a rule", kept);
+        write(new File(store, "stray"), "x");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("stray");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept, "stray");
+    }
+
+    @Test
+    void aDirectoryInTheStoreFolderIsNeverACondition() {
+        File onlyADirectory = folder("only-a-directory");
+        assertThat(new File(onlyADirectory, "subfolder").mkdir()).isTrue();
+        String kept = file(onlyADirectory, "kept", "some violation");
+        index(onlyADirectory, "a rule", kept);
+        initialize(integrity(onlyADirectory, "fail"));
+
+        File withAStrayFile = folder("with-a-stray-file");
+        String alsoKept = file(withAStrayFile, "kept", "some violation");
+        index(withAStrayFile, "a rule", alsoKept);
+        write(new File(withAStrayFile, "stray"), "x");
+        assertThatThrownBy(() -> initialize(integrity(withAStrayFile, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("stray");
+    }
+
+    @Test
+    void aFileInsideADirectoryInTheStoreFolderIsNeverACondition() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "a rule", kept, "a broken rule", "gone");
+        File subfolder = new File(store, "subfolder");
+        assertThat(subfolder.mkdir()).isTrue();
+        write(new File(subfolder, "buried"), "some violation");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a broken rule")
+                .hasMessageNotContaining("buried");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+        assertThat(contentOf(new File(subfolder, "buried"))).isEqualTo("some violation");
+    }
+
+    @Test
+    void theIndexItselfIsNeverUnowned() {
+        File onlyTheIndex = folder("only-the-index");
+        String kept = file(onlyTheIndex, "kept", "some violation");
+        index(onlyTheIndex, "a rule", kept);
+        initialize(integrity(onlyTheIndex, "fail"));
+
+        File withABrokenEntry = folder("with-a-broken-entry");
+        index(withABrokenEntry, "broken rule", "gone");
+        assertThatThrownBy(() -> initialize(integrity(withABrokenEntry, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("broken rule");
+    }
+
+    // ---------------------------------------------------------------- settledness
+
+    @Test
+    void aSecondInitializationOfARepairedFolderDiscardsNothing() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        List<String> afterFirstRepair = fileNames(store);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("kept rule");
+        assertThat(fileNames(store)).isEqualTo(afterFirstRepair);
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+    }
+
+    @Test
+    void anEntryReachingAnotherEntrysFileThroughALinkIsNeverMovedAndRepairStaysSettled() {
+        File store = folder("store");
+        String legacy = file(store, "legacy", "a remaining violation\n");
+        link(new File(store, derivedNameOf("a rule")), new File(store, legacy));
+        index(store, "a rule", derivedNameOf("a rule"), "another rule", legacy, "broken rule", "gone");
+
+        initialize(derivedNames(store, "repair"));
+        Properties afterFirstRepair = entries(store);
+        List<String> filesAfterFirstRepair = fileNames(store);
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store)).as("a second repair discards nothing").isEqualTo(afterFirstRepair);
+        assertThat(entries(store)).containsOnlyKeys("a rule", "another rule");
+        assertThat(fileNames(store)).isEqualTo(filesAfterFirstRepair);
+        assertThat(contentOf(new File(store, legacy))).isEqualTo("a remaining violation\n");
+    }
+
+    @Test
+    void aRepairedFolderPassesAFailingCheck() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone", "resolved rule", file(store, "resolved", ""));
+
+        initialize(integrity(store, "repair"));
+
+        initialize(integrity(store, "fail"));
+        assertThat(entries(store)).containsOnlyKeys("kept rule");
+    }
+
+    @Test
+    void aSeparatelyCreatedStoreObservesTheRepairedIndex() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        ViolationStore separateStore = new TextFileBasedViolationStore();
+        separateStore.initialize(integrity(store, "ignore"));
+        assertThat(separateStore.contains(rule("broken rule")))
+                .as("separate store still knows the discarded rule").isFalse();
+        assertThat(separateStore.contains(rule("kept rule")))
+                .as("separate store knows the surviving rule").isTrue();
+    }
+
+    @Test
+    void aRepairedFolderHoldsOnlyTheIndexAndTheFilesItsSurvivingEntriesRecord() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "resolved rule", file(store, "resolved", ""), "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+        assertThat(entries(store).getProperty("kept rule")).isEqualTo(kept);
+    }
+
+    @Test
+    void concurrentInitializationsLeaveAReadableIndex() throws Exception {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone", "resolved rule", file(store, "resolved", ""));
+
+        int threadCount = 4;
+        CountDownLatch start = new CountDownLatch(1);
+        CountDownLatch done = new CountDownLatch(threadCount);
+        List<Throwable> failures = new ArrayList<>();
+        for (int i = 0; i < threadCount; i++) {
+            new Thread(() -> {
+                try {
+                    start.await();
+                    initialize(integrity(store, "repair"));
+                } catch (Throwable e) {
+                    synchronized (failures) {
+                        failures.add(e);
+                    }
+                } finally {
+                    done.countDown();
+                }
+            }).start();
+        }
+        start.countDown();
+        assertThat(done.await(30, TimeUnit.SECONDS)).as("all initializations finished").isTrue();
+
+        assertThat(failures).isEmpty();
+        assertThat(entries(store)).containsOnlyKeys("kept rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+    }
+
+    @Test
+    void concurrentRepairsOfAMisplacedEntryLeaveItOnItsMovedFile() throws Exception {
+        File store = folder("store");
+        String legacy = file(store, "legacy", "a remaining violation\n");
+        index(store, "a rule", legacy);
+
+        BlockingFileNames.prepare();
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", BlockingFileNames.class.getName());
+
+        Thread first = new Thread(() -> initialize(properties));
+        Thread second = new Thread(() -> {
+            BlockingFileNames.secondRepairStarted.countDown();
+            initialize(properties);
+        });
+        first.start();
+        boolean firstEntered = BlockingFileNames.firstClassificationEntered.await(5, TimeUnit.SECONDS);
+        if (!firstEntered) {
+            BlockingFileNames.releaseFirstClassification.countDown();
+            first.join(30_000);
+        }
+        assertThat(firstEntered).as("the first repair reached the store folder").isTrue();
+        second.start();
+        assertThat(BlockingFileNames.secondRepairStarted.await(30, TimeUnit.SECONDS)).isTrue();
+        BlockingFileNames.secondClassificationEntered.await(1, TimeUnit.SECONDS);
+        BlockingFileNames.releaseFirstClassification.countDown();
+        first.join(30_000);
+        second.join(30_000);
+
+        assertThat(first.isAlive()).isFalse();
+        assertThat(second.isAlive()).isFalse();
+        assertThat(entries(store)).as("the rule is still stored after both repairs")
+                .containsOnlyKeys("a rule");
+        assertThat(entries(store).getProperty("a rule"))
+                .as("the entry records the file it was moved to").isEqualTo("derived");
+        assertThat(fileNames(store)).containsOnly(INDEX, "derived");
+        assertThat(contentOf(new File(store, "derived"))).isEqualTo("a remaining violation\n");
+
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void examiningTheFolderWhileAnotherStoreSavesANewRuleWaitsForTheSave() throws Exception {
+        File store = folder("store");
+        index(store, "broken rule", "gone");
+        ArchRule newRule = rule("a newly frozen rule");
+        ViolationStore saving = new TextFileBasedViolationStore();
+        saving.initialize(integrity(store, "repair"));
+        assertThat(entries(store)).as("the saving store repaired the folder before saving").isEmpty();
+
+        ViolationsReadOnRelease violations = new ViolationsReadOnRelease("a violation");
+        List<Throwable> failures = Collections.synchronizedList(new ArrayList<>());
+        List<Thread> threads = new ArrayList<>();
+        threads.add(new Thread(() -> saving.save(newRule, violations)));
+        for (String integrityValue : Arrays.asList("repair", "fail")) {
+            threads.add(new Thread(() -> initialize(integrity(store, integrityValue))));
+        }
+        threads.forEach(thread -> thread.setUncaughtExceptionHandler((failed, e) -> failures.add(e)));
+        Thread saver = threads.get(0);
+        List<Thread> examiners = threads.subList(1, threads.size());
+
+        saver.start();
+        boolean saveReadingViolations = violations.reading.await(30, TimeUnit.SECONDS);
+        if (saveReadingViolations) {
+            examiners.forEach(Thread::start);
+            // an examination that does not wait for the save in progress is done long before the save goes on
+            for (Thread examiner : examiners) {
+                examiner.join(2_000);
+            }
+        }
+        violations.release.countDown();
+        for (Thread thread : threads) {
+            thread.join(30_000);
+        }
+
+        assertThat(saveReadingViolations).as("the save got as far as reading the violations it stores").isTrue();
+        assertThat(threads).noneMatch(Thread::isAlive);
+        assertThat(failures).as("neither the save nor an examination of the folder failed").isEmpty();
+        assertThat(entries(store)).as("the rule saved while the folder was examined is still stored")
+                .containsOnlyKeys(newRule.getDescription());
+        String storedName = entries(store).getProperty(newRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+        assertThat(saving.getViolations(newRule)).containsExactly("a violation");
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "fail"));
+        assertThat(reader.getViolations(newRule)).containsExactly("a violation");
+    }
+
+    @Test
+    void oneStoreForgettingARuleWhileAnotherSavesItLeavesNoFileBehind() throws Exception {
+        File store = folder("store");
+        ArchRule frozenRule = rule("a frozen rule");
+        String kept = file(store, "kept", "an old violation\n");
+        index(store, frozenRule.getDescription(), kept, "broken rule", "gone");
+        ViolationStore saving = new TextFileBasedViolationStore();
+        saving.initialize(integrity(store, "repair"));
+        ViolationStore forgetting = new TextFileBasedViolationStore();
+        forgetting.initialize(integrity(store, "repair"));
+        assertThat(entries(store)).as("the stores repaired the folder before saving")
+                .containsOnlyKeys(frozenRule.getDescription());
+
+        ViolationsReadOnRelease violations = new ViolationsReadOnRelease("a violation of the held save");
+        List<Throwable> failures = Collections.synchronizedList(new ArrayList<>());
+        Thread held = new Thread(() -> saving.save(frozenRule, violations));
+        Thread forgets = new Thread(() -> forgetting.save(frozenRule, Collections.emptyList()));
+        List<Thread> threads = Arrays.asList(held, forgets);
+        threads.forEach(thread -> thread.setUncaughtExceptionHandler((failed, e) -> failures.add(e)));
+
+        held.start();
+        boolean saveReadingViolations = violations.reading.await(30, TimeUnit.SECONDS);
+        if (saveReadingViolations) {
+            forgets.start();
+            // a save that does not wait for the one in progress is done long before that one goes on
+            forgets.join(2_000);
+        }
+        violations.release.countDown();
+        for (Thread thread : threads) {
+            thread.join(30_000);
+        }
+
+        assertThat(saveReadingViolations).as("the held save got as far as reading the violations it stores").isTrue();
+        assertThat(threads).noneMatch(Thread::isAlive);
+        assertThat(failures).as("neither save failed").isEmpty();
+        assertThat(entries(store)).as("the rule the save that ran last forgot").isEmpty();
+        assertThat(fileNames(store)).as("the file of the forgotten rule went with its entry").containsOnly(INDEX);
+
+        initialize(integrity(store, "fail"));
+    }
+
+    @Test
+    void repairingTheFolderWhileAnotherStoreSavesAMisplacedRuleMovesWhatWasSaved() throws Exception {
+        File store = folder("store");
+        ArchRule frozenRule = rule("a frozen rule");
+        String legacy = file(store, "legacy-name", "an old violation\n");
+        index(store, frozenRule.getDescription(), legacy);
+        ViolationStore saving = new TextFileBasedViolationStore();
+        saving.initialize(derivedNames(store, "ignore"));
+
+        ViolationsReadOnRelease violations = new ViolationsReadOnRelease("a violation saved while repairing");
+        List<Throwable> failures = Collections.synchronizedList(new ArrayList<>());
+        Thread saver = new Thread(() -> saving.save(frozenRule, violations));
+        Thread repairer = new Thread(() -> initialize(derivedNames(store, "repair")));
+        List<Thread> threads = Arrays.asList(saver, repairer);
+        threads.forEach(thread -> thread.setUncaughtExceptionHandler((failed, e) -> failures.add(e)));
+
+        saver.start();
+        boolean saveReadingViolations = violations.reading.await(30, TimeUnit.SECONDS);
+        if (saveReadingViolations) {
+            repairer.start();
+            // a repair that does not wait for the save in progress is done long before the save goes on
+            repairer.join(2_000);
+        }
+        violations.release.countDown();
+        for (Thread thread : threads) {
+            thread.join(30_000);
+        }
+
+        assertThat(saveReadingViolations).as("the save got as far as reading the violations it stores").isTrue();
+        assertThat(threads).noneMatch(Thread::isAlive);
+        assertThat(failures).as("neither the save nor the repair failed").isEmpty();
+        String derived = derivedNameOf(frozenRule.getDescription());
+        assertThat(entries(store)).as("the entry the repair moved once the save was done")
+                .containsOnlyKeys(frozenRule.getDescription())
+                .containsEntry(frozenRule.getDescription(), derived);
+        assertThat(fileNames(store)).containsOnly(INDEX, derived);
+        assertThat(contentOf(new File(store, derived))).as("the file holds what was saved, not what it held before")
+                .isEqualTo("a violation saved while repairing\n");
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(derivedNames(store, "fail"));
+        assertThat(reader.getViolations(frozenRule)).containsExactly("a violation saved while repairing");
+    }
+
+    @Test
+    void repairingTheFolderWhileAnotherStoreSavesIntoAnEmptiedFileKeepsTheEntryAndTheFile() throws Exception {
+        File store = folder("store");
+        ArchRule frozenRule = rule("a frozen rule");
+        // a repair of the folder as it lies would discard this entry together with its file, which holds no violations
+        String emptied = file(store, "emptied", "");
+        index(store, frozenRule.getDescription(), emptied, "broken rule", "gone");
+        ViolationStore saving = new TextFileBasedViolationStore();
+        saving.initialize(integrity(store, "ignore"));
+
+        ViolationsReadOnRelease violations = new ViolationsReadOnRelease("a violation saved while repairing");
+        List<Throwable> failures = Collections.synchronizedList(new ArrayList<>());
+        Thread saver = new Thread(() -> saving.save(frozenRule, violations));
+        Thread repairer = new Thread(() -> initialize(integrity(store, "repair")));
+        List<Thread> threads = Arrays.asList(saver, repairer);
+        threads.forEach(thread -> thread.setUncaughtExceptionHandler((failed, e) -> failures.add(e)));
+
+        saver.start();
+        boolean saveReadingViolations = violations.reading.await(30, TimeUnit.SECONDS);
+        if (saveReadingViolations) {
+            repairer.start();
+            // a repair that does not wait for the save in progress is done long before the save goes on
+            repairer.join(2_000);
+        }
+        violations.release.countDown();
+        for (Thread thread : threads) {
+            thread.join(30_000);
+        }
+
+        assertThat(saveReadingViolations).as("the save got as far as reading the violations it stores").isTrue();
+        assertThat(threads).noneMatch(Thread::isAlive);
+        assertThat(failures).as("neither the save nor the repair failed").isEmpty();
+        assertThat(entries(store)).as("the rule saved while the folder was repaired")
+                .containsOnlyKeys(frozenRule.getDescription())
+                .containsEntry(frozenRule.getDescription(), emptied);
+        assertThat(fileNames(store)).containsOnly(INDEX, emptied);
+        assertThat(contentOf(new File(store, emptied))).as("the file the repair found holding violations")
+                .isEqualTo("a violation saved while repairing\n");
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "fail"));
+        assertThat(reader.getViolations(frozenRule)).containsExactly("a violation saved while repairing");
+    }
+
+    // ---------------------------------------------------------------- policy
+
+    @Test
+    void concurrentRepairAndFailLeaveAReadableIndex() throws Exception {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone", "resolved rule", file(store, "resolved", ""));
+
+        int threadCount = 6;
+        CountDownLatch start = new CountDownLatch(1);
+        CountDownLatch done = new CountDownLatch(threadCount);
+        List<Throwable> unexpected = new ArrayList<>();
+        for (int i = 0; i < threadCount; i++) {
+            String mode = i % 2 == 0 ? "repair" : "fail";
+            new Thread(() -> {
+                try {
+                    start.await();
+                    initialize(integrity(store, mode));
+                } catch (RuntimeException expected) {
+                    // fail rejects while the folder has not been repaired yet
+                } catch (Throwable e) {
+                    synchronized (unexpected) {
+                        unexpected.add(e);
+                    }
+                } finally {
+                    done.countDown();
+                }
+            }).start();
+        }
+        start.countDown();
+        assertThat(done.await(30, TimeUnit.SECONDS)).as("all initializations finished").isTrue();
+
+        assertThat(unexpected).isEmpty();
+        assertThat(entries(store)).containsOnlyKeys("kept rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+    }
+
+    @Test
+    void repairWithoutPermissionToUpdateIsRejectedAndChangesNothing() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone");
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.allowStoreUpdate", "false");
+
+        assertThatThrownBy(() -> initialize(properties)).isInstanceOf(RuntimeException.class);
+        assertThat(entries(store)).containsOnlyKeys("kept rule", "broken rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+    }
+
+    @Test
+    void repairWithoutPermissionToUpdateIsRejectedEvenForAConsistentStore() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept);
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.allowStoreUpdate", "false");
+
+        assertThatThrownBy(() -> initialize(properties)).isInstanceOf(RuntimeException.class);
+    }
+
+    @Test
+    void failWithoutPermissionToUpdateStillReportsTheInconsistency() {
+        File store = folder("store");
+        index(store, "broken rule", "gone");
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.allowStoreUpdate", "false");
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("broken rule");
+    }
+
+    @Test
+    void anAbsentIndexWithoutPermissionToCreateIsRejectedBeforeAnythingIsExamined() {
+        File store = folder("store");
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.allowStoreCreation", "false");
+
+        assertThatThrownBy(() -> initialize(properties)).isInstanceOf(RuntimeException.class);
+        assertThat(new File(store, INDEX)).doesNotExist();
+
+        // fail names every unowned file it finds, so a rejection naming none has examined nothing
+        File unexamined = folder("unexamined");
+        write(new File(unexamined, "notes.txt"), "written by hand");
+        Properties failing = integrity(unexamined, "fail");
+        failing.setProperty("default.allowStoreCreation", "false");
+        assertThatThrownBy(() -> initialize(failing))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageNotContaining("notes.txt");
+        assertThat(fileNames(unexamined)).containsOnly("notes.txt");
+
+        index(store, "broken rule", "gone");
+        initialize(properties);
+        assertThat(entries(store)).isEmpty();
+    }
+
+    @Test
+    void failRejectingAFolderThatHasNoIndexYetLeavesItWithoutOne() throws Exception {
+        File store = folder("store");
+        write(new File(store, "notes.txt"), "written by hand");
+
+        try (WatchService watcher = store.toPath().getFileSystem().newWatchService()) {
+            store.toPath().register(watcher, StandardWatchEventKinds.ENTRY_CREATE);
+
+            assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                    .isInstanceOf(RuntimeException.class)
+                    .hasMessageContaining("notes.txt");
+
+            assertThat(new File(store, INDEX)).as("a rejecting fail creates no index").doesNotExist();
+            assertThat(fileNames(store)).containsOnly("notes.txt");
+            assertThat(contentOf(new File(store, "notes.txt"))).isEqualTo("written by hand");
+            assertThat(namesCreatedIn(store, watcher))
+                    .as("a rejecting fail does not create an index even for a moment, deleting it again afterwards")
+                    .doesNotContain(INDEX);
+        }
+    }
+
+    @Test
+    void anIndexThatIsALinkOutOfTheStoreFolderIsRejectedAndItsTargetSurvives() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "outside-index");
+        write(outside, "a rule=gone\n");
+        link(new File(store, INDEX), outside);
+
+        assertThatThrownBy(() -> initialize(integrity(store, "repair"))).isInstanceOf(RuntimeException.class);
+        assertThat(contentOf(outside)).as("nothing outside the store folder was written")
+                .isEqualTo("a rule=gone\n");
+    }
+
+    @Test
+    void anIndexThatIsALinkToAFileInTheStoreFolderIsRejectedBeforeAnythingIsExamined() {
+        File store = folder("store");
+        // the link is no regular file itself, however ordinary the file directly in the folder it points at is
+        File linkedTo = new File(store, "index-file");
+        file(store, "kept", "a remaining violation\n");
+        write(new File(store, "notes.txt"), "written by hand");
+        index(store, "kept rule", "kept", "broken rule", "gone");
+        assertThat(new File(store, INDEX).renameTo(linkedTo)).isTrue();
+        link(new File(store, INDEX), linkedTo);
+        byte[] linkedToBefore = bytesOf(linkedTo);
+
+        for (String integrityValue : Arrays.asList("repair", "fail")) {
+            // fail names every unowned file it finds and repair discards every broken entry,
+            // so a rejection naming neither has examined nothing
+            assertThatThrownBy(() -> initialize(integrity(store, integrityValue)))
+                    .as("initializing with %s", integrityValue)
+                    .isInstanceOf(RuntimeException.class)
+                    .hasMessageNotContaining("notes.txt")
+                    .hasMessageNotContaining("broken rule");
+            assertThat(bytesOf(linkedTo)).as("the file the index links to after initializing with %s", integrityValue)
+                    .isEqualTo(linkedToBefore);
+        }
+
+        assertThat(Files.isSymbolicLink(new File(store, INDEX).toPath())).as("the index is still the link").isTrue();
+        assertThat(fileNames(store)).containsOnly(INDEX, "index-file", "kept", "notes.txt");
+    }
+
+    @Test
+    void anIndexThatCannotBeReadIsRejectedWhileASoundStoreIsStillRepaired() {
+        File unreadable = folder("unreadable");
+        assertThat(new File(unreadable, INDEX).mkdirs()).isTrue();
+        write(new File(unreadable, "notes.txt"), "written by hand");
+        write(new File(unreadable, "violations"), "a violation\n");
+        Map<String, byte[]> before = new LinkedHashMap<>();
+        for (String fileName : fileNames(unreadable)) {
+            before.put(fileName, bytesOf(new File(unreadable, fileName)));
+        }
+
+        assertThatThrownBy(() -> initialize(integrity(unreadable, "repair"))).isInstanceOf(RuntimeException.class);
+        assertThatThrownBy(() -> initialize(integrity(unreadable, "fail"))).isInstanceOf(RuntimeException.class);
+
+        assertThat(new File(unreadable, INDEX)).isDirectory();
+        assertThat(fileNames(unreadable)).isEqualTo(new ArrayList<>(before.keySet()));
+        for (Map.Entry<String, byte[]> entry : before.entrySet()) {
+            assertThat(bytesOf(new File(unreadable, entry.getKey())))
+                    .as("bytes of %s", entry.getKey()).isEqualTo(entry.getValue());
+        }
+
+        File sound = folder("sound");
+        String kept = file(sound, "kept", "some violation");
+        index(sound, "kept rule", kept, "broken rule", "gone");
+
+        initialize(integrity(sound, "repair"));
+
+        assertThat(entries(sound)).as("a store whose index can be read is repaired all the same")
+                .containsOnlyKeys("kept rule");
+        assertThat(fileNames(sound)).containsOnly(INDEX, kept);
+    }
+
+    // ---------------------------------------------------------------- reporting order
+
+    @Test
+    void failNamesTheConditionsInTheStatedOrder() {
+        File store = folder("store");
+        String sharedFile = file(store, "shared", "some violation");
+        index(store, "broken entry", "gone",
+                "resolved entry", file(store, "resolved", ""),
+                "shared entry one", sharedFile,
+                "shared entry two", sharedFile);
+        write(new File(store, "unowned-file"), "x");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "broken entry", "resolved entry", "shared entry one", "unowned-file"))
+                        .as("order of reported conditions")
+                        .isSorted());
+    }
+
+    @Test
+    void failOrdersEntriesWithinAConditionByRuleDescriptionAndFilesByName() {
+        File store = folder("store");
+        index(store, "zulu broken", "gone-one", "alpha broken", "gone-two");
+        write(new File(store, "zulu-unowned"), "x");
+        write(new File(store, "alpha-unowned"), "x");
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> {
+                    assertThat(positionsOf(thrown.getMessage(), "alpha broken", "zulu broken"))
+                            .as("order of broken entries").isSorted();
+                    assertThat(positionsOf(thrown.getMessage(), "alpha-unowned", "zulu-unowned"))
+                            .as("order of unowned files").isSorted();
+                });
+    }
+
+    @Test
+    void failOrdersSharedEntriesByRuleDescription() {
+        File store = folder("store");
+        String late = file(store, "z-shared", "some violation");
+        String early = file(store, "a-shared", "some violation");
+        index(store, "zulu shared", late, "alpha shared", late, "mike shared", early, "november shared", early);
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "alpha shared", "mike shared", "november shared", "zulu shared"))
+                        .as("order of shared entries, whose recorded names sort the other way round")
+                        .isSorted());
+    }
+
+    @Test
+    void failOrdersMisplacedEntriesByRuleDescription() {
+        File store = folder("store");
+        index(store, "zulu misplaced", file(store, "zulu-legacy", "a remaining violation\n"),
+                "alpha misplaced", file(store, "alpha-legacy", "a remaining violation\n"),
+                "mike misplaced", file(store, "mike-legacy", "a remaining violation\n"));
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "alpha misplaced", "mike misplaced", "zulu misplaced"))
+                        .as("order of misplaced entries")
+                        .isSorted());
+    }
+
+    @Test
+    void failOrdersCollidingEntriesByRuleDescription() {
+        File store = folder("store");
+        index(store, "zulu colliding", file(store, "a-legacy", "a remaining violation\n"),
+                "alpha colliding", file(store, "z-legacy", "a remaining violation\n"),
+                "mike colliding", file(store, "n-legacy", "a remaining violation\n"));
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "alpha colliding", "mike colliding", "zulu colliding"))
+                        .as("order of colliding entries")
+                        .isSorted());
+    }
+
+    @Test
+    void failOrdersOccupiedEntriesByRuleDescription() {
+        File store = folder("store");
+        index(store, "zulu occupied", file(store, "zulu-legacy", "a remaining violation\n"),
+                "alpha occupied", file(store, "alpha-legacy", "a remaining violation\n"),
+                "mike occupied", file(store, "mike-legacy", "a remaining violation\n"));
+        InvertedOrderFileNames invertedNames = new InvertedOrderFileNames();
+        for (String ruleDescription : Arrays.asList("zulu occupied", "alpha occupied", "mike occupied")) {
+            assertThat(new File(store, invertedNames.createRuleFileName(ruleDescription)).mkdir()).isTrue();
+        }
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.fileNames", InvertedOrderFileNames.class.getName());
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "alpha occupied", "mike occupied", "zulu occupied"))
+                        .as("order of occupied entries, whose derived names sort the other way round")
+                        .isSorted());
+    }
+
+    @Test
+    void failOrdersMisplacedEntriesByRuleDescriptionAndNotByTheirDerivedNames() {
+        File store = folder("store");
+        index(store, "zulu misplaced", file(store, "zulu-legacy", "a remaining violation\n"),
+                "alpha misplaced", file(store, "alpha-legacy", "a remaining violation\n"),
+                "mike misplaced", file(store, "mike-legacy", "a remaining violation\n"));
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.fileNames", InvertedOrderFileNames.class.getName());
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .satisfies(thrown -> assertThat(positionsOf(thrown.getMessage(),
+                        "alpha misplaced", "mike misplaced", "zulu misplaced"))
+                        .as("order of misplaced entries, whose derived names sort the other way round")
+                        .isSorted());
+    }
+
+    @Test
+    void failWithSeveralConditionsAtOnceChangesNotOneByte() {
+        File store = folder("store");
+        String sharedFile = file(store, "shared", "some violation");
+        String kept = file(store, "kept", "another violation");
+        String resolved = file(store, "resolved", "");
+        index(store, "kept rule", kept, "broken rule", "gone", "resolved rule", resolved,
+                "shared entry one", sharedFile, "shared entry two", sharedFile);
+        write(new File(store, "unowned-file"), "hand written");
+
+        Map<String, byte[]> before = new LinkedHashMap<>();
+        for (String fileName : fileNames(store)) {
+            before.put(fileName, bytesOf(new File(store, fileName)));
+        }
+
+        assertThatThrownBy(() -> initialize(integrity(store, "fail"))).isInstanceOf(RuntimeException.class);
+
+        assertThat(fileNames(store)).isEqualTo(new ArrayList<>(before.keySet()));
+        for (Map.Entry<String, byte[]> entry : before.entrySet()) {
+            assertThat(bytesOf(new File(store, entry.getKey())))
+                    .as("bytes of %s", entry.getKey()).isEqualTo(entry.getValue());
+        }
+    }
+
+    // ---------------------------------------------------------------- freezing again
+
+    @Test
+    void aRuleWhoseEntryWasDiscardedIsNoLongerFrozen() {
+        File store = folder("store");
+        ArchRule resolvedRule = rule("classes should be public for maintenance");
+        index(store, resolvedRule.getDescription(), file(store, "resolved", ""));
+
+        initialize(integrity(store, "repair"));
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "ignore"));
+        assertThat(reader.contains(resolvedRule)).as("resolved rule is still frozen").isFalse();
+    }
+
+    @Test
+    void repairKeepsAStillViolatingRuleFrozenWithItsViolations() {
+        File store = folder("store");
+        ArchRule violatingRule = rule("classes should be private for maintenance");
+        String violations = file(store, "violations", "one remaining violation\n");
+        index(store, violatingRule.getDescription(), violations, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "ignore"));
+        assertThat(reader.contains(violatingRule)).as("still violating rule stays frozen").isTrue();
+        assertThat(reader.getViolations(violatingRule)).containsExactly("one remaining violation");
+        assertThat(entries(store)).as("the broken entry beside it is discarded")
+                .containsOnlyKeys(violatingRule.getDescription());
+    }
+
+    @Test
+    void aRepairedStoreCanFreezeARuleAgain() {
+        File store = folder("store");
+        ArchRule refrozenRule = rule("classes should be public after maintenance");
+        index(store, refrozenRule.getDescription(), file(store, "resolved", ""));
+
+        initialize(integrity(store, "repair"));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "ignore"));
+        writer.save(refrozenRule, Arrays.asList("a new violation"));
+
+        assertThat(writer.contains(refrozenRule)).as("rule is frozen again").isTrue();
+        assertThat(writer.getViolations(refrozenRule)).containsExactly("a new violation");
+        assertThat(entries(store)).containsOnlyKeys(refrozenRule.getDescription());
+        assertThat(fileNames(store)).as("the resolved file was discarded, not reused")
+                .doesNotContain("resolved");
+    }
+
+    @Test
+    void aRuleDiscardedByRepairFreezesAfreshOnTheNextFreezingArchRuleEvaluation() {
+        File store = folder("store");
+        ArchRule refrozenRule = rule("classes should be public after a real freezing evaluation");
+        index(store, refrozenRule.getDescription(), file(store, "resolved", ""));
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).as("the resolved entry was discarded by repair").isEmpty();
+
+        JavaClasses classes = new ClassFileImporter().importClasses(getClass());
+        EvaluationResult result = ArchConfiguration.withThreadLocalScope(configuration -> {
+            configuration.setProperty("freeze.store.default.path", store.getAbsolutePath());
+            configuration.setProperty("freeze.store.default.allowStoreCreation", "true");
+            return FreezingArchRule.freeze(refrozenRule).persistIn(new TextFileBasedViolationStore()).evaluate(classes);
+        });
+
+        assertThat(result.hasViolation()).as("a rule freezing for the first time always passes").isFalse();
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(integrity(store, "ignore"));
+        assertThat(reader.contains(refrozenRule)).as("the real evaluation froze the rule again").isTrue();
+        assertThat(fileNames(store)).as("the resolved file was discarded, not reused")
+                .doesNotContain("resolved");
+    }
+
+    // ---------------------------------------------------------------- derived file names
+
+    @Test
+    void randomFileNamesDeriveNothingSoNoEntryIsMisplaced() {
+        File store = folder("store");
+        String arbitrary = file(store, "arbitrary-name", "some violation");
+        index(store, "a rule", arbitrary, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(arbitrary);
+    }
+
+    @Test
+    void namingRandomExplicitlyDerivesNothingSoNoEntryIsMisplaced() {
+        File store = folder("store");
+        String arbitrary = file(store, "arbitrary-name", "some violation");
+        index(store, "a rule", arbitrary, "broken rule", "gone");
+
+        initialize(builtInNames(store, "repair", "random"));
+
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(entries(store).getProperty("a rule"))
+                .as("a name that derives nothing is never relocated").isEqualTo(arbitrary);
+        assertThat(fileNames(store)).containsOnly(INDEX, arbitrary);
+
+        initialize(builtInNames(store, "fail", "random"));
+    }
+
+    @Test
+    void aStrategyGivenToTheConstructorNamesFilesAndMovesAnEntryRecordingAnotherName() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded, "broken rule", "gone");
+
+        ViolationStore writer = new TextFileBasedViolationStore(new DescriptionFileNames());
+        writer.initialize(integrity(store, "repair"));
+
+        String derived = derivedNameOf("a rule");
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(derived);
+        assertThat(fileNames(store)).containsOnly(INDEX, derived);
+        assertThat(contentOf(new File(store, derived))).isEqualTo("a remaining violation\n");
+
+        ArchRule newRule = rule("a newly discovered rule");
+        writer.save(newRule, Arrays.asList("a fresh violation"));
+
+        String newDerived = derivedNameOf(newRule.getDescription());
+        assertThat(entries(store).getProperty(newRule.getDescription())).isEqualTo(newDerived);
+        assertThat(fileNames(store)).containsOnly(INDEX, derived, newDerived);
+        assertThat(contentOf(new File(store, newDerived))).isEqualTo("a fresh violation\n");
+    }
+
+    @Test
+    void aStrategyGivenToTheConstructorTogetherWithTheSettingIsRejectedAndChangesNothing() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+
+        assertThatThrownBy(() -> new TextFileBasedViolationStore(new DescriptionFileNames())
+                .initialize(builtInNames(store, "repair", "description")))
+                .isInstanceOf(RuntimeException.class);
+
+        assertThat(fileNames(store)).containsOnly(INDEX, recorded);
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+    }
+
+    @Test
+    void aStrategyGivenToTheConstructorYieldingNoNameIsRejectedWhileExaminingAConsistentStore() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        for (TextFileBasedViolationStore.RuleViolationFileNameStrategy yieldingNoName
+                : Arrays.asList(new NullFileNames(), new EmptyFileNames())) {
+            for (String integrityValue : Arrays.asList("repair", "fail")) {
+                assertThatThrownBy(() -> new TextFileBasedViolationStore(yieldingNoName)
+                        .initialize(integrity(store, integrityValue)))
+                        .as("strategy '%s' under '%s'", yieldingNoName.getClass().getSimpleName(), integrityValue)
+                        .isInstanceOf(RuntimeException.class);
+            }
+        }
+
+        assertThat(bytesOf(new File(store, INDEX))).isEqualTo(indexBefore);
+        assertThat(fileNames(store)).containsOnly(INDEX, recorded);
+    }
+
+    @Test
+    void absentFileNamesGivesEveryRuleItsOwnUsableNameAndRelocatesNone() {
+        File store = folder("store");
+        index(store, "broken rule", "gone");
+        ArchRule oneRule = rule("services should not access controllers");
+        ArchRule otherRule = rule("controllers should not access services");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "repair"));
+        writer.save(oneRule, Arrays.asList("a violation"));
+        writer.save(otherRule, Arrays.asList("another violation"));
+
+        String oneName = entries(store).getProperty(oneRule.getDescription());
+        String otherName = entries(store).getProperty(otherRule.getDescription());
+        assertThat(oneName).matches("[A-Za-z0-9_-]+").isNotEqualTo(otherName).isNotEqualTo(INDEX)
+                .hasSizeLessThanOrEqualTo(200);
+        assertThat(otherName).matches("[A-Za-z0-9_-]+").isNotEqualTo(INDEX).hasSizeLessThanOrEqualTo(200);
+        assertThat(entries(store)).as("the broken entry was discarded")
+                .containsOnlyKeys(oneRule.getDescription(), otherRule.getDescription());
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store).getProperty(oneRule.getDescription()))
+                .as("a random name is never relocated").isEqualTo(oneName);
+        assertThat(fileNames(store)).containsOnly(INDEX, oneName, otherName);
+    }
+
+    @Test
+    void aConfiguredStrategyNamesNewlyStoredRules() {
+        File store = folder("store");
+        index(store);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(derivedNames(store, "ignore"));
+        ArchRule storedRule = rule("a stored rule");
+        writer.save(storedRule, Arrays.asList("a violation"));
+
+        assertThat(entries(store).getProperty(storedRule.getDescription())).isEqualTo(derivedNameOf(storedRule.getDescription()));
+        assertThat(fileNames(store)).containsOnly(INDEX, derivedNameOf(storedRule.getDescription()));
+    }
+
+    @Test
+    void aStrategyDeclaringAPublicNoArgumentConstructorNamesTheFilesItMovesAndSaves() {
+        File store = folder("store");
+        String legacy = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", legacy);
+        // the configured class declares the public no-argument constructor the setting asks for
+        ExplicitConstructorFileNames strategy = new ExplicitConstructorFileNames();
+        String derived = strategy.createRuleFileName("a rule");
+        ArchRule newRule = rule("a newly stored rule");
+        String newDerived = strategy.createRuleFileName(newRule.getDescription());
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "repair", ExplicitConstructorFileNames.class.getName()));
+        writer.save(newRule, Arrays.asList("a violation"));
+
+        assertThat(entries(store)).as("entries named by the configured strategy")
+                .containsOnlyKeys("a rule", newRule.getDescription())
+                .containsEntry("a rule", derived)
+                .containsEntry(newRule.getDescription(), newDerived);
+        assertThat(fileNames(store)).containsOnly(INDEX, derived, newDerived);
+        assertThat(contentOf(new File(store, derived))).isEqualTo("a remaining violation\n");
+        assertThat(contentOf(new File(store, newDerived))).isEqualTo("a violation\n");
+    }
+
+    @Test
+    void aStrategyThatCannotBeInstantiatedIsRejected() {
+        File store = folder("store");
+        index(store, "a rule", file(store, "violations", "some violation"));
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", "com.tngtech.archunit.library.freeze.NoSuchNamingStrategy");
+
+        assertThatThrownBy(() -> initialize(properties)).isInstanceOf(RuntimeException.class);
+    }
+
+    @Test
+    void aStrategyOfTheWrongTypeOrWithoutANoArgumentConstructorIsRejected() {
+        File store = folder("store");
+        String violations = file(store, "violations", "some violation");
+        index(store, "a rule", violations);
+
+        List<String> unusable = Arrays.asList(
+                NotARuleViolationFileNameStrategy.class.getName(),
+                FileNamesWithoutANoArgumentConstructor.class.getName(),
+                FileNamesWithAPrivateNoArgumentConstructor.class.getName());
+        for (String strategyClassName : unusable) {
+            Properties properties = integrity(store, "repair");
+            properties.setProperty("default.fileNames", strategyClassName);
+
+            assertThatThrownBy(() -> initialize(properties)).as("strategy '%s'", strategyClassName)
+                    .isInstanceOf(RuntimeException.class);
+        }
+
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, violations);
+    }
+
+    @Test
+    void aStrategyYieldingNoNameIsRejectedWhileExaminingAConsistentStore() {
+        File store = folder("store");
+        String violations = file(store, "violations", "some violation");
+        index(store, "a rule", violations);
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        for (String strategyClassName : Arrays.asList(NullFileNames.class.getName(), EmptyFileNames.class.getName())) {
+            for (String integrityValue : Arrays.asList("repair", "fail")) {
+                Properties properties = builtInNames(store, integrityValue, strategyClassName);
+
+                assertThatThrownBy(() -> initialize(properties))
+                        .as("strategy '%s' under '%s'", strategyClassName, integrityValue)
+                        .isInstanceOf(RuntimeException.class);
+            }
+        }
+
+        assertThat(bytesOf(new File(store, INDEX))).isEqualTo(indexBefore);
+        assertThat(fileNames(store)).containsOnly(INDEX, violations);
+    }
+
+    @Test
+    void aStrategyYieldingNoNameIsRejectedWithoutChangingTheStore() {
+        File store = folder("store");
+        String violations = file(store, "violations", "some violation");
+        index(store, "a rule", violations);
+
+        List<String> yieldingNoName = Arrays.asList(
+                NullFileNames.class.getName(), EmptyFileNames.class.getName());
+        for (String strategyClassName : yieldingNoName) {
+            ViolationStore writer = new TextFileBasedViolationStore();
+            Properties properties = builtInNames(store, "ignore", strategyClassName);
+            REQUESTS_YIELDING_NO_NAME.set(0);
+
+            writer.initialize(properties);
+            assertThat(REQUESTS_YIELDING_NO_NAME)
+                    .as("ignore examines nothing, so strategy '%s' is asked for no name while initializing", strategyClassName)
+                    .hasValue(0);
+
+            assertThatThrownBy(() -> writer.save(rule("another rule"), Arrays.asList("a violation")))
+                    .as("strategy '%s' once the new rule needs a name", strategyClassName)
+                    .isInstanceOf(RuntimeException.class);
+            assertThat(REQUESTS_YIELDING_NO_NAME)
+                    .as("strategy '%s' was asked for the name the new rule needs", strategyClassName)
+                    .hasPositiveValue();
+
+            assertThat(fileNames(store)).as("strategy '%s' wrote a file all the same", strategyClassName)
+                    .containsOnly(INDEX, violations);
+            assertThat(contentOf(new File(store, violations))).isEqualTo("some violation");
+        }
+    }
+
+    // ---------------------------------------------------------------- misplaced entries
+
+    @Test
+    void anEntryRecordingAnotherNameIsMisplacedAndItsFileIsMoved() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+
+        initialize(derivedNames(store, "repair"));
+
+        String derived = derivedNameOf("a rule");
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(derived);
+        assertThat(fileNames(store)).containsOnly(INDEX, derived);
+        assertThat(contentOf(new File(store, derived))).isEqualTo("a remaining violation\n");
+    }
+
+    @Test
+    void aMisplacedEntryKeepsItsViolationsAfterTheMove() {
+        File store = folder("store");
+        index(store, "a rule", file(store, "legacy-name", "first violation\nsecond violation\n"));
+
+        initialize(derivedNames(store, "repair"));
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(derivedNames(store, "ignore"));
+        assertThat(reader.getViolations(rule("a rule"))).containsExactly("first violation", "second violation");
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(derivedNameOf("a rule"));
+    }
+
+    @Test
+    void aMisplacedEntryNamingALinkMovesTheFileTheLinkPointsAt() {
+        File store = folder("store");
+        String target = file(store, "target", "a remaining violation\n");
+        link(new File(store, "legacy-link"), new File(store, target));
+        index(store, "a rule", "legacy-link");
+
+        initialize(derivedNames(store, "repair"));
+
+        String derived = derivedNameOf("a rule");
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(derived);
+        assertThat(Files.isSymbolicLink(new File(store, derived).toPath()))
+                .as("the file the entry owned is moved to the derived name, not the link that pointed at it").isFalse();
+        assertThat(contentOf(new File(store, derived))).isEqualTo("a remaining violation\n");
+        assertThat(fileNames(store)).as("the file no longer sits under its old name").containsOnly(INDEX, derived);
+
+        initialize(derivedNames(store, "fail"));
+    }
+
+    @Test
+    void failNamesMisplacedEntriesAndChangesNothing() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, recorded);
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+    }
+
+    @Test
+    void aDerivedNameLeavingTheStoreFolderIsNeverUsed() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "escaped-target");
+        write(outside, "precious");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", EscapingFileNames.class.getName());
+        initialize(properties);
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(fileNames(store)).containsOnly(INDEX, recorded);
+        assertThat(contentOf(outside)).isEqualTo("precious");
+
+        properties.setProperty("default.integrity", "fail");
+        assertThatThrownBy(() -> initialize(properties)).as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+
+        File rooted = folder("rooted");
+        String rootedRecorded = file(rooted, "legacy-name", "a remaining violation\n");
+        index(rooted, "a rule", rootedRecorded);
+        Properties rootedProperties = integrity(rooted, "repair");
+        rootedProperties.setProperty("default.fileNames", RootedFileNames.class.getName());
+        initialize(rootedProperties);
+
+        assertThat(entries(rooted).getProperty("a rule")).as("an absolute derived name leaves the folder as well")
+                .isEqualTo(rootedRecorded);
+        assertThat(fileNames(rooted)).containsOnly(INDEX, rootedRecorded);
+    }
+
+    // ---------------------------------------------------------------- colliding and occupied
+
+    @Test
+    void twoRulesDerivingOneNameAreCollidingAndNeitherIsMoved() {
+        File store = folder("store");
+        String firstRecorded = file(store, "first-legacy", "a remaining violation\n");
+        String secondRecorded = file(store, "second-legacy", "another remaining violation\n");
+        index(store, "first rule", firstRecorded, "second rule", secondRecorded);
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+        initialize(properties);
+
+        assertThat(entries(store).getProperty("first rule")).isEqualTo(firstRecorded);
+        assertThat(entries(store).getProperty("second rule")).isEqualTo(secondRecorded);
+        assertThat(fileNames(store)).containsOnly(INDEX, firstRecorded, secondRecorded);
+
+        properties.setProperty("default.integrity", "fail");
+        assertThatThrownBy(() -> initialize(properties)).as("both entries are still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("first rule")
+                .hasMessageContaining("second rule");
+    }
+
+    @Test
+    void aDerivedNameAnUnownedFileOccupiesIsNotTakenOver() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+        write(new File(store, derivedNameOf("a rule")), "written by hand");
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(contentOf(new File(store, derivedNameOf("a rule")))).isEqualTo("written by hand");
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void aDerivedNameALinkOutOfTheStoreFolderOccupiesIsNotTakenOver() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "linked-target");
+        write(outside, "precious");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        link(new File(store, derivedNameOf("a rule")), outside);
+        index(store, "a rule", recorded);
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(contentOf(outside)).isEqualTo("precious");
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void aDerivedNameADanglingLinkOccupiesIsNotTakenOver() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+        link(new File(store, derivedNameOf("a rule")), new File(store, "never-created"));
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void aDerivedNameALinkToTheEntrysOwnFileOccupiesIsNotTakenOver() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        File linkOnTheDerivedName = new File(store, derivedNameOf("a rule"));
+        link(linkOnTheDerivedName, new File(store, recorded));
+        index(store, "a rule", recorded);
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+        assertThat(Files.isSymbolicLink(linkOnTheDerivedName.toPath()))
+                .as("the link on the derived name is left in place").isTrue();
+        assertThat(contentOf(linkOnTheDerivedName)).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void aDerivedNameADirectoryOccupiesIsNotTakenOver() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+        assertThat(new File(store, derivedNameOf("a rule")).mkdirs()).isTrue();
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(new File(store, derivedNameOf("a rule"))).isDirectory();
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void aDerivedNameEqualToTheIndexIsOccupiedAndNeverMovedOver() {
+        File store = folder("store");
+        String recorded = file(store, "legacy-name", "a remaining violation\n");
+        index(store, "a rule", recorded);
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", IndexFileNames.class.getName());
+        initialize(properties);
+
+        assertThat(entries(store).getProperty("a rule")).isEqualTo(recorded);
+        assertThat(bytesOf(new File(store, INDEX))).isEqualTo(indexBefore);
+        assertThat(contentOf(new File(store, recorded))).isEqualTo("a remaining violation\n");
+
+        properties.setProperty("default.integrity", "fail");
+        assertThatThrownBy(() -> initialize(properties))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    @Test
+    void twoEntriesThatWouldSwapNamesAreNotMoved() {
+        File store = folder("store");
+        String firstName = derivedNameOf("first rule");
+        String secondName = derivedNameOf("second rule");
+        write(new File(store, firstName), "second rule violation\n");
+        write(new File(store, secondName), "first rule violation\n");
+        index(store, "first rule", secondName, "second rule", firstName);
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store).getProperty("first rule")).isEqualTo(secondName);
+        assertThat(entries(store).getProperty("second rule")).isEqualTo(firstName);
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("both entries are still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("first rule")
+                .hasMessageContaining("second rule");
+    }
+
+    @Test
+    void failNamesBothCollidingRulesEvenWhenOneAlreadyRecordsTheDerivedName() {
+        File store = folder("store");
+        String settled = file(store, new ConstantFileNames().createRuleFileName("alpha rule"), "a remaining violation\n");
+        String legacy = file(store, "legacy-name", "another remaining violation\n");
+        index(store, "alpha rule", settled, "beta rule", legacy);
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .as("the rule already sitting on the shared derived name is colliding too")
+                .hasMessageContaining("alpha rule")
+                .hasMessageContaining("beta rule");
+
+        properties.setProperty("default.integrity", "repair");
+        initialize(properties);
+
+        assertThat(entries(store).getProperty("alpha rule")).isEqualTo(settled);
+        assertThat(entries(store).getProperty("beta rule")).isEqualTo(legacy);
+        assertThat(fileNames(store)).containsOnly(INDEX, settled, legacy);
+    }
+
+    @Test
+    void anEntryRecordingItsDerivedNameIsNeverOccupiedWhileAnotherEntryIs() {
+        File store = folder("store");
+        // the settled entry records the name its rule derives and the file under that name is its own, which is
+        // no reason to take that name for one something else occupies
+        String settled = file(store, derivedNameOf("alpha rule"), "a remaining violation\n");
+        String legacy = file(store, "legacy-name", "another remaining violation\n");
+        String occupant = file(store, derivedNameOf("beta rule"), "written by hand");
+        index(store, "alpha rule", settled, "beta rule", legacy);
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .isInstanceOf(RuntimeException.class)
+                .as("only the entry whose derived name another file occupies is reported")
+                .hasMessageContaining("beta rule")
+                .hasMessageNotContaining("alpha rule");
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(bytesOf(new File(store, INDEX))).as("an index no repair rewrote").isEqualTo(indexBefore);
+        assertThat(entries(store)).containsOnlyKeys("alpha rule", "beta rule")
+                .containsEntry("alpha rule", settled)
+                .containsEntry("beta rule", legacy);
+        assertThat(fileNames(store)).containsOnly(INDEX, settled, legacy, occupant);
+        assertThat(contentOf(new File(store, settled))).isEqualTo("a remaining violation\n");
+        assertThat(contentOf(new File(store, occupant))).isEqualTo("written by hand");
+    }
+
+    @Test
+    void failNamesCollidingEntriesAndChangesNothing() {
+        File store = folder("store");
+        String firstRecorded = file(store, "first-legacy", "a remaining violation\n");
+        String secondRecorded = file(store, "second-legacy", "another remaining violation\n");
+        index(store, "alpha rule", firstRecorded, "beta rule", secondRecorded);
+
+        Properties properties = integrity(store, "fail");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+
+        assertThatThrownBy(() -> initialize(properties))
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("alpha rule")
+                .hasMessageContaining("beta rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, firstRecorded, secondRecorded);
+    }
+
+    @Test
+    void brokenAndResolvedEntriesAreDiscardedEvenWhenTheirRulesDeriveOneName() {
+        File store = folder("store");
+        String kept = file(store, "kept-legacy", "a remaining violation\n");
+        index(store, "alpha rule", file(store, "alpha-legacy", ""),
+                "beta rule", file(store, "beta-legacy", "\n\n"),
+                "broken rule", "gone",
+                "kept rule", kept);
+
+        Properties properties = integrity(store, "repair");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+        initialize(properties);
+
+        assertThat(entries(store)).as("only the colliding entry still holding violations is left in place")
+                .containsOnlyKeys("kept rule");
+        assertThat(entries(store).getProperty("kept rule")).isEqualTo(kept);
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+        assertThat(contentOf(new File(store, kept))).isEqualTo("a remaining violation\n");
+    }
+
+    @Test
+    void brokenAndResolvedEntriesAreDiscardedEvenWhenTheirDerivedNamesAreOccupied() {
+        File store = folder("store");
+        String kept = file(store, "kept-legacy", "a remaining violation\n");
+        index(store, "resolved rule", file(store, "resolved-legacy", ""),
+                "broken rule", "gone",
+                "kept rule", kept);
+        String resolvedOccupant = file(store, derivedNameOf("resolved rule"), "written by hand");
+        String brokenOccupant = file(store, derivedNameOf("broken rule"), "written by hand");
+        String keptOccupant = file(store, derivedNameOf("kept rule"), "written by hand");
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store)).as("only the occupied entry still holding violations is left in place")
+                .containsOnlyKeys("kept rule");
+        assertThat(entries(store).getProperty("kept rule")).isEqualTo(kept);
+        assertThat(fileNames(store)).containsOnly(INDEX, kept, resolvedOccupant, brokenOccupant, keptOccupant);
+        for (String occupant : Arrays.asList(resolvedOccupant, brokenOccupant, keptOccupant)) {
+            assertThat(contentOf(new File(store, occupant))).as("occupant %s", occupant).isEqualTo("written by hand");
+        }
+    }
+
+    @Test
+    void aDerivedNameSharedEntriesRecordIsOccupiedEvenWhileNothingExistsUnderIt() {
+        File store = folder("store");
+        String legacy = file(store, "legacy-name", "a remaining violation\n");
+        String derived = derivedNameOf("a rule");
+        index(store, "a rule", legacy, "first sharer", derived, "second sharer", derived, "broken rule", "gone");
+
+        initialize(derivedNames(store, "repair"));
+
+        assertThat(entries(store)).as("the broken entry is discarded while the shared ones stay")
+                .containsOnlyKeys("a rule", "first sharer", "second sharer");
+        assertThat(entries(store).getProperty("a rule"))
+                .as("the file is not moved onto the name the shared entries record").isEqualTo(legacy);
+        assertThat(fileNames(store)).containsOnly(INDEX, legacy);
+        assertThat(contentOf(new File(store, legacy))).isEqualTo("a remaining violation\n");
+
+        assertThatThrownBy(() -> initialize(derivedNames(store, "fail")))
+                .as("the entry is still named as inconsistent")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("a rule");
+    }
+
+    // ---------------------------------------------------------------- storing never overwrites
+
+    @Test
+    void storingARuleNeverWritesOverAFileTheStoreDoesNotOwn() {
+        File store = folder("store");
+        index(store);
+        String unowned = derivedNameOf("a rule");
+        write(new File(store, unowned), "written by hand");
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(derivedNames(store, "ignore"));
+
+        for (String attempt : Arrays.asList("first attempt", "retry")) {
+            assertThatThrownBy(() -> writer.save(rule("a rule"), Arrays.asList("a violation")))
+                    .as(attempt).isInstanceOf(RuntimeException.class);
+            assertThat(bytesOf(new File(store, INDEX))).as("the index after the %s", attempt).isEqualTo(indexBefore);
+            assertThat(entries(store)).as("the entries after the %s", attempt).isEmpty();
+            assertThat(writer.contains(rule("a rule"))).as("the rule is still unknown after the %s", attempt).isFalse();
+            assertThat(fileNames(store)).as("the files after the %s", attempt).containsOnly(INDEX, unowned);
+            assertThat(contentOf(new File(store, unowned))).as("the unowned file after the %s", attempt)
+                    .isEqualTo("written by hand");
+        }
+    }
+
+    @Test
+    void storingASecondUnknownRuleNeverTakesOverTheFirstRulesFile() {
+        File store = folder("store");
+        index(store);
+        ArchRule firstRule = rule("first previously unknown rule");
+        ArchRule secondRule = rule("second previously unknown rule");
+        String collidingName = new ConstantFileNames().createRuleFileName(firstRule.getDescription());
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        Properties properties = integrity(store, "ignore");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+        writer.initialize(properties);
+        writer.save(firstRule, Arrays.asList("first violation"));
+
+        assertThatThrownBy(() -> writer.save(secondRule, Arrays.asList("second violation")))
+                .as("a name the first rule's entry already records cannot be taken over")
+                .isInstanceOf(RuntimeException.class);
+
+        assertThat(entries(store)).as("nothing is recorded for the rejected rule")
+                .containsOnlyKeys(firstRule.getDescription());
+        assertThat(entries(store).getProperty(firstRule.getDescription()))
+                .as("the first rule keeps the name the strategy gave it").isEqualTo(collidingName);
+        assertThat(fileNames(store)).as("no file is written for the rejected rule")
+                .containsOnly(INDEX, collidingName);
+        assertThat(contentOf(new File(store, collidingName)))
+                .as("the first rule's violations are the ones still stored").isEqualTo("first violation\n");
+    }
+
+    @Test
+    void storingAPreviouslyUnknownRuleUnderAnUnsafeDerivedNameIsRejected() {
+        File store = folder("store");
+        index(store);
+        File outside = new File(tempDir.toFile(), "escaped-target");
+        write(outside, "precious");
+        File nestedDir = new File(store, "nested");
+        assertThat(nestedDir.mkdirs()).isTrue();
+        File nested = new File(nestedDir, "violations");
+        write(nested, "untouched");
+
+        for (String strategyClassName : Arrays.asList(
+                EscapingFileNames.class.getName(), NestedFileNames.class.getName(), RootedFileNames.class.getName())) {
+            ViolationStore writer = new TextFileBasedViolationStore();
+            Properties properties = integrity(store, "ignore");
+            properties.setProperty("default.fileNames", strategyClassName);
+            writer.initialize(properties);
+
+            assertThatThrownBy(() -> writer.save(rule("a rule"), Arrays.asList("a violation")))
+                    .as("strategy '%s'", strategyClassName).isInstanceOf(RuntimeException.class);
+        }
+
+        assertThat(contentOf(outside)).isEqualTo("precious");
+        assertThat(contentOf(nested)).isEqualTo("untouched");
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
+
+    @Test
+    void storingAPreviouslyUnknownRuleNeverTakesOverADanglingLink() {
+        File store = folder("store");
+        index(store);
+        ArchRule rule = rule("a rule");
+        String derivedName = new ConstantFileNames().createRuleFileName(rule.getDescription());
+        File danglingLink = new File(store, derivedName);
+        link(danglingLink, new File(store, "never-created"));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        Properties properties = integrity(store, "ignore");
+        properties.setProperty("default.fileNames", ConstantFileNames.class.getName());
+        writer.initialize(properties);
+
+        assertThatThrownBy(() -> writer.save(rule, Arrays.asList("a violation")))
+                .as("a dangling link occupies the strategy's derived name")
+                .isInstanceOf(RuntimeException.class);
+
+        assertThat(Files.isSymbolicLink(danglingLink.toPath())).isTrue();
+        assertThat(entries(store)).isEmpty();
+    }
+
+    @Test
+    void storingARuleWhoseEntryRecordsAnUnsafeNameIsRejected() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "escaped-target");
+        write(outside, "precious");
+        String inFolder = file(store, "rooted-e448f3", "an old violation\n");
+        index(store, "escaping rule", "../escaped-target", "index rule", INDEX, "rooted rule", "/" + inFolder);
+        byte[] indexBefore = bytesOf(new File(store, INDEX));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "ignore"));
+
+        assertThatThrownBy(() -> writer.save(rule("escaping rule"), Arrays.asList("a violation")))
+                .as("an entry recording a name outside the store folder")
+                .isInstanceOf(RuntimeException.class);
+        assertThatThrownBy(() -> writer.save(rule("index rule"), Arrays.asList("a violation")))
+                .as("an entry recording the index itself")
+                .isInstanceOf(RuntimeException.class);
+        assertThatThrownBy(() -> writer.save(rule("rooted rule"), Arrays.asList("a violation")))
+                .as("an entry recording an absolute name whose last part names a file in the store folder")
+                .isInstanceOf(RuntimeException.class);
+
+        assertThat(contentOf(outside)).isEqualTo("precious");
+        assertThat(contentOf(new File(store, inFolder))).isEqualTo("an old violation\n");
+        assertThat(bytesOf(new File(store, INDEX))).isEqualTo(indexBefore);
+    }
+
+    @Test
+    void storingARuleWhoseEntryRecordsADanglingLinkNeverCreatesTheFileItPointsAt() {
+        File outside = new File(tempDir.toFile(), "outside-target");
+        File direct = folder("direct");
+        index(direct, "a rule", "escape", "another rule", file(direct, "kept", "an old violation\n"));
+        link(new File(direct, "escape"), outside);
+        File chained = folder("chained");
+        index(chained, "a rule", "first-hop", "another rule", file(chained, "kept", "an old violation\n"));
+        link(new File(chained, "first-hop"), new File(chained, "second-hop"));
+        link(new File(chained, "second-hop"), outside);
+
+        for (File store : Arrays.asList(direct, chained)) {
+            byte[] indexBefore = bytesOf(new File(store, INDEX));
+            ViolationStore writer = new TextFileBasedViolationStore();
+            writer.initialize(properties(store));
+
+            assertThatThrownBy(() -> writer.save(rule("a rule"), Arrays.asList("a violation")))
+                    .as("store %s", store.getName()).isInstanceOf(RuntimeException.class);
+            assertThat(outside).as("the file the links of store %s point at", store.getName()).doesNotExist();
+            assertThat(bytesOf(new File(store, INDEX)))
+                    .as("the index of store %s", store.getName()).isEqualTo(indexBefore);
+
+            writer.save(rule("another rule"), Arrays.asList("a new violation"));
+            assertThat(contentOf(new File(store, "kept")))
+                    .as("the file another rule of store %s records", store.getName()).isEqualTo("a new violation\n");
+        }
+    }
+
+    @Test
+    void storingAStillViolatedRuleWritesToItsOwnFileEvenWhenItsDerivedNameIsOccupied() {
+        File store = folder("store");
+        ArchRule storedRule = rule("a rule");
+        ArchRule unknownRule = rule("another rule");
+        String legacy = file(store, "legacy", "some violation");
+        String occupied = file(store, derivedNameOf(storedRule.getDescription()), "an unowned file");
+        index(store, storedRule.getDescription(), legacy);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(derivedNames(store, "repair"));
+        writer.save(storedRule, Arrays.asList("another violation"));
+        writer.save(unknownRule, Arrays.asList("a third violation"));
+
+        assertThat(entries(store).getProperty(storedRule.getDescription()))
+                .as("the rule keeps the entry it had").isEqualTo(legacy);
+        assertThat(entries(store).getProperty(unknownRule.getDescription()))
+                .as("a rule the index did not know is named by the setting")
+                .isEqualTo(derivedNameOf(unknownRule.getDescription()));
+        assertThat(contentOf(new File(store, legacy))).isEqualTo("another violation\n");
+        assertThat(contentOf(new File(store, occupied))).isEqualTo("an unowned file");
+        assertThat(fileNames(store))
+                .containsOnly(INDEX, legacy, occupied, derivedNameOf(unknownRule.getDescription()));
+    }
+
+    @Test
+    void storingAStillViolatedRuleWritesThroughTheLinkItsEntryRecords() {
+        for (String integrityValue : Arrays.asList("repair", "ignore")) {
+            File store = folder("store-" + integrityValue);
+            ArchRule linkedRule = rule("a linked rule");
+            // an entry naming a link to a file in the store owns that file, so the rule's violations belong in it
+            String target = file(store, "target", "an old violation\n");
+            link(new File(store, "link-to-target"), new File(store, target));
+            index(store, linkedRule.getDescription(), "link-to-target", "broken rule", "gone");
+
+            ViolationStore writer = new TextFileBasedViolationStore();
+            writer.initialize(integrity(store, integrityValue));
+            writer.save(linkedRule, Arrays.asList("a new violation"));
+
+            assertThat(entries(store).getProperty(linkedRule.getDescription()))
+                    .as("the linked entry under %s", integrityValue).isEqualTo("link-to-target");
+            assertThat(entries(store).containsKey("broken rule"))
+                    .as("the broken entry is kept under %s unless repaired", integrityValue)
+                    .isEqualTo(integrityValue.equals("ignore"));
+            assertThat(contentOf(new File(store, target))).as("the owned file under %s", integrityValue)
+                    .isEqualTo("a new violation\n");
+            assertThat(writer.getViolations(linkedRule)).containsExactly("a new violation");
+            assertThat(fileNames(store)).containsOnly(INDEX, target, "link-to-target");
+        }
+    }
+
+    @Test
+    void storingARuleWhoseEntryRecordsAnotherPathToTheIndexIsRejected() {
+        File spelled = folder("spelled");
+        index(spelled, "a rule", "./" + INDEX);
+        File linked = folder("linked");
+        index(linked, "a rule", "beside-the-index");
+        link(new File(linked, "beside-the-index"), new File(linked, INDEX));
+        File hardLinked = folder("hard-linked");
+        index(hardLinked, "a rule", "another-name-of-the-index");
+        // a hard link is a regular file of its own name, yet writing to it writes to the index
+        hardLink(new File(hardLinked, "another-name-of-the-index"), new File(hardLinked, INDEX));
+
+        for (File store : Arrays.asList(spelled, linked, hardLinked)) {
+            ViolationStore writer = new TextFileBasedViolationStore();
+            writer.initialize(properties(store));
+            byte[] before = bytesOf(new File(store, INDEX));
+
+            assertThatThrownBy(() -> writer.save(rule("a rule"), Arrays.asList("a violation")))
+                    .as("store %s", store.getName()).isInstanceOf(RuntimeException.class);
+            assertThat(bytesOf(new File(store, INDEX)))
+                    .as("the index of store %s", store.getName()).isEqualTo(before);
+        }
+    }
+
+    @Test
+    void storingARuleNeverWritesOverTheIndex() {
+        File store = folder("store");
+        index(store);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        Properties properties = integrity(store, "ignore");
+        properties.setProperty("default.fileNames", IndexFileNames.class.getName());
+        writer.initialize(properties);
+
+        assertThatThrownBy(() -> writer.save(rule("a rule"), Arrays.asList("a violation")))
+                .isInstanceOf(RuntimeException.class);
+        assertThat(entries(store)).isEmpty();
+    }
+
+    // ---------------------------------------------------------------- forgetting a resolved rule
+
+    @Test
+    void storingNoViolationsUnderRepairForgetsTheEntryAndItsFile() {
+        File store = folder("store");
+        ArchRule resolvedRule = rule("a fully resolved rule");
+        String violations = file(store, "violations", "one violation\n");
+        index(store, resolvedRule.getDescription(), violations);
+
+        File untouched = folder("untouched");
+        String keptViolations = file(untouched, "violations", "one violation\n");
+        index(untouched, resolvedRule.getDescription(), keptViolations);
+
+        ViolationStore maintaining = new TextFileBasedViolationStore();
+        maintaining.initialize(integrity(store, "repair"));
+        maintaining.save(resolvedRule, Collections.emptyList());
+
+        ViolationStore plain = new TextFileBasedViolationStore();
+        plain.initialize(integrity(untouched, "ignore"));
+        plain.save(resolvedRule, Collections.emptyList());
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX);
+        assertThat(entries(untouched)).as("not maintaining the store keeps the entry")
+                .containsOnlyKeys(resolvedRule.getDescription());
+        assertThat(plain.getViolations(resolvedRule)).isEmpty();
+    }
+
+    @Test
+    void onlyRepairForgetsAResolvedRuleWhileFailKeepsIt() {
+        File store = folder("store");
+        File reporting = folder("reporting");
+        ArchRule resolvedRule = rule("a fully resolved rule");
+        index(store, resolvedRule.getDescription(), file(store, "violations", "one violation\n"));
+        index(reporting, resolvedRule.getDescription(), file(reporting, "violations", "one violation\n"));
+
+        ViolationStore repairing = new TextFileBasedViolationStore();
+        repairing.initialize(integrity(store, "repair"));
+        repairing.save(resolvedRule, Collections.emptyList());
+
+        ViolationStore reportingStore = new TextFileBasedViolationStore();
+        reportingStore.initialize(integrity(reporting, "fail"));
+        reportingStore.save(resolvedRule, Collections.emptyList());
+
+        assertThat(entries(store)).as("repair forgets the rule").isEmpty();
+        assertThat(entries(reporting)).as("fail changes nothing of its own")
+                .containsOnlyKeys(resolvedRule.getDescription());
+    }
+
+    @Test
+    void forgettingARuleWhoseNameEscapesTheFolderNeverTouchesAnythingOutside() {
+        File store = folder("store");
+        File outside = new File(tempDir.toFile(), "outside.txt");
+        write(outside, "precious");
+        ArchRule escapingRule = rule("a rule recorded outside the folder");
+        index(store, escapingRule.getDescription(), "../outside.txt", "its shared peer", "../outside.txt");
+
+        ViolationStore maintaining = new TextFileBasedViolationStore();
+        maintaining.initialize(integrity(store, "repair"));
+        maintaining.save(escapingRule, Collections.emptyList());
+
+        assertThat(entries(store)).as("the forgotten rule's entry is discarded, while the entry sharing its file stays")
+                .containsOnlyKeys("its shared peer");
+        assertThat(entries(store).getProperty("its shared peer")).isEqualTo("../outside.txt");
+        assertThat(outside).as("nothing outside the store folder was removed").exists();
+        assertThat(contentOf(outside)).as("nothing outside the store folder was written").isEqualTo("precious");
+    }
+
+    @Test
+    void forgettingARuleKeepsTheFileAnotherEntryStillRecords() {
+        File store = folder("store");
+        String shared = file(store, "shared", "a remaining violation\n");
+        link(new File(store, "beside-the-shared-file"), new File(store, shared));
+        index(store, "forgotten rule", "beside-the-shared-file", "keeping rule", shared);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "repair"));
+        writer.save(rule("forgotten rule"), Collections.emptyList());
+
+        assertThat(entries(store)).containsOnlyKeys("keeping rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared, "beside-the-shared-file");
+        assertThat(contentOf(new File(store, shared))).isEqualTo("a remaining violation\n");
+        assertThat(writer.getViolations(rule("keeping rule"))).containsExactly("a remaining violation");
+    }
+
+    @Test
+    void forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry() {
+        File store = folder("store");
+        ArchRule resolvedRule = rule("a fully resolved rule");
+        String violations = file(store, "violations", "one violation\n");
+        index(store, resolvedRule.getDescription(), violations);
+        File indexFile = new File(store, INDEX);
+        byte[] indexBefore = bytesOf(indexFile);
+
+        // nothing can be removed from the folder any more, while the files in it can still be written
+        setPermissions(tempDir.toFile(), "rwxr-xr-x");
+        setPermissions(indexFile, "rw-rw-rw-");
+        setPermissions(new File(store, violations), "rw-rw-rw-");
+        setPermissions(store, "r-xr-xr-x");
+        String outcome;
+        try {
+            outcome = Files.isWritable(store.toPath())
+                    ? forgetAsAnotherUser(store, resolvedRule.getDescription())
+                    : ForgettingProbe.forget(store, resolvedRule.getDescription());
+        } finally {
+            setPermissions(store, "rwxr-xr-x");
+        }
+
+        assertThat(outcome).as("forgetting the rule while its file cannot be deleted").isEqualTo("rejected");
+        assertThat(bytesOf(indexFile)).as("the index still records the rule").isEqualTo(indexBefore);
+        assertThat(contentOf(new File(store, violations))).isEqualTo("one violation\n");
+
+        ViolationStore maintaining = new TextFileBasedViolationStore();
+        maintaining.initialize(integrity(store, "repair"));
+        maintaining.save(resolvedRule, Collections.emptyList());
+
+        assertThat(entries(store)).as("once its file can be deleted, the rule is forgotten").isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
+
+    @Test
+    void forgettingARuleTheIndexNeverKnewStoresNothingForIt() {
+        File store = folder("store");
+        index(store);
+
+        ViolationStore maintaining = new TextFileBasedViolationStore();
+        maintaining.initialize(integrity(store, "repair"));
+        maintaining.save(rule("a rule nothing was ever stored for"), Collections.emptyList());
+
+        assertThat(entries(store)).isEmpty();
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
+
+    @Test
+    void aStillViolatedRuleKeepsItsEntryUnderRepair() {
+        File store = folder("store");
+        ArchRule remainingRule = rule("a still violated rule");
+        String violations = file(store, "violations", "first violation\nsecond violation\n");
+        index(store, remainingRule.getDescription(), violations, "broken rule", "gone");
+
+        ViolationStore maintaining = new TextFileBasedViolationStore();
+        maintaining.initialize(integrity(store, "repair"));
+        maintaining.save(remainingRule, Arrays.asList("first violation"));
+
+        assertThat(entries(store)).containsOnlyKeys(remainingRule.getDescription());
+        assertThat(maintaining.getViolations(remainingRule)).containsExactly("first violation");
+    }
+
+    // ---------------------------------------------------------------- names taken from the description
+
+    @Test
+    void namesTakenFromTheDescriptionShowTheRuleTheyStore() {
+        File store = folder("store");
+        index(store);
+        ArchRule namedRule = rule("services should not access controllers");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(namedRule, Arrays.asList("a violation"));
+
+        String storedName = entries(store).getProperty(namedRule.getDescription());
+        assertKeepsAWordOf(storedName, namedRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aRuleKeepsTheSameNameInALaterRun() {
+        File first = folder("first");
+        File second = folder("second");
+        index(first);
+        index(second);
+        ArchRule namedRule = rule("services should not access controllers");
+
+        ViolationStore toFirst = new TextFileBasedViolationStore();
+        toFirst.initialize(builtInNames(first, "description"));
+        toFirst.save(namedRule, Arrays.asList("a violation"));
+        ViolationStore toSecond = new TextFileBasedViolationStore();
+        toSecond.initialize(builtInNames(second, "description"));
+        toSecond.save(namedRule, Arrays.asList("a violation"));
+
+        assertThat(entries(second).getProperty(namedRule.getDescription()))
+                .as("name derived from the description alone")
+                .isEqualTo(entries(first).getProperty(namedRule.getDescription()));
+    }
+
+    @Test
+    void aRuleKeepsTheSameNameOnAnotherMachine() {
+        String ruleDescription = "API classes should not access the na\u00efve controllers";
+
+        String first = descriptionNameFromSeparateJvm(ruleDescription, "machine-one", "en", "US", "UTF-8");
+        String second = descriptionNameFromSeparateJvm(ruleDescription, "machine-two", "tr", "TR", "ISO-8859-1");
+
+        assertThat(first).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertThat(second).as("the name owes nothing to the machine it was derived on").isEqualTo(first);
+        assertKeepsAWordOf(first, ruleDescription);
+    }
+
+    @Test
+    void aRuleKeepsTheSameNameWhateverTheStoreAlreadyHolds() {
+        File alone = folder("alone");
+        File crowded = folder("crowded");
+        index(alone);
+        index(crowded);
+        ArchRule namedRule = rule("services should not access controllers");
+        ArchRule oneOther = rule("controllers should not access services");
+        ArchRule anotherOther = rule("repositories should not access controllers");
+
+        ViolationStore toAlone = new TextFileBasedViolationStore();
+        toAlone.initialize(builtInNames(alone, "description"));
+        toAlone.save(namedRule, Arrays.asList("a violation"));
+
+        ViolationStore toCrowded = new TextFileBasedViolationStore();
+        toCrowded.initialize(builtInNames(crowded, "description"));
+        toCrowded.save(oneOther, Arrays.asList("a violation"));
+        toCrowded.save(anotherOther, Arrays.asList("another violation"));
+        toCrowded.save(namedRule, Arrays.asList("a violation"));
+
+        String aloneName = entries(alone).getProperty(namedRule.getDescription());
+        assertThat(entries(crowded).getProperty(namedRule.getDescription()))
+                .as("the name owes nothing to what the store already held")
+                .isEqualTo(aloneName);
+    }
+
+    @Test
+    void twoRulesReadingAlikeStillGetDifferentNames() {
+        File store = folder("store");
+        index(store);
+        String shared = repeated("classes should be public and ", 40);
+        // descriptions differing only in case are different rules to the index, so they need different names too
+        List<ArchRule> rulesReadingAlike = Arrays.asList(rule(shared + "one"), rule(shared + "other"),
+                rule("service:rule"), rule("service/rule"), rule("ServiceRule"), rule("serviceRule"),
+                rule(shared + "Case"), rule(shared + "case"));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        for (ArchRule ruleReadingAlike : rulesReadingAlike) {
+            writer.save(ruleReadingAlike, Arrays.asList("violation of " + ruleReadingAlike.getDescription()));
+        }
+
+        List<String> names = new ArrayList<>();
+        for (ArchRule ruleReadingAlike : rulesReadingAlike) {
+            String name = entries(store).getProperty(ruleReadingAlike.getDescription());
+            assertKeepsAWordOf(name, ruleReadingAlike.getDescription());
+            names.add(name);
+        }
+        assertThat(names).as("names of rules reading alike").doesNotHaveDuplicates();
+        List<String> expectedFiles = new ArrayList<>(names);
+        expectedFiles.add(INDEX);
+        assertThat(fileNames(store)).containsExactlyInAnyOrderElementsOf(expectedFiles);
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(builtInNames(store, "description"));
+        for (ArchRule ruleReadingAlike : rulesReadingAlike) {
+            assertThat(reader.getViolations(ruleReadingAlike))
+                    .as("violations read back for '%s'", ruleReadingAlike.getDescription())
+                    .containsExactly("violation of " + ruleReadingAlike.getDescription());
+        }
+    }
+
+    @Test
+    void aDescriptionFullOfPunctuationStillYieldsAPlainBoundedName() {
+        File store = folder("store");
+        index(store);
+        ArchRule awkwardRule = rule("no ../ classes: |a/b| -> *?:<>\n" + repeated("very long ", 60));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(awkwardRule, Arrays.asList("a violation"));
+
+        String storedName = entries(store).getProperty(awkwardRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertKeepsAWordOf(storedName, awkwardRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aLongWordAfterOnlyShortOnesStillYieldsABoundedName() {
+        File first = folder("first");
+        File second = folder("second");
+        index(first);
+        index(second);
+        ArchRule awkwardRule = rule(repeated("abc ", 40) + repeated("x", 120));
+
+        ViolationStore toFirst = new TextFileBasedViolationStore();
+        toFirst.initialize(builtInNames(first, "description"));
+        toFirst.save(awkwardRule, Arrays.asList("a violation"));
+        ViolationStore toSecond = new TextFileBasedViolationStore();
+        toSecond.initialize(builtInNames(second, "description"));
+        toSecond.save(awkwardRule, Arrays.asList("another violation"));
+
+        String storedName = entries(first).getProperty(awkwardRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertKeepsAWordOf(storedName, awkwardRule.getDescription());
+        assertThat(entries(second).getProperty(awkwardRule.getDescription()))
+                .as("the same name in a later run").isEqualTo(storedName);
+        assertThat(fileNames(first)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aWordWorthKeepingSurvivesADescriptionOfShortWordsBeforeIt() {
+        File store = folder("store");
+        index(store);
+        ArchRule lateWordRule = rule(repeated("abc ", 60) + "controllers");
+        // four digits are a word worth keeping as well, and the shortest one there is
+        ArchRule lateNumberRule = rule(repeated("abc ", 60) + "1234");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(lateWordRule, Arrays.asList("a violation"));
+        writer.save(lateNumberRule, Arrays.asList("another violation"));
+
+        String storedName = entries(store).getProperty(lateWordRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertKeepsAWordOf(storedName, lateWordRule.getDescription());
+        String numberName = entries(store).getProperty(lateNumberRule.getDescription());
+        assertThat(numberName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertKeepsAWordOf(numberName, lateNumberRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName, numberName);
+    }
+
+    @Test
+    void aWordWorthKeepingSurvivesAnOverlongWordBeforeIt() {
+        File store = folder("store");
+        index(store);
+        // the leading word is longer than 120 characters, so it is not one the name may keep; the short words after it
+        // are too short to keep, which leaves the late "controllers" as the only word of a length worth keeping
+        ArchRule crowdedRule = rule(repeated("x", 121) + " " + repeated("abc ", 40) + "controllers");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(crowdedRule, Arrays.asList("a violation"));
+
+        String storedName = entries(store).getProperty(crowdedRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertThat(storedName).as("the overlong leading word is passed over rather than cut into the name")
+                .contains("controllers");
+        assertKeepsAWordOf(storedName, crowdedRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aWordWorthKeepingSurvivesAnOverlongWordAfterIt() {
+        File store = folder("store");
+        index(store);
+        // the only word of a length worth keeping comes first; a fragment of the overlong word after it is not a
+        // whole word
+        ArchRule trailingRule = rule("controllers " + repeated("x", 121));
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(trailingRule, Arrays.asList("a violation"));
+
+        String storedName = entries(store).getProperty(trailingRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertThat(storedName).as("the whole word before the overlong one is kept").contains("controllers");
+        assertKeepsAWordOf(storedName, trailingRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aWordWorthKeepingSurvivesAnOverlongWordBeginningWithIt() {
+        File store = folder("store");
+        index(store);
+        // the overlong first word begins with the very letters of the late word worth keeping, so a name holding
+        // those letters only as the start of that overlong word keeps no whole word of the description
+        ArchRule disguisedRule = rule("abcd" + repeated("x", 117) + " " + repeated("abc ", 20) + "abcd");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(disguisedRule, Arrays.asList("a violation"));
+
+        String storedName = entries(store).getProperty(disguisedRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200);
+        assertKeepsAWordOf(storedName, disguisedRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(builtInNames(store, "description"));
+        assertThat(reader.getViolations(disguisedRule)).containsExactly("a violation");
+    }
+
+    @Test
+    void aDescriptionWithoutAnyPlainCharacterStillYieldsAStableName() {
+        File first = folder("first");
+        File second = folder("second");
+        index(first);
+        index(second);
+        ArchRule symbolicRule = rule("!@#$%^&*()");
+
+        ViolationStore toFirst = new TextFileBasedViolationStore();
+        toFirst.initialize(builtInNames(first, "description"));
+        toFirst.save(symbolicRule, Arrays.asList("a violation"));
+        ViolationStore toSecond = new TextFileBasedViolationStore();
+        toSecond.initialize(builtInNames(second, "description"));
+        toSecond.save(symbolicRule, Arrays.asList("a violation"));
+
+        String storedName = entries(first).getProperty(symbolicRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+");
+        assertThat(entries(second).getProperty(symbolicRule.getDescription())).isEqualTo(storedName);
+        assertThat(fileNames(first)).containsOnly(INDEX, storedName);
+    }
+
+    @Test
+    void aDescriptionOfOnlyNonAsciiCharactersStillYieldsAStableAsciiName() {
+        File first = folder("first");
+        File second = folder("second");
+        index(first);
+        index(second);
+        ArchRule foreignRule = rule("\u4e2d\u6587 \u30eb\u30fc\u30eb \ud83d\ude00");
+        ArchRule otherForeignRule = rule("\u0645\u062b\u0627\u0644 \ud83d\ude80");
+
+        ViolationStore toFirst = new TextFileBasedViolationStore();
+        toFirst.initialize(builtInNames(first, "description"));
+        toFirst.save(foreignRule, Arrays.asList("a violation"));
+        toFirst.save(otherForeignRule, Arrays.asList("another violation"));
+        ViolationStore toSecond = new TextFileBasedViolationStore();
+        toSecond.initialize(builtInNames(second, "description"));
+        toSecond.save(foreignRule, Arrays.asList("a violation"));
+
+        String storedName = entries(first).getProperty(foreignRule.getDescription());
+        assertThat(storedName).matches("[A-Za-z0-9_-]+").hasSizeLessThanOrEqualTo(200)
+                .isNotEqualTo(entries(first).getProperty(otherForeignRule.getDescription()));
+        assertThat(entries(second).getProperty(foreignRule.getDescription()))
+                .as("the same name in a later run").isEqualTo(storedName);
+    }
+
+    @Test
+    void violationsAreReadBackFromANameTakenFromTheDescription() {
+        File store = folder("store");
+        index(store);
+        ArchRule namedRule = rule("services should not access controllers");
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(namedRule, Arrays.asList("first violation", "second violation"));
+
+        ViolationStore reader = new TextFileBasedViolationStore();
+        reader.initialize(builtInNames(store, "description"));
+        assertThat(reader.getViolations(namedRule)).containsExactly("first violation", "second violation");
+        assertKeepsAWordOf(entries(store).getProperty(namedRule.getDescription()), namedRule.getDescription());
+    }
+
+    @Test
+    void anEntryRecordingALegacyNameIsMovedToTheNameTakenFromTheDescription() {
+        File store = folder("store");
+        ArchRule namedRule = rule("services should not access controllers");
+        String legacy = file(store, "8f14e45f-ea8d-4a2e-9d1f-2f0c1b6d3a77", "a remaining violation\n");
+        index(store, namedRule.getDescription(), legacy);
+
+        initialize(builtInNames(store, "repair", "description"));
+
+        String storedName = entries(store).getProperty(namedRule.getDescription());
+        assertThat(storedName).isNotEqualTo(legacy);
+        assertKeepsAWordOf(storedName, namedRule.getDescription());
+        assertThat(fileNames(store)).containsOnly(INDEX, storedName);
+        assertThat(contentOf(new File(store, storedName))).isEqualTo("a remaining violation\n");
+    }
+
+    @Test
+    void namesTakenFromTheDescriptionNeverCollideWithTheIndex() {
+        File store = folder("store");
+        index(store);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(builtInNames(store, "description"));
+        writer.save(rule(INDEX), Arrays.asList("a violation"));
+
+        String derived = entries(store).getProperty(INDEX);
+        assertThat(derived).isNotEqualTo(INDEX);
+        assertKeepsAWordOf(derived, INDEX);
+    }
+
+    // ---------------------------------------------------------------- writing the index
+
+    @Test
+    void aFirstRepairOfAConsistentStoreLeavesTheIndexByteIdentical() {
+        File consistent = folder("consistent");
+        File drifted = folder("drifted");
+        String kept = file(consistent, "kept", "some violation");
+        index(consistent, "kept rule", kept);
+        index(drifted, "kept rule", file(drifted, "kept", "some violation"), "broken rule", "gone");
+        byte[] consistentBefore = bytesOf(new File(consistent, INDEX));
+        byte[] driftedBefore = bytesOf(new File(drifted, INDEX));
+
+        initialize(integrity(consistent, "repair"));
+        initialize(integrity(drifted, "repair"));
+
+        assertThat(bytesOf(new File(consistent, INDEX)))
+                .as("a first repair that changes nothing does not rewrite the index")
+                .isEqualTo(consistentBefore);
+        assertThat(bytesOf(new File(drifted, INDEX)))
+                .as("a repair that discards an entry does rewrite it")
+                .isNotEqualTo(driftedBefore);
+    }
+
+    @Test
+    void aRepairFindingOnlyThingsItLeavesAloneDoesNotRewriteTheIndex() {
+        File untouched = folder("untouched");
+        file(untouched, "kept", "some violation");
+        file(untouched, "shared", "some violation");
+        write(new File(untouched, "unowned-file"), "written by hand");
+        write(new File(untouched, INDEX), "#an index written by hand\n"
+                + "kept-rule=kept\nfirst-shared=shared\nsecond-shared=shared\n");
+        byte[] untouchedBefore = bytesOf(new File(untouched, INDEX));
+
+        initialize(integrity(untouched, "repair"));
+
+        assertThat(bytesOf(new File(untouched, INDEX)))
+                .as("shared and unowned findings change no entry, so the index is not written")
+                .isEqualTo(untouchedBefore);
+        assertThat(entries(untouched)).containsOnlyKeys("kept-rule", "first-shared", "second-shared");
+        assertThatThrownBy(() -> initialize(integrity(untouched, "fail")))
+                .as("the findings a repair left alone are still there for fail to name")
+                .isInstanceOf(RuntimeException.class)
+                .hasMessageContaining("unowned-file");
+    }
+
+    @Test
+    void arepairThatChangesNothingLeavesTheIndexByteIdentical() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "kept rule", kept, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).containsOnlyKeys("kept rule");
+        byte[] afterFirstRepair = bytesOf(new File(store, INDEX));
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(bytesOf(new File(store, INDEX))).as("index rewritten although nothing changed")
+                .isEqualTo(afterFirstRepair);
+    }
+
+    // ---------------------------------------------------------------- helpers
+
+    @Test
+    void repairExaminesTheIndexAsItIsOnDiskAfterAnEarlierInitializationOfTheSameFolder() {
+        File store = folder("store");
+        index(store, "a rule", file(store, "kept", "a violation"));
+        initialize(integrity(store, "ignore"));
+
+        index(store, "another rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).isEmpty();
+    }
+
+    private void initialize(Properties properties) {
+        new TextFileBasedViolationStore().initialize(properties);
+    }
+
+    private File folder(String name) {
+        File created = new File(tempDir.toFile(), name);
+        assertThat(created.mkdirs() || created.isDirectory()).isTrue();
+        return created;
+    }
+
+    private Properties properties(File store) {
+        Properties properties = new Properties();
+        properties.setProperty("default.path", store.getAbsolutePath());
+        properties.setProperty("default.allowStoreCreation", "true");
+        return properties;
+    }
+
+    private Properties integrity(File store, String value) {
+        Properties properties = properties(store);
+        properties.setProperty("default.integrity", value);
+        return properties;
+    }
+
+    private ArchRule rule(String description) {
+        return classes().should().bePublic().as(description);
+    }
+
+    private void index(File store, String... ruleDescriptionToFileName) {
+        Properties properties = new Properties();
+        for (int i = 0; i < ruleDescriptionToFileName.length; i += 2) {
+            properties.setProperty(ruleDescriptionToFileName[i], ruleDescriptionToFileName[i + 1]);
+        }
+        try (FileOutputStream outputStream = new FileOutputStream(new File(store, INDEX))) {
+            properties.store(outputStream, "");
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private Properties entries(File store) {
+        Properties properties = new Properties();
+        try (FileInputStream inputStream = new FileInputStream(new File(store, INDEX))) {
+            properties.load(inputStream);
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+        return properties;
+    }
+
+    private String file(File store, String fileName, String content) {
+        write(new File(store, fileName), content);
+        return fileName;
+    }
+
+    private void write(File file, String content) {
+        try {
+            Files.write(file.toPath(), content.getBytes(StandardCharsets.UTF_8));
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private String contentOf(File file) {
+        try {
+            return new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private List<String> fileNames(File store) {
+        File[] files = store.listFiles();
+        Set<String> names = new LinkedHashSet<>();
+        if (files != null) {
+            for (File file : files) {
+                if (file.isFile()) {
+                    names.add(file.getName());
+                }
+            }
+        }
+        List<String> sorted = new ArrayList<>(names);
+        sorted.sort(String::compareTo);
+        return sorted;
+    }
+
+    /**
+     * A name is recognisable when it keeps a word of the rule description of four or more letters or digits,
+     * whichever word that is.
+     */
+    private void assertKeepsAWordOf(String fileName, String ruleDescription) {
+        List<String> words = new ArrayList<>();
+        for (String word : ruleDescription.split("[^A-Za-z0-9]+")) {
+            if (word.length() >= 4 && word.length() <= 120) {
+                words.add(word.toLowerCase(Locale.ROOT));
+            }
+        }
+        assertThat(words).as("the description '%s' has a word of 4 to 120 characters to keep", ruleDescription)
+                .isNotEmpty();
+        String lowerName = fileName.toLowerCase(Locale.ROOT);
+        assertThat(words).as("name '%s' keeps a whole word of 4 to 120 characters of '%s'", fileName, ruleDescription)
+                .anyMatch(word -> holdsWholeWord(lowerName, word));
+    }
+
+    /**
+     * Whether a name holds a word whole rather than as part of a longer one, which is what a name keeping only the
+     * first letters of a longer word would do.
+     */
+    private boolean holdsWholeWord(String name, String word) {
+        for (int found = name.indexOf(word); found >= 0; found = name.indexOf(word, found + 1)) {
+            if (endsAWord(name, found - 1) && endsAWord(name, found + word.length())) {
+                return true;
+            }
+        }
+        return false;
+    }
+
+    private boolean endsAWord(String name, int index) {
+        return index < 0 || index >= name.length() || !isWordCharacter(name.charAt(index));
+    }
+
+    private boolean isWordCharacter(char character) {
+        return (character >= 'a' && character <= 'z')
+                || (character >= 'A' && character <= 'Z')
+                || (character >= '0' && character <= '9');
+    }
+
+    /**
+     * The names created in a watched folder since it was registered. The file system reports what it created in the
+     * order it created it, so collecting until a file created last has been reported leaves nothing created earlier
+     * out, however late the reports arrive.
+     */
+    private List<String> namesCreatedIn(File folder, WatchService watcher) throws IOException, InterruptedException {
+        File createdLast = new File(folder, "created-last");
+        write(createdLast, "");
+        List<String> created = new ArrayList<>();
+        try {
+            while (!created.contains(createdLast.getName())) {
+                WatchKey key = watcher.poll(30, TimeUnit.SECONDS);
+                assertThat(key).as("the creation of %s was reported", createdLast.getName()).isNotNull();
+                for (WatchEvent<?> event : key.pollEvents()) {
+                    assertThat(event.kind()).as("no creation went unreported").isNotEqualTo(StandardWatchEventKinds.OVERFLOW);
+                    created.add(event.context().toString());
+                }
+                key.reset();
+            }
+        } finally {
+            Files.deleteIfExists(createdLast.toPath());
+        }
+        return created;
+    }
+
+    private List<Integer> positionsOf(String message, String... tokens) {
+        List<Integer> positions = new ArrayList<>();
+        for (String token : tokens) {
+            int position = message.indexOf(token);
+            assertThat(position).as("message names '%s'", token).isGreaterThanOrEqualTo(0);
+            positions.add(position);
+        }
+        return positions;
+    }
+
+    private Properties builtInNames(File store, String fileNamesValue) {
+        return builtInNames(store, "ignore", fileNamesValue);
+    }
+
+    private Properties builtInNames(File store, String integrityValue, String fileNamesValue) {
+        Properties properties = integrity(store, integrityValue);
+        properties.setProperty("default.fileNames", fileNamesValue);
+        return properties;
+    }
+
+    /**
+     * The name the store gives a rule in a JVM of its own, where everything a machine could contribute to a file name
+     * differs: the user, the home and temporary folders, the default locale and the default charset. Reading the name
+     * back off the store folder keeps the probe to the same public store the tests use.
+     */
+    private String descriptionNameFromSeparateJvm(
+            String ruleDescription, String machine, String language, String country, String encoding) {
+        File machineRoot = folder(machine);
+        File store = new File(machineRoot, "store");
+        File description = new File(machineRoot, "description");
+        File derivedName = new File(machineRoot, "derived-name");
+        File output = new File(machineRoot, "output");
+        write(description, ruleDescription);
+        ProcessBuilder probe = new ProcessBuilder(
+                new File(System.getProperty("java.home"), "bin/java").getAbsolutePath(),
+                "-Duser.name=" + machine,
+                "-Duser.home=" + machineRoot.getAbsolutePath(),
+                "-Djava.io.tmpdir=" + machineRoot.getAbsolutePath(),
+                "-Duser.language=" + language,
+                "-Duser.country=" + country,
+                "-Dfile.encoding=" + encoding,
+                "-cp", probeClassPath(),
+                DescriptionNameProbe.class.getName(),
+                store.getAbsolutePath(), description.getAbsolutePath(), derivedName.getAbsolutePath());
+        probe.redirectErrorStream(true);
+        probe.redirectOutput(output);
+        try {
+            assertThat(probe.start().waitFor()).as("separate JVM output: %s", contentOf(output)).isZero();
+        } catch (IOException | InterruptedException e) {
+            throw new IllegalStateException(e);
+        }
+        return contentOf(derivedName);
+    }
+
+    /**
+     * A user who may remove any file is not stopped by the permissions of a folder, so the store is run in a JVM of
+     * its own under an unprivileged user instead.
+     */
+    private String forgetAsAnotherUser(File store, String ruleDescription) {
+        File output = new File(tempDir.toFile(), "forgetting-output");
+        File errors = new File(tempDir.toFile(), "forgetting-errors");
+        ProcessBuilder probe = new ProcessBuilder(
+                "setpriv", "--reuid=65534", "--regid=65534", "--clear-groups",
+                new File(System.getProperty("java.home"), "bin/java").getAbsolutePath(),
+                "-cp", probeClassPath(),
+                ForgettingProbe.class.getName(), store.getAbsolutePath(), ruleDescription);
+        probe.redirectOutput(output);
+        probe.redirectError(errors);
+        try {
+            assertThat(probe.start().waitFor()).as("separate JVM errors: %s", contentOf(errors)).isZero();
+        } catch (IOException | InterruptedException e) {
+            throw new IllegalStateException(e);
+        }
+        return contentOf(output);
+    }
+
+    private String probeClassPath() {
+        Set<String> locations = new LinkedHashSet<>();
+        for (Class<?> onTheClassPath : Arrays.asList(FreezeStoreMaintenance_e448f3_Test.class,
+                TextFileBasedViolationStore.class, Splitter.class, LoggerFactory.class)) {
+            try {
+                locations.add(Paths.get(onTheClassPath.getProtectionDomain().getCodeSource().getLocation().toURI())
+                        .toAbsolutePath().toString());
+            } catch (URISyntaxException e) {
+                throw new IllegalStateException(e);
+            }
+        }
+        return String.join(File.pathSeparator, locations);
+    }
+
+    private String repeated(String part, int times) {
+        StringBuilder repeated = new StringBuilder();
+        for (int i = 0; i < times; i++) {
+            repeated.append(part);
+        }
+        return repeated.toString();
+    }
+
+    private Properties derivedNames(File store, String integrityValue) {
+        Properties properties = integrity(store, integrityValue);
+        properties.setProperty("default.fileNames", DescriptionFileNames.class.getName());
+        return properties;
+    }
+
+    private String derivedNameOf(String ruleDescription) {
+        return new DescriptionFileNames().createRuleFileName(ruleDescription);
+    }
+
+    private void link(File link, File target) {
+        try {
+            Files.createSymbolicLink(link.toPath(), target.toPath());
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private void hardLink(File link, File existing) {
+        try {
+            Files.createLink(link.toPath(), existing.toPath());
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private void setPermissions(File file, String permissions) {
+        try {
+            Files.setPosixFilePermissions(file.toPath(), PosixFilePermissions.fromString(permissions));
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    private byte[] bytesOf(File file) {
+        try {
+            return Files.readAllBytes(file.toPath());
+        } catch (IOException e) {
+            throw new IllegalStateException(e);
+        }
+    }
+
+    public static class DescriptionFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return ruleDescription.replaceAll("[^A-Za-z0-9]", "-") + ".violations";
+        }
+    }
+
+    public static class ConstantFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return "shared-by-every-rule.violations";
+        }
+    }
+
+    public static class EscapingFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return "../escaped-target";
+        }
+    }
+
+    public static class NestedFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return "nested/violations";
+        }
+    }
+
+    public static class RootedFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            // an absolute name, although its last part alone would be a plain name in the store folder
+            return "/rooted-e448f3-derived";
+        }
+    }
+
+    /**
+     * Derives names that sort the other way round than the descriptions they come from, so that reporting order by
+     * rule description can be told apart from reporting order by derived name.
+     */
+    public static class InvertedOrderFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            char inverted = (char) ('z' - (ruleDescription.charAt(0) - 'a'));
+            return inverted + "-" + ruleDescription.replaceAll("[^A-Za-z0-9]", "-");
+        }
+    }
+
+    public static class NullFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            REQUESTS_YIELDING_NO_NAME.incrementAndGet();
+            return null;
+        }
+    }
+
+    public static class EmptyFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            REQUESTS_YIELDING_NO_NAME.incrementAndGet();
+            return "";
+        }
+    }
+
+    public static class NotARuleViolationFileNameStrategy {
+    }
+
+    public static class FileNamesWithoutANoArgumentConstructor
+            implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        private final String suffix;
+
+        public FileNamesWithoutANoArgumentConstructor(String suffix) {
+            this.suffix = suffix;
+        }
+
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return ruleDescription + suffix;
+        }
+    }
+
+    public static class FileNamesWithAPrivateNoArgumentConstructor
+            implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        private FileNamesWithAPrivateNoArgumentConstructor() {
+        }
+
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return ruleDescription;
+        }
+    }
+
+    public static class ExplicitConstructorFileNames
+            implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        public ExplicitConstructorFileNames() {
+        }
+
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return "explicit-" + ruleDescription.replaceAll("[^A-Za-z0-9]", "-") + ".violations";
+        }
+    }
+
+    public static class DescriptionNameProbe {
+        public static void main(String[] args) throws IOException {
+            File store = new File(args[0]);
+            String ruleDescription = new String(Files.readAllBytes(new File(args[1]).toPath()), StandardCharsets.UTF_8);
+
+            Properties properties = new Properties();
+            properties.setProperty("default.path", store.getAbsolutePath());
+            properties.setProperty("default.allowStoreCreation", "true");
+            properties.setProperty("default.fileNames", "description");
+            ViolationStore violationStore = new TextFileBasedViolationStore();
+            violationStore.initialize(properties);
+            violationStore.save(classes().should().bePublic().as(ruleDescription), Collections.singletonList("a violation"));
+
+            Files.write(new File(args[2]).toPath(), derivedNameIn(store).getBytes(StandardCharsets.UTF_8));
+        }
+
+        private static String derivedNameIn(File store) {
+            List<String> names = new ArrayList<>();
+            for (File file : store.listFiles()) {
+                if (file.isFile() && !INDEX.equals(file.getName())) {
+                    names.add(file.getName());
+                }
+            }
+            if (names.size() != 1) {
+                throw new IllegalStateException("expected one rule violation file, but found " + names);
+            }
+            return names.get(0);
+        }
+    }
+
+    public static class ForgettingProbe {
+        public static void main(String[] args) {
+            System.out.print(forget(new File(args[0]), args[1]));
+        }
+
+        static String forget(File store, String ruleDescription) {
+            if (Files.isWritable(store.toPath())) {
+                return "files in " + store + " can still be removed";
+            }
+            Properties properties = new Properties();
+            properties.setProperty("default.path", store.getAbsolutePath());
+            properties.setProperty("default.integrity", "repair");
+            ViolationStore violationStore = new TextFileBasedViolationStore();
+            violationStore.initialize(properties);
+            try {
+                violationStore.save(classes().should().bePublic().as(ruleDescription), Collections.emptyList());
+                return "forgotten";
+            } catch (RuntimeException e) {
+                return "rejected";
+            }
+        }
+    }
+
+    public static class IndexFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            return INDEX;
+        }
+    }
+
+    public static class BlockingFileNames implements TextFileBasedViolationStore.RuleViolationFileNameStrategy {
+        private static CountDownLatch firstClassificationEntered;
+        private static CountDownLatch releaseFirstClassification;
+        private static CountDownLatch secondRepairStarted;
+        private static CountDownLatch secondClassificationEntered;
+        private static AtomicInteger classifications;
+
+        static void prepare() {
+            firstClassificationEntered = new CountDownLatch(1);
+            releaseFirstClassification = new CountDownLatch(1);
+            secondRepairStarted = new CountDownLatch(1);
+            secondClassificationEntered = new CountDownLatch(1);
+            classifications = new AtomicInteger();
+        }
+
+        @Override
+        public String createRuleFileName(String ruleDescription) {
+            if (classifications.incrementAndGet() == 1) {
+                firstClassificationEntered.countDown();
+                await(releaseFirstClassification);
+            } else {
+                secondClassificationEntered.countDown();
+            }
+            return "derived";
+        }
+    }
+
+    /**
+     * Violations whose text is handed out only once released, so a save reading them can be held at that point.
+     */
+    private static class ViolationsReadOnRelease extends AbstractList<String> {
+        private final CountDownLatch reading = new CountDownLatch(1);
+        private final CountDownLatch release = new CountDownLatch(1);
+        private final List<String> violations;
+
+        ViolationsReadOnRelease(String... violations) {
+            this.violations = Arrays.asList(violations);
+        }
+
+        @Override
+        public String get(int index) {
+            reading.countDown();
+            await(release);
+            return violations.get(index);
+        }
+
+        @Override
+        public int size() {
+            return violations.size();
+        }
+    }
+
+    private static void await(CountDownLatch latch) {
+        try {
+            latch.await();
+        } catch (InterruptedException e) {
+            Thread.currentThread().interrupt();
+            throw new AssertionError(e);
+        }
+    }
+
+}
diff --git a/test.sh b/test.sh
new file mode 100755
index 00000000..d00e8c6e
--- /dev/null
+++ b/test.sh
@@ -0,0 +1,117 @@
+#!/usr/bin/env bash
+set -euo pipefail
+
+INVOKE_DIR="$PWD"
+cd "$(dirname "$0")"
+
+usage() {
+  echo "Usage: $0 --output_path <path> {base|new}" >&2
+  exit 2
+}
+
+OUTPUT_PATH=""
+MODE=""
+
+while [[ $# -gt 0 ]]; do
+  case "$1" in
+    --output_path)
+      [[ $# -ge 2 ]] || usage
+      OUTPUT_PATH="$2"
+      shift 2
+      ;;
+    base|new)
+      MODE="$1"
+      shift
+      ;;
+    *)
+      usage
+      ;;
+  esac
+done
+
+if [[ -z "$OUTPUT_PATH" || -z "$MODE" ]]; then
+  usage
+fi
+
+case "$OUTPUT_PATH" in
+  /*) ;;
+  *) OUTPUT_PATH="$INVOKE_DIR/$OUTPUT_PATH" ;;
+esac
+
+if [[ -L "$OUTPUT_PATH" || ( -e "$OUTPUT_PATH" && ! -f "$OUTPUT_PATH" ) ]]; then
+  echo "Output path $OUTPUT_PATH is not a regular file" >&2
+  exit 2
+fi
+
+mkdir -p "$(dirname "$OUTPUT_PATH")"
+# a report an earlier run left at the output path must never pass for the result of this run
+rm -f "$OUTPUT_PATH"
+
+case "$MODE" in
+  base)
+    GRADLE_TARGET="freezeStoreBaselineTest"
+    RESULT_DIR="archunit/build/test-results/freezeStoreBaselineTest"
+    ;;
+  new)
+    GRADLE_TARGET="freezeStoreMaintenanceTest"
+    RESULT_DIR="archunit/build/test-results/freezeStoreMaintenanceTest"
+    ;;
+esac
+
+SCRATCH="$(mktemp -d)"
+STAGED=""
+trap 'rm -rf "$SCRATCH"; [[ -z "$STAGED" ]] || rm -f "$STAGED"' EXIT
+
+rm -rf "$RESULT_DIR"
+
+# archunit/build.gradle compiles the jdk9main source set into the main output directory. Its
+# incremental pass then prunes main classes that were regenerated in the same build, which loses
+# unrelated class files and fails later builds with NoClassDefFoundError. Discarding the shared
+# output directory first makes every run a full, deterministic compile.
+rm -rf archunit/build/classes/java/main
+
+set +e
+./gradlew --offline --no-daemon -Dscan=false ":archunit:${GRADLE_TARGET}" 2>&1 | tee "$SCRATCH/gradle.log"
+STATUS="${PIPESTATUS[0]}"
+set -e
+
+REPORT="$SCRATCH/report.xml"
+shopt -s nullglob
+RESULT_FILES=("$RESULT_DIR"/*.xml)
+shopt -u nullglob
+
+if [[ ${#RESULT_FILES[@]} -gt 0 ]]; then
+  {
+    echo '<?xml version="1.0" encoding="UTF-8"?>'
+    echo '<testsuites>'
+    for result_file in "${RESULT_FILES[@]}"; do
+      sed '1{/^<?xml/d;}' "$result_file"
+    done
+    echo '</testsuites>'
+  } > "$REPORT"
+else
+  echo "No JUnit XML was produced by $GRADLE_TARGET" >&2
+  {
+    echo '<?xml version="1.0" encoding="UTF-8"?>'
+    echo '<testsuites>'
+    echo "<testsuite name=\"${GRADLE_TARGET}\" tests=\"1\" skipped=\"0\" failures=\"0\" errors=\"1\">"
+    echo "<testcase classname=\"${GRADLE_TARGET}\" name=\"build\">"
+    echo "<error message=\"Gradle produced no JUnit XML for ${GRADLE_TARGET}\"><![CDATA["
+    tail -n 200 "$SCRATCH/gradle.log" | sed 's/]]>/]]]]><![CDATA[>/g'
+    echo ']]></error>'
+    echo '</testcase>'
+    echo '</testsuite>'
+    echo '</testsuites>'
+  } > "$REPORT"
+  if [[ "$STATUS" -eq 0 ]]; then
+    STATUS=1
+  fi
+fi
+
+# publish the report of this run in one step, so the output path never holds a partial one
+STAGED="$(mktemp "$(dirname "$OUTPUT_PATH")/.results.XXXXXX")"
+cp "$REPORT" "$STAGED"
+chmod 644 "$STAGED"
+mv -f "$STAGED" "$OUTPUT_PATH"
+STAGED=""
+exit "$STATUS"

__SHIPD_PATCH_CONTENT__
git apply test.patch

# Create Dockerfile
cat > Dockerfile << '__SHIPD_DOCKERFILE_CONTENT__'
FROM public.ecr.aws/d3j8x8q7/olympus-base-jvm:latest

ENV JAVA_HOME=${JDK25_HOME}
ENV PATH=${JDK25_HOME}/bin:${PATH}

RUN mkdir -p /opt/gradle-cache/init.d && \
    printf '%s\n' \
      'gradle.settingsEvaluated { settings ->' \
      '  try { settings.develocity.buildScan.publishing.onlyIf { false } } catch (Exception ignore) { }' \
      '}' > /opt/gradle-cache/init.d/no-build-scan.gradle

WORKDIR /app
COPY . .

RUN chmod +x ./gradlew

RUN ./gradlew --no-daemon --version

RUN printf '%s\n' \
      'gradle.beforeProject { project ->' \
      '  project.tasks.register("cacheOfflineDependencies") {' \
      '    doLast {' \
      '      ["testRuntimeClasspath", "testCompileClasspath", "testFixturesRuntimeClasspath", "jacocoAgent", "jacocoAnt"].each { name ->' \
      '        try { project.configurations.named(name).get().files } catch (Exception ignore) { }' \
      '      }' \
      '    }' \
      '  }' \
      '}' > /tmp/cache-offline.init.gradle

RUN ./gradlew --no-daemon -I /tmp/cache-offline.init.gradle \
      :archunit:testClasses :archunit:compileJdk9mainJava

RUN ./gradlew --no-daemon -I /tmp/cache-offline.init.gradle \
      cacheOfflineDependencies

RUN rm -f /tmp/cache-offline.init.gradle && \
    rm -rf /opt/gradle-cache/daemon /opt/gradle-cache/.tmp /app/.gradle && \
    chmod -R a+rwX /opt/gradle-cache /app

CMD ["/bin/bash"]

__SHIPD_DOCKERFILE_CONTENT__

# Write solution patch (reference only — not applied)
cat > solution.patch << '__SHIPD_SOLUTION_CONTENT__'
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java
new file mode 100644
index 00000000..036dac97
--- /dev/null
+++ b/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleDescriptionFileNames.java
@@ -0,0 +1,150 @@
+/*
+ * Copyright 2014-2026 TNG Technology Consulting GmbH
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *     http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+package com.tngtech.archunit.library.freeze;
+
+import java.nio.charset.StandardCharsets;
+import java.security.MessageDigest;
+import java.security.NoSuchAlgorithmException;
+import java.util.Locale;
+
+import com.tngtech.archunit.library.freeze.TextFileBasedViolationStore.RuleViolationFileNameStrategy;
+
+import static com.tngtech.archunit.library.freeze.FreezingArchRule.ensureUnixLineBreaks;
+
+/**
+ * Names a rule violation file after the rule it stores, so that the store folder can be read by a human and reviewed
+ * like any other source file.
+ * <p>
+ * The name is a readable prefix taken from the rule description followed by a fingerprint of the whole description.
+ * The prefix keeps only characters every file system accepts and is cut to a fixed length, which two different rules
+ * can well share; the fingerprint is what keeps their names apart. Deriving both from the description alone makes the
+ * name of a rule the same in every run and on every machine, which is what lets the store recognize a file it wrote
+ * earlier.
+ */
+class RuleDescriptionFileNames implements RuleViolationFileNameStrategy {
+    private static final int MAXIMUM_PREFIX_LENGTH = 183;
+    private static final int MINIMUM_WORD_LENGTH = 4;
+    private static final int MAXIMUM_WORD_LENGTH = 120;
+    private static final int FINGERPRINT_LENGTH = 16;
+    private static final String EMPTY_PREFIX_REPLACEMENT = "rule";
+    private static final char SEPARATOR = '-';
+
+    @Override
+    public String createRuleFileName(String ruleDescription) {
+        String normalizedDescription = ensureUnixLineBreaks(ruleDescription);
+        return prefixKeepingAWord(normalizedDescription) + SEPARATOR + fingerprintOf(normalizedDescription);
+    }
+
+    private static String prefixKeepingAWord(String ruleDescription) {
+        String prefix = readablePrefixOf(ruleDescription);
+        if (keepsAWordOf(prefix, ruleDescription)) {
+            return prefix;
+        }
+        int firstWord = indexOfFirstWordWorthKeeping(ruleDescription);
+        return firstWord < 0 ? prefix : readablePrefixOf(ruleDescription.substring(firstWord));
+    }
+
+    private static boolean keepsAWordOf(String prefix, String ruleDescription) {
+        for (String word : ruleDescription.split("[^A-Za-z0-9]+")) {
+            if (isWorthKeeping(word.length()) && holdsWholeWord(prefix, word)) {
+                return true;
+            }
+        }
+        return false;
+    }
+
+    // a word the prefix holds only as the start of a longer one, or only as far as the cut reached, is no word the
+    // name kept, so an occurrence counts only where it begins and ends a word of the prefix as well
+    private static boolean holdsWholeWord(String prefix, String word) {
+        for (int found = prefix.indexOf(word); found >= 0; found = prefix.indexOf(word, found + 1)) {
+            if (endsAWord(prefix, found - 1) && endsAWord(prefix, found + word.length())) {
+                return true;
+            }
+        }
+        return false;
+    }
+
+    private static boolean endsAWord(String prefix, int index) {
+        return index < 0 || index >= prefix.length() || !isWordCharacter(prefix.charAt(index));
+    }
+
+    // a word longer than the prefix can hold is no word the name could keep whole, so an overlong one is passed over
+    // rather than cut, which is what lets a later word of a length that does fit be the one the name keeps
+    private static boolean isWorthKeeping(int wordLength) {
+        return wordLength >= MINIMUM_WORD_LENGTH && wordLength <= MAXIMUM_WORD_LENGTH;
+    }
+
+    private static int indexOfFirstWordWorthKeeping(String ruleDescription) {
+        int wordStart = -1;
+        for (int i = 0; i <= ruleDescription.length(); i++) {
+            if (i < ruleDescription.length() && isWordCharacter(ruleDescription.charAt(i))) {
+                wordStart = wordStart < 0 ? i : wordStart;
+            } else if (wordStart >= 0) {
+                if (isWorthKeeping(i - wordStart)) {
+                    return wordStart;
+                }
+                wordStart = -1;
+            }
+        }
+        return -1;
+    }
+
+    private static boolean isWordCharacter(char character) {
+        return (character >= 'a' && character <= 'z')
+                || (character >= 'A' && character <= 'Z')
+                || (character >= '0' && character <= '9');
+    }
+
+    private static String readablePrefixOf(String ruleDescription) {
+        StringBuilder prefix = new StringBuilder();
+        for (int i = 0; i < ruleDescription.length() && prefix.length() < MAXIMUM_PREFIX_LENGTH; i++) {
+            char character = ruleDescription.charAt(i);
+            if (isSafe(character)) {
+                prefix.append(character);
+            } else if (prefix.length() > 0 && prefix.charAt(prefix.length() - 1) != SEPARATOR) {
+                prefix.append(SEPARATOR);
+            }
+        }
+        while (prefix.length() > 0 && prefix.charAt(prefix.length() - 1) == SEPARATOR) {
+            prefix.setLength(prefix.length() - 1);
+        }
+        return prefix.length() > 0 ? prefix.toString() : EMPTY_PREFIX_REPLACEMENT;
+    }
+
+    private static boolean isSafe(char character) {
+        return (character >= 'a' && character <= 'z')
+                || (character >= 'A' && character <= 'Z')
+                || (character >= '0' && character <= '9')
+                || character == '_';
+    }
+
+    private static String fingerprintOf(String ruleDescription) {
+        byte[] digest = digestOf(ruleDescription.getBytes(StandardCharsets.UTF_8));
+        StringBuilder fingerprint = new StringBuilder(FINGERPRINT_LENGTH);
+        for (int i = 0; fingerprint.length() < FINGERPRINT_LENGTH; i++) {
+            fingerprint.append(String.format(Locale.ROOT, "%02x", digest[i]));
+        }
+        return fingerprint.toString();
+    }
+
+    private static byte[] digestOf(byte[] bytes) {
+        try {
+            return MessageDigest.getInstance("SHA-256").digest(bytes);
+        } catch (NoSuchAlgorithmException e) {
+            throw new StoreInitializationFailedException("Cannot derive rule violation file names without SHA-256", e);
+        }
+    }
+}
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java
new file mode 100644
index 00000000..000e521e
--- /dev/null
+++ b/archunit/src/main/java/com/tngtech/archunit/library/freeze/RuleViolationFileNameStrategyFactory.java
@@ -0,0 +1,75 @@
+/*
+ * Copyright 2014-2026 TNG Technology Consulting GmbH
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *     http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+package com.tngtech.archunit.library.freeze;
+
+import java.lang.reflect.Constructor;
+import java.lang.reflect.Modifier;
+import java.util.UUID;
+
+import com.tngtech.archunit.base.MayResolveTypesViaReflection;
+import com.tngtech.archunit.library.freeze.TextFileBasedViolationStore.RuleViolationFileNameStrategy;
+
+import static com.tngtech.archunit.base.ReflectionUtils.newInstanceOf;
+
+/**
+ * Creates the {@link RuleViolationFileNameStrategy} a {@link TextFileBasedViolationStore} names its rule violation
+ * files by.
+ * <p>
+ * The configured value {@code random} keeps the historic behaviour of naming every file by a fresh {@link UUID}, which
+ * derives nothing from a rule description. The configured value {@code description} names every file after the rule it
+ * stores. Any other value is the fully qualified class name of a strategy of the user's own. The latter two derive the
+ * name from the description, which is what lets a store recognize an entry recording some other name.
+ */
+class RuleViolationFileNameStrategyFactory {
+    static final String RANDOM = "random";
+    static final String DESCRIPTION = "description";
+
+    static RuleViolationFileNameStrategy create(String configuredValue) {
+        if (RANDOM.equals(configuredValue)) {
+            return randomFileNames();
+        }
+        if (DESCRIPTION.equals(configuredValue)) {
+            return new RuleDescriptionFileNames();
+        }
+        return createInstance(configuredValue);
+    }
+
+    static boolean derivesNames(String configuredValue) {
+        return !RANDOM.equals(configuredValue);
+    }
+
+    private static RuleViolationFileNameStrategy randomFileNames() {
+        return ruleDescription -> UUID.randomUUID().toString();
+    }
+
+    @MayResolveTypesViaReflection(reason = "This is not part of the import process")
+    private static RuleViolationFileNameStrategy createInstance(String strategyClassName) {
+        try {
+            Class<?> strategyClass = Class.forName(strategyClassName);
+            Constructor<?> constructor = strategyClass.getDeclaredConstructor();
+            if (!Modifier.isPublic(constructor.getModifiers())) {
+                throw new IllegalArgumentException("The no-argument constructor is not public");
+            }
+            return (RuleViolationFileNameStrategy) newInstanceOf(strategyClass);
+        } catch (Exception e) {
+            String message = String.format("Could not instantiate %s of configured type '%s.%s=%s'",
+                    RuleViolationFileNameStrategy.class.getSimpleName(),
+                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME,
+                    TextFileBasedViolationStore.FILE_NAMES_PROPERTY_NAME, strategyClassName);
+            throw new StoreInitializationFailedException(message, e);
+        }
+    }
+}
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java
new file mode 100644
index 00000000..5c638afa
--- /dev/null
+++ b/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java
@@ -0,0 +1,441 @@
+/*
+ * Copyright 2014-2026 TNG Technology Consulting GmbH
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *     http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+package com.tngtech.archunit.library.freeze;
+
+import java.io.File;
+import java.io.IOException;
+import java.nio.file.Files;
+import java.nio.file.InvalidPathException;
+import java.nio.file.LinkOption;
+import java.nio.file.Path;
+import java.util.ArrayList;
+import java.util.Collection;
+import java.util.Comparator;
+import java.util.LinkedHashMap;
+import java.util.LinkedHashSet;
+import java.util.List;
+import java.util.Map;
+import java.util.Set;
+import java.util.SortedMap;
+import java.util.TreeMap;
+
+import com.tngtech.archunit.library.freeze.TextFileBasedViolationStore.RuleViolationFileNameStrategy;
+import org.slf4j.Logger;
+import org.slf4j.LoggerFactory;
+
+import static java.util.Collections.emptyList;
+import static java.util.stream.Collectors.toSet;
+
+/**
+ * Reconciles the index of a {@link TextFileBasedViolationStore} with the contents of its store folder.
+ * <p>
+ * The store owns its index and the files its entries record, and owns nothing else. An entry recording a name that does
+ * not denote a regular file directly inside the store folder is broken, an entry whose file yields no violations is
+ * resolved, and an entry recording a name other than the one its rule derives is misplaced; all three are owned, so
+ * they may be discarded or moved. A name recorded by more than one entry is shared and a regular file no entry records
+ * is unowned; neither is owned, so neither is ever changed. A name two rules derive alike is colliding and a derived
+ * name something else already occupies or another entry records is occupied; no file is ever moved onto either, which
+ * leaves an entry holding violations where it is, while a broken or resolved entry is discarded all the same.
+ */
+class StoreIntegrity {
+    private static final Logger log = LoggerFactory.getLogger(StoreIntegrity.class);
+
+    private static final String IGNORE = "ignore";
+    private static final String REPAIR = "repair";
+    private static final String FAIL = "fail";
+
+    private final File storeFolder;
+    private final String indexFileName;
+    private final ViolationsReader violationsReader;
+    private final RuleViolationFileNameStrategy fileNameStrategy;
+    private final boolean derivesNames;
+
+    StoreIntegrity(File storeFolder, String indexFileName, ViolationsReader violationsReader,
+            RuleViolationFileNameStrategy fileNameStrategy, boolean derivesNames) {
+        this.storeFolder = storeFolder;
+        this.indexFileName = indexFileName;
+        this.violationsReader = violationsReader;
+        this.fileNameStrategy = fileNameStrategy;
+        this.derivesNames = derivesNames;
+    }
+
+    static Mode parseMode(String configuredValue) {
+        switch (configuredValue) {
+            case IGNORE:
+                return Mode.IGNORE;
+            case REPAIR:
+                return Mode.REPAIR;
+            case FAIL:
+                return Mode.FAIL;
+            default:
+                throw new StoreInitializationFailedException(String.format(
+                        "Configuration %s.%s only accepts the values %s, %s and %s, but was '%s'",
+                        ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, TextFileBasedViolationStore.INTEGRITY_PROPERTY_NAME,
+                        IGNORE, REPAIR, FAIL, configuredValue));
+        }
+    }
+
+    void rejectBeforeCreating(Mode mode, File indexFile, boolean storeUpdateAllowed) {
+        if (mode == Mode.REPAIR && !storeUpdateAllowed) {
+            throw new StoreInitializationFailedException(String.format(
+                    "Repairing the violation store requires configuration %s.%s=true",
+                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME,
+                    TextFileBasedViolationStore.ALLOW_STORE_UPDATE_PROPERTY_NAME));
+        }
+        // an existing index is left to examine, which waits for any store of the folder in the middle of a save
+        if (mode == Mode.FAIL && !nameIsTaken(indexFile)) {
+            rejectFindings(classify(new TreeMap<>()));
+        }
+    }
+
+    void examine(Mode mode, TextFileBasedViolationStore.FileSyncedProperties index) {
+        if (mode == Mode.IGNORE) {
+            return;
+        }
+        synchronized (index) {
+            // the index is shared per path for the lifetime of the JVM, so it may have been loaded
+            // before something rewrote the file; both modes examine the file as it is on disk
+            index.reloadFromFileSystem();
+            List<Finding> findings = classify(index.entriesByRuleDescription());
+            if (mode == Mode.REPAIR) {
+                repair(findings, index);
+            } else {
+                rejectFindings(findings);
+            }
+        }
+    }
+
+    private void rejectFindings(List<Finding> findings) {
+        if (!findings.isEmpty()) {
+            throw new StoreInitializationFailedException(describe(findings));
+        }
+    }
+
+    private List<Finding> classify(SortedMap<String, String> entries) {
+        Set<String> sharedNames = namesDenotingOneFileTwice(entries.values());
+        SortedMap<String, String> derivedNames = derivedNames(entries.keySet());
+        Set<String> collidingNames = namesDenotingOneFileTwice(derivedNames.values());
+        Set<File> recordedFiles = entries.values().stream()
+                .map(recordedName -> denotedFileOf(resolvedIn(storeFolder, recordedName)))
+                .collect(toSet());
+
+        List<Finding> findings = new ArrayList<>();
+        for (Map.Entry<String, String> entry : entries.entrySet()) {
+            Finding finding = findingFor(entry.getKey(), entry.getValue(), derivedNames.get(entry.getKey()),
+                    sharedNames, collidingNames, recordedFiles);
+            if (finding != null) {
+                findings.add(finding);
+            }
+        }
+        for (String unownedFileName : unownedFileNames(recordedFiles)) {
+            findings.add(new Finding(Condition.UNOWNED, null, unownedFileName, null));
+        }
+        findings.sort(Finding.REPORTING_ORDER);
+        return findings;
+    }
+
+    private Finding findingFor(String ruleDescription, String recordedName, String derivedName,
+            Set<String> sharedNames, Set<String> collidingNames, Set<File> recordedFiles) {
+        if (sharedNames.contains(recordedName)) {
+            return new Finding(Condition.SHARED, ruleDescription, recordedName, null);
+        }
+        if (!isOwnedFile(recordedName)) {
+            return new Finding(Condition.BROKEN, ruleDescription, recordedName, null);
+        }
+        Contents contents = contentsOf(recordedName);
+        if (contents == Contents.GONE) {
+            return new Finding(Condition.BROKEN, ruleDescription, recordedName, null);
+        }
+        if (contents == Contents.NONE) {
+            return new Finding(Condition.RESOLVED, ruleDescription, recordedName, null);
+        }
+        if (derivedName != null && collidingNames.contains(derivedName)) {
+            return new Finding(Condition.COLLIDING, ruleDescription, recordedName, derivedName);
+        }
+        if (derivedName == null || derivedName.equals(recordedName)) {
+            return null;
+        }
+        return canHold(derivedName, recordedFiles)
+                ? new Finding(Condition.MISPLACED, ruleDescription, recordedName, derivedName)
+                : new Finding(Condition.OCCUPIED, ruleDescription, recordedName, derivedName);
+    }
+
+    private Contents contentsOf(String recordedName) {
+        try {
+            return violationsReader.readViolations(recordedName).isEmpty() ? Contents.NONE : Contents.SOME;
+        } catch (StoreReadException e) {
+            return isOwnedFile(recordedName) ? Contents.UNREADABLE : Contents.GONE;
+        }
+    }
+
+    private SortedMap<String, String> derivedNames(Collection<String> ruleDescriptions) {
+        SortedMap<String, String> derived = new TreeMap<>();
+        if (derivesNames) {
+            for (String ruleDescription : ruleDescriptions) {
+                derived.put(ruleDescription, checkedName(fileNameStrategy.createRuleFileName(ruleDescription), ruleDescription));
+            }
+        }
+        return derived;
+    }
+
+    private static String checkedName(String derivedName, String ruleDescription) {
+        if (derivedName == null || derivedName.isEmpty()) {
+            throw new StoreInitializationFailedException(String.format(
+                    "Configuration %s.%s yields no file name for rule '%s'",
+                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME,
+                    TextFileBasedViolationStore.FILE_NAMES_PROPERTY_NAME, ruleDescription));
+        }
+        return derivedName;
+    }
+
+    private Set<String> namesDenotingOneFileTwice(Collection<String> names) {
+        Map<File, String> firstNameByFile = new LinkedHashMap<>();
+        Set<String> shared = new LinkedHashSet<>();
+        for (String name : names) {
+            File denoted = denotedFileOf(resolvedIn(storeFolder, name));
+            String firstName = firstNameByFile.get(denoted);
+            if (firstName == null) {
+                firstName = firstNameOfSameFile(firstNameByFile, denoted);
+            }
+            if (firstName != null) {
+                shared.add(firstName);
+                shared.add(name);
+            } else {
+                firstNameByFile.put(denoted, name);
+            }
+        }
+        return shared;
+    }
+
+    private static String firstNameOfSameFile(Map<File, String> firstNameByFile, File denoted) {
+        for (Map.Entry<File, String> known : firstNameByFile.entrySet()) {
+            if (isSameExistingFile(known.getKey(), denoted)) {
+                return known.getValue();
+            }
+        }
+        return null;
+    }
+
+    // canonical paths collapse a symbolic link onto its target, but two hard links to one file
+    // stay two distinct canonical paths, so file identity has to be asked of the filesystem;
+    // a name that denotes no file yet, or that no path can hold, is left to the canonical comparison
+    private static boolean isSameExistingFile(File one, File other) {
+        try {
+            return Files.isSameFile(one.toPath(), other.toPath());
+        } catch (IOException | InvalidPathException e) {
+            return false;
+        }
+    }
+
+    private boolean isOwnedFile(String recordedName) {
+        return denotesFileDirectlyIn(storeFolder, resolvedIn(storeFolder, recordedName));
+    }
+
+    private boolean canHold(String derivedName, Set<File> recordedFiles) {
+        // a name an entry records belongs to that entry even while nothing exists under it, so moving a file
+        // there would hand that entry the violations of another rule
+        File target = resolvedIn(storeFolder, derivedName);
+        return !denotesSameFile(target, new File(storeFolder, indexFileName))
+                && !nameIsTaken(target) && !recordedFiles.contains(denotedFileOf(target))
+                && liesDirectlyIn(storeFolder, target);
+    }
+
+    static boolean nameIsTaken(File file) {
+        try {
+            return Files.exists(file.toPath(), LinkOption.NOFOLLOW_LINKS);
+        } catch (InvalidPathException e) {
+            return false;
+        }
+    }
+
+    // a name is resolved against the folder the way a path is, so an absolute name denotes that very path, while
+    // java.io.File(File, String) would take it for a name inside the folder
+    static File resolvedIn(File folder, String name) {
+        try {
+            return folder.toPath().resolve(name).toFile();
+        } catch (InvalidPathException e) {
+            // no path can hold such a name, so it is left to the checks that already refuse it
+            return new File(folder, name);
+        }
+    }
+
+    static boolean denotesFileDirectlyIn(File folder, File candidate) {
+        return candidate.isFile() && liesDirectlyIn(folder, candidate);
+    }
+
+    static boolean isDirectRegularFile(File folder, File candidate) {
+        // a link is not the file it points at, so a name left as a link is never taken
+        // for a file the store may write through
+        return Files.isRegularFile(candidate.toPath(), LinkOption.NOFOLLOW_LINKS) && liesDirectlyIn(folder, candidate);
+    }
+
+    static boolean denotesSameFile(File one, File other) {
+        File denotedOne = denotedFileOf(one);
+        File denotedOther = denotedFileOf(other);
+        return denotedOne.equals(denotedOther) || isSameExistingFile(denotedOne, denotedOther);
+    }
+
+    static boolean liesDirectlyIn(File folder, File candidate) {
+        // a canonical path stops at a link that points at nothing, so a dangling link would pass for a name in the
+        // folder although writing through it creates a file wherever it points; a taken name has to resolve fully
+        try {
+            Path location = nameIsTaken(candidate)
+                    ? candidate.toPath().toRealPath()
+                    : candidate.getAbsoluteFile().getParentFile().toPath().toRealPath().resolve(candidate.getName());
+            return folder.toPath().toRealPath().equals(location.getParent());
+        } catch (IOException | InvalidPathException e) {
+            return false;
+        }
+    }
+
+    private List<String> unownedFileNames(Set<File> recordedFiles) {
+        File[] presentFiles = storeFolder.listFiles();
+        if (presentFiles == null) {
+            return emptyList();
+        }
+        List<String> unowned = new ArrayList<>();
+        for (File presentFile : presentFiles) {
+            String name = presentFile.getName();
+            if (isDirectRegularFile(storeFolder, presentFile)
+                    && !indexFileName.equals(name) && !recordedFiles.contains(denotedFileOf(presentFile))) {
+                unowned.add(name);
+            }
+        }
+        return unowned;
+    }
+
+    private static File denotedFileOf(File file) {
+        try {
+            return file.getCanonicalFile();
+        } catch (IOException e) {
+            return file;
+        }
+    }
+
+    static boolean deleteDenotedFile(File recorded) {
+        File denoted = denotedFileOf(recorded);
+        boolean removed = denoted.delete() || !denoted.exists();
+        if (!denoted.getPath().equals(recorded.getPath())) {
+            removed = (recorded.delete() || !nameIsTaken(recorded)) && removed;
+        }
+        return removed;
+    }
+
+    private boolean moveDenotedFile(File recorded, File destination) {
+        // an entry naming a link owns the file the link points at, so that file is what moves and the link,
+        // which would point at nothing afterwards, goes with it; the index is never an entry's file to move
+        File denoted = denotedFileOf(recorded);
+        if (denotesSameFile(denoted, new File(storeFolder, indexFileName)) || !denoted.renameTo(destination)) {
+            return false;
+        }
+        if (Files.isSymbolicLink(recorded.toPath()) && !recorded.delete()) {
+            log.warn("Could not delete link {} to the file moved to {}",
+                    recorded.getAbsolutePath(), destination.getAbsolutePath());
+        }
+        return true;
+    }
+
+    private void repair(List<Finding> findings, TextFileBasedViolationStore.FileSyncedProperties index) {
+        List<String> discarded = new ArrayList<>();
+        SortedMap<String, String> moved = new TreeMap<>();
+        for (Finding finding : findings) {
+            if (finding.condition == Condition.BROKEN) {
+                discarded.add(finding.ruleDescription);
+            } else if (finding.condition == Condition.RESOLVED) {
+                if (deleteDenotedFile(resolvedIn(storeFolder, finding.fileName))) {
+                    discarded.add(finding.ruleDescription);
+                }
+            } else if (finding.condition == Condition.MISPLACED && moveDenotedFile(
+                    resolvedIn(storeFolder, finding.fileName), resolvedIn(storeFolder, finding.derivedName))) {
+                moved.put(finding.ruleDescription, finding.derivedName);
+            }
+        }
+        index.apply(discarded, moved);
+    }
+
+    private String describe(List<Finding> findings) {
+        StringBuilder message = new StringBuilder("Violation store at ")
+                .append(storeFolder.getAbsolutePath())
+                .append(" is inconsistent.");
+        Condition reported = null;
+        for (Finding finding : findings) {
+            if (finding.condition != reported) {
+                reported = finding.condition;
+                message.append(' ').append(reported.label).append(':');
+            }
+            message.append(' ').append(finding.describe()).append(';');
+        }
+        return message.toString();
+    }
+
+    enum Mode {
+        IGNORE,
+        REPAIR,
+        FAIL
+    }
+
+    private enum Contents {
+        NONE,
+        SOME,
+        UNREADABLE,
+        GONE
+    }
+
+    private enum Condition {
+        BROKEN("Broken entries"),
+        RESOLVED("Resolved entries"),
+        MISPLACED("Misplaced entries"),
+        SHARED("Shared entries"),
+        COLLIDING("Colliding entries"),
+        OCCUPIED("Occupied entries"),
+        UNOWNED("Unowned files");
+
+        private final String label;
+
+        Condition(String label) {
+            this.label = label;
+        }
+    }
+
+    interface ViolationsReader {
+        List<String> readViolations(String recordedName);
+    }
+
+    private static class Finding {
+        private static final Comparator<Finding> REPORTING_ORDER =
+                Comparator.<Finding, Condition>comparing(finding -> finding.condition).thenComparing(Finding::sortKey);
+
+        private final Condition condition;
+        private final String ruleDescription;
+        private final String fileName;
+        private final String derivedName;
+
+        Finding(Condition condition, String ruleDescription, String fileName, String derivedName) {
+            this.condition = condition;
+            this.ruleDescription = ruleDescription;
+            this.fileName = fileName;
+            this.derivedName = derivedName;
+        }
+
+        String describe() {
+            return ruleDescription == null ? fileName : ruleDescription + " (" + fileName + ")";
+        }
+
+        private String sortKey() {
+            return ruleDescription == null ? fileName : ruleDescription;
+        }
+    }
+}
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java
index fd2bcc56..9f806bb1 100644
--- a/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java
+++ b/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java
@@ -20,8 +20,13 @@ import java.io.FileInputStream;
 import java.io.FileOutputStream;
 import java.io.IOException;
 import java.nio.file.Files;
+import java.util.ArrayList;
+import java.util.Collection;
 import java.util.List;
+import java.util.Map;
 import java.util.Properties;
+import java.util.SortedMap;
+import java.util.TreeMap;
 import java.util.UUID;
 import java.util.concurrent.ConcurrentHashMap;
 import java.util.regex.Pattern;
@@ -38,6 +43,9 @@ import static com.tngtech.archunit.PublicAPI.Usage.ACCESS;
 import static com.tngtech.archunit.PublicAPI.Usage.INHERITANCE;
 import static com.tngtech.archunit.library.freeze.FreezingArchRule.ensureUnixLineBreaks;
 import static java.nio.charset.StandardCharsets.UTF_8;
+import static java.util.Collections.emptyList;
+import static java.util.Collections.emptyMap;
+import static java.util.Collections.singletonList;
 import static java.util.stream.Collectors.toList;
 
 /**
@@ -59,6 +67,11 @@ import static java.util.stream.Collectors.toList;
  * default.path=...               # string: the path of the folder where violation files will be stored
  * default.allowStoreCreation=... # boolean: whether to allow creating a new index file
  * default.allowStoreUpdate=...   # boolean: whether to allow updating any store file
+ * default.fileNames=...          # string: "random" for random {@link UUID} names, "description" for names derived
+ *                                #         from the rule description, otherwise the fully qualified class name of a
+ *                                #         {@link RuleViolationFileNameStrategy} deriving the name likewise
+ * default.integrity=...          # string: "ignore" to examine nothing, "repair" to reconcile the index with the
+ *                                #         folder, "fail" to reject an inconsistent store
  * </code></pre>
  */
 @PublicAPI(usage = ACCESS)
@@ -66,18 +79,26 @@ public final class TextFileBasedViolationStore implements ViolationStore {
     private static final Logger log = LoggerFactory.getLogger(TextFileBasedViolationStore.class);
 
     private static final Pattern UNESCAPED_LINE_BREAK_PATTERN = Pattern.compile("(?<!\\\\)\n");
+    private static final Pattern LINE_BREAKS_ONLY_PATTERN = Pattern.compile("[\r\n]*");
     private static final String STORE_PATH_PROPERTY_NAME = "default.path";
     private static final String STORE_PATH_DEFAULT = "archunit_store";
     private static final String STORED_RULES_FILE_NAME = "stored.rules";
     private static final String ALLOW_STORE_CREATION_PROPERTY_NAME = "default.allowStoreCreation";
     private static final String ALLOW_STORE_CREATION_DEFAULT = "false";
-    private static final String ALLOW_STORE_UPDATE_PROPERTY_NAME = "default.allowStoreUpdate";
+    static final String ALLOW_STORE_UPDATE_PROPERTY_NAME = "default.allowStoreUpdate";
     private static final String ALLOW_STORE_UPDATE_DEFAULT = "true";
+    static final String INTEGRITY_PROPERTY_NAME = "default.integrity";
+    private static final String INTEGRITY_DEFAULT = "ignore";
+    static final String FILE_NAMES_PROPERTY_NAME = "default.fileNames";
 
     private static final ConcurrentHashMap<String, FileSyncedProperties> STORED_RULES_BY_PATH = new ConcurrentHashMap<>();
 
-    private final RuleViolationFileNameStrategy ruleViolationFileNameStrategy;
+    private final RuleViolationFileNameStrategy configuredFileNameStrategy;
 
+    private RuleViolationFileNameStrategy ruleViolationFileNameStrategy;
+
+    private StoreIntegrity.Mode integrityMode;
+    private boolean derivesFileNames;
     private boolean storeCreationAllowed;
     private boolean storeUpdateAllowed;
     private File storeFolder;
@@ -89,28 +110,55 @@ public final class TextFileBasedViolationStore implements ViolationStore {
      * @see #TextFileBasedViolationStore(RuleViolationFileNameStrategy)
      */
     public TextFileBasedViolationStore() {
-        this(__ -> UUID.randomUUID().toString());
+        this(null);
     }
 
     /**
-     * Creates a {@link TextFileBasedViolationStore} with a custom strategy for rule violation file naming
+     * Creates a {@link TextFileBasedViolationStore} with a custom strategy for rule violation file naming.<br>
+     * Configuring {@code default.fileNames} for such a store is rejected, since the strategy is already given here.
      *
      * @param ruleViolationFileNameStrategy controls how the rule violation file name is derived from the rule description
      */
     public TextFileBasedViolationStore(RuleViolationFileNameStrategy ruleViolationFileNameStrategy) {
-        this.ruleViolationFileNameStrategy = ruleViolationFileNameStrategy;
+        this.configuredFileNameStrategy = ruleViolationFileNameStrategy;
     }
 
     @Override
     public void initialize(Properties properties) {
         storeCreationAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_CREATION_PROPERTY_NAME, ALLOW_STORE_CREATION_DEFAULT));
         storeUpdateAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_UPDATE_PROPERTY_NAME, ALLOW_STORE_UPDATE_DEFAULT));
+        integrityMode = StoreIntegrity.parseMode(properties.getProperty(INTEGRITY_PROPERTY_NAME, INTEGRITY_DEFAULT));
+        checkInitialization(configuredFileNameStrategy == null || properties.getProperty(FILE_NAMES_PROPERTY_NAME) == null,
+                "Cannot name rule violation files by the %s given to the constructor and by configuration %s.%s at once",
+                RuleViolationFileNameStrategy.class.getSimpleName(),
+                ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, FILE_NAMES_PROPERTY_NAME);
+        String configuredFileNames = properties.getProperty(FILE_NAMES_PROPERTY_NAME, RuleViolationFileNameStrategyFactory.RANDOM);
+        derivesFileNames = configuredFileNameStrategy != null
+                || RuleViolationFileNameStrategyFactory.derivesNames(configuredFileNames);
+        ruleViolationFileNameStrategy = canonicalNames(configuredFileNameStrategy != null
+                ? configuredFileNameStrategy
+                : RuleViolationFileNameStrategyFactory.create(configuredFileNames));
         String path = properties.getProperty(STORE_PATH_PROPERTY_NAME, STORE_PATH_DEFAULT);
         storeFolder = new File(path);
+        // rejects an absent index without default.allowStoreCreation, and one that is not a regular file directly in
+        // the folder, before the integrity check below examines anything
         File storedRulesFile = getStoredRulesFile();
         log.trace("Initializing {} at {}", TextFileBasedViolationStore.class.getSimpleName(), storedRulesFile.getAbsolutePath());
+        StoreIntegrity integrity = new StoreIntegrity(storeFolder, STORED_RULES_FILE_NAME, this::readRecordedViolations,
+                ruleViolationFileNameStrategy, derivesFileNames);
+        integrity.rejectBeforeCreating(integrityMode, storedRulesFile, storeUpdateAllowed);
         storedRules = getOrCreateStoredRules(storedRulesFile);
         checkInitialization(storedRules.initializationSuccessful(), "Cannot create rule store at %s", storedRulesFile.getAbsolutePath());
+        integrity.examine(integrityMode, storedRules);
+    }
+
+    private static RuleViolationFileNameStrategy canonicalNames(RuleViolationFileNameStrategy strategy) {
+        // the index records its values with Unix line breaks, so a name spelled otherwise would
+        // name the file that is written and never the file the entry records
+        return ruleDescription -> {
+            String fileName = strategy.createRuleFileName(ruleDescription);
+            return fileName == null ? null : ensureUnixLineBreaks(fileName);
+        };
     }
 
     private FileSyncedProperties getOrCreateStoredRules(File storedRulesFile) {
@@ -123,10 +171,16 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
     private File getStoredRulesFile() {
         File rulesFile = new File(storeFolder, STORED_RULES_FILE_NAME);
-        if (!rulesFile.exists() && !storeCreationAllowed) {
+        if (!StoreIntegrity.nameIsTaken(rulesFile)) {
+            if (!storeCreationAllowed) {
+                throw new StoreInitializationFailedException(String.format(
+                        "Creating new violation store is disabled (enable by configuration %s.%s=true)",
+                        ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_CREATION_PROPERTY_NAME));
+            }
+        } else if (!StoreIntegrity.isDirectRegularFile(storeFolder, rulesFile)) {
             throw new StoreInitializationFailedException(String.format(
-                    "Creating new violation store is disabled (enable by configuration %s.%s=true)",
-                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_CREATION_PROPERTY_NAME));
+                    "The rule store index %s is not a regular file within %s",
+                    STORED_RULES_FILE_NAME, storeFolder.getAbsolutePath()));
         }
         return rulesFile;
     }
@@ -150,8 +204,80 @@ public final class TextFileBasedViolationStore implements ViolationStore {
                     "Updating frozen violations is disabled (enable by configuration %s.%s=true)",
                     ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));
         }
-        String ruleFileName = ensureRuleFileName(rule);
-        write(violations, new File(storeFolder, ruleFileName));
+        // every store of this folder shares storedRules, and examining the folder locks it as well, so an examination
+        // waits until the entry of a rule being saved and its file are both in place
+        storedRules.runExclusively(() -> {
+            if (violations.isEmpty() && integrityMode == StoreIntegrity.Mode.REPAIR) {
+                discard(rule);
+            } else {
+                String ruleFileName = ensureRuleFileName(rule);
+                write(violations, StoreIntegrity.resolvedIn(storeFolder, ruleFileName));
+            }
+        });
+    }
+
+    private void discard(ArchRule rule) {
+        String ruleFileName = storedRules.getProperty(rule.getDescription());
+        if (ruleFileName == null) {
+            return;
+        }
+        File ruleDetails = StoreIntegrity.resolvedIn(storeFolder, ruleFileName);
+        if (sharedWithAnotherRule(rule.getDescription(), ruleDetails)) {
+            // the file is left to the other entry wherever it lies, so forgetting the rule touches nothing but the index
+            log.trace("Keeping {} of fully resolved rule '{}', which another rule is stored in as well",
+                    ruleDetails.getAbsolutePath(), rule.getDescription());
+        } else {
+            checkStoreCanOwn(rule.getDescription(), ruleFileName);
+            if (!StoreIntegrity.deleteDenotedFile(ruleDetails)) {
+                throw new StoreUpdateFailedException(String.format(
+                        "Cannot discard fully resolved rule '%s', because %s could not be deleted",
+                        rule.getDescription(), ruleDetails.getAbsolutePath()));
+            }
+        }
+        log.trace("Discarding fully resolved rule '{}' stored in file {}", rule.getDescription(), ruleFileName);
+        storedRules.apply(singletonList(rule.getDescription()), emptyMap());
+    }
+
+    private boolean sharedWithAnotherRule(String ruleDescription, File ruleDetails) {
+        String ownRuleDescription = ensureUnixLineBreaks(ruleDescription);
+        for (Map.Entry<String, String> entry : storedRules.entriesByRuleDescription().entrySet()) {
+            File recorded = StoreIntegrity.resolvedIn(storeFolder, entry.getValue());
+            if (!ownRuleDescription.equals(entry.getKey()) && StoreIntegrity.denotesSameFile(ruleDetails, recorded)) {
+                log.trace("File {} is recorded by rule '{}' as well", ruleDetails.getAbsolutePath(), entry.getKey());
+                return true;
+            }
+        }
+        return false;
+    }
+
+    private void checkStoreCanOwn(String ruleDescription, String fileName) {
+        boolean ownable = fileName != null && !fileName.isEmpty() && ownableTarget(ruleDescription, fileName);
+        if (!ownable) {
+            throw new StoreUpdateFailedException(String.format(
+                    "Cannot store rule violations in '%s' within %s, because the violation store does not own that file",
+                    fileName, storeFolder.getAbsolutePath()));
+        }
+    }
+
+    private boolean ownableTarget(String ruleDescription, String fileName) {
+        File target = StoreIntegrity.resolvedIn(storeFolder, fileName);
+        if (StoreIntegrity.denotesSameFile(target, new File(storeFolder, STORED_RULES_FILE_NAME))) {
+            return false;
+        }
+        boolean ownedByThisRule = fileName.equals(storedRules.getProperty(ruleDescription));
+        if (StoreIntegrity.nameIsTaken(target)) {
+            return ownedByThisRule && StoreIntegrity.denotesFileDirectlyIn(storeFolder, target);
+        }
+        return StoreIntegrity.liesDirectlyIn(storeFolder, target) && (ownedByThisRule || !recordedByAnEntry(target));
+    }
+
+    private boolean recordedByAnEntry(File target) {
+        for (String recordedFileName : storedRules.recordedFileNames()) {
+            if (StoreIntegrity.denotesSameFile(target, StoreIntegrity.resolvedIn(storeFolder, recordedFileName))) {
+                return true;
+            }
+        }
+        return false;
     }
 
     private void write(List<String> violations, File ruleDetails) {
@@ -176,14 +302,19 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
     private String ensureRuleFileName(ArchRule rule) {
         String ruleDescription = rule.getDescription();
-        String candidateFileName = ruleViolationFileNameStrategy.createRuleFileName(ruleDescription);
-        String existingFileName = storedRules.putIfAbsent(ruleDescription, candidateFileName);
-        if (existingFileName == null) {
-            log.trace("Assigning new file {} to rule '{}'", candidateFileName, ruleDescription);
-            return candidateFileName;
+        String recordedFileName = storedRules.getProperty(ruleDescription);
+        if (recordedFileName == null) {
+            String candidateFileName = ruleViolationFileNameStrategy.createRuleFileName(ruleDescription);
+            checkStoreCanOwn(ruleDescription, candidateFileName);
+            recordedFileName = storedRules.putIfAbsent(ruleDescription, candidateFileName);
+            if (recordedFileName == null) {
+                log.trace("Assigning new file {} to rule '{}'", candidateFileName, ruleDescription);
+                return candidateFileName;
+            }
         }
-        log.trace("Rule '{}' is already stored in file {}", ruleDescription, existingFileName);
-        return existingFileName;
+        checkStoreCanOwn(ruleDescription, recordedFileName);
+        log.trace("Rule '{}' is already stored in file {}", ruleDescription, recordedFileName);
+        return recordedFileName;
     }
 
     @Override
@@ -196,7 +327,17 @@ public final class TextFileBasedViolationStore implements ViolationStore {
     }
 
     private List<String> readLines(String ruleDetailsFileName) {
+        return linesOf(readStoreFile(ruleDetailsFileName));
+    }
+
+    private List<String> readRecordedViolations(String ruleDetailsFileName) {
         String violationsText = readStoreFile(ruleDetailsFileName);
+        // violations are only split at line feeds, so a lone carriage return would read as a violation
+        // of its own, while a file holding nothing but line breaks of whatever kind records none
+        return LINE_BREAKS_ONLY_PATTERN.matcher(violationsText).matches() ? emptyList() : linesOf(violationsText);
+    }
+
+    private List<String> linesOf(String violationsText) {
         return Splitter.on(UNESCAPED_LINE_BREAK_PATTERN).omitEmptyStrings().splitToStream(violationsText)
                 .map(this::unescape)
                 .collect(toList());
@@ -204,14 +345,14 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
     private String readStoreFile(String fileName) {
         try {
-            String result = new String(toByteArray(new File(storeFolder, fileName)), UTF_8);
+            String result = new String(toByteArray(StoreIntegrity.resolvedIn(storeFolder, fileName)), UTF_8);
             return ensureUnixLineBreaks(result);
         } catch (IOException e) {
             throw new StoreReadException(e);
         }
     }
 
-    private static class FileSyncedProperties {
+    static class FileSyncedProperties {
         private final File propertiesFile;
         private final Properties loadedProperties;
 
@@ -254,6 +395,24 @@ public final class TextFileBasedViolationStore implements ViolationStore {
             return result;
         }
 
+        synchronized void runExclusively(Runnable action) {
+            action.run();
+        }
+
+        synchronized void reloadFromFileSystem() {
+            Properties onDisk = loadRulesFrom(propertiesFile);
+            loadedProperties.clear();
+            loadedProperties.putAll(onDisk);
+        }
+
+        private static SortedMap<String, String> entriesOf(Properties properties) {
+            SortedMap<String, String> result = new TreeMap<>();
+            for (String ruleDescription : properties.stringPropertyNames()) {
+                result.put(ruleDescription, properties.getProperty(ruleDescription));
+            }
+            return result;
+        }
+
         boolean containsKey(String propertyName) {
             return loadedProperties.containsKey(ensureUnixLineBreaks(propertyName));
         }
@@ -262,6 +421,23 @@ public final class TextFileBasedViolationStore implements ViolationStore {
             return loadedProperties.getProperty(ensureUnixLineBreaks(propertyName));
         }
 
+        synchronized SortedMap<String, String> entriesByRuleDescription() {
+            return entriesOf(loadedProperties);
+        }
+
+        synchronized void apply(Collection<String> discardedRuleDescriptions, Map<String, String> movedRuleDescriptions) {
+            if (discardedRuleDescriptions.isEmpty() && movedRuleDescriptions.isEmpty()) {
+                return;
+            }
+            discardedRuleDescriptions.forEach(description -> loadedProperties.remove(ensureUnixLineBreaks(description)));
+            movedRuleDescriptions.forEach((description, fileName) -> loadedProperties.setProperty(ensureUnixLineBreaks(description), fileName));
+            syncFileSystem();
+        }
+
+        synchronized Collection<String> recordedFileNames() {
+            return new ArrayList<>(entriesOf(loadedProperties).values());
+        }
+
         synchronized String putIfAbsent(String key, String value) {
             String normalizedKey = ensureUnixLineBreaks(key);
             String existing = loadedProperties.getProperty(normalizedKey);
diff --git a/docs/userguide/008_The_Library_API.adoc b/docs/userguide/008_The_Library_API.adoc
index 10ed830c..6c470767 100644
--- a/docs/userguide/008_The_Library_API.adoc
+++ b/docs/userguide/008_The_Library_API.adoc
@@ -495,6 +495,30 @@ For example to allow the creation of the violation store in a specific environme
 -Darchunit.freeze.store.default.allowStoreCreation=true
 ----
 
+The text based store also offers two settings that control how it names the files it writes and
+whether it checks its own consistency while initializing
+
+[source,options="nowrap"]
+.archunit.properties
+----
+# controls how the files holding the violations of newly frozen rules are named
+# "random" (the default) picks a random file name, while "description" derives a readable
+# and stable name from the rule description
+# any other value is the fully qualified name of a RuleViolationFileNameStrategy
+# implementation with a public no-argument constructor
+freeze.store.default.fileNames=description
+
+# controls whether the store checks its index and its files against each other while initializing
+# "ignore" (the default) checks nothing
+# "repair" discards entries whose file is missing or no longer holds a violation and moves a
+# file that is not named after its rule to that name
+# "fail" leaves the store untouched and rejects initialization, naming everything it found
+freeze.store.default.integrity=repair
+----
+
+Note that `freeze.store.default.integrity=repair` changes the store on disk and therefore also
+requires `freeze.store.default.allowStoreUpdate` to be `true`, which is the default.
+
 It is also possible to allow all violations to be "refrozen", i.e. the store will just be updated
 with the current state, and the reported result will be success. Thus, it is effectively the same behavior
 as if all rules would never have been frozen.
diff --git a/docs/userguide/html/000_Index.html b/docs/userguide/html/000_Index.html
index 9a207a63..8576dd62 100644
--- a/docs/userguide/html/000_Index.html
+++ b/docs/userguide/html/000_Index.html
@@ -2487,6 +2487,32 @@ For example to allow the creation of the violation store in a specific environme
 </div>
 </div>
 <div class="paragraph">
+<p>The text based store also offers two settings that control how it names the files it writes and
+whether it checks its own consistency while initializing</p>
+</div>
+<div class="listingblock">
+<div class="title">archunit.properties</div>
+<div class="content">
+<pre class="highlightjs highlight nowrap"><code class="language-none hljs"># controls how the files holding the violations of newly frozen rules are named
+# "random" (the default) picks a random file name, while "description" derives a readable
+# and stable name from the rule description
+# any other value is the fully qualified name of a RuleViolationFileNameStrategy
+# implementation with a public no-argument constructor
+freeze.store.default.fileNames=description
+
+# controls whether the store checks its index and its files against each other while initializing
+# "ignore" (the default) checks nothing
+# "repair" discards entries whose file is missing or no longer holds a violation and moves a
+# file that is not named after its rule to that name
+# "fail" leaves the store untouched and rejects initialization, naming everything it found
+freeze.store.default.integrity=repair</code></pre>
+</div>
+</div>
+<div class="paragraph">
+<p>Note that <code>freeze.store.default.integrity=repair</code> changes the store on disk and therefore also
+requires <code>freeze.store.default.allowStoreUpdate</code> to be <code>true</code>, which is the default.</p>
+</div>
+<div class="paragraph">
 <p>It is also possible to allow all violations to be "refrozen", i.e. the store will just be updated
 with the current state, and the reported result will be success. Thus, it is effectively the same behavior
 as if all rules would never have been frozen.

__SHIPD_SOLUTION_CONTENT__

EOSCRIPT

# Navigate to project directory
cd archunit-kh76b5kmd3qae2eprydzvb9k4x8cve47

# Build and run Docker container (uncomment to use)
# docker build -t olympus-challenge .
# docker run -it --network=none olympus-challenge
