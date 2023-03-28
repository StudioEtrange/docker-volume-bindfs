if [ ! "$_predictionio_INCLUDED_" = "1" ]; then
_predictionio_INCLUDED_=1

# TODO not finished
# https://docs.prediction.io/install/install-linux/
# you must edit PredictionIO-0.9.6/conf/pio-env.sh and change the SPARK_HOME
# edit PredictionIO-0.9.6/conf/pio-env.sh and change the PIO_STORAGE_SOURCES_ELASTICSEARCH_HOME
# PIO_STORAGE_SOURCES_ELASTICSEARCH_TYPE=elasticsearch
# PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=localhost
# PIO_STORAGE_SOURCES_ELASTICSEARCH_PORTS=9300
# edit PredictionIO-0.9.6/conf/pio-env.sh and change the PIO_STORAGE_SOURCES_HBASE_HOME
#
# conf hbase
# hbase-site.xml
# <configuration>
#   <property>
#     <name>hbase.rootdir</name>
#     <value>file:///home/abc/PredictionIO-0.9.6/vendors/hbase-1.0.0/data</value>
#   </property>
#   <property>
#     <name>hbase.zookeeper.property.dataDir</name>
#     <value>/home/abc/PredictionIO-0.9.6/vendors/hbase-1.0.0/zookeeper</value>
#   </property>
# </configuration>


# http://predictionio.incubator.apache.org/index.html

feature_predictionio() {
	FEAT_NAME=predictionio
	FEAT_LIST_SCHEMA="0_9_6:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_predictionio_0_9_6() {
	FEAT_VERSION=0_9_6
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES="oracle-jdk#8u91 hbase#1_1_5 elasticsearch#1_7_3 spark#1_6_1_HADOOP_2_6"

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=https://github.com/PredictionIO/PredictionIO/releases/download/v0.9.6/PredictionIO-0.9.6.tar.gz
	FEAT_BINARY_URL_FILENAME=PredictionIO-0.9.6.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/pio
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_predictionio_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP"

}


fi
