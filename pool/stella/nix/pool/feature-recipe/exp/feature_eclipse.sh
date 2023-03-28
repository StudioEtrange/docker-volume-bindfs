if [ ! "$_eclipse_INCLUDED_" = "1" ]; then
_eclipse_INCLUDED_=1

# TODO not finished

# download page : http://archive.eclipse.org/eclipse/downloads/
# eclipse repositories : https://wiki.eclipse.org/Eclipse_Project_Update_Sites

# Platform runtime binary : this is eclipse alone without anything

# to install stuff :
# ./Eclipse.app/Contents/MacOS/eclipse -nosplash -consolelog -application org.eclipse.equinox.p2.director  -repository http://download.eclipse.org/releases/neon/ -installIU org.eclipse.jdt.feature.group
# maven ; org.eclipse.m2e.feature.feature.group
# http://stackoverflow.com/questions/15262572/how-to-install-list-of-eclipse-plugins-from-a-script

feature_eclipse() {
	FEAT_NAME=eclipse
	FEAT_LIST_SCHEMA="4_6:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_eclipse_4_6() {
	FEAT_VERSION=4_6
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=http://archive.eclipse.org/eclipse/downloads/drops4/R-4.6-201606061100/download.php?dropFile=eclipse-platform-4.6-macosx-cocoa-x86_64.tar.gz
	FEAT_BINARY_URL_FILENAME=eclipse-platform-4.6-macosx-cocoa-x86_64.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=feature_eclipse_env


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/eclipse
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	ECLIPSE_REPOSITORY="http://download.eclipse.org/releases/neon/"

}

feature_eclipse_env() {
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && ECLIPSE_BINARY="$FEAT_INSTALL_ROOT/eclipse"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && ECLIPSE_BINARY="$FEAT_INSTALL_ROOT/Eclipse.app/Contents/MacOS/eclipse"
}

feature_eclipse_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
