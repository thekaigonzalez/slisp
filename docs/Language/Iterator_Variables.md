# Iterator Variables

## `@`

The **AT** symbol is mainly for formatting. 

When you use a `format` call, the proper method of indexing is `@`.

## `*`

This is used for `each` loops. When iterating over a certain object, you use this symbol to get the object at the position currently being indexed.

```lisp
(each my-list 
      (print (access *)))
```
