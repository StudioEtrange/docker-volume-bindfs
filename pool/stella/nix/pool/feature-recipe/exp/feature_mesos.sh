if [ ! "$_mesos_INCLUDED_" = "1" ]; then
_mesos_INCLUDED_=1


# need libsasl : http://www.cyrusimap.org/sasl/
# http://mesos.apache.org/gettingstarted/

# Note : zookeeper is embedded

feature_mesos() {

	FEAT_NAME=mesos
	FEAT_LIST_SCHEMA="1_2_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_LINK="http://mesos.apache.org/"
	FEAT_DESC="A distributed systems kernel. Apache Mesos abstracts CPU, memory, storage, and other compute resources away from machines (physical or virtual), enabling fault-tolerant and elastic distributed systems to easily be built and run effectively."
}

feature_mesos_1_2_0() {
	FEAT_VERSION=1_2_0

	FEAT_SOURCE_DEPENDENCIES="apr#1_5_2:source apr-util#1_5_4:source svn#1_8_17 curl#7_36_0 cyrus-sasl#2_1_26"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://archive.apache.org/dist/mesos/1.2.0/mesos-1.2.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=mesos-1.2.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=


	FEAT_SOURCE_CALLBACK=feature_mesos_source_callback
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/mesos
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin:"$FEAT_INSTALL_ROOT"/sbin

}


feature_mesos_source_callback() {

	__link_feature_library "apr" "GET_FOLDER _apr NO_SET_FLAGS"
	__link_feature_library "apr-util"
	__link_feature_library "curl"
	__link_feature_library "cyrus-sasl"
	__link_feature_library "svn" "GET_FOLDER _svn NO_SET_FLAGS"

	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-svn=$_svn_ROOT  --with-apr=$_apr_ROOT"
}


feature_mesos_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"
	__check_toolset "C++"

	__add_toolset "miniconda#4_2_12_PYTHON2"
	__add_toolset "maven#3_3_9"
	__add_toolset "oracle-jdk#8u91"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__feature_callback

	#__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"
	__set_build_mode "OPTIMIZATION" ""
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP BUILD_KEEP POST_BUILD_STEP install check"

	__copy_folder_content_into "$SRC_DIR/src/examples" "$INSTALL_DIR/examples"

	#__del_folder "$SRC_DIR"

}



fi
