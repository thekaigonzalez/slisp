(set to_type nil)

(set type (type-of to_type))

(case (= type "number")
  (print "Is number")
  (case (= type "str")
    (print "Is string")
    (print "another type: " type)))
