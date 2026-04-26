if [ ! "$_STELLA_PLATFORM_SEARCH_PATH_INCLUDED_" = "1" ]; then
_STELLA_PLATFORM_SEARCH_PATH_INCLUDED_=1

# ----------------------------- HELPERS -------------


# Helper: get Darwin SDK path
# 1. use SDKROOT if set
# 2. else use xcrun --sdk macosx --show-sdk-path
# 3. else empty
__darwin_get_sdkroot() {
  if [ -n "${SDKROOT:-}" ]; then
    printf '%s' "$SDKROOT"
    return
  fi
  if command -v xcrun >/dev/null 2>&1; then
    xcrun --sdk macosx --show-sdk-path 2>/dev/null && return 0
  fi
  return 1
}


# notation used by autoconf
# i.e : x86_64-pc-linux-gnu
__get_system_canonical_triplet() {
	"$STELLA_ARTEFACT/autoconf-scripts/config.guess"
}

# notation used by ebian multiarch / pkg-config / toolchain practical tuple
# i.e : x86_64-linux-gnu
__get_system_non_canonical_triplet() {
	local _result=""
	local _name=""
	if command -v gcc >/dev/null 2>&1; then
		_result="$(gcc -dumpmachine 2>/dev/null)"
	else
		# specific debian like multiarch
		if command -v dpkg-architecture >/dev/null 2>&1; then
			_result="$(dpkg-architecture -qDEB_HOST_MULTIARCH 2>/dev/null)"
		else
			# try by using pkg-config
			if [ -z "$_result" ]; then
				local _old_ifs _p
				local _original_default_search_path="$(__pkgconfig_original_default_search_path)"
				if [ -n "$_original_default_search_path" ]; then
					_old_ifs="$IFS"
					IFS=':'
					for _p in $_original_default_search_path; do
						case "$_p" in
							*/lib/*/pkgconfig)
								_name="${_p%/pkgconfig}"
								_name="${_name##*/}"
								case "$_name" in
									*-linux-gnu|*-linux-gnueabi|*-linux-gnueabihf|*-linux-musl)
										_result="$_name"
										break
										;;
								esac
								;;
						esac
					done
					IFS="$_old_ifs"
				fi
			fi
			if [ -z "$_result" ]; then
				# try to guess exploring libs folder
				# specific debian like multiarch
				local _base _dir
				for _base in /usr/local/lib /usr/lib /lib; do
					[ -d "$_base" ] || continue
					for _dir in "$_base"/*-linux-gnu "$_base"/*-linux-gnueabi "$_base"/*-linux-gnueabihf "$_base"/*-linux-musl; do
						[ -d "$_dir" ] || continue
						_name="${_dir##*/}"
						case "$_name" in
							*-linux-gnu|*-linux-gnueabi|*-linux-gnueabihf|*-linux-musl)
								_result="$_name"
								break
								;;
						esac
					done
					[ -n "$_result" ] && break
				done
			fi
		fi
	fi
	echo -n "$_result"
}
#t0TSX77tZbt0AZ3V

# pkg-config full search path
# https://linux.die.net/man/1/pkg-config
# get search path, including PKG_CONFIG_PATH, used by pkg-config
__pkgconfig_current_search_path() {
	if command -v pkg-config >/dev/null 2>&1; then
		[ -z "${PKG_CONFIG_PATH}" ] && \
			echo "$(pkg-config --variable pc_path pkg-config)" || \
			echo "${PKG_CONFIG_PATH}:$(pkg-config --variable pc_path pkg-config)"
	fi
}

# get default search path used on the current host by system pkg-config
# because if we build it ourself with feature_bindfs, it does not contains
# the default search path accordingly to the current host
__pkgconfig_original_default_search_path() {
	if PATH="$STELLA_ORIGINAL_SYSTEM_PATH" command -v pkg-config >/dev/null 2>&1; then
		PATH="$STELLA_ORIGINAL_SYSTEM_PATH" pkg-config --variable pc_path pkg-config
	fi
}

