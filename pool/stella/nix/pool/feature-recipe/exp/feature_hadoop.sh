if [ ! "$_hadoop_INCLUDED_" = "1" ]; then
_hadoop_INCLUDED_=1

# NOTE : for hadoop common native libraries
# see http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/NativeLibraries.html

# Include Hadoop Common, YARN service, HDFS service and MapReduce framework


feature_hadoop() {
	FEAT_NAME=hadoop
	FEAT_LIST_SCHEMA="2_7_2:binary 2_6_4:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_hadoop_2_7_2() {
	FEAT_VERSION=2_7_2
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=http://www.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
	FEAT_BINARY_URL_FILENAME=hadoop-2.7.2.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/hadoop
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin:"$FEAT_INSTALL_ROOT"/sbin

}

feature_hadoop_2_6_4() {
	FEAT_VERSION=2_6_4
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=http://www.apache.org/dist/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz
	FEAT_BINARY_URL_FILENAME=hadoop-2.6.4.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/hadoop
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin:"$FEAT_INSTALL_ROOT"/sbin

}


feature_hadoop_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"
}


fi
