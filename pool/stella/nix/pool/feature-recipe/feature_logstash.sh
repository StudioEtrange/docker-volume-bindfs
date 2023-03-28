if [ ! "$_logstash_INCLUDED_" = "1" ]; then
_logstash_INCLUDED_=1



feature_logstash() {
	FEAT_NAME=logstash
	FEAT_LIST_SCHEMA="5_2_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_logstash_env() {
	LOGSTASH_HOME=$FEAT_INSTALL_ROOT
	export LOGSTASH_HOME=$FEAT_INSTALL_ROOT
}


feature_logstash_5_2_0() {
	FEAT_VERSION=5_2_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/logstash/logstash-5.2.0.tar.gz
	FEAT_BINARY_URL_FILENAME=logstash-5.2.0.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=feature_logstash_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/logstash
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_logstash_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"


}


fi
