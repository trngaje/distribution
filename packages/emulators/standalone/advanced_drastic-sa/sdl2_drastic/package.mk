# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present 5schatten (https://github.com/5schatten)
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

PKG_NAME="sdl2_drastic"
PKG_VERSION="2.30.8"
PKG_LICENSE="GPL"
PKG_SITE="https://www.libsdl.org/"
PKG_URL="https://www.libsdl.org/release/SDL2-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa-lib systemd dbus pulseaudio libdrm SDL2:host json-c"
PKG_LONGDESC="Simple DirectMedia Layer is a cross-platform development library designed to provide low level access to audio, keyboard, mouse, joystick, and graphics hardware."
#PKG_DEPENDS_HOST="toolchain:host distutilscross:host"
PKG_TOOLCHAIN="manual"

if [ ! "${OPENGL_SUPPORT}" = "no" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGL} glu"
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGL=ON \
                           -DVIDEO_OPENGL=ON \
                           -DVIDEO_KMSDRM=OFF"
  if [ "${PREFER_GLES}" = "yes" ] && [ "${OPENGLES_SUPPORT}" = "yes" ]; then
    PKG_DEPENDS_TARGET+=" SDL2_glesonly "
  fi
else
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGL=OFF \
                           -DVIDEO_OPENGL=OFF \
                           -DVIDEO_KMSDRM=OFF"
fi

if [ "${OPENGLES_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" ${OPENGLES}"
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGLES=ON \
                           -DVIDEO_OPENGLES=ON \
                           -DVIDEO_KMSDRM=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_OPENGLES=OFF \
                           -DVIDEO_OPENGLES=OFF \
                           -DVIDEO_KMSDRM=OFF"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]; then
  PKG_DEPENDS_TARGET+=" vulkan-loader vulkan-headers"
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_VULKAN=ON \
                           -DVIDEO_OPENGL=OFF \
                           -DVIDEO_VULKAN=ON"
else
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_VULKAN=OFF \
                           -DVIDEO_VULKAN=OFF"
fi

if [ "${DISPLAYSERVER}" = "wl" ]
then
  PKG_DEPENDS_TARGET+=" wayland "
  case ${ARCH} in
    arm|i686)
      true
      ;;
    *)
      PKG_DEPENDS_TARGET+=" ${WINDOWMANAGER}"
      ;;
  esac
  PKG_CMAKE_OPTS_TARGET+=" -DSDL_WAYLAND=ON \
                           -DVIDEO_WAYLAND=ON \
                           -DVIDEO_WAYLAND_QT_TOUCH=ON \
                           -DWAYLAND_SHARED=ON \
                           -DVIDEO_X11=OFF \
                           -DSDL_X11=OFF"
else
  PKG_CMAKE_OPTS_TARGET+=" -DVIDEO_WAYLAND=OFF \
                           -DVIDEO_WAYLAND_QT_TOUCH=ON \
                           -DWAYLAND_SHARED=OFF \
                           -DVIDEO_X11=OFF \
                           -DSDL_X11=OFF"
fi

case ${PROJECT} in
  Rockchip)
    PKG_DEPENDS_TARGET+=" librga"
    PKG_PATCH_DIRS_TARGET+="${DEVICE}"
  ;;
esac

