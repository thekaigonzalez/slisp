// Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module sal_std;

import std.stdio;
import sal_shared_api;
import salinterp;
import sal_auxlib;

int printf(SalmonSub s) {
  // string ns;
  string fs = "";

  string str = s.value_at(0).getValue();

  SalmonValue[] fmts = s.rest(1);

  int st = 0;
  int n = 0;

  for (int i = 0; i < str.length; ++i) {
    if (str[i] == '{' && st == 0) {
      st = 1;
    }
    else if (str[i] == '}' && st == 1) {
      st = 0;
      fs ~= fmts[n].getValue();
      n += 1;
    }
    else {
      fs ~= str[i];
    }
  }

  SalmonValue fina = new SalmonValue();

  fina.setType(SalType.str);
  fina.setValue(fs);

  writeln(fina.getValue());

  return 0;
}

int cdr(SalmonSub sub) {
  SalmonValue pair = sub.value_at(0);

  if (pair.getType() == SalType.list) {
    sub.returnValue(pair.list_members()[1]);
    return 0;
  }
  return 0;
}

int car(SalmonSub sub) {
  SalmonValue pair = sub.value_at(0);

  if (pair.getType() == SalType.list) {
    sub.returnValue(pair.list_members()[0]);
    return 0;
  }
  return 0;
}

int hasLisp(SalmonSub sub) {
  SalmonValue nf = sub.value_at(0);

  foreach (SalmonValue s; sub.value_at(1).list_members) {
    if (nf.equals(s)) {
      sub.returnValue(asSBool(true));
      return 0;
    }
  }

  sub.returnValue(asSBool(false));
  return (0);
}

int isNil(SalmonSub s) {
  s.returnValue(asSBool(s.value_at(0).equals(new SalmonValue()))); /* by default svalue returns nil */
  return 0;
}

int loadlib_std(SalmonEnvironment env) {
    saL_register(env, "printf", &printf);
    saL_register(env, "cdr", &cdr);
    saL_register(env, "car", &car);
    saL_register(env, "has", &hasLisp);
    saL_register(env, "null", &isNil);
    saL_register(env, "nil?", &isNil);
    return 0;
}
