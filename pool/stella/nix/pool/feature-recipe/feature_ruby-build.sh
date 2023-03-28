if [ ! "$_RUBYINSTALL_INCLUDED_" = "1" ]; then
_RUBYINSTALL_INCLUDED_=1


# https://github.com/rbenv/ruby-build

# Work as a standalone program or as rbenv plugin
# This recipe stand for the standalone program way

# aownload any ruby distribution source code and built it, without taking care of dependencies



feature_ruby-build() {
	FEAT_NAME=ruby-build
	FEAT_LIST_SCHEMA="v20170914:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_ruby-build_v20170914() {
	FEAT_VERSION=v20170914

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/rbenv/ruby-build/archive/v20170914.tar.gz
	FEAT_SOURCE_URL_FILENAME=ruby-build-v20170914.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/ruby-build
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_ruby-build_install_binary() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	PREFIX="$INSTALL_DIR" $SRC_DIR/install.sh

}


fi
