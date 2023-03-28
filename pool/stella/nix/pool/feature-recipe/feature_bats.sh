if [ ! "$_bats_INCLUDED_" = "1" ]; then
_bats_INCLUDED_=1



feature_bats() {
	FEAT_NAME="bats"
	FEAT_LIST_SCHEMA="1"
	FEAT_DEFAULT_ARCH=

	FEAT_BUNDLE="NESTED"

	FEAT_DESC="Bash Automated Testing System and its helper"
	FEAT_LINK="https://github.com/bats-core/bats-core https://bats.readthedocs.io/"
}


feature_bats_1() {
	FEAT_VERSION="1"
	
	FEAT_BUNDLE_ITEM="bats-core#1_7_0 bats-assert#2_0_0 bats-support#0_3_0 bats-file#0_3_0"

	FEAT_ENV_CALLBACK="feature_bats_setenv"
	FEAT_BUNDLE_CALLBACK=

	FEAT_INSTALL_TEST=
	FEAT_SEARCH_PATH=

}



feature_bats_setenv() {
	export BATS_BUNDLE_HOME="${FEAT_INSTALL_ROOT}"
	__log "INFO" "-- Bats is installed in [$BATS_BUNDLE_HOME] (see BATS_BUNDLE_HOME env var)."
	__log "INFO" "-- Bats helper are installed in folders listed in [$BATS_LIB_PATH] (see BATS_LIB_PATH env var)."
	__log "INFO" "-- To load an installed helper use bats_load_library 'bats-assert', it will search bats-assert folder inside those folders list"
	__log "INFO" "-- see https://bats-core.readthedocs.io/en/stable/writing-tests.html#bats-load-library-load-system-wide-libraries"
}




fi
