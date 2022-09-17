# Salmon VS SDKL

My two most functional programming languages. Let's see how they compare!

## Iterating a list

### Salmon

```lisp
(list y 1 2 3 4 5 6 7 8)

(each y
  (print (* 2 (get *))))
```

### SDKL

```lua
local y = {1,2,3,4,5,6,7,8}

for i = 1, #y do
  print(y[i]*2)
end
```

## Hello, world

### SDKL

```lua
print("Hello, world!")
```

### Salmon

```lisp
(print "Hello, world!")
```

## Assert

### SDKL

```lua
assert(1 ~= 1)
```

### Salmon

```lisp
(assert (not (= 1 1)))
```
