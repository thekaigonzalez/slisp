# List - Salmon Types

List is a type allowing for comprehensive object management.

> **Warning:** Types are new to Salmon and can not yet be displayed in a proper way yet. They are 100% mutable and can be mutated. The only way to access arrays are from the [D API.](../D_API/index.md)

## Mutation

```lisp
; Lists can be created using a simple formula:
; (list <name> <contents>)
; There's a beta method to print a list
; Using the format function.
; But that will be supported in later versions.
(list my-fun-list 1 2 3 4 5)
```

## Formatting (**only in** 2.0)

```lisp
(format my-list 
              (print 
                    (access @)))
```

To learn what `@` does, overview the [iterator variables](../Iterator_Variables.md) page.