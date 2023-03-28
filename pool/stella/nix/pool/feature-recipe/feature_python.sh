if [ ! "$_PYTHON_INCLUDED_" = "1" ]; then
_PYTHON_INCLUDED_=1

# Python 2.7.9 and later (on the python2 series), and Python 3.4 and later include PIP by default
# But not python from code source
# (http://pip.readthedocs.org/en/latest/installing.html#pip-included-with-python)

feature_python() {

	FEAT_NAME=python
	FEAT_LIST_SCHEMA="2_7_9:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_python_2_7_9() {
	FEAT_VERSION=2_7_9

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 FORCE_ORIGIN_STELLA openssl#1_0_2d"

	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
	FEAT_SOURCE_URL_FILENAME=Python-2.7.9.tgz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_python_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/python
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_python_link() {
	__link_feature_library "zlib#^1_2" "LIBS_NAME z FORCE_STATIC"
	__link_feature_library "FORCE_ORIGIN_STELLA openssl#1_0_2d"
}


feature_python_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	__feature_callback

	# auto relocate failed, because adding rpath there is not enough rpath in headers
	# maybe we have to use -Wl,-headerpad_max_install_names
	# error message :
	# "because larger updated load commands do not fit (the program must be relinked, and you may need to use -headerpad or -headerpad_max_install_names)"
	#__set_build_mode "RELOCATE" "OFF"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--enable-shared"
	#--with-ensurepip=install # build pip from pip source included into python source BUT need openssl
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	# NOTE : on darwin, have to fix min macos version, information needed for building python

	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_OUT_OF_TREE_BUILD"




	# install last pip/setuptools
	__get_resource "get-pip" "https://bootstrap.pypa.io/get-pip.py" "HTTP" "$FEAT_INSTALL_ROOT/pip"
	cd "$FEAT_INSTALL_ROOT/pip"
	"$FEAT_INSTALL_ROOT/bin/python" get-pip.py
	rm -Rf "$FEAT_INSTALL_ROOT/pip"

}



fi
