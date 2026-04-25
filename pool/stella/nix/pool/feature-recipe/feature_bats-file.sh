if [ ! "$_batsfile_INCLUDED_" = "1" ]; then
_batsfile_INCLUDED_=1



feature_bats-file() {
	FEAT_NAME="bats-file"
	FEAT_LIST_SCHEMA="0_3_0:source"
	
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="bats-file is a helper library providing common filesystem related assertions and helpers for bats"
	FEAT_LINK="https://github.com/bats-core/bats-file"
}


feature_bats-file_0_3_0() {
	FEAT_VERSION="0_3_0"

	FEAT_SOURCE_URL="https://github.com/bats-core/bats-file/archive/refs/tags/v0.3.0.tar.gz"
	FEAT_SOURCE_URL_FILENAME="bats-file-${FEAT_VERSION}.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_bats-file_setenv"

	FEAT_INSTALL_TEST="${FEAT_INSTALL_ROOT}/load.bash"
	FEAT_SEARCH_PATH=

}


feature_bats-file_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


}


feature_bats-file_setenv() {
	# https://bats-core.readthedocs.io/en/stable/writing-tests.html#bats-load-library-load-system-wide-libraries
	export BATS_LIB_PATH="${BATS_LIB_PATH}:${FEAT_INSTALL_ROOT}/.."
}




fi
