#!/usr/bin/env bash
if [ ! "$_STELLA_COMMON_BUILD_INCLUDED_" = "1" ]; then
_STELLA_COMMON_BUILD_INCLUDED_=1


# BUILD WORKFLOW

# SET SOME DEFAULT BUILD MODE
#		__set_build_mode_default "RELOCATE" "ON"
#  	__set_build_mode_default "DARWIN_STDLIB" "LIBCPP"

# START BUILD SESSION
#	__start_build_session
#			__reset_build_env : reset every env values to default or empty
#			__set_toolset STELLA_BUILD_DEFAULT_TOOLSET



#		GET SOURCE CODE
#		__get_resource

#		SET TOOLSET
#		__set_toolset

#		ADD EXTRA TOOLS
#		__add_toolset "bazel"

# 	CHECK TOOLSET FEATURES
#		__check_toolset "C++"

# 		SET CUSTOM BUILD MODE
#		__set_build_mode ARCH x86

#		SET CUSTOM FLAGS
#		STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -DFLAG"

#		LINK BUILD TO OTHER LIBRARY
#		__link_feature_library

#		AUTOMATIC BUILD AND INSTALL
#		__auto_build		OR __start_manual_build/__end_manual_build

#				INSTALL/INIT REQUIRED TOOLSET
#				__enable_current_toolset 	(included in __start_manual_build)

#				SET BUILD ENV AND FLAGS
#				__prepare_build 					(included in __start_manual_build)
#
#						call set_env_vars_for_gcc
#						call set_env_vars_for_cmake


#				LAUNCH CONFIG TOOL
#				__launch_configure
#				LAUNCH BUILD TOOL
#				__launch_build

#				__inspect_and_fix_build
#						call __fix_built_files
#						call __check_built_files

#				DISABLE REQUIRED TOOLSET
#				__disable_current_toolset	(included in __end_manual_build)


# TOOLSET & BUILD TOOLS ----------------
# Available tools :
# CONFIG TOOL (and family) : configure, cmake, autotools
# BUILD TOOL (and family) : make (make), ninja
# COMPIL FRONTEND (and family) : clang-omp (gcc), gcc (gcc), default (gcc) : default means gcc or other aliased compiler already present on system
#
#				NOTE : - in fact COMPIL_FRONTEND should be called COMPIL_DRIVER
#							 - family has an impact on option/flag passed to the real binary

# Available preconfigured build toolset on Nix system :
# TOOLSET 		| CONFIG TOOL 				| BUILD TOOL (binary family) | COMPIL FRONTEND (binary family)
# STANDARD		|	configure						|		make (make)							 |		default (gcc)
# NINJA				| cmake								|		ninja										 | 		default (gcc)
# CMAKE				|	cmake								|		make (make)							 |		default (gcc)
# NONE ===> disable build toolset and all tools

# NOTE :
# GCC ------------------------------------------------------
# GCC stands for GNU Compiler Collection
# GCC is a compiler collection that consists of a front end for each programming language, a middle end, and a back end for each architecture.
# 	https://en.wikibooks.org/wiki/GNU_C_Compiler_Internals/GNU_C_Compiler_Architecture
# 	http://blog.lxgcc.net/?p=181
# 	gcc and g++ binaries are compiler driver and act as a 'driver' which pilots the call of a compiler, an assembler, and a linker
#		a compiler is a FRONT-END/MIDDLE-END/BACK-END
# 	each language have its specific compiler which is made of specific FRONT-END components and generic MIDDLE-END/BACK-END components.
#  	a compiler driver might be seens as a kind of FRONT-END door
#
#		a compiler driver launch 			 : compiler (FRONT-END/MIDDLE-END/BACK-END)	---> assembler ---> 		linker
#		(for C:)				gcc						 :								cc1													--->		as 		 ---> 	collect2/ld
#
# Structure of a compiler :
#										FRONT-END													-------> 							MIDDLE-END 						------>						BACK-END
#					(specific preprocessor/parser)																		optimizer
#	[SOURCE]		->	[AST:SYNTAX TREE]		-> 	[GENERIC]			->				[GIMPLE]	->	[SSA]	->  [RTL]				->				[ASSEMBLY CODE]
#
# LLVM ------------------------------------------------------
#
#			http://stackoverflow.com/a/27591168/5027535
#			LLVM is a generic MIDDLE-END and a BACK-END
#			Clang is 3 diffirent things
#					* Clang is a compiler driver
#					* Clang is a compiler (FRONT-END/MIDDLE-END/BACK-END) using LLVM (MIDDLE-END/BACK-END)
#					* libclang is the FRONT-END part (preprocessor/parser) of the Clang compiler
#						libclang is the FRONT-END part of the Clang compiler using LLVM BACK-END

__start_build_session() {
	__reset_build_env
	local OPT="$1"
	#for o in $OPT; do
		# TODO : this OPT is never used when calling __start_build_session - useless, to supress ?
		#[ "$o" = "RELOCATE" ] && __set_build_mode "RELOCATE" "ON"
#	done

	__set_toolset "$STELLA_BUILD_DEFAULT_TOOLSET"
}

# BUILD ------------------------------------------------------------------------------------------------------------------------------
__start_manual_build() {
	local NAME
	local SOURCE_DIR
	local INSTALL_DIR

	NAME="$1"
	SOURCE_DIR="$2"
	INSTALL_DIR="$3"

	echo " ** Manual-building $NAME"

	__enable_current_toolset

	# set build env
	__prepare_build "$INSTALL_DIR" "$SOURCE_DIR"

}


__end_manual_build() {

	__disable_current_toolset
	echo " ** Done"
}



__prepare_build() {
	local INSTALL_DIR="$1"
	local SOURCE_DIR="$2"
	local BUILD_DIR="$3"





	# pkg-config
	export PKG_CONFIG_PATH=$STELLA_BUILD_PKG_CONFIG_PATH

	# set env
	__set_build_env ARCH $STELLA_BUILD_ARCH
	__set_build_env CPU_INSTRUCTION_SCOPE $STELLA_BUILD_CPU_INSTRUCTION_SCOPE
	__set_build_env OPTIMIZATION $STELLA_BUILD_OPTIMIZATION
	__set_build_env MACOSX_DEPLOYMENT_TARGET $STELLA_BUILD_MACOSX_DEPLOYMENT_TARGET
	__set_build_env DARWIN_STDLIB $STELLA_BUILD_DARWIN_STDLIB
	__set_build_env LINK_FLAGS_DEFAULT $STELLA_BUILD_LINK_FLAGS_DEFAULT

	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && __set_build_env RUNPATH_OVER_RPATH

	# trim list
	STELLA_BUILD_RPATH="$(__trim $STELLA_BUILD_RPATH)"
	STELLA_C_CXX_FLAGS="$(__trim $STELLA_C_CXX_FLAGS)"
	STELLA_CPP_FLAGS="$(__trim $STELLA_CPP_FLAGS)"
	STELLA_LINK_FLAGS="$(__trim $STELLA_LINK_FLAGS)"



	# set compiler env flags -------------
	# cmake take care of compiler flags in case of other compil frontend
	case $STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY in
		cmake)
			__set_env_vars_for_cmake
		;;
		*)
			if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ]; then
				__set_env_vars_for_gcc
			fi
		;;
	esac


	# print info ----------
	echo "** BUILD TOOLSET"
	echo "====> Preconfigured Toolset : $STELLA_BUILD_TOOLSET"
	echo "====> Configuration Tool : $STELLA_BUILD_CONFIG_TOOL [family : $STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY]"
	echo "====> Build management Tool : $STELLA_BUILD_BUILD_TOOL [family : $STELLA_BUILD_BUILD_TOOL_BIN_FAMILY]"
	echo "====> Compiler Frontend : $STELLA_BUILD_COMPIL_FRONTEND [family : $STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY]"
	echo "====> env CC : $CC"
	echo "====> env CXX : $CXX"
	echo "====> env CPP : $CPP"
	echo "====> Extra toolset : $STELLA_BUILD_EXTRA_TOOLSET"
	echo "====> Toolset features checked : $STELLA_BUILD_CHECK_TOOLSET"
	echo "** BUILD INFO"
	echo "====> Build arch directive : $STELLA_BUILD_ARCH"
	echo "====> Parallelized (if supported) : $STELLA_BUILD_PARALLELIZE"
	echo " (soon DEPRECATED) Relocatable : $STELLA_BUILD_RELOCATE"
	echo "** LINKED LIB"
	echo "====> Feature link path mode : $STELLA_FEATURE_LINK_PATH"
	echo "====> Build Link path mode : $STELLA_BUILD_LINK_PATH"
	echo "====> Linked libs from stella features : $STELLA_LINKED_LIBS_LIST"
	echo "====> Linked libs from system : $STELLA_LINKED_LIBS_SYSTEM_LIST"
	echo "====> pkg-config tool : $(which pkg-config)"
	echo "====> env PKG_CONFIG_PATH (additional search path for pkg-config): $PKG_CONFIG_PATH"
	echo "====> pkg-config full search path : $(__pkgconfig_search_path)"
	echo "** FOLDERS"
	echo "====> Install directory : $INSTALL_DIR"
	echo "====> Source directory : $SOURCE_DIR"
	echo "====> Build directory : $BUILD_DIR"
	echo "** SOME FLAGS"
	echo "====> STELLA_C_CXX_FLAGS : $STELLA_C_CXX_FLAGS"
	echo "====> STELLA_CPP_FLAGS : $STELLA_CPP_FLAGS"
	echo "====> STELLA_LINK_FLAGS : $STELLA_LINK_FLAGS"
	echo "====> STELLA_DYNAMIC_LINK_FLAGS : $STELLA_DYNAMIC_LINK_FLAGS"
	echo "====> STELLA_STATIC_LINK_FLAGS : $STELLA_STATIC_LINK_FLAGS"
	echo "====> CMAKE_LIBRARY_PATH : $CMAKE_LIBRARY_PATH"
	echo "====> CMAKE_INCLUDE_PATH : $CMAKE_INCLUDE_PATH"
	echo "====> STELLA_CMAKE_EXTRA_FLAGS : $STELLA_CMAKE_EXTRA_FLAGS"
	echo "** SOME ENV"
	echo "====> LIBRARY_PATH (search path at link time) : $LIBRARY_PATH"
	echo "====> LD_LIBRARY_PATH (search path at run time linux): $LD_LIBRARY_PATH"
	echo "====> DYLD_LIBRARY_PATH (search path at run time darwin): $DYLD_LIBRARY_PATH"


}


__auto_build() {

	local NAME
	local SOURCE_DIR
	local BUILD_DIR
	local INSTALL_DIR
	local OPT


	NAME="$1"
	SOURCE_DIR="$2"
	INSTALL_DIR="$3"
	OPT="$4"
	# DEBUG
	# SOURCE_KEEP
	# BUILD_KEEP
	# AUTOTOOLS <bootstrap|autogen|autoreconf>
	# NO_CONFIG
	# NO_BUILD
	# NO_OUT_OF_TREE_BUILD
	# NO_INSPECT
	# NO_INSTALL
	# NO_FIX
	# NO_CHECK
	# POST_BUILD_STEP
	# INCLUDE_FILTER <expr> -- include these files for inspect and fix
	# EXCLUDE_FILTER <expr> -- exclude these files for inspect and fix
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
	# BUILD_ACTION <action1> <action2>
	# keep source code after build (default : FALSE)
	local _opt_source_keep=
	# keep build dir after build (default : FALSE)
	local _opt_build_keep=
	# configure step activation (default : TRUE)
	local _opt_configure=ON
	# build step activation (default : TRUE)
	local _opt_build=ON
	# build from another folder (default : TRUE)
	local _opt_out_of_tree_build=ON
	for o in $OPT; do
		[ "$o" = "SOURCE_KEEP" ] && _opt_source_keep=ON
		[ "$o" = "BUILD_KEEP" ] && _opt_build_keep=ON
		[ "$o" = "NO_CONFIG" ] && _opt_configure=OFF
		[ "$o" = "NO_BUILD" ] && _opt_build=OFF
		[ "$o" = "NO_OUT_OF_TREE_BUILD" ] && _opt_out_of_tree_build=OFF
	done

	# can not build out of tree without configure first
	[ "$_opt_configure" = "OFF" ] && _opt_out_of_tree_build=OFF



	echo " ** Auto-building $NAME into $INSTALL_DIR for $STELLA_CURRENT_OS"


	__enable_current_toolset


	# folder stuff
	BUILD_DIR="$SOURCE_DIR"
	[ "$_opt_out_of_tree_build" = "ON" ] && BUILD_DIR="$(dirname $SOURCE_DIR)/$(basename $SOURCE_DIR)-build"

	mkdir -p "$INSTALL_DIR"

	if [ "$_opt_out_of_tree_build" = "ON" ]; then
		echo "** Out of tree build is active"
		[ "$FORCE" = "1" ] && rm -Rf "$BUILD_DIR"
		[ ! "$_opt_build_keep" = "ON" ] && rm -Rf "$BUILD_DIR"
	else
		echo "** Out of tree build is not active"
	fi

	mkdir -p "$BUILD_DIR"

	# set build env
	__prepare_build "$INSTALL_DIR" "$SOURCE_DIR" "$BUILD_DIR"

	# launch process
	[ "$_opt_configure" = "ON" ] && __launch_configure "$SOURCE_DIR" "$INSTALL_DIR" "$BUILD_DIR" "$OPT"
	[ "$_opt_build" = "ON" ] && __launch_build "$SOURCE_DIR" "$INSTALL_DIR" "$BUILD_DIR" "$OPT"


	cd "$INSTALL_DIR"

	# clean workspace
	[ ! "$_opt_source_keep" = "ON" ] && rm -Rf "$SOURCE_DIR"

	if [ "$_opt_out_of_tree_build" = "ON" ]; then
		[ ! "$_opt_build_keep" = "ON" ] && rm -Rf "$BUILD_DIR"
	fi

	__inspect_and_fix_build "$INSTALL_DIR" "$OPT"

	__disable_current_toolset
	echo " ** Done"

}


