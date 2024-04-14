PKG_NAME="es-theme-persona5-dc-RGB30"
PKG_SHORTDESC="persona5 theme"
PKG_LONGDESC="persona5 theme"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/share/themes
  tar -xvzf $PKG_DIR/es-theme-persona5-dc-RGB30.tar.gz -C ${INSTALL}/usr/share/themes/
}
