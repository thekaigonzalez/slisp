(set m true)

; Ok so my error was,
; I forgot that it evaluates it and just using variables isn't supported behavior
; Fooled by my own mechanic!
(if (get m) (print "hello,")
              (print "world!"))
