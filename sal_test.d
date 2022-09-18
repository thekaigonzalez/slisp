module sal_test;

import std.stdio;
import std.process;
import std.file;
import std.conv;
import std.string;
import std.path;

void test_dir(string dname)
{
  int testN = 0;
  int passedTests = 0;
  int failed_tests = 0;

  auto strnc = dirEntries(dname, SpanMode.depth);
  if (".testcache".exists == false)
    ".testcache".mkdir;

  foreach (string d; strnc)
  {
    if (d.isFile() && endsWith(d, ".asd"))
    {
      testN += 1;

      auto proc = executeShell("salmon-linux-x86_64 " ~ d);

      if (proc.status == 0)
      {
        writeln("\033[32;1mTEST " ~ testN.to!string ~ " SUCCESSFUL!\033[0;0m\b");
        passedTests += 1;
        File n = File(".testcache/test-" ~ testN.to!string ~ "-" ~ baseName(d) ~ ".cache", "w");

        n.write(proc.output);

        n.close();
      }
      else
      {
        writeln("\033[33;1mTEST " ~ testN.to!string ~ " FAILED.\033[0;0m\b");
        File n = File(".testcache/test-fail-" ~ testN.to!string ~ "-" ~ baseName(d) ~ ".cache", "w");

        n.write(proc.output);

        n.close();
        failed_tests += 1;
      }
    }
  }
  if (failed_tests == 0)
  {
    writeln("\033[36;1mAll tests passed!\033[0m");
  }
}

void main()
{

  writeln("testing packaged tests");
  test_dir("./unit-tests");
  writeln("testing ports");
  test_dir("./ports");
  // writeln("testing the standard library");
  // test_dir("./std-src");

}
