# What is `require` ?

Require is a function that allows you to import files & [D API](../../Language/D_API/) files.

## How do I use it?

Simply just use the `require` function.

The syntax is `(require <mod-name>)`

## Example

```lisp
(require "file-1.asd")

(function-from-file-1)
```

**file-1.asd:**

```lisp
(defun function-from-file-1 ()
  (print "Hello, world!"))
```

## Supported directories

For a more customizable path variable, please see about using the [`import`](./import.md) function instead.

- `./libs/*.so`
- `./*.asd`
- `/usr/local/lib/salmon/libs/*.so`
