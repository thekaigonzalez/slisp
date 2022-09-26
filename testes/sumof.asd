(defun sumof (nums)
  (set sum 0)
  
  (each nums (set sum (+ sum @)))
  
  (return sum))

(print (sumof (list 1 2 3 4)))