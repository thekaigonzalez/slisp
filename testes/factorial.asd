(defun factorial (n)
    (case (= n 0)
        1
        (* (factorial (- n 1)) n)
    )
)

(set i 0)

(until (= i 16)
    (progn
        (print (factorial i))
        (set i (+ i 1))
    )
)