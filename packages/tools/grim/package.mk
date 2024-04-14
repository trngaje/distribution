# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2024-present trngaje (https://github.com/trngaje)

PKG_NAME="grim"
PKG_VERSION="1.4.1"
#PKG_SHA256="a63b2df8722ee595695a0ec6c84bf29a055a9767e63d8e4c07ff568cb6ee0b51"
PKG_LICENSE="MIT"
#https://git.sr.ht/~emersion/grim/refs/download/v1.4.1/grim-1.4.1.tar.gz
PKG_SITE="https://git.sr.ht/~emersion/grim"
PKG_URL="https://git.sr.ht/~emersion/grim/refs/download/v${PKG_VERSION}/grim-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain wayland  libjpeg-turbo pixman libpng"
PKG_LONGDESC="Grab images from a Wayland compositor. Works great with slurp and with sway."
PKG_TOOLCHAIN="meson"

PKG_MESON_OPTS_TARGET=""

pre_configure_target() {
  # sway does not build without -Wno flags as all warnings being treated as errors
 export TARGET_CFLAGS=$(echo "${TARGET_CFLAGS} -Wno-unused-variable")
}



