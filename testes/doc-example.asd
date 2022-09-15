(set i 0)

; while <i> not 100, append <1>
(while (not (get i) 100)
        (set i (+ (get i) 1))
          (print (get i)))
