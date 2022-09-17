# Control Flow

There are multiple different ways to check & run conditions.

One of the ways is the classic **if** statement.

```lisp
(if (=> (get num1) 2))
```

But that leaves out the `else if` & `else`.

So, what's the solution?

**`ecase`**.

```lisp
(ecase (condition)
  (if-case)
  (elif-case)
  (else-case))
```
