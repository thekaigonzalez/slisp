import std.stdio;
import std.math;
import std.conv;
import sal_shared_api;

int lsin(SalmonInfo i)
{
  i.returnValue(to!string((sin(to!float(i.aA[0])))), SalType.number);

  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment env)
{
  env.env_funcs["sin"] = &lsin;
  return 0;
}
