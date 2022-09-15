(set m 0)
(while (not (get m) 100)
                (set m (+ (get m) 1))
                    (print (get m)))