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

int loadlib_std(SalmonEnvironment env) {
    saL_register(env, "printf", &printf);
    return 0;
}
