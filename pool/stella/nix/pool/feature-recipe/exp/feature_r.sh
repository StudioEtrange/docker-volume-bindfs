if [ ! "$_R_INCLUDED_" = "1" ]; then
_R_INCLUDED_=1


# TODO DO NOT WORK


# for darwin : build a separate gfortran recipe with a bunch of dependencies see https://github.com/ros/homebrew-hydro/blob/master/gfortran.rb

# try to mimic recipe  installation from RRO (revolution r open) https://mran.revolutionanalytics.com/download/#download


feature_r() {
	FEAT_NAME=r
	FEAT_LIST_SCHEMA="3_2_2:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}




feature_r_3_2_2() {
	FEAT_VERSION=3_2_2

	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 bzip2#1_0_6 gmp#6_0_0a"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://cran.r-project.org/src/base/R-3/R-3.2.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=R-3.2.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && FEAT_SOURCE_CALLBACK="feature_r_link feature_r_darwin"
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && FEAT_SOURCE_CALLBACK="feature_r_link"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/R.framework/Resources/bin/R
	#FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/R.framework/Resources/bin # some files are in conflict with system files
	FEAT_SEARCH_PATH=
}

feature_r_link() {
	__link_feature_library "libpng#1_6_17" "FORCE_DYNAMIC"
	__link_feature_library "jpeg#9_0_0" "FORCE_DYNAMIC"
	__link_feature_library "gmp#6_0_0a" "FORCE_STATIC"
}


feature_r_darwin() {

	# tools and libs for R for darwin http://r.research.att.com/tools/
	# https://github.com/Homebrew/homebrew-science/blob/master/r.rb

	# gfortran
	# NOTE gfortran-4.2.3 recommanded by http://r.research.att.com/tools/ does not work
	# -- so we use gfortran 4.8.2 as recipe from R evolution R : https://github.com/RevolutionAnalytics/RRO/blob/fe7546d74b6306d23c14c58ffdf26e08ceed1d14/RRO-src/OSX/build-setup.sh

	# MAIN INSPIRATION : https://github.com/RevolutionAnalytics/RRO/blob/d9aca68f3231473c7cee28f065630c14efd61c74/RRO-src/OSX/build-OSX.sh
	# and https://github.com/RevolutionAnalytics/RRO/blob/fe7546d74b6306d23c14c58ffdf26e08ceed1d14/RRO-src/OSX/build-setup.sh


	# download
	__get_resource "gfortran darwin" "http://coudert.name/software/gfortran-5.2-Yosemite.dmg" "HTTP" "$STELLA_APP_CACHE_DIR"



	# mount dmg file and extract pkg file
	rm -Rf "$SRC_DIR"/gfortran
	mkdir -p "$SRC_DIR"/gfortran
	cd "$SRC_DIR"/gfortran
	hdiutil mount "$STELLA_APP_CACHE_DIR/gfortran-5.2-Yosemite.dmg"
	# TODO use function uncompress
	tar xzf "/Volumes/gfortran-5.2-Yosemite/gfortran-5.2-Yosemite/gfortran.pkg/Contents/Archive.pax.gz" --strip-components=4
	hdiutil unmount "/Volumes/gfortran-5.2-Yosemite"


	#mkdir -p $SRC_DIR/lib
	#cp $SRC_DIR/gfortran/lib/libquadmath.0.dylib $SRC_DIR/lib/
	#cp $SRC_DIR/gfortran/lib/libgfortran.3.dylib $SRC_DIR/lib/
	#cp $SRC_DIR/gfortran/lib/libgcc_s_x86_64.1.dylib $SRC_DIR/lib/
	#cp $SRC_DIR/gfortran/lib/libgcc_s.1.dylib $SRC_DIR/lib/

	__tweak_install_name_darwin "$SRC_DIR/gfortran/lib/libquadmath.0.dylib" "PATH"
	__tweak_install_name_darwin "$SRC_DIR/gfortran/lib/libgfortran.3.dylib" "PATH"
	__tweak_install_name_darwin "$SRC_DIR/gfortran/lib/libgcc_s_x86_64.1.dylib" "PATH"
	__tweak_install_name_darwin "$SRC_DIR/gfortran/lib/libgcc_s.1.dylib" "PATH"

	# TODO REVIEW
	__tweak_linked_lib "$SRC_DIR/gfortran/lib/libquadmath.0.dylib" "FIXED_PATH @loader_path INCLUDE_FILTER quadmath|gfortran|gcc"
	__tweak_linked_lib "$SRC_DIR/gfortran/lib/libgfortran.3.dylib" "FIXED_PATH @loader_path INCLUDE_FILTER quadmath|gfortran|gcc"
	__tweak_linked_lib "$SRC_DIR/gfortran/lib/libgcc_s_x86_64.1.dylib" "FIXED_PATH @loader_path INCLUDE_FILTER quadmath|gfortran|gcc"
	__tweak_linked_lib "$SRC_DIR/gfortran/lib/libgcc_s.1.dylib" "FIXED_PATH @loader_path INCLUDE_FILTER quadmath|gfortran|gcc"


	# env and clean
	AUTO_INSTALL_CONF_FLAG_POSTFIX="CC=clang CXX=clang++ OBJC=clang"
	PATH="$SRC_DIR/gfortran/bin:$PATH"
	STELLA_C_CXX_FLAGS="$STELLA_CPP_FLAGS -std=gnu99 -I$SRC_DIR/gfortran/include -I$SRC_DIR/gfortran/include/c++/5.2.0"
	STELLA_LINK_FLAGS="$STELLA_LINK_FLAGS -L$SRC_DIR/gfortran/lib"
	#export FFLAGS="-I$SRC_DIR/gfortran/include -I$SRC_DIR/gfortran/include/c++/5.2.0 -I$SRC_DIR/gfortran/lib/gcc/x86_64-apple-darwin14/5.2.0/include"
}


feature_r_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"



	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP NO_OUT_OF_TREE_BUILD"


}




fi
