# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="evdevd"
PKG_VERSION="cd3fb6acfb5fc0a1c28c63666dd7fcaac59d3f15"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="BSD"
PKG_SITE="https://github.com/trngaje/evdevd"
PKG_GIT_CLONE_BRANCH="rgb30"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain libevdev"
PKG_SHORTDESC="evdevd - event for uinput"
PKG_LONGDESC="evdevd - event for uinput"
GET_HANDLER_SUPPORT="git"
PKG_TOOLCHAIN="manual"



make_target() {
   cp -f ${PKG_DIR}/Makefile ${PKG_BUILD}
   CFLAGS+=" -I$(get_build_dir libevdev) `${TOOLCHAIN}/bin/pkg-config --cflags --libs glib-2.0`"
   sed -i "s#/home/ark/mypipe#/storage/mypipe#g" ${PKG_BUILD}/fifo.c
   sed -i "s#sudo ##g" ${PKG_BUILD}/evdevd.c
   sed -i "s#e:D:S:vglFt#e:D:S:vglFts#g" ${PKG_BUILD}/evdevd.c
   make
}

makeinstall_target() {
   mkdir -p $INSTALL/usr/bin
   cp $PKG_BUILD/evdevd $INSTALL/usr/bin/
   chmod a+x $INSTALL/usr/bin/evdevd
}
