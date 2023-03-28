if [ ! "$_ALLEGRO_INCLUDED_" = "1" ]; then
_ALLEGRO_INCLUDED_=1


# https://github.com/liballeg/allegro5

# need openal : but for macos use openal installed on system


# Library dependencies (from README.txt)
#- DirectX SDK (Windows only)
#- X11 development libraries (Linux/Unix only)
#- OpenGL development libraries (optional only on Windows)
# Addons dependencies
#- libpng and zlib
#- libjpeg
#- FreeType
#- Ogg Vorbis, a free lossy audio format. (libogg, libvorbis, libvorbisfile)
#- FLAC, a free lossless audio codec. (libFLAC, libogg)
#- DUMB, an IT, XM, S3M and MOD player library. (libdumb)
#- OpenAL, a 3D audio API.
#- PhysicsFS


feature_allegro() {
	FEAT_NAME=allegro
	FEAT_LIST_SCHEMA="5_0_11:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_allegro_5_0_11() {
	FEAT_VERSION=5_0_11
	FEAT_SOURCE_DEPENDENCIES="zlib#^1_2 freetype#2_6_0 libpng#1_6_17 jpeg#9_0_0 vorbis#1_3_5 libogg#DEV20150926 physfs#2_0_3 dumb#0_9_3 flac#1_3_1"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://sourceforge.net/projects/alleg/files/allegro/5.0.11/allegro-5.0.11.tar.gz
	FEAT_SOURCE_URL_FILENAME=allegro-5.0.11.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_allegro_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lib/liballegro-static.a
	FEAT_SEARCH_PATH=

}

feature_allegro_link() {
	__link_feature_library "freetype#2_6_0"
	__link_feature_library "zlib#^1_2" "FORCE_DYNAMIC"
	__link_feature_library "libpng#1_6_17"
	__link_feature_library "jpeg#9_0_0"
	__link_feature_library "vorbis#1_3_5"
	__link_feature_library "libogg#DEV20150926"
	__link_feature_library "physfs#2_0_3"
	__link_feature_library "dumb#0_9_3"
	__link_feature_library "flac#1_3_1"
}


feature_allegro_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"

	__set_toolset "CMAKE"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	# build static
	AUTO_INSTALL_CONF_FLAG_POSTFIX="-DSHARED=OFF -DWANT_DEMO=OFF -DWANT_EXAMPLES=OFF -DWANT_DOCS=OFF -DWANT_NATIVE_IMAGE_LOADER=OFF"
	# WANT_NATIVE_IMAGE_LOADER=OFF : use our version of jpeg, png
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP"



	# build shared
	AUTO_INSTALL_CONF_FLAG_POSTFIX="-DSHARED=ON -DWANT_DEMO=ON -DWANT_EXAMPLES=ON -DWANT_DOCS=OFF -DWANT_NATIVE_IMAGE_LOADER=OFF"
	# WANT_NATIVE_IMAGE_LOADER=OFF : use our version of jpeg, png
	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP BUILD_KEEP"



	# install demos and examples
	__copy_folder_content_into "$SRC_DIR/demos/" "$INSTALL_DIR/demos/"
	__copy_folder_content_into "$SRC_DIR-build/demos/" "$INSTALL_DIR/demos/"

	__copy_folder_content_into "$SRC_DIR/examples/" "$INSTALL_DIR/examples/"
	__copy_folder_content_into "$SRC_DIR-build/examples/" "$INSTALL_DIR/examples/"

	# examples are mislinked
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		__tweak_linked_lib "$INSTALL_DIR/examples" "INCLUDE_FILTER $SRC_DIR-build REL_LINK_FORCE ../lib"
		__tweak_linked_lib "$INSTALL_DIR/demos" "INCLUDE_FILTER $SRC_DIR-build REL_LINK_FORCE ../../../../../lib"
	fi

	# clean
	rm -Rf "$INSTALL_DIR"/demos/*/CMakeFiles
	rm -Rf "$INSTALL_DIR"/examples/CMakeFiles
	rm -Rf "$SRC_DIR"
	rm -Rf "$SRC_DIR-build"

	# inspect demos and examples
	__inspect_and_fix_build "$INSTALL_DIR/demos"
	__inspect_and_fix_build "$INSTALL_DIR/examples"





}



fi
