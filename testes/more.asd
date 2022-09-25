(defun less (list1)
  ; Variables
  (set smallest (position list1 0))
  (set list1 (truncate list1 1 *)) ; truncate the list so it's the second element => the end
  (set iterator 0)

  ; Iterate the list
  ; (each wasn't doing the job good enough)
  (while (< iterator (- (length list1) 1)) ; [list length] - 1 to prevent range error
    ; Add new iterator 
    (set iterator (+ iterator 1))

    ; If the current object in the list is smaller than the last object, set that one
    ; to the new smallest.
    ; Kind of like a leadership algorithm
    ; (to make this a greater algorithm just set the `<` to `>`)
    (if (> (position list1 iterator) smallest)
        (set smallest (position list1 iterator))))

  (return smallest))

(print (less (list 1 2 3 4 5 6 7 8 0))) ; 0