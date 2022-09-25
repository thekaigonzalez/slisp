import std.stdio;
import std.conv;
import std.string;
import std.path;
import std.getopt;
import std.file;

static import core.exception;
import salinterp;

import sal_shared_api;

int main(string[] args)
{
  SalmonEnvironment env = new SalmonEnvironment();
  env.env_vars["salmon_version"] = quickRun("30", env);
  env.env_vars["compiler_system"] = quickRun(getTargetSystem(), env);
  env.env_lists["arg"] = args[1 .. $];
  GetoptResult optional_arg;

  bool ver = false;

  try
  {
    optional_arg = getopt(
      args, std.getopt.config.bundling,
      "version|v", "Print version and exit", &ver
    );
  }
  catch (GetOptException e)
  {
    err(e.msg, 0, "cli");
    return 91;
  }

  if (ver) {
    writefln("Salmon Version: %s", env.env_vars["salmon_version"].getValue());
    return 0;
  }

  if (optional_arg.helpWanted)
  {
    writeln("Options:");
    foreach (it; optional_arg.options)
    {
      writefln("\t%s (%s)\t%s", it.optShort,
        it.optLong, it.help);
    }
    writeln("\nPositional (Optional) arguments:\n\tfile(s)\tThe file(s) to run. You may specify more than one.");
    writeln("\nThis is the official Salmon command-line-interface.");
    writeln("Any questions? Email me! <gkai70264@gmail.com>");

    return 0;
  }

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
        if (run.getType() == SalType.list)
        {
          writeln("[" ~ valuesToList(run.g, env).join(", ") ~ "] (" ~ run.getType.to!string ~ ")");
        }
        else
        {
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
    err("file not found.", 0, "commandline");
    return 2;
  }

  foreach (string f; args[1..$])
  {
    _FILEN = f;
    if (!exists(f))
    {
      err("file not found.", 0, "commandline");
      return -1;
    }
    quickRun(readText(f), env, false);
  }
  return 0;
}
