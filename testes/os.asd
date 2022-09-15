(require "os")

(set gcc_status (sys "gcc --version"))
(set gcc_version (osys "gcc --version"))

(print "GCC version: " (get gcc_version))
