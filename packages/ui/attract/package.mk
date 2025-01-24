# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present trngaje (https://github.com/trngaje)

PKG_NAME="attract"
PKG_VERSION="bee423356a0c76bdd06ef7d541a25125cfe40ac4"

PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="ATTRACT"
PKG_SITE="https://github.com/mickelson/attract"
PKG_URL="$PKG_SITE.git"
PKG_SOURCE_DIR="attract-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain flac libogg libvorbis openal-soft libjpeg-turbo freetype systemd sfml runcommand ffmpeg"

PKG_SHORTDESC="Attract-Mode is a graphical frontend for command line emulators"
PKG_LONGDESC="Attract-Mode is a graphical frontend for command line emulators"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+pic"

if [ "${OPENGLES_SUPPORT}" = yes ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  echo "OPENGLES_SUPPORT is yes"
fi

if [ ! "${OPENGL}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu libglvnd"
  export GLES="USE_GLES=0"
  echo "OPENGL is not no"
fi

make_target() {
  sed -i "s|CC=gcc|CC=$CC|" "$PKG_BUILD/Makefile"
  sed -i "s|CXX=g++|CXX=$CXX|" "$PKG_BUILD/Makefile"
  sed -i "s|STRIP=strip|STRIP=$STRIP|" "$PKG_BUILD/Makefile"
  sed -i "s|-lGLESv1_CM|-lGLESv2|" "$PKG_BUILD/Makefile"

  echo "STRIP=$STRIP"
  echo "CC=$CC"
  echo "CXX=$CXX"

#USE_GLES=1
  make -j4 USE_DRM=1 EXTRA_CFLAGS="-L${SYSROOT_PREFIX}/usr/lib $CFLAGS"
}

makeinstall_target() {
 : not
}


post_make_target() {
  echo "PKG_BUILD=$PKG_BUILD"
  echo "TARGET_NAME=$TARGET_NAME"
  echo "INSTALL=$INSTALL"

  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/attract $INSTALL/usr/bin/
  cp $PKG_DIR/attract.sh $INSTALL/usr/bin/
  chmod a+x $INSTALL/usr/bin/attract.sh
  
  mkdir -p $INSTALL/usr/share/fonts/truetype
  cp $PKG_DIR/font/* $INSTALL/usr/share/fonts/truetype/

  mkdir -p $INSTALL/usr/share/attract
  cp -r $PKG_DIR/tar/* $INSTALL/usr/share/attract

  cp ${PKG_BUILD}/start_attractmode.sh ${INSTALL}/usr/bin
  cp ${PKG_BUILD}/start_frontend.sh ${INSTALL}/usr/bin
  chmod 0755 ${INSTALL}/usr/bin/start_attractmode.sh
  chmod 0755 ${INSTALL}/usr/bin/start_frontend.sh
  
  CFLAGS=$OLDCFLAGS
}

