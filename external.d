module external;

import sal_shared_api;
import std.stdio;
import std.conv;
import std.algorithm;

int in_array(SalmonInfo inf) {
  bool is_in_array = inf.environ.env_lists[inf.aA[0]].canFind(inf.aA[1]);
  inf.returnValue(to!string(is_in_array), SalType.str);
  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment env) {
  env.env_funcs["has"] = &in_array;
  return 0;
}