# D Programming With Salmon

You can use create D extensions for your Salmon programs, or use D libraries to create extensive programs!

this is a sample library:

```d
import std.stdio;
import sal_shared_api;

int test_function(SalmonInfo info)
{
  writeln("Hello, world!");
  return (0);
}

extern (C) int sal_lib_init(SalmonEnvironment env)
{
  env.env_funcs["test_function"] = &test_function;
  return 0;
}
```

Then run from lisp:

```lisp
(test_function)
```

Get expected output:

```
Hello, world!
```

## Why?

Because why not?

In all seriousness, D has first-class support for Salmon, the standard library is written in D (instead of the implemented language), a lot of functions and libraries are written in D, the language's written in D- You get the point.

The reason for choosing D is because it's an object-oriented programming language with just about everything you need, it contains C-like syntax and just about enough low-level access that it won't have you begging for any more than it provides.

Salmon provides a full API for D, it's a short little guest addition, which was built since I decided to make a separate file for all of the non-depentant API features.

You can find the D Programming language [here!](https://dlang.org/)