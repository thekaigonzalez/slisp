# Basic "Hello World" program

To program in lisp, you must first understand how it works.

When talking about Lisp, you can't just say "Oh I'm programming in Lisp!"

Your colleague would ask, "which one?"

**And that's how it happens**.

## Understanding the deep family tree

There's many different dialects of Lisp, a few for example are [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)), [Racket](https://racket-lang.org/), and [Common Lisp](https://lisp-lang.org/).

Some Lisp dialects implement custom features, some don't, some have specific purposes, others are for general scripting 
programming purposes. A great example is **Common Lisp** and **AutoLISP**. AutoLISP is a Lisp dialect which is for use with the AutoCAD software, while **Common Lisp** was designed for well-- common things.

There are many different Lisp implementations with their different standard libraries, and SalmonLisp is no different!

Except, SLisp has it all!

What SalmonLisp tries to do is be as compatible with **every Lisp implementation**, as well as all of the programming languages I've designed.

## The Standard Library

Currently the standard library documentation is under construction, so there's no real documentation yet, but all you'll need to know for now is the `print` function!

Here's the documentation for the print function:

```lisp
(defun #dlang print (arg...))

  Prints the arguments concatenated.

Example:

  (print "Hello, " "World!") ; Prints "Hello, World!"
```

## Syntax

Symbolic expressions follow this format:

```
(func args)
```

## The Code

So, to print "hello world", create a file called `helloWorld.asd` (learn about the adopted file extension [here.](../Tech/File_Extension.md))

Then, write the following:

```commonlisp
(print "Hello, world!")
```

Simple! Run the program and you're gonna get `Hello, world!`
