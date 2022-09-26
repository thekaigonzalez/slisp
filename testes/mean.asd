(defun mean (listofnumbers)
  (set sumOfDataPoints 0)
  (set noOfDataPoints (length listofnumbers))
  
  (set iter 0)
  
  (while (< iter (length listofnumbers))
    (set sumOfDataPoints (+ sumOfDataPoints (position listofnumbers iter)))
    (set iter (+ iter 1)))
    
  (return (/ sumOfDataPoints noOfDataPoints)))

(print (mean (list 4 1 3 12 4 2 6)))