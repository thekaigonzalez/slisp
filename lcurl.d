module lcurl;

import std.net.curl;
import sal_shared_api;
import std.conv;

int dlweb(SalmonInfo f) {
  f.returnValue(to!string(get(f.aA[0])), SalType.str);
  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment env)
{
  env.env_funcs["download"] = &dlweb;
  return 0;
}
