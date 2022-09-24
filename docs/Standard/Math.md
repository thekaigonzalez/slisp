# math - Salmon Modules

Import: `(require "math")`

## Functions

### `sin [number]`

The typical bind to `math.sin()` in every programming language.

```lisp

(require "math")

(print 
  (sin 7))

```

### `intersection [list-one: list...] [list-two: list...] [list-three: any...]`

> **WARNING:** this version of the intersection function is deprecated.
> it has now been merged into the standard library.
> please use [this](std.md) one instead.

`list-one`: [List](../Language/Types/List.md)

`list-two`: [List](../Language/Types/List.md)

`list-three`: [Any](../Language/Types/Any.md)

Puts the intersection of `[list-one]` & `list-two` into `list-three`.

```lisp
(require "math")

(list list-one 1 2 3 4 5)
(list list-two 2 4 6)

(intersection list-one list-two list-three)

(each list-three
  (print (get *)))
; 2
; 4
```

You can read more on **intersections** [here.](https://en.wikipedia.org/wiki/Intersection)

Quoted from the **intersection** Wikipedia page:
> *For example, if A = {1, 3, 5, 7} and B = {1, 2, 4, 6}*,
> *Then the intersection of the two will be {1}.*
