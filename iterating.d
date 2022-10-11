module iterating;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import salinterp;
import sal_auxlib;
import sal_shared_api;

import std.string : join;
import std.stdio : writeln;

SalmonValue until(string[] arg, SalmonEnvironment env) {
    SalmonValue condition = quickRun(arg[1], env);
    
    string _body = arg[2];
    while (condition.getValue() != "true") {
        quickRun(_body, env);
        condition = quickRun(arg[1], env);
    }
    return new SalmonValue();
}

SalmonValue _LispWith(string[] arg, SalmonEnvironment env) {
    SalmonValue value = quickRun(arg[1], env);

    string _body = arg[2];

    while (value.getType() != SalType.nil) {
        quickRun(_body, env);
        value = quickRun(arg[1], env);
    }
    return new SalmonValue();
}

int salIteratingTools(SalmonEnvironment env) {
    saL_keyword(env, "until", &until);
    saL_keyword(env, "with", &_LispWith);
    return 0;
}
