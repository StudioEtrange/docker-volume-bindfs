if [ ! "$_OPENSSL_INCLUDED_" = "1" ]; then
_OPENSSL_INCLUDED_=1

# TODO
# When building from source : Require perl (from system is enough), to configure source code
# Require system "build-system"
# build with an arch

# NOTE : On darwin openssl lib in lib/engines folder does not have LC_ID_DYLIB

# TODO finished binaries version
# NOTE :
# binaries version are retrieved from conan.io repository conan-center
# https://bintray.com/conan-community/conan/OpenSSL%3Aconan
# https://github.com/conan-community/conan-openssl

# To inspect openssl binaries from conan-center repository :
# List all available versions from connan
#				conan search OpenSSL -r=conan-center
# List all available binaries with compilated options
#				conan search OpenSSL/1.0.2o@conan/stable -r=conan-center
#				conan search OpenSSL/1.0.2o@conan/stable -r=conan-center --table openssl.html
# List with filters
# 			conan search OpenSSL/1.0.2o@conan/stable -r=conan-center -q 'build_type=Release AND arch=x86_64 AND os=Macos AND compiler=apple-clang AND shared=True'
# Get info and dependencies
#				conan info OpenSSL/1.0.2o@conan/stable -r conan-center
# Create a default profile depending on the current platform
#				conan profile new default --detect

# To identify URL of the tar.gz use search :
#			conan search OpenSSL/1.0.2o@conan/stable -r=conan-center -q 'shared=True AND build_type=Release AND arch=x86_64 AND os=Macos'
#			retrieve Package_ID matching compiler and compiler.version
#			find this Package_ID here https://bintray.com/conan-community/conan/OpenSSL%3Aconan/1.0.2o%3Astable#files/conan%2FOpenSSL%2F1.0.2o%2Fstable%2Fpackage

# Options for downloaded openssl from conan-center
# no_sse2=False
# no_threads=False
# no_cast=False
# 386=False
# no_md5=False
# no_sha=False
# no_dh=False
# no_asm=False
# no_rsa=False
# no_dsa=False
# no_rc5=False
# no_zlib=False
# shared=False
# no_rc4=False
# no_md2=False
# no_rc2=False
# no_bf=False
# no_hmac=False
# no_des=False
# no_mdc2=False

# 1_0_2o@x64:binary 1_0_2o@x86:binary

feature_openssl() {
	FEAT_NAME="openssl"
	FEAT_LIST_SCHEMA="1_1_1k:source 1_0_2k:source 1_0_2d:source"
	FEAT_DEFAULT_ARCH=""
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="OpenSSL is a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols."
	FEAT_LINK="https://www.openssl.org/"
}






feature_openssl_1_1_1k() {
	FEAT_VERSION="1_1_1k"

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.openssl.org/source/openssl-1.1.1k.tar.gz"
	FEAT_SOURCE_URL_FILENAME="openssl-1.1.1k.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_openssl_link feature_openssl_options_1_1_1"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/openssl"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_openssl_1_0_2k() {
	FEAT_VERSION="1_0_2k"

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.openssl.org/source/openssl-1.0.2k.tar.gz"
	FEAT_SOURCE_URL_FILENAME="openssl-1.0.2k.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_openssl_link feature_openssl_options_1_0_2"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/openssl"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_openssl_1_0_2d() {
	FEAT_VERSION="1_0_2d"

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="https://www.openssl.org/source/openssl-1.0.2d.tar.gz"
	FEAT_SOURCE_URL_FILENAME="openssl-1.0.2d.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_openssl_link feature_openssl_options_1_0_2"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/openssl"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}

feature_openssl_link() {
	# zlib dependencies
	__link_feature_library "zlib" "LIBS_NAME z GET_FLAGS _zlib FORCE_DYNAMIC NO_SET_FLAGS"
}


feature_openssl_options_1_0_2() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		OPENSSL_OPT="shared no-idea no-mdc2 no-rc5 enable-ssl2 enable-tlsext enable-cms"
		if [ "$ARCH" = "x64" ]; then
			OPENSSL_OPT="$OPENSSL_OPT enable-ec_nistp_64_gcc_128"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		OPENSSL_OPT="shared no-idea no-mdc2 no-rc5 enable-ssl2 enable-tlsext enable-cms enable-krb5"	
	fi

}

feature_openssl_options_1_1_1() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		OPENSSL_OPT="shared no-idea no-mdc2 no-rc5 enable-ssl2 enable-cms"
		if [ "$ARCH" = "x64" ]; then
			OPENSSL_OPT="$OPENSSL_OPT enable-ec_nistp_64_gcc_128"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		OPENSSL_OPT="shared no-idea no-mdc2 no-rc5 enable-ssl2 enable-cms"	
	fi
}

feature_openssl_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__require "perl" "perl" "SYSTEM"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	ARCH=$STELLA_BUILD_ARCH
	[ "$ARCH" = "" ] && ARCH="x64"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		[ "$ARCH" = "x86" ] && OPENSSL_PLATFORM="darwin-i386-cc"
		if [ "$ARCH" = "x64" ]; then
			OPENSSL_PLATFORM="darwin64-x86_64-cc"
		fi
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		[ "$ARCH" = "x86" ] && OPENSSL_PLATFORM="linux-generic32"
		[ "$ARCH" = "x64" ] && OPENSSL_PLATFORM="linux-x86_64"
	fi

	__feature_callback

	__start_manual_build "openssl" "$SRC_DIR" "$INSTALL_DIR"

	cd "$SRC_DIR"
	# configure --------------------------------
	# http://stackoverflow.com/questions/16601895/how-can-one-build-openssl-on-ubuntu-with-a-specific-version-of-zlib
	# zlib zlib-dynamic --with-zlib-lib and --with-zlib-include do not work properly to link openssl against a specific zlib version
	# 		so we use direct flag -Ixxx -Lxxx -lxxx, with zlib before (in this case use "zlib" either when linking static or dynamic)
	perl "Configure" $OPENSSL_OPT \
		zlib $_zlib_CPP_FLAGS $_zlib_C_CXX_FLAGS $_zlib_LINK_FLAGS \
		--openssldir=$INSTALL_DIR/etc/ssl --libdir=lib --prefix=$INSTALL_DIR \
		$OPENSSL_PLATFORM

	# build --------------------------------
	$STELLA_API del_folder $INSTALL_DIR/share/man/openssl

	make depend
	make -j$STELLA_NB_CPU all

	make MANDIR=$INSTALL_DIR/share/man/openssl MANSUFFIX=ssl install
	# TODO : 'make test' do not work if we build for a different architecture than the host
	#[ "$ARCH" = "x64" ] && make test

	__end_manual_build

	# clean --------------------------------
	cd "$INSTALL_DIR"
	rm -Rf "$SRC_DIR"

	__inspect_and_fix_build "$INSTALL_DIR" "EXCLUDE_FILTER /share/"
}


fi
