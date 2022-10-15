module debugging;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/* all debugging functions end with '!' */

import sal_auxlib;
import sal_shared_api;
import salinterp;

import std.stdio :
    stderr,
    writefln;

import core.stdc.stdlib :
    exit;

int panic(SalmonSub sn) {
    stderr.writefln("\033[1;38:5:215mProgram Panic!\033[0m\n\t\033[1m%s\033[0m", sn.value_at(0).getValue());
    if (_FILEN != "repl") exit(-24);
    return 0;
}

int loadDebugTools(SalmonEnvironment env) {
    saL_register(env, "panic!", &panic);
    return 0;
}
