# Parsable - Salmon Types

Parsable is a basic string which is parsed to be indexed.

> *This type currently creates a bug, where you can use a **string** to create a string value.*
> *Please just **try..** Not to use strings for integers, as it's against the standard code style.*

## Mutation

```lisp
; "Parsable" currently does not support a list.
(list test-list 1 2 3 4 5)

; But, parsable does support numbers!
; Only for functions that implement Parsable.
; Just about the entire standard.
(require "math")

; "3" is used without quotation marks, but can be used with them due to the 
; Dynamic & Extensive nature of Salmon.
(sin 3)
(sin "3")
```