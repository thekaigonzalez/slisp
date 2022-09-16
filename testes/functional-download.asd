(require "curl")

(defun download-site (sitename)
  (print "Downloading site " siteName)
    (trim (download (get sitename))))

(print (download-site "https://example.com"))