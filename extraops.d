module extraops;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import std.stdio : log = writeln;
import std.conv : to;

import sal_auxlib;
import sal_shared_api;
import salinterp;

int modulo(SalmonSub s) {
    assert(s.value_at(0).numeric());
    assert(s.value_at(1).numeric());
    SalmonValue newValue = new SalmonValue();

    newValue.setType(SalType.number);
    newValue.setValue((s.value_at(0).value!real.convert() % s.value_at(1).value!real.convert()).to!string);

    s.returnValue(newValue);

    return 0;
}

int sal_ops(SalmonEnvironment env) {
    saL_register(env, "mod", &modulo);
    saL_register(env, "%", &modulo);
    return 0;
}
