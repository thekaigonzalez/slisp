module sal_auxlib;

import salinterp;
import sal_shared_api;
import std.conv;

class SalmonValue
{
public:
  string v = "nil";
  SalType t = SalType.nil;
  SalmonValue[] g; /* unless it's a list */

  // Adds `value` to @v & `type` as the type.
  void returnValue(string value, SalType type)
  {
    t = type;
    v = value;
  }

  void returnValue(SalmonValue n) {
    if (n.getType() == SalType.list) {
      g = n.g;
    } else 
      v = n.v;
      
    t = n.getType();
  }

  void returnValue(SalmonValue n, SalType p) {
    v = n.v;
    t = p;
  }

  SalmonValue[] list_members() {
    if (t != SalType.list) {
      err("[C]: running list_members() on a type \033[;1m" ~ t.to!string ~ "\033[0m");
      return [new SalmonValue()];
    } else {
      return this.g;
    }
  }

  void returnList(SalmonValue[] li)
  {
    g = li;
    t = SalType.list;
  }

  string getValue()
  {
    return v;
  }

  SalType getType()
  {
    return t;
  }

  void returnNil()
  {
    t = SalType.nil;
    v = "nil";
  }
}

class SalmonSub
{
public:
  string[] aA;
  string[] raw;

  SalmonValue[] newArg = [];
  SalmonValue rvalue = new SalmonValue();
  SalType rvaluetype = SalType.nil; /* WARNING: rvaluetype is not used now that we have salmonvalue types. */
  /* it is used as a backward compatibility transition into the new API. */
  /* + whatever else I need */
  void returnValue(SalmonValue value)
  {
    rvalue = value;
  }

  SalmonValue value_at(int pos) {
    return newArg[pos];
  }
  void returnValue(string value, SalType t)
  {
    rvalue = quickRun(value, this.environ);
    this.rvaluetype = rvalue.getType();
  }

  SalmonEnvironment environ = new SalmonEnvironment();
}
