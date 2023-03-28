if [ ! "$_rexray_INCLUDED_" = "1" ]; then
_rexray_INCLUDED_=1


feature_rexray() {

	FEAT_NAME=rexray
	FEAT_LIST_SCHEMA=
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_LIST_SCHEMA="0_11_2@x64:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR="binary"
}

feature_rexray_0_11_2() {
	FEAT_VERSION=0_11_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://dl.bintray.com/rexray/rexray/stable/0.11.2/rexray-Linux-x86_64-0.11.2.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64=rexray-Linux-x86_64-0.11.2.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_rexray_add_resource
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/rexray
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	FEAT_ADD_RESOURCES="rexray-agent https://dl.bintray.com/rexray/rexray/stable/0.11.2/rexray-agent-Linux-x86_64-0.11.2.tar.gz \
	rexray-client https://dl.bintray.com/rexray/rexray/stable/0.11.2/rexray-client-Linux-x86_64-0.11.2.tar.gz \
	rexray-controller https://dl.bintray.com/rexray/rexray/stable/0.11.2/rexray-controller-Linux-x86_64-0.11.2.tar.gz"
}

feature_rexray_add_resource() {
	local _target_folder=
	for t in $FEAT_ADD_RESOURCES; do
		if [ "$_target_folder" = "" ]; then
			_target_folder=$FEAT_INSTALL_ROOT/bin/$t
			continue
		fi
		__get_resource "$FEAT_NAME" "$t" "$FEAT_BINARY_URL_PROTOCOL" "$_target_folder" "DEST_ERASE STRIP"
		_target_folder=
	done
}

# -----------------------------------------
feature_rexray_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT/bin" "FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	__feature_callback


}




fi
