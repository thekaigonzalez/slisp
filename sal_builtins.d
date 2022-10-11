// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import sal_shared_api;
import std.stdio;
import std.conv;
import std.base64;
import std.string;
import sal_auxlib;

int builtin_print(SalmonSub info) {
    string n;

    foreach (string s; valArrayToString(info.rest())) {
        n ~= s;
    }

    writeln(n);

    return (0);
}

int istrcat(SalmonSub i) {
    i.returnValue(join(i.aA, ""), SalType.any);

    return (0);
}

int builtin_trim(SalmonSub s) {
    s.returnValue(s.aA[0].strip, SalType.str);
    return 0;
}

int builtin_println(SalmonSub s) {
    string n;

    foreach (string sg; valArrayToString(s.rest())) {
        n ~= sg;
    }

    writeln(n);

    return (0);
}

int builtin_strcat(SalmonSub info) {
    info.returnValue(info.aA[0] ~ info.aA[1], SalType.str);

    return (0);
}

int builtin_add(SalmonSub info) {
    int i = 0;

    foreach (string n; info.aA) {
        i += to!int(n);
    }
    info.returnValue(to!string(i), SalType.number);
    return (0);
}

int builtin_min(SalmonSub info) {
    int i = info.value_at(0).getValue().to!int;

    int i1 = info.value_at(1).getValue().to!int;

    info.returnValue(to!string(i - i1), SalType.number);
    return (0);
}

int builtin_div(SalmonSub info) {
    int i = info.value_at(0).getValue().to!int;

    int i1 = info.value_at(1).getValue().to!int;

    info.returnValue(to!string(i / i1), SalType.number);
    return (0);
}

int builtin_mul(SalmonSub info) {
    int i = 1;

    foreach (string n; info.aA) {
        i *= to!int(n);
    }
    info.returnValue(to!string(i), SalType.number);
    return (0);
}
