(defun polkit:elevate (command)
    (sys:run (istrcat "pkexec " command)))