# pkgconfig system default search path to find .pc files for library
# try to several method or try to build list
# informations :
# default value extracted from pkg-config source code, configure script : https://gitlab.freedesktop.org/pkg-config/pkg-config/-/blob/pkg-config-0.29.2/configure.ac#L55
	# ${libdir}/pkgconfig:${datadir}/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
	# 	${libdir} : files depending on architectures (often /usr/lib)
	#	${datadir} : architecture-independent data files (often /usr/share)
	#   /usr/lib/pkgconfig:/usr/share/pkgconfig : default hardcoded values in pkg-config when there is no PREFIX value used at pkg-config build time
# default behaviour for .pc files location :
# .pc files which might be architecture-specific 
#	go in /usr/lib 
# .pc files which are sure to be architecture-independent 
#	can go in /usr/share
# EXCEPTIONS are analysed below :
#	distributions analysis using "pkg-config --variable pc_path pkg-config"
#	on debian and ubuntu: /usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
#			libdir : /usr/local/lib/<triplet target compilation>, /usr/local/lib, /usr/lib/<triplet target compilation>, /usr/lib
#				/usr/local/lib, /usr/lib are for pre-multiarch packages
# 				/usr/local/lib/<triplet>, /usr/lib/<triplet> are for multiarch packages
#			datadir : /usr/local/share, /usr/share
#	on fedora and almalinux : /usr/lib64/pkgconfig:/usr/share/pkgconfig
#			libdir : /usr/lib<arch>
#			datadir : /usr/share
#	on alpine : /usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
#			libdir : /usr/local/lib, /usr/lib
#			datadir : /usr/local/share, /usr/share
#	on almalinux : /usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/lib/pkgconfig:/usr/share/pkgconfig
#			libdir : /usr/local/lib, /usr/lib
#			datadir : /usr/local/share, /usr/share
#	on freebsd (partial results) :
#			datadur : /usr/libdata
__pkgconfig_get_system_default_search_path() {
	
	local _original_default_search_path="$(__pkgconfig_original_default_search_path)"
	if [ -n "$_original_default_search_path" ]; then
		echo -n "$_original_default_search_path"
		return 0
	else

		local _result=""
		_result="$(__pkgconfig_search_paths_from_prefix "/usr/local")"
		[ -n "${_result}" ] && _result="${_result}:"
		_result="$(__pkgconfig_search_paths_from_prefix "/usr")"
	fi

	echo -n "$_result"
}


# return standard libraries and shared-data search paths for a system prefix (default /usr)
# Example:
# i.e : /usr/local/lib64:/usr/local/share:/usr/lib64:/usr/share
__pkgconfig_search_paths_from_prefix() {
	local _prefix="${1:-/usr}"

	local _result="$(__get_library_and_share_search_paths_from_prefix "${_prefix}")"

	local _filtered=""
	local _p
	local _old_ifs="$IFS"

	IFS=':'
	for _p in $_result; do
		# NOTE : check only if root folder exist, not pkgconfig folder itself
		if [ -d "$_p" ]; then
			if [ -n "$_filtered" ]; then
				_filtered="${_filtered}:${_p}/pkgconfig"
			else
				_filtered="${_p}/pkgconfig"
			fi
		fi
	done
	IFS="$_old_ifs"

	echo -n "$_filtered"
}


# return standard libraries and shared-data search paths for a system prefix (default /usr)
# Example:
# i.e : /usr/local/lib64:/usr/local/share:/usr/lib64:/usr/share
__get_library_and_share_search_paths_from_prefix() {
	local _prefix="${1:-/usr}"
	local _current_triplet_non_canonical="$(__get_system_non_canonical_triplet)"

	local _result=""
	[ -n "${_current_triplet_non_canonical}" ] && _result="${_result}${_prefix}/lib/${_current_triplet_non_canonical}:"
	_result="${_result}${_prefix}/lib64:${_prefix}/lib:${_prefix}/share"

	echo -n "${_result}"
}


