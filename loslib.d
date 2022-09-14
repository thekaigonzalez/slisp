import std.stdio;
import sal_shared_api;
import std.process;
import std.conv;

int sys(SalmonInfo i)
{
  i.returnValue(to!string(executeShell(i.aA[0]).status), SalType.number);
  return 0;
}

int osys(SalmonInfo i)
{
  i.returnValue(to!string(executeShell(i.aA[0]).output), SalType.number);
  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment e)
{
  e.env_funcs["sys"] = &sys;
  e.env_funcs["osys"] = &osys;
  return 0;
}
