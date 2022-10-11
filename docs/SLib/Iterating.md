<!--
 Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
 Use of this source code is governed by a BSD-style
 license that can be found in the LICENSE file.
-->

# Iterator Functions

There are many different functions for iterating and creating many types of loops.

This document will go over some of the basic use cases for them.

## `each`

The `each` keyword iterates over the given list and uses a variable `@` to notate each variable.

For example, if you want to iterate a list, and add every number in it by one, you would do the following:

```lisp
(each list 
    (print (+ @ 1)))
```

This is the most basic (**and recommended**) form of list iteration.

## `while`

While is the [de-facto](https://en.wikipedia.org/wiki/De_facto), tried and true method of iteration no matter how big or small the task!

The `while` keyword works like it would in any other language, a clause & a body.

This adds a variable until it is the number `10`.

```lisp
(while (< variable 10)
    (set variable (+ variable 1)))
```

## `until`

!!! note
    The until keyword has not been publicly released yet and is a part of the SLisp `31` release. To use it you must compile
    the 31 build yourself. Please see [building Salmon (dead link)]() for tips.

The `until` keyword runs a block of code until the clause becomes true.

It's useful for creating loops and could be considered the super-standard **`for`-loop** of modern SLisp. 

Here's a quick example of the `until` loop in action:

```lisp
(set a 0)

(until (> a 5)
    (set a (+ a 1)))
```

## Classic

!!! danger
    The classic method is not as memory-safe as the other functions, and besides, they are built for this life! Use the newer, more
    modern functions to accomplish your iteration tasks.

The **classic** method of iteration, that could also be defined as recursion is a method of checking a variable inside of a function and running the function again.

Example:

```lisp
(defun is_x_5 ()
    (case (not x 5)
        (progn
            (set x (+ x 1))
            (is_x_5))
        (print "Done! X is 5!")))
```
