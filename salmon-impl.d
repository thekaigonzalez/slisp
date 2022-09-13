/* SALMON: A basic implementation of Common Lisp. */
// (print "Hello, Salmon World!")

module salmon;

import std.stdio;
import std.conv;
import std.string;
import std.file;
import sal_builtins;
import std.algorithm : canFind;
import sal_shared_api;

string[] _sep(string lisp)
{
  string b = "";
  int s = 0;

  string[] final_;

  foreach (char n; lisp)
  {
    if (n == ' ' && s == 0 && b.strip.length > 0)
    {
      final_ ~= b;
      b = "";
    }
    else if (n == '(' && s != 1237)
    {
      s += 120;
      b ~= n;
    }
    else if (n == ')' && s != 1237)
    {
      s -= 120;
      b ~= n;
    }
    else if (n == '"' && s == 0)
    {
      s = 1237;
    }
    else if (n == '"' && s == 1237)
    {
      s = 0;
    }
    else
    {
      b ~= n;
    }
  }
  if (b.strip.length > 0)
  {
    final_ ~= b;
  }

  return final_;
}

class SalmonEnvironment
{
public:
  int function(SalmonInfo)[string] env_funcs;
  string[string] env_vars;
}

/* STRING because it will return a value to be reparsed if needed. Fight me */
string execute_salmon(SalmonState s, bool lambda = false, SalmonEnvironment env = new SalmonEnvironment())
{
  int[string] reserves = [
    "let": 0
  ];
  env.env_funcs["+"] = &builtin_add;
  env.env_funcs["print"] = &builtin_print;
  env.env_funcs["println"] = &builtin_dep_println; /* println deprecated */
  env.env_funcs["strcat"] = &builtin_strcat;
  string b;

  int st = 0;
  int m = 0;
  if (!startsWith(s.CODE, '(') && lambda)
  {
    if (s.CODE[1 .. $] in env.env_vars && s.CODE[0] == '&')
      return env.env_vars[s.CODE[1 .. $]];

    return s.CODE;
  }
  else if (!startsWith(s.CODE, '(') && !lambda)
  {
    writeln("(syntax warning) this style of syntax is deprecated: `<function> (args)`.\nPlease use the modern" ~
        "`(<function> <args>)' format.");
  }
  for (int i = 0; i < s.CODE.length; ++i)
  {
    char n = s.CODE[i];

    if (n == '(' && st == 0 && m == 0)
    {
      m = 1;
      st = 1;
    }
    else if (n == '(' && m != 0)
    {
      m += 1;
      b ~= n;
    }
    else if (n == ')' && m == 1 && st == 1)
    {
      string[] args = _sep(b.strip);

      if (!(args[0] in env.env_funcs) && !(args[0] in reserves))
      {
        return "nil";
      }
      SalmonInfo tmp = new SalmonInfo();
      string[] argum = args[1 .. $];
      for (int _ = 0; _ < argum.length; ++_)
      {
        auto Scope = newState();
        salmon_push_code(Scope, argum[_]);
        argum[_] = execute_salmon(Scope, true, env);
      }

      tmp.aA = argum;

      if (args[0] == "let")
      {
        env.env_vars[argum[0]] = argum[1];
      }
      else
        env.env_funcs[args[0]](tmp);

      if (lambda)
        return tmp.rvalue;
      m = 0;
      st = 0;
      b = "";
    }
    else if (n == ')' && m != 1)
    {
      m -= 1;
      b ~= n;
    }
    else
    {
      b ~= n;
    }
  }
  return "";
}

void main(string[] args)
{
  if (args.length == 1)
  {
    writeln("** SALMON LISP REPL **");
    SalmonState input = new SalmonState();
    SalmonEnvironment env = new SalmonEnvironment();
    while (true)
    {
      write("Lisp> ");
      string n = readln();
      salmon_push_code(input, n);
      writeln(execute_salmon(input, true, env));
      input.CODE = "";
    }
  }
  SalmonState s = newState();

  salmon_push_code(s, readText(args[1]));

  SalmonEnvironment env = new SalmonEnvironment();

  execute_salmon(s, false, env);
}
