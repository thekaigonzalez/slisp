# Consistency

When writing SLisp, it should be noted that good code will not contain more than one type of the available syntax methods.

As an example, both `#`, and `;` are comment operators, but you shall not combine them in one file.

```lisp
Choose one:

# Hello, world!
; Hello, world!

```

This is **NOT** okay:

```lisp
(defun my_func ()
    ; Adds something

    (+ 1 1))

# Add things
(my_func)
```