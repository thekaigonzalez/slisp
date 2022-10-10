(defun bog-fib (n)
  (case (> n 2)
    (return 1)
    (return (+ 
              (bog-fib (- n 1)) 
              (bog-fib (- n 2))))))

(print (bog-fib 150))
