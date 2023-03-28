if [ ! "$_sqlite_INCLUDED_" = "1" ]; then
_sqlite_INCLUDED_=1


feature_sqlite() {
	FEAT_NAME="sqlite"
	FEAT_LIST_SCHEMA="3_35_5:source 3_23_1:source 3_18_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="SQLite is an in-process library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
	FEAT_LINK="https://www.sqlite.org/"

}


feature_sqlite_3_35_5() {
	FEAT_VERSION="3_35_5"


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.sqlite.org/2021/sqlite-autoconf-3350500.tar.gz"
	FEAT_SOURCE_URL_FILENAME="sqlite-autoconf-3350500.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/sqlite3"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_sqlite_3_23_1() {
	FEAT_VERSION="3_23_1"


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://www.sqlite.org/2018/sqlite-autoconf-3230100.tar.gz"
	FEAT_SOURCE_URL_FILENAME="sqlite-autoconf-3230100.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/sqlite3"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_sqlite_3_18_0() {
	FEAT_VERSION="3_18_0"


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.sqlite.org/2017/sqlite-autoconf-3180000.tar.gz"
	FEAT_SOURCE_URL_FILENAME="sqlite-autoconf-3180000.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/sqlite3"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_sqlite_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking"
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"


}


fi