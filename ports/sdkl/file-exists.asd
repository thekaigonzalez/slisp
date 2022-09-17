(defun evaluate_path (p)
  (ecase (not 
    (probe-file (get p)) true)
      (return "not a path")
      (return "is a path")))

(print (evaluate_path "./"))