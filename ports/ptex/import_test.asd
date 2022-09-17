(print "this will run the files. I guess")
(print "we're gonna include the curl library")

(require "curl")

; now lets use it.

(set example (download "https://example.com"))

(print (get example))