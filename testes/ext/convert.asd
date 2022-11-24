(defun convertstringtointeger (int-str)
    (compile int-str))

(print (+ (convertstringtointeger "1") (convertstringtointeger "2")))