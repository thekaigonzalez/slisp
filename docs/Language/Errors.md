# Salmon Errors

Salmon Errors were designed to be easy-to-read and useful for the programmer. Here are some things to note about them.

## Format

The error format follows this:

```lisp
[filename]:[line]: [Error Description]
[potential note]: [where you went wrong]
[showing code]
  [line number] | [bad-code]
```

## What They Mean

They will give you tips incase you forget basic principles, we all do at some point!

### `type` can not be converted to `boolean`

This will happen (only with while loops in Salmon 26)

If you try to use a condition which doesn't convert to a `boolean` value, it gives an error.

```r
testes/while.asd:5: error: Type `str`, expected `boolean`.
testes/while.asd:5: note: Does the statement `"hello"' return a `true/false` value?
```