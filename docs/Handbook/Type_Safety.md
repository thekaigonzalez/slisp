# Type Safety, what about it?

The biggest issues with interpreted programming languages in production environments is the lack of **type safety**.

For example, in *Python*, if you try to create a function without taking the different types into consideration:

```py
def addThis(number):
  return number + 1
```

If you ran `addThis(1)`, it would return `2`. As you would expect.

But, if you instead ran it with a `string`, instead of an integer, you would get the following error:

```py
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "<stdin>", line 1, in addThis
TypeError: can only concatenate str (not "int") to str
```

The more recent versions of Python fix this by adding **type checking**.

```py
def addThis(number: int):
  return number + 1
```

Overall a happier experience!

## So what about SLisp?

You can kind of fake this type safety by using the `type-of` function:

```lisp

(defun myfunc...

    (case (= (type-of n) "number")

      (return "No")
      (print "Hello!")
```