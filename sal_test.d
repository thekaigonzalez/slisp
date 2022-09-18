module sal_test;

import std.stdio;
import std.process;
import std.file;
import std.conv;

void main() {
  auto strnc = dirEntries("./unit-tests/", SpanMode.depth);
  int testN = 0;
  int passedTests = 0;
  int failed_tests = 0;
  foreach (string d; strnc) {
    testN += 1;
    if (d.isFile()) {
      auto proc = executeShell("salmon-linux-x86_64 " ~ d);

      if (proc.status == 0) {
        writeln("\033[32;1mTEST " ~ testN.to!string ~ " SUCCESSFUL!\033[0;0m");
        passedTests += 1;
      } else {
        writeln("\033[33;1mTEST " ~ testN.to!string ~ " FAILED.\033[0;0m");
        failed_tests += 1;
      }
    }
  }
  if (failed_tests == 0) {
    writeln("\033[36;1mAll tests passed!\033[0m");
  }
}