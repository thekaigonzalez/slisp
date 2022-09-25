(defun bog-fib (n)
  (case (> n 2)
    (return 1)
    (return (+ 
              (fib (- n 1)) 
              (fib (- n 2))))))

(print (bog-fib 5))
