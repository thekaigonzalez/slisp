module svm.svm;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import std.stdio;
import core.sys.posix.unistd;
import std.getopt;
import std.net.curl : download, CurlException, CurlTimeoutException, get;
import std.process;
import std.string;
import std.file : rmdirRecurse;

void info(string msg) {
    writefln("\033[1;38:5:215mINFO:\033[0m %s", msg);
}

bool prompt(string msg) {
    writefln("\033[1;38:5:215mINFO:\033[0m %s (y/n)", msg);

    return readln() == "y";
}

int error(string msg) {
    writefln("\033[1;31mERROR:\033[0m %s", msg);
    return -1;
}

int unzip_backend(string file) {
    auto command = executeShell("unzip temporary_source.zip");

    if (command.status == 127)
        return error("Can not use UNZIP backend. Requires `unzip' command installed.");

    return 0;
}

int main(string[] args) {
    GetoptResult gargs;

    bool silence = false;
    string backend = "unzip-command";

    try {
        gargs = getopt(args,
            "silent", "Silent downloads (no information)", &silence,
            "zip-backend",
            "Choose a different ZIP decompression backend. Use this if the `unzip-command` backend fails.", &backend);
    } catch (Exception e) {
        writeln("error: " ~ e.msg);
    }
    if (args[1] == "version") {
        /* ver */
    }

    info("Testing connection to github.com...");

    try {
        get("https://github.com");
    } catch (CurlException e) {
        return error("Connectivity test failed! Could not continue.");
        return -1;
    }

    info("Downloading source for version `" ~ args[1] ~ "'...");

    // https://github.com/thekaigonzalez/slisp/archive/refs/tags/28.zip

    try {
        download("https://github.com/thekaigonzalez/slisp/archive/refs/tags/" ~ args[1] ~ ".zip", "temporary_source.zip");
    } catch (CurlException e) {
        int _ = error("Something went wrong trying to download the source code.");
        return error("Message: " ~ e.msg);
        remove("temporary_source.zip");
        return -1;
    }

    info("Extracting source using decompression backend: `" ~ backend ~ "'");

    if (backend == "unzip-command") {
        int stat = unzip_backend("temporary_source.zip");
        if (stat != 0)
            return stat;
    }

    info("Checking for meson...");

    if (executeShell("meson --version").status == 127) {
        bool wLtI = prompt("The 'meson' build tool is not installed. Install it? (y/n)");
        if (wLtI == true) {
            info("Installing `meson` with pip...");
            executeShell("pip install meson");
        }
    }

    info("Building SLisp...");

    chdir(("slisp-" ~ args[1]).toStringz());
    auto buildCmd = executeShell("meson builddir && ninja -C builddir");

    if (buildCmd.status != 0) {
        int _ = error("Could not build Salmon.");
        return error("Output: " ~ buildCmd.output);
    }

    info("Installing SLisp...");

    auto installCmd = executeShell("ninja install -C builddir");

    info("Build completed!");
    info("Removing source code...");
    
    rmdirRecurse("slisp-" ~ args[1]);

    info("Removing archives...");
    remove("temporary_source.zip");
    return (0);
}
