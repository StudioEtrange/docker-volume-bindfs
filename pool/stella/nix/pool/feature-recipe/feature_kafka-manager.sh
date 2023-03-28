if [ ! "$_kafkamanager_INCLUDED_" = "1" ]; then
_kafkamanager_INCLUDED_=1


# https://github.com/yahoo/kafka-manager

# launch with
# ZK_HOSTS=localhost:2181 kafka-manager
# where ZK_HOSTS is zookeeper

feature_kafka-manager() {
	FEAT_NAME="kafka-manager"
	FEAT_LIST_SCHEMA="1_3_3_14:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}


feature_kafka-manager_1_3_3_14() {
	FEAT_VERSION="1_3_3_14"

	FEAT_SOURCE_DEPENDENCIES="oracle-jdk"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://github.com/yahoo/kafka-manager/archive/1.3.3.14.tar.gz"
	FEAT_SOURCE_URL_FILENAME="kafka-manager-1.3.3.14.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/kafka-manager"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_kafka-manager_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	# if we have a built version in cache, do not rebuild
	if [ -f "$STELLA_APP_CACHE_DIR/$FEAT_NAME-${FEAT_VERSION//_/.}.zip" ]; then
		__uncompress "$STELLA_APP_CACHE_DIR/$FEAT_NAME-${FEAT_VERSION//_/.}.zip" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
	else

		__set_toolset "NONE"

		__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

		cd "$SRC_DIR"
		./sbt clean dist

		if [ -f "$SRC_DIR/target/universal/$FEAT_NAME-${FEAT_VERSION//_/.}.zip" ]; then
			__uncompress "$SRC_DIR/target/universal/$FEAT_NAME-${FEAT_VERSION//_/.}.zip" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
		fi

		cp -f "$SRC_DIR/target/universal/$FEAT_NAME-${FEAT_VERSION//_/.}.zip" "$STELLA_APP_CACHE_DIR/"

		rm -Rf "$SRC_DIR"
	fi
}

fi
