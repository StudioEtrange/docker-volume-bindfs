if [ ! "$_AUTOTOOLS_INCLUDED_" = "1" ]; then
_AUTOTOOLS_INCLUDED_=1



feature_autotools() {
	FEAT_NAME=autotools
	FEAT_LIST_SCHEMA="1_2 1_1_1 1_1 1_0"
	FEAT_BUNDLE="MERGE"
}




feature_autotools_1_2() {
	FEAT_VERSION="1_2"


	# BUNDLE ITEM LIST
	# order is important
	# see http://petio.org/tools.html
	FEAT_BUNDLE_ITEM="m4#1_4_19:source autoconf#2_71:source automake#1_16_5:source libtool#2_4_2:source"

	FEAT_ENV_CALLBACK=
	FEAT_BUNDLE_CALLBACK=

	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"


}

feature_autotools_1_1_1() {
	FEAT_VERSION="1_1_1"


	# BUNDLE ITEM LIST
	# order is important
	# see http://petio.org/tools.html
	FEAT_BUNDLE_ITEM="m4#1_4_18:source autoconf#2_69:source automake#1_14_1:source libtool#2_4_2:source"

	FEAT_ENV_CALLBACK=
	FEAT_BUNDLE_CALLBACK=

	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"


}

feature_autotools_1_1() {
	FEAT_VERSION="1_1"


	# BUNDLE ITEM LIST
	# order is important
	# see http://petio.org/tools.html
	FEAT_BUNDLE_ITEM="m4#1_4_18:source autoconf#2_69:source automake#1_14:source libtool#2_4_2:source"

	FEAT_ENV_CALLBACK=
	FEAT_BUNDLE_CALLBACK=

	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"


}

feature_autotools_1_0() {
	FEAT_VERSION="1_0"

	# BUNDLE ITEM LIST
	# order is important
	# see http://petio.org/tools.html
	FEAT_BUNDLE_ITEM="m4#1_4_17:source autoconf#2_69:source automake#1_14:source libtool#2_4_2:source"

	FEAT_ENV_CALLBACK=
	FEAT_BUNDLE_CALLBACK=

	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"


}


fi
