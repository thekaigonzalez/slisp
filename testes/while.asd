(let m 0)
(while (not (access m) 100)
                (let m (+ (access m) 1))
                    (print (access m)))