(defun giveOne (param)
    (case (= param 1)
        0
        (panic! (istrcat "expected 1. Got `" param "'"))
    )
)

(giveOne 2)