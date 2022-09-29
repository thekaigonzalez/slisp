(defun less (list1) 
  (set smallest (position list1 0))
  (set list1 (truncate list1 1 *)) ; truncate the list so it's the second element => the end
  (set iterator 0)
  (print (- (length list1))))

(less (list 1 2 3))
