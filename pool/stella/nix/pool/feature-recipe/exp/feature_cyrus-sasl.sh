if [ ! "$_cyrussasl_INCLUDED_" = "1" ]; then
_cyrussasl_INCLUDED_=1


# TODO not finished

feature_cyrus-sasl() {
	FEAT_NAME=cyrus-sasl
	FEAT_LIST_SCHEMA="2_1_26:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="http://www.cyrusimap.org/sasl/"
	FEAT_DESC="Simple Authentication and Security Layer (SASL) is a specification that describes how authentication mechanisms \
	can be plugged into an application protocol on the wire. Cyrus SASL is an implementation of SASL that makes it easy \
	for application developers to integrate authentication mechanisms into their application in a generic way."
}

feature_cyrus-sasl_2_1_26() {
	FEAT_VERSION=2_1_26
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz
	FEAT_SOURCE_URL_FILENAME=cyrus-sasl-2.1.26.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libcyrus-sasl2.a
	FEAT_SEARCH_PATH=

}



feature_cyrus-sasl_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}



fi
