; Different types of print

; 'print' will print a line to stdout.
(print "hello, world!")

; Does the same as `print`.
(println "hello, world!")

; Print formatted output, similar to Python's .format function.
(printf "hello, {}!" "world")

; Write a raw line to stdout. This does not add newlines.
(write-line "hello, world!\n")