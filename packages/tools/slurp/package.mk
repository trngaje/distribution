# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present trngaje (https://github.com/trngaje)

PKG_NAME="slurp"
PKG_VERSION="1.5.0"
#PKG_SHA256="a63b2df8722ee595695a0ec6c84bf29a055a9767e63d8e4c07ff568cb6ee0b51"
PKG_LICENSE="MIT"

#https://github.com/emersion/slurp/releases/download/v1.5.0/slurp-1.5.0.tar.gz
PKG_SITE="https://github.com/emersion/slurp/"
PKG_URL="https://github.com/emersion/slurp/releases/download/v${PKG_VERSION}/slurp-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain wayland cairo libxkbcommon"
PKG_LONGDESC="Select a region in a Wayland compositor and print it to the standard output. Works well with grim."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET=""

#pre_configure_target() {
  # sway does not build without -Wno flags as all warnings being treated as errors
 # export TARGET_CFLAGS=$(echo "${TARGET_CFLAGS} -Wno-unused-variable")
#}