# search a dynamic library into dyld cache
# 	either in known list of files in cache (default mode and faster mode)
#	OR by scanning dyld cache (needs ipsw tool)
#   depending on STELLA_LINKED_LIB_CACHE_MODE_DARWIN value
__darwin_dynamic_library_exists_in_cache() {
	local lib_file_name="$1"
	local lib_regex_file=/${lib_file_name}'(.*)\.dylib$'

	case $STELLA_LINKED_LIB_CACHE_MODE_DARWIN in
		cache-list|*)
			[ -f "$STELLA_ARTEFACT/macos-dyld-cache-list.txt" ] && cat $STELLA_ARTEFACT/macos-dyld-cache-list.txt | grep -E -e "$lib_regex_file" -m1
			[ $? -eq 0 ] && return 0
			;;

		dyld-cache)
			__require "ipsw" "ipsw" "INTERNAL" 2>&1 1>/dev/null
			$STELLA_ARTEFACT/macos-dyld-cache-analyse.sh --quiet --only-dylib --no-default-excludes --images --exists-one "$lib_regex_file"
			[ $? -eq 0 ] && return 0
			;;
	esac
	return 1
}

# search a dynamic library available at runtime in system
#		__search_dynamic_library_at_runtime "libcurl"
#
# 		NOTE  : return 0 at first match else return 1
#		on linux
#			STEP 0 check in current LD_LIBRARY_PATH
#			STEP 1 check in lld cache
#			STEP 2 check in all search path for libraries at RUNTIME from __get_search_library_paths_at_runtime
__search_dynamic_library_at_runtime() {
	local lib_file_name="$1"
	local lib_regex_file
	
	# macOS before 11 Big Sur used to ship with the source binaries still on-disk, particularly so it can be updated with update_dyld_shared_cache [Archived 2015-08-29 at the Wayback Machine]. Starting with macOS 11, update_dyld_shared_cache is deprecated and, as in iOS, the only copy of the libraries is in the "cache".
	# https://theapplewiki.com/wiki/Dev:Dyld_shared_cache
	case $STELLA_CURRENT_PLATFORM in
		darwin)
			lib_regex_file=${lib_file_name}'(.*)\.dylib$'

			if __darwin_dynamic_library_exists_on_filesystem; then
				# NOTE : __find_file_in_path_list is not recursive
				__find_file_in_path_list "^${lib_regex_file}" "$(__get_search_library_paths_at_runtime | tr '\n' ':')" "STOP_FIRST"
				[ $? -eq 0 ] && return 0
			else
				# STEP 1 - find in dyld cache
				__darwin_dynamic_library_exists_in_cache "$lib_file_name"
				[ $? -eq 0 ] && return 0

				# STEP 2 - find in system search paths
				__find_file_in_path_list "^$lib_regex_file" "$(__get_search_library_paths_at_runtime | tr '\n' ':')" "STOP_FIRST"
				[ $? -eq 0 ] && return 0
			fi
		;;

		linux)
			lib_regex_file='^'${lib_file_name}'.so'

			# STEP 0 - find in current LD_LIBRARY_PATH
			[ -n "$LD_LIBRARY_PATH" ] && __find_file_in_path_list "$lib_regex_file" "$LD_LIBRARY_PATH" "STOP_FIRST"
			[ $? -eq 0 ] && return 0

			# STEP 1 - find in ld cache
			if command -v ldconfig >/dev/null 2>&1; then
				local found_path="$(ldconfig -p 2>/dev/null | awk -v lib="$lib_regex_file" '$1 ~ lib { print $NF; exit }')"
				if [ -n "$found_path" ] && [ -e "$found_path" ]; then
					printf '%s\n' "$found_path"
					return 0
				fi
			fi

			# STEP 2 - find in system search paths
			__find_file_in_path_list "$lib_regex_file" "$(__get_search_library_paths_at_runtime | tr '\n' ':')" "STOP_FIRST"
			[ $? -eq 0 ] && return 0
		;;
	esac

	return 1
}

# ----------------------------- AT RUNTIME/RUN TIME -------------

# order of search - reading LC_LOAD_DYLIB
# 1.check dependency if absolute path (i.e : /usr/lib/libSystem.B.dylib) - could be in dyld cache or on disk
# 2.if present in LC_LOAD_DYLIB value try to solve @rpath, @loader_path, @executable_path
# 3 DYLD_LIBRARY_PATH (if not disabled by apple security SIP)
# 4 DYLD_FALLBACK_LIBRARY_PATH (if not disabled by apple security SIP) or its default values : $HOME/lib:/usr/local/lib:/usr/lib
# NOTE : this function do not extract the paths from dyld cache
__darwin_default_search_library_paths_at_runtime() {
  local res=""
  local p

  # from DYLD_LIBRARY_PATH
  if [ -n "${DYLD_LIBRARY_PATH:-}" ]; then
    IFS=:; for p in $DYLD_LIBRARY_PATH; do
      # here we keep only existing dirs, runtime should be real
      res="$(__path_append_to_list_if_exists "$res" "$p")"
    done
    unset IFS
  fi

  # fallback (or default)
  local fb="${DYLD_FALLBACK_LIBRARY_PATH:-$HOME/lib:/usr/local/lib:/usr/lib}"
  IFS=:; for p in $fb; do
    res="$(__path_append_to_list_if_exists "$res" "$p")"
  done
  unset IFS

  printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
}

# order of search - reading LC_LOAD_DYLIB
# 1.check dependency if absolute path (i.e : /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation) - could be in dyld cache or on disk
# 2.if present in LC_LOAD_DYLIB value try to solve @rpath, @loader_path, @executable_path
# 3 DYLD_FRAMEWORK_PATH (if not disabled by apple security SIP)
# 4 DYLD_FALLBACK_FRAMEWORK_PATH (if not disabled by apple security SIP) or its default values : $HOME/Library/Frameworks:/Library/Frameworks:/Network/Library/Frameworks:/System/Library/Frameworks
# NOTE : this function do not extract the paths from dyld cache
__darwin_default_search_framework_paths_at_runtime() {
  local res=""
  local p

  # DYLD_FRAMEWORK_PATH
  if [ -n "${DYLD_FRAMEWORK_PATH:-}" ]; then
    IFS=:; for p in $DYLD_FRAMEWORK_PATH; do
      res="$(__path_append_to_list_if_exists "$res" "$p")"
    done
    unset IFS
  fi

  # fallback (or default)
  local fb="${DYLD_FALLBACK_FRAMEWORK_PATH:-$HOME/Library/Frameworks:/Library/Frameworks:/Network/Library/Frameworks:/System/Library/Frameworks}"
  IFS=:; for p in $fb; do
    res="$(__path_append_to_list_if_exists "$res" "$p")"
  done
  unset IFS

  printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
}

__linux_default_search_library_paths_at_runtime() {
	local c_ldso_paths=""
	# inspired adapted from lddtree : https://github.com/StudioEtrange/lddtree/blob/579ebe449b76ed9d22f116a6f30b87b1f2ded2ca/lddtree.sh#L169
	read_ldso_conf() {
		local __depth="${__depth:-0}"
		[ "$__depth" -gt 20 ] && return 0
		__depth=$((__depth+1))

		local p line
		for p in "$@"; do
			# Fichier lisible ?
			[ -r "$p" ] || continue

			while IFS= read -r line || [ -n "$line" ]; do
				# Enlever commentaires en fin de ligne (# ...)
				# (simple, ne gère pas les # échappés — suffisant ici)
				line=${line%%\#*}

				# Trim spaces
				line=${line#"${line%%[![:space:]]*}"}
				line=${line%"${line##*[![:space:]]}"}

				# bypass empty lines
				[ -z "$line" ] && continue
				case $line in
					include[[:space:]]*)
						# Extraire motif après "include"
						set -- ${line#include}
						# $@ contient maintenant le motif (éventuellement avec glob)
						# Laisser le glob s'étendre volontairement (non quoté)
						read_ldso_conf $__depth "$@"
						;;
					*)
						# Première "colonne" seulement (au cas où)
						# (ld.so.conf n'attend qu'un chemin par ligne)
						set -- $line
						local path=$1

						# Normaliser: garantir un seul / en tête
						case $path in
							/*) : ;;
							*) path="/$path" ;;
						esac

						# Garder seulement les répertoires existants
						if [ -d "$path" ]; then
							# Ajouter sans créer de ":" initial
							case ":$c_ldso_paths:" in
								*:"$path":*) : ;;     # déjà présent → ignorer
								*)
									if [ -n "$c_ldso_paths" ]; then
										c_ldso_paths="$c_ldso_paths:$path"
									else
										c_ldso_paths="$path"
									fi
									;;
							esac
						fi
						;;
				esac
			done < "$p"
		done
	}

	# inspired adapted from lddtree : https://github.com/StudioEtrange/lddtree/blob/579ebe449b76ed9d22f116a6f30b87b1f2ded2ca/lddtree.sh#L184
	if [ -r /etc/ld.so.conf ] ; then
		# the 'include' can be relative
		local _oldpwd="$(pwd)"
		cd "/etc" >/dev/null
		interp=$(__get_elf_interpreter_linux "$(type -P ls 2>/dev/null)")
		case "$interp" in
			*/ld-musl-*)
				# muslc
				musl_arch=${interp%.so*}
				musl_arch=${musl_arch##*-}
				read_ldso_conf /etc/ld-musl-${musl_arch}.path
				;;
			*/ld-linux*|*/ld.so*)
				# glibc
				read_ldso_conf /etc/ld.so.conf
				;;
		esac
		cd "$_oldpwd"
	fi

	printf '%s\n' "$(printf '%s' "$c_ldso_paths" | sed 's/:/\n/g')"
}

__default_search_library_paths_at_runtime() {
	case $STELLA_CURRENT_PLATFORM in
		darwin)
			__darwin_default_search_library_paths_at_runtime
		;;
		linux)
			__linux_default_search_library_paths_at_runtime
		;;
	esac
}


# retrieve in solving order all search path for libraries at RUNTIME
# if a binary is in arg, then runtime path hardcoded in binary will also be returned into the result
__get_search_library_paths_at_runtime() {
	local binary="$1"
	case $STELLA_CURRENT_PLATFORM in
		darwin)
			# 1. extract LC_RPATH and add its value as a rpath, which will be used when looking for library
			[ -f "$binary" ] && __get_rpath "$binary" | tr -s '[:space:]' '\n'
			# 2 DYLD_* PATHs
			__darwin_default_search_library_paths_at_runtime
		;;

		linux)
			# 0. extract DT_RPATH
			[ -f "$binary" ] && _rpath="$(__get_rpath "$binary" | tr -s '[:space:]' '\n')"
			# if DT_RUNPATH is setted, DT_RPATH is ignored
			if [ $? -eq 12 ]; then
				echo "$_rpath"
			fi
			# 1. LD_LIBRARY_PATH
			[ ! -z $LD_LIBRARY_PATH ] && printf '%s\n' "$(printf '%s' "$LD_LIBRARY_PATH" | sed 's/:/\n/g')"
			# 2. extract DT_RUNPATH
			[ -f "$binary" ] && _rpath="$(__get_rpath "$binary" | tr -s '[:space:]' '\n')"
			if [ $? -eq 21 ] || [ $? -eq 22 ]; then
				echo "$_rpath"
			fi
			# 3. default search library path
			__linux_default_search_library_paths_at_runtime
		;; 
	esac
	
}

