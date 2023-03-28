#!sh
if [ ! "$_STELLA_COMMON_BUILD_TOOLSET_INCLUDED_" = "1" ]; then
_STELLA_COMMON_BUILD_TOOLSET_INCLUDED_=1


# TOOLSET ------------------------------------------------------------------------------------------------------------------------------
__toolset_install() {
	local _save_STELLA_APP_FEATURE_ROOT=$STELLA_APP_FEATURE_ROOT
	local _save_FORCE=$FORCE
	FORCE=
	STELLA_APP_FEATURE_ROOT=$STELLA_INTERNAL_TOOLSET_ROOT
	(__feature_install "$1" "NON_DECLARED")
	STELLA_APP_FEATURE_ROOT=$_save_STELLA_APP_FEATURE_ROOT
	FORCE=$_save_FORCE
}



__toolset_info() {
	__push_schema_context
	local _save_STELLA_APP_FEATURE_ROOT=$STELLA_APP_FEATURE_ROOT
	STELLA_APP_FEATURE_ROOT=$STELLA_INTERNAL_TOOLSET_ROOT
	__feature_info "$1" "TOOLSET"
	STELLA_APP_FEATURE_ROOT=$_save_STELLA_APP_FEATURE_ROOT
	__pop_schema_context
}

__toolset_init() {
	local _SCHEMA=$1
	__push_schema_context
	local _save_STELLA_APP_FEATURE_ROOT=$STELLA_APP_FEATURE_ROOT
	STELLA_APP_FEATURE_ROOT=$STELLA_INTERNAL_TOOLSET_ROOT


	__internal_feature_context "$_SCHEMA"
	__feature_inspect "$FEAT_SCHEMA_SELECTED"

	if [ "$TEST_FEATURE" = "1" ]; then
		if [ ! "$FEAT_BUNDLE" = "" ]; then
			local p
			__push_schema_context

			FEAT_BUNDLE_MODE=$FEAT_BUNDLE
			for p in $FEAT_BUNDLE_ITEM; do
				__internal_feature_context $p
				if [ ! "$FEAT_SEARCH_PATH" = "" ]; then
					STELLA_BUILD_TOOLSET_PATH="$FEAT_SEARCH_PATH:$STELLA_BUILD_TOOLSET_PATH"
				fi
				for c in $FEAT_ENV_CALLBACK; do
					$c
				done
			done
			FEAT_BUNDLE_MODE=
			__pop_schema_context
		fi

		if [ ! "$FEAT_SEARCH_PATH" = "" ]; then
			STELLA_BUILD_TOOLSET_PATH="$FEAT_SEARCH_PATH:$STELLA_BUILD_TOOLSET_PATH"
		fi
		local c
		# TODO : warn : env vars should be uninitialized later because use of a toolset is temporary
		for c in $FEAT_ENV_CALLBACK; do
			$c
		done
	fi
	STELLA_APP_FEATURE_ROOT=$_save_STELLA_APP_FEATURE_ROOT
	__pop_schema_context
}

# check some toolset features availability
__check_toolset() {
	STELLA_BUILD_CHECK_TOOLSET="$STELLA_BUILD_CHECK_TOOLSET $1"
}

__add_toolset() {
	local _SCHEMA=$1
	STELLA_BUILD_EXTRA_TOOLSET="$STELLA_BUILD_EXTRA_TOOLSET $_SCHEMA"
}

__set_toolset() {
	local MODE="$1"
	local OPT="$2"


	STELLA_BUILD_CONFIG_TOOL_SCHEMA=
	STELLA_BUILD_BUILD_TOOL_SCHEMA=
	STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=

	case $MODE in
		CUSTOM)
			STELLA_BUILD_TOOLSET=CUSTOM
			local _flag_configure=
			local _flag_frontend=
			local _flag_build=
			for o in $OPT; do
				[ "$_flag_configure" = "ON" ] && STELLA_BUILD_CONFIG_TOOL_SCHEMA=$o && _flag_configure=OFF
				[ "$o" = "CONFIG_TOOL" ] && _flag_configure=ON
				[ "$_flag_build" = "ON" ] && STELLA_BUILD_BUILD_TOOL_SCHEMA=$o && _flag_build=OFF
				[ "$o" = "BUILD_TOOL" ] && _flag_build=ON
				[ "$_flag_frontend" = "ON" ] && STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=$o && _flag_frontend=OFF
				[ "$o" = "COMPIL_FRONTEND" ] && _flag_frontend=ON
			done
			;;

		NONE)
			STELLA_BUILD_TOOLSET=NONE
			STELLA_BUILD_CONFIG_TOOL_SCHEMA=
			STELLA_BUILD_BUILD_TOOL_SCHEMA=
			STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=
			;;

		AUTOTOOLS)
			echo "********* DEPRECATED use __add_toolset autotools *******************"
			exit
			;;

		STANDARD)
			STELLA_BUILD_TOOLSET=STANDARD
			STELLA_BUILD_CONFIG_TOOL_SCHEMA=configure
			STELLA_BUILD_BUILD_TOOL_SCHEMA=make
			STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=default
			;;
		CMAKE)
			STELLA_BUILD_TOOLSET=CMAKE
			STELLA_BUILD_CONFIG_TOOL_SCHEMA=cmake
			STELLA_BUILD_BUILD_TOOL_SCHEMA=make
			STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=default
			;;
		NINJA)
			STELLA_BUILD_TOOLSET=NINJA
			STELLA_BUILD_CONFIG_TOOL_SCHEMA=cmake
			STELLA_BUILD_BUILD_TOOL_SCHEMA=ninja
			STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=default
			;;
	esac

	# TODO autoselect ninja instead of make if using cmake


	case $STELLA_BUILD_CONFIG_TOOL_SCHEMA in
		configure)
			STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY=configure
			STELLA_BUILD_CONFIG_TOOL=configure
		;;
		cmake*)
			STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY=cmake
			STELLA_BUILD_CONFIG_TOOL=cmake
			;;
		autotools*)
			echo "********* DEPRECATED *******************"
			;;
	esac

	case $STELLA_BUILD_BUILD_TOOL_SCHEMA in
		make)
			STELLA_BUILD_BUILD_TOOL_BIN_FAMILY=make
			STELLA_BUILD_BUILD_TOOL=make
		;;
		ninja*)
			STELLA_BUILD_BUILD_TOOL_BIN_FAMILY=ninja
			STELLA_BUILD_BUILD_TOOL=ninja
		;;
	esac

	# STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY has an impact on flag passed to compiler
	case $STELLA_BUILD_COMPIL_FRONTEND_SCHEMA in
		default)
			# NOTE : we use gcc binary as default compiler driver/front end
			#				on macos, gcc binary is in fact clang.
			#				So in default mode on linux, gcc will be used, on darwin, clang will be used
			STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY=gcc
			STELLA_BUILD_COMPIL_FRONTEND=default
		;;
		clang-omp*)
			# TODO : create a 'clang' binary family ? but clang and gcc are kind of same family
			STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY=gcc
			STELLA_BUILD_COMPIL_FRONTEND=clang-omp
		;;
		gcc*)
			STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY=gcc
			STELLA_BUILD_COMPIL_FRONTEND=gcc
		;;
	esac



}


__enable_current_toolset() {
	echo "** Require build toolset : $STELLA_BUILD_TOOLSET [ config tool schema : $STELLA_BUILD_CONFIG_TOOL_SCHEMA build tool schema : $STELLA_BUILD_BUILD_TOOL_SCHEMA compil frontend schema : $STELLA_BUILD_COMPIL_FRONTEND_SCHEMA ]"

	case $STELLA_BUILD_CONFIG_TOOL_SCHEMA in
		"")
		;;
		configure)
		;;
		cmake)
			# if no version specified, prefer cmake already present on system
			if [ "$(which cmake 2>/dev/null)" = "" ]; then
				__toolset_install "$STELLA_BUILD_CONFIG_TOOL_SCHEMA"
				__toolset_init "$STELLA_BUILD_CONFIG_TOOL_SCHEMA"
			fi
			;;
		cmake*)
			__toolset_install "$STELLA_BUILD_CONFIG_TOOL_SCHEMA"
			__toolset_init "$STELLA_BUILD_CONFIG_TOOL_SCHEMA"
			;;
		*)
			echo "********* ERROR UNSUPPORTED STELLA_BUILD_CONFIG_TOOL_SCHEMA : $STELLA_BUILD_CONFIG_TOOL_SCHEMA *******************"
			;;
	esac

	case $STELLA_BUILD_BUILD_TOOL in
		"")
		;;
		make)
			__require "make" "build-chain-standard" "SYSTEM"
		;;
		ninja)
			__toolset_install "$STELLA_BUILD_BUILD_TOOL_SCHEMA"
			__toolset_init "$STELLA_BUILD_BUILD_TOOL_SCHEMA"
		;;
		*)
			echo "********* ERROR UNSUPPORTED STELLA_BUILD_BUILD_TOOL_SCHEMA : $STELLA_BUILD_BUILD_TOOL_SCHEMA *******************"
			;;
	esac




	case $STELLA_BUILD_COMPIL_FRONTEND in
		"")
		;;
		default)
			# NOTE : will look for gcc (or clang on macos)
			__require "gcc" "build-chain-standard" "SYSTEM"
		;;
		clang-omp)
			__toolset_install "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
			__toolset_init "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"

		;;
		gcc)
		 	__translate_schema "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA" "_REQUIRED_TOOLSET_NAME" "_REQUIRED_TOOLSET_VER"
			local _install_gcc

			if $(type gcc &>/dev/null); then
				_install_gcc=0

				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					if [ "$(__gcc_is_clang)" = "1" ]; then
						_install_gcc=1
					fi
				fi
				if [ ! "$_REQUIRED_TOOLSET_VER" = "" ]; then
					if [ "$(__gcc_check_min_version "$_REQUIRED_TOOLSET_VER")" = "0" ]; then
						_install_gcc=1
					fi
				fi
			else
				_install_gcc=1
			fi

			if [ "$_install_gcc" = "1" ]; then
				__toolset_install "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
				__toolset_init "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
			fi

		;;
		*)
			echo "********* ERROR UNSUPPORTED STELLA_BUILD_COMPIL_FRONTEND_SCHEMA : $STELLA_BUILD_COMPIL_FRONTEND_SCHEMA *******************"
			;;
	esac

	echo



	echo "** Require build toolset : $STELLA_BUILD_TOOLSET [ config tool schema : $STELLA_BUILD_CONFIG_TOOL_SCHEMA build tool schema : $STELLA_BUILD_BUILD_TOOL_SCHEMA compil frontend schema : $STELLA_BUILD_COMPIL_FRONTEND_SCHEMA ]"

	echo "** Require extra toolset : $STELLA_BUILD_EXTRA_TOOLSET"
	for s in $STELLA_BUILD_EXTRA_TOOLSET; do
		__toolset_install "$s"
		__toolset_init "$s"
	done
	echo

	echo "** All toolset are installed"

	echo "** Set toolsets search path"
	_save_path_CURRENT_TOOLSET="$PATH"
	PATH="$STELLA_BUILD_TOOLSET_PATH:$PATH"




	echo "** Check from build toolset feature availability: $STELLA_BUILD_CHECK_TOOLSET"
	for c in $STELLA_BUILD_CHECK_TOOLSET; do
		case "$c" in
			"C++")
				case $STELLA_BUILD_COMPIL_FRONTEND in
					default)
						if [ "$(which g++ 2>/dev/null)" = "" ] && [ "$(which clang++ 2>/dev/null)" = "" ]; then
							echo "** ERROR : missing g++ or clang++"
							echo "** Try stella.sh sys install build-chain-standard OR your regular OS package manager"
							exit 1
						fi
					;;
					clang-omp)
						if [ "$(which clang++-omp 2>/dev/null)" = "" ]; then
							echo "** ERROR : missing clang++ for clang-omp"
							exit 1
						fi
					;;
					gcc)
						if [ "$(which g++ 2>/dev/null)" = "" ]; then
							echo "** ERROR : missing g++ for gcc"
							__toolset_install "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
							__toolset_init "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
						fi
					;;
				esac
				echo "==> C++ compiler available."
			;;
		esac
	done


	echo "** Some informations about toolset"
	case $STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY in
		gcc)
			echo "===> default linker search path"
			# TODO could depend on arch
			__default_linker_search_path
			if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
				echo "===> gcc hardcoded libraries search (-L flag)"
				__gcc_linker_search_path
			fi
	esac
	if $(type pkg-config &>/dev/null); then
		echo "===> pkg-config default search path"
		__pkgconfig_search_path
	fi




	echo "** Init specific toolset env var"
	case $STELLA_BUILD_COMPIL_FRONTEND in
		default)
		;;
		clang-omp)
			__toolset_info "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
			if [ "$TOOLSET_TEST_FEATURE" = "1" ]; then
				export CC=$TOOLSET_FEAT_INSTALL_ROOT/bin/clang
				export CXX=$TOOLSET_FEAT_INSTALL_ROOT/bin/clang++
				# activate clang openmp libs search folder at link time
				export LIBRARY_PATH="$LIBRARY_PATH:$TOOLSET_FEAT_INSTALL_ROOT/lib"
				# add a search path for clang openmp libs at runtime
				__set_build_mode "RPATH" "ADD_FIRST" "$TOOLSET_FEAT_INSTALL_ROOT/lib"
			fi
		;;

		gcc)
			__toolset_info "$STELLA_BUILD_COMPIL_FRONTEND_SCHEMA"
			if [ "$TOOLSET_TEST_FEATURE" = "1" ]; then
				export CC=$TOOLSET_FEAT_INSTALL_ROOT/bin/gcc
				export CXX=$TOOLSET_FEAT_INSTALL_ROOT/bin/g++
				# activate gcc libs search folder at link time
				export LIBRARY_PATH="$LIBRARY_PATH:$TOOLSET_FEAT_INSTALL_ROOT/lib"
				# add a search path for gcc libs at runtime
				__set_build_mode "RPATH" "ADD_FIRST" "$TOOLSET_FEAT_INSTALL_ROOT/lib"
			fi
		;;
	esac





}


__disable_current_toolset() {
	echo "** Disable current toolset path"
	PATH="$_save_path_CURRENT_TOOLSET"
}


fi
