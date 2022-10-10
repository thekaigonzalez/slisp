(print "Enter 'hi'")

(set input (read-line))

(until (= input "hi")
    (progn
        (print "I said, enter 'hi'!")
        (set input (read-line))))

(print "Thanks!")