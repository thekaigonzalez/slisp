<!--
 Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
 Use of this source code is governed by a BSD-style
 license that can be found in the LICENSE file.
-->

# Frequently Asked Questions

## I see this doesn't use a traditional parsing method, is it stable?

This is a common question for those beginning to get into open source and would like to contribute,
**yes. It is very much stable.** The parser may look a bit off for a newcomer, but if you look deeper into it you will understand the logic behind it in a less-confused and more productive manner.

!!! note
    And if you don't want to believe me, then let the facts speak for themselves:

    - **Salmon Lisp can run one million lines of code at the exact speed as the COMPILER OPTIMIZED SBCL.**
    - Near native overhead with high-level scripting
    - A bunch of features packed into the tiny binary that SLisp is.

## If this is a language primarily for Scripting, where's `cdr` & `car`?

There's no such thing as `cons` or any sort of memory addresses in SLisp, instead
it's a generic standard and a generic simplified approach to the Lisp & Common Lisp libraries.

There's a somewhat working implementation of `cdr` and `car` in the Standard Library. But it's not what you'd expect.

```lisp
(set a (list 1 2))

(print (car a)) ; 1
(print (cdr a)) ; 2
(print (+ (cdr a) 1))
```

## How is SLisp "less rigid" than something like SBCL?

While this may be a stretch, it's all in the handling.

With SBCL, if you tried to print "hello, world", the output will literally be "hello world":

```lisp
(print "hello")
; output:
; <whitespace>
; "hello"
```

It's a bit strange, but due to the native performance SBCL gives you, it's a small tradeoff.

But this is unlike SLisp, it will just print "hello" and do exactly what you want it to.
