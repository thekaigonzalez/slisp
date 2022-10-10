module sarithmetic;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/* fyi: this is not "math" math it's just math. */
/* implements:
    - *
    - /
    - +
    - -
    */

import sal_auxlib;
import sal_shared_api;
import salinterp;

int multiply(SalmonSub s) {
    float result = 1;

    foreach (SalmonValue integer ; s.rest()) {
        result = result * integer.asFloat();
    }

    s.returnValue(floatAsValue(result));

    return 0;
}

int add(SalmonSub s) {
    float result = 0;

    foreach (SalmonValue integer ; s.rest()) {
        result = result + integer.asFloat();
    }

    s.returnValue(floatAsValue(result));

    return 0;
}

int subtract(SalmonSub s) {
    float result = s.value_at(0).asFloat();

    foreach (SalmonValue integer ; s.rest(1)) {
        result = result - integer.asFloat();
    }

    s.returnValue(floatAsValue(result));

    return 0;
}

int divide(SalmonSub s) {
    float result = s.value_at(0).asFloat();

    foreach (SalmonValue integer ; s.rest(1)) {
        result = result / integer.asFloat();
    }

    s.returnValue(floatAsValue(result));

    return 0;
}

int salArithmetic(SalmonEnvironment env) {
    saL_register(env, "*", &multiply);
    saL_register(env, "+", &add);
    saL_register(env, "-", &subtract);
    saL_register(env, "/", &divide);
    return 0;
}
