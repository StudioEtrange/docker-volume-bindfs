if [ ! "$_nmap_INCLUDED_" = "1" ]; then
_nmap_INCLUDED_=1


feature_nmap() {
	FEAT_NAME=nmap
	FEAT_LIST_SCHEMA="6_49_BETA_4:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_nmap_6_49_BETA_4() {
	FEAT_VERSION=6_49_BETA_4
	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2d"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://nmap.org/dist/nmap-6.49BETA4.tgz
	FEAT_SOURCE_URL_FILENAME=nmap-6.49BETA4.tgz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_nmap_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/nmap
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_nmap_link() {
	__link_feature_library "openssl#1_0_2d"
}


feature_nmap_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"



	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	# https://nmap.org/book/inst-source.html
	AUTO_INSTALL_CONF_FLAG_POSTFIX="-with-libpcre=included \
									--with-libpcap=included \
      								--with-liblua=included \
      								--without-nmap-update"
      								# Zenmap is a python GUI with gtk, need python and pygtk to run
      								#--without-zenmap"

	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"



}



fi
