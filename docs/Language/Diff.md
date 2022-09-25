# SLisp VS Traditional CL (Common Lisp)

SalmonLisp aims to be as compatible with Common Lisp as possible, but it bends the rules just a *tiiiny* bit.

For example: **In Common Lisp there is no dedicated `while` function.**

You would need to use another function called **`loop`**.

```commonlisp
(loop while ...)
```
But in SLisp, you could simply use the built-in `while` function.

```commonlisp
(while ... (clause*))
```
