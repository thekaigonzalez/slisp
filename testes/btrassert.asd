(defun new_assert (n)
    (case (= n true)
        0
        (panic! "Assertion failed\n\twhat: n != true")
    )
)

(new_assert false)