pre_configure_target(){

  if [ -n "${PKG_PATCH_DIRS_TARGET}" ]
  then
    ###
    ### Patching here is necessary to allow SDL2 to be built for
    ### use by host builds without requiring additional unnecessary
    ### packages to also be built (and break) during the build.
    ###
    ### It may be better served as a hook in scripts/build.
    ###

    if [ -d "${PKG_DIR}/patches/${PKG_PATCH_DIRS_TARGET}" ]
    then
      cd $(get_build_dir SDL2)
      for PATCH in ${PKG_DIR}/patches/${PKG_PATCH_DIRS_TARGET}/*
      do
        patch -p1 <${PATCH}
      done
      cd -
    fi

    ### End
  fi

  #export CFLAGS="${CFLAGS} -Wno-error -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-implicit-function-declaration \
  #			-Wno-implicit-int -I${SYSROOT_PREFIX}/usr/include/SDL2 -DADVDRASTIC_DRM"
  #export LDFLAGS="${LDFLAGS} -ludev -lSDL2_image -lSDL2_ttf -ljson-c -lEGL -lGLESv2 -lpthread"
  #export EXTRA_LDFLAGS="${LDFLAGS}"



  PKG_CMAKE_OPTS_TARGET+="-DSDL_STATIC=OFF \
                         -DLIBC=ON \
                         -DGCC_ATOMICS=ON \
                         -DALTIVEC=OFF \
                         -DOSS=OFF \
                         -DALSA=ON \
                         -DALSA_SHARED=ON \
                         -DJACK=OFF \
                         -DJACK_SHARED=OFF \
                         -DESD=OFF \
                         -DESD_SHARED=OFF \
                         -DARTS=OFF \
                         -DARTS_SHARED=OFF \
                         -DNAS=OFF \
                         -DNAS_SHARED=OFF \
                         -DLIBSAMPLERATE=OFF \
                         -DLIBSAMPLERATE_SHARED=OFF \
                         -DSNDIO=OFF \
                         -DDISKAUDIO=OFF \
                         -DDUMMYAUDIO=OFF \
                         -DVIDEO_X11=OFF \
                         -DVIDEO_MIR=OFF \
                         -DMIR_SHARED=OFF \
                         -DVIDEO_COCOA=OFF \
                         -DVIDEO_DIRECTFB=OFF \
                         -DVIDEO_VIVANTE=OFF \
                         -DDIRECTFB_SHARED=OFF \
                         -DFUSIONSOUND=OFF \
                         -DFUSIONSOUND_SHARED=OFF \
                         -DVIDEO_DUMMY=OFF \
                         -DINPUT_TSLIB=ON \
                         -DSDL_HIDAPI_JOYSTICK=ON \
                         -DPTHREADS=ON \
                         -DPTHREADS_SEM=ON \
                         -DDIRECTX=OFF \
                         -DSDL_DLOPEN=ON \
                         -DCLOCK_GETTIME=OFF \
                         -DSDL_RPATH=OFF \
                         -DRENDER_D3D=OFF \
                         -DPIPEWIRE=ON \
                         -DPULSEAUDIO=ON \
                         -DADVDRASTIC_WAYLAND=ON "
#-DADVDRASTIC_DRM=ON "
  #PKG_CMAKE_OPTS_TARGET+= " -DADVDRASTIC_DRM=ON "
}

make_target() {
    sed -i "s&^#define PATCH_COUNT .*&#define PATCH_COUNT \"`cat  ${PKG_BUILD}/.patchcount`\"&g" ${PKG_BUILD}/src/video/drastic_advanced.h
    # for wayland
   # sed -i "s#%CFLAGS%#${CFLAGS} -Wno-error -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -Wno-implicit-int -I${SYSROOT_PREFIX}/usr/include/SDL2 -DADVDRASTIC_WAYLAND#g" ${PKG_BUILD}/CMakeLists.txt 
    # for drm
    #sed -i "s#%CFLAGS%#${CFLAGS} -Wno-error -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -Wno-implicit-int -I${SYSROOT_PREFIX}/usr/include/SDL2 -DADVDRASTIC_DRM#g" ${PKG_BUILD}/CMakeLists.txt 
    sed -i "s#%CFLAGS%#${CFLAGS} -Wno-error -Wno-int-conversion -Wno-incompatible-pointer-types -Wno-implicit-function-declaration -Wno-implicit-int -I${SYSROOT_PREFIX}/usr/include/SDL2#g" ${PKG_BUILD}/CMakeLists.txt 

    # for weston
    cp $PKG_DIR/weston/* $PKG_BUILD/src/video/

    #wayland-scanner private-code $SYSROOT_PREFIX/usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml $PKG_BUILD/src/video/xdg-shell.c 
    #wayland-scanner client-header $SYSROOT_PREFIX/usr/share/wayland-protocols/stable/xdg-shell/xdg-shell.xml $PKG_BUILD/src/video/xdg-shell.h     

    [ -d "${PKG_BUILD}/build" ] && rm -rf ${PKG_BUILD}/build
    mkdir ${PKG_BUILD}/build
    cd ${PKG_BUILD}/build
    cmake ${PKG_CMAKE_OPTS_TARGET} ..
    #cmake --build .
    make NO_WERROR=1 CODE=ANSI_C

#	cmake ${PKG_BUILD} ${PKG_CMAKE_OPTS_TARGET}
#	make -C ${PKG_BUILD}
}

makeinstall_target() {
    mkdir -p ${INSTALL}/usr/share/advanced_drastic/libs
    cp -rf ${PKG_BUILD}/build/libSDL2-2.0.so.0 ${INSTALL}/usr/share/advanced_drastic/libs/
}
