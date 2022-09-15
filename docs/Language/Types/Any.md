# Any - Salmon Types

> ***Any*** *is not to be confused with*
> *the [Parsable](./Parsable.md) type, as they are different definitions.*

**Any** defines a type which can be mutated into anything.

The **Any** spec implements [Parsable](Parsable.md), one of it's ancestors.

## Mutation

```lisp
; you can't really "define" "ANY", it comes naturally.
; If you want to add a number, when you pass integers, or, so-call them,
; They're actually going to be strings. The types are figured out by the function whenever
; They are needed. This is called "Lazy Evaluation".
(+ 1 1)
; + "1" "1"
; Logic:
;   Cast arguments 1 and 2 to integer
```