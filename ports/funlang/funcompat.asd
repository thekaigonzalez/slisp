; FUNCOMPAT.asd
; contains functions to aid in fun ports.

(defun add (o, n)
  (print (+ (get o) (get n))))
