module operators;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import sal_auxlib;
import sal_shared_api;
import salinterp;

import std.conv : to;

int equals(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).getValue() == s.value_at(1).getValue())));
    return 0;
}

int not(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).getValue() != s.value_at(1).getValue())));
    return 0;
}

int greaterThan(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).asFloat() > s.value_at(1).asFloat())));
    return 0;
}

int lessThan(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).asFloat() < s.value_at(1).asFloat())));
    return 0;
}

int greaterThanOrEqual(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).asFloat() >= s.value_at(1).asFloat())));
    return 0;
}

int lessThanOrEqual(SalmonSub s) {
    s.returnValue(asSBool((s.value_at(0).asFloat() <= s.value_at(1).asFloat())));
    return 0;
}

int salOperators(SalmonEnvironment env) {
    /* new operator interface */
    saL_register(env, "=", &equals);
    saL_register(env, "<", &lessThan);
    saL_register(env, ">", &greaterThan);
    saL_register(env, ">=", &greaterThanOrEqual);
    saL_register(env, "<=", &lessThanOrEqual);
    saL_register(env, "not", &not);
    return 0;
}
