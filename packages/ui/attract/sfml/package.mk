# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="sfml"

PKG_VERSION="754ed8fee142276608043cc08ba6fe92da5355a6"


PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="SFML"

PKG_SITE="https://github.com/mickelson/sfml-pi"

PKG_URL="$PKG_SITE.git"
PKG_SOURCE_DIR="sfml-$PKG_VERSION*"

#gbm
PKG_DEPENDS_TARGET="toolchain flac libogg libvorbis openal-soft libjpeg-turbo freetype systemd libdrm ${OPENGLES}"

#PKG_SECTION="emuelec/mod"
PKG_SHORTDESC="SFML on the odroid go advance with hardware graphics and no X11 dependency."
PKG_LONGDESC="SFML on the odroid go advance with hardware graphics and no X11 dependency."
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="cmake-make"
PKG_BUILD_FLAGS="+pic"


PKG_CMAKE_OPTS_TARGET="-DUDEV_PATH_LIB=${SYSROOT_PREFIX}/usr/lib \
        -DJPEG_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DJPEG_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DVORBIS_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DVORBISFILE_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DVORBISENC_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DFLAC_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DOGG_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DFREETYPE_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DVORBIS_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DOGG_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DFLAC_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DOPENGL_opengl_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DOPENGL_glx_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DOPENGL_gl_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
		-DOPENGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DSFML_DRM=1  -DSFML_OPENGL_ES=1  \
		-DJPEG_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DOPENGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DOPENGL_opengl_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libGLESv2.so \
		-DEGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
		-DEGL_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libEGL.so \
		-DGLES_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include  \
		-DGLES_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libGLESv2.so"

#-DSFML_OPENGL_ES=1
#PKG_MAKE_OPTS_TARGET=" INCLUDES=-I$SYSROOT_PREFIX/usr/include "
#make_target() {
#cd $PKG_BUILD

#cmake . -DUDEV_PATH_LIB=${SYSROOT_PREFIX}/usr/lib \
#        -DJPEG_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DJPEG_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
#		-DVORBIS_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DVORBISFILE_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DVORBISENC_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DFLAC_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DOGG_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DFREETYPE_LIBRARY=${SYSROOT_PREFIX}/usr/lib \
#		-DVORBIS_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
#		-DOGG_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
#		-DFLAC_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
#		-DSFML_RPI=1 -DSFML_OS_LINUX=1 -DSFML_OPENGL_ES=1 \
#		-DEGL_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include \
#		-DEGL_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libEGL.so \
#		-DGLES_INCLUDE_DIR=${SYSROOT_PREFIX}/usr/include  \
#		-DGLES_LIBRARY=${SYSROOT_PREFIX}/usr/lib/libGLESv2.so

#make -j4 -I${SYSROOT_PREFIX}/usr/include
#}

makeinstall_target() {
 : not
}

post_make_target() { 
#./build.EmuELEC-OdroidGoAdvance.aarch64-4.1/sfml-eb47be11116fe1382578c58141229b8991312bd9/.aarch64-libreelec-linux-gnueabi/lib/libsfml-system.so.2.4.2

echo "PKG_BUILD=$PKG_BUILD"
echo "TARGET_NAME=$TARGET_NAME"
echo "INSTALL=$INSTALL"

mkdir -p $INSTALL/usr/lib
cp -P "$PKG_BUILD/.${TARGET_NAME}/lib/libsfml-"* $INSTALL/usr/lib/
cp -P "$PKG_BUILD/.${TARGET_NAME}/lib/libsfml-"* ${SYSROOT_PREFIX}/usr/lib/
cp -r "$PKG_BUILD"/include/SFML ${SYSROOT_PREFIX}/usr/include/ 
CFLAGS=$OLDCFLAGS
}
