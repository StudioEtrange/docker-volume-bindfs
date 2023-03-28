#!sh
if [ ! "$_STELLA_COMMON_BINARY_INCLUDED_" = "1" ]; then
_STELLA_COMMON_BINARY_INCLUDED_=1

# GENERIC
# __is_multi_arch		# TEST FILE IS BIN - NON RECURSIVE -- [RETURN ERROR CODE]
# __get_arch				# TEST FILE IS BIN - NON RECURSIVE
# __get_elf_interpreter_linux # TEST FILE IS BIN - NON RECURSIVE
# __check_arch			# TEST FILE IS BIN - RECURSIVE -- [RETURN ERROR CODE]
# __check_binary_file # TEST FILE IS BIN - RECURSIVE -- OPTIONAL FILTER -- [RETURN ERROR CODE]
# __tweak_binary_file # TEST FILE IS BIN - RECURSIVE -- OPTIONAL FILTER AND OPTIONAL FILTER FOR LIB

# RPATH
# __get_rpath					# TEST IS EXEC OR DYN FILE - NON RECURSIVE
# __have_rpath				# TEST IS A FILE - RECURSIVE	-- [RETURN ERROR CODE]
# __tweak_rpath				# TEST IS EXEC OR DYN FILE - RECURSIVE -- OPTIONAL FILTER
# __remove_all_rpath 	# TEST IS EXEC OR DYN FILE - RECURSIVE
# __add_rpath					# TEST IS EXEC OR DYN FILE - RECURSIVE
# __check_rpath				# TEST IS EXEC OR DYN FILE - RECURSIVE -- [RETURN ERROR CODE]

# LINKED LIB
# __get_linked_lib		# TEST IS EXEC OR DYN FILE - NON RECURSIVE -- OPTIONAL FILTER FOR LIB
# __check_linked_lib	# TEST IS EXEC OR DYN FILE - RECURSIVE -- OPTIONAL FILTER -- [RETURN ERROR CODE]
# __find_linked_lib_darwin	# TEST IS EXEC OR DYN FILE - RECURSIVE -- [RETURN ERROR CODE]
#	__find_linked_lib_linux		# TEST IS EXEC OR DYN FILE - RECURSIVE -- [RETURN ERROR CODE]
# __tweak_linked_lib	# TEST IS EXEC OR DYN FILE - RECURSIVE -- OPTIONAL FILTER AND OPTIONAL FILTER FOR LIB

# DARWIN : install_name
# __get_install_name_darwin 	# TEST IS MACHO AND IS DYN FILE - NON RECURSIVE
# __check_install_name_darwin	# TEST IS MACHO AND IS DYN FILE - RECURSIVE -- OPTIONAL FILTER -- [RETURN ERROR CODE]
# __tweak_install_name_darwin # TEST IS MACHO AND IS DYN FILE - RECURSIVE -- OPTIONAL FILTER

# NOTE
#			LINUX ELF TOOLS
#					objdump (needed to analysis) -- in sys package gnu binutils (WARN : objdump not always present on linux system / prefer readelf ? see lddtree to change objdump to readelf)
#					ldd (needed for linked lib analys) -- present by default => security warning
#					patchelf (needed to analysis AND modify rpath) -- in stella recipe 'patchelf'
#					scanelf (needed to analysis) -- in stella recipe pax-utils
#					readelf (needed to analysis)-- in sys package gnu 'binutils'
#			MACOS BINARY TOOLS :
#					otool (needed to analysis) -- in ??
#					install_name_tool (needed to modify rpath, install_name and already linked lib. Cannot add or remove linked lib) -- in ??
#			MACOS : install_name, rpath, loader_path, executable_path
# 					https://mikeash.com/pyblog/friday-qa-2009-11-06-linking-and-install-names.html
#					http://jorgen.tjer.no/post/2014/05/20/dt-rpath-ld-and-at-rpath-dyld/
#					https://wincent.com/wiki/@executable_path,_@load_path_and_@rpath
#
#			LINKED LIBS
#						LINUX : Dynamic libs will be searched at RUNTINE in the following directories in the given order:
#							1. DT_RPATH - a list of directories which is linked into the executable, supported on most UNIX systems.
#											The DT_RPATH entries are ignored if DT_RUNPATH entries exist.
#							2. LD_LIBRARY_PATH - an environment variable which holds a list of directories
#							3. DT_RUNPATH - same as RPATH, but searched after LD_LIBRARY_PATH, supported only on most recent UNIX systems, e.g. on most current Linux systems
#							4. /etc/ld.so.conf and /etc/ld.so.conf/* - configuration file for ld.so which lists additional library directories
#							5. builtin directories - basically /lib and /usr/lib
#
#						LINUX : Static and dynamic libraries will be searched at BUILD time in the folowwing order - see common-platform function __default_linker_search_path
#							1. LIBRARY_PATH
#							2. path giver to the linker from gcc option -L and gcc hardcoded path
#							3. hardcoded path into the linker

#					  LINUX INFO :
#								http://blog.tremily.us/posts/rpath/
# 								https://bbs.archlinux.org/viewtopic.php?id=6460
# 								http://www.cyberciti.biz/tips/linux-shared-library-management.html
#								http://www.kaizou.org/2015/01/linux-libraries/
#								https://stackoverflow.com/a/4250666/5027535
#
#						LINUX	TOOLS :
#								https://github.com/gentoo/pax-utils
#								https://github.com/ncopa/lddtree
#
#						MACOS :
#								Use DYLD_LIBRARY_PATH instead of LD_LIBRARY_PATH
#
#						LINUX DEBUG :
#								LD_TRACE_LOADED_OBJECTS=1 LD_DEBUG=libs ./program
#								LD_DEBUG values http://www.bnikolic.co.uk/blog/linux-ld-debug.html
#
#						MACOS DEBUG :
#								DYLD_PRINT_LIBRARIES=y ./program
#
# 	 	LINUX RPATH : PATCHELF
#							using patchelf  "--set-rpath, --shrink-rpath and --print-rpath now prefer DT_RUNPATH over DT_RPATH,
#							which is obsolete. When updating, if both are present, both are updated.
# 						If only DT_RPATH is present, it is converted to DT_RUNPATH unless --force-rpath is specified.
# 						If neither is present, a DT_RUNPATH is added unless --force-rpath is specified, in which case a DT_RPATH is added."
#




# GENERIC -------------------------------------------------------------------

__get_elf_interpreter_linux() {
	local _file="$1"
	if __is_bin "$_file"; then
		readelf  -p ".interp" "$_file" | sed -E -n '/\[\s*[0-9]\]/s/^\s*\[.*\]\s*(.*)/\1/p'
	fi
}

__is_multi_arch() {
	local _file="$1"
	local _result=1
	if __is_bin "$_file"; then
		__is_macho_universal "$_file" && _result=0
	fi
	return $_result
}

__get_arch() {
	local _file="$1"
	local _arch
	if __is_bin "$_file"; then
		local _bit="$(__bit_bin "$_file")"
		case $_bit in
			32)
			_arch="x86"
				;;
			64)
			_arch="x64"
				;;
		esac
	fi
	echo "$_arch"
}


