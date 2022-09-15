; Now we can create another list

(require "math")

(list list-one 1 2 3 4 5)
(list list-two 2 4 6)

(intersection list-one list-two list-three) ; (list-three) is created at runtime

(each list-three
              (print 
                  (access *)))
