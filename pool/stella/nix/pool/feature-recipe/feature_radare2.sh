if [ ! "$_radare2_INCLUDED_" = "1" ]; then
_radare2_INCLUDED_=1

# https://github.com/radare/radare2
# https://github.com/radare/radare2/blob/master/doc/intro.md
# https://radare.gitbooks.io/radare2book/content/
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/radare2.rb

# r2 package manager :
# r2pm init
# r2pm update
# r2 web ui :
# r2 -c=H <binary file>

feature_radare2() {
	FEAT_NAME=radare2
	FEAT_LIST_SCHEMA="1_3_0:source 1_2_1:source SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_radare2_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/radare/radare2
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/r2
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	FEAT_GIT_TAG="master"

}



feature_radare2_1_3_0() {
	FEAT_VERSION=1_3_0


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/radare/radare2/archive/1.3.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=radare2-1.3.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/r2
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_radare2_1_2_1() {
	FEAT_VERSION=1_2_1


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/radare/radare2/archive/1.2.1.tar.gz
	FEAT_SOURCE_URL_FILENAME=radare2-1.2.1.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/r2
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}




feature_radare2_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	#SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"
	SRC_DIR="$INSTALL_DIR"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "$FORCE_NAME $FEAT_SOURCE_URL_FILENAME STRIP VERSION $FEAT_GIT_TAG"

	__set_toolset "STANDARD"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	cd "$SRC_DIR"


	mkdir -p $INSTALL_DIR
	# need sudo
	# "PREFIX=$INSTALL_DIR" ./sys/install.sh --without-pull
	# do not need sudo, but do not support prefix option
	# always install in HOME directory. So we use this hack
	HOME=$INSTALL_DIR ./sys/user.sh --without-pull


	#__inspect_and_fix_build "$INSTALL_DIR" "INCLUDE_FILTER bin/"


	__end_manual_build
}


fi
