if [ ! "$_unixodbc_INCLUDED_" = "1" ]; then
_unixodbc_INCLUDED_=1

# https://github.com/Homebrew/homebrew-core/blob/master/Formula/unixodbc.rb
# with odbc_config binary, you can request build flags, include flags, ... for unixODBC

feature_unixodbc() {
	FEAT_NAME=unixodbc
	FEAT_LIST_SCHEMA="2_3_9:source 2_3_8:source 2_3_7:source 2_3_4:source"
	FEAT_DEFAULT_FLAVOUR="source"
	
	FEAT_DESC="The unixODBC Project goals are to develop and promote unixODBC to be the definitive standard for ODBC on non MS Windows platforms. ODBC is an open specification for providing application developers with a predictable API with which to access Data Sources. Data Sources include SQL Servers and any Data Source with an ODBC Driver."
	FEAT_LINK="http://www.unixodbc.org/"
}

feature_unixodbc_2_3_9() {
	FEAT_VERSION=2_3_9

	FEAT_SOURCE_URL="http://www.unixodbc.org/unixODBC-2.3.9.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unixODBC-2.3.9.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/odbc_config
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_unixodbc_2_3_8() {
	FEAT_VERSION=2_3_8

	FEAT_SOURCE_URL="http://www.unixodbc.org/unixODBC-2.3.8.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unixODBC-2.3.7.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/odbc_config
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}

feature_unixodbc_2_3_7() {
	FEAT_VERSION=2_3_7

	FEAT_SOURCE_URL="http://www.unixodbc.org/unixODBC-2.3.7.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unixODBC-2.3.7.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/odbc_config
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}


feature_unixodbc_2_3_4() {
	FEAT_VERSION=2_3_4

	FEAT_SOURCE_URL="http://www.unixodbc.org/unixODBC-2.3.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="unixODBC-2.3.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/odbc_config
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin
}



feature_unixodbc_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "STRIP"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-static --enable-shared --enable-gui=no --disable-debug --disable-dependency-tracking"

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

}



fi
