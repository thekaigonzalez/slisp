module sal_type;

import std.stdio;
import sal_shared_api;
import sal_auxlib;
import salinterp;

SalmonValue sal_construct_value(string n, SalmonEnvironment env) {
  auto s = newState();
  salmon_push_code(s, n);
  SalmonValue na = execute_salmon(s, true, env);

  return na;
}