__launch_configure() {
	local AUTO_SOURCE_DIR
	local AUTO_BUILD_DIR
	local AUTO_INSTALL_DIR
	local OPT

	AUTO_SOURCE_DIR="$1"
	AUTO_INSTALL_DIR="$2"
	AUTO_BUILD_DIR="$3"
	OPT="$4"

	# debug mode (default : OFF)
	local _debug=
	# AUTOTOOLS <bootstrap|autogen|autoreconf>
	local _opt_autotools=OFF
	local _flag_opt_autotools=OFF
	local _autotools=
	for o in $OPT; do
		[ "$o" = "DEBUG" ] && _debug=ON
		[ "$_flag_opt_autotools" = "ON" ] && _autotools="$o" && _flag_opt_autotools=OFF
		[ "$o" = "AUTOTOOLS" ] && _flag_opt_autotools=ON && _opt_autotools=ON
	done

	mkdir -p "$AUTO_BUILD_DIR"
	cd "$AUTO_BUILD_DIR"

	if [ "$_opt_autotools" = "ON" ]; then
		echo "** Using Autotools : ${_autotools}"
		case $_autotools in
			bootstrap)
				[ -f "$AUTO_SOURCE_DIR/bootstrap" ] && "$AUTO_SOURCE_DIR/bootstrap" || echo "** WARN : bootstrap not found or error"
			;;
			autogen)
				[ -f "$AUTO_SOURCE_DIR/autogen.sh" ] && "$AUTO_SOURCE_DIR/autogen.sh" || echo "** WARN : autogen not found or error"
			;;
			autoreconf)
				autoreconf --force --verbose --install $AUTO_SOURCE_DIR
			;;
		esac
	fi


	# GLOBAL FLAGs
	# AUTO_INSTALL_CONF_FLAG_PREFIX
	# AUTO_INSTALL_CONF_FLAG_POSTFIX

	case $STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY in

		configure)
			chmod +x "$AUTO_SOURCE_DIR/configure"

			if [ "$AUTO_INSTALL_CONF_FLAG_PREFIX" = "" ]; then
				"$AUTO_SOURCE_DIR/configure" --prefix="$AUTO_INSTALL_DIR" $AUTO_INSTALL_CONF_FLAG_POSTFIX
			else
				eval $(echo $AUTO_INSTALL_CONF_FLAG_PREFIX) "$AUTO_SOURCE_DIR/configure" --prefix="$AUTO_INSTALL_DIR" $AUTO_INSTALL_CONF_FLAG_POSTFIX
			fi
		;;


		cmake)
			[ "$STELLA_BUILD_BUILD_TOOL_BIN_FAMILY" = "make" ] && CMAKE_GENERATOR="Unix Makefiles"
			[ "$STELLA_BUILD_BUILD_TOOL_BIN_FAMILY" = "ninja" ] && CMAKE_GENERATOR="Ninja"
			[ "$_debug" = "ON" ] && _debug="--debug-output" #--trace --debug-output

			if [ "$AUTO_INSTALL_CONF_FLAG_PREFIX" = "" ]; then
				cmake "$_debug" "$AUTO_SOURCE_DIR" \
				-DCMAKE_C_FLAGS:STRING="$CMAKE_C_FLAGS" -DCMAKE_CXX_FLAGS:STRING="$CMAKE_CXX_FLAGS" $STELLA_CMAKE_EXTRA_FLAGS \
				$AUTO_INSTALL_CONF_FLAG_POSTFIX \
				-DCMAKE_SHARED_LINKER_FLAGS:STRING="$CMAKE_SHARED_LINKER_FLAGS" -DCMAKE_MODULE_LINKER_FLAGS:STRING="$CMAKE_MODULE_LINKER_FLAGS" \
				-DCMAKE_STATIC_LINKER_FLAGS:STRING="$CMAKE_STATIC_LINKER_FLAGS" -DCMAKE_EXE_LINKER_FLAGS:STRING="$CMAKE_EXE_LINKER_FLAGS" \
				-DCMAKE_BUILD_TYPE=Release \
				-DCMAKE_INSTALL_PREFIX="$AUTO_INSTALL_DIR" \
				-DINSTALL_BIN_DIR="$AUTO_INSTALL_DIR/bin" -DINSTALL_LIB_DIR="$AUTO_INSTALL_DIR/lib" \
				-DCMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH" -DCMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH" \
				-DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_FIND_APPBUNDLE=LAST \
				-G "$CMAKE_GENERATOR"
				# -DCMAKE_DEBUG_POSTFIX=$DEBUG_POSTFIX
				#-DBUILD_STATIC_LIBS:BOOL=TRUE -DBUILD_SHARED_LIBS:BOOL=TRUE \
			else
				eval $(echo $AUTO_INSTALL_CONF_FLAG_PREFIX) cmake "$_debug" "$AUTO_SOURCE_DIR" \
				-DCMAKE_C_FLAGS:STRING="$CMAKE_C_FLAGS" -DCMAKE_CXX_FLAGS:STRING="$CMAKE_CXX_FLAGS" $STELLA_CMAKE_EXTRA_FLAGS \
				$AUTO_INSTALL_CONF_FLAG_POSTFIX \
				-DCMAKE_SHARED_LINKER_FLAGS:STRING="$CMAKE_SHARED_LINKER_FLAGS" -DCMAKE_MODULE_LINKER_FLAGS:STRING="$CMAKE_MODULE_LINKER_FLAGS" \
				-DCMAKE_STATIC_LINKER_FLAGS:STRING="$CMAKE_STATIC_LINKER_FLAGS" -DCMAKE_EXE_LINKER_FLAGS:STRING="$CMAKE_EXE_LINKER_FLAGS" \
				-DCMAKE_BUILD_TYPE=Release \
				-DCMAKE_INSTALL_PREFIX="$AUTO_INSTALL_DIR" \
				-DINSTALL_BIN_DIR="$AUTO_INSTALL_DIR/bin" -DINSTALL_LIB_DIR="$AUTO_INSTALL_DIR/lib" \
				-DCMAKE_LIBRARY_PATH="$CMAKE_LIBRARY_PATH" -DCMAKE_INCLUDE_PATH="$CMAKE_INCLUDE_PATH" \
				-DCMAKE_FIND_FRAMEWORK=LAST -DCMAKE_FIND_APPBUNDLE=LAST \
				-G "'"$CMAKE_GENERATOR"'"
				#  -DCMAKE_DEBUG_POSTFIX=$DEBUG_POSTFIX
				# -DBUILD_STATIC_LIBS:BOOL=TRUE -DBUILD_SHARED_LIBS:BOOL=TRUE \
			fi
		;;

	esac
}


__launch_build() {
	local AUTO_SOURCE_DIR
	local AUTO_INSTALL_DIR
	local AUTO_BUILD_DIR
	local OPT

	AUTO_SOURCE_DIR="$1"
	AUTO_INSTALL_DIR="$2"
	AUTO_BUILD_DIR="$3"
	OPT="$4"
	# parallelize build
	local _opt_parallelize="$STELLA_BUILD_PARALLELIZE"

	# debug mode (default : OFF)
	local _debug=
	# configure step activation (default : TRUE)
	local _opt_configure=ON
	# install step activation (default : TRUE)
	local _opt_install=ON
	# build steps after building (in order)
	local _flag_opt_post_build_step=OFF
	local _post_build_step=
	for o in $OPT; do
		[ "$o" = "DEBUG" ] && _debug=ON && _flag_opt_post_build_step=OFF
		[ "$o" = "NO_CONFIG" ] && _opt_configure=OFF && _flag_opt_post_build_step=OFF
		[ "$o" = "NO_INSTALL" ] && _opt_install=OFF && _flag_opt_post_build_step=OFF
		[ "$_flag_opt_post_build_step" = "ON" ] && _post_build_step="$_post_build_step $o"
		[ "$o" = "POST_BUILD_STEP" ] && _flag_opt_post_build_step=ON
	done

	# FLAGS (declared as global)
	# AUTO_INSTALL_BUILD_FLAG_PREFIX
	# AUTO_INSTALL_BUILD_FLAG_POSTFIX

	local _FLAG_PARALLEL=

	mkdir -p "$AUTO_BUILD_DIR"
	cd "$AUTO_BUILD_DIR"

	# POST_BUILD_STEP
	if __string_contains "$_post_build_step" "install"; then
		if [ "$_opt_install" = "OFF" ]; then
			_post_build_step=$(echo "$_post_build_step" | sed 's/^install$//' | sed 's/^install //' | sed 's/ install$//' | sed 's/ install / /g' )
		fi
	else
		if [ "$_opt_install" = "ON" ]; then
			# we add install in first place if not already present
			_post_build_step="install $_post_build_step"
		fi
	fi

	local _step
	case $STELLA_BUILD_BUILD_TOOL_BIN_FAMILY in

		make)
			[ "$_opt_parallelize" = "ON" ] && _FLAG_PARALLEL="-j$STELLA_NB_CPU"
			[ "$_debug" = "ON" ] && _debug="--debug=b" #--debug=a
			if [ "$AUTO_INSTALL_BUILD_FLAG_PREFIX" = "" ]; then
				if [ "$_opt_configure" = "ON" ]; then
					# First step : build
					make $_debug $_FLAG_PARALLEL \
					$AUTO_INSTALL_BUILD_FLAG_POSTFIX

					# Other build step
					for _step in $_post_build_step; do
						make $_debug \
						$AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						$_step
					done
				else
					#make $_debug $_FLAG_PARALLEL \
					#CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" \
					#PREFIX="$AUTO_INSTALL_DIR" $AUTO_INSTALL_BUILD_FLAG_POSTFIX

					# First step : build
					make $_debug $_FLAG_PARALLEL \
					PREFIX="$AUTO_INSTALL_DIR" prefix="$AUTO_INSTALL_DIR" \
					$AUTO_INSTALL_BUILD_FLAG_POSTFIX

					#for _step in $_post_build_step; do
						#make $_debug \
						#CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" \
						#PREFIX="$AUTO_INSTALL_DIR" $AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						#$_step
					#done

					# Other build step
					for _step in $_post_build_step; do
						make $_debug \
						PREFIX="$AUTO_INSTALL_DIR" prefix="$AUTO_INSTALL_DIR" \
						$AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						$_step
					done
				fi
			else
				if [ "$_opt_configure" = "ON" ]; then
					# First step : build
					eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug $_FLAG_PARALLEL \
					$AUTO_INSTALL_BUILD_FLAG_POSTFIX

					# Other build step
					for _step in $_post_build_step; do
						eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug \
						$AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						$_step
					done
				else
					#eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug  $_FLAG_PARALLEL \
					#CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" \
					#PREFIX="$AUTO_INSTALL_DIR" $AUTO_INSTALL_BUILD_FLAG_POSTFIX

					# First step : build
					eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug $_FLAG_PARALLEL \
					PREFIX="$AUTO_INSTALL_DIR" prefix="$AUTO_INSTALL_DIR" \
					$AUTO_INSTALL_BUILD_FLAG_POSTFIX

					#for _step in $_post_build_step; do
						#eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug \
						#CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" CPPFLAGS="$CPPFLAGS" LDFLAGS="$LDFLAGS" \
						#PREFIX="$AUTO_INSTALL_DIR" $AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						#$_step
					#done

					# Other build step
					for _step in $_post_build_step; do
						eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) make $_debug \
						PREFIX="$AUTO_INSTALL_DIR" prefix="$AUTO_INSTALL_DIR" \
						$AUTO_INSTALL_BUILD_FLAG_POSTFIX \
						$_step
					done
				fi
			fi
		;;

		ninja)
			if [ ! "$_opt_parallelize" = "ON" ]; then
				_FLAG_PARALLEL="-j1"
			else
				# ninja is auto parallelized
				_FLAG_PARALLEL=
			fi
			[ "$_debug" = "ON" ] && _debug="-v"
			if [ "$AUTO_INSTALL_BUILD_FLAG_PREFIX" = "" ]; then
				# First step : build
				ninja $_debug $_FLAG_PARALLEL $AUTO_INSTALL_BUILD_FLAG_POSTFIX
				# Other build step
				for _step in $_post_build_step; do
					ninja $_debug $AUTO_INSTALL_BUILD_FLAG_POSTFIX $_step
				done
			else
				# First step : build
				eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) ninja $_debug $_FLAG_PARALLEL $AUTO_INSTALL_BUILD_FLAG_POSTFIX
				# Other build step
				for _step in $_post_build_step; do
					eval $(echo $AUTO_INSTALL_BUILD_FLAG_PREFIX) ninja $_debug $AUTO_INSTALL_BUILD_FLAG_POSTFIX $_step
				done
			fi
		;;

	esac
}



# ENV and FLAGS management---------------------------------------------------------------------------------------------------------------------------------------

__reset_build_env() {
	# BUILD FLAGS
	STELLA_C_CXX_FLAGS=
	STELLA_CPP_FLAGS=
	STELLA_DYNAMIC_LINK_FLAGS=
	STELLA_STATIC_LINK_FLAGS=
	STELLA_LINK_FLAGS=
	STELLA_CMAKE_EXTRA_FLAGS=
	STELLA_CMAKE_RPATH_BUILD_PHASE=
	STELLA_CMAKE_RPATH_INSTALL_PHASE=
	STELLA_CMAKE_RPATH=
	STELLA_CMAKE_RPATH_DARWIN=


	# LINKED LIBRARIES
	STELLA_LINKED_LIBS_LIST=
	STELLA_LINKED_LIBS_SYSTEM_LIST=
	STELLA_LINKED_LIBS_C_CXX_FLAGS=
	STELLA_LINKED_LIBS_CPP_FLAGS=
	STELLA_LINKED_LIBS_LINK_FLAGS=
	STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH=
	STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH=
	STELLA_BUILD_PKG_CONFIG_PATH=

	# BUILD MODE
	STELLA_BUILD_RELOCATE="$STELLA_BUILD_RELOCATE_DEFAULT"
	STELLA_BUILD_LINK_PATH="$STELLA_BUILD_LINK_PATH_DEFAULT"
	STELLA_BUILD_RPATH="$STELLA_BUILD_RPATH_DEFAULT"
	STELLA_BUILD_CPU_INSTRUCTION_SCOPE="$STELLA_BUILD_CPU_INSTRUCTION_SCOPE_DEFAULT"
	STELLA_BUILD_OPTIMIZATION="$STELLA_BUILD_OPTIMIZATION_DEFAULT"
	STELLA_BUILD_PARALLELIZE="$STELLA_BUILD_PARALLELIZE_DEFAULT"
	STELLA_BUILD_LINK_MODE="$STELLA_BUILD_LINK_MODE_DEFAULT"
	STELLA_BUILD_ARCH="$STELLA_BUILD_ARCH_DEFAULT"
	# NOTE : STELLA_BUILD_DARWIN_STDLIB_DEFAULT is never initialized by a set_build_mode_default call
	STELLA_BUILD_DARWIN_STDLIB="$STELLA_BUILD_DARWIN_STDLIB_DEFAULT"
	STELLA_BUILD_MACOSX_DEPLOYMENT_TARGET="$STELLA_BUILD_MACOSX_DEPLOYMENT_TARGET_DEFAULT"
	STELLA_BUILD_MIX_CPP_C_FLAGS="$STELLA_BUILD_MIX_CPP_C_FLAGS_DEFAULT"
	STELLA_BUILD_LINK_FLAGS_DEFAULT="$STELLA_BUILD_LINK_FLAGS_DEFAULT_DEFAULT"


	# EXTERNAL VARIABLE
	# reset variable from outside stella
	# dont need this, they are reaffected when calling set_cmake_flags and set_standard_flags
	unset CFLAGS #flags to pass to the C compiler.
	unset CXXFLAGS #flags to pass to the C++ compiler.
	unset CPPFLAGS #flags to pass to the C preprocessor. Used when compiling C and C++
	unset LDFLAGS #flags to pass to the linker
	unset CMAKE_C_FLAGS
	unset CMAKE_CXX_FLAGS
	unset CMAKE_SHARED_LINKER_FLAGS
	unset CMAKE_MODULE_LINKER_FLAGS
	unset CMAKE_STATIC_LINKER_FLAGS
	unset CMAKE_EXE_LINKER_FLAGS
	unset CC
	unset CXX
	unset LIBRARY_PATH
	unset PKG_CONFIG_PATH #pkg-config research path

	# TOOLSET
	STELLA_BUILD_TOOLSET=
	STELLA_BUILD_TOOLSET_PATH=
	STELLA_BUILD_EXTRA_TOOLSET=
	STELLA_BUILD_CHECK_TOOLSET=
	STELLA_BUILD_CONFIG_TOOL=
	STELLA_BUILD_BUILD_TOOL=
	STELLA_BUILD_COMPIL_FRONTEND=
	STELLA_BUILD_CONFIG_TOOL_SCHEMA=
	STELLA_BUILD_BUILD_TOOL_SCHEMA=
	STELLA_BUILD_COMPIL_FRONTEND_SCHEMA=
	STELLA_BUILD_CONFIG_TOOL_BIN_FAMILY=
	STELLA_BUILD_BUILD_TOOL_BIN_FAMILY=
	STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY=
}




