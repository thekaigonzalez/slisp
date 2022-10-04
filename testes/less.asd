(defun less (list)
  (set smallest-so-far nil)
  (each list
    (progn
      (if (= smallest-so-far nil)
        (set smallest-so-far @)))
    (if (< smallest-so-far @)
      (set smallest-so-far @)))
  (return smallest-so-far))


(print (less (list 2 1 2 3 4)))