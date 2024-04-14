# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present trngaje (https://github.com/trngaje) 

PKG_NAME="tcl"

PKG_VERSION="8.6"
PKG_REV="12"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://prdownloads.sourceforge.net/tcl"
PKG_URL="${PKG_SITE}/tcl${PKG_VERSION}.${PKG_REV}-src.tar.gz"
#wget https://prdownloads.sourceforge.net/tcl/tcl8.6.12-src.tar.gz
PKG_DEPENDS_TARGET="toolchain"

PKG_SHORTDESC="Tcl provides a powerful platform for creating integration applications"
PKG_LONGDESC="Tcl provides a powerful platform for creating integration applications that tie together diverse applications, protocols, devices, and frameworks."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"

make_target() {
  cd ${PKG_BUILD}/unix

  ./configure --disable-symbols --disable-langinfo  \
    --disable-framework --prefix=${SYSROOT_PREFIX}/usr \
    --host=${TARGET_NAME}

  make install
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib
  cp ${PKG_BUILD}/unix/libtcl*.so ${INSTALL}/usr/lib/
}