__set_build_mode_default() {
	case $1 in
		RPATH)
			eval STELLA_BUILD_"$1"_DEFAULT=\"$2\" \"$3\"
		;;
		*)
			eval STELLA_BUILD_"$1"_DEFAULT=\"$2\"
		;;
	esac

}

# TOOLSET agnostic
__set_build_mode() {

	# LINK_FLAGS_DEFAULT -----------------------------------------------------------------
	# activate default link flags
	[ "$1" = "LINK_FLAGS_DEFAULT" ] && STELLA_BUILD_LINK_FLAGS_DEFAULT=$2

	# MIX_CPP_C_FLAGS -----------------------------------------------------------------
	# set CFLAGS and CXXFLAGS with CPPFLAGS
	[ "$1" = "MIX_CPP_C_FLAGS" ] && STELLA_BUILD_MIX_CPP_C_FLAGS=$2

	# STATIC/DYNAMIC LINK -----------------------------------------------------------------
	# force build system to force a linking mode when it is possible
	# STATIC | DYNAMIC | DEFAULT
	[ "$1" = "LINK_MODE" ] && STELLA_BUILD_LINK_MODE=$2

	# CPU_INSTRUCTION_SCOPE -----------------------------------------------------------------
	# http://sdf.org/~riley/blog/2014/10/30/march-mtune/
	# CURRENT | SAME_FAMILY | GENERIC
	[ "$1" = "CPU_INSTRUCTION_SCOPE" ] && STELLA_BUILD_CPU_INSTRUCTION_SCOPE=$2

	# ARCH -----------------------------------------------------------------
	# Setting flags for a specific arch
	[ "$1" = "ARCH" ] && STELLA_BUILD_ARCH=$2

	# BINARIES RELOCATE -ABLE -----------------------------------------------------------------
	# ON | OFF
	#		every dependency will be added to a DT_NEEDED field in elf files
	# 				on linux : DT_NEEDED contain dependency filename only
	# 				on darwin : LC_LOAD_DYLIB contain a dependency with using couple of values : @rpath and @loader_path
	#		if OFF : RPATH values will be added for each dependency by absolute path
	#		if ON : RPATH values will contain relative values to a nested lib folder containing dependencies
	[ "$1" = "RELOCATE" ] && STELLA_BUILD_RELOCATE=$2

	# DEPENDENCIES LINK PATH MODE  -----------------------------------------------------------------
	# DEFAULT | ABSOLUTE | RELATIVE
	[ "$1" = "LINK_PATH" ] && STELLA_BUILD_LINK_PATH=$2

	# GENERIC RPATH (runtime search path values) -----------------------------------------------------------------
	if [ "$1" = "RPATH" ]; then
		case $2 in
			ADD)
				STELLA_BUILD_RPATH="$STELLA_BUILD_RPATH $3"
			;;
			ADD_FIRST)
				STELLA_BUILD_RPATH="$3 $STELLA_BUILD_RPATH"
			;;
		esac
	fi

	# MACOSX_DEPLOYMENT_TARGET -----------------------------------------------------------------
	[ "$1" = "MACOSX_DEPLOYMENT_TARGET" ] && STELLA_BUILD_MACOSX_DEPLOYMENT_TARGET=$2

	# DARWIN STDLIB -----------------------------------------------------------------
	# http://stackoverflow.com/a/19637199
	# On 10.8 and earlier libstdc++ is chosen by default, on version >= 10.9 libc++ is chosen by default.
	# by default -mmacosx-version-min value is used to choose one of them
	[ "$1" = "DARWIN_STDLIB" ] && STELLA_BUILD_DARWIN_STDLIB=$2

	# OPTIMIZATION LEVEL-----------------------------------------------------------------
	[ "$1" = "OPTIMIZATION" ] && STELLA_BUILD_OPTIMIZATION=$2

	# PARALLELIZATION -----------------------------------------------------------------
	[ "$1" = "PARALLELIZE" ] && STELLA_BUILD_PARALLELIZE=$2


}



