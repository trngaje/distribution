# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="advanced_drastic-sa"
PKG_VERSION="3348ee066401fb76d1a0a0ca9b03a3bc58f91c42"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/trngaje/advanced_drastic"
PKG_URL="$PKG_SITE.git"

PKG_DEPENDS_TARGET="toolchain sdl2_drastic drastic_layout"
PKG_LONGDESC="Advanced Drastic"
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="git"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
  cp -rf ${PKG_DIR}/scripts/* ${INSTALL}/usr/bin
  chmod +x ${INSTALL}/usr/bin/start_advanced_drastic.sh

  mkdir -p ${INSTALL}/usr/share/advanced_drastic
  cp -rf ${PKG_BUILD}/* ${INSTALL}/usr/share/advanced_drastic/
}


