# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present trngaje (https://github.com/trngaje)

PKG_NAME="runcommand"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="runcommand for advmenu and attractmode"
PKG_TOOLCHAIN="manual"


makeinstall_target() {
  mkdir -p $INSTALL/usr/share/runcommand
  cp -r $PKG_DIR/*.tar.gz $INSTALL/usr/share/runcommand
}
