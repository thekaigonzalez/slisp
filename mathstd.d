module mathstd;

// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import sal_auxlib;
import sal_shared_api;
import salinterp;

import std.stdio;
import std.algorithm : mean, levenshteinDistance;
import std.math :
    /* supported math functions */
                PI, 
                sqrt, 
                sin, 
                cos, 
                tan, 
                atan, 
                asin, 
                asinh;
import std.conv : to;

int _atan(SalmonSub f) {
    real atan1 = f.value_at(0).getValue().to!real;

    SalmonValue final_value = new SalmonValue();
    final_value.setType(SalType.number);
    final_value.setValue(atan(atan1).to!string);

    f.returnValue(final_value);

    return 0;
}

int _sin(SalmonSub f) {
    real sinOf     =    f.value_at(0).getValue().to!real;
    auto sinResult =    new SalmonValue();

    sinResult.setType(SalType.number);
    sinResult.setValue(sin(sinOf).to!string);

    f.returnValue(sinResult);
    return 0;
}

int _sqrt(SalmonSub f) {
    float sqrtOf     =    f.value_at(0).getValue().to!float;
    auto sqrtResult  =    new SalmonValue();

    sqrtResult.setType(SalType.number);
    sqrtResult.setValue(sqrt(sqrtOf).to!string);

    f.returnValue(sqrtResult);
    return 0;
}

int _cos(SalmonSub f) {
    real Of     =    f.value_at(0).getValue().to!real;
    auto Result  =    new SalmonValue();

    Result.setType(SalType.number);
    Result.setValue(cos(Of).to!string);

    f.returnValue(Result);
    return 0;
}

int _tan(SalmonSub f) {
    real Of     =    f.value_at(0).getValue().to!real;
    auto Result  =    new SalmonValue();

    Result.setType(SalType.number);
    Result.setValue(tan(Of).to!string);

    f.returnValue(Result);
    return 0;
}

int _asin(SalmonSub f) {
    real Of     =    f.value_at(0).getValue().to!real;
    auto Result  =    new SalmonValue();

    Result.setType(SalType.number);
    Result.setValue(asin(Of).to!string);

    f.returnValue(Result);
    return 0;
}

int _asinh(SalmonSub f) {
    real Of     =    f.value_at(0).getValue().to!real;
    auto Result  =    new SalmonValue();

    Result.setType(SalType.number);
    Result.setValue(asinh(Of).to!string);

    f.returnValue(Result);
    return 0;
}

int _distance(SalmonSub f) {
    string str1  =    f.value_at(0).getValue();
    string str2  =    f.value_at(1).getValue();

    auto Result  =    new SalmonValue();

    Result.setType(SalType.number);
    Result.setValue(levenshteinDistance(str1, str2).to!string);

    f.returnValue(Result);
    return 0;
}

int sal_mathstd_init(SalmonEnvironment env) {
    saL_register(env, "atan", &_atan);
    saL_register(env, "sin", &_sin);
    saL_register(env, "sqrt", &_sqrt);
    saL_register(env, "cos", &_cos);
    saL_register(env, "tan", &_tan);
    saL_register(env, "asin", &_asin);
    saL_register(env, "asinh", &_asin);
    saL_register(env, "distance", &_distance);


    return 0;
}
