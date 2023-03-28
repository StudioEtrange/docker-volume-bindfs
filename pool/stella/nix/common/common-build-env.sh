#!sh
if [ ! "$_STELLA_COMMON_BUILD_ENV_INCLUDED_" = "1" ]; then
_STELLA_COMMON_BUILD_ENV_INCLUDED_=1


__link_flags() {
	local _frontend_bin_family="$1"
	local _var_flags="$2"
	local _lib_path="$3"
	local _include_path="$4"
	local _libs_name="$5"

	if [ "$_frontend_bin_family" = "gcc" ] || [ "$_frontend_bin_family" = "clang" ]; then
		__link_flags_gcc "$_var_flags" "$_lib_path" "$_include_path" "$_libs_name"
	fi
}

__link_flags_gcc() {
	local _var_flags="$1"
	local _lib_path="$2"
	local _include_path="$3"
	local _libs_name="$4"

	# for configure/make/gcc-clang OR NULL/make/gcc-clang
	local _C_CXX_FLAGS=
	local _CPP_FLAGS="-I$_include_path"
	local _LINK_FLAGS="-L$_lib_path"

	for l in $_libs_name; do
		_LINK_FLAGS="$_LINK_FLAGS -l$l"
	done
	
	eval "$_var_flags"_C_CXX_FLAGS=\"$_C_CXX_FLAGS\"
	eval "$_var_flags"_CPP_FLAGS=\"$_CPP_FLAGS\"
	eval "$_var_flags"_LINK_FLAGS=\"$_LINK_FLAGS\"

}

# NOTE : NOT USED
__link_rpath_flags() {
	local _frontend="$1"
	local _var_flags="$2"
	local _linked_target_path="$3"
	local _linked_lib_path="$4"
	if [ "$_frontend" = "gcc" ] || [ "$_frontend" = "clang" ]; then
		__link_rpath_flags_gcc "$_var_flags" "$_linked_target_path" "$_linked_lib_path"
	fi
}

# NOTE : NOT USED
__link_rpath_flags_gcc() {
	local _var_flags="$1"
	local _linked_target_path="$2"
	local _linked_lib_path="$3"

	local _p="$(__abs_to_rel_path "$_linked_lib_path" "$_linked_target_path")"
	local _LINK_RPATH_FLAGS
	local _rpath

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		# to avoid problem with $$ORIGIN -- only usefull with standard build tools (do not need this with cmake)
		# relative to /lib or /root folder
		_rpath='$ORIGIN/../'$_p
		_rpath=${_rpath/\$ORIGIN/\$\$ORIGIN}
		_LINK_RPATH_FLAGS="-Wl,-rpath='"$_rpath"'"
		# relative to root folder
		_rpath='$ORIGIN/'$_p
		_rpath=${_rpath/\$ORIGIN/\$\$ORIGIN}
		_LINK_RPATH_FLAGS="$_LINK_RPATH_FLAGS -Wl,-rpath='"$_rpath"'"
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		# NOTE : if we use ' or " around $_p, it will be used as rpath value
		_LINK_RPATH_FLAGS="-Wl,-rpath,@loader_path/$_p -Wl,-rpath,@loader_path/../$_p"
	fi

	eval "$_var_flags"_LINK_RPATH_FLAGS=\"$_LINK_RPATH_FLAGS\"
}



