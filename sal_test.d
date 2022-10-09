// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module sal_test;

import std.stdio;
import std.process;
import std.file;
import std.conv;
import std.string;
import std.getopt;
import std.path;

void test_dir(string dname, string compiler, bool save_test_data = false) {
    int testN = 0;
    int passedTests = 0;
    int failed_tests = 0;

    auto strnc = dirEntries(dname, SpanMode.depth);
    if (".testcache".exists == false && save_test_data)
        ".testcache".mkdir;

    foreach (string d; strnc) {
        if (d.isFile() && endsWith(d, ".asd")) {
            testN += 1;

            auto proc = executeShell(compiler ~ " " ~ d);

            if (proc.status == 0) {
                writeln("\033[32;1mTEST " ~ testN.to!string ~ " SUCCESSFUL!\033[0;0m\b");
                passedTests += 1;
                if (save_test_data) {
                    File n = File(".testcache/test-" ~ testN.to!string ~ "-" ~ baseName(d) ~ ".cache",
                            "w");

                    n.write(proc.output);

                    n.close();
                }
            }
            else {
                writeln("\033[33;1mTEST " ~ testN.to!string ~ " FAILED.\033[0;0m\b");
                if (save_test_data) {
                    File n = File(".testcache/test-fail-" ~ testN.to!string ~ "-" ~ baseName(d) ~ ".cache",
                            "w");

                    n.write(proc.output);

                    n.close();
                }
                failed_tests += 1;
            }
        }
    }
    if (failed_tests == 0) {
        writeln("\033[36;1mAll tests passed!\033[0m");
    }
}

void main(string[] args) {
    string compiler = "salmon-linux-x86_64";
    bool only_one_dir = false;
    string startdir = "./unit-tests";
    string[] additional_dirs;
    bool saveData = false;
    GetoptResult optional_args = getopt(args, std.getopt.config.bundling,
            "compiler|c", "change the compiler to use", &compiler, "one|o",
            "run tests on only one directory (starting dir) and skip extras",
            &only_one_dir, "save|s", "save test data to a .testcache directory.",
            &saveData, "dir|a", "add a directory to the test suite.",
            &additional_dirs, "directory|d",
            "The directory to test (default: unit-tests)", &startdir);

    if (optional_args.helpWanted) {
        defaultGetoptPrinter("Salmon testing suite", optional_args.options);
        return;
    }
    writeln("testing packaged tests");
    test_dir(startdir, compiler);

    if (!only_one_dir) {
        writeln("testing ports");
        test_dir("./ports", compiler, saveData);
    }

    foreach (string d; additional_dirs) {
        test_dir(d, compiler, saveData);
    }
    // writeln("testing the standard library");
    // test_dir("./std-src");

}
