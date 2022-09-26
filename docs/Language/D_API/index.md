---
title: the D API
---

# D Programming With Salmon

The D API contains many different functions and variables for adding, editing, and running Salmon code/functions.

This code:

```dlang
int helloWorld(SalmonSub s) {
  writeln(s.value_at(0).getValue());
  return 0;
}
```

is the equivalent to:

```lisp
(defun helloWorld (arg)
  (print arg))
```

As you could (*probably*) tell, SLisp has first-class support for D. 
