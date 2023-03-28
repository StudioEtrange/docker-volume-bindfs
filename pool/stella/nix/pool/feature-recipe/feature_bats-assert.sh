if [ ! "$_batsassert_INCLUDED_" = "1" ]; then
_batsassert_INCLUDED_=1



feature_bats-assert() {
	FEAT_NAME="bats-assert"
	FEAT_LIST_SCHEMA="2_0_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="bats-assert is a helper library providing common assertions for bats"
	FEAT_LINK="https://github.com/bats-assert/bats-assert"
}


feature_bats-assert_2_0_0() {
	FEAT_VERSION="2_0_0"

	FEAT_SOURCE_URL="https://github.com/bats-core/bats-assert/archive/refs/tags/v2.0.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bats-assert-${FEAT_VERSION}.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_bats-assert_setenv"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/load.bash"
	FEAT_SEARCH_PATH=

}


feature_bats-assert_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


}


feature_bats-assert_setenv() {
	# https://bats-core.readthedocs.io/en/stable/writing-tests.html#bats-load-library-load-system-wide-libraries
	export BATS_LIB_PATH="${BATS_LIB_PATH}:${FEAT_INSTALL_ROOT}/.."
}




fi
