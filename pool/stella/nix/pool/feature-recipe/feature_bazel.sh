if [ ! "$_bazel_INCLUDED_" = "1" ]; then
_bazel_INCLUDED_=1


# https://github.com/Homebrew/homebrew-core/blob/master/Formula/bazel.rb

feature_bazel() {
	FEAT_NAME=bazel
	FEAT_LIST_SCHEMA="0_6_1:binary 0_5_4:binary 0_4_2:source 0_3_2:source 0_2_2b:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_bazel_0_6_1() {
	FEAT_VERSION=0_6_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=oracle-jdk#8u91

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/bazelbuild/bazel/releases/download/0.6.1/bazel-0.6.1-without-jdk-installer-linux-x86_64.sh
		FEAT_BINARY_URL_FILENAME=bazel-0.6.1-without-jdk-installer-linux-x86_64.sh
		FEAT_BINARY_URL_PROTOCOL=HTTP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/bazelbuild/bazel/releases/download/0.6.1/bazel-0.6.1-without-jdk-installer-darwin-x86_64.sh
		FEAT_BINARY_URL_FILENAME=bazel-0.6.1-without-jdk-installer-darwin-x86_64.sh
		FEAT_BINARY_URL_PROTOCOL=HTTP
	fi



	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/bazel
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_bazel_0_5_4() {
	FEAT_VERSION=0_5_4

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=oracle-jdk#8u91

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://github.com/bazelbuild/bazel/releases/download/0.5.4/bazel-0.5.4-without-jdk-installer-linux-x86_64.sh
		FEAT_BINARY_URL_FILENAME=bazel-0.5.4-without-jdk-installer-linux-x86_64.sh
		FEAT_BINARY_URL_PROTOCOL=HTTP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/bazelbuild/bazel/releases/download/0.5.4/bazel-0.5.4-without-jdk-installer-darwin-x86_64.sh
		FEAT_BINARY_URL_FILENAME=bazel-0.5.4-without-jdk-installer-darwin-x86_64.sh
		FEAT_BINARY_URL_PROTOCOL=HTTP
	fi



	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/bazel
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_bazel_0_4_2() {
	FEAT_VERSION=0_4_2

	# TODO : need jdk8
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/bazelbuild/bazel/releases/download/0.4.2/bazel-0.4.2-dist.zip
	FEAT_SOURCE_URL_FILENAME=bazel-0.4.2-dist.zip
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bazel
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_bazel_0_3_2() {
	FEAT_VERSION=0_3_2

	# TODO : need jdk8
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/bazelbuild/bazel/archive/0.3.2.zip
	FEAT_SOURCE_URL_FILENAME=bazel-0.3.2.zip
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bazel
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_bazel_0_2_2b() {
	FEAT_VERSION=0_2_2b

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/bazelbuild/bazel/archive/0.2.2b.tar.gz
	FEAT_SOURCE_URL_FILENAME=bazel-0.2.2b.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bazel
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_bazel_install_binary() {
	__require "unzip" "unzip" "SYSTEM"

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT"

	chmod +x "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"

	"$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" --prefix="$FEAT_INSTALL_ROOT"

	rm -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"
}





feature_bazel_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"

	cd $SRC_DIR
	./compile.sh

	__copy_folder_content_into $SRC_DIR/output $INSTALL_DIR

	__del_folder $SRC_DIR

}



fi
