# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="advancemame-sa"
#PKG_VERSION="f1cbe29af2f42dbc478e44563a58393d1ada85f5"
PKG_VERSION="198f4f592ce6ad6f7f374b9cae7ed37e34eb1cee"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/trngaje/advancemame"
PKG_URL="$PKG_SITE.git"
#PKG_SOURCE_DIR="advancemame-sa-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain freetype slang alsa SDL2 runcommand"
PKG_SHORTDESC="A MAME and MESS port with an advanced video support for Arcade Monitors, TVs, and PC Monitors "
PKG_LONGDESC="A MAME and MESS port with an advanced video support for Arcade Monitors, TVs, and PC Monitors "
#PKG_IS_ADDON="no"
#PKG_AUTORECONF="no"
#PKG_TOOLCHAIN="make"
PKG_TOOLCHAIN="configure"
GET_HANDLER_SUPPORT="git"

#--with-freetype-prefix=$SYSROOT_PREFIX/usr/
PKG_CONFIGURE_OPTS_TARGET=" --datarootdir=/usr/share/ --enable-fb --enable-freetype --disable-slang"
# --enable-slang"
							  
pre_configure_target() {
	#export CFLAGS=`echo $CFLAGS | sed -e "s|-O.|-O3|g"`
	sed -i "s|#include <slang.h>|#include <$SYSROOT_PREFIX/usr/include/slang.h>|" $PKG_BUILD/configure.ac
	
	#sed -i "s|AC_HEADER_STDC|AC_CHECK_INCLUDES_DEFAULT\n\tAC_PROG_EGREP\n|" $PKG_BUILD/configure.ac
	
	echo "STRIP = $STRIP"
	echo "CC = $CC"
	echo "CXX = $CXX"
	echo "CCFLAGS = $CFLAGS"
	echo "CXXFLAGS = $CXXFLAGS"
	echo "LINKFLAGS = $LDFLAGS"	
	echo "AR = $AR"
	     
	#CFLAGS="-march=armv8-a+crc+crypto+fp+simd -mabi=lp64 -Wno-psabi -mtune=cortex-a55 -mno-outline-atomics -Wall -pipe -O3 -fomit-frame-pointer -DNDEBUG"
	CFLAGS="-march=armv8-a+crc+crypto+fp+simd -mabi=lp64 -Wno-psabi -mtune=cortex-a55 -mno-outline-atomics -Wall -pipe -O3 -fomit-frame-pointer  -fsigned-char -fno-stack-protector -Wno-sign-compare -Wno-unused -DNDEBUG"
	
	cd ${PKG_BUILD}
	autoupdate
	./autogen.sh
}

pre_make_target() {
	VERSION="trngaje"
	echo $VERSION > $PKG_BUILD/.version
}

make_target() {

   
	make
}

makeinstall_target() {
	mkdir -p $INSTALL/usr/share/advance
	cp -r $PKG_DIR/config/* $INSTALL/usr/share/advance/

	mkdir -p $INSTALL/usr/bin
	cp -r $PKG_DIR/bin/* $INSTALL/usr/bin
	chmod +x $INSTALL/usr/bin/advmame.sh

	cp -r $PKG_DIR/scripts/start_advmame.sh $INSTALL/usr/bin
	chmod +x $INSTALL/usr/bin/start_advmame.sh

	cp ${PKG_BUILD}/start_advmenu.sh ${INSTALL}/usr/bin
	chmod 0755 ${INSTALL}/usr/bin/start_advmenu.sh
  
	cp -r $PKG_BUILD/obj/mame/linux/blend/advmame $INSTALL/usr/bin
	cp -r $PKG_BUILD/obj/menu/linux/blend/advmenu $INSTALL/usr/bin
	cp -r $PKG_BUILD/obj/mess/linux/blend/advmess $INSTALL/usr/bin
	
	cp -r $PKG_BUILD/support/category.ini $INSTALL/usr/share/advance
	cp -r $PKG_BUILD/support/sysinfo.dat $INSTALL/usr/share/advance
	cp -r $PKG_BUILD/support/history.dat $INSTALL/usr/share/advance
	cp -r $PKG_BUILD/support/hiscore.dat $INSTALL/usr/share/advance
	cp -r $PKG_BUILD/support/event.dat $INSTALL/usr/share/advance


	CFLAGS=$OLDCFLAGS
}
