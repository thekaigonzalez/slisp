<!--
 Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
 Use of this source code is governed by a BSD-style
 license that can be found in the LICENSE file.
-->

# SLisp 1.5.0 Builtin Keywords

## `set [name] [value]`

Creates a new variable called `name` and sets it's value to `value`.

## `eq`

The english form of the operator [+.](../operators/index.md#math)

## `list`

!!! warning
    The entirety of list functionality is in very early alpha. It may not work as intended
    and some values may be incorrect. Sorry.

Creates a new list with the arguments as the inhabitants.

```lisp
(list a 1 2 3 4)
```

## `format`

!!! note
    This function would later on be replaced by the `each` keyword. Please
    keep that in mind as they do the same things.

Iterates a list and runs the given code with the list object as a variable.

```lisp
(format my-list 
              (print 
                    (access @)))
```
