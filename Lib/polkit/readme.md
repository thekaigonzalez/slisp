<!--
 Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
 Use of this source code is governed by a BSD-style
 license that can be found in the LICENSE file.
-->

# Polkit for SLisp

A library where you can use `pkexec` to elevate programs.

```lisp
(import "polkit")

(polkit:elevate "touch /test")
```