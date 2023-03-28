if [ ! "$_CURSEOFWAR_INCLUDED_" = "1" ]; then
_CURSEOFWAR_INCLUDED_=1

feature_curseofwar() {
	FEAT_NAME=curseofwar
	FEAT_LIST_SCHEMA="1_2_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}




feature_curseofwar_1_2_0() {
	FEAT_VERSION=1_2_0

	FEAT_SOURCE_DEPENDENCIES="sdl#1_2_15 ncurses#6_0"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/a-nikolaev/curseofwar/archive/v1.2.0.tar.gz
	FEAT_SOURCE_URL_FILENAME=curseofwar-v1.2.0.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_curseofwar_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/curseofwar-sdl
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/

}

feature_curseofwar_link() {
	__link_feature_library "sdl#1_2_15"
	__link_feature_library "ncurses#6_0"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX -DCURSES_NEED_NCURSES=TRUE"
	# TODO : PATCH STELLA to use found curses libs by cmake
	sed -i .bak 's,${COMMON_LIBS} ncurses,${COMMON_LIBS} ${CURSES_NCURSES_LIBRARY},' "$SRC_DIR/CMakeLists.txt"

}



feature_curseofwar_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


	# curse of war have problem on darwin when using install script with make build tool (cause of 'install -D' flag which not exist)
	# curse of war does not install when using cmake
	__set_toolset "CMAKE"


	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX=
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=

	__feature_callback


	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "NO_INSTALL NO_OUT_OF_TREE_BUILD SOURCE_KEEP"


	# install
	cp -f "$SRC_DIR/README" "$INSTALL_DIR/"
	cp -f "$SRC_DIR/LICENSE" "$INSTALL_DIR/"
	cp -f "$SRC_DIR/VERSION" "$INSTALL_DIR/"
	cp -f "$SRC_DIR/CHANGELOG" "$INSTALL_DIR/"

	# install binaries
	cp -f "$SRC_DIR/curseofwar-sdl" "$INSTALL_DIR/"
	cp -f "$SRC_DIR/curseofwar" "$INSTALL_DIR/"

	# install data
	__copy_folder_content_into "$SRC_DIR/images" "$INSTALL_DIR/images"
	__copy_folder_content_into "$SRC_DIR/pixmaps" "$INSTALL_DIR/pixmaps"

	# install man
	mkdir -p "$INSTALL_DIR/share/man/man6"
	sed "s/%VERSION%/$FEAT_VERSION/g" "$SRC_DIR/curseofwar-sdl.6" >"$INSTALL_DIR/share/man/man6/curseofwar-sdl.6"
	sed "s/%VERSION%/$FEAT_VERSION/g" "$SRC_DIR/curseofwar.6" > "$INSTALL_DIR/share/man/man6/curseofwar.6"

	# FIX from STELLA : create start up file -- because for SDL version data image files have to be in the current directory
	echo "#!/bin/bash" >"$INSTALL_DIR/curseofwar-sdl.sh"
	echo "_CURRENT_FILE_DIR=\"\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd )\"" >>"$INSTALL_DIR/curseofwar-sdl.sh"
	echo "_CURRENT_RUNNING_DIR=\"\$( cd \"\$( dirname \".\" )\" && pwd )\"" >>"$INSTALL_DIR/curseofwar-sdl.sh"
	echo "cd \"\$_CURRENT_FILE_DIR\"" >>"$INSTALL_DIR/curseofwar-sdl.sh"
	echo "\"\$_CURRENT_FILE_DIR/curseofwar-sdl\" \$@" >>"$INSTALL_DIR/curseofwar-sdl.sh"
	echo "cd \"\$_CURRENT_RUNNING_DIR\"" >>"$INSTALL_DIR/curseofwar-sdl.sh"
	chmod +x "$INSTALL_DIR/curseofwar-sdl.sh"


	__inspect_and_fix_build "$INSTALL_DIR" "EXCLUDE_FILTER /share/|/images/|/pixmaps/"
	__del_folder "$SRC_DIR"


}




fi
