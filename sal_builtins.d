import sal_shared_api;
import std.stdio;
import std.conv;
import std.base64;
import std.string;

int builtin_print(SalmonInfo info)
{
  writeln(join(info.aA, ""));
  return (0);
}

int istrcat(SalmonInfo i)
{
  i.returnValue(join(i.aA, ""), SalType.any);

  return (0);
}

int builtin_trim(SalmonInfo s)
{
  s.returnValue(s.aA[0].strip, SalType.str);
  return 0;
}

int builtin_dep_println(SalmonInfo s)
{
  writeln(
    "(deprecation) `println` is not a part of the Common Lisp standard. It is only here for reference purposes.\n" ~
      "In future code please use `print`, it does the same as `println` in the CL standard.");
  return (1);
}

int builtin_strcat(SalmonInfo info)
{
  info.returnValue(sal_argument_at(info, 0) ~ sal_argument_at(info, 1), SalType.str);

  return (0);
}

int builtin_add(SalmonInfo info)
{
  int i = 0;

  foreach (string n; info.aA)
  {
    i += to!int(n);
  }
  info.returnValue(to!string(i), SalType.number);
  return (0);
}

int builtin_mul(SalmonInfo info)
{
  int i = 1;

  foreach (string n; info.aA)
  {
    i *= to!int(n);
  }
  info.returnValue(to!string(i), SalType.number);
  return (0);
}
