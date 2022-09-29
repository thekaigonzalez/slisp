(import "testes/less.asd")

(set n (list 1 2 3 4))

(set q (list 2 4 6))

(set a (merge n q))

(set a (less a))

(print (concatenate a))
