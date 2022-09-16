; Increment variable by 1
(defun increment (var)
  (set (get var) 1))

(set i 0)

(print (get i))

(increment i)

(print (get i))