# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2022-24 JELOS (https://github.com/JustEnoughLinuxOS)
# Copyright (C) 2024-present ROCKNIX (https://github.com/ROCKNIX)

PKG_NAME="u-boot"
PKG_VERSION="v2024.10"
PKG_LICENSE="GPL"
PKG_SITE="https://www.denx.de/wiki/U-Boot"
PKG_URL="https://github.com/u-boot/u-boot/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain openssl:host pkg-config:host Python3:host swig:host pyelftools:host"
PKG_LONGDESC="Das U-Boot is a cross-platform bootloader for embedded systems."
PKG_TOOLCHAIN="manual"

PKG_NEED_UNPACK="${PROJECT_DIR}/${PROJECT}/bootloader ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/bootloader"
PKG_NEED_UNPACK+=" ${PROJECT_DIR}/${PROJECT}/options ${PROJECT_DIR}/${PROJECT}/devices/${DEVICE}/options"

if [ -n "${UBOOT_FIRMWARE}" ]; then
  PKG_DEPENDS_TARGET+=" ${UBOOT_FIRMWARE}"
  PKG_DEPENDS_UNPACK+=" ${UBOOT_FIRMWARE}"
fi

configure_package() {
  PKG_UBOOT_CONFIG="odroid-go-ultra_defconfig"
  PKG_UBOOT_FIP="odroid-go-ultra"
  FIP_DIR="$(get_build_dir amlogic-boot-fip)"
}

make_target() {
  [ "${BUILD_WITH_DEBUG}" = "yes" ] && PKG_DEBUG=1 || PKG_DEBUG=0
  setup_pkg_config_host
  DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make mrproper
  DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm make HOSTCC="${HOST_CC}" HOSTCFLAGS="-I${TOOLCHAIN}/include" HOSTLDFLAGS="${HOST_LDFLAGS}" ${PKG_UBOOT_CONFIG}
  DEBUG=${PKG_DEBUG} CROSS_COMPILE="${TARGET_KERNEL_PREFIX}" LDFLAGS="" ARCH=arm _python_sysroot="${TOOLCHAIN}" _python_prefix=/ _python_exec_prefix=/ make HOSTCC="${HOST_CC}" HOSTCFLAGS="-I${TOOLCHAIN}/include" HOSTLDFLAGS="${HOST_LDFLAGS}" HOSTSTRIP="true" CONFIG_MKIMAGE_DTC_PATH="scripts/dtc/dtc"

  cp -av ${PKG_BUILD}/u-boot.bin ${FIP_DIR}/${PKG_UBOOT_FIP}
  cd ${FIP_DIR}
  ./build-fip.sh ${PKG_UBOOT_FIP} ${FIP_DIR}/${PKG_UBOOT_FIP}/u-boot.bin ${PKG_BUILD}
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/bootloader

  # Always install the update script
  find_file_path bootloader/update.sh && cp -av ${FOUND_PATH} ${INSTALL}/usr/share/bootloader

  cp -av ${PKG_BUILD}/u-boot.bin $INSTALL/usr/share/bootloader
}
