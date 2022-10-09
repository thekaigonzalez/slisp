// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import std.stdio;
import std.conv;
import std.string;
import std.path;
import std.getopt;
import std.file;

static import core.exception;
import salinterp;

import sal_shared_api;
import sal_auxlib;

extern (C) char* readline(const char*);

int main(string[] args) {
    SalmonEnvironment env = new SalmonEnvironment();
    env.settings.handlePath = false;
    SalmonValue version_string = new SalmonValue();

    auto version_major = quickRun("3", env);
    auto version_minor = quickRun("0", env);

    version_string.flagAsList();

    version_string.setValue([version_major, version_minor]);

    env.env_vars["salmon_version"] = version_string;
    env.env_vars["compiler_system"] = quickRun(getTargetSystem(), env);
    auto argValue = new SalmonValue();

    argValue.flagAsList();
    argValue.setValue(listToValues(args[1 .. $], env));

    env.env_vars["arg"] = argValue;

    GetoptResult optional_arg;

    string mode = "normal";

    bool one = false;

    string[] optional_paths;

    bool ver = false;

    try {
        optional_arg = getopt(args, std.getopt.config.bundling, "version|v",
            "Print version and exit", &ver, "I", "directories to add to PATH.",
            &optional_paths, "m|mode",
            "The compiler mode. Please see: \033[;1mhttps://thekaigonzalez.github.io/slisp\033[0m",
            &mode,
            "o|one", "Specify one file, allowing arguments",
            &one);
    }
    catch (GetOptException e) {
        err(e.msg, 0, "cli");
        return 91;
    }

    if (ver) {
        writefln("Salmon Version: %s", env.env_vars["salmon_version"].getValue());
        return 0;
    }
    if (mode == "normal")
        populateEnvironment(env);
    else {
        if (mode.strip == "bare") {
            env.settings.setBuiltins = false;
        }
    }

    foreach (string s; optional_paths) {
        SalmonValue pathVariable = getEnvironmentVariable(env, "path");

        pathVariable.append(convertStringToValue(s));
    }

    if (optional_arg.helpWanted) {
        writeln("Options:");
        foreach (it; optional_arg.options) {
            writefln("\t%s\t%s", it.optShort, it.help);
        }
        writeln(
            "\nPositional (Optional) arguments:\n\tfile(s)\tThe file(s) to run. You may specify more than one.");
        writeln("\nThis is the official Salmon command-line-interface.");
        writeln("Any questions? Email me! <gkai70264@gmail.com>");

        return 0;
    }

    if (args.length == 1) {
        SalmonState input = new SalmonState();
        _FILEN = "repl";
        writeln("\033[;1mWelcome to..\033[0;0m \033[32;1mSalmon\033[0;0m\033[36;1mLisp\033[0;0m!");

        writeln("To learn \033[;1mSLisp\033[0m, please \033[33;1mvisit the\033[0;0m\033[34;1m SLisp "
                ~ "\033[0;0mwebsite:\033[0;0m \033[33;1mhttps://thekaigonzalez.github.io/slisp\033[0;0m");

        while (true) {
            string n = readline(">").to!string;
            salmon_push_code(input, n);
            try {
                auto run = execute_salmon(input, true, env);
                if (run.getType() == SalType.list) {
                    writeln("[" ~ valuesToList(run.g, env)
                            .join(", ") ~ "] (" ~ run.getType.to!string ~ ")");
                }
                else {
                    writeln(run.getValue() ~ " (" ~ run.getType().to!string ~ ")");
                }
            }
            catch (core.exception.ArraySliceError e) {
                err("imbalanced statement (failure to slice)", 0, "repl");
                note("line length: " ~ n.strip.length.to!string, 0, "repl");
            }
            input.CODE = "";
        }
    }

    if (!exists(args[1])) {
        err("file not found.", 0, "commandline");
        return 2;
    }

    if (!one) {
        foreach (string f; args[1 .. $]) {
            _FILEN = f;
            if (!exists(f)) {
                err("file not found.", 0, "commandline");
                return -1;
            }
            quickRun(readText(f), env, false);
        }
    }
    else {
        _FILEN = args[1];
        if (!exists(args[1])) {
            err("file not found.", 0, "commandline");
            return -1;
        }
        quickRun(readText(args[1]), env, false);
    }
    return 0;
}
