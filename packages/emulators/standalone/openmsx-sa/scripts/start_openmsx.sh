#!/bin/bash

. /etc/profile

set_kill set "-9 openmsx"

#copy advance files to .advance
if [ ! -d "/storage/.openMSX" ]; then
  tar -xvzf /usr/share/openmsx/openMSX_config.tar.gz -C /storage/
fi

evdevd -g -s &

openmsx -script "/storage/.openMSX/commands.txt" "$1"

kill -9 $(pidof evdevd)
