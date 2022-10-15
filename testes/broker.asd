(defun runtime_test ()
    (case (not 1 1)
        0
        (panic! "One not one")))

(runtime_test)