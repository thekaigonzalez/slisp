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

int checkeq(SalmonInfo s)
{
  s.returnValue(to!string(s.aA[0] == s.aA[1]), SalType.number);
  return 0;
}

int builtin_access(SalmonInfo i)
{
  i.returnValue(i.environ.env_vars[i.aA[0]], SalType.any);
  return 0;
}

int builtin_accessq(SalmonInfo i)
{
  i.returnValue(i.environ.env_lists[i.aA[0]].join(","), SalType.any);
  return 0;
}

/* STRING because it will return a value to be reparsed if needed. Fight me */
string execute_salmon(SalmonState s, bool lambda = false, SalmonEnvironment env = new SalmonEnvironment())
{
  int[string] reserves = [
    "let": 0,
    "require": 1,
    "list": 2,
    "each": 3,
  ];

  env.env_funcs["+"] = &builtin_add;
  env.env_funcs["="] = &checkeq;
  env.env_funcs["eq"] = &checkeq;
  env.env_funcs["print"] = &builtin_print;
  env.env_funcs["println"] = &builtin_dep_println; /* println deprecated */
  env.env_funcs["strcat"] = &builtin_strcat;
  env.env_funcs["trim"] = &builtin_trim;
  env.env_funcs["access"] = &builtin_access;
  env.env_funcs["istrcat"] = &istrcat;
  env.env_funcs["accessq"] = &builtin_accessq;
  string b;

  int st = 0;
  int m = 0;
  if (!startsWith(s.CODE.strip, '(') && lambda)
  {
    if (s.CODE.strip[1 .. $] in env.env_vars && s.CODE[0] == '&')
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

      if (args[0] == "each")
      {

        if (args[1] in env.env_lists)
        {
          string codee = args[2];
          foreach (string sm; env.env_lists[args[1]])
          {
            env.env_vars["*"] = sm;
            auto scopem = newState();
            salmon_push_code(scopem, codee);
            args[2] = execute_salmon(scopem, true, env);
          }
        }
      }

      if (!(args[0] in env.env_funcs) && !(args[0] in reserves))
      {
        return "nil";
      }
      SalmonInfo tmp = new SalmonInfo();
      tmp.environ = env;
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
      else if (args[0] == "require")
      {
        import core.sys.linux.dlfcn;

        void* hndl = dlopen(("./libs/" ~ argum[0] ~ ".so").toStringz(), RTLD_LAZY);

        int function(SalmonEnvironment) openFunc = cast(int function(SalmonEnvironment)) dlsym(hndl, "sal_lib_init");

        openFunc(env);
      }
      else if (args[0] == "list")
      {
        env.env_lists[argum[0]] = argum[1 .. $];
      }
      else if (args[0] == "format")
      {
        string target = "nil";

        if (argum[0] in env.env_vars)
          target = env.env_vars[argum[0]];
        else if (argum[0] in env.env_lists)
          target = env.env_lists[argum[0]].join(",");

        auto Scope2 = newState();
        auto env_loop = new SalmonEnvironment();

        /* bind environment */
        env_loop.env_lists = env.env_lists;
        env_loop.env_vars = env.env_vars;
        env_loop.env_funcs = env.env_funcs;

        env_loop.env_vars["@"] = target;
        writeln(env_loop);
        salmon_push_code(Scope2, args[2]);

        execute_salmon(Scope2, true, env_loop);

      }
      else
      {
        if (!(args[0] in reserves))
          env.env_funcs[args[0]](tmp);
      }

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
  return "?";
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