# INSPECT CHECK and FIX BUILT FILES ------------------------------------------------------------------------------------------------------------------------------
# inspect and fix files built by stella
__inspect_and_fix_build() {
	local path="$1"
	local OPT="$2"
	local _result=0
	local o=
	# INCLUDE_LINKED_LIB <expr> -- include these linked libs
	# EXCLUDE_LINKED_LIB <expr> -- exclude these linked libs
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
	# INCLUDE_FILTER <expr> -- include these files
	# EXCLUDE_FILTER <expr> -- exclude these files
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
	# NO_FIX do not fix files
	# NO_CHECK do not check files

	[ "$1" = "" ] && return

	# fix files (default : ON)
	local _opt_fix_files=ON
	# check build (default : ON)
	local _opt_check_files=ON
	for o in $OPT; do
		[ "$o" = "NO_FIX" ] && _opt_fix_files=OFF
		[ "$o" = "NO_CHECK" ] && _opt_check_files=OFF
	done

	# nothing to do
	if [ "${_opt_fix_files}" = "OFF" ]; then
		[ "${_opt_check_files}" = "OFF" ] && return
	fi


	[ -z "$(__filter_list "$path/*" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return $_result



	local f=
	if [ -d "$path" ]; then
		for f in  "$path"/*; do
			__inspect_and_fix_build "$f" "$OPT"
		done
	fi

	if [ -f "$path" ]; then
		# fixing built files
		[ "${_opt_fix_files}" = "ON" ] && __fix_built_files "$path" "$OPT"
		# checking built files
		if [ "${_opt_check_files}" = "ON" ]; then
			__check_built_files "$path" "$OPT" || _result=1
		fi
	fi

	return $_result
}

__fix_built_files() {
	local path="$1"
	local OPT="$2"
	if [ "$STELLA_BUILD_RELOCATE" = "ON" ]; then
		__tweak_binary_file "$path" "$OPT RELOCATE WANTED_RPATH $STELLA_BUILD_RPATH"
	fi
	if [ "$STELLA_BUILD_RELOCATE" = "OFF" ]; then
		# TODO NON_RELOCATE will change binary, maybe we dont want that...
		#__tweak_binary_file "$path" "$OPT NON_RELOCATE WANTED_RPATH $STELLA_BUILD_RPATH"
		__tweak_binary_file "$path" "$OPT WANTED_RPATH $STELLA_BUILD_RPATH"
	fi
}

__check_built_files() {
	local path="$1"
	local OPT="$2"
	local _result=0
	local _check_arch=
	[ ! "$STELLA_BUILD_ARCH" = "" ] && _check_arch="ARCH $STELLA_BUILD_ARCH"
	if [ "$STELLA_BUILD_RELOCATE" = "ON" ]; then
		__check_binary_file "$path" "$OPT RELOCATE $_check_arch WANTED_RPATH $STELLA_BUILD_RPATH" || _result=1
	fi
	if [ "$STELLA_BUILD_RELOCATE" = "OFF" ]; then
		# if we are in export mode or in default mode, linked libs should be relocatable
		__check_binary_file "$path" "$OPT NON_RELOCATE $_check_arch WANTED_RPATH $STELLA_BUILD_RPATH" || _result=1
	fi

	return $_result
}


fi
