if [ ! "$_JQ_INCLUDED_" = "1" ]; then
_JQ_INCLUDED_=1

feature_jq() {
	FEAT_NAME=jq
	FEAT_LIST_SCHEMA="1_8_1@x64:binary 1_8_1@x86:binary 1_8_0@x64:binary 1_8_0@x86:binary 1_6@x64:binary 1_6@x86:binary 1_5@x64:binary 1_5@x86:binary 1_4@x64:binary 1_4@x86:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="jq is a lightweight and flexible command-line JSON processor."
	FEAT_LINK="https://jqlang.github.io/jq/ https://github.com/jqlang/jq"
}

feature_jq_1_8_1() {
	FEAT_VERSION="1_8_1"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64"
			FEAT_BINARY_URL_FILENAME_x64="jq-linux64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-i386"
			FEAT_BINARY_URL_FILENAME_x86="jq-linux32-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-arm64"
			FEAT_BINARY_URL_FILENAME_x64="jq-linux-arm64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
			FEAT_BINARY_URL_x86="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-armel"
			FEAT_BINARY_URL_FILENAME_x86="jq-linux-armel-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-macos-amd64"
			FEAT_BINARY_URL_FILENAME_x64="jq-macos-amd64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-macos-arm64"
			FEAT_BINARY_URL_FILENAME_x64="jq-macos-arm64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/jq"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"
}





feature_jq_1_8_0() {
	FEAT_VERSION="1_8_0"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux-i386"
		FEAT_BINARY_URL_FILENAME_x86="jq-linux32-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x86="HTTP"
		FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-linux-amd64"
		FEAT_BINARY_URL_FILENAME_x64="jq-linux64-$FEAT_VERSION"
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP

	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-macos-amd64"
			FEAT_BINARY_URL_FILENAME_x64="jq-macos-amd64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64=HTTP
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x86=
			FEAT_BINARY_URL_FILENAME_x86=
			FEAT_BINARY_URL_PROTOCOL_x86=
			FEAT_BINARY_URL_x64="https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-macos-arm64"
			FEAT_BINARY_URL_FILENAME_x64="jq-macos-arm64-$FEAT_VERSION"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/jq"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_jq_1_6() {
	FEAT_VERSION=1_6

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32
		FEAT_BINARY_URL_FILENAME_x86=jq-linux32-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
		FEAT_BINARY_URL_FILENAME_x64=jq-linux64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64
		FEAT_BINARY_URL_FILENAME_x64=jq-osx-amd64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/jq
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_jq_1_5() {
	FEAT_VERSION=1_5

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32
		FEAT_BINARY_URL_FILENAME_x86=jq-linux32-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
		FEAT_BINARY_URL_FILENAME_x64=jq-linux64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64
		FEAT_BINARY_URL_FILENAME_x64=jq-osx-amd64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/jq
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_jq_1_4() {
	FEAT_VERSION=1_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=https://github.com/stedolan/jq/releases/download/jq-1.4/jq-linux-x86
		FEAT_BINARY_URL_FILENAME_x86=jq-linux-x86-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.4/jq-linux-x86_64
		FEAT_BINARY_URL_FILENAME_x64=jq-linux-x86_64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP

	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=https://github.com/stedolan/jq/releases/download/jq-1.4/jq-osx-x86
		FEAT_BINARY_URL_FILENAME_x86=jq-osx-x86-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP
		FEAT_BINARY_URL_x64=https://github.com/stedolan/jq/releases/download/jq-1.4/jq-osx-x86_64
		FEAT_BINARY_URL_FILENAME_x64=jq-osx-x86_64-$FEAT_VERSION
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/jq
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_jq_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

	mv "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT/jq"
	chmod +x "$FEAT_INSTALL_ROOT/jq"

}


fi