# set flags and env for CMAKE
__set_env_vars_for_cmake() {

	# RPATH Management
	local _rpath=
	for r in $STELLA_BUILD_RPATH; do
		_rpath="$r;$_rpath"
	done

	if [ "$STELLA_BUILD_RELOCATE" = "ON" ]; then

		# all phase
		[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && __set_build_env "CMAKE_RPATH" "ALL_PHASE_USE_RPATH_DARWIN"
		__set_build_env "CMAKE_RPATH" "ALL_PHASE_USE_RPATH"

		# cmake build phase
		__set_build_env "CMAKE_RPATH" "BUILD_PHASE_USE_BUILD_FOLDER"

		# cmake install phase
		__set_build_env "CMAKE_RPATH" "INSTALL_PHASE_USE_FINAL_RPATH"

		[ ! "$_rpath" = "" ] && __set_build_env "CMAKE_RPATH" "INSTALL_PHASE_ADD_FINAL_RPATH" "$_rpath"
	else

		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			# force install_name with hard path
			__set_build_env "CMAKE_RPATH" "ALL_PHASE_USE_RPATH" # -- we need this for forcing install_name
			__set_build_env "CMAKE_RPATH" "INSTALL_PHASE_USE_FINAL_RPATH" # -- we need this for forcing install_name
			# \${CMAKE_INSTALL_PREFIX}/lib is correct because when building we pass INSTALL_LIB_DIR with /lib
			STELLA_CMAKE_EXTRA_FLAGS="$STELLA_CMAKE_EXTRA_FLAGS -DCMAKE_INSTALL_NAME_DIR=\${CMAKE_INSTALL_PREFIX}/lib"

			[ ! "$_rpath" = "" ] && __set_build_env "CMAKE_RPATH" "INSTALL_PHASE_ADD_FINAL_RPATH" "$_rpath"
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then

			__set_build_env "CMAKE_RPATH" "ALL_PHASE_USE_RPATH"

			# cmake build phase
			__set_build_env "CMAKE_RPATH" "BUILD_PHASE_NO_RPATH"

			# cmake install phase
			__set_build_env "CMAKE_RPATH" "INSTALL_PHASE_USE_FINAL_RPATH"

			# add dependent lib directories to rpath value.
			__set_build_env "CMAKE_RPATH" "INSTALL_PHASE_ADD_DEPENDENT_LIB"
			# \${CMAKE_INSTALL_PREFIX}/lib is correct because when building we pass INSTALL_LIB_DIR with /lib
			#[ ! "$_rpath" = "" ] && __set_build_env "CMAKE_RPATH" "INSTALL_PHASE_ADD_FINAL_RPATH" "\${CMAKE_INSTALL_PREFIX}/lib;$_rpath"
			[ ! "$_rpath" = "" ] && __set_build_env "CMAKE_RPATH" "INSTALL_PHASE_ADD_FINAL_RPATH" "$_rpath"
		fi
	fi



	# CMAKE Flags
	# note :
	#	- these flags have to be passed to the cmake command line, as cmake do not read en var
	#	- list of environment variables read by cmake http://www.cmake.org/Wiki/CMake_Useful_Variables#Environment_Variables
	CMAKE_C_FLAGS="$STELLA_C_CXX_FLAGS"
	CMAKE_CXX_FLAGS="$STELLA_C_CXX_FLAGS"

	# Linker flags to be used to create shared libraries
	CMAKE_SHARED_LINKER_FLAGS="$STELLA_LINK_FLAGS $STELLA_DYNAMIC_LINK_FLAGS"
	# Linker flags to be used to create module
	CMAKE_MODULE_LINKER_FLAGS="$STELLA_LINK_FLAGS $STELLA_DYNAMIC_LINK_FLAGS"
	# Linker flags to be used to create static libraries
	CMAKE_STATIC_LINKER_FLAGS="$STELLA_LINK_FLAGS $STELLA_STATIC_LINK_FLAGS"
	# Linker flags to be used to create executables
	CMAKE_EXE_LINKER_FLAGS="$STELLA_LINK_FLAGS $STELLA_DYNAMIC_LINK_FLAGS"

	# Linked libraries
	STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH="$(__trim $STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH)"
	STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH="$(__trim $STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH)"
	export CMAKE_LIBRARY_PATH="$STELLA_LINKED_LIBS_CMAKE_LIBRARY_PATH"
	export CMAKE_INCLUDE_PATH="$STELLA_LINKED_LIBS_CMAKE_INCLUDE_PATH"
	# -DCMAKE_MODULE_PATH="$CMAKE_MODULE_PATH"

	# save rpath related flags
	[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && STELLA_CMAKE_EXTRA_FLAGS="$STELLA_CMAKE_EXTRA_FLAGS $STELLA_CMAKE_RPATH $STELLA_CMAKE_RPATH_BUILD_PHASE $STELLA_CMAKE_RPATH_INSTALL_PHASE"
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && STELLA_CMAKE_EXTRA_FLAGS="$STELLA_CMAKE_EXTRA_FLAGS $STELLA_CMAKE_RPATH $STELLA_CMAKE_RPATH_DARWIN $STELLA_CMAKE_RPATH_BUILD_PHASE $STELLA_CMAKE_RPATH_INSTALL_PHASE"

	STELLA_CMAKE_EXTRA_FLAGS="$(__trim $STELLA_CMAKE_EXTRA_FLAGS)"
}


# set flags and env for standard build tools (GNU MAKE,...)
__set_env_vars_for_gcc() {

	# RPATH Management
	for r in $STELLA_BUILD_RPATH; do

		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			# to avoid problem with $$ORIGIN -- only usefull with standard build tools (do not need this with cmake)
			r=${r/\$ORIGIN/\$\$ORIGIN}
			STELLA_LINK_FLAGS="$STELLA_LINK_FLAGS -Wl,-rpath='"$r"'"
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			# NOTE : if we use ' or " around $r, it will be used as rpath value
			STELLA_LINK_FLAGS="$STELLA_LINK_FLAGS -Wl,-rpath,$r"
		fi
	done


	# ADD linked libraries flags
	STELLA_LINKED_LIBS_C_CXX_FLAGS="$(__trim $STELLA_LINKED_LIBS_C_CXX_FLAGS)"
	STELLA_LINKED_LIBS_CPP_FLAGS="$(__trim $STELLA_LINKED_LIBS_CPP_FLAGS)"
	STELLA_LINKED_LIBS_LINK_FLAGS="$(__trim $STELLA_LINKED_LIBS_LINK_FLAGS)"

	STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS $STELLA_LINKED_LIBS_C_CXX_FLAGS"
	STELLA_CPP_FLAGS="$STELLA_CPP_FLAGS $STELLA_LINKED_LIBS_CPP_FLAGS"
	STELLA_LINK_FLAGS="$STELLA_LINKED_LIBS_LINK_FLAGS $STELLA_LINK_FLAGS $STELLA_DYNAMIC_LINK_FLAGS $STELLA_STATIC_LINK_FLAGS"


 	if [ "$STELLA_BUILD_MIX_CPP_C_FLAGS" = "ON" ]; then
 		# flags to pass to the C compiler.
		export CFLAGS="$STELLA_C_CXX_FLAGS $STELLA_CPP_FLAGS"
		# flags to pass to the C++ compiler
		export CXXFLAGS="$STELLA_C_CXX_FLAGS $STELLA_CPP_FLAGS"
	else
		export CFLAGS="$STELLA_C_CXX_FLAGS"
		export CXXFLAGS="$STELLA_C_CXX_FLAGS"
	fi
	# flags to pass to the C preprocessor. Used when compiling C and C++ (Used to pass -Iinclude_folder)
	export CPPFLAGS="$STELLA_CPP_FLAGS"
	# flags to pass to the linker
	export LDFLAGS="$STELLA_LINK_FLAGS"
}




# settings compiler flags -- depend on toolset (configure tool, build tool, compiler frontend)
__set_build_env() {

	# LINK_FLAGS_DEFAULT -----------------------------------------------------------------
	# Activate some default link flags
	# TODO experimental new flags => transform into set_build_env
	# https://sourceware.org/binutils/docs/ld/Options.html
	# http://www.kaizou.org/2015/01/linux-libraries/
	if [ "$1" = "LINK_FLAGS_DEFAULT" ]; then
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
				if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
					case $2 in
						ON)
							# NOTE : these flags do not work when building static lib with "ar" tool
							# http://stackoverflow.com/a/2356407
							#  -Wl,--no-allow-shlib-undefined
							STELLA_DYNAMIC_LINK_FLAGS="-Wl,--copy-dt-needed-entries -Wl,--as-needed -Wl,--no-undefined $STELLA_DYNAMIC_LINK_FLAGS"
						;;
						OFF)
							STELLA_DYNAMIC_LINK_FLAGS=
						;;
					esac
				fi
		fi
	fi

	# CPU_INSTRUCTION_SCOPE -----------------------------------------------------------------
	# http://sdf.org/~riley/blog/2014/10/30/march-mtune/
	if [ "$1" = "CPU_INSTRUCTION_SCOPE" ]; then
		if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
			case $2 in
				CURRENT)
					STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -march=native"
					;;
				SAME_FAMILY)
					STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -mtune=native"
					;;
				GENERIC)
					STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -mtune=generic"
					;;
			esac
		fi
	fi

	# set OPTIMIZATION -----------------------------------------------------------------
	if [ "$1" = "OPTIMIZATION" ]; then
		if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
			[ ! "$2" = "" ] && STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -O$2"
		fi
	fi

	# ARCH -----------------------------------------------------------------
	# Setting flags for a specific arch
	if [ "$1" = "ARCH" ]; then
		if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
			if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
				case $2 in
					x86)
						STELLA_C_CXX_FLAGS="-m32 $STELLA_C_CXX_FLAGS"
						;;
					x64)
						STELLA_C_CXX_FLAGS="-m64 $STELLA_C_CXX_FLAGS"
						;;
				esac
			fi
			# for darwin -m and -arch are near the same
			# http://stackoverflow.com/questions/1754460/apples-gcc-whats-the-difference-between-arch-i386-and-m32
			if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
				case $2 in
					x86)
						STELLA_C_CXX_FLAGS="-arch i386 $STELLA_C_CXX_FLAGS"
						;;
					x64)
						STELLA_C_CXX_FLAGS="-arch x86_64 $STELLA_C_CXX_FLAGS"
						;;
					universal)
						STELLA_C_CXX_FLAGS="-arch i386 -arch x86_64 $STELLA_C_CXX_FLAGS"
						;;
				esac
			fi
		fi
	fi

	# fPIC is usefull when building shared libraries for x64
	# not for x86 : http://stackoverflow.com/questions/7216244/why-is-fpic-absolutely-necessary-on-64-and-not-on-32bit-platforms -- http://stackoverflow.com/questions/6961832/does-32bit-x86-code-need-to-be-specially-pic-compiled-for-shared-library-files
	# On MacOS it is active by default
	if [ "$1" = "ARCH" ]; then
		if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
			if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
				case $2 in
					x64)
						STELLA_C_CXX_FLAGS="-fPIC $STELLA_C_CXX_FLAGS"
						;;
				esac
			fi
		fi
	fi

	# MACOSX_DEPLOYMENT_TARGET -----------------------------------------------------------------
	if [ "$1" = "MACOSX_DEPLOYMENT_TARGET" ]; then
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			if [ ! "$2" = "" ]; then
				export MACOSX_DEPLOYMENT_TARGET=$2
				STELLA_CMAKE_EXTRA_FLAGS="$STELLA_CMAKE_EXTRA_FLAGS -DCMAKE_OSX_DEPLOYMENT_TARGET=$2"
				STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -mmacosx-version-min=$2"
			fi
		fi
	fi


	# DARWIN STDLIB -----------------------------------------------------------------
	# http://stackoverflow.com/a/19637199
	# On 10.8 and earlier libstdc++ is chosen by default, on version >= 10.9 libc++ is chosen by default.
	# by default -mmacosx-version-min value is used to choose one of them
	# about linux and macos c++ libs : # http://stackoverflow.com/a/19774902/5027535
	if [ "$1" = "DARWIN_STDLIB" ]; then
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			# we seems to need this on both cflags and ldflags (i.e for openttd)
			[ "$2" = "LIBCPP" ] && STELLA_LINK_FLAGS="$STELLA_LINK_FLAGS -stdlib=libc++"
			[ "$2" = "LIBSTDCPP" ] && STELLA_LINK_FLAGS="$STELLA_LINK_FLAGS -stdlib=libstdc++"
			[ "$2" = "LIBCPP" ] && STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -stdlib=libc++"
			[ "$2" = "LIBSTDCPP" ] && STELLA_C_CXX_FLAGS="$STELLA_C_CXX_FLAGS -stdlib=libstdc++"
		fi
	fi


	# RUNPATH/RPATH
	# prefer setting RUNPATH over setting RPATH
	# enable-new-dtags : http://blog.tremily.us/posts/rpath/
	if [ "$1" = "RUNPATH_OVER_RPATH" ]; then
		if [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "gcc" ] || [ "$STELLA_BUILD_COMPIL_FRONTEND_BIN_FAMILY" = "clang" ]; then
			if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
				STELLA_DYNAMIC_LINK_FLAGS="$STELLA_DYNAMIC_LINK_FLAGS -Wl,--enable-new-dtags"
			fi
		fi
	fi

	# CMAKE_RPATH -----------------------------------------------------------------
	# Change behaviour of cmake about RPATH
	# CMAKE have 2 phases
	# During each phase a rpath value is determined and used
	# On Linux :
	#		1.Build Phase
	#			While building the binary and running tests
	# 			* [DEFAULT] CMAKE set binary RPATH value with the current build path as RPATH value (CMAKE_SKIP_BUILD_RPATH=OFF)
	#				* CMAKE set binary RPATH value with EMPTY VALUE (CMAKE_SKIP_BUILD_RPATH=ON)
	#				* CMAKE set binary RPATH value with CMAKE_INSTALL_RPATH value (CMAKE_BUILD_WITH_INSTALL_RPATH=ON) - (and so, do not have to re-set it while installing)
	#		2.Install Phase
	#			When installing the binanry
	#				* CMAKE set binary RPATH value with EMPTY VALUE (CMAKE_SKIP_INSTALL_RPATH=ON)
	#				* [DEFAULT] CMAKE add as binary RPATH value CMAKE_INSTALL_RPATH value
	#				* CMAKE add as binary RPATH value all dependent libraries outside the current build tree folder as RPATH value (CMAKE_INSTALL_RPATH_USE_LINK_PATH=ON)
	#	Note : CMAKE_SKIP_RPATH=ON : CMAKE set binary RPATH value with EMPTY VALUE during both phase (building and installing)
	#	Default :
	#		CMAKE_SKIP_RPATH : OFF
	#		CMAKE_SKIP_BUILD_RPATH : OFF
	#		CMAKE_BUILD_WITH_INSTALL_RPATH : OFF
	#		CMAKE_INSTALL_RPATH "" (empty)
	#		CMAKE_INSTALL_RPATH_USE_LINK_PATH : OFF
	#		CMAKE_SKIP_INSTALL_RPATH : OFF
	# On MacOSX :
	#		http://www.kitware.com/blog/home/post/510
	#		http://matthew-brett.github.io/docosx/mac_runtime_link.html
	#		1.Build Phase
	#			* CMAKE set binary RPATH value with "@rpath" during both phase (CMAKE_MACOSX_RPATH=ON)
	#		2.Install Phase
	#			* CMAKE set binary RPATH value with "@rpath" during both phase (CMAKE_MACOSX_RPATH=ON)
	#			* CMAKE set binary RPATH value with INSTALL_NAME_DIR if it setted
	#	Default :
	#		CMAKE_MACOSX_RPATH : ON
	if [ "$1" = "CMAKE_RPATH" ]; then
		case $2 in

			# no rpath during BUILD PHASE
			BUILD_PHASE_NO_RPATH)
				STELLA_CMAKE_RPATH_BUILD_PHASE="-DCMAKE_SKIP_BUILD_RPATH=ON" # DEFAULT : OFF
				;;

			BUILD_PHASE_USE_BUILD_FOLDER)
				STELLA_CMAKE_RPATH_BUILD_PHASE="-DCMAKE_SKIP_BUILD_RPATH=OFF -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF" # DEFAULT : OFF / OFF
				;;

			BUILD_PHASE_USE_FINAL_RPATH)
				STELLA_CMAKE_RPATH_BUILD_PHASE="-DCMAKE_SKIP_BUILD_RPATH=OFF -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON" # DEFAULT :  OFF / OFF
				;;




			INSTALL_PHASE_NO_RPATH)
				STELLA_CMAKE_RPATH_INSTALL_PHASE="-DCMAKE_SKIP_INSTALL_RPATH=ON" # DEFAULT : OFF
				;;

			INSTALL_PHASE_USE_FINAL_RPATH)
				STELLA_CMAKE_RPATH_INSTALL_PHASE="$STELLA_CMAKE_RPATH_INSTALL_PHASE -DCMAKE_SKIP_INSTALL_RPATH=OFF" # DEFAULT : OFF
				;;

			INSTALL_PHASE_ADD_FINAL_RPATH)
				# NOTE : this is a list !
				STELLA_CMAKE_RPATH_INSTALL_PHASE="$STELLA_CMAKE_RPATH_INSTALL_PHASE -DCMAKE_INSTALL_RPATH=$3" # DEFAULT : empty string
				;;

			# add folder containing dependent lib, which are outside of the project
			INSTALL_PHASE_ADD_DEPENDENT_LIB)
				STELLA_CMAKE_RPATH_INSTALL_PHASE="$STELLA_CMAKE_RPATH_INSTALL_PHASE -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON" # DEFAULT : OFF
				;;



			ALL_PHASE_NO_RPATH)
				STELLA_CMAKE_RPATH="-DCMAKE_SKIP_RPATH=ON" # DEFAULT : OFF
			;;
			ALL_PHASE_USE_RPATH)
				STELLA_CMAKE_RPATH="-DCMAKE_SKIP_RPATH=OFF" # DEFAULT : OFF
			;;


			# For DARWIN
			ALL_PHASE_NO_RPATH_DARWIN)
				STELLA_CMAKE_RPATH_DARWIN="-DCMAKE_MACOSX_RPATH=OFF" # DEFAULT : ON
			;;
			ALL_PHASE_USE_RPATH_DARWIN)
				# DEFAULT : ON
				# activate @rpath/lib_name as INSTALL_NAME for lib built with CMAKE
				# activate management of rpath values during BUILD and INSTALL phase
				STELLA_CMAKE_RPATH_DARWIN="-DCMAKE_MACOSX_RPATH=ON" # DEFAULT : ON
			;;


		esac

	fi


}




fi
