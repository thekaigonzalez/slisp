(require "ports/funlang/funcompat.asd")

(defun main ()
  (make2))

(defun umain ()
  (print "hello world!")
    (print "goodbye")
      (tunnel))

(defun tunnel ()
  (print "Going through")
    (print "The magical tunnel!"))

(defun make2 ()
  (print "Hello again.")
    (umain))

(main)