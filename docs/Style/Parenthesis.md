# Parenthesis Style Guide

The best style for parenthesis would be:

```lisp
(defun function ()
    (print "Hello!")
)
```

Because this helps maintain readability and helps you focus on important parts of your program.

This:

```lisp
(defun test (n)
    (progn (
            (case (= n 1)
                n
                (* n 2)
            )
    )
)
```

Is much better than:

```lisp
(defun test (n)
    (progn (
            (case (= n 1)
                n
                (* n 2))))
```
