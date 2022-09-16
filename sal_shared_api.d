// Salmon Implementation

import std.stdio;

enum SalType
{
  nil,
  str,
  number,
  any,
  func
}

/* WWW: throwaway value, use SalmonState */
class SalmonInfo
{
public:
  string[] aA;
  SalType rvaluetype = SalType.nil; /* return value */
  string rvalue = "nil";
  /* + whatever else I need */
  void returnValue(string value, SalType type)
  {
    rvalue = value;
    rvaluetype = type;
  }

  SalmonEnvironment environ = new SalmonEnvironment();
}

class SalmonFunction {
  public:
    string run;
    string returns;
    string[string] parameters;
    string[] template_params;
}

class SalmonEnvironment
{
public:
  int function(SalmonInfo)[string] env_funcs;
  string[string] env_vars;
  string[][string] env_lists;
  string[string] env_definitions;
  SalmonEnvironment copy()
  {
    return new SalmonEnvironment();
  }
  SalmonFunction[string] env_userdefined;
}

/* this is the value you should use for adding code */
class SalmonState
{
public:
  string CODE = "";

}

/* return the argument at the position @p */
string sal_argument_at(SalmonInfo s, int p)
{
  return s.aA[p];
}

void salmon_push_code(SalmonState s, string code)
{
  s.CODE = code; /* push the code to the state */
}

SalmonState newState()
{
  return new SalmonState();
}
