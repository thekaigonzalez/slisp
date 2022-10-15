(set a 0)
(set scoped_var "hello")

(with scoped_var
    (progn
        (print "Hello")
        (case (= a 4)
            (set scoped_var nil)
            (set a (+ a 1)))))