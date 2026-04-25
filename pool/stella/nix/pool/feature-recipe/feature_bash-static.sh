if [ ! "$_bash_static_INCLUDED_" = "1" ]; then
_bash_static_INCLUDED_=1


feature_bash-static() {
	FEAT_NAME="bash-static"
	FEAT_LIST_SCHEMA="5_2_015_1_2_3_2@x64:binary"
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Statically linked to muslc bash binaries. And code to build these bash binaries."
	FEAT_LINK="https://github.com/robxu9/bash-static"
}


feature_bash-static_5_2_015_1_2_3_2() {
	FEAT_VERSION="5_2_015_1_2_3_2"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/robxu9/bash-static/releases/download/5.2.015-1.2.3-2/bash-linux-x86_64"
		FEAT_BINARY_URL_FILENAME_x64="bash-linux-x86_64"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bash-static"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}



feature_bash-static_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"
	mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/bash-static"
	chmod +x "$FEAT_INSTALL_ROOT/bash-static"
}


fi
