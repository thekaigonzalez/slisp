(defun evaluate_path (p)
  (case (not 
    (probe-file p) true)
      (return "not a path")
      (return "is a path")))

(print (evaluate_path ".123"))