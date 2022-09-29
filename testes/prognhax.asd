; ; Wrong!
; (case (= 1 1)
;   (print "hello")
;   (print "world"))

;only prints "hello"

(case (= 1 1)
  (progn
    (print "hello")
    (print "world"))
  nil)