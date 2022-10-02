import sal_shared_api;
import std.stdio;
import std.conv;
import std.base64;
import std.string;
import sal_auxlib;

int builtin_print(SalmonSub info) {
    writeln(join(info.aA, ""));
    return (0);
}

int istrcat(SalmonSub i) {
    i.returnValue(join(i.aA, ""), SalType.any);

    return (0);
}

int builtin_trim(SalmonSub s) {
    s.returnValue(s.aA[0].strip, SalType.str);
    return 0;
}

int builtin_dep_println(SalmonSub s) {
    writeln(
            "(deprecation) `println` is not a part of the Common Lisp standard. It is only here for reference purposes.\n"
            ~ "In future code please use `print`, it does the same as `println` in the CL standard.");
    return (1);
}

int builtin_strcat(SalmonSub info) {
    info.returnValue(info.aA[0] ~ info.aA[1], SalType.str);

    return (0);
}

int builtin_add(SalmonSub info) {
    int i = 0;

    foreach (string n; info.aA) {
        i += to!int(n);
    }
    info.returnValue(to!string(i), SalType.number);
    return (0);
}

int builtin_min(SalmonSub info) {
    int i = info.value_at(0).getValue().to!int;

    int i1 = info.value_at(1).getValue().to!int;

    info.returnValue(to!string(i - i1), SalType.number);
    return (0);
}

int builtin_div(SalmonSub info) {
    int i = info.value_at(0).getValue().to!int;

    int i1 = info.value_at(1).getValue().to!int;

    info.returnValue(to!string(i / i1), SalType.number);
    return (0);
}

int builtin_mul(SalmonSub info) {
    int i = 1;

    foreach (string n; info.aA) {
        i *= to!int(n);
    }
    info.returnValue(to!string(i), SalType.number);
    return (0);
}
