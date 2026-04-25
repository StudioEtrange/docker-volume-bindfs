if [ ! "$_lilipod_INCLUDED_" = "1" ]; then
_lilipod_INCLUDED_=1

# NOTE :
#		dependencies on  getsubuid/gid : have to install a system package : 
#					https://github.com/89luca89/lilipod/issues/7 
#					https://man7.org/linux/man-pages/man1/getsubids.1.html 
#					https://github.com/shadow-maint/shadow/blob/master/src/getsubids.c
#
#		You can set LILIPOD_HOME to force lilipod to create images/containers/volumes in a specific directory.
#		else lilipod will use XDG_DATA_HOME or fallback to $HOME/.local/share/lilipod

feature_lilipod() {
	FEAT_NAME="lilipod"
	FEAT_LIST_SCHEMA="0_0_3@x64:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"


	FEAT_DESC="Lilipod is a simple container manager, able to download, unpack and use OCI images from various container registries."
	FEAT_LINK="https://github.com/89luca89/lilipod"
}



feature_lilipod_0_0_3() {
	FEAT_VERSION="0_0_3"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/89luca89/lilipod/releases/download/v0.0.3/lilipod-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="lilipod-linux-amd64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi


	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/lilipod"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}




feature_lilipod_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/lilipod"
	chmod +x "$FEAT_INSTALL_ROOT/lilipod"

}


fi
