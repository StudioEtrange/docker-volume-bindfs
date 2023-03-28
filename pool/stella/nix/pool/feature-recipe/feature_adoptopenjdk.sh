if [ ! "$_adoptopenjdk_INCLUDED_" = "1" ]; then
_adoptopenjdk_INCLUDED_=1


# Recipe for Open Java Development Kit (=JDK)

# CHANGE in Java/Oracle Licence model:
#		* It is impossible to automate oraclejdk download now
#		* Now there is OpenJDK and OracleJDK
#		* There is a lot of OpenJDK distributor including Oracle (so OpenJDK crom Oracle is not the same than OracleJDK)

# List of OpenJDK distributor : https://dzone.com/articles/java-and-the-jdks-which-one-to-use


# NOTE : AdoptOpenJDK provide an Hotspot JVM, but can provide OepnJ9 JVM instead (not included in this recipe)

feature_adoptopenjdk() {
	FEAT_NAME="adoptopenjdk"
	FEAT_LIST_SCHEMA="12_0_2_10_2@x64:binary 11_0_4_11@x64:binary 8_u222_b10@x64:binary 8_u172_b11@x64:binary"
	FEAT_DEFAULT_ARCH="x64"
	FEAT_DEFAULT_FLAVOUR="binary"
	
	FEAT_LINK="https://adoptopenjdk.net"
	FEAT_DESC="AdoptOpenJDK uses infrastructure, build et test scripts to produce prebuilt binaries from OpenJDK™ class libraries and a choice of either the OpenJDK HotSpot ou Eclipse OpenJ9 VM. All AdoptOpenJDK binaries and scripts are open source licensed and available for free."
}

feature_adoptopenjdk_env() {
	export JAVA_HOME=$FEAT_INSTALL_ROOT
}



feature_adoptopenjdk_12_0_2_10_2() {
	FEAT_VERSION="12_0_2_10_2"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.2%2B10/OpenJDK12U-jdk_x64_linux_hotspot_12.0.2_10.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK12U-jdk_x64_linux_hotspot_12.0.2_10.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.2%2B10/OpenJDK12U-jdk_x64_mac_hotspot_12.0.2_10.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK12U-jdk_x64_mac_hotspot_12.0.2_10.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_adoptopenjdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_adoptopenjdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}



feature_adoptopenjdk_11_0_4_11() {
	FEAT_VERSION="11_0_4_11"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11/OpenJDK11U-jdk_x64_linux_hotspot_11.0.4_11.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK11U-jdk_x64_linux_hotspot_11.0.4_11.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.4%2B11/OpenJDK11U-jdk_x64_mac_hotspot_11.0.4_11.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK11U-jdk_x64_mac_hotspot_11.0.4_11.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_adoptopenjdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_adoptopenjdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}




feature_adoptopenjdk_8_u222_b10() {
	FEAT_VERSION="8_u222_b10"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK8U-jdk_x64_linux_hotspot_8u222b10.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jdk_x64_mac_hotspot_8u222b10.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK8U-jdk_x64_mac_hotspot_8u222b10.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"


	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_adoptopenjdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_adoptopenjdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}


feature_adoptopenjdk_8_u172_b11() {
	FEAT_VERSION="8_u172_b11"

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_x86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk8-releases/releases/download/jdk8u172-b11/OpenJDK8_x64_Linux_jdk8u172-b11.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK8_x64_Linux_jdk8u172-b11.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="https://github.com/AdoptOpenJDK/openjdk8-releases/releases/download/jdk8u172-b11/OpenJDK8_x64_Mac_jdk8u172-b11.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64="OpenJDK8_x64_Mac_jdk8u172-b11.tar.gz"
		FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"


	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_adoptopenjdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_adoptopenjdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}


# fix problems with jni_md.h
# http://stackoverflow.com/a/24996278
feature_adoptopenjdk_fix_jni_header() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		ln -s $FEAT_INSTALL_ROOT/include/darwin/jni_md.h $FEAT_INSTALL_ROOT/include/jni_md.h
		ln -s $FEAT_INSTALL_ROOT/include/darwin/jawt_md.h $FEAT_INSTALL_ROOT/include/jawt_md.h
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		ln -s $FEAT_INSTALL_ROOT/include/linux/jni_md.h $FEAT_INSTALL_ROOT/include/jni_md.h
		ln -s $FEAT_INSTALL_ROOT/include/linux/jawt_md.h $FEAT_INSTALL_ROOT/include/jawt_md.h
	fi
}


feature_adoptopenjdk_install_binary() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"


	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP"
	
	__feature_callback


}


fi
