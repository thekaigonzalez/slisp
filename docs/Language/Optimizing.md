# Optimizing your program

The default times should be good enough (technically speaking), but here are some tips
to optimize your program!

## Redundancy

Sometimes you will have redundant code (or duplicates). Example:

```lisp
(set i 1)
(set i 1)
```

That will slow down code depending on how many times you call code twice. You may not get the performance you are looking for.

## Multithreading

If you want to improve your algorithm performance, you could use the safe threading functions.

```lisp
(&thread (while ...
```

## Looping

There are two ways to iterate a list, the implemented way, and the 'workaround' method.

**Implemented**:

```lisp
(list m 1 2 3 4)
(each m (print (get *)))
```

**Workaround Method**:

```lisp
(list m 1 2 3 4)

(set i 0)

(while (< (get i) (length m))
  (set i (+ (get i) 1))
    (print (get i)))
```
