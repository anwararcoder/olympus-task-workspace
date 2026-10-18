cat <<'EOSCRIPT' | bash
#!/bin/bash

# Clone repository and checkout commit
git clone https://github.com/tng/archunit archunit-kh76b5kmd3qae2eprydzvb9k4x8cve47 --recurse-submodules
cd archunit-kh76b5kmd3qae2eprydzvb9k4x8cve47
git checkout ab6a677dd4b678f0ab1d9481df17222916705170

# Create challenge branch
git checkout -b shipd-challenge/kh76b5kmd3qae2eprydzvb9k4x8cve47-v26

# Write problem description (reference only)
cat > problem.md << '__SHIPD_PROBLEM_CONTENT__'
Ensure the `TextFileBasedViolationStore` maintains the integrity of its `stored.rules` index and files.

Setting `default.integrity` to `repair` will check the index and folder as they are on disk during initialization, even if the same folder was initialized before. Defaulting to `ignore` which checks nothing.

If an entry points to a path that is not a regular file directly within the folder, it is broken. This also applies if the file name is not a valid path.

If an entry is not broken and its file has no violations it is resolved. Files that only contain line breaks are also resolved.

Entries that point to the same file name are shared, even if nothing exists with that name. If multiple entries point to the same file they are also shared. Including through a symbolic or hard link. Even if that file is outside the folder.

The `TextFileBasedViolationStore` will not touch any shared entries or files that no entry points to. If an entry is shared and anything else it will remain shared.

When set to `repair` broken entries will be discarded.

When set to `repair` resolved entries and the file they point to will be discarded. If a resolved entry is a symbolic link the file it points to will be deleted as well.

If using `repair` and saving no violations for a known rule it will forget the rule. Its entry will be removed and its file as well. Unless another entry is sharing that file. In which case only the entry will be removed. Even if it points outside the folder. If using `repair` and saving no violations for an unknown rule nothing will be saved.

If it cannot delete the file of a rule it is forgetting it will fail to save and leave the entry.
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
index 00000000..af8eb4f9
--- /dev/null
+++ b/archunit/src/test/java/com/tngtech/archunit/library/freeze/FreezeStoreMaintenance_e448f3_Test.java
@@ -0,0 +1,985 @@
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
+import java.nio.file.attribute.PosixFilePermissions;
+import java.util.ArrayList;
+import java.util.Arrays;
+import java.util.Collections;
+import java.util.LinkedHashMap;
+import java.util.LinkedHashSet;
+import java.util.List;
+import java.util.Map;
+import java.util.Properties;
+import java.util.Set;
+
+import com.google.common.base.Splitter;
+import com.google.common.base.Strings;
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
+import static org.junit.jupiter.api.Assumptions.assumeTrue;
+
+class FreezeStoreMaintenance_e448f3_Test {
+
+    private static final String INDEX = "stored.rules";
+
+    @TempDir
+    Path tempDir;
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
+        String kept = file(store, "kept", "a remaining violation\n");
+        index(store, "broken rule", "gone", "resolved rule", resolved,
+                "shared entry one", sharedFile, "shared entry two", sharedFile, "kept rule", kept);
+        write(new File(store, "unowned-file"), "hand written");
+
+        Map<String, byte[]> before = new LinkedHashMap<>();
+        for (String fileName : fileNames(store)) {
+            before.put(fileName, bytesOf(new File(store, fileName)));
+        }
+
+        initialize(integrity(store, "ignore"));
+
+        assertThat(fileNames(store)).as("ignore neither deletes nor writes anything")
+                .isEqualTo(new ArrayList<>(before.keySet()));
+        for (Map.Entry<String, byte[]> entry : before.entrySet()) {
+            assertThat(bytesOf(new File(store, entry.getKey())))
+                    .as("bytes of %s unchanged by ignore", entry.getKey()).isEqualTo(entry.getValue());
+        }
+
+        initialize(integrity(store, "repair"));
+
+        Properties afterRepair = entries(store);
+        assertThat(afterRepair).as("ignore had examined nothing, so repair still finds every condition")
+                .doesNotContainKey("broken rule")
+                .doesNotContainKey("resolved rule")
+                .containsEntry("shared entry one", sharedFile)
+                .containsEntry("shared entry two", sharedFile)
+                .containsEntry("kept rule", kept);
+        assertThat(fileNames(store)).containsOnly(INDEX, sharedFile, kept, "unowned-file");
+        assertThat(contentOf(new File(store, "unowned-file"))).isEqualTo("hand written");
+        assertThat(contentOf(new File(store, kept))).isEqualTo("a remaining violation\n");
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
+        String longerThanAnyFileName = Strings.repeat("name-", 60);
+        index(store, "alpha rule", "bad\u0000name", "gamma rule", "bad\uD800name", "delta rule", longerThanAnyFileName,
+                "beta rule", healthy);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("entries recording a null character, an unpaired surrogate or a name too long for any file")
+                .containsOnlyKeys("beta rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, healthy);
+        assertThat(contentOf(new File(store, healthy))).isEqualTo("a remaining violation\n");
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
+    }
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
+    void anEntryNamingADanglingLinkToAnotherEntrysAbsentNameIsBrokenLikeThatEntry() {
+        File store = folder("store");
+        link(new File(store, "alias"), new File(store, "missing"));
+        index(store, "alpha rule", "missing", "beta rule", "alias");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("the two names differ and neither reaches a regular file").isEmpty();
+        assertThat(Files.isSymbolicLink(new File(store, "alias").toPath())).as("the dangling link itself stays").isTrue();
+    }
+
+    @Test
+    void entriesRecordingTwoSpellingsOfAnAbsentNameAreBothBroken() {
+        File store = folder("store");
+        index(store, "first rule", "gone", "second rule", "./gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("different names that reach no file are broken rather than shared").isEmpty();
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
+        String first = file(store, "first-name", "");
+        hardLink(new File(store, "second-name"), new File(store, first));
+        index(store, "alpha rule", first, "beta rule", "second-name", "broken rule", "gone");
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
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).containsOnlyKeys("first shared", "second shared");
+        assertThat(fileNames(store)).containsOnly(INDEX, shared);
+    }
+
+    @Test
+    void anEntryBothSharedAndBrokenStaysSharedAndSurvivesRepair() {
+        File store = folder("store");
+        index(store, "first shared", "vanished", "second shared", "vanished", "lone broken", "also-gone");
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store))
+                .as("entries sharing a name nothing exists under stay shared, so repair discards only the lone broken one")
+                .containsOnlyKeys("first shared", "second shared");
+        assertThat(fileNames(store)).containsOnly(INDEX);
+    }
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
+    void aFileInsideADirectoryInTheStoreFolderIsNeverACondition() {
+        File store = folder("store");
+        String kept = file(store, "kept", "some violation");
+        index(store, "a rule", kept, "a broken rule", "gone");
+        File subfolder = new File(store, "subfolder");
+        assertThat(subfolder.mkdir()).isTrue();
+        write(new File(subfolder, "buried"), "some violation");
+
+        initialize(integrity(store, "repair"));
+        assertThat(entries(store)).containsOnlyKeys("a rule");
+        assertThat(fileNames(store)).containsOnly(INDEX, kept);
+        assertThat(contentOf(new File(subfolder, "buried"))).isEqualTo("some violation");
+    }
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
+        link(new File(store, "alias"), new File(store, legacy));
+        index(store, "a rule", "alias", "another rule", legacy, "broken rule", "gone");
+
+        initialize(integrity(store, "repair"));
+        Properties afterFirstRepair = entries(store);
+        List<String> filesAfterFirstRepair = fileNames(store);
+
+        initialize(integrity(store, "repair"));
+
+        assertThat(entries(store)).as("a second repair discards nothing").isEqualTo(afterFirstRepair);
+        assertThat(entries(store)).containsOnlyKeys("a rule", "another rule");
+        assertThat(fileNames(store)).isEqualTo(filesAfterFirstRepair);
+        assertThat(contentOf(new File(store, legacy))).isEqualTo("a remaining violation\n");
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
+    void forgettingARuleWhoseEntryNamesALinkToAFileNoOtherEntryRecordsDiscardsLinkAndFile() {
+        File store = folder("store");
+        String target = file(store, "target", "a remaining violation\n");
+        link(new File(store, "link-to-target"), new File(store, target));
+        String kept = file(store, "kept", "another remaining violation\n");
+        index(store, "forgotten rule", "link-to-target", "keeping rule", kept);
+
+        ViolationStore writer = new TextFileBasedViolationStore();
+        writer.initialize(integrity(store, "repair"));
+        writer.save(rule("forgotten rule"), Collections.emptyList());
+
+        assertThat(entries(store)).containsOnlyKeys("keeping rule");
+        assertThat(fileNames(store)).as("the file the link pointed at is gone with the entry").containsOnly(INDEX, kept);
+        assertThat(Files.isSymbolicLink(new File(store, "link-to-target").toPath()))
+                .as("the link is gone as well, not left behind dangling").isFalse();
+        assertThat(writer.contains(rule("forgotten rule"))).isFalse();
+        assertThat(writer.getViolations(rule("keeping rule"))).containsExactly("another remaining violation");
+    }
+
+    @Test
+    void forgettingARuleWhoseFileCannotBeDeletedKeepsItsEntry() {
+        File store = folder("store");
+        ArchRule resolvedRule = rule("a fully resolved rule");
+        String violations = file(store, "violations", "one violation\n");
+        index(store, resolvedRule.getDescription(), violations);
+        File indexFile = new File(store, INDEX);
+
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
+        assertThat(outcome).as("forgetting the rule while its file cannot be deleted, as the same store sees it afterwards")
+                .isEqualTo(ForgettingProbe.REJECTED_AND_STILL_STORED);
+        assertThat(entries(store)).as("the index still records the rule")
+                .containsOnlyKeys(resolvedRule.getDescription())
+                .containsEntry(resolvedRule.getDescription(), violations);
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
+     * Folder permissions do not stop a privileged user, so the store runs in a JVM of an unprivileged one.
+     */
+    private String forgetAsAnotherUser(File store, String ruleDescription) {
+        assumeTrue(isOnPath("setpriv"), "running the store as an unprivileged user needs setpriv");
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
+    private boolean isOnPath(String program) {
+        String path = System.getenv("PATH");
+        return path != null && Arrays.stream(path.split(File.pathSeparator))
+                .anyMatch(directory -> new File(directory, program).canExecute());
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
+    public static class ForgettingProbe {
+        static final String REJECTED_AND_STILL_STORED = "rejected, still stored";
+
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
+            ArchRule rule = classes().should().bePublic().as(ruleDescription);
+            try {
+                violationStore.save(rule, Collections.emptyList());
+                return "forgotten";
+            } catch (RuntimeException e) {
+                return violationStore.contains(rule) ? REJECTED_AND_STILL_STORED : "rejected, but no longer stored";
+            }
+        }
+    }
+
+}
diff --git a/test.sh b/test.sh
new file mode 100755
index 00000000..a702759c
--- /dev/null
+++ b/test.sh
@@ -0,0 +1,173 @@
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
+# the jdk9main compilation shares this output directory and can prune classes of an incremental
+# build, so every run compiles it from scratch
+rm -rf archunit/build/classes/java/main
+
+set +e
+./gradlew --offline --no-daemon -Dscan=false ":archunit:${GRADLE_TARGET}" 2>&1 | tee "$SCRATCH/gradle.log"
+STATUS="${PIPESTATUS[0]}"
+set -e
+
+cat > "$SCRATCH/MalformedXml.java" <<'EOF'
+import java.io.File;
+import javax.xml.XMLConstants;
+import javax.xml.parsers.DocumentBuilder;
+import javax.xml.parsers.DocumentBuilderFactory;
+import org.xml.sax.helpers.DefaultHandler;
+
+public class MalformedXml {
+    public static void main(String[] args) throws Exception {
+        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
+        factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
+        factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
+        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
+        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
+        factory.setXIncludeAware(false);
+        factory.setExpandEntityReferences(false);
+        DocumentBuilder builder = factory.newDocumentBuilder();
+        builder.setErrorHandler(new DefaultHandler());
+        for (String path : args) {
+            try {
+                builder.parse(new File(path));
+            } catch (Exception e) {
+                System.out.println(path);
+            }
+        }
+    }
+}
+EOF
+
+# prints every given file that is not well-formed XML, or all of them if they cannot be checked
+malformed_among() {
+  local checked
+  if checked="$(java "$SCRATCH/MalformedXml.java" "$@")"; then
+    [[ -z "$checked" ]] || printf '%s\n' "$checked"
+  else
+    printf '%s\n' "$@"
+  fi
+}
+
+error_suite() {
+  local name="$1" message="$2" details="$3"
+  echo "<testsuite name=\"${name}\" tests=\"1\" skipped=\"0\" failures=\"0\" errors=\"1\">"
+  echo "<testcase classname=\"${GRADLE_TARGET}\" name=\"${name}\">"
+  echo "<error message=\"${message}\"><![CDATA["
+  tail -n 200 "$details" | tr -d '\000-\010\013\014\016-\037' | sed 's/]]>/]]]]><![CDATA[>/g'
+  echo ']]></error>'
+  echo '</testcase>'
+  echo '</testsuite>'
+}
+
+REPORT="$SCRATCH/report.xml"
+shopt -s nullglob
+RESULT_FILES=("$RESULT_DIR"/*.xml)
+shopt -u nullglob
+
+MALFORMED=()
+if [[ ${#RESULT_FILES[@]} -gt 0 ]]; then
+  mapfile -t MALFORMED < <(malformed_among "${RESULT_FILES[@]}")
+fi
+
+{
+  echo '<?xml version="1.0" encoding="UTF-8"?>'
+  echo '<testsuites>'
+  for result_file in "${RESULT_FILES[@]}"; do
+    if [[ " ${MALFORMED[*]} " == *" ${result_file} "* ]]; then
+      echo "Malformed JUnit XML: $result_file" >&2
+      error_suite "$(basename "$result_file" .xml)" "Malformed JUnit XML produced by ${GRADLE_TARGET}" "$result_file"
+    else
+      sed '1{/^<?xml/d;}' "$result_file"
+    fi
+  done
+  if [[ ${#RESULT_FILES[@]} -eq 0 ]]; then
+    echo "No JUnit XML was produced by $GRADLE_TARGET" >&2
+    error_suite "build" "Gradle produced no JUnit XML for ${GRADLE_TARGET}" "$SCRATCH/gradle.log"
+  fi
+  echo '</testsuites>'
+} > "$REPORT"
+
+if [[ ${#RESULT_FILES[@]} -eq 0 || ${#MALFORMED[@]} -gt 0 ]] && [[ "$STATUS" -eq 0 ]]; then
+  STATUS=1
+fi
+
+if [[ -n "$(malformed_among "$REPORT")" ]]; then
+  echo "The merged JUnit XML is malformed" >&2
+  printf '%s\n' '<?xml version="1.0" encoding="UTF-8"?>' '<testsuites>' \
+    "<testsuite name=\"report\" tests=\"1\" skipped=\"0\" failures=\"0\" errors=\"1\">" \
+    "<testcase classname=\"${GRADLE_TARGET}\" name=\"report\"><error message=\"Malformed JUnit XML\"/></testcase>" \
+    '</testsuite>' '</testsuites>' > "$REPORT"
+  STATUS=1
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

# The wrapper pins Gradle 9.7.1 by distributionUrl and distributionSha256Sum; gradle/libs.versions.toml fixes library versions.
RUN grep -Fqx 'distributionSha256Sum=acd53f1edaf02f1a8ff99879f8a34b302661a057d9b063ae9e35b552f804d20a' \
      gradle/wrapper/gradle-wrapper.properties && \
    ./gradlew --no-daemon --version | grep -Fx 'Gradle 9.7.1'

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
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java
new file mode 100644
index 00000000..d7a89544
--- /dev/null
+++ b/archunit/src/main/java/com/tngtech/archunit/library/freeze/StoreIntegrity.java
@@ -0,0 +1,305 @@
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
+import java.util.HashSet;
+import java.util.LinkedHashMap;
+import java.util.LinkedHashSet;
+import java.util.List;
+import java.util.Map;
+import java.util.Set;
+import java.util.SortedMap;
+
+import static java.util.stream.Collectors.toList;
+
+/**
+ * Reconciles the index of a {@link TextFileBasedViolationStore} with the contents of its store folder.
+ * The store changes only entries it owns alone: shared entries and unowned files are always left untouched.
+ */
+class StoreIntegrity {
+    private static final String IGNORE = "ignore";
+    private static final String REPAIR = "repair";
+
+    private final File storeFolder;
+    private final ViolationsReader violationsReader;
+
+    StoreIntegrity(File storeFolder, ViolationsReader violationsReader) {
+        this.storeFolder = storeFolder;
+        this.violationsReader = violationsReader;
+    }
+
+    static Mode parseMode(String configuredValue) {
+        switch (configuredValue) {
+            case IGNORE:
+                return Mode.IGNORE;
+            case REPAIR:
+                return Mode.REPAIR;
+            default:
+                throw new StoreInitializationFailedException(String.format(
+                        "Configuration %s.%s only accepts the values %s and %s, but was '%s'",
+                        ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, TextFileBasedViolationStore.INTEGRITY_PROPERTY_NAME,
+                        IGNORE, REPAIR, configuredValue));
+        }
+    }
+
+    void rejectBeforeCreating(Mode mode, boolean storeUpdateAllowed) {
+        if (mode == Mode.REPAIR && !storeUpdateAllowed) {
+            throw new StoreInitializationFailedException(String.format(
+                    "Repairing the violation store requires configuration %s.%s=true",
+                    ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME,
+                    TextFileBasedViolationStore.ALLOW_STORE_UPDATE_PROPERTY_NAME));
+        }
+    }
+
+    void examine(Mode mode, TextFileBasedViolationStore.FileSyncedProperties index) {
+        if (mode == Mode.IGNORE) {
+            return;
+        }
+        synchronized (index) {
+            // the index is cached per path for the lifetime of the JVM, so the file may have changed since
+            index.reloadFromFileSystem();
+            repair(classify(index.entriesByRuleDescription()), index);
+        }
+    }
+
+    private List<Finding> classify(SortedMap<String, String> entries) {
+        Set<String> sharedNames = sharedNames(entries.values());
+        List<Finding> findings = new ArrayList<>();
+        for (Map.Entry<String, String> entry : entries.entrySet()) {
+            Finding finding = findingFor(entry.getKey(), entry.getValue(), sharedNames);
+            if (finding != null) {
+                findings.add(finding);
+            }
+        }
+        return findings;
+    }
+
+    private Finding findingFor(String ruleDescription, String recordedName, Set<String> sharedNames) {
+        if (sharedNames.contains(recordedName)) {
+            return new Finding(Condition.SHARED, ruleDescription, recordedName);
+        }
+        if (!isOwnedFile(recordedName)) {
+            return new Finding(Condition.BROKEN, ruleDescription, recordedName);
+        }
+        Contents contents = contentsOf(recordedName);
+        if (contents == Contents.GONE) {
+            return new Finding(Condition.BROKEN, ruleDescription, recordedName);
+        }
+        if (contents == Contents.NONE) {
+            return new Finding(Condition.RESOLVED, ruleDescription, recordedName);
+        }
+        return null;
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
+    // two spellings of an absent name reach no file, so only an identical name makes their entries shared
+    private Set<String> sharedNames(Collection<String> recordedNames) {
+        Set<String> recordedOnce = new HashSet<>();
+        Set<String> shared = new LinkedHashSet<>();
+        for (String recordedName : recordedNames) {
+            if (!recordedOnce.add(recordedName)) {
+                shared.add(recordedName);
+            }
+        }
+        shared.addAll(namesDenotingOneFileTwice(recordedNames.stream().filter(this::reachesAFile).collect(toList())));
+        return shared;
+    }
+
+    private boolean reachesAFile(String name) {
+        try {
+            return Files.exists(resolvedIn(storeFolder, name).toPath());
+        } catch (InvalidPathException e) {
+            return false;
+        }
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
+    // canonical paths do not collapse hard links, so file identity has to be asked of the file system
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
+    static boolean nameIsTaken(File file) {
+        try {
+            return Files.exists(file.toPath(), LinkOption.NOFOLLOW_LINKS);
+        } catch (InvalidPathException e) {
+            return false;
+        }
+    }
+
+    // unlike new File(folder, name), an absolute name resolves to itself rather than into the folder
+    static File resolvedIn(File folder, String name) {
+        try {
+            return folder.toPath().resolve(name).toFile();
+        } catch (InvalidPathException e) {
+            return new File(folder, name);
+        }
+    }
+
+    static boolean denotesFileDirectlyIn(File folder, File candidate) {
+        return candidate.isFile() && liesDirectlyIn(folder, candidate);
+    }
+
+    static boolean isDirectRegularFile(File folder, File candidate) {
+        return Files.isRegularFile(candidate.toPath(), LinkOption.NOFOLLOW_LINKS) && liesDirectlyIn(folder, candidate);
+    }
+
+    static boolean denotesSameFile(File one, File other) {
+        File denotedOne = denotedFileOf(one);
+        File denotedOther = denotedFileOf(other);
+        return denotedOne.equals(denotedOther) || isSameExistingFile(denotedOne, denotedOther);
+    }
+
+    // a taken name must resolve fully, since a canonical path stops at a dangling link wherever it points
+    static boolean liesDirectlyIn(File folder, File candidate) {
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
+    private void repair(List<Finding> findings, TextFileBasedViolationStore.FileSyncedProperties index) {
+        List<String> discarded = new ArrayList<>();
+        try {
+            for (Finding finding : findings) {
+                repair(finding, discarded);
+            }
+        } catch (StoreInitializationFailedException e) {
+            index.apply(discarded);
+            throw e;
+        }
+        index.apply(discarded);
+    }
+
+    private void repair(Finding finding, List<String> discarded) {
+        if (finding.condition == Condition.BROKEN) {
+            discarded.add(finding.ruleDescription);
+        } else if (finding.condition == Condition.RESOLVED) {
+            File recorded = resolvedIn(storeFolder, finding.fileName);
+            if (!deleteDenotedFile(recorded)) {
+                throw new StoreInitializationFailedException(String.format(
+                        "Cannot discard resolved rule '%s', because %s could not be deleted",
+                        finding.ruleDescription, recorded.getAbsolutePath()));
+            }
+            discarded.add(finding.ruleDescription);
+        }
+    }
+
+    enum Mode {
+        IGNORE,
+        REPAIR
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
+        BROKEN,
+        RESOLVED,
+        SHARED
+    }
+
+    interface ViolationsReader {
+        List<String> readViolations(String recordedName);
+    }
+
+    private static class Finding {
+        private final Condition condition;
+        private final String ruleDescription;
+        private final String fileName;
+
+        Finding(Condition condition, String ruleDescription, String fileName) {
+            this.condition = condition;
+            this.ruleDescription = ruleDescription;
+            this.fileName = fileName;
+        }
+    }
+}
diff --git a/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java b/archunit/src/main/java/com/tngtech/archunit/library/freeze/TextFileBasedViolationStore.java
index fd2bcc56..b25b74fd 100644
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
@@ -38,6 +43,8 @@ import static com.tngtech.archunit.PublicAPI.Usage.ACCESS;
 import static com.tngtech.archunit.PublicAPI.Usage.INHERITANCE;
 import static com.tngtech.archunit.library.freeze.FreezingArchRule.ensureUnixLineBreaks;
 import static java.nio.charset.StandardCharsets.UTF_8;
+import static java.util.Collections.emptyList;
+import static java.util.Collections.singletonList;
 import static java.util.stream.Collectors.toList;
 
 /**
@@ -59,6 +66,7 @@ import static java.util.stream.Collectors.toList;
  * default.path=...               # string: the path of the folder where violation files will be stored
  * default.allowStoreCreation=... # boolean: whether to allow creating a new index file
  * default.allowStoreUpdate=...   # boolean: whether to allow updating any store file
+ * default.integrity=...          # string: "ignore" to examine nothing, "repair" to reconcile the index with the folder
  * </code></pre>
  */
 @PublicAPI(usage = ACCESS)
@@ -66,18 +74,22 @@ public final class TextFileBasedViolationStore implements ViolationStore {
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
 
     private static final ConcurrentHashMap<String, FileSyncedProperties> STORED_RULES_BY_PATH = new ConcurrentHashMap<>();
 
     private final RuleViolationFileNameStrategy ruleViolationFileNameStrategy;
 
+    private StoreIntegrity.Mode integrityMode;
     private boolean storeCreationAllowed;
     private boolean storeUpdateAllowed;
     private File storeFolder;
@@ -105,15 +117,21 @@ public final class TextFileBasedViolationStore implements ViolationStore {
     public void initialize(Properties properties) {
         storeCreationAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_CREATION_PROPERTY_NAME, ALLOW_STORE_CREATION_DEFAULT));
         storeUpdateAllowed = Boolean.parseBoolean(properties.getProperty(ALLOW_STORE_UPDATE_PROPERTY_NAME, ALLOW_STORE_UPDATE_DEFAULT));
+        integrityMode = StoreIntegrity.parseMode(properties.getProperty(INTEGRITY_PROPERTY_NAME, INTEGRITY_DEFAULT));
         String path = properties.getProperty(STORE_PATH_PROPERTY_NAME, STORE_PATH_DEFAULT);
         storeFolder = new File(path);
         File storedRulesFile = getStoredRulesFile();
         log.trace("Initializing {} at {}", TextFileBasedViolationStore.class.getSimpleName(), storedRulesFile.getAbsolutePath());
-        storedRules = getOrCreateStoredRules(storedRulesFile);
-        checkInitialization(storedRules.initializationSuccessful(), "Cannot create rule store at %s", storedRulesFile.getAbsolutePath());
+        StoreIntegrity integrity = new StoreIntegrity(storeFolder, this::readRecordedViolations);
+        storedRules = getStoredRules(storedRulesFile);
+        storedRules.runExclusively(() -> {
+            integrity.rejectBeforeCreating(integrityMode, storeUpdateAllowed);
+            checkInitialization(storedRules.open(), "Cannot create rule store at %s", storedRulesFile.getAbsolutePath());
+            integrity.examine(integrityMode, storedRules);
+        });
     }
 
-    private FileSyncedProperties getOrCreateStoredRules(File storedRulesFile) {
+    private FileSyncedProperties getStoredRules(File storedRulesFile) {
         try {
             return STORED_RULES_BY_PATH.computeIfAbsent(storedRulesFile.getCanonicalPath(), path -> new FileSyncedProperties(storedRulesFile));
         } catch (IOException e) {
@@ -123,10 +141,16 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
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
@@ -150,8 +174,78 @@ public final class TextFileBasedViolationStore implements ViolationStore {
                     "Updating frozen violations is disabled (enable by configuration %s.%s=true)",
                     ViolationStoreFactory.FREEZE_STORE_PROPERTY_NAME, ALLOW_STORE_UPDATE_PROPERTY_NAME));
         }
-        String ruleFileName = ensureRuleFileName(rule);
-        write(violations, new File(storeFolder, ruleFileName));
+        // stores of one folder share storedRules, so initializing waits until a save has written both entry and file
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
+        storedRules.apply(singletonList(ensureUnixLineBreaks(rule.getDescription())));
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
@@ -176,14 +270,19 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
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
@@ -196,7 +295,16 @@ public final class TextFileBasedViolationStore implements ViolationStore {
     }
 
     private List<String> readLines(String ruleDetailsFileName) {
+        return linesOf(readStoreFile(ruleDetailsFileName));
+    }
+
+    private List<String> readRecordedViolations(String ruleDetailsFileName) {
         String violationsText = readStoreFile(ruleDetailsFileName);
+        // only line feeds split violations, so a file of lone carriage returns must be recognized as empty here
+        return LINE_BREAKS_ONLY_PATTERN.matcher(violationsText).matches() ? emptyList() : linesOf(violationsText);
+    }
+
+    private List<String> linesOf(String violationsText) {
         return Splitter.on(UNESCAPED_LINE_BREAK_PATTERN).omitEmptyStrings().splitToStream(violationsText)
                 .map(this::unescape)
                 .collect(toList());
@@ -204,47 +312,47 @@ public final class TextFileBasedViolationStore implements ViolationStore {
 
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
-        private final Properties loadedProperties;
+        private final Properties loadedProperties = new Properties();
+        private boolean opened;
 
         FileSyncedProperties(File file) {
-            propertiesFile = initializePropertiesFile(file);
-            loadedProperties = initializationSuccessful() ? loadRulesFrom(propertiesFile) : null;
+            propertiesFile = file;
         }
 
-        boolean initializationSuccessful() {
-            return propertiesFile != null;
+        synchronized boolean open() {
+            if (!opened && initializePropertiesFile(propertiesFile)) {
+                loadedProperties.putAll(loadRulesFrom(propertiesFile));
+                opened = true;
+            }
+            return opened;
         }
 
-        private File initializePropertiesFile(File file) {
+        private static boolean initializePropertiesFile(File file) {
             try {
                 File directory = file.getParentFile();
 
                 // mkdirs() returns false both on failure and if another process concurrently
                 // created the directory, so isDirectory() distinguishes the two
                 if (!directory.mkdirs() && !directory.isDirectory()) {
-                    return null;
-                }
-
-                if (!file.exists() && !file.createNewFile()) {
-                    return null;
+                    return false;
                 }
 
-                return file;
+                return file.exists() || file.createNewFile();
             } catch (IOException e) {
-                return null;
+                return false;
             }
         }
 
-        private Properties loadRulesFrom(File file) {
+        private static Properties loadRulesFrom(File file) {
             Properties result = new Properties();
             try (FileInputStream inputStream = new FileInputStream(file)) {
                 result.load(inputStream);
@@ -254,14 +362,49 @@ public final class TextFileBasedViolationStore implements ViolationStore {
             return result;
         }
 
-        boolean containsKey(String propertyName) {
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
+        synchronized boolean containsKey(String propertyName) {
             return loadedProperties.containsKey(ensureUnixLineBreaks(propertyName));
         }
 
-        String getProperty(String propertyName) {
+        synchronized String getProperty(String propertyName) {
             return loadedProperties.getProperty(ensureUnixLineBreaks(propertyName));
         }
 
+        synchronized SortedMap<String, String> entriesByRuleDescription() {
+            return entriesOf(loadedProperties);
+        }
+
+        // keys are taken exactly as the index holds them, since it can hold keys that differ only in their line breaks
+        synchronized void apply(Collection<String> discardedKeys) {
+            if (discardedKeys.isEmpty()) {
+                return;
+            }
+            discardedKeys.forEach(loadedProperties::remove);
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
index 10ed830c..fa04580b 100644
--- a/docs/userguide/008_The_Library_API.adoc
+++ b/docs/userguide/008_The_Library_API.adoc
@@ -495,6 +495,20 @@ For example to allow the creation of the violation store in a specific environme
 -Darchunit.freeze.store.default.allowStoreCreation=true
 ----
 
+The text based store can also check its own consistency while initializing
+
+[source,options="nowrap"]
+.archunit.properties
+----
+# controls whether the store checks its index and its files against each other while initializing
+# "ignore" (the default) checks nothing
+# "repair" discards entries whose file is missing or no longer holds a violation
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
index 9a207a63..8d188fa1 100644
--- a/docs/userguide/html/000_Index.html
+++ b/docs/userguide/html/000_Index.html
@@ -2487,6 +2487,22 @@ For example to allow the creation of the violation store in a specific environme
 </div>
 </div>
 <div class="paragraph">
+<p>The text based store can also check its own consistency while initializing</p>
+</div>
+<div class="listingblock">
+<div class="title">archunit.properties</div>
+<div class="content">
+<pre class="highlightjs highlight nowrap"><code class="language-none hljs"># controls whether the store checks its index and its files against each other while initializing
+# "ignore" (the default) checks nothing
+# "repair" discards entries whose file is missing or no longer holds a violation
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
