import std.stdio;
import std.conv;
import std.string;
import std.path;
import std.file;


static import core.exception;
import salinterp;

import sal_shared_api;

int main(string[] args)
{
  SalmonEnvironment env = new SalmonEnvironment();
  env.env_vars["salmon_version"] = quickRun("27", env);
  env.env_vars["compiler_system"] = quickRun(getTargetSystem(), env);
  env.env_lists["arg"] = args[1 .. $];
  if (args.length == 1)
  {
    writeln("** SALMON LISP REPL **");
    SalmonState input = new SalmonState();
    _FILEN = "repl";
    while (true)
    {
      write("Lisp> ");
      string n = readln();
      salmon_push_code(input, n);
      try
      {
        auto run = execute_salmon(input, true, env);
        if (run.getType() == SalType.list) {
          writeln("[" ~ valuesToList(run.g, env).join(", ") ~ "] (" ~ run.getType.to!string ~ ")");
        } else {
          writeln(run.getValue() ~ " (" ~ run.getType().to!string ~ ")");
        }
      }
      catch (core.exception.ArraySliceError e)
      {
        err("imbalanced statement (failure to slice)", 0, "repl");
        note("line length: " ~ n.strip.length.to!string, 0, "repl");
      }
      input.CODE = "";
    }
  }

  if (!exists(args[1]))
  {
    writeln("file not found.");
    return 2;
  }

  _FILEN = args[1];
  SalmonState s = newState();

  salmon_push_code(s, readText(args[1]));

  execute_salmon(s, false, env);

  return 0;
}
