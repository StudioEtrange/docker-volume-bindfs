if [ ! "$_GEKKO_INCLUDED_" = "1" ]; then
_GEKKO_INCLUDED_=1

# run with
# node gekko --ui
# OR use stella alias "gekko-run"
# OR for headless edit config : https://gekko.wizb.it/docs/installation/installing_gekko_on_a_server.html

feature_gekko() {
	FEAT_NAME=gekko
	FEAT_LIST_SCHEMA="0_6_8:source 0_5_11:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="A bitcoin trading bot written in node"
	FEAT_LINK="https://gekko.wizb.it/"
}


feature_gekko_0_6_8() {
	FEAT_VERSION=0_6_8

	FEAT_SOURCE_DEPENDENCIES="nodejs"

	FEAT_SOURCE_URL="https://github.com/askmike/gekko/archive/v0.6.8.tar.gz"
	FEAT_SOURCE_URL_FILENAME="gekko-0.6.8.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_gekko_alias"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/gekko.js
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_gekko_0_5_11() {
	FEAT_VERSION="0_5_11"

	FEAT_SOURCE_DEPENDENCIES="nodejs"

	FEAT_SOURCE_URL="https://github.com/askmike/gekko/archive/0.5.11.tar.gz"
	FEAT_SOURCE_URL_FILENAME="gekko-0.5.11.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_gekko_alias"

	#FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/node_modules/gekko/gekko.js
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/gekko.js
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_gekko_alias() {
	export GEKKO_HOME="$FEAT_INSTALL_ROOT"
	gekko-run() {
		node $GEKKO_HOME/gekko --ui
	}
}


feature_gekko_install_source() {
	#INSTALL_DIR="$FEAT_INSTALL_ROOT"
	#SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME ${FEAT_SOURCE_URL_FILENAME}"
	__set_toolset "STANDARD"

	#cd "${INSTALL_DIR}"
	#npm install --only=production "${SRC_DIR}"

	cd "${FEAT_INSTALL_ROOT}"
	npm install --only=production

}


fi
