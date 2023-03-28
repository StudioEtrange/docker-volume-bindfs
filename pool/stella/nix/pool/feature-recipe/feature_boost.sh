if [ ! "$_BOOST_INCLUDED_" = "1" ]; then
_BOOST_INCLUDED_=1

# code source : https://github.com/boostorg/boost
# Note for windows : http://stackoverflow.com/questions/7282645/how-to-build-boost-iostreams-with-gzip-and-bzip2-support-on-windows

# TODO Apply debian patch ? : https://packages.debian.org/sid/libboost1.60-dev
# TODO : NON_RELOCATE

feature_boost() {
	FEAT_NAME=boost
	FEAT_LIST_SCHEMA="1_61_0:source 1_59_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}



feature_boost_1_61_0() {
	FEAT_VERSION=1_61_0



	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 bzip2 openmpi#1_10_3 icu4c FORCE_ORIGIN_SYSTEM python"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://downloads.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.gz
	FEAT_SOURCE_URL_FILENAME=boost_1_61_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_boost_dep"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK="boost_set_env"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libboost_wave-mt.a
	FEAT_SEARCH_PATH=

}

feature_boost_1_59_0() {
	FEAT_VERSION=1_59_0


	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 bzip2 icu4c openmpi#1_10_3 FORCE_ORIGIN_SYSTEM python"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
	FEAT_SOURCE_URL_FILENAME=boost_1_59_0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK="feature_boost_dep"
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK="boost_set_env"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/libboost_wave-mt.a
	FEAT_SEARCH_PATH=

}


boost_set_env() {
	BOOST_ROOT="$FEAT_INSTALL_ROOT"
	export BOOST_ROOT="$FEAT_INSTALL_ROOT"
}


feature_boost_dep() {

	__link_feature_library "bzip2" "LIBS_NAME bz2 GET_FOLDER _bzip2 NO_SET_FLAGS"

	BZIP2_LIBPATH="$_bzip2_LIB"
	BZIP2_INCLUDE="$_bzip2_INCLUDE"

	__link_feature_library "zlib#^1_2" "GET_FOLDER _zlib NO_SET_FLAGS LIBS_NAME z"

	ZLIB_LIBPATH="$_zlib_LIB"
	ZLIB_INCLUDE="$_zlib_INCLUDE"

	__link_feature_library "openmpi#1_10_3" "GET_FOLDER _openmpi NO_SET_FLAGS"

	OPENMPI_BIN="$_openmpi_BIN"

	__link_feature_library "icu4c" "GET_FOLDER _icu NO_SET_FLAGS"

	ICU_ROOT="$_icu_ROOT"

}

feature_boost_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"



	# NOTE 1 :
	# boost do NOT depend on Boost.Build
	# Boost have its own embedded version of Boost.Build. If we do not want that, precise --with-bjam=<path> when building

	# NOTE 2 :
	# classic env var are not used to set flags during building. We have to use feature spassed to b2 :
	# cflags, cxxflags, linkflags
	# The value of those features is passed without modification to the corresponding tools.
	# For cflags that is both the C and C++ compilers,
	# for cxxflags that is the C++ compiler
	# and for linkflags that is the linker.
	# http://www.boost.org/build/doc/html/bbv2/overview/builtins/features.html


	# PROBLEM 1
	# building Boost.MPI with shared, static, single thread and multi thread do not work, we have to split builds in THREE steps
	# splitting single and multi thread builds
	# https://svn.boost.org/trac/boost/ticket/8841

	# PROBLEM 2
	# on darwin install_name values are not well fixed during build https://fairroot-redmine.gsi.de/issues/58
	# due to configuration in darwin.jam and clang-darwin.jam
	# bug exist until in 1.59. Starting 1.59 install_name is fixed with @rpath value but ONLY if toolset is clang !
 	# so we need to force clang toolset (instead of g++ detected toolset on darwin, which in fact is clang)
	# NOTE : for previous version like 1.58 we have to hack clang-darwin.jam file OR tweak install_name and linked lib after build

	# PROBLEM 3
	# auto detected values for python libs are fucked up. we have to set them ourself

	# PROBLEM 4
	# some boost cannot be built depending on arch or on system
	# lib context, coroutine and log



	# TODO embed libc
	#./b2 runtime-link=static|shared
  #                        Whether to link to static or shared C and C++
  #                        runtime.



	# ---------------------------------------------------------------
	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "STANDARD"

	# NOTE : do not use this
	#__set_build_mode "DARWIN_STDLIB" "LIBSTDCPP"

	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"
	__set_build_mode "OPTIMIZATION" ""



	local _arch
	if [ ! "$STELLA_BUILD_ARCH" = "" ]; then
		_arch="address-model=$STELLA_BUILD_ARCH"
	fi

	# PROBLEM 2
	local _toolset
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		_toolset="--with-toolset=clang"
		__set_build_mode "RPATH" "ADD_FIRST" "@loader_path"
		# TODO : for linux, use $ORIGIN ?
		# __set_build_mode "RPATH" "ADD_FIRST" '$ORIGIN'
	fi

	__feature_callback

	__start_manual_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR"





	# PROBLEM 4
	local without_lib_base
	# The context library is implemented as x86_64 ASM, so it
  # won't build on PPC or 32-bit builds
  if [ ! "$STELLA_CPU_ARCH" = "64" ]; then
  	without_lib_base="$without_lib_base,context,coroutine"
  fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
	# Boost.Log cannot be built using Apple GCC at the moment. Disabled (see brew formula)
		without_lib_base="$without_lib_base,log"
	fi


	# NOTE 2 : Flags
	local _cflags="$(__trim "$STELLA_C_CXX_FLAGS $STELLA_CPP_FLAGS")"
	local _cxxflags="$(__trim "$STELLA_C_CXX_FLAGS $STELLA_CPP_FLAGS")"
	local _linkflags="$(__trim "$STELLA_LINK_FLAGS")"
	[ ! "$_cflags" = "" ] && _cflags="cflags=$_cflags"
	[ ! "$_cxxflags" = "" ] && _cxxflags="cxxflags=$_cxxflags"
	[ ! "$_linkflags" = "" ] && _linkflags="linkflags=$_linkflags"


	# PROBLEM 1
	# FIRST STEP : Building All (except python) with single thread ----
	local without_lib="$(echo $without_lib_base,python | sed s/^,//)"
	# building Boost.MPI require a user-config.jam
	echo "using mpi : $OPENMPI_BIN/mpicc ;" > "$SRC_DIR/user-config.jam"
	cd "$SRC_DIR"
	./bootstrap.sh --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" --with-icu="$ICU_ROOT" --without-libraries="$without_lib" $_toolset
	./b2 --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" -d2 -j$STELLA_NB_CPU --layout=tagged install threading=single link=shared,static \
	"$_arch" "$_cflags" "$_cxxflags" "$_linkflags" \
	-sBZIP2_INCLUDE="$BZIP2_INCLUDE" -sBZIP2_LIBPATH="$BZIP2_LIBPATH" -sZLIB_INCLUDE="$ZLIB_INCLUDE" -sZLIB_LIBPATH="$ZLIB_LIBPATH" \
	--debug-configuration --user-config="$SRC_DIR/user-config.jam"

	# SECOND STEP : Building All (except python) with multi thread ----
	cd "$SRC_DIR"
	./bootstrap.sh --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" --with-icu="$ICU_ROOT" --without-libraries="$without_lib" $_toolset
	./b2 --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" -d2 -j$STELLA_NB_CPU --layout=tagged install threading=multi link=shared,static \
	"$_arch" "$_cflags" "$_cxxflags" "$_linkflags" \
	-sBZIP2_INCLUDE="$BZIP2_INCLUDE" -sBZIP2_LIBPATH="$BZIP2_LIBPATH" -sZLIB_INCLUDE="$ZLIB_INCLUDE" -sZLIB_LIBPATH="$ZLIB_LIBPATH" \
	--debug-configuration --user-config="$SRC_DIR/user-config.jam" "$_flags"




	# THIRD STEP : Building python single and multi ------
	# http://stackoverflow.com/questions/15136671/unable-to-build-boost-python
	# https://github.com/ianblenke/homebrew-taps/blob/master/boost-python.rb
	echo "using mpi : $OPENMPI_BIN/mpicc ;" > "$SRC_DIR/user-config.jam"

	# PROBLEM 3
	_pyconfig_path="$(dirname $(__python_get_pyconfig))"
	_python_ver="$(__python_short_version)"
	if [ ! -f $_pyconfig_path/pyconfig.h ]; then
		echo "WARN -- not building python -- missing python headers"
	else

		cd "$SRC_DIR"
		./bootstrap.sh --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" --with-icu="$ICU_ROOT" --with-libraries="python" $_toolset

		# disable auto detected values for python
		sed -i".bak" "s/using python/#using python/" $SRC_DIR/project-config.jam
	 	# inject wanted version
		# using python 			 	: two digit version
		#                     : python binary path
	  #                     : python include folder
	  #                     : python lib folder


		echo "using python : $_python_ver : $(which python) : $_pyconfig_path : $(__python_get_lib_path) ;" >> "$SRC_DIR/user-config.jam"

		# NOTE to insert several python versions use this example :
		# for pyver in $(pyversions); do \
		# 	echo "using python : $$pyver : /usr ;" >> user-config.jam; \
		# done
		# AND USE :
		#./b2 ... --python-buildid=$_python_ver

		./b2 --prefix="$INSTALL_DIR" --libdir="$INSTALL_DIR/lib" --includedir="$INSTALL_DIR/include" -d2 -j$STELLA_NB_CPU --layout=tagged install threading=multi,single link=shared,static \
		"$_arch" "$_cflags" "$_cxxflags" "$_linkflags" \
		-sBZIP2_INCLUDE="$BZIP2_INCLUDE" -sBZIP2_LIBPATH="$BZIP2_LIBPATH" -sZLIB_INCLUDE="$ZLIB_INCLUDE" -sZLIB_LIBPATH="$ZLIB_LIBPATH" \
		--debug-configuration --user-config="$SRC_DIR/user-config.jam" "$_flags"
	fi


	__del_folder "$SRC_DIR"

	# we fix rpath and install name values as absolute path, to be clean
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		# TODO : NON_RELOCATE
		__tweak_binary_file "$FEAT_INSTALL_ROOT/lib" "NON_RELOCATE"
	fi

	__inspect_and_fix_build "$FEAT_INSTALL_ROOT/lib"


	__end_manual_build
}


fi
