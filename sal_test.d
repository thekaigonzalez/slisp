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

  foreach (string d; strnc)
  {
    testN += 1;
    if (d.isFile() && endsWith(d, ".asd"))
    {
      auto proc = executeShell("salmon-linux-x86_64 " ~ d ~ " | echo 'asdf'");

      if (proc.status == 0)
      {
        writeln("\033[32;1mTEST " ~ testN.to!string ~ " SUCCESSFUL!\033[0;0m");
        passedTests += 1;
      }
      else
      {
        writeln("\033[33;1mTEST " ~ testN.to!string ~ " FAILED.\033[0;0m");
        readln();
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

}
