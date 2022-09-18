// Salmon Implementation

import std.stdio;

enum SalType
{
  nil,
  str,
  number,
  any,
  func,
  list,
  error,
  boolean
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

/* value: type */
class SalmonValue {
public:
  string v = "nil";
  SalType t = SalType.nil;
  SalmonValue[] g; /* unless it's a list */

  // Adds `value` to @v & `type` as the type.
  void returnValue(string value, SalType type) {
    t = type;
    v = value;
  }

  void returnList(SalmonValue[] li) {
    g = li;
  }

  string getValue() {
    return v;
  }

  SalType getType() {
    return t;
  }

  void returnNil() {
    t = SalType.nil;
    v = "null";
  }
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