# ----------------------------- AT BUILD TIME -------------
__darwin_default_search_framework_paths_at_buildtime() {
  local res=""
  local arg p

  # 1. SDKROOT
  local sdk
  if ! sdk="$(__darwin_get_sdkroot)"; then
	# ALTERNATIVE to sdkroot : use __gcc_default_search_framework_paths_at_buildtime if xcrun do not exist
	# NOTE : this alternative method is not complete, do not add other Frameworks path
	path="$(__gcc_default_search_framework_paths_at_buildtime)"
	res="$(__path_append_to_list "$res" "$path")"
	sdk="$(echo $path | sed 's,/System/Library/Frameworks.*,,')"
  fi
  if [ -n "$sdk" ]; then
    res="$(__path_append_to_list "$res" "$sdk/System/Library/Frameworks")"
    res="$(__path_append_to_list "$res" "$sdk/Library/Frameworks")"
  fi

  # 2. host defaults (these should exist on real macOS, but we still check)
  res="$(__path_append_to_list_if_exists "$res" "$HOME/Library/Frameworks")"
  res="$(__path_append_to_list_if_exists "$res" /Library/Frameworks)"
  res="$(__path_append_to_list_if_exists "$res" /Network/Library/Frameworks)"
  res="$(__path_append_to_list_if_exists "$res" /System/Library/Frameworks)"

  printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
}

# it is a hack because rgcc -Xlinker -vr alwayrs generate an error we ignore to get information
# method used as an alternative in __darwin_default_search_framework_paths_at_buildtime
__gcc_default_search_framework_paths_at_buildtime() {
	case $STELLA_CURRENT_PLATFORM in
		linux);;
		darwin)
			gcc -Xlinker -v 2>&1 \
				| awk '
				/^Library search paths:/ {lib=1; fw=0; next}
				/^Framework search paths:/ {lib=0; fw=1; next}
				fw && $0 ~ /^[[:space:]]+\// { sub(/^[[:space:]]+/,""); print }
				'
		;;
	esac
}


# default library search paths during linking at build time  (linker path)
__darwin_default_search_library_paths_at_buildtime() {
  local res=""
  local arg p
  local expect_L=0

  # 2. SDKROOT
  local sdk
  if ! sdk="$(__darwin_get_sdkroot)"; then
	# ALTERNATIVE to sdkroot : use __gcc_default_search_framework_paths_at_buildtime if xcrun do not exist
	# NOTE : this alternative method is not complete, do not add /usr/local/lib
  	res="$(__gcc_default_search_library_paths_at_buildtime)"
	return $?
  fi
  if [ -n "$sdk" ]; then
    # standard places inside SDK
    res="$(__path_append_to_list "$res" "$sdk/usr/local/lib")"
    res="$(__path_append_to_list "$res" "$sdk/usr/lib")"
  fi

  # 3. system defaults if they exists
  res="$(__path_append_to_list_if_exists "$res" /usr/local/lib)"
  res="$(__path_append_to_list_if_exists "$res" /usr/lib)"

  printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
}


# default gcc/ld library search paths during linking at build time (linker path)
# it is a hack because gcc -Xlinker -v alwayrs generate an error we ignore to get information
# method used as an alternative in __darwin_default_search_library_paths_at_buildtime
__gcc_default_search_library_paths_at_buildtime() {
	local __arch=""
	case $STELLA_CPU_ARCH in
		"64")
			__arch="-m64"
		;;
		"32")
			__arch="-m32"
		;;
	esac
	
	case $STELLA_CURRENT_PLATFORM in
		linux)
			# ALTERNATIVE FOR LINUX : use ld : __ld_default_search_library_paths_at_buildtime
			gcc $__arch -Xlinker --verbose  2>/dev/null | grep SEARCH | sed 's/SEARCH_DIR("=\?\([^"]\+\)"); */\1\n/g'  | grep -vE '^$'
		;;

		darwin)
			gcc $__arch -Xlinker -v 2>&1 \
				| awk '
				/^Library search paths:/ {lib=1; fw=0; next}
				/^Framework search paths:/ {lib=0; fw=1; next}
				lib && $0 ~ /^[[:space:]]+\// { sub(/^[[:space:]]+/,""); print }
				'
		;;

	esac
}

