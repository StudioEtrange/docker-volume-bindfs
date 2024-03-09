if [ ! "$_batscore_INCLUDED_" = "1" ]; then
_batscore_INCLUDED_=1



feature_bats-core() {
	FEAT_NAME="bats-core"
	FEAT_LIST_SCHEMA="1_9_0:source 1_7_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Bash Automated Testing System"
	FEAT_LINK="https://github.com/bats-core/bats-core https://bats-core.readthedocs.io/"
}

# get bats own unit test to have some sample as guide
get_bats_own_unit_test() {
	cp -R "${SRC_DIR}/test" "${INSTALL_DIR}/test"
}


feature_bats-core_1_9_0() {
	FEAT_VERSION="1_9_0"

	FEAT_SOURCE_URL="https://github.com/bats-core/bats-core/archive/refs/tags/v1.9.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bats-${FEAT_VERSION}.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="get_bats_own_unit_test"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/bats"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"

}




feature_bats-core_1_7_0() {
	FEAT_VERSION="1_7_0"

	FEAT_SOURCE_URL="https://github.com/bats-core/bats-core/archive/refs/tags/v1.7.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bats-${FEAT_VERSION}.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_SOURCE_CALLBACK="get_bats_own_unit_test"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/bin/bats"
	FEAT_SEARCH_PATH="${FEAT_INSTALL_ROOT}/bin"

}


feature_bats-core_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	cd "$SRC_DIR"
	./install.sh "$INSTALL_DIR"

	__feature_callback

	rm -Rf "$SRC_DIR"

}




fi
