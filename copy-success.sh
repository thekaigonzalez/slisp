# Copyright 2022 Kai Daniel Gonzalez. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Copy the library

sudo cp /usr/local/lib64/libsalmon.so /lib/libsalmon.so >/dev/null || echo "Couldn't find lib64, trying lib"
sudo cp /usr/local/lib/libsalmon.so /lib/libsalmon.so >/dev/null || echo "Could not find lib"