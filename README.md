<div align="center">
  <img src="SLispLogo.png" alt="Salmon Logo">
</div>

## NOTE: After installation (Unix)

To use the library, you must symlink it.

```sh
$ (sudo) ln /usr/local/lib/libsalmon.so /usr/lib/libsalmon.so -s
```

# SLisp Sources

This is the source repository for the official SalmonLisp repository.

## What is SLisp?

SLisp (long form, SalmonLisp) is a Lisp (or Common Lisp) implementation which focuses on readability, portability, and extensibility.

It uses features from many different standard Lisp implementations such as AutoLisp, NewLisp, and Steel Banks Common Lisp.

## Build

```bash
$ meson builddir
$ [sudo] ninja -C builddir install
```
