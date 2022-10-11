module stringutl;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import std.string : replace;

import sal_auxlib;
import salinterp;
import sal_shared_api;

int replaceInString(SalmonSub s) {
    string fin = replace(s.value_at(0).getValue(), s.value_at(1).getValue(), s.value_at(2).getValue());
    SalmonValue final_value = new SalmonValue();

    final_value.setType(SalType.str);
    final_value.setValue(fin);

    s.returnValue(final_value);
    return 0;
}

int stringLibInit(SalmonEnvironment env) {
    saL_register(env, "replace", &replaceInString);
    return 0;
}
