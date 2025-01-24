#!/bin/bash
. /etc/profile

START_BOOT_UI=$(get_setting boot)

if [ "${START_BOOT_UI}" == "AttractMode" ]; then
  start_attractmode.sh
elif [ "${START_BOOT_UI}" == "AdvMenu" ]; then
  start_advmenu.sh
else
  start_es.sh
fi
