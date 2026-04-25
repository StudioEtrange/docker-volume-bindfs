if [ ! "$_batssupport_INCLUDED_" = "1" ]; then
_batssupport_INCLUDED_=1



feature_bats-support() {
	FEAT_NAME="bats-support"
	FEAT_LIST_SCHEMA="0_3_0:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="bats-support is a helper library providing common functions for bats"
	FEAT_LINK="https://github.com/bats-core/bats-support https://bats-support.readthedocs.io/"
}


feature_bats-support_0_3_0() {
	FEAT_VERSION="0_3_0"

	FEAT_SOURCE_URL="https://github.com/bats-core/bats-support/archive/refs/tags/v0.3.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bats-support-${FEAT_VERSION}.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_bats-support_setenv"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/load.bash"
	FEAT_SEARCH_PATH=

}


feature_bats-support_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


}


feature_bats-support_setenv() {
	# https://bats-core.readthedocs.io/en/stable/writing-tests.html#bats-load-library-load-system-wide-libraries
	export BATS_LIB_PATH="${BATS_LIB_PATH}:${FEAT_INSTALL_ROOT}/.."
}




fi
