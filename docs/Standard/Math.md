# math

Import: `(require "math")`

## Functions

### `sin [number]`

The typical bind to `math.sin()` in every programming language.

```lisp

(require "math")

(print 
  (sin 7))

```

### `intersection [list-one: list...] [list-two: list...]`

`list-one`: [List](../Language/Types/List.md)

`list-two`: [List](../Language/Types/List.md)

Prints the intersection (common values) in two arrays.

```lisp
(require "math")

(list list-one 1 2 3 4 5)
(list list-two 2 4 6)

; Prints: 2 4
(intersection list-one list-two)
```

You can read more on **intersections** [here.](https://en.wikipedia.org/wiki/Intersection)

Quoted from the **intersection** Wikipedia page:
> *For example, if A = {1, 3, 5, 7} and B = {1, 2, 4, 6}*,
> *Then the intersection of the two will be {1}.*
