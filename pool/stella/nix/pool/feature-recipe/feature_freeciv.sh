if [ ! "$_freeciv_INCLUDED_" = "1" ]; then
_freeciv_INCLUDED_=1

# TODO
# https://github.com/Homebrew/homebrew-games/blob/master/freeciv.rb
# https://packages.debian.org/sid/freeciv-client-sdl
# need readline need libggz
# for freeciv module installer, use gtk or qt
# need ncurses ?
# linked against zlib and bz2 and iconv
# SDL client has less functionnality than gtk client ==> abandon sdl client which do not build
feature_freeciv() {
	FEAT_NAME=freeciv
	FEAT_LIST_SCHEMA="2_5_1:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_freeciv_2_5_1() {
	FEAT_VERSION=2_5_1

	FEAT_SOURCE_DEPENDENCIES="sdl#1_2_15 gettext#0_19_4 curl#7_36_0 sdl-mixer#1_2_12 sdl-image#1_2_12 sdl-gfx#2_0_25 sdl-ttf#2_0_11"
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=http://downloads.sourceforge.net/project/freeciv/Freeciv%202.5/2.5.1/freeciv-2.5.1.tar.bz2
	FEAT_SOURCE_URL_FILENAME=freeciv-2.5.1.tar.bz2
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=feature_freeciv_link
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/freeciv-sdl
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/

}

feature_freeciv_link() {

	__link_feature_library "gettext#0_19_4"

	__link_feature_library "curl#7_36_0" "GET_FLAGS _curl LIBS_NAME curl"
	export CURL_CFLAGS="$_curl_C_CXX_FLAGS $_curl_CPP_FLAGS"
	export CURL_LIBS="$_curl_LINK_FLAGS"

	__link_feature_library "sdl#1_2_15" "GET_FOLDER _sdl FORCE_INCLUDE_FOLDER include/SDL NO_SET_FLAGS LIBS_NAME SDL"
	AUTO_INSTALL_CONF_FLAG_POSTFIX="$AUTO_INSTALL_CONF_FLAG_POSTFIX --with-sdl-prefix=$_sdl_ROOT"

	__link_feature_library "sdl-mixer#1_2_12" "GET_FLAGS _mixer FORCE_INCLUDE_FOLDER include/SDL"
	#export SDLMIXER_CFLAGS="$_mixer_C_CXX_FLAGS $_mixer_CPP_FLAGS"
	#export SDLMIXER_LIBS="$_mixer_LINK_FLAGS"

	__link_feature_library "sdl-image#1_2_12" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-gfx#2_0_25" "FORCE_INCLUDE_FOLDER include/SDL"
	__link_feature_library "sdl-ttf#2_0_11" "FORCE_INCLUDE_FOLDER include/SDL"
}



feature_freeciv_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE STRIP"


	__set_toolset "STANDARD"

	__feature_callback

	AUTO_INSTALL_CONF_FLAG_PREFIX=
	AUTO_INSTALL_CONF_FLAG_POSTFIX="--disable-dependency-tracking --disable-debug \
	--enable-fcdb=no --enable-fcmp=no --enable-ipv6=yes --enable-client=sdl --enable-sdl-mixer=sdl --enable-aimodules=no \
	--enable-shared --enable-static --enable-aimodules=yes"
	# enable-fcmp : freeciv module pack installer/management : cannot be built with sdl
	AUTO_INSTALL_BUILD_FLAG_PREFIX=
	AUTO_INSTALL_BUILD_FLAG_POSTFIX=



	__auto_build "$FEAT_NAME" "$SRC_DIR" "$INSTALL_DIR" "SOURCE_KEEP BUILD_KEEP EXCLUDE_FILTER /share"



}
# = General build options =
#   Shared libraries:      no
#   Debugging support:     no
#   Profiling support:     no
#   IPv6 support:          yes
#   Map image toolkits:    auto
#     ppm:                   built-in
#     MagickWand:            no

#   = Client =
#   Build freeciv client:  yes

#   Maintained client frontends:
#     Gtk-2.0: no
#     Gtk-3.0: no
#     SDL:     yes
#     QT:      no
#     Stub:    no

#   Not maintained client frontends:
#     Xaw:     no

#   = Server =
#   Build freeciv server:  yes
#     AI modules support:    no
#     Database support:      no
#       mysql:                 no
#       postgres:              no
#       sqlite3:               no

