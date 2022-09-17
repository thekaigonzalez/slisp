#!/bin/bash

dialog --title "Salmon Standard Library Installation" --yesno "Would you like to install the standard library?" 5 80

case $? in
  0)
    echo "Compiling the standard library...";;
  1)
    echo "exiting...";
    exit;;
esac

make -C std-src -j12
make -C std-src install -j12
