/* SALMON: A basic implementation of Common Lisp. */
// (print "Hello, Salmon World!")

module salinterp;

import std.stdio;
import std.conv;
import std.string;
import std.concurrency;
import std.file;
import core.thread;
import sal_builtins;
import core.stdc.stdlib;
import sal_auxlib;
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
      b ~= n;
    }
    else if (n == '"' && s == 1237)
    {
      s = 0;
      b ~= n;
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

int checkeq(SalmonSub s)
{
  s.returnValue(to!string(s.aA[0] == s.aA[1]), SalType.boolean);
  return 0;
}

int checkbet(SalmonSub s)
{
  s.returnValue(to!string(s.aA[0].to!int < s.aA[1].to!int), SalType.boolean);
  return 0;
}

int checkgre(SalmonSub s)
{
  s.returnValue(to!string(s.aA[0].to!int > s.aA[1].to!int), SalType.boolean);
  return 0;
}

int checkbete(SalmonSub s)
{
  s.returnValue(to!string(s.aA[0].to!int <= s.aA[1].to!int), SalType.boolean);
  return 0;
}

int checkgree(SalmonSub s)
{
  s.returnValue(to!string(s.aA[0].to!int >= s.aA[1].to!int), SalType.boolean);
  return 0;
}

int checkxq(SalmonSub s)
{
  string truf = to!string(!(s.aA[0] == s.aA[1]));
  s.returnValue(truf, SalType.boolean);
  return 0;
}

int typeLisp(SalmonSub s)
{
  s.returnValue(checkSalmonType(s.raw[0]).to!string, SalType.any);
  return 0;
}

int lengthLisp(SalmonSub s)
{
  if (s.aA[0] in s.environ.env_lists)
  {
    s.returnValue(s.environ.env_lists[s.aA[0]].length.to!string, SalType.str);
    return 0;
  }
  s.returnValue(s.aA[0].length.to!string, SalType.number);
  return 0;
}

int probeFileLisp(SalmonSub s)
{
  s.returnValue(s.aA[0].exists.to!string, SalType.str);
  return 0;
}

int builtin_access(SalmonSub i)
{
  i.returnValue(i.environ.env_vars[i.aA[0]].getValue(), i.environ.env_vars[i.aA[0]].getType());
  return 0;
}

int builtin_accessq(SalmonSub i)
{
  deprecate("\033[;1m`getq'\033[0m is deprecated, please use \033[;1m`get'\033[0m.", __LINE__, "[D]");
  return 0;
}

string toSyntax(string fun, string noted, string arg2, int lineno = 0)
{
  return (to!string(
      lineno) ~ " | (\033[35;1m" ~ fun ~ "\033[0m \033[36;1m" ~ noted ~ "\033[;0m (" ~ arg2 ~ ")");
}

int returnAt(SalmonSub inf)
{
  deprecate("\033[;1m`getf'\033[0m is deprecated, please use \033[;1m`position'\033[0m.", __LINE__, "[D]");
  // inf.returnValue(inf.environ.env_lists[inf.aA[0]][to!int(inf.aA[1])], SalType.any);
  return 0;
}

int positionLisp(SalmonSub inf)
{
  SalmonValue list = inf.value_at(0);
  // foreach (SalmonValue value; inf.newArg)
  // {
  //   if (value.getType() == SalType.list)
  //   {
  //     writeln(value.list_members());
  //   }
  //   else
  //   {
  //     writeln(value.getValue() ~ " - " ~ value.getType().to!string);
  //   }
  // }

  int pos = inf.aA[1].to!int;
  inf.returnValue(list.list_members()[pos]);
  return 0;
}

int lispPosition(SalmonSub inf)
{
  // inf.returnValue([to!int(inf.aA[1])], SalType.any);
  return 0;
}

int replaceLisp(SalmonSub inf)
{
  inf.returnValue(inf.aA[0].replace(inf.aA[1], inf.aA[2]), SalType.any);
  return 0;
}

int assertLisp(SalmonSub inf)
{
  assert(to!bool(inf.aA[0]));
  return 0;
}

int returnLisp(SalmonSub inf)
{
  inf.returnValue(inf.aA[0], SalType.any);
  return 0;
}

int lintersection(SalmonSub i)
{
  SalmonValue[] list1 = i.value_at(0).list_members();
  SalmonValue list2 = i.value_at(1);
  SalmonValue list3 = new SalmonValue();

  list3.flagAsList();

  foreach (SalmonValue n; list1)
  {
    if (canFind(valArrayToString(list2), n.getValue()))
    {
      listAppendV(n, list3);
    }
  }
  SalmonValue listal = new SalmonValue();

  listal.g = list3.g;
  listal.t = list3.getType();

  listal.returnList(list3.list_members());

  i.returnValue(listal);

  return 0;
}

int concat(SalmonSub f)
{
  string[] array = f.value_at(0).valArrayToString();
  f.returnValue("[" ~ array.join(", ") ~ "]");
  return 0;
}

int readlineLisp(SalmonSub inf)
{
  inf.returnValue(readln(), SalType.any);
  return 0;
}

int writeLineLisp(SalmonSub inf)
{
  write(inf.aA[0]);
  return 0;
}

int compileLisp(SalmonSub inf)
{
  auto n = newState();
  n.CODE = inf.aA[0];
  auto vat = execute_salmon(n, true, inf.environ);
  inf.returnValue(vat.getValue, vat.getType);
  return 0;
}

int isNull(SalmonSub i)
{
  i.returnValue((i.aA[0] == "nil").to!string, SalType.str);
  return 0;
}

SalmonValue[] listToValues(string[] l, SalmonEnvironment env)
{
  /** 
   * Converts `l` to a `SalmonValue[]`
   */
  SalmonValue[] n = [];
  int iterator = 0;

  foreach (string s; l)
  {
    auto sa = newState();

    salmon_push_code(sa, s);
    n ~= execute_salmon(sa, true, env);
    iterator += 1;
  }

  return n;
}

string _FILEN = "";

SalmonValue quickRun(string c, SalmonEnvironment env)
{
  auto sc = newState();
  salmon_push_code(sc, c);
  return execute_salmon(sc, true, env);
}

/* STRING because it will return a value to be reparsed if needed. Fight me */
SalmonValue execute_salmon(SalmonState s, bool lambda = false, SalmonEnvironment env = new SalmonEnvironment())
{
  int LINE_NUMBER = 1;
  int[string] reserves = [
    "set": 0,
    "require": 1,
    "list": 2,
    "each": 3,
    "if": 4,
    "defun": 5,
    "case": 6,
    "&thread": 7,
    "await": 8,
  ];

  env.env_funcs["+"] = &builtin_add;
  env.env_funcs["<"] = &checkbet;
  env.env_funcs[">"] = &checkgre;
  env.env_funcs[">="] = &checkgree;
  env.env_funcs["<="] = &checkbete;

  env.env_funcs["*"] = &builtin_mul;

  env.env_funcs["="] = &checkeq;
  env.env_funcs["not"] = &checkxq;
  env.env_funcs["length"] = &lengthLisp;
  env.env_funcs["replace"] = &replaceLisp;
  env.env_funcs["return"] = &returnLisp;
  env.env_funcs["assert"] = &assertLisp;
  env.env_funcs["compile"] = &compileLisp;
  env.env_funcs["type"] = &typeLisp;
  env.env_funcs["type"] = &typeLisp;
  env.env_funcs["probe-file"] = &probeFileLisp;
  env.env_funcs["null"] = &isNull;

  env.env_funcs["eq"] = &checkeq;
  env.env_funcs["getf"] = &returnAt;
  env.env_funcs["read-line"] = &readlineLisp;
  env.env_funcs["write-line"] = &writeLineLisp;

  env.env_funcs["print"] = &builtin_print;
  env.env_funcs["println"] = &builtin_dep_println; /* println deprecated */
  env.env_funcs["strcat"] = &builtin_strcat;
  env.env_funcs["string-trim"] = &builtin_trim;
  env.env_funcs["get"] = &builtin_access;
  env.env_funcs["istrcat"] = &istrcat;
  env.env_funcs["getq"] = &builtin_accessq;
  env.env_funcs["position"] = &positionLisp;
  env.env_funcs["intersection"] = &lintersection;
  env.env_funcs["concatenate"] = &concat;

  string b;
  SalmonValue value = new SalmonValue();
  int st = 0;
  int m = 0;
  if (!startsWith(s.CODE.strip, '(') && lambda)
  {
    if (startsWith(s.CODE.strip, '"'))
      value.returnValue(parse_string(s.CODE), SalType.str);
    else
    {
      if (lambda && (s.CODE.strip in env.env_vars))
      {
        auto var = env.env_vars[s.CODE.strip];
        value.returnValue(var);
        return value;
      }
      else
      {
        value.returnValue(s.CODE.strip, checkSalmonType(s.CODE.strip)); /* Return the value */
        return value;
      }
      value.returnNil();
    }
  }
  else if (!startsWith(s.CODE.strip, '(') && !lambda && !startsWith(s.CODE.strip, ';'))
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
        SalmonValue lis = quickRun(args[1], env);
        lis.flagAsList();
        string codee = args[2];
        foreach (SalmonValue sm; lis.list_members())
        {
          env.env_vars["@"] = sm;

          auto scopem = newState();
          salmon_push_code(scopem, codee);
          execute_salmon(scopem, false, env);
        }
      }

      else if (args[0] == "&thread")
      {
        string codee = args[1];
        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string f = "nil";
        Thread ab = new Thread({
          f = execute_salmon(scopem, false, env).getValue();
        }).start();

        if (lambda)
          value.returnValue(f, SalType.any);
      }

      else if (args[0] == "while")
      {
        string codee = args[1];

        auto scopem = newState();
        salmon_push_code(scopem, codee);
        auto condition = execute_salmon(scopem, true, env);
        auto scopeg = newState();
        salmon_push_code(scopeg, args[2 .. $].join(' '));

        if (condition.getType() != SalType.boolean)
        {
          err("Type `" ~ condition.getType()
              .to!string ~ "`, expected `boolean`.", LINE_NUMBER, _FILEN);
          note("Does the statement `" ~ scopem.CODE.strip ~ "' return a `true/false` value?", LINE_NUMBER, _FILEN);
          return value;
        }

        while (condition.getValue == "true" || condition.getValue == "1")
        {
          execute_salmon(scopeg, false, env);
          condition = execute_salmon(scopem, true, env);
        }
        return value;
      }

      else if (args[0] == "defun")
      {
        string codee = args[1];

        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string name = execute_salmon(scopem, true, env).getValue;

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

        string condition = execute_salmon(scopem, true, env)
          .getValue();

        auto scopeg = newState();
        salmon_push_code(scopeg, join(args[2 .. $], " "));

        if (condition == "true" || condition == "1")
        {
          execute_salmon(scopeg, false, env);
          condition = execute_salmon(scopem, true, env).getValue();
        }
      }

      else if (args[0] == "await")
      {
        thread_joinAll();
        value.returnNil();
      }

      else if (args[0] == "case")
      {
        string codee = args[1];
        auto scopem = newState();
        salmon_push_code(scopem, codee);
        string condition = execute_salmon(scopem, true, env).getValue();
        auto scopeg = newState();
        salmon_push_code(scopeg, (args[2]));

        auto scopef = newState();
        salmon_push_code(scopef, (args[3]));
        if (condition == "true" || condition == "1")
        {
          auto exe = execute_salmon(scopeg, true, env);
          if (lambda)
          {
            value.returnValue(exe.getValue(), exe.getType());
            return value;
          }
          condition = execute_salmon(scopem, true, env).getValue();
        }
        else
        {
          auto exe2 = execute_salmon(scopef, true, env);
          if (lambda)
          {
            value.returnValue(exe2.getValue(), exe2.getType());
            return value;
          }
          condition = execute_salmon(scopem, true, env).getValue();
        }
      }

      if (!(args[0] in env.env_funcs) && !(args[0] in env.env_userdefined) && !(args[0] in reserves))
      {
        value.returnNil();
        return value;
      }
      SalmonSub tmp = new SalmonSub();
      tmp.environ = env;
      string[] argum = args[1 .. $];
      SalmonValue[] rargum = [];

      if (!(args[0] in reserves))
      {
        for (int _ = 0; _ < argum.length; ++_)
        {
          auto Scope = newState();
          salmon_push_code(Scope, argum[_]);
          argum[_] = execute_salmon(Scope, true, env).getValue();
          rargum ~= execute_salmon(Scope, true, env);
        }
      }
      tmp.raw = args;
      tmp.newArg = rargum;
      tmp.aA = argum;
      if (args[0] == "set")
      {
        SalmonValue outVal = quickRun(argum[1], env);
        env.env_vars[argum[0]] = outVal;
      }
      else if (args[0] == "require")
      {
        args[1] = parse_string(args[1]);
        if (exists(args[1]) && isFile(args[1]))
        {
          auto include = newState;
          include.CODE = readText(args[1]);
          execute_salmon(include, lambda, env);
        }
        else if (exists(args[1]) && isDir(args[1]))
        {
          auto include = newState;
          include.CODE = readText(args[1] ~ "/init.asd");
          execute_salmon(include, lambda, env);
        }
        else
        {
          if (exists("./libs/" ~ argum[0] ~ ".so"))
          {
            import core.sys.linux.dlfcn;

            void* hndl = dlopen(("./libs/" ~ argum[0] ~ ".so").toStringz(), RTLD_LAZY);

            int function(SalmonEnvironment) openFunc = cast(int function(SalmonEnvironment)) dlsym(hndl, "sal_lib_init");

            openFunc(env);
          }
          else if (exists("/usr/local/lib/salmon/libs/" ~ argum[0] ~ ".so"))
          {
            import core.sys.linux.dlfcn;

            void* hndl = dlopen(("/usr/local/lib/salmon/libs/" ~ argum[0] ~ ".so")
                .toStringz(), RTLD_LAZY);

            int function(SalmonEnvironment) openFunc = cast(int function(SalmonEnvironment)) dlsym(hndl, "sal_lib_init");

            openFunc(env);
          }
          else
          {
            err("require '" ~ argum[0] ~ "' - library not found in any supported path(s).", LINE_NUMBER, _FILEN);
            note("required here:\n\t" ~ toSyntax("require", "\"" ~ argum[0] ~ "\"", "...", LINE_NUMBER), LINE_NUMBER,
              _FILEN);

            if (exists("/usr/local/lib/salmon/libs/" ~ argum[0].toLower ~ ".so") || exists(
                "./libs/" ~ argum[0].toLower))
            {
              writeln("\033[;1mTip!\033[0m '" ~ argum[0] ~ "' does not exist, but \033[;1m\"" ~ argum[0].toLower ~
                  "\"\033[0m does. Did you mean, \033[;1m(\033[35;1mrequire\033[;1m \"" ~ argum[0].toLower ~ "\")\033[0m ?");
            }
            if (_FILEN != "repl")
              exit(8);
            else
            {
              value.returnValue("importFailure", SalType.error);
            }
          }
        }
      }
      else if (args[0] == "list")
      {
        value.returnList(listToValues(argum[0 .. $], env));
        value.t = SalType.list;

        return value;
      }
      else if (args[0] == "format")
      {
        string target = "nil";

        if (argum[0] in env.env_vars)
          target = env.env_vars[argum[0]].getValue();
        else if (argum[0] in env.env_lists)
          target = env.env_vars[argum[0]].list_members().valuesToList(env).join(",");

        auto Scope2 = newState();
        auto env_loop = new SalmonEnvironment();

        /* bind environment */
        env_loop.env_lists = env.env_lists;
        env_loop.env_vars = env.env_vars;
        env_loop.env_funcs = env.env_funcs;

        env_loop.env_vars["@"] = quickRun(target, env);
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

          auto env_arch = env.copy;

          for (int f1 = 0; f1 < fn.template_params.length; ++f1)
          {
            try
            {
              env.env_vars[fn.template_params[f1]] = quickRun(argum[f1], env);
            }
            catch (core.exception.ArrayIndexError)
            {
              err("parameter `" ~ fn.template_params[f1] ~ "` not supplied.", LINE_NUMBER, _FILEN);
              note("defined here:\n  (\033[35;1mdefun\033[0m \033[36;1m" ~ args[0] ~ "\033[;0m (" ~ join(
                  fn.template_params, ", ") ~ ") ...", LINE_NUMBER, _FILEN);
              writeln("\t\033[36;1m ^~~~~~~~~~~~\033[0m");
              exit(9);
            }
          }

          execute_salmon(sl, false, env);

          if (lambda)
          {
            auto sala = execute_salmon(sl2, true, env);
            value.returnValue(sala.getValue(), sala.getType());
            return value;
          }

          env = env_arch;
        }
        else if (!(args[0] in reserves))
        {
          try
          {
            env.env_funcs[args[0]](tmp);
          }
          catch (core.exception.ArraySliceError e)
          {
            err("could not truncate: bad statement", LINE_NUMBER, _FILEN);
            note("statement length: " ~ s.CODE.length.to!string, LINE_NUMBER, _FILEN);
          }
          catch (core.exception.ArrayIndexError e)
          {
            value.returnNil();
          }
          catch (core.exception.RangeError e)
          {
            // err("tried to access unknown value", LINE_NUMBER, _FILEN);
            // note("line here:\n\t" ~ toSyntax(args[0], args[1], "...", LINE_NUMBER), LINE_NUMBER, _FILEN);
            // exit(10);
            value.returnNil();
          }
          catch (ConvException e)
          {
            err(e.msg, LINE_NUMBER, _FILEN);
            value.returnValue("convException", SalType.error);
            exit(13);
          }
          catch (FileException e)
          {
            value.returnNil();
          }
          catch (core.exception.AssertError e)
          {
            err(e.msg, LINE_NUMBER, _FILEN);
            note("condition:\n\t" ~ toSyntax(args[0], args[1], "...", LINE_NUMBER), LINE_NUMBER, _FILEN);
          }
        }
      }
      if (lambda)
      {
        if (tmp.rvalue.getType() != SalType.list)
          value.returnValue(tmp.rvalue, tmp.rvalue.getType());
        else
        {
          value.returnList(tmp.rvalue.g);
        }
        return value;
      }
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
      if (n == '\n')
      {
        LINE_NUMBER += 1;
      }
    }
  }
  return value;
}

string getTargetSystem()
{
  version (linux)
  {
    return "Linux";
  }
  version (Windows)
  {
    return "Windows";
  }
  version (OSX)
  {
    return "macOS/OSX-based";
  }
  else
  {
    return "Unknown";
  }
}
