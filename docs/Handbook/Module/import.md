# What is `import`?

Import is the `require` of modern SLisp, (*"modern" meaning any updates after 25*)

`require`'s been around since the dawn of SLisp. Now that's something.

But we over at SLisp thought it was about time for a little change.

Everybody, welcome `import`!

## So, what's the difference?

Essentially none, well, not a huge difference.

To kick of the "maJoR" differences, **`import` is not a hard-coded function.**
Meaning it's not a part of the base parser, and you could even run SLisp without it!

It's easy to understand and you don't even need to dig deep into the parser's code to get it.
That's all a part of the SLisp nature!

Now obviously, it's still in beta, some things like errors or platform compilation are not available, so currently some platforms other than Linux may have trouble building it.

But don't fret! Patches are underway!

Other than that, there's a custom path variable created for the function, it is a `list` type, so
any manipulation must be done on [list-safe](../Type_Safety.md) functions.

## How do I use it?

Like the `require` function:

```lisp
(import "filename.asd")
```

**But better**.

```lisp
(set path (append path "my/include/dir"))

(import "fileFromIncludeDir.asd")
```

## Supported Paths

Well will `import`, the sky's really the limit!

Default paths:

- `./libs/*.(asd|so)`
- `/usr/local/lib/salmon/libs/*.(asd|so)`
- `./*.(asd|so)`
