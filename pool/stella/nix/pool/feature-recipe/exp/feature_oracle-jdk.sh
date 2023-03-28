if [ ! "$_ORACLEJDK_INCLUDED_" = "1" ]; then
_ORACLEJDK_INCLUDED_=1


# NOTE : cant use this recipe cause we cant download oracle jdk

# Recipe for Oracle Java SE Development Kit (=JDK)

# NOTE : Java Runtime Environment (=JRE) is only a java runtime
#		 Java SE Development Kit (=JDK) includes a JRE and all components needed to develop
#		 Java EE Development Kit do NOT include any Java SE Development Kit (JDK) nor any JRE. It includes a server (and other examples stuff) implementing the Java EE rules

# releases : http://www.oracle.com/technetwork/java/javase/archive-139210.html

feature_oracle-jdk() {
	FEAT_NAME=oracle-jdk
	FEAT_LIST_SCHEMA="8u152@x64:binary 8u152@x86:binary 8u91@x86:binary 8u91@x64:binary 8u45@x86:binary 8u45@x64:binary 7u80@x86:binary 7u80@x64:binary"
	FEAT_DEFAULT_ARCH=x64
	FEAT_DEFAULT_FLAVOUR=binary
}

feature_oracle-jdk_env() {
	export JAVA_HOME=$FEAT_INSTALL_ROOT
}



feature_oracle-jdk_8u152() {
	FEAT_VERSION=8u152

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-linux-i586.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86=jdk-8u152-linux-i586.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-linux-x64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u152-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-macosx-x64.dmg"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u152-macosx-x64.dmg
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP


		DMG_VOLUME_NAME="JDK 8 Update 152"
		PKG_NAME="JDK 8 Update 152.pkg"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_oracle-jdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_oracle-jdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}


feature_oracle-jdk_8u91() {
	FEAT_VERSION=8u91

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=
	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="http://download.oracle.com/otn/java/jdk/8u91-b14/jdk-8u91-linux-i586.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86=jdk-8u91-linux-i586.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u91-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/8u91-b14/jdk-8u91-macosx-x64.dmg"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u91-macosx-x64.dmg
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP


		DMG_VOLUME_NAME="JDK 8 Update 91"
		PKG_NAME="JDK 8 Update 91.pkg"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_oracle-jdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_oracle-jdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}


feature_oracle-jdk_8u45() {
	FEAT_VERSION=8u45

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="http://download.oracle.com/otn/java/jdk/8u45-b14/jdk-8u45-linux-i586.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86=jdk-8u45-linux-i586.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u45-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/8u45-b14/jdk-8u45-macosx-x64.dmg"
		FEAT_BINARY_URL_FILENAME_x64=jdk-8u45-macosx-x64.dmg
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP


		DMG_VOLUME_NAME="JDK 8 Update 45"
		PKG_NAME="JDK 8 Update 45.pkg"
	fi


	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_oracle-jdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_oracle-jdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"
}

#
feature_oracle-jdk_7u80() {
	FEAT_VERSION=7u80

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=


	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL_x86="http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-i586.tar.gz"
		FEAT_BINARY_URL_FILENAME_x86=jdk-7u80-linux-i586.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x86=HTTP_ZIP

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-linux-x64.tar.gz"
		FEAT_BINARY_URL_FILENAME_x64=jdk-7u80-linux-x64.tar.gz
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP_ZIP
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL_x86=
		FEAT_BINARY_URL_FILENAME_86=
		FEAT_BINARY_URL_PROTOCOL_x86=

		FEAT_BINARY_URL_x64="http://download.oracle.com/otn/java/jdk/7u80-b15/jdk-7u80-macosx-x64.dmg"
		FEAT_BINARY_URL_FILENAME_x64=jdk-7u80-macosx-x64.dmg
		FEAT_BINARY_URL_PROTOCOL_x64=HTTP


		DMG_VOLUME_NAME="JDK 7 Update 80"
		PKG_NAME="JDK 7 Update 80.pkg"
	fi

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=feature_oracle-jdk_fix_jni_header
	FEAT_ENV_CALLBACK=feature_oracle-jdk_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/java"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

# fix problems with jni_md.h
# http://stackoverflow.com/a/24996278
feature_oracle-jdk_fix_jni_header() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		ln -s $FEAT_INSTALL_ROOT/include/darwin/jni_md.h $FEAT_INSTALL_ROOT/include/jni_md.h
		ln -s $FEAT_INSTALL_ROOT/include/darwin/jawt_md.h $FEAT_INSTALL_ROOT/include/jawt_md.h
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		ln -s $FEAT_INSTALL_ROOT/include/linux/jni_md.h $FEAT_INSTALL_ROOT/include/jni_md.h
		ln -s $FEAT_INSTALL_ROOT/include/linux/jawt_md.h $FEAT_INSTALL_ROOT/include/jawt_md.h
	fi
}


feature_oracle-jdk_install_binary() {

	mkdir -p "$STELLA_APP_CACHE_DIR"
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ ! -f "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" ]; then
			type wget &>/dev/null && wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$FEAT_BINARY_URL" -O "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" \
			    ||  curl -j -k -S -L -H "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -o "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" "$FEAT_BINARY_URL"
			
		fi
		__uncompress "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"
	fi




	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		mkdir -p $STELLA_APP_TEMP_DIR

		# download
		if [ ! -f "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" ]; then
			curl -j -k -S -L -H "gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" -o "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME" "$FEAT_BINARY_URL"
		fi



		# mount dmg file and extract pkg file
		if [ ! -f "$STELLA_APP_CACHE_DIR/$PKG_NAME" ]; then
			hdiutil mount "$STELLA_APP_CACHE_DIR/$FEAT_BINARY_URL_FILENAME"
			cp "/Volumes/$DMG_VOLUME_NAME/$PKG_NAME" "$STELLA_APP_CACHE_DIR/$PKG_NAME"
			hdiutil unmount "/Volumes/$DMG_VOLUME_NAME"
		fi

		# unzip pkg file
		rm -Rf "$STELLA_APP_TEMP_DIR/$FEAT_VERSION"
		pkgutil --expand "$STELLA_APP_CACHE_DIR/$PKG_NAME" "$STELLA_APP_TEMP_DIR/$FEAT_VERSION/"

		# extract files from payload
		rm -Rf "$FEAT_INSTALL_ROOT"
		mkdir -p "$FEAT_INSTALL_ROOT"
		cd "$FEAT_INSTALL_ROOT"
		for payload in "$STELLA_APP_TEMP_DIR"/$FEAT_VERSION/jdk*; do
			tar xvzf "$payload/Payload"
		done
		__copy_folder_content_into "$FEAT_INSTALL_ROOT/Contents/Home" "$FEAT_INSTALL_ROOT"

		rm -Rf "$FEAT_INSTALL_ROOT/Contents"
		rm -Rf "$STELLA_APP_TEMP_DIR/$FEAT_VERSION"
	fi

	__feature_callback


}


fi