__check_arch() {
	local _path="$1"
	local _wanted_arch="$2"
	local _arch=
	local _result=0


	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__check_arch "$f" "$_wanted_arch" || _result=1
		done
	fi

	if __is_bin "$_path"; then
		_arch="$(__get_arch $_path)"
		if [ "$_wanted_arch" = "" ]; then
			echo "*** Detected ARCH : $_arch"
		else
			if [ "$_wanted_arch" = "$_arch" ]; then
				echo "*** Detected ARCH : $_arch -- OK"
			else
				_result=1
				echo "*** Detected ARCH : $_arch Wanted ARCH : $_wanted_arch -- WARN"
			fi
		fi
	fi
	return $_result
}



# run some test for binary files
__check_binary_file() {
	local path="$1"
	local OPT="$2"
	local _result=0

	local f
	if [ -d "$path" ]; then
		for f in  "$path"/*; do
			__check_binary_file "$f" "$OPT" || _result=1
		done
	fi

	# INCLUDE_LINKED_LIB <expr> -- include these linked libs while checking
	# EXCLUDE_LINKED_LIB <expr> -- exclude these linked libs while checking
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
	# INCLUDE_FILTER <expr> -- include these files to check
	# EXCLUDE_FILTER <expr> -- exclude these files to check
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
	# RELOCATE -- binary file should be relocatable
	# NON_RELOCATE -- binary file should be non relocatable
	# ARCH <arch> -- test a specific arch
	# WANTED_RPATH val1 val2 ... -- test if binary files have some specific values as rpath
	local _arch=
	local _flag_arch=OFF
	local _opt_arch=OFF
	local _flag_relocate=DEFAULT
	for o in $OPT; do
		[ "$_flag_arch" = "ON" ] && _arch=$o && _flag_arch=OFF
		[ "$o" = "ARCH" ] && _opt_arch=ON && _flag_arch=ON
		[ "$o" = "RELOCATE" ] && _flag_relocate=YES
		[ "$o" = "NON_RELOCATE" ] && _flag_relocate=NO
	done

	[ -z "$(__filter_list "$path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return $_result

	if __is_bin "$path"; then

		echo
		echo "-*--*-** Analysing $path **-*--*-"

		if [ "$_opt_arch" = "ON" ]; then
			__check_arch "$path" "$_arch" || _result=1
		fi

		case $_flag_relocate in
			YES)
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					__check_install_name_darwin "$path" "RPATH $OPT" || _result=1
				fi
				__check_rpath "$path" "REL_RPATH $OPT" || _result=1
				__check_linked_lib "$path" "REL_PATH $OPT"  || _result=1
				;;
			NO)
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					__check_install_name_darwin "$path" "PATH $OPT" || _result=1
				fi
				__check_rpath "$path" "ABS_RPATH $OPT" || _result=1
				__check_linked_lib "$path" "ABS_PATH $OPT" || _result=1
				;;
			DEFAULT)
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					__check_install_name_darwin "$path" "$OPT" || _result=1
				fi
				__check_rpath "$path" "$OPT" || _result=1
				__check_linked_lib "$path" "$OPT" || _result=1

				;;
		esac

		echo
	fi

	return $_result

}





__tweak_binary_file() {
	local _path="$1"
	local OPT="$2"

	local f
	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__tweak_binary_file "$f" "$OPT"
		done
	fi

	# INCLUDE_LINKED_LIB <expr> -- include these linked libs while tweaking
	# EXCLUDE_LINKED_LIB <expr> -- exclude these linked libs while tweaking
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
	# FIX_LINKED_LIB <path> -- change path of linked libs to path (relative path will be computed)
	# INCLUDE_FILTER <expr> -- include these files to tweak
	# EXCLUDE_FILTER <expr> -- exclude these files to tweak
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
	# RELOCATE -- binary have to be relocatable
	# NON_RELOCATE -- binary have to be non relocatable
	# WANTED_RPATH val1 val2 ... -- binary rpath values to set
	local _flag_relocate=DEFAULT
	local _fix_linked_lib=
	local _flag_fix_linked_lib=OFF
	local _opt_fix_linked_lib=OFF
	local _flag_wanted_rpath=OFF
	local _wanted_rpath_values=
	local _opt_wanted_rpath=OFF
	for o in $OPT; do
		[ "$_flag_fix_linked_lib" = "ON" ] && _fix_linked_lib="$o" && _flag_fix_linked_lib=OFF
		[ "$o" = "FIX_LINKED_LIB" ] && _flag_fix_linked_lib=ON && _opt_fix_linked_lib=ON && _flag_wanted_rpath=OFF
		[ "$o" = "RELOCATE" ] && _flag_relocate=YES && _flag_wanted_rpath=OFF
		[ "$o" = "NON_RELOCATE" ] && _flag_relocate=NO && _flag_wanted_rpath=OFF
		[ "$_flag_wanted_rpath" = "ON" ] && _wanted_rpath_values="$o $_wanted_rpath_values"
		[ "$o" = "WANTED_RPATH" ] && _flag_wanted_rpath=ON && _opt_wanted_rpath=ON
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return

	if __is_bin "$_path"; then

		echo
		echo "-*--*-** Fixing if necessary $_path **-*--*-"

		if [ "$_opt_fix_linked_lib" = "ON" ]; then
			if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
				__tweak_install_name_darwin "$_path" "RPATH $OPT"
			fi
			__remove_all_rpath "$_path"
			__tweak_linked_lib "$_path" "REL_LINK_FORCE $_fix_linked_lib $OPT"
			if [ ! "$_wanted_rpath_values" = "" ]; then
				__have_rpath "$_path" "$_wanted_rpath_values" || __add_rpath "$_path" "$_wanted_rpath_values"
			fi
		else

			case $_flag_relocate in
				YES)
					if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
						__tweak_install_name_darwin "$_path" "RPATH $OPT"
					fi
					if [ ! "$_wanted_rpath_values" = "" ]; then
						__have_rpath "$_path" "$_wanted_rpath_values" || __add_rpath "$_path" "$_wanted_rpath_values"
					fi
					__tweak_linked_lib "$_path" "ABS_LINK_TO_REL $OPT"
					__tweak_rpath "$_path" "REL_RPATH $OPT"
					;;
				NO)
					if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
						__tweak_install_name_darwin "$_path" "PATH $OPT"
					fi
					__tweak_linked_lib "$_path" "REL_LINK_TO_ABS $OPT"
					__remove_all_rpath "$_path"
					;;
				DEFAULT)
					if [ ! "$_wanted_rpath_values" = "" ]; then
						__have_rpath "$_path" "$_wanted_rpath_values" || __add_rpath "$_path" "$_wanted_rpath_values"
					fi
					;;
			esac
		fi
		echo
	fi
}






# RPATH -------------------------------------------------------------------
# return rpath values in search order
__get_rpath() {
	local _file="$1"
	local _rpath_values

	if __is_executable_or_shareable_bin "$_file"; then
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			_rpath_values="$(otool -l "$_file" | grep -E "LC_RPATH" -A2 | awk '/LC_RPATH/{for(i=2;i;--i)getline; print $0 }' | tr -s ' ' | cut -d ' ' -f 3 |  tr '\n' ' ')"
			echo "$(__trim $_rpath_values)"
		fi

		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			local _field='RUNPATH'
			IFS=':' read -ra _rpath_values <<< $(objdump -p $_file | grep -E "$_field\s" | tr -s ' ' | cut -d ' ' -f 3)
			if [ "$_rpath_values" = "" ]; then
				_field="RPATH"
				IFS=':' read -ra _rpath_values <<< $(objdump -p $_file | grep -E "$_field\s" | tr -s ' ' | cut -d ' ' -f 3)
			fi
			echo "${_rpath_values[@]}"
		fi
	fi
}





# modify rpath values to all binaries in the path
# ABS_RPATH : transform relative rpath values to absolute path - so rpath values turn from ../foo to /path/foo
# REL_RPATH [DEFAULT] : transform absolute rpath values to relative path
#																-	FOR MACOS : rpath values turn from /path/foo to @loader_path/foo
#																-	FOR LINUX : rpath values turn from /path/foo to $ORIGIN/foo
__tweak_rpath() {
	local _path=$1
	local _OPT="$2"
	# INCLUDE_FILTER <expr> -- include these files to tweak
	# EXCLUDE_FILTER <expr> -- exclude these files to tweak
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__tweak_rpath "$f" "$_OPT"
		done
	fi

	local _rel_rpath=ON
	local _abs_rpath=OFF
	for o in $_OPT; do
		[ "$o" = "REL_RPATH" ] && _rel_rpath=ON && _abs_rpath=OFF
		[ "$o" = "ABS_RPATH" ] && _rel_rpath=OFF && _abs_rpath=ON
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $_OPT")" ] && return

	if __is_executable_or_shareable_bin "$_path"; then
		local _rpath_values=
		local _new_rpath_values=
		local _flag_change=
		local _p=

		_rpath_values="$(__get_rpath $_path)"

		for line in $_rpath_values; do
			_p=
			if [ "$_abs_rpath" = "ON" ]; then
				if [ "$(__is_abs $line)" = "FALSE" ];then
					[ ! "$_flag_change" = "1" ] && echo "*** Fixing RPATH for $_path"

					_p="$(__rel_to_abs_path "$line" $(__get_path_from_string $_path))"
					echo "=> Transform $line to abs path : $_p"

					_new_rpath_values="$_new_rpath_values $_p"
					_flag_change=1
				else
					_new_rpath_values="$_new_rpath_values $line"
				fi
			else
				if [ "$_rel_rpath" = "ON" ]; then
					if [ "$(__is_abs $line)" = "TRUE" ];then
						[ ! "$_flag_change" = "1" ] && echo "*** Fixing RPATH for $_path"

						[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && _p="@loader_path/$(__abs_to_rel_path "$line" $(__get_path_from_string $_path))"
						[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && _p="\$ORIGIN/$(__abs_to_rel_path "$line" $(__get_path_from_string $_path))"
						echo "=> Transform $line to rel path : $_p"

						_new_rpath_values="$_new_rpath_values $_p"
						_flag_change=1
					else
						_new_rpath_values="$_new_rpath_values $line"
					fi
				fi
			fi

		done

		if [ "$_flag_change" = "1" ]; then
			__remove_all_rpath "$_path"
			__add_rpath "$_path" "$_new_rpath_values" "LAST"
		fi
	fi
}




# remove all rpath values to all binaries in the path
__remove_all_rpath() {
	local _path="$1"

	local _rpath_list_values
	local msg=

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__remove_all_rpath "$f"
		done
	fi

	if __is_executable_or_shareable_bin "$_path"; then
		_rpath_list_values="$(__get_rpath $_path)"
		# fix write permission
		chmod +w "$_path"
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			for r in $_rpath_list_values; do
				msg="$msg -- deleting RPATH value : $r"
				install_name_tool -delete_rpath "$r" "$_path"
			done
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			__require "patchelf" "patchelf#0_10" "STELLA_FEATURE"
				msg="$msg -- deleting all RPATH values."
			patchelf --remove-rpath "$_path"
		fi
		[ ! "$msg" = "" ] && echo "** Deleting rpath values from $_path $msg"
	fi
}


# check if binary have some specific rpath values
__have_rpath() {
	local _path="$1"
	local _rpath_values="$2"
	local _result=0
	local j
	local r

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__have_rpath "$f" "$_rpath_values" || _result=1
		done
	fi

	[ -z "$_rpath_values" ] && return $_result

	if __is_executable_or_shareable_bin "$_path"; then
		local _existing_rpath="$(__get_rpath $_path)"
		echo "*** Checking missing rpath values : $_rpath_values"

		for r in $_rpath_values; do
			local _match=0
			printf %s "=> checking : $r"
			for j in $_existing_rpath; do
				[ "$j" = "$r" ] && _match=1
			done
			if [ "$_match" = "1" ]; then
				printf %s " -- OK"
			else
				printf %s " -- WARN RPATH is missing"
				_result=1
			fi
			echo
		done
	fi

	return $_result
}


# add rpath values to all binaries in the path by adding rpath values contained in list _rpath_list_values
# if a rpath value is already setted, it will be just reordered
# 		FIRST (DEFAULT) : rpath values will be put in first order search
#			LAST : rpath values will be put in last order search
__add_rpath() {
	local _path=$1
	local _rpath_list_values="$2"
	local OPT="$3"

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__add_rpath "$f" "$_rpath_list_values" "$OPT"
		done
	fi

	local msg=

	if __is_executable_or_shareable_bin "$_path"; then
		local _flag_first_place=ON
		local _flag_last_place=OFF
		for o in $OPT; do
			[ "$o" = "FIRST" ] && _flag_first_place=ON && _flag_last_place=OFF
			[ "$o" = "LAST" ] && _flag_first_place=OFF && _flag_last_place=ON
		done

		local _old_rpath=
		local _flag_found=
		local _rpath=
		local _new_rpath=

		_old_rpath="$(__get_rpath $_path)"
		for r in $_old_rpath; do
			_flag_found=0
			for n in $_rpath_list_values; do
				if [ "$n" = "$r" ]; then
					msg="$msg -- moving RPATH value : $r"
					_flag_found=1
				fi
			done
			[ "$_flag_found" = "0" ] && _new_rpath="$_new_rpath $r"
		done

		[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && __remove_all_rpath "$_path"

		if [ "$_flag_first_place" = "ON" ]; then
			_new_rpath="$_rpath_list_values $_new_rpath"
		fi
		if [ "$_flag_last_place" = "ON" ]; then
			_new_rpath="$_new_rpath $_rpath_list_values"
		fi

		# adding values
		_new_rpath="$(__trim $_new_rpath)"
		# fix write permission
		chmod +w "$_path"
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			for p in $_new_rpath; do
				msg="$msg -- adding RPATH value : $p"
				install_name_tool -add_rpath "$p" "$_path"
			done
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			__require "patchelf" "patchelf#0_10" "STELLA_FEATURE"
			patchelf --set-rpath "${_new_rpath// /:}" "$_path"
			msg="$msg -- adding : $_new_rpath"
		fi

		[ ! "$msg" = "" ] && echo "*** Adding rpath values to $_path $msg"
	fi
}


# check rpath values of exexcutable binary and shared lib
# 		NO_RPATH -- must not have any rpath
# 		REL_RPATH -- rpath must be a relative path
# 		ABS_RPATH -- rpath must be an absolute path
#			WANTED_RPATH val1 val2 ... -- check some missing rpath
# 		INCLUDE_FILTER <expr> -- include these files to check
#			EXCLUDE_FILTER <expr> -- exclude these files to check
# 		INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
__check_rpath() {
	local _path="$1"
	local OPT="$2"
	local t
	local _result=0

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__check_rpath "$f" "$OPT" || _result=1
		done
	fi

	local _no_rpath=OFF
	local _rel_rpath=OFF
	local _abs_rpath=OFF
	local _flag_missing_rpath=OFF
	local _missing_rpath_values=
	local _opt_missing_rpath=OFF
	for o in $OPT; do
		[ "$o" = "NO_RPATH" ] && _no_rpath=ON && _flag_missing_rpath=OFF
		[ "$o" = "REL_RPATH" ] && _rel_rpath=ON && _abs_rpath=OFF && _flag_missing_rpath=OFF
		[ "$o" = "ABS_RPATH" ] && _rel_rpath=OFF && _abs_rpath=ON && _flag_missing_rpath=OFF
		[ "$_flag_missing_rpath" = "ON" ] && _missing_rpath_values="$o $_missing_rpath_values"
		[ "$o" = "WANTED_RPATH" ] && _flag_missing_rpath=ON && _opt_missing_rpath=ON
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return $_result

	if __is_executable_or_shareable_bin "$_path"; then
		t="$(__get_rpath $_path)"
		echo "*** Checking rpath"
		echo "=> setted rpath in search order : $t"
		if [ "$_no_rpath" = "ON" ];then
			printf %s "=> checking if there is no RPATH setted "
			if [ "$t" = "" ]; then
				printf %s " -- OK"
				echo
			else
				printf %s " -- RPATH is setted : WARN"
				_result=1
				echo
			fi

		else

			for r in $t; do
				printf %s "=> checking $r "
				if [ "$_abs_rpath" = "ON" ]; then
					if [ "$(__is_abs $r)" = "TRUE" ];then
						printf %s "-- is abs path : OK"
					else
						printf %s "-- is not an abs path : WARN"
					_result=1
					fi
				fi

				if [ "$_rel_rpath" = "ON" ]; then
					if [ "$(__is_abs $r)" = "TRUE" ];then
						printf %s "-- is not a rel path : WARN"
						_result=1
					else
						printf %s "-- is rel path : OK"
					fi
				fi
				echo
			done

			__have_rpath "$_path" "$_missing_rpath_values" || _result=1
			[ $_result ] && echo "*** Checking rpath : OK" || \
			echo "*** Checking rpath : ERROR"
		fi
	fi

	return $_result

}








# LINKED LIB --------------------------------
# return linked libs
__get_linked_lib() {
	local _file="$1"
	local _opt="$2"

	# INCLUDE_LINKED_LIB <expr> -- include these linked libs
	# EXCLUDE_LINKED_LIB <expr> -- exclude these linked libs
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB

	local _linked_lib
	if __is_executable_or_shareable_bin "$_file"; then

		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			_linked_lib="$(otool -l "$_file" | grep -E "LC_LOAD_DYLIB" -A2 | awk '/LC_LOAD_DYLIB/{for(i=2;i;--i)getline; print $0 }' | tr -s ' ' | cut -d ' ' -f 3 | tr '\n' ' ')"
			# we do not exclude STELLA_BINARY_DEFAULT_LIB_IGNORED here, because we may want all linked libs
			_linked_lib="$(__filter_list "$_linked_lib" "INCLUDE_TAG INCLUDE_LINKED_LIB EXCLUDE_TAG EXCLUDE_LINKED_LIB $_opt")"
			echo "$(__trim $_linked_lib)"
		fi

		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			_linked_lib="$(objdump -p $_file | grep -E "NEEDED" | tr -s ' ' | cut -d ' ' -f 3 | tr '\n' ' ')"
			# we do not exclude STELLA_BINARY_DEFAULT_LIB_IGNORED here, because we may want all linked libs
			_linked_lib="$(__filter_list "$_linked_lib" "INCLUDE_TAG INCLUDE_LINKED_LIB EXCLUDE_TAG EXCLUDE_LINKED_LIB $_opt")"
			echo "$(__trim $_linked_lib)"
		fi
	fi
}

# check dynamic link at runtime
# Print out dynamic libraries loaded at runtime when launching a program :
# 		on DARWIN : DYLD_PRINT_LIBRARIES=y program
# 		on LINUX : LD_TRACE_LOADED_OBJECTS=1 program
__check_linked_lib() {
	local _path="$1"
	local _OPT="$2"
	# linked lib filter :
	# INCLUDE_LINKED_LIB <expr> -- include these linked libraries while checking
	# EXCLUDE_LINKED_LIB <expr> -- exclude these linked libraries while checking
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
	# INCLUDE_FILTER <expr> -- include these files to check
	# EXCLUDE_FILTER <expr> -- exclude these files to check
	# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
	# REL_PATH -- linked lib should be linked with relative path
	# ABS_PATH -- linked lib should be linked with absolute path
	local line=
	local linked_lib_list=
	local linked_lib=

	local _result=0

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__check_linked_lib "$f" "$_OPT" || _result=1
		done
	fi

	local _opt_rel_path=OFF
	local _opt_abs_path=OFF
	for o in $_OPT; do
		[ "$o" = "REL_PATH" ] && _opt_rel_path=ON && _opt_abs_path=OFF
		[ "$o" = "ABS_PATH" ] && _opt_abs_path=ON && _opt_rel_path=OFF
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $_OPT")" ] && return $_result

	if __is_executable_or_shareable_bin "$_path"; then

		# First checking linked lib path
		echo "*** Checking form of linked lib path"
		# get all lib -- do not filter here
		local _lib_list="$(__get_linked_lib "$_path")"
		echo "=> Linked libraries : $_lib_list"
		for line in $_lib_list; do
			if [ "$_opt_rel_path" = "ON" ]; then
				[ "$(__is_abs "$line")" = "TRUE" ] && echo "  => $line is NOT relative" && _result=1
			fi
			if [ "$_opt_abs_path" = "ON" ]; then
				[ "$(__is_abs "$line")" = "FALSE" ] && echo "  => $line is NOT absolute" && _result=1
			fi
		done

		if [ "$_result" = "1" ]; then
			echo "*** Checking form of linked lib path : WARN"
		else
			echo "*** Checking form of linked lib path : OK"
		fi
		# second checking : see if we can resolve linked lib
		if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
			__find_linked_lib_darwin "$_path" || _result=1
		fi
		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			__find_linked_lib_linux "$_path" || _result=1
		fi
	fi

	return $_result
}


# try to resolve linked libs of all binaries in path
# OR resolve a list of specific linked libs
__find_linked_lib_darwin() {
	local _path="$1"
	local _opt="$2"
	local _result=0

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__find_linked_lib_darwin "$f" "$_opt" || _result=1
		done
	fi

	local _opt_verbose=ON
	local _flag_lib_list=OFF
	local _lib_list
	local _opt_lib_list=OFF
	for o in $_opt; do
		[ "$o" = "NO_VERBOSE" ] && _opt_verbose=OFF && _flag_lib_list=OFF
		[ "$_flag_lib_list" = "ON" ] && _lib_list="$o $_lib_list"
		[ "$o" = "LIB_LIST" ] && _flag_lib_list=ON && _opt_lib_list=ON
	done


	if __is_executable_or_shareable_bin "$_path"; then
		local _rpath="$(__get_rpath $_path)"
		local loader_path="$(__get_path_from_string "$_path")"

		[ "$_opt_lib_list" = "OFF" ] && _lib_list="$(__get_linked_lib "$_path")"

		if [ "$_opt_verbose" = "ON" ]; then
			echo "*** Checking missing dynamic library at runtime"
			echo "=> Binary : $_path"
			echo "=> Linked libraries : $_lib_list"
			echo "=> setted rpath : $_rpath"
			echo "=> loader path (guessed) : $loader_path"
			echo "=> install name (not used here while resolving libs) : $(__get_install_name_darwin "$_path")"
		fi
		local _match
		local line
		local linked_lib
		local linked_lib_result
		local p
		local original_rpath_value

		for line in $_lib_list; do
			linked_lib=
			_match=
			[ "$_opt_verbose" = "ON" ] && printf %s "=> checking linked lib : $line "
			# @rpath case
			if [ -z "${line##*@rpath*}" ]; then

				for p in $_rpath; do
					original_rpath_value="$p"
					#replace @loader_path
					if [ -z "${p##*@loader_path*}" ]; then
						p="${p/@loader_path/$loader_path}"
					fi
					#replace @executable_path
					if [ -z "${p##*@executable_path*}" ]; then
						p="${p/@executable_path/$loader_path}"
					fi
					linked_lib="${line/@rpath/$p}"
					if [ -f "$linked_lib" ]; then
						[ "$_opt_verbose" = "ON" ] && printf %s "-- OK -- [$original_rpath_value] => $linked_lib"
						_match=1
						break
					fi
				done
			else
				# @loader_path case
				if [ -z "${line##*@loader_path*}" ]; then
					linked_lib="${line/@loader_path/$loader_path}"
					if [ -f "$linked_lib" ]; then
						[ "$_opt_verbose" = "ON" ] && printf %s "-- OK -- [$line] => $linked_lib"
						_match=1
					fi
				# @executable_path case
				elif [ -z "${line##*@executable_path*}" ]; then
					linked_lib="${line/@executable_path/$loader_path}"
					if [ -f "$linked_lib" ]; then
						[ "$_opt_verbose" = "ON" ] && printf %s "-- OK -- [$line] => $linked_lib"
						_match=1
					fi
				else
					linked_lib="$line"
					# NOTE : if a lib is linked in relative (relative path, or just filename),
					# it will be resolved relative to current running dir, not relative to the binary to wich it is linked
					# So it might be a problem. For relative path to the binary, its better to use @loader_path
					if [ "$(__is_abs "$linked_lib")" = "FALSE" ]; then
						[ "$_opt_verbose" = "ON" ] && printf %s "-- WARN : pure relative path - consider use @loader_path or @rpath"
					fi
					if [ -f "$linked_lib" ]; then
						[ "$_opt_verbose" = "ON" ] && printf %s "-- OK"
						_match=1
					fi
				fi
			fi
			if [ "$_match" = "" ]; then
				[ "$_opt_verbose" = "ON" ] && printf %s "-- WARN not found"
				_result=1
			fi
			[ "$_opt_verbose" = "ON" ] && echo
			linked_lib_result="$linked_lib_result $linked_lib"
		done

		if [ "$_opt_verbose" = "OFF" ]; then
			[ "$_result" = "0" ] && echo "$(__trim "$linked_lib_result")"
		fi

		if [ "$_opt_verbose" = "ON" ]; then
			[ "$_result" = "1" ] && echo "*** Checking missing dynamic library at runtime : ERROR" || \
			echo "*** Checking missing dynamic library at runtime : OK"
		fi

	fi

	return $_result
}


# try to resolve linked libs of all binaries in path
# OR resolve a list of specific linked libs
__find_linked_lib_linux() {
	local _path="$1"
	local _opt="$2"
	local _result=0

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__find_linked_lib_linux "$f" "$_opt" || _result=1
		done
	fi

	local _opt_verbose=ON
	local _flag_lib_list=OFF
	local _lib_list
	local _opt_lib_list=OFF
	for o in $_opt; do
		[ "$o" = "NO_VERBOSE" ] && _opt_verbose=OFF && _flag_lib_list=OFF
		[ "$_flag_lib_list" = "ON" ] && _lib_list="$o $_lib_list"
		[ "$o" = "LIB_LIST" ] && _flag_lib_list=ON && _opt_lib_list=ON
	done


	if __is_executable_or_shareable_bin "$_path"; then
		local _rpath="$(__get_rpath $_path)"
		local loader_path="$(__get_path_from_string "$_path")"

		[ "$_opt_lib_list" = "OFF" ] && _lib_list="$(__get_linked_lib "$_path")"

		if [ "$_opt_verbose" = "ON" ]; then
			echo "*** Checking missing dynamic library at runtime"
			echo "=> Binary : $_path"
			echo "=> Linked libraries : $_lib_list"
			echo "=> setted rpath : $_rpath"
			echo "=> loader path (guessed) : $loader_path"
		fi

		if [ "$_opt_verbose" = "ON" ]; then
			__require "readelf" "binutils" "SYSTEM"
			$STELLA_ARTEFACT/lddtree/lddtree.sh -b readelf -m --no-recursive --no-header $_path || _result=1

			[ "$_result" = "1" ] && echo "*** Checking missing dynamic library at runtime : ERROR" || \
			echo "*** Checking missing dynamic library at runtime : OK"
		fi

		if [ "$_opt_verbose" = "OFF" ]; then
			local linked_lib_result

			__require "readelf" "binutils" "SYSTEM" 1>/dev/null 2>&1
			local _output="$($STELLA_ARTEFACT/lddtree/lddtree.sh -b readelf -m --no-recursive --no-header $_path)" || _result=1
			_result=$?
			if [ "$_result" = "0" ]; then
				for l in $_lib_list; do
					l="$(__get_filename_from_string "$l")"
					linked_lib_result="$linked_lib_result $(echo "$_output" | grep "$l =>" | cut -d '=' -f 2 | sed 's/> //' | sed 's/not found//g')"
				done
				echo "$(__trim "$linked_lib_result")"
			fi
		fi
	fi
	return $_result
}



# fix already linked shared lib by modifying LOAD_DYLIB and adding rpath values
# 	- first you can filter libs to tweak
# 				INCLUDE_FILTER <expr> -- include these files to tweak
# 				EXCLUDE_FILTER <expr> -- exclude these files to tweak
# 				INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
# 	-	second filter linked lib to modify path
# 				INCLUDE_LINKED_LIB <expr> -- include these linked libs while tweaking
# 				EXCLUDE_LINKED_LIB <expr> -- exclude these linked libs while tweaking
# 				INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
#		-	third transform path of linked lib -- you can choose between (exclusive choices) :
#				-	REL_LINK_TO_ABS -- transform all linked libs with a rel path to abs path - Try to find elf with information contained in file and turn it into abs path
#																																	(for ELF and Macho : each linked lib will be "<path>/linked_lib_file")
#				-	ABS_LINK_TO_REL -- transform all linked libs with an abs path to rel path
#																																	(for ELF : set linked lib with "lib file name" AND add an RPATH value corresponding to the relative path to the lib with "$ORIGIN/<computed_rel_path_to_lib>")
#																																	(for MachO : set linked lib with "@rpath/lib" and AND an RPATH value corresponding to the relative path to the lib with "@loader_path/<computed_rel_path_to_lib>")
#				- ABS_LINK_FORCE <path> -- force linked libs with a given path injecting an abs path.
#																																	(for ELF and Macho : each linked lib will be "<path>/linked_lib_file")
#				- REL_LINK_FORCE <path> -- force linked libs with a given path injecting an rpath value.
#																																	(for Elf : set linked lib with "linked_lib_file" AND add an RPATH value corresponding to the relative path to the given <path> with "$ORIGIN/<computed_rel_path_to_path>")
#																																	(for MachO : set linked lib with "@rpath/linked_lib_file" AND add an RPATH value corresponding to the relative path to the given <path> with "@loader_path/<computed_rel_path_to_path>")
#				- ABS_RELINK <path_to_lib> -- switch linked lib to another lib with a given path injecting an abs path.
#				- REL_RELINK <path_to_lib> -- switch linked lib to another lib with a given path injecting an rpath value.
__tweak_linked_lib() {
	local _file=$1
	local OPT="$2"

	local f=
	if [ -d "$_file" ]; then
		for f in  "$_file"/*; do
			__tweak_linked_lib "$f" "$OPT"
		done
	fi

	# linked lib filter :
	# INCLUDE_LINKED_LIB <expr> -- include from the transformation these linked libraries
	# EXCLUDE_LINKED_LIB <expr> -- exclude from the transformation these linked libraries
	# INCLUDE_LINKED_LIB is apply first, before EXCLUDE_LINKED_LIB
	# path management :
	# ABS_LINK_FORCE <path>
	# REL_LINK_FORCE <path>
	# REL_LINK_TO_ABS
	# ABS_LINK_TO_REL [DEFAULT MODE]
	# ABS_RELINK <path_to_lib>
	# REL_RELINK <path_to_lib>
	local _rel_link_to_abs=OFF
	local _abs_link_to_rel=ON
	local _flag_fixed_path=OFF

	local _rel_link_force=
	local _opt_rel_link_force=OFF
	local _flag_rel_link_force=OFF

	local _abs_link_force=
	local _opt_abs_link_force=OFF
	local _flag_abs_link_force=OFF

	local _abs_relink=
	local _opt_abs_relink=OFF
	local _flag_abs_relink=OFF

	local _rel_relink=
	local _opt_rel_relink=OFF
	local _flag_rel_relink=OFF
	for o in $OPT; do
		#[ "$_flag_fixed_path" = "ON" ] && _force_path="$o" && _flag_fixed_path=OFF && _fixed_path=ON && _abs_link_to_rel=OFF && _rel_link_to_abs=OFF
		#[ "$o" = "FIXED_PATH" ] && _flag_fixed_path=ON
		[ "$o" = "FIXED_PATH" ] && echo "ERROR : deprecated -- use ABS_LINK_FORCE instead" && exit 1
		[ "$o" = "FIX_RPATH" ] && echo "ERROR : deprecated -- use ABS_LINK_FORCE instead" && exit 1
		[ "$o" = "REL_RPATH" ] && echo "ERROR : deprecated -- use ABS_LINK_TO_REL" && exit 1
		[ "$o" = "ABS_RPATH" ] && echo "ERROR : deprecated -- use REL_LINK_TO_ABS" && exit 1
		[ "$o" = "ABS_LINK_TO_REL" ] && _abs_link_to_rel=ON && _rel_link_to_abs=OFF && _opt_rel_link_force=OFF && _opt_abs_link_force=OFF && _opt_rel_relink=OFF && _opt_abs_relink=OFF
		[ "$o" = "REL_LINK_TO_ABS" ] && _abs_link_to_rel=OFF && _rel_link_to_abs=ON && _opt_rel_link_force=OFF && _opt_abs_link_force=OFF && _opt_rel_relink=OFF && _opt_abs_relink=OFF
		[ "$_flag_rel_link_force" = "ON" ] && _rel_link_force="$o" && _flag_rel_link_force=OFF
		[ "$o" = "REL_LINK_FORCE" ] && _flag_rel_link_force=ON && _abs_link_to_rel=OFF && _rel_link_to_abs=OFF && _opt_rel_link_force=ON && _opt_abs_link_force=OFF && _opt_rel_relink=OFF && _opt_abs_relink=OFF
		[ "$_flag_abs_link_force" = "ON" ] && _abs_link_force="$o" && _flag_abs_link_force=OFF
		[ "$o" = "ABS_LINK_FORCE" ] && _flag_abs_link_force=ON && _abs_link_to_rel=OFF && _rel_link_to_abs=OFF && _opt_rel_link_force=OFF && _opt_abs_link_force=ON && _opt_rel_relink=OFF && _opt_abs_relink=OFF

		[ "$_flag_abs_relink" = "ON" ] && _abs_relink="$o" && _flag_abs_relink=OFF
		[ "$o" = "ABS_RELINK" ] && _flag_abs_relink=ON && _opt_abs_relink=ON && _abs_link_to_rel=OFF && _rel_link_to_abs=OFF && _opt_rel_link_force=OFF && _opt_abs_link_force=OFF && _opt_rel_relink=OFF
		[ "$_flag_rel_relink" = "ON" ] && _rel_relink="$o" && _flag_rel_relink=OFF
		[ "$o" = "REL_RELINK" ] && _flag_rel_relink=ON && _opt_rel_relink=ON && _abs_link_to_rel=OFF && _rel_link_to_abs=OFF && _opt_rel_link_force=OFF && _opt_abs_link_force=OFF && _opt_abs_relink=OFF
	done

	[ -z "$(__filter_list "$_file" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return

	# NOTE : do not use STELLA_CURRENT_RUNNING_DIR which is not refreshed when we are in shell mode
	_file="$(__rel_to_abs_path "$_file" "$( cd "$( dirname "." )" && pwd )")"

	if __is_executable_or_shareable_bin "$_file"; then
		local _new_load_lib=
		local _new_rpath=
		local line=
		local _linked_lib_filename=
		local _linked_lib_list=
		local _flag_existing_rpath=

		# get all linked libs
		local __all_linked_libs="$(__get_linked_lib "$_file")"

		# get existing linked lib
		for line in $__all_linked_libs; do

			# ABS_RELINK : pick all linked libraries
			if [ "$_opt_abs_relink" = "ON" ]; then
				_linked_lib_list="$_linked_lib_list $line"
			fi

			# REL_RELINK : pick all linked libraries
			if [ "$_opt_rel_relink" = "ON" ]; then
				_linked_lib_list="$_linked_lib_list $line"
			fi

			# ABS_LINK_FORCE : pick all linked libraries
			if [ "$_opt_abs_link_force" = "ON" ]; then
				_linked_lib_list="$_linked_lib_list $line"
			fi

			# REL_LINK_FORCE : pick all linked libraries
			if [ "$_opt_rel_link_force" = "ON" ]; then
				_linked_lib_list="$_linked_lib_list $line"
			fi

			# REL_LINK_TO_ABS : pick only rel path (for MachO do not pick @executable_path because we cant determine the path )
			if [ "$_rel_link_to_abs" = "ON" ]; then
				case $line in
					@executable_path*);;
					@rpath*|@loader_path)
						_linked_lib_list="$_linked_lib_list $line"
						;;
					*)
						if [ "$(__is_abs "$line")" = "FALSE" ]; then
							_linked_lib_list="$_linked_lib_list $line"
						fi
						;;
				esac
			fi

			# ABS_LINK_TO_REL : pick only abs path
			if [ "$_abs_link_to_rel" = "ON" ]; then
				if [ "$(__is_abs "$line")" = "TRUE" ]; then
					_linked_lib_list="$_linked_lib_list $line"
				fi
			fi
		done


		if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
			__require "patchelf" "patchelf#0_10" "STELLA_FEATURE"
		fi

		local _resolved_lib
		local _resolved="0"
		local _lib_to_filter=
		local _filename="$(__get_filename_from_string $_file)"
		for l in $_linked_lib_list; do
			_linked_lib_filename="$(__get_filename_from_string $l)"

			echo "*** Fixing $_filename linked to $_linked_lib_filename shared lib"

			echo "=> Try to resolve $l"
			# FILTERS -- filters are applied on resolved libs
			[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] &&	_resolved_lib="$(__find_linked_lib_darwin "$_file" "NO_VERBOSE LIB_LIST $l")"
			[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && _resolved_lib="$(__find_linked_lib_linux "$_file" "NO_VERBOSE LIB_LIST $l")"
			[ "$_resolved_lib" = "" ] && _resolved="0" || _resolved="1"
			if [ "$_resolved" = "1" ]; then
				_lib_to_filter="$_resolved_lib"
				echo "=> linked lib resolved as : $_resolved_lib"
			else
				_lib_to_filter="$l"
				echo "=> linked lib not resolved : WARN"
			fi

			# filter linked libs
			if [ -z "$(__filter_list "$_lib_to_filter" "INCLUDE_TAG INCLUDE_LINKED_LIB EXCLUDE_TAG EXCLUDE_LINKED_LIB $OPT")" ]; then
				echo "=> linked lib has been filtered -- link is not processed"
				continue
			fi
			# default filter
			if [ ! "$STELLA_BINARY_DEFAULT_LIB_IGNORED" = "" ]; then
				if [ -z "$(__filter_list "$_lib_to_filter" "EXCLUDE_TAG EXCLUDE_LINKED_LIB EXCLUDE_LINKED_LIB $STELLA_BINARY_DEFAULT_LIB_IGNORED")" ]; then
					echo "=> linked lib has been filtered -- link is not processed"
					continue
				fi
			fi

			# ABS_RELINK
			if [ "$_opt_abs_relink" = "ON" ]; then
				local _new_linked_lib_filename="$(__get_filename_from_string $_abs_relink)"
				echo "=> switch link from $_linked_lib_filename to $_new_linked_lib_filename"
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					echo "=> setting NEEDED : $_abs_relink"
					patchelf --replace-needed "$l" "$_abs_relink" "$_file"
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					echo "=> setting LC_LOAD_DYLIB : $_abs_relink"
					install_name_tool -change "$l" "$_abs_relink" "$_file"
				fi
			fi

			# REL_RELINK
			if [ "$_opt_rel_relink" = "ON" ]; then
				local _new_linked_lib_filename="$(__get_filename_from_string $_rel_relink)"
				echo "=> switch link from $_linked_lib_filename to $_new_linked_lib_filename"
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					echo "=> setting NEEDED : $_new_linked_lib_filename"
					patchelf --replace-needed "$l" "$_new_linked_lib_filename" "$_file"

					_new_rpath="$(__abs_to_rel_path "$(__get_path_from_string $_rel_relink)" "$(__get_path_from_string $_file)")"
					[ "$_new_rpath" = "." ] && _new_rpath="\$ORIGIN" || \
						_new_rpath="\$ORIGIN/$_new_rpath"
					echo "=> Adding RPATH value : $_new_rpath"
					__add_rpath "$_file" "$_new_rpath"
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					echo "=> setting LC_LOAD_DYLIB : @rpath/$_new_linked_lib_filename"
					install_name_tool -change "$l" "@rpath/$_new_linked_lib_filename" "$_file"

					_new_rpath="$(__abs_to_rel_path "$(__get_path_from_string $_rel_relink)" "$(__get_path_from_string $_file)")"
					[ "$_new_rpath" = "." ] && _new_rpath="@loader_path" || \
								_new_rpath="@loader_path/$_new_rpath"
					echo "=> Adding RPATH value : $_new_rpath"
					__add_rpath "$_file" "$_new_rpath"
				fi
			fi

			# ABS_LINK_FORCE
			if [ "$_opt_abs_link_force" = "ON" ]; then
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					echo "=> setting NEEDED : $_abs_link_force/$_linked_lib_filename"
					patchelf --replace-needed "$l" "$_abs_link_force/$_linked_lib_filename" "$_file"
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					echo "=> setting LC_LOAD_DYLIB : $_abs_link_force/$_linked_lib_filename"
					install_name_tool -change "$l" "$_abs_link_force/$_linked_lib_filename" "$_file"
				fi
			fi

			# REL_LINK_FORCE
			if [ "$_opt_rel_link_force" = "ON" ]; then
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					echo "=> setting NEEDED : $_linked_lib_filename"
					patchelf --replace-needed "$l" "$_linked_lib_filename" "$_file"

					_new_rpath="$(__abs_to_rel_path "$_rel_link_force" "$(__get_path_from_string $_file)")"
					[ "$_new_rpath" = "." ] && _new_rpath="\$ORIGIN" || \
						_new_rpath="\$ORIGIN/$_new_rpath"
					echo "=> Adding RPATH value : $_new_rpath"
					__add_rpath "$_file" "$_new_rpath"
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					echo "=> setting LC_LOAD_DYLIB : @rpath/$_linked_lib_filename"
					install_name_tool -change "$l" "@rpath/$_linked_lib_filename" "$_file"

					_new_rpath="$(__abs_to_rel_path "$_rel_link_force" "$(__get_path_from_string $_file)")"
					[ "$_new_rpath" = "." ] && _new_rpath="@loader_path" || \
								_new_rpath="@loader_path/$_new_rpath"
					echo "=> Adding RPATH value : $_new_rpath"
					__add_rpath "$_file" "$_new_rpath"
				fi
			fi

			# REL_LINK_TO_ABS
			if [ "$_rel_link_to_abs" = "ON" ]; then
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					if [ "$_resolved" = "1" ]; then
						echo "=> setting NEEDED : $_resolved_lib"
						patchelf --replace-needed "$l" "$_resolved_lib" "$_file"
					else
						echo "=> can not determine absolute path for $l"
					fi
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					if [ "$_resolved" = "1" ]; then
						echo "=> setting LC_LOAD_DYLIB : $_resolved_lib"
						install_name_tool -change "$l" "$_resolved_lib" "$_file"
					else
						echo "=> can not determine absolute path for $l"
					fi
				fi
			fi

			# ABS_LINK_TO_REL
			if [ "$_abs_link_to_rel" = "ON" ]; then
				# fix write permission
				chmod +w "$_file"
				if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
					if [ "$_resolved" = "1" ]; then
						echo "=> setting NEEDED : $_linked_lib_filename"
						patchelf --replace-needed "$l" "$_linked_lib_filename" "$_file"

						#_new_rpath="$(__abs_to_rel_path $(__get_path_from_string $l) $(__get_path_from_string $_file))"
						_new_rpath="$(__abs_to_rel_path $(__get_path_from_string $_resolved_lib) $(__get_path_from_string $_file))"
						[ "$_new_rpath" = "." ] && _new_rpath="\$ORIGIN" || \
							_new_rpath="\$ORIGIN/$_new_rpath"
						echo "=> Adding RPATH value : $_new_rpath"
						__add_rpath "$_file" "$_new_rpath"
					else
						echo "=> can not determine absolute path for $l"
					fi
				fi
				if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
					if [ "$_resolved" = "1" ]; then
						echo "=> setting LC_LOAD_DYLIB : @rpath/$_linked_lib_filename"
						install_name_tool -change "$l" "@rpath/$_linked_lib_filename" "$_file"

						#_new_rpath="$(__abs_to_rel_path $(__get_path_from_string $l) $(__get_path_from_string $_file))"
						_new_rpath="$(__abs_to_rel_path $(__get_path_from_string $_resolved_lib) $(__get_path_from_string $_file))"
						[ "$_new_rpath" = "." ] && _new_rpath="@loader_path" || \
									_new_rpath="@loader_path/$_new_rpath"
						echo "=> Adding RPATH value : $_new_rpath"
						__add_rpath "$_file" "$_new_rpath"
					else
						echo "=> can not determine absolute path for $l"
					fi
				fi
			fi
		done


	fi

}





# DARWIN -------------------------------------------------------------------


# DARWIN : INSTALL NAME --------------------------------
__get_install_name_darwin() {
	local _file=$1
	if __is_shareable_bin "$_file"; then
		if __is_macho "$_file" || __is_macho_universal "$_file"; then
			echo $(otool -l "$_file" | grep -E "LC_ID_DYLIB" -A2 | awk '/LC_ID_DYLIB/{for(i=2;i;--i)getline; print $0 }' | tr -s ' ' | cut -d ' ' -f 3)
		fi
	fi
}



# check ID/Install Name value
# 		RPATH -- check if install_name has @rpath
# 		PATH -- check if install_name is a standard path and is matching current file location
# INCLUDE_FILTER <expr> -- include these files to check
# EXCLUDE_FILTER <expr> -- exclude these files to check
# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
__check_install_name_darwin() {
	local _path=$1
	local OPT="$2"
	local t
	local _result=0
	local f=

	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__check_install_name_darwin "$f" "$OPT" || _result=1
		done
	fi

	local _opt_rpath=OFF
	local _opt_path=OFF
	for o in $OPT; do
		[ "$o" = "RPATH" ] && _opt_rpath=ON && _opt_path=OFF
		[ "$o" = "PATH" ] && _opt_rpath=OFF && _opt_path=ON
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return $_result

	if __is_shareable_bin "$_path"; then
		if __is_macho "$_path" || __is_macho_universal "$_path"; then


			printf "*** Checking ID/Install Name value : "
			local _install_name="$(__get_install_name_darwin $_path)"

			if [ "$_install_name" = "" ]; then
				echo
				echo " *** WARN $_path do not have any install name (LC_ID_DYLIB field)"
				_result=1
			else

				if [ "$_opt_rpath" = "ON" ]; then
					t=`echo $_install_name | grep -E "@rpath/"`
					if [ "$t" = "" ]; then
						printf %s " WARN ID/Install Name does not contain @rpath : $_install_name"
						_result=1
					else
						printf %s " $_install_name -- OK"
					fi
				fi

				if [ "$_opt_path" = "ON" ]; then
					if [ "$(dirname $_path)" = "$(dirname $_install_name)" ]; then
						printf %s " $_install_name -- OK"
					else
						if [ "$(dirname $_install_name)" = "." ]; then
							printf %s " WARN ID/Install Name contain only a name : $_install_name"
							_result=1
						else
							printf %s " WARN ID/Install Name does not match location of file : $_install_name"
							_result=1
						fi
					fi
				fi

			fi
			echo
		fi
	fi

	return $_result
}



# tweak install name with @rpath/lib_name OR tweak install name replacing @rpath/lib_name with /lib/path/lib_name
# we cannot pass '-Wl,install_name @rpath/library_filename' during build time because we do not know the library name yet
# 		RPATH -- tweak install_name with @rpath/library_filename [DEFAULT]
# 		PATH -- tweak install_name with location of the file
# INCLUDE_FILTER <expr> -- include these files to tweak
# EXCLUDE_FILTER <expr> -- exclude these files to tweak
# INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
__tweak_install_name_darwin() {
	local _path=$1
	local OPT="$2"
	local _new_install_name
	local _original_install_name


	local f=
	if [ -d "$_path" ]; then
		for f in  "$_path"/*; do
			__tweak_install_name_darwin "$f" "$OPT"
		done
	fi

	local _opt_rpath=ON
	local _opt_path=OFF
	for o in $OPT; do
		[ "$o" = "RPATH" ] && _opt_rpath=ON && _opt_path=OFF
		[ "$o" = "PATH" ] && _opt_rpath=OFF && _opt_path=ON
	done

	[ -z "$(__filter_list "$_path" "INCLUDE_TAG INCLUDE_FILTER EXCLUDE_TAG EXCLUDE_FILTER $OPT")" ] && return

	if __is_shareable_bin "$_path"; then
		if __is_macho "$_path" || __is_macho_universal "$_path"; then

			_original_install_name="$(__get_install_name_darwin $_path)"

			if [ "$_opt_path" = "ON" ]; then
				if [ "$_original_install_name" = "" ]; then
					# location path is not the good one
					if [ ! "$(dirname $_path)" = "$(dirname $_original_install_name)" ]; then
						_new_install_name="$(__get_path_from_string $_path)/$(__get_filename_from_string $_path)"
					fi
				else
					case "$_original_install_name" in
						@rpath*)
							_new_install_name="$(__get_path_from_string $_path)/$(__get_filename_from_string $_original_install_name)"
						;;
						*)
							# location path is not the good one
							if [ ! "$(dirname $_path)" = "$(dirname $_original_install_name)" ]; then
								# use original install_name
								_new_install_name="$(__get_path_from_string $_path)/$(__get_filename_from_string $_original_install_name)"
							fi
						;;
					esac
				fi
			fi

			if [ "$_opt_rpath" = "ON" ]; then
				if [ "$_original_install_name" = "" ]; then
					_new_install_name="@rpath/$(__get_filename_from_string $_path)"
				else
					case "$_original_install_name" in
						@rpath*);;
						*)
							# use original install_name
							_new_install_name="@rpath/$(__get_filename_from_string $_original_install_name)"
						;;
					esac
				fi
			fi


			if [ ! "$_new_install_name" = "" ]; then
				# fix write permission
				chmod +w "$_path"
				echo "*** Fixing install_name for $_path with value : FROM $_original_install_name TO $_new_install_name"
				install_name_tool -id "$_new_install_name" $_path
			fi

		fi
	fi
}







fi
