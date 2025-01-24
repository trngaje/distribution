#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

set_kill set "-9 drastic"

#load gptokeyb support files
control-gen_init.sh
source /storage/.config/gptokeyb/control.ini
get_controls

if echo "${UI_SERVICE}" | grep "sway"; then
    /usr/bin/drastic_sense.sh &
fi

cd /storage/advanced_drastic

./launch.sh "$1"

if echo "${UI_SERVICE}" | grep "sway"; then
    kill -9 $(pidof drastic_sense.sh)
fi
