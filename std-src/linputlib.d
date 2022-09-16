import std.stdio;
import sal_shared_api;

int getline(SalmonInfo p)
{
  p.returnValue(readln(), SalType.any);
  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment env)
{
  env.env_funcs["getline"] = &getline;
  return 0;
}
