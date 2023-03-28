if [ ! "$_PERL_INCLUDED_" = "1" ]; then
_PERL_INCLUDED_=1


feature_perl() {

	FEAT_NAME=perl
	FEAT_LIST_SCHEMA="5_18_2:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_perl_5_18_2() {
	FEAT_VERSION=5_18_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://www.cpan.org/src/5.0/perl-5.18.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=perl-5.18.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/perl
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_perl_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	cd "$SRC_DIR"

	sh "$SRC_DIR/Configure" -des -Dprefix=$INSTALL_DIR \
                  -Dvendorprefix=$INSTALL_DIR \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib

	make -j$STELLA_NB_CPU
	# test are too long
	# make test
	make install && __del_folder $SRC_DIR

	__end_manual_build
}



fi
