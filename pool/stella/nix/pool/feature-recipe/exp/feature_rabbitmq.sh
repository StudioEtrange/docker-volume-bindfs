if [ ! "$_rabbitmq_INCLUDED_" = "1" ]; then
_rabbitmq_INCLUDED_=1


feature_rabbitmq() {
	FEAT_NAME=rabbitmq
	FEAT_LIST_SCHEMA="3_7_3:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="message broker"
	FEAT_LINK="https://www.rabbitmq.com/"
}



feature_rabbitmq_3_7_3() {
	FEAT_VERSION=3_7_3

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_BINARY_URL=https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.7.3/rabbitmq-server-generic-unix-3.7.3.tar.xz
	FEAT_BINARY_URL_FILENAME=rabbitmq-server-generic-unix-3.7.3.tar.xz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP


	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST=$FEAT_INSTALL_ROOT/sbin/rabbitmq-server
	# PATH to add to system PATH
	FEAT_SEARCH_PATH=$FEAT_INSTALL_ROOT/sbin:$FEAT_INSTALL_ROOT/escript

}


feature_rabbitmq_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	#mv -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/rabbitmq"
	#chmod +x "$FEAT_INSTALL_ROOT/rabbitmq"

}



fi
