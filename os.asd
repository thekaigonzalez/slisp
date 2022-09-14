(require "os")

(let gcc_status (sys "gcc --version"))
(let gcc_version (osys "gcc --version"))

(print "GCC version: " (access gcc_version))
