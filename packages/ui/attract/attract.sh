#!/usr/bin/bash
source /etc/profile
set_kill set "-9 attract"

if [ ! -d "/storage/.attract" ]; then
  tar -xvzf /usr/share/attract/attract.tar.gz -C /storage/
fi

if [ ! -d "/storage/runcommand" ]; then
  tar -xvzf /usr/share/attract/runcommand.tar.gz -C /storage/
fi

attract
