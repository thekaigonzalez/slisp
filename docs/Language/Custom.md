# Creating a custom SalmonLisp interface

Recently, SLisp was separated from the main file, meaning that now you can include the interpreter file (& the *APIs*) and create your own SLisp interface!

## Requirements

- x86_64 Architecture (Any other architecture will not receive binary updates, you must compile from source)
- Same-versioned interpreter & API. (can not be version 27 API and 30 interpreter)
- Latest ABI
- One night of lemon desserts & optionally [music.](https://open.spotify.com/playlist/105X14IvryZHZjqT5zK8tm?si=0bf48127bde94f36)

## Including the interpreter

To include the interpreter file, once you have it in your path somehow, just include it like so:

```dlang
import salinterp;
```

**And it's helpers.**

```dlang
import sal_auxlib;
import sal_shared_api;
```

Now you have all of the functions you need.

Let's test!

## The SLisp Structure

To run code, there first needs to be an **environment**.

"What's that?" -- You may ask, I will explain it to you!

The "environment" (named `SalmonEnvironment` in the API), contains the "lexical" aspect of SLisp.

So everything from **functions**, to **variables**, to **definitions**, it's all there.

So to begin, you would first need to create your environment, like so:

```dlang
SalmonEnvironment environment = new SalmonEnvironment();
```

Perfect! You have created your first Salmon environment!

You can customize the settings of your environment, but this guide does not go over that yet.

## Running Code

Before you can run the code, you must first add a **Salmon state.**

What are Salmon states?

There are essentially... Blocks of code.

Say in JavaScript, you have this piece of code:

```js
console.log("hello,");

{
  let str = "world"
  console.log(str);
}
```

When running it, it will print:

```
hello,
world
```

Like expected.

This is similar to how it would work in SLisp:

```lisp
(print "hello,")

(progn
  (set str "world")
  (print str))
```

When `progn` runs, it will create a new state to run the code passed into it,
in this case it's `(set str "world") (print str)`

It copies the current environment (as a SEPARATELY `mutable` environment) using the `SalmonEnvironment.copy()` function.

Which means all changes to that state's environment will not dirty the root environment.