# gcc hardcoded libraries search path when linking
# gcc passes a few extra -L paths to the linker, which you can list with the following command:
# 		linux & darwin : https://stackoverflow.com/a/21610523/5027535
#		darwin : https://opensource.apple.com/source/dyld/dyld-519.2.1/src/dyld.cpp.auto.html
__gcc_extra_search_library_paths_at_buildtime() {
	local __arch=""
	case $STELLA_CPU_ARCH in
		"64")
			__arch="-m64"
		;;
		"32")
			__arch="-m32"
		;;
	esac
	
	if [ "${STELLA_CURRENT_PLATFORM}" = "linux" ]; then
		gcc -print-search-dirs $__arch \
		| sed '/^lib/b 1;d;:1;s,/[^/.][^/]*/\.\./,/,;t 1;s,:[^=]*=,:;,;s,;,;  ,g; s/^libraries:[[:space:]]*;[[:space:]]*//' \
		| tr : '\n'
	elif [ "${STELLA_CURRENT_PLATFORM}" = "darwin" ]; then
		gcc -print-search-dirs $__arch \
		| sed -n 's/^libraries:[[:space:]]*\(=\)\{0,1\}[[:space:]]*//p' \
		| tr ':' '\n' \
		| sed -E '/^$/d; s|/+$/||; s|(/lib)?$|/lib|'
	fi
}

# default gcc/ld library search paths during linking at build time (linker path)
# https://stackoverflow.com/a/21610523/5027535
# ld is the linker only on linux
# existing alternative : __gcc_default_search_library_paths_at_buildtime
__ld_default_search_library_paths_at_buildtime() {
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		case $STELLA_CPU_ARCH in
			"64")
				__arch="-m elf_x86_64"
			;;
			"32")
				__arch="-m elf_i386"
			;;
		esac
		ld --verbose $__arch 2>/dev/null \
			| grep SEARCH \
			| sed 's/SEARCH_DIR("=\?\([^"]\+\)"); */\1\n/g' \
			| grep -vE '^$'
	fi
}




# library search paths during linking at build time (linker path)
# NOTE :
# 		linux : https://stackoverflow.com/questions/9922949/how-to-print-the-ldlinker-search-path
#		macos : https://opensource.apple.com/source/dyld/dyld-519.2.1/src/dyld.cpp.auto.html
#				harcoded values : https://opensource.apple.com/source/dyld/dyld-519.2.1/src/dyld.cpp.auto.html
__get_search_library_paths_at_buildtime() {
	local res="" p
	local OLD_IFS="$IFS"
	case "$STELLA_CURRENT_PLATFORM" in
		"darwin")
			# 1. LIBRARY_PATH
			if [ -n "${LIBRARY_PATH:-}" ]; then
				IFS=:; for p in $LIBRARY_PATH; do
					res="$(__path_append_to_list "$res" "$p")"
				done
				IFS="$OLD_IFS"
			fi
			
			# 2. hardcoded gcc search path
			res="$(__gcc_extra_search_library_paths_at_buildtime | __path_append_to_list_from_stdin "$res")"

			# 3. default lib search path
			res="$(__darwin_default_search_library_paths_at_buildtime | __path_append_to_list_from_stdin "$res")"

			printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
		;;

		"linux")
			# 1. LIBRARY_PATH
			if [ -n "${LIBRARY_PATH:-}" ]; then
				IFS=:; for p in $LIBRARY_PATH; do
					res="$(__path_append_to_list "$res" "$p")"
				done
				IFS="$OLD_IFS"
			fi

			# 2. hardcoded gcc search path
			res="$(__gcc_extra_search_library_paths_at_buildtime | __path_append_to_list_from_stdin "$res")"

			# 3. default lib search path
			res="$(__gcc_default_search_library_paths_at_buildtime | __path_append_to_list_from_stdin "$res")"

			printf '%s\n' "$(printf '%s' "$res" | tr ':' '\n')"
		;;

	esac


}

fi