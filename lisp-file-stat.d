module lispstat;

import std.stdio;
import std.file;
import std.conv;
import std.string;

void main() {
    int files = 0;
    foreach (string s; dirEntries(".", SpanMode.depth)) {
        if (s.endsWith(".asd") || s.endsWith(".lisp")) {
            files += 1;
        }
    }

    writeln("There were \033[31;1m" ~ files.to!string ~ "\033[0m Lisp files in this directory.");
}
