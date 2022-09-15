# Salmon Parser

Salmon uses a [recursive descent] parser for tokenizing statements.

Take the following example:

```lisp
(print "Hello!")
```

You may be thinking, *"This could be simplified"*... Well it's an example program so..
Take that.

Anyway, the reason this format was chosen is to show you how the parser breaks down a statement.

First of all we need a root function, in that case it's `print`.

So far the parser knows:

```lisp
root function: print
```

Then after it continues reading on, it'll start to understand your parameters.

## Values

Values are mainly parsed by the builtin functions, instead of the parser, so the values
are returned as they are without modification.

## Nested Statements

Nested statements, however, are parsed differently using a method called recursion.

It will read the parenthesis one time and continue to match them with every parameter.

Here's a more complex example:

```lisp
(set i 0)

; while <i> not 100, append <1>
(while (not (get i) 100)
        (set i (+ (get i) 1))
          (print (get i)))
```

As you can see, it utilizes nested statements to provide an effect similar to a `for loop`.

Specifically this statement:

```lisp
(while (not (get i) 100)
        (set i (+ (get i) 1))
          (print (get i)))
```

If you want to know what it's paremeters would be, here's a rough draft.

```

params: [
  while;
  (not (get i) 100);
  (set i (+ (get i) 1));
  (print (get i));
]

```

As you can see, it's matching is correct, and what it will do is check if the parameter's a nested statement, if it is, it will
do the same operation on the root, on that statement, BUT INSTEAD, it will return it's value.

This is the default logic in the REPL however, that's why it will return a value in the repl, but instead of not doing anything, it will show it.
