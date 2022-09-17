; Code to append data to variable using
; The standard library functions

(set one 1)

(defun println (msg)
  (print (get msg)))

(println (strcat "Variable before mutation: " (get one)))

; Define two
(set two 2)

; we can skip the 'tostr()' since dynamic
(defun mutate ()
  (set two_s (strcat (get two) (get one))))

(mutate)

(println (strcat "Variable one after mutation: " (get one)))

; This code's a bit of a boilerplate, so it may not make sense
(set t_two (* (get one) 2))

(println (strcat "Multiplied: " (get t_two)))

; println(twelve)
