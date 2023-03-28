#!sh
if [ ! "$_STELLA_COMMON_BUILD_LINK_INCLUDED_" = "1" ]; then
_STELLA_COMMON_BUILD_LINK_INCLUDED_=1



__link_feature_library() {
	local SCHEMA="$1"
	local _link_OPT="$2"
	# FORCE_STATIC -- force link to static version of lib (by isolating it)
	# FORCE_DYNAMIC -- force link to dynamic version of lib (by isolating it)
	# TODO (see windows impl.) : FORCE_RENAME -- rename files when isolating files -- only apply when FORCE_STATIC or FORCE_DYNAMIC is ON
	# FORCE_LIB_FOLDER <path> -- folder prefix where lib resides, default "/lib"
	# FORCE_BIN_FOLDER <path> -- folder prefix where bin resides, default "/bin"
	# FORCE_INCLUDE_FOLDER <path> -- folder prefix where include resides, default "/include"
	# GET_FLAGS <prefix> -- get prefix_C_CXX_FLAGS, prefix_CPP_FLAGS, prefix_LINK_FLAGS with correct flags
	# GET_FOLDER <prefix> -- get prefix_ROOT, prefix_LIB, prefix_BIN, prefix_INCLUDE with correct path
	# NO_SET_FLAGS -- do not set stella build system flags (by default, flags will be generated) AND do not add RPATH values
	# LIBS_NAME -- libraries name to use with -l arg -- you can specify several libraries. If you do not use LIBS_NAME -l flag will not be setted, only -L will be setted. If you use LIBS_NAME both -l and -L flags will be setted
  # USE_PKG_CONFIG -- use of pkg-config

	local _ROOT=
	local _BIN=
	local _LIB=
	local _INCLUDE=


	local _folders=OFF
	local _var_folders=
	local _flags=OFF
	local _var_flags=
	local _opt_flavour=
	local _opt_use_pkg_config=OFF
	local _flag_lib_folder=OFF
	local _lib_folder=lib
	local _flag_bin_folder=OFF
	local _bin_folder=bin
	local _flag_include_folder=OFF
	local _include_folder=include
	local _opt_set_flags=ON
	local _flag_libs_name=OFF
	local _libs_name=

	# default mode
	case "$STELLA_BUILD_LINK_MODE" in
		DEFAULT)
			_opt_flavour="DEFAULT"
			;;
		DYNAMIC)
			_opt_flavour="FORCE_DYNAMIC"
			;;
		STATIC)
			_opt_flavour="FORCE_STATIC"
			;;
	esac

	for o in $_link_OPT; do
		[ "$o" = "USE_PKG_CONFIG" ] && _opt_use_pkg_config=ON && _flag_libs_name=OFF
		[ "$o" = "FORCE_STATIC" ] && _opt_flavour=$o && _flag_libs_name=OFF
		[ "$o" = "FORCE_DYNAMIC" ] && _opt_flavour=$o && _flag_libs_name=OFF

		[ "$_flag_lib_folder" = "ON" ] && _lib_folder=$o && _flag_lib_folder=OFF
		[ "$o" = "FORCE_LIB_FOLDER" ] && _flag_lib_folder=ON && _flag_libs_name=OFF
		[ "$_flag_bin_folder" = "ON" ] && _bin_folder=$o && _flag_bin_folder=OFF
		[ "$o" = "FORCE_BIN_FOLDER" ] && _flag_bin_folder=ON && _flag_libs_name=OFF
		[ "$_flag_include_folder" = "ON" ] && _include_folder=$o && _flag_include_folder=OFF
		[ "$o" = "FORCE_INCLUDE_FOLDER" ] && _flag_include_folder=ON && _flag_libs_name=OFF

		[ "$_flags" = "ON" ] && _var_flags=$o && _flags=OFF
		[ "$o" = "GET_FLAGS" ] && _flags=ON && _flag_libs_name=OFF
		[ "$_folders" = "ON" ] && _var_folders=$o && _folders=OFF
		[ "$o" = "GET_FOLDER" ] && _folders=ON && _flag_libs_name=OFF

		[ "$o" = "NO_SET_FLAGS" ] && _opt_set_flags=OFF && _flag_libs_name=OFF

		[ "$_flag_libs_name" = "ON" ] && _libs_name="$_libs_name $o"
		[ "$o" = "LIBS_NAME" ] && _flag_libs_name=ON
	done

	# check origin for this schema
	local _origin
	case "$SCHEMA" in
		FORCE_ORIGIN_STELLA*)
				_origin="STELLA"
				SCHEMA=${SCHEMA#FORCE_ORIGIN_STELLA}
				;;
		FORCE_ORIGIN_SYSTEM*)
				_origin="SYSTEM"
				SCHEMA=${SCHEMA#FORCE_ORIGIN_SYSTEM}
				;;
		*)
				_origin="$(__feature_choose_origin $SCHEMA)"
				;;
	esac

	# NOTE when linking to a system lib, we do not have control over things and all options are disabled
	if [ "$_origin" = "SYSTEM" ]; then
		STELLA_LINKED_LIBS_SYSTEM_LIST="$STELLA_LINKED_LIBS_SYSTEM_LIST [ ${SCHEMA} options: ${_link_OPT} ]"
		echo "We do not link against STELLA version of $SCHEMA, but from SYSTEM."
		if [ "$_opt_use_pkg_config" = "ON" ]; then
			__add_toolset "pkgconfig"
			# we need to add some defaut seach into path, because pkgconfig have default values from its install path
			# pkgconfig is installed inside stella and do not have correct default values when we want to link against SYSTEM libraries
			echo "** WARN : adding some system lib search path for pkg-config, because we use pkg-config for a SYSTEM lib"
			# TODO __default_linker_search_path should receive arch, because linker search path depend on arch
			__def_path=$(__default_linker_search_path)
			__def_path="${__def_path//:/ }"
			for _p in $__def_path; do
				STELLA_BUILD_PKG_CONFIG_PATH="${STELLA_BUILD_PKG_CONFIG_PATH}:${_p}/pkgconfig"
			done
		fi
		return
	fi

	echo "** Linking to $SCHEMA"

	[ "$STELLA_BUILD_COMPIL_FRONTEND" = "" ] && echo "** WARN : compil frontend empty - did you set a toolset ?"



	# INSPECT required lib through schema
	__push_schema_context
	__feature_inspect "${SCHEMA}"
	if [ "$TEST_FEATURE" = "0" ]; then
		echo " ** ERROR : depend on lib $SCHEMA but not installed - you may add it to FEAT_SOURCE_DEPENDENCIES"
		__pop_schema_context
		return
	fi
	# TODO here : full reinit (or call of FEAT_ENV_CALLBACK) of the feature to override other versions of the feature
	STELLA_LINKED_LIBS_LIST="$STELLA_LINKED_LIBS_LIST [ ${SCHEMA} options: ${_link_OPT} ]"
	local REQUIRED_LIB_ROOT="$FEAT_INSTALL_ROOT"
	local REQUIRED_LIB_NAME="$FEAT_NAME"
	__pop_schema_context

	# TODO useless ?
	# 	REQUIRED_LIB_ROOT="$FEAT_INSTALL_ROOT/stella-dep/$REQUIRED_LIB_NAME"
	# 	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
	# 		[ "$STELLA_BUILD_RELOCATE" = "ON" ] && __tweak_install_name_darwin "$REQUIRED_LIB_ROOT" "RPATH"
	# 		[ "$STELLA_BUILD_RELOCATE" = "OFF" ] && __tweak_install_name_darwin "$REQUIRED_LIB_ROOT" "PATH"
	# 	fi

	# ISOLATE STATIC OR DYNAMIC LIBS
	# if we want specific static or dynamic linking, we isolate specific version
	# by default, linker use dynamic version first and then static version if dynamic is not found
	local _flag_lib_isolation=FALSE
	[ "$_opt_flavour" = "FORCE_STATIC" ] && _flag_lib_isolation=TRUE
	[ "$_opt_flavour" = "FORCE_DYNAMIC" ] && _flag_lib_isolation=TRUE

	local LIB_TARGET_FOLDER=
	local LIB_EXTENSION=

	case $_opt_flavour in
		FORCE_STATIC)
			LIB_TARGET_FOLDER="$REQUIRED_LIB_ROOT/stella-dep-static"
			LIB_EXTENSION=".a"
			;;
		FORCE_DYNAMIC)
			LIB_TARGET_FOLDER="$REQUIRED_LIB_ROOT/stella-dep-dynamic"
			[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && LIB_EXTENSION=".so"
			[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && LIB_EXTENSION=".dylib"
			;;
		DEFAULT)
			LIB_TARGET_FOLDER="$REQUIRED_LIB_ROOT/$_lib_folder"
			;;
	esac

	# TODO do not base lib isolation on file extension but on result of __is_*__bin from lib-parse-bin
	if [ "$_flag_lib_isolation" = "TRUE" ]; then

		echo "*** Isolate dependencies into $LIB_TARGET_FOLDER"
		__del_folder "$LIB_TARGET_FOLDER"
		echo "*** Copying items from $REQUIRED_LIB_ROOT/$_lib_folder to $LIB_TARGET_FOLDER"
		__copy_folder_content_into "$REQUIRED_LIB_ROOT"/"$_lib_folder" "$LIB_TARGET_FOLDER" "*"$LIB_EXTENSION"*"
		__copy_folder_content_into "$REQUIRED_LIB_ROOT"/"$_lib_folder/pkgconfig" "$LIB_TARGET_FOLDER/pkgconfig"

		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			[ "$STELLA_BUILD_RELOCATE" = "ON" ] && __tweak_install_name_darwin "$LIB_TARGET_FOLDER" "RPATH"
			[ "$STELLA_BUILD_RELOCATE" = "OFF" ] && __tweak_install_name_darwin "$LIB_TARGET_FOLDER" "PATH"
		fi
	fi




	# manage pkg-config ----
	if [ "$_opt_use_pkg_config" = "ON" ]; then
		__add_toolset "pkgconfig"
		STELLA_BUILD_PKG_CONFIG_PATH=$LIB_TARGET_FOLDER/pkgconfig:$STELLA_BUILD_PKG_CONFIG_PATH
		if [ "$_flag_lib_isolation" = "TRUE" ]; then
			for f in $LIB_TARGET_FOLDER/pkgconfig/*.pc; do
				#ed -i .bak "s,^prefix=.*,prefix=$LIB_TARGET_FOLDER," "$f"
				sed -i .bak "s,^libdir=.*,libdir=$LIB_TARGET_FOLDER," "$f"
			done
		fi
	fi



	# RESULTS

	# root folder
	_ROOT="$REQUIRED_LIB_ROOT"
	# bin folder
	_BIN="$REQUIRED_LIB_ROOT/bin"
	# include folder
	_INCLUDE="$REQUIRED_LIB_ROOT/$_include_folder"
	# lib folder
	_LIB="$LIB_TARGET_FOLDER"



	# set stella build system flags ----
	if [ "$_opt_set_flags" = "ON" ]; then
		# On Darwin, the install_name of the linked lib is used to link the lib
		#			BUT if install_name of the linked lib is "@rpath/lib" so we will miss the rpath value !
		#			SO better to add a rpath value anyway
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			__set_build_mode "RPATH" "ADD_FIRST" "$LIB_TARGET_FOLDER"
		fi
		# On linux we need to add an rpath value to the folder where reside the linked lib
		#			if needed, we will remove rpath value and turn into a hard link after build
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			__set_build_mode "RPATH" "ADD_FIRST" "$LIB_TARGET_FOLDER"
		fi
	fi

	if [ "$_opt_set_flags" = "ON" ]; then
		__set_link_flags "$_LIB" "$_INCLUDE" "$_libs_name"

		# NOTE : we cannot really set rpath now, each built binary may have a different path, so rpath might be false
		# if [ "$STELLA_BUILD_RELOCATE" = "ON" ]; then
		# 	local p="$(__abs_to_rel_path "$_LIB" "$FEAT_INSTALL_ROOT")"
		# 	# NOTE : $ORIGIN may have problem on some systems, see : http://www.cmake.org/pipermail/cmake/2008-January/019290.html
		# 	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		# 		# from root
		# 		__set_build_mode "RPATH" "ADD_FIRST" '$ORIGIN/'$p
		# 		# from lib or bin folder
		# 		__set_build_mode "RPATH" "ADD_FIRST" '$ORIGIN/../'$p
		# 	fi
		# 	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		# 		# from root
		# 		__set_build_mode "RPATH" "ADD_FIRST" "@loader_path/$p"
		# 		# from lib or bin folder
		# 		__set_build_mode "RPATH" "ADD_FIRST" "@loader_path/../$p"
		# 	fi
		# fi
	fi

	# set <var> flags ---- GET_FLAGS
	if [ ! "$_var_flags" = "" ]; then
		__link_flags "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" "$_var_flags" "$_LIB" "$_INCLUDE" "$_libs_name"
	fi

	# set <folder> vars ---- GET_FOLDER
	if [ ! "$_var_folders" = "" ]; then
		eval "$_var_folders"_ROOT=\"$_ROOT\"
		eval "$_var_folders"_LIB=\"$_LIB\"
		eval "$_var_folders"_INCLUDE=\"$_INCLUDE\"
		eval "$_var_folders"_BIN=\"$_BIN\"
	fi

	echo "** Linked to $SCHEMA"
}

__set_link_flags() {
	local _lib_path="$1"
	local _include_path="$2"
	local _libs_name="$3"

	if [ ! "$STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY" = "cmake" ]; then
		#if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
		#	__link_flags_gcc-clang "_flags" "$_lib_path" "$_include_path" "$_libs_name"
		#	STELLA_LINKED_LIBS_C_CXX_FLAGS="$STELLA_LINKED_LIBS_C_CXX_FLAGS $_flags_C_CXX_FLAGS"
		#	STELLA_LINKED_LIBS_CPP_FLAGS="$STELLA_LINKED_LIBS_CPP_FLAGS $_flags_CPP_FLAGS"
		#	STELLA_LINKED_LIBS_LINK_FLAGS="$STELLA_LINKED_LIBS_LINK_FLAGS $_flags_LINK_FLAGS"
		#fi
		__link_flags "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" "_flags" "$_lib_path" "$_include_path" "$_libs_name"
		[ ! "$_flags_C_CXX_FLAGS" == "" ] && STELLA_LINKED_LIBS_C_CXX_FLAGS="$STELLA_LINKED_LIBS_C_CXX_FLAGS $_flags_C_CXX_FLAGS"
		[ ! "$_flags_CPP_FLAGS" == "" ] && STELLA_LINKED_LIBS_CPP_FLAGS="$STELLA_LINKED_LIBS_CPP_FLAGS $_flags_CPP_FLAGS"
		[ ! "$_flags_LINK_FLAGS" == "" ] && STELLA_LINKED_LIBS_LINK_FLAGS="$STELLA_LINKED_LIBS_LINK_FLAGS $_flags_LINK_FLAGS"
	else
		STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH="$STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH:$_lib_path"
		STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH="$STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH:$_include_path"
	fi

}



fi
