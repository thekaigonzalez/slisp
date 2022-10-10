(print "Enter a word below.")

(set words (list
                "hello"
                "world"))

(set word (string-trim (read-line)))

(defun most_similar (n)
    (set similarest nil)

    (each words
        (progn
            (if (= similarest nil) (set similarest @))
            
            (if (< (distance n @)
                    (distance similarest @))
                (set similarest @))))
    (return similarest))

(case (= (most_similar word) nil)
    (print "Your word isn't similar to anything!")
    (print "Your word is most similar to: " (most_similar word)))