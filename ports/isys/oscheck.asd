; "it feels great to not have to use the ';' operator on every comment"
; well that's what happens when you make a trash programming language

(print (get compiler_system))

(case (= (string-trim (get compiler_system)) "Linux")
  (print "hello")
  (print "bye"))
