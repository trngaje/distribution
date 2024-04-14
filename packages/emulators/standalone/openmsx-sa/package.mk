# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present trngaje (https://github.com/trngaje)

PKG_NAME="openmsx-sa"

PKG_VERSION="19"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/openMSX/openMSX"
#PKG_URL="$PKG_SITE.git"
#https://github.com/openMSX/openMSX/releases/download/RELEASE_19_1/openmsx-19.1.tar.gz
PKG_URL="$PKG_SITE/releases/download/RELEASE_${PKG_VERSION}_${PKG_REV}/openmsx-${PKG_VERSION}.${PKG_REV}.tar.gz"
PKG_DEPENDS_TARGET="toolchain   zlib SDL2 SDL2_ttf libpng tcl freetype libtheora evdevd"

PKG_SHORTDESC="openMSX - the MSX emulator that aims for perfection"
PKG_LONGDESC="openMSX - the MSX emulator that aims for perfection"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
PKG_TOOLCHAIN="manual"

PKG_MESON_OPTS_TARGET+="  -Dalsamidi=enabled -Dlaserdisc=disabled"
PKG_DEPENDS_TARGET+=" alsa-lib libogg libvorbis"

if [ ! "${OPENGL}" = "no" ]; then 
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd" 
fi 

if [ "${OPENGLES_SUPPORT}" = yes ]; then 
  PKG_DEPENDS_TARGET+=" ${OPENGLES}" 
fi 

export GCC_FOR_BUILD="${CC}"
export CROSS_COMPILE="${SYSROOT_PREFIX}/usr/bin/"
export PREFIX="${SYSROOT_PREFIX}"
export TCL_CONFIG="${SYSROOT_PREFIX}/usr/lib"
export LD_FOR_BUILD="${LD}"

make_target() {
  cp ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh.bak
  sed -i "s@TCL_LIB_SPEC='-L/usr/lib -ltcl8.6'@TCL_LIB_SPEC='-L${SYSROOT_PREFIX}/usr/lib -ltcl8.6'@" ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh
  sed -i "s@TCL_INCLUDE_SPEC='-I/usr/include'@TCL_INCLUDE_SPEC='-I${SYSROOT_PREFIX}/usr/include'@" ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh

  echo "STRIP=$STRIP"
  echo "CC=$CC"
  echo "CXX=$CXX"
  echo "CFLAGS=$CFLAGS"
  echo "CXXFLAGS=$CXXFLAGS"
  echo "LDFLAGS=$LDFLAGS"

  sed -i "s@SYMLINK_FOR_BINARY:=true@SYMLINK_FOR_BINARY:=false@" ${PKG_BUILD}/build/custom.mk
  sed -i "s@INSTALL_BASE:=/opt/openMSX@INSTALL_BASE:=${INSTALL}/usr/share/openmsx@" ${PKG_BUILD}/build/custom.mk
  echo "INSTALL_DOC_DIR:=${INSTALL}/usr/share/doc/openmsx" >> ${PKG_BUILD}/build/custom.mk
  echo "INSTALL_SHARE_DIR:=${INSTALL}/usr/share/openmsx" >> ${PKG_BUILD}/build/custom.mk
  echo "INSTALL_BINARY_DIR:=${INSTALL}/usr/bin" >> ${PKG_BUILD}/build/custom.mk

  export COMPILER=${CXX}
  cd $PKG_BUILD
  export MAKE=make

  export GCC_FOR_BUILD="${CC}"
  export CROSS_COMPILE="${SYSROOT_PREFIX}/usr/bin/"
  export TCL_CONFIG="${SYSROOT_PREFIX}/usr/lib"

  export OPENMSX_TARGET_CPU="aarch64"
  export OPENMSX_TARGET_OS="linux"

  sed -i "s@libpng-config@${SYSROOT_PREFIX}/usr/bin/libpng-config@" ${PKG_BUILD}/build/libraries.py
  sed -i "s@sdl2-config@${SYSROOT_PREFIX}/usr/bin/sdl2-config@" ${PKG_BUILD}/build/libraries.py

  ./configure
   GCC_FOR_BUILD="${CC}"  CROSS_COMPILE="${SYSROOT_PREFIX}/usr/bin/"  TCL_CONFIG="${SYSROOT_PREFIX}/usr/lib"  make -C ${PKG_BUILD} install
}

post_make_target() {
  echo "PKG_BUILD=$PKG_BUILD"
  echo "TARGET_NAME=$TARGET_NAME"
  echo "INSTALL=$INSTALL"

  mv -f ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh.bak ${SYSROOT_PREFIX}/usr/lib/tclConfig.sh

#CFLAGS=$OLDCFLAGS
  mkdir -p $INSTALL/usr/share/openmsx/
  cp $PKG_DIR/share/openMSX_config.tar.gz $INSTALL/usr/share/openmsx/
  mkdir -p $INSTALL/usr/bin
  cp $PKG_DIR/scripts/start_openmsx.sh $INSTALL/usr/bin/
  chmod +x $INSTALL/usr/bin/start_openmsx.sh
}
