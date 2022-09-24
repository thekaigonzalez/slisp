(set acartifact "new")

(set newfact (case (= acartifact "new")
    (return true)
    (return 0)))

(print newfact)