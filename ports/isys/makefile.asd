; "makefile" editing

(case (= (get compiler_system) "Windows")
  (print "You should be using MINGW.")
    (print "Don't know."))