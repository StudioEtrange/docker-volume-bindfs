if [ ! "$_clangomp_INCLUDED_" = "1" ]; then
_clangomp_INCLUDED_=1

# Clang OpenMP

# NOTE:
# LLVM is an unmbrella project and a common libs for several project
# Need CMake >= 3.4.3
# source code : http://llvm.org/docs/GettingStarted.html

# NOTE : On MacOSX : Do not install gnu autotools, problem with GNU libtool, because GNU autotools shadow xcode libtools
# https://github.com/Homebrew/legacy-homebrew/issues/28442


# Need python to build
feature_clang-omp() {
	FEAT_NAME=clang-omp
	FEAT_LIST_SCHEMA="3_9_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_clang-omp_3_9_0() {
	FEAT_VERSION=3_9_0


	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL="http://llvm.org/releases/3.9.0/llvm-3.9.0.src.tar.xz"
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_clang-omp_add_resource
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/clang-omp
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

	FEAT_ADD_RESOURCES_CLANG="http://llvm.org/releases/3.9.0/cfe-3.9.0.src.tar.xz"
	FEAT_ADD_RESOURCES_CLANG_TOOLS="http://llvm.org/releases/3.9.0/clang-tools-extra-3.9.0.src.tar.xz"
	FEAT_ADD_RESOURCES_PROJECTS="http://llvm.org/releases/3.9.0/libcxx-3.9.0.src.tar.xz libcxx \
	http://llvm.org/releases/3.9.0/compiler-rt-3.9.0.src.tar.xz compiler-rt \
	http://llvm.org/releases/3.9.0/openmp-3.9.0.src.tar.xz openmp \
	http://llvm.org/releases/3.9.0/libcxxabi-3.9.0.src.tar.xz libcxxabi"
}
#http://llvm.org/releases/3.9.0/test-suite-3.9.0.src.tar.xz \

feature_clang-omp_add_resource() {
	__get_resource "$FEAT_NAME" "$FEAT_ADD_RESOURCES_CLANG" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR/llvm/tools/clang" "DEST_ERASE STRIP"
	__get_resource "$FEAT_NAME" "$FEAT_ADD_RESOURCES_CLANG_TOOLS" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR/llvm/tools/clang/tools/extra" "DEST_ERASE STRIP"

	local _f=0
	local _url
	for t in $FEAT_ADD_RESOURCES_PROJECTS; do
		if [ "$_f" = "0" ]; then
			_url=$t
			_f=1
		else
			__get_resource "$FEAT_NAME" "$_url" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR/llvm/projects/$t" "DEST_ERASE STRIP"
			_f=0
		fi
	done

}

feature_clang-omp_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR/llvm" "DEST_ERASE STRIP"

	__set_toolset "NINJA"

	__set_build_mode "LINK_FLAGS_DEFAULT" "OFF"

  __feature_callback

	# TODO ?
	#[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && __set_build_mode "MACOSX_DEPLOYMENT_TARGET" "10.8"

  AUTO_INSTALL_CONF_FLAG_PREFIX=
  AUTO_INSTALL_CONF_FLAG_POSTFIX="-DLIBOMP_ARCH=x86_64 -DLLVM_ENABLE_LIBCXX=ON"
  AUTO_INSTALL_BUILD_FLAG_PREFIX=
  AUTO_INSTALL_BUILD_FLAG_POSTFIX=


	__auto_build "$FEAT_NAME" "$SRC_DIR/llvm" "$INSTALL_DIR" "SOURCE_KEEP"

	# TESTS -------
	cat > $SRC_DIR/hello.c << EOL
/* hello.c */
#include <omp.h>
#include <stdio.h>
int main() {
  	#pragma omp parallel
    printf("Hello from thread %d, nthreads %d\n", omp_get_thread_num(), omp_get_num_threads());
}
EOL

	cd $SRC_DIR
	LIBRARY_PATH=$INSTALL_DIR/lib:$LIBRARY_PATH \
	$INSTALL_DIR/bin/clang -fopenmp hello.c -o hello

	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && DYLD_LIBRARY_PATH=$INSTALL_DIR/lib ./hello
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && LD_LIBRARY_PATH=$INSTALL_DIR/lib ./hello


	ln -s "$INSTALL_DIR"/bin/clang "$INSTALL_DIR"/bin/clang-omp
	ln -s "$INSTALL_DIR"/bin/clang++ "$INSTALL_DIR"/bin/clang++-omp
	ln -s "$INSTALL_DIR"/bin/clang++ "$INSTALL_DIR"/bin/clang-omp++

	__del_folder "$SRC_DIR"
}


fi