#   = Tools =
#   Modpack installers:   none
#   Manual generator:      yes





# Optional Features:
#   --disable-option-checking  ignore unrecognized --enable/--with options
#   --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
#   --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
#   --enable-dependency-tracking
#                           do not reject slow dependency extractors
#   --disable-dependency-tracking
#                           speeds up one-time build
#   --enable-silent-rules   less verbose build output (undo: "make V=1")
#   --disable-silent-rules  verbose build output (undo: "make V=0")
#   --enable-fcdb=no/all/mysql/postgres/sqlite3
#                           database backends [no](no, or list)
#   --disable-server        do not compile the server
#   --enable-ipv6=yes/no/test
#                           use IPv6 [test]
#   --enable-mapimg=no/auto/magickwand
#                           additional map image toolkits to compile [auto](no,
#                           or list)
#   --enable-client=auto/all/gtk2/gtk3/sdl/xaw/qt/stub
#                           clients to compile [auto](list for multiple)
#   --enable-svnrev         get svn revision to version information
#   --enable-gitrev         get git revision to version information
#   --disable-make-data     do not recurse make into data directories
#   --enable-make-include   force make to recurse into include directory
#   --enable-aimodules=yes/no/experimental
#                           support for ai modules [no]
#   --enable-ai-static      statically link listed modules to server
#   --enable-shared[=PKGS]  build shared libraries [default=no]
#   --enable-static[=PKGS]  build static libraries [default=yes]
#   --enable-fast-install[=PKGS]
#                           optimize for fast installation [default=yes]
#   --disable-libtool-lock  avoid locking (might break parallel builds)
#   --disable-rpath         do not hardcode runtime library paths
#   --disable-nls           do not add localization support
#   --enable-debug[=no/some/yes/checks] turn on debugging [default=some]
#   --enable-gprof          turn on profiling [default=no]
#   --enable-crosser        build version to be used with crosser environment
#   --enable-sdl-mixer      use the SDL mixer [sdl]
#   --disable-sdltest       Do not try to compile and run a test SDL program
#   --disable-sdl2test       Do not try to compile and run a test SDL2 program
#   --disable-gtktest       do not try to compile and run a test GTK+ program
#        --disable-freetypetest  Do not try to compile and run a test FreeType
#                           program
#   --enable-noregistry     Do not register game modules.
#   --enable-fcmp=no/yes/gtk2/gtk3/qt/cli/all/auto
#                           build freeciv-modpack-program [auto]
#   --enable-sys-lua        use lua from system instead of one from freeciv tree
#                           [false]

