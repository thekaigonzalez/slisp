import std.stdio;
import std.math;
import std.array;
import std.conv;
import std.algorithm;
import sal_shared_api;

int lsin(SalmonInfo i)
{
  i.returnValue(to!string((sin(to!float(i.aA[0])))), SalType.number);

  return 0;
}

int lintersection(SalmonInfo i)
{
  string[] list1 = i.environ.env_lists[i.aA[0]];
  string[] list2 = i.environ.env_lists[i.aA[1]];
  string[] l;
  string list3 = "";
  foreach (string n; list1)
  {
    if (canFind(list2, n))
      l ~= n;
  }

  list3 ~= join(l, " ") ~ "";
  writeln(list3);
  i.returnValue(list3, SalType.str);
  return 0;
}

extern (C) int sal_lib_init(SalmonEnvironment env)
{
  env.env_funcs["sin"] = &lsin;
  env.env_funcs["intersection"] = &lintersection;
  return 0;
}
