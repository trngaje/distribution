# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2022-present JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="drastic_layout"
PKG_VERSION="3fb9aa23b95e7022dcfadface457f2f35e12405d"
PKG_ARCH="aarch64"
PKG_SITE="https://github.com/trngaje/drastic_layout"
PKG_URL="$PKG_SITE.git"

PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="layout for Advanced Drastic"
PKG_TOOLCHAIN="manual"
GET_HANDLER_SUPPORT="git"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/advanced_drastic/resources
  cp -rf ${PKG_BUILD}/* ${INSTALL}/usr/share/advanced_drastic/resources/
}


