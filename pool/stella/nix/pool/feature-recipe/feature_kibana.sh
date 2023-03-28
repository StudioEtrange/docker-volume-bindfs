if [ ! "$_KIBANA_INCLUDED_" = "1" ]; then
_KIBANA_INCLUDED_=1


# NOTE :
# 	https://www.elastic.co/support/matrix#show_compatibility
# 	KIBANA 5.x NEED ES 5.x
#		KIBANA 4.2 NEED ES 2.X
#		KIBANA 4.1.2 NEED ES 1.4.4 - 1.7
feature_kibana() {
	FEAT_NAME=kibana
	FEAT_LIST_SCHEMA="6_5_0:binary 5_6_4:binary 5_6_2:binary 5_6_0:binary 5_2_0:binary 4_3_3:binary 4_5_4:binary 4_0_0:binary 3_1_2:source 4_0_1:binary 4_0_3:binary 4_1_0:binary 4_1_2:binary 4_2_0:binary 4_2_2:binary 4_3_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}


feature_kibana_6_5_0() {
	FEAT_VERSION=6_5_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-6.5.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-6.5.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-6.5.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-6.5.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_kibana_5_6_4() {
	FEAT_VERSION=5_6_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.4-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.4-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.4-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.4-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_kibana_5_6_0() {
	FEAT_VERSION=5_6_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_kibana_5_6_2() {
	FEAT_VERSION=5_6_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.2-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.2-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.6.2-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.6.2-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_kibana_5_2_0() {
	FEAT_VERSION=5_2_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.2.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.2.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_kibana_5_2_0() {
	FEAT_VERSION=5_2_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.2.0-darwin-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://artifacts.elastic.co/downloads/kibana/kibana-5.2.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-5.2.0-linux-x86_64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_kibana_4_5_4() {
	FEAT_VERSION=4_5_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.5.4-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.5.4-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.5.4-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.5.4-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_kibana_4_3_3() {
	FEAT_VERSION=4_3_3

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.3.3-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.3.3-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.3.3-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.3.3-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_kibana_4_3_1() {
	FEAT_VERSION=4_3_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.3.1-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.3.1-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.3.1-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.3.1-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_kibana_4_2_2() {
	FEAT_VERSION=4_2_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.2.2-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.2.2-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.2.2-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.2.2-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_kibana_4_2_0() {
	FEAT_VERSION=4_2_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.2.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.2.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.2.0-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_kibana_4_1_2() {
	FEAT_VERSION=4_1_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.1.2-darwin-x64.zip
		FEAT_BINARY_URL_FILENAME=kibana-4.1.2-darwin-x64.zip
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.1.2-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.1.2-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_kibana_3_1_2() {
	FEAT_VERSION=3_1_2

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://download.elastic.co/kibana/kibana/kibana-3.1.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=kibana-3.1.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/config.js
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_kibana_4_0_0() {
	FEAT_VERSION=4_0_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.0-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_kibana_4_0_1() {
	FEAT_VERSION=4_0_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.1-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.1-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.1-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_kibana_4_0_3() {
	FEAT_VERSION=4_0_3

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.3-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.3-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.0.3-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.0.3-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}




feature_kibana_4_1_0() {
	FEAT_VERSION=4_1_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.1.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.1.0-darwin-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.elastic.co/kibana/kibana/kibana-4.1.0-linux-x64.tar.gz
		FEAT_BINARY_URL_FILENAME=kibana-4.1.0-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/kibana
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}







feature_kibana_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
}

feature_kibana_install_source() {
	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
}


fi
