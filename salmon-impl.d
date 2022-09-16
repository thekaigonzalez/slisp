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
static import core.exception;

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

string[] parseParamList(string mf)
{
  int st = 0;
  string b = "";
  string[] pi;

  foreach (char s; mf)
  {
    if (s == '(' && st == 0)
    {
      st = 1;
    }
    else if (s == ')' && st == 1)
    {
      if (b.strip.length > 0)
      {
        pi ~= b.strip;
      }

      return pi;
    }
    else if (s == '(' && st != 0)
    {
      st += 5;
    }
    else if (s == ')' && st > 1)
    {
      st -= 5;
    }
    else if (s == ',' && st == 1)
    {
      pi ~= b.strip;
      b = "";
    }
    else
    {
      b ~= s;
    }
  }
  return pi;
}

int checkeq(SalmonInfo s)
{
  s.returnValue(to!string(s.aA[0] == s.aA[1]), SalType.number);
  return 0;
}

int checkxq(SalmonInfo s)
{
  string truf = to!string(!(s.aA[0] == s.aA[1]));
  s.returnValue(truf, SalType.number);
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

void err(string msg) {
  writeln("\033[31;1merror:\033[0m " ~ msg);
}
void note(string msg) {
  writeln("\033[36mnote:\033[0m " ~ msg);
}

/* STRING because it will return a value to be reparsed if needed. Fight me */
string execute_salmon(SalmonState s, bool lambda = false, SalmonEnvironment env = new SalmonEnvironment())
{
  int[string] reserves = [
    "set": 0,
    "require": 1,
    "list": 2,
    "each": 3,
    "if": 4,
    "defun": 5,
  ];

  env.env_funcs["+"] = &builtin_add;
  env.env_funcs["="] = &checkeq;
  env.env_funcs["not"] = &checkxq;
  env.env_funcs["eq"] = &checkeq;
  env.env_funcs["print"] = &builtin_print;
  env.env_funcs["println"] = &builtin_dep_println; /* println deprecated */
  env.env_funcs["strcat"] = &builtin_strcat;
  env.env_funcs["trim"] = &builtin_trim;
  env.env_funcs["get"] = &builtin_access;
  env.env_funcs["istrcat"] = &istrcat;
  env.env_funcs["getq"] = &builtin_accessq;

  string b;

  int st = 0;
  int m = 0;
  if (!startsWith(s.CODE.strip, '(') && lambda)
  {
    if (s.CODE.strip[1 .. $] in env.env_vars && s.CODE[0] == '&')
      return env.env_vars[s.CODE[1 .. $]];

    return s.CODE;
  }
  else if (!startsWith(s.CODE, '(') && !lambda && !startsWith(s.CODE, ';'))
  {
    // writeln("(syntax warning) this style of syntax is deprecated: `<function> (args)`.\nPlease use the modern" ~
    // "`(<function> <args>)' format.");
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
    else if (n == ';' && st == 0)
    {
      st = -100;
      m = -1;
    }
    else if (n == '\n' && st == -100)
    {
      st = 0;
      m = 0;
      b = "";
    }
    else if (n == ')' && m == 1 && st == 1)
    {
      string[] args = _sep(b.strip);

      // for (int ia = 0 ; ia < args.length ; ++ ia) {
      //   args[ia] = strip(args[ia]);
      // }
      if (args[0] == "each")
      {
        if (args[1].strip in env.env_lists)
        {
          string codee = args[2];
          foreach (string sm; env.env_lists[args[1].strip])
          {
            env.env_vars["*"] = sm;
            auto scopem = newState();
            salmon_push_code(scopem, codee);
            execute_salmon(scopem, false, env);
          }
        }
      }

      else if (args[0] == "while")
      {
        string codee = args[1];

        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string condition = execute_salmon(scopem, true, env);

        auto scopeg = newState();
        salmon_push_code(scopeg, args[2 .. $].join(' '));

        while (condition == "true" || condition == "1")
        {
          execute_salmon(scopeg, false, env);
          condition = execute_salmon(scopem, true, env);
        }
      }

      else if (args[0] == "defun")
      {
        string codee = args[1];

        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string name = execute_salmon(scopem, true, env);

        auto scopeg = newState();
        salmon_push_code(scopeg, args[args.length - 1]);

        auto Func = new SalmonFunction();

        Func.template_params = parseParamList(args[2]);
        Func.run = join(args[3 .. args.length], ' ');
        Func.returns = scopeg.CODE;

        env.env_userdefined[name] = Func;
        env.env_definitions[name] = args.join(' ');
      }

      else if (args[0] == "if")
      {
        string codee = args[1];

        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string condition = execute_salmon(scopem, true, env);

        auto scopeg = newState();
        salmon_push_code(scopeg, join(args[2 .. $], " "));

        if (condition == "true" || condition == "1")
        {
          execute_salmon(scopeg, false, env);
          condition = execute_salmon(scopem, true, env);
        }
      }

      if (!(args[0] in env.env_funcs) && !(args[0] in env.env_userdefined) && !(args[0] in reserves))
      {
        return "nil";
      }
      SalmonInfo tmp = new SalmonInfo();
      tmp.environ = env;
      string[] argum = args[1 .. $];
      if (!(args[0] in reserves) || args[0] == "set")
      {
        for (int _ = 0; _ < argum.length; ++_)
        {
          auto Scope = newState();
          salmon_push_code(Scope, argum[_]);
          argum[_] = execute_salmon(Scope, true, env);
        }
      }

      tmp.aA = argum;
      if (args[0] == "set")
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
        salmon_push_code(Scope2, args[2]);

        execute_salmon(Scope2, true, env_loop);

      }
      else
      {
        if (args[0] in env.env_userdefined)
        {
          auto sl = newState();
          auto sl2 = newState();
          SalmonFunction fn = env.env_userdefined[args[0]];
          string cod = fn.run;
          string rv = fn.returns;

          salmon_push_code(sl, cod);
          salmon_push_code(sl2, rv);

          for (int f1 = 0; f1 < fn.template_params.length; ++f1)
          {
            try
            {
              env.env_vars[fn.template_params[f1]] = argum[f1];
            }
            catch (core.exception.ArrayIndexError)
            {
              err("parameter `" ~ fn.template_params[f1] ~ "` not supplied.");
              note("defined here:\n  (\033[35;1mdefun\033[0m \033[36;1m" ~ args[0] ~ "\033[;0m (" ~ join(fn.template_params, ", ") ~ ") ...");
              writeln("\t\033[36;1m ^~~~~~~~~~~~\033[0m");
              return "errorParameterNotSupplied";
            }
          }
          execute_salmon(sl, false, env);

          if (lambda)
          {
            return execute_salmon(sl2, true, env);
          }
        }
        else if (!(args[0] in reserves))
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