# Optional Packages:
#   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
#   --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
#   --with-mysql-prefix=PFX Prefix where MySql is installed (optional)
#   --with-postgres-prefix=PFX Prefix where PostgreSQL is installed (optional)
#   --with-sqlite3-prefix=PFX Prefix where SQLite3 is installed (optional)
#   --with-readline         support fancy command line editing
#   --with-followtag        version tag to follow
#   --with-desktopdir       install desktop files to given dir
#   --with-appdatadir       install appdata files to given dir
#   --with-magickwand=DIR   Imagemagick installation directory (optional)
#   --with-xaw              use the Xaw widget set for the xaw client
#   --with-xaw3d            use the Xaw3d widget set for the xaw client
#   --with-efence           use Electric Fence, malloc debugger
#   --with-default-ai       default ai type [first static]
#   --with-ai-lib           build in default AI code [if needed]
#   --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
#                           both]
#   --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
#   --with-sysroot=DIR Search for dependent libraries within DIR
#                         (or the compiler's sysroot if not specified).
#   --with-gnu-ld           assume the C compiler uses GNU ld default=no
#   --with-libiconv-prefix[=DIR]  search for libiconv in DIR/include and DIR/lib
#   --without-libiconv-prefix     don't search for libiconv in includedir and libdir
#   --with-sdl-prefix=PFX   Prefix where SDL is installed (optional)
#   --with-sdl-exec-prefix=PFX Exec prefix where SDL is installed (optional)
#   --with-sdl2-prefix=PFX   Prefix where SDL2 is installed (optional)
#   --with-sdl2-exec-prefix=PFX Exec prefix where SDL2 is installed (optional)
#   --with-qt5-framework-bin
#                           path to binares of Qt5 framework (MacOS X,
#                           autodetected if wasn't specified)
#   --with-qt5-includes     path to Qt5 includes
#   --with-qt5-libs         path to Qt5 libraries
#        --with-ft-prefix=PREFIX Prefix where FreeType is installed (optional)
#        --with-ft-exec-prefix=PREFIX
#                           Exec prefix where FreeType is installed (optional)
#   --with-x                use the X Window System
#   --with-x-funcproto=DEFS Xfuncproto control definitions are DEFS
#                           (e.g.: --with-x-funcproto='FUNCPROTO=15 NARROWPROTO'
#   --with-xpm-prefix=DIR   Xpm files are in DIR/lib and DIR/include,
#                           or use the following to set them separately:
#   --with-xpm-lib=DIR      Xpm library is in DIR
#   --with-xpm-include=DIR  Xpm header file is in DIR (that is, DIR/X11/xpm.h)
#   --with-ggz-dir=DIR      Path to GGZ Gaming Zone
#   --with-libggz-dir=DIR   libggz installation prefix
#   --with-libggz-includes=DIR
#                           where the libggz includes are
#   --with-libggz-libraries=DIR
#                           where the libggz libs are
#   --with-ggz-client       Force GGZ client support
#   --with-ggzmod-dir=DIR   ggzmod installation prefix
#   --with-ggzmod-includes=DIR
#                           where the ggzmod includes are
#   --with-ggzmod-libraries=DIR
#                           where the ggzmod libs are
#   --with-ggzconfig=DIR    path to ggz-config
#   --with-ggz-gtk-dir=DIR  ggz-gtk installation prefix
#   --with-ggz-gtk-includes=DIR
#                           where the ggz-gtk includes are
#   --with-ggz-gtk-libraries=DIR
#                           where the ggz-gtk libs are
#   --with-ggz-server       Force GGZ server support
#   --with-ggzdmod-dir=DIR  ggzdmod installation prefix
#   --with-ggzdmod-includes=DIR
#                           where the ggzdmod includes are
#   --with-ggzdmod-libraries=DIR
#                           where the ggzdmod libs are
#   --with-ggzd-confdir=DIR directory for room/game data
#   --without-freeciv-manual
#                           do not build freeciv-manual
#   --with-missinglist      list missing features after configure

# Some influential environment variables:
#   MOCCMD      QT 5 moc command (autodetected it if not set)
#   CC          C compiler command
#   CFLAGS      C compiler flags
#   LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
#               nonstandard directory <lib dir>
#   LIBS        libraries to pass to the linker, e.g. -l<library>
#   CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
#               you have headers in a nonstandard directory <include dir>
#   CPP         C preprocessor
#   CXX         C++ compiler command
#   CXXFLAGS    C++ compiler flags
#   CXXCPP      C++ preprocessor
#   PKG_CONFIG  path to pkg-config utility
#   PKG_CONFIG_PATH
#               directories to add to pkg-config's search path
#   PKG_CONFIG_LIBDIR
#               path overriding pkg-config's built-in search path
#   CURL_CFLAGS C compiler flags for CURL, overriding pkg-config
#   CURL_LIBS   linker flags for CURL, overriding pkg-config
#   SDLMIXER_CFLAGS
#               C compiler flags for SDLMIXER, overriding pkg-config
#   SDLMIXER_LIBS
#               linker flags for SDLMIXER, overriding pkg-config
#   SDL2_CFLAGS C compiler flags for SDL2, overriding pkg-config
#   SDL2_LIBS   linker flags for SDL2, overriding pkg-config
#   SDL2MIXER_CFLAGS
#               C compiler flags for SDL2MIXER, overriding pkg-config
#   SDL2MIXER_LIBS
#               linker flags for SDL2MIXER, overriding pkg-config
#   XMKMF       Path to xmkmf, Makefile generator for X Window System
#   PNG_CFLAGS  C compiler flags for PNG, overriding pkg-config
#   PNG_LIBS    linker flags for PNG, overriding pkg-config
#   GTHREAD_CFLAGS
#               C compiler flags for GTHREAD, overriding pkg-config
#   GTHREAD_LIBS
#               linker flags for GTHREAD, overriding pkg-config
#   LUA_CFLAGS  C compiler flags for LUA, overriding pkg-config
#   LUA_LIBS    linker flags for LUA, overriding pkg-config

# Use these variables to override the choices made by `configure' or to help
# it to find libraries and programs with nonstandard names/locations.




fi
