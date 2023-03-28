if [ ! "$_qt_INCLUDED_" = "1" ]; then
_qt_INCLUDED_=1


#https://bitbucket.org/StudioEtrange/ryzomcore-script/src/b5b7fc357f33a46e894ab1ff97019ccb98ac3018/nix/lib_qt_build.sh?at=default&fileviewer=file-view-default
#https://github.com/cartr/homebrew-qt4
# TODO not finished
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/qt5.rb (not tested)

feature_qt() {
	FEAT_NAME=qt

	FEAT_LIST_SCHEMA="5_1_1:source 4_8_7:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_qt_4_8_7() {
	FEAT_VERSION=4_8_7

	FEAT_SOURCE_DEPENDENCIES="openssl#1_0_2k zlib#^1_2"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://download.qt.io/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_qt_link feature_qt48_patch_darwin"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/qt3to4
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_qt_link() {
	__link_feature_library "openssl#1_0_2k" "NO_SET_FLAGS GET_FLAGS _openssl"
	#__link_feature_library "freetype"
	__link_feature_library "zlib#^1_2" "NO_SET_FLAGS GET_FLAGS _zlib"
	#__link_feature_library "jpeg"

	#__link_feature_library "libpng" "NO_SET_FLAGS GET_FLAGS _libpng"
}

feature_qt48_patch_darwin() {
	# Backport of Qt5 commit to fix the fatal build error with Xcode 7, SDK 10.11.
	# https://code.qt.io/cgit/qt/qtbase.git/commit/?id=b06304e164ba47351fa292662c1e6383c081b5ca
  __get_resource "PATCH" "https://raw.githubusercontent.com/Homebrew/formula-patches/480b7142c4e2ae07de6028f672695eb927a34875/qt/el-capitan.patch" "HTTP" "$SRC_DIR" "FORCE_NAME el-capitan-480b7142c4e2ae07de6028f672695eb927a34875.patch"
	cd $SRC_DIR
	patch -Np1 < el-capitan-480b7142c4e2ae07de6028f672695eb927a34875.patch

	# Backport of Qt5 patch to fix an issue with null bytes in QSetting strings.
  __get_resource "PATCH" "https://raw.githubusercontent.com/cartr/homebrew-qt4/41669527a2aac6aeb8a5eeb58f440d3f3498910a/patches/qsetting-nulls.patch" "HTTP" "$SRC_DIR" "FORCE_NAME qsetting-nulls-41669527a2aac6aeb8a5eeb58f440d3f3498910a.patch"
	cd $SRC_DIR
	patch -Np1 < qsetting-nulls-41669527a2aac6aeb8a5eeb58f440d3f3498910a.patch
}

feature_qt_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"


	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "STRIP" #DEST_ERASE"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		#QMAKESPEC=macx-g++
		QMAKESPEC=unsupported/macx-clang
		# TODO 32 bits http://www.qtcentre.org/threads/40557-spec-to-use-when-compiling-for-32-bit-MacOS-X-on-Snow-Leopard-(no-macx-g-32-)
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ ! -z "$STELLA_BUILD_ARCH"]; then
			[ "$STELLA_BUILD_ARCH" = "x64" ] && QMAKESPEC=linux-g++-64
			[ "$STELLA_BUILD_ARCH" = "x86" ] && QMAKESPEC=linux-g++-32
		else
			[ "$STELLA_CPU_ARCH" = "64" ] && QMAKESPEC=linux-g++-64
			[ "$STELLA_CPU_ARCH" = "32" ] && QMAKESPEC=linux-g++-32
			# fallback to 32bits
			[ -z "$STELLA_CPU_ARCH" ] && QMAKESPEC=linux-g++-32
		fi
	fi

	# TODO : FREETYPE / FONTCONFIG
	# -no-fontconfig ..... Do not compile FontConfig (anti-aliased font) support.
 	# -fontconfig (DEFAULT) ........ Compile FontConfig support. Requires fontconfig/fontconfig.h, libfontconfig,freetype.h and libfreetype.


# TODO libtiff
# TODO libmng http://www.linuxfromscratch.org/blfs/view/cvs/general/libmng.html

	__feature_callback

	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX -cocoa"
		[ "$STELLA_BUILD_ARCH" = "x64" ] && AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX -arch x86_64"
		[ "$STELLA_BUILD_ARCH" = "x86" ] && AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX -arch x86"
	fi

	#__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	AUTO_INSTALL_CONF_FLAG_POSTFIX="-v -debug-and-release -stl -opensource -shared -no-qt3support -fast \
							-qt-zlib -qt-libpng -qt-libjpeg -qt-libmng -qt-libtiff -qt-freetype \
							-no-exceptions -nomake demos -nomake examples -confirm-license -prefix $INSTALL_DIR \
							-no-sql-mysql -no-sql-psql -no-sql-db2 -no-sql-ibase -no-sql-oci -no-sql-odbc -no-sql-tds -no-sql-sqlite -no-sql-sqlite2 \
							-no-dbus -no-phonon -no-webkit \
							-platform $QMAKESPEC \
							-openssl-linked $_openssl_CPP_FLAGS $_openssl_LINK_FLAGS $_zlib_CPP_FLAGS $_zlib_LINK_FLAGS"


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "INCLUDE_FILTER bin|lib|plugins EXCLUDE_FILTER .*debug.*"


}



fi
