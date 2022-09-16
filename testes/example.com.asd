(require "curl")

(set example.com.contents (download "https://example.com"))

(print (trim (get example.com.contents)))