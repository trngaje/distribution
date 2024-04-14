#!/bin/bash

. /etc/profile

set_kill set "-9 advmame"

#copy advance files to .advance
if [ ! -d "/storage/.advance" ]; then
  mkdir -p /storage/.advance
  cp -r /usr/share/advance/* /storage/.advance/
fi

if [ ! -d "/storage/runcommand" ]; then
  tar -xvzf /usr/share/runcommand/runcommand.tar.gz -C /storage/
  chmod a+x /storage/runcommand/runcommand.sh
fi

advmame.sh "$1"
