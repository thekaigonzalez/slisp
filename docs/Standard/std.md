# Standard Library (Builtins)

The standard library populates the environment with about `10` functions. They are listed below.

## `+ <n> <g>`

Adds `n` & `g` and returns the result.

## `= <v1> <v2>`

If `v1` is `v2` then it will return `true`, otherwise
it will return `false`.

## `not <n> <g>`

The opposite of `+`. If `v1 = v2` is false, it will return true. Otherwise false.

## `eq`

an alias to +.

## `print [contents...]`

Prints a string with a `\n`.

`[contents]` can be a list of strings, it will separate them with `' '`.

## `println`

> WARNING: this is deprecated. Use `print`.

## `println` (DEPRECATED)

## `strcat [str1] [str2]`

Returns `str1 + str2`

## `istrcat [strs...]`

Stands for **I**nfinite **`strcat`**.

It joins `strs` separated by `' '`.

## `trim <str>`

Trims all whitespace from both sides of `[str]`.

## `get <NAME>`

Gets a variable called `[NAME]` and returns it.

## `getq <LIST>`

Prints a [`List`](../Language/Types/List.md) separated by `,`.

```lisp
(list a 1 2 3 4)
(set list-printed (getq a))
```

## `< [n1] [n2]`

Returns `true` if `n1` is less than `n2`.

## `* [n...]`

The multiplication operator.

## `length [strOrList]`

returns the length of the string, or list `[strOrList]`

## `return [v]`

Returns `[v]`. Mainly used as a helper in functions.

```lisp
(print (return "hello")) ; hello

(defun x ()
  (return (+ 1 1)))
```

## `assert [g]`

Exits if `[g]` is not true.

## `probe-file [fn]`

Returns a bool value if `[fn]` (file) exists on the filesystem/

## `null [value]`

Returns `true` if `[value]` is `nil`.

## `getf [li] [pos]`

Gets `li[pos]`

## `read-line`

Returns one line of STDIN. (backported from `input` lib)

## `write-line [s]`

Writes `[s]` to `stdout` without flushing.

## `replace [s] [l1] [l2]`

Replaces `[l1]` with `[l2]` in string `[s]`.
