#!/usr/bin/env bash
# macos-link-analyse.sh
# https://gist.github.com/StudioEtrange/c2f1a2f625c5745c84dda2bc02fea4eb
# Author: StudioEtrange https://github.com/StudioEtrange
# License: MIT
set -euo pipefail

man() {
cat <<MAN
Purpose:
  A tool to analyse Mach-O files dependencies

  Dependencies Analysis:
	- try to solve dependencies
	- detects non-standard absolute paths
	- detects unresolved @rpath / @loader_path / @executable_path references
	- detects misconfigured LC_ID_DYLIB values
	- avoids false positives related to the dyld shared cache (macOS 11+ Big Sur)
	- can not analyse dependencies of a file that is itself into dyld cache (i.e : /usr/lib/libutil.dylib)

Usage:
  macos-link-analyse.sh [--exec-dir <dir>] \
    [--main-rpath-exe <path>] [--use-dyld-env] [--log] [--json]  \
    [--system-prefix <path>]... [--extra-rpath <path>]... [--check-dyld-cache] \
    <file|folder>...
 
  Options
      [--json] : Output results as JSON
      [--log] : when in text format, show log output while analyzing
      [--exec-dir <dir>] : executable path used to solve dependencies - otherwise it use the current analysed file
      [--use-dyld-env] : will use DYLD_LIBRARY_PATH env var - by default it is ignored
      [--system-prefix <path>] : (repeatable) add a path to system path, also considered to be cached into dyld cache
      [--extra-rpath <path>] : (repeatable) add a path to look for to the ones already registered into the analysed file when solving dependencies
      [--main-rpath-exe <path>] : will add rpath values extracted from this binary (usually a main process which invoke subsequent libraries)
      [--check-dyld-cache] : check if dependencies really exist in dyld cache -
                            WARN : in PATH, needs ipsw https://github.com/blacktop/ipsw 
                            and macos-dyld-cache-analyse.sh script https://gist.github.com/StudioEtrange/8c2801df68969538cfccc6dcdb8d6bcc

About log symbols:
	+ : status is OK
	- : status is KO
	* : status is neutral

About json output: 
  sample json output

[
  {
    "file": "/bin/cat",
    "install_name": "",
    "data": {
      "rpaths_total": 0,
      "deps_solved_total": 1,
      "deps_not_solved_total": 0,
      "deps_total": 1,
      "issues_total": 0
    },
    "rpaths": [],
    "deps": [
      "/usr/lib/libSystem.B.dylib"
    ],
    "deps_solved": [
      "/usr/lib/libSystem.B.dylib"
    ],
    "deps_solved_as": [
      "/usr/lib/libSystem.B.dylib"
    ],
    "deps_solved_map": [
      {
        "dep": "/usr/lib/libSystem.B.dylib",
        "solved_as": "/usr/lib/libSystem.B.dylib"
      }
    ],
    "deps_not_solved": [],
    "issues": []
  }
]

About system prefix path that should be in dyld cache:
$(printf '  %s\n' "${SYSTEM_PREFIXES[@]}")

Requirements:
  - bash (3.2+)
  - for --check-dyld-cache in PATH, needs ipsw https://github.com/blacktop/ipsw 
    and macos-dyld-cache-analyse.sh script https://gist.github.com/StudioEtrange/8c2801df68969538cfccc6dcdb8d6bcc

Usage examples:
	# Check dependencies of /bin/cat and printing analysis log
	./macos-link-analyse.sh /bin/cat --log

	# Check dependencies of /bin/cat, output in json
	./macos-link-analyse.sh /bin/cat --json

	# Check dependencies of /bin/cat and /bin/ls, and check dependencies exists in dyld cache
	./macos-link-analyse.sh /bin/cat /bin/ls --check-dyld-cache

Tips:
	- It’s recommended to use dependencies referenced via @rpath or @loader_path.
	- Adjust RPATH entries, use: install_name_tool -add_rpath <path> <binary>
	- Set the ID of a dylib (LC_ID_DYLIB): install_name_tool -id @rpath/libX.dylib <libX.dylib>
	- Rewrite a dependency path: install_name_tool -change <old> <new> <binary>
	- Customize system path that are cached in dyld to look for with --system-prefix, and your library directories with --extra-rpath.
	- The --check-dyld-cache option (optional) attempts an informative check against the dyld shared cache.
MAN
}

FORMAT="text"
EXEC_DIR=""
MAIN_RPATH_EXE=""
USE_DYLD_ENV=0
CHECK_DYLD_CACHE=0
LOG=0

# paths considered to be by default cached in dyld for all version of macos (these paths change over times)
# to collect default cached path for the current system:
#		./macos-dyld-cache-analyse.sh --dir | awk -F/ 'NF>=3 {print "/" $2 "/" $3; next} NF==2 {print "/" $2; next}' | sort -u
SYSTEM_PREFIXES=(
  "/usr/lib"
  "/System/Library"
  "/System/iOSSupport"
  "/Library/Frameworks"
)
EXTRA_RPATHS=()

log_err() { printf '%s\n' "$*" >&2; }

json_escape() {
  printf '"'
  # Iterates byte by byte (LC_ALL=C), converts according to JSON rules
  LC_ALL=C printf '%s' "$1" \
  | od -An -t u1 -v \
  | tr -s ' \n' ' ' \
  | tr ' ' '\n' \
  | while IFS= read -r b; do
      [ -z "$b" ] && continue
      case $b in
        34) printf '\\"' ;;   # "
        92) printf '\\\\' ;;  # \
         8) printf '\\b'  ;;  # backspace
        12) printf '\\f'  ;;  # formfeed
        10) printf '\\n'  ;;  # newline
        13) printf '\\r'  ;;  # carriage return
         9) printf '\\t'  ;;  # tab
        [0-9]|[1-2][0-9]|3[0-1]) printf '\\u%04X' "$b" ;;  # others < 0x20
        *)  printf "\\$(printf '%03o' "$b")" ;;            # raw byte (UTF-8 safe)
      esac
    done
  #printf '"\n'
  printf '"'
}


# Build a JSON array escaping each element
json_array() {
  [ $# -eq 0 ] && { printf '[]'; return; }
  [ $# -eq 1 ] && [ -z "$1" ] && { printf '[]'; return; }

  local parts=() s
  for s in "$@"; do
    parts+=("$(json_escape "$s")")
  done
  local IFS=,
  printf '[%s]' "${parts[*]}"
}

is_macho() {
  [[ -f "$1" ]] || return 1
  file -b "$1" 2>/dev/null | grep -q "Mach-O"
}


macho_type() {
  [ -f "$1" ] || { echo "none"; return 1; }
  is_macho "$1" || return 1
  local out_raw out
  out_raw=$(file -b -- "$1") || { echo "none"; return 1; }

  local is_universal=0
  case "$out_raw" in
    *"universal binary"*)
      is_universal=1
      out=$(printf '%s\n' "$out_raw" | tail -n +2)
      ;;
	*)out="$out_raw" ;;
  esac

  local type=""
  case "$out" in
    *"dynamically"*"shared library"*) type="dylib" ;; # MH_DYLIB
    *"bundle"*)                       type="bundle" ;; # MH_BUNDLE
    *"executable"*)                   type="executable" ;; # MH_EXECUTABLE
  esac
  [ -n "$type" ] || return 1
  
  [ $is_universal -eq 1 ] && type="${type}+universal"

  printf '%s\n' "$type"
  return 0
}

deps_of() { otool -L "$1" 2>/dev/null | tail -n +2 | awk '{print $1}'; }

rpaths_of() {
  otool -l "$1" 2>/dev/null | awk '
    /cmd LC_RPATH/ { r=1; next }
    r && $1=="path" { print $2; r=0 }
  '
}

id_of_dylib() {
  otool -l "$1" 2>/dev/null | awk '
    /cmd LC_ID_DYLIB/ { id=1; next }
    id && $1=="name" { print $2; exit }
  '
}

# main binary RPATHs
rpaths_of_main() {
  local m="$1"
  [[ -n "$m" && -f "$m" ]] || return 0
  otool -l "$m" 2>/dev/null | awk '
    /cmd LC_RPATH/ { r=1; next }
    r && $1=="path" { print $2; r=0 }
  '
}

unique_array() {
  local -a new=()
  local seen="" item
  for item in "$@"; do
    case " $seen " in
      *" $item "*) ;; # already seen -> skip
      *)
        seen="$seen $item"
        new+=("$item")
        ;;
    esac
  done
  echo "${new[@]}"
}

join_by() { local IFS="$1"; shift; echo "$*"; }

starts_with() { case "$2" in "$1"*) return 0;; *) return 1;; esac }

# Resolve directory symlinks and, if the file itself is a symlink, resolve it once
real_path() {
  local p="$1"
  local dir base
  dir="$(cd "$(dirname "$p")" 2>/dev/null && pwd -P)" || return 1
  base="$(basename "$p")"

  # if the last component is a symlink, try to read it
  if [ -L "$p" ]; then
    local target
    target="$(readlink "$p")" || {
      printf '%s/%s\n' "$dir" "$base"
      return 0
    }
    # if target is relative, make it relative to dir
    case "$target" in
      /*)
        printf '%s\n' "$target"
        ;;
      *)
        # rebuild relative target
        printf '%s/%s\n' "$dir" "$target"
        ;;
    esac
  else
    printf '%s/%s\n' "$dir" "$base"
  fi
}


# Normalize a path without requiring it to exist
# - do NOT resolve relative expression relative to curreznt path !
# - removes '.' and '..' components
# - removes duplicate '/'
# - preserves the leading '/' if the path is absolute
# - accepts empty input (returns empty line)
normalize_path() {
  local path="$1"

  # handle empty input
  if [ -z "$path" ]; then
    printf '\n'
    return 0
  fi

  # split by '/'
  local IFS=/
  local parts=()
  read -r -a parts <<<"$path"

  local out=()
  local part
  for part in "${parts[@]}"; do
    case "$part" in
      ''|'.')
        # ignore empty or '.' segments
        continue
        ;;
      '..')
        # remove last segment if available
        if [ "${#out[@]}" -gt 0 ]; then
          local idx=$((${#out[@]} - 1))
          unset "out[$idx]"
        fi
        ;;
      *)
        # keep valid segment
        out+=("$part")
        ;;
    esac
  done

  # rebuild normalized path
  if [ "${path#/}" != "$path" ]; then
    # absolute path
    printf '/%s\n' "$(IFS=/; echo "${out[*]}")"
  else
    # relative path
    printf '%s\n' "$(IFS=/; echo "${out[*]}")"
  fi
}


# Replace @loader_path/@executable_path in a string (RPATH or dep)
# loader_dir = directory of the file that references the dependency (the "loader")
# exec_dir   = directory of the main executable (if provided via --exec-dir, otherwise falls back to loader_dir)
expand_dyld_tokens() {
  local s="$1" loader_dir="$2" exec_dir="$3"
  s="${s//@loader_path/$loader_dir}"
  s="${s//@executable_path/$exec_dir}"
  printf '%s\n' "$(normalize_path "$s")"
}

path_in_system_prefixes() {
  local p="$1" pref
  for pref in "${SYSTEM_PREFIXES[@]}"; do
    starts_with "$pref" "$p" && return 0
  done
  return 1
}

path_exists_in_dyld_cache() {
  local raw="$1" esc
  # escape regex characters in filename
  esc=$(printf '%s' "$raw" | sed -e 's/[][\\.^$*+?(){}|]/\\&/g')
  PATH="$(pwd):$PATH" macos-dyld-cache-analyse.sh \
    --quiet --images --no-default-excludes --exists-one "^${esc}$"

  return $?
}

# Build solved mapping as JSON
json_solved_map() {
  local i
  printf '['
  for ((i=0; i<${#dep_solved[@]}; i++)); do
    ((i>0)) && printf ','
    printf '{"dep":%s,"solved_as":%s}' \
      "$(json_escape "${dep_solved[$i]}")" \
      "$(json_escape "${dep_solved_as[$i]:-}")"
  done
  printf ']'
}

# order of search - reading LC_LOAD_DYLIB
# 1.check dependency if absolute path (i.e : /usr/lib/libSystem.B.dylib) - could be in dyld cache or on disk
# 2.if present in LC_LOAD_DYLIB value try to solve @rpath, @loader_path, @executable_path
# 3 DYLD_LIBRARY_PATH (if not disabled by apple security SIP)
# 4 DYLD_FALLBACK_LIBRARY_PATH (if not disabled by apple security SIP) or its default values : $HOME/lib:/usr/local/lib:/usr/lib
resolve_dep() {
  local dep="$1" bin="$2" exec_dir="$3"

  # directory of the "loader" (the file that holds the reference)
  local loader_path; loader_path="$(cd "$(dirname "$bin")" && pwd -P)"
  # @executable_path = directory of the main executable (if not provided, falls back to loader_path)
  local executable_path="${exec_dir:-$loader_path}"
  local r

  case "$dep" in
    @loader_path/*|@executable_path/*)
      # Direct expansion of tokens in the dependency
      local cand; cand="$(expand_dyld_tokens "$dep" "$loader_path" "$executable_path")"
      [[ -e "$cand" ]] && { printf '%s\n' "$cand"; return 0; } \
      || { printf '%s\n' "$cand"; return 1; }
      ;;
    @rpath/*)
      local suffix="${dep#@rpath}"
      local rp_list=()

      # 1) main executable RPATHs - usually priority number 1
      while IFS= read -r r; do [[ -n "$r" ]] && rp_list+=("$r"); done < <(rpaths_of_main "$MAIN_RPATH_EXE" || true)

      # 2) RPATHs from the loader (current analysed file)
      while IFS= read -r r; do [[ -n "$r" ]] && rp_list+=("$r"); done < <(rpaths_of "$bin" || true)

      # 3) extra RPATHs added by option
      for r in "${EXTRA_RPATHS[@]:-}"; do rp_list+=("$r"); done

      # 4) DYLD_LIBRARY_PATH (if activated by option)
      if [[ $USE_DYLD_ENV -eq 1 && -n "${DYLD_LIBRARY_PATH:-}" ]]; then
        IFS=':' read -r -a _dyld_lp <<<"$DYLD_LIBRARY_PATH"
        for r in "${_dyld_lp[@]}"; do [[ -n "$r" ]] && rp_list+=("$r"); done
      fi

      # try every translated RPATH
      local cand r_expanded
      for r in "${rp_list[@]}"; do
        # IMPORTANT: expand @loader_path / @executable_path within the RPATH itself
        r_expanded="$(expand_dyld_tokens "$r" "$loader_path" "$executable_path")"
        [[ -z "$r_expanded" ]] && continue
        cand="$(normalize_path "$r_expanded$suffix")"
        if [[ -e "$cand" ]]; then
          printf '%s\n' "$cand"
          return 0
        fi
        printf '%s\n' "$cand"
      done
      return 1
      ;;
    /*)
      [[ -e "$dep" ]] && { printf '%s\n' "$dep"; return 0; } \
      || { printf '%s\n' "$dep"; return 1; }
      ;;
    *)
      # relative path / ambiguous path
      return 1
      ;;
  esac
}

# check path passed as script argument
parse_paths() {
  local path
  for path in "$@"; do
    if [[ -d "$path" ]]; then
      find "$path" -type f \( -perm -111 -o -name '*.dylib' -o -name '*.so' -o -name '*.bundle' \) -print
      find "$path" -type f -path '*/*.framework/*' -print
    elif [[ -f "$path" ]]; then
      echo "$path"
    fi
  done | sort -u
}

usage() {
  man
}

ARGS=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) FORMAT="json"; shift 1;;
	--log) LOG=1; shift 1;;
    --exec-dir) EXEC_DIR="${2:-}"; shift 2;;
    --main-rpath-exe) MAIN_RPATH_EXE="${2:-}"; shift 2;;
    --system-prefix) SYSTEM_PREFIXES+=("${2:-}"); shift 2;;
    --extra-rpath) EXTRA_RPATHS+=("${2:-}"); shift 2;;
    --use-dyld-env) USE_DYLD_ENV=1; shift 1;;
    --check-dyld-cache) CHECK_DYLD_CACHE=1; shift 1;;
    -h|--help) usage; exit 0;;
    *) ARGS+=("$1"); shift;;
  esac
done

if [[ ${#ARGS[@]} -eq 0 ]]; then
  log_err "ERROR : no file nor folder given."
  usage
  exit 2
fi

if [ $CHECK_DYLD_CACHE -eq 1 ]; then
	if ! PATH="$(pwd):$PATH" command -v macos-dyld-cache-analyse.sh >/dev/null 2>&1; then
		log_err "ERROR : requirement macos-dyld-cache-analyse.sh is missing"
		log_err "		download it from https://gist.github.com/StudioEtrange/8c2801df68969538cfccc6dcdb8d6bcc"
		log_err "		curl -fksL \"https://gist.githubusercontent.com/StudioEtrange/8c2801df68969538cfccc6dcdb8d6bcc/raw/macos-dyld-cache-analyse.sh?$(date +%s)\""
		usage
		exit 1
	fi
fi

FILES=()
while IFS= read -r f; do FILES+=("$f"); done < <(parse_paths "${ARGS[@]}")

if [[ ${#FILES[@]} -eq 0 ]]; then
  log_err "ERROR : invalid path given."
  usage
  exit 2
fi


JSON_ITEMS=()
GLOBAL_ISSUES_TOTAL=0

for f in "${FILES[@]}"; do
  original_filename="$f"
  f="$(real_path "$f")"
  file_type=$(macho_type "$f") || continue  

  DEP_TOTAL=0
  DEP_SOLVED_TOTAL=0
  DEP_NOT_SOLVED_TOTAL=0
  ISSUES_TOTAL=0
  RPATHS_TOTAL=0
  TRACE_TOTAL=0

  DYLIB_ID="$(id_of_dylib "$f" || true)"

  issues_trace=()
  log_trace=()
  dep_solved=()
  dep_solved_as=()
  dep_not_solved=()
  dep_checked_cached=()
  dep_should_be_cached=()

  if [[ "$FORMAT" == "text" ]]; then
      echo "-----------------------------------------------------"
      echo "FILE: $original_filename"
	  echo "TYPE: $file_type"
  fi
  [ $LOG -eq 1 ] && echo "LOGS:"

  # LC_ID_DYLIB - install name - only for shareable binary (dylib)
  if [[ $file_type =~ dylib* ]]; then
    if [[ "$DYLIB_ID" == @rpath/* || "$DYLIB_ID" == @loader_path/* || "$DYLIB_ID" == @executable_path/* ]]; then
		result="LC_ID_DYLIB | $DYLIB_ID | install_name standard value"; trace='  + '"$result";
		log_trace+=("$trace");
		[ $LOG -eq 1 ] && printf '%s\n' "$trace"
	elif [[ "$DYLIB_ID" == "" ]]; then
		result="LC_ID_DYLIB | $DYLIB_ID | install_name empty value"; trace='  - '"$result";
		ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
		issues_trace+=("$result"); log_trace+=("$trace");
    elif [[ "$DYLIB_ID" == /* ]]; then
      if ! path_in_system_prefixes "$DYLIB_ID"; then
        result="LC_ID_DYLIB | $DYLIB_ID | non standard absolute path : should change to @rpath/$(basename "$f")"; trace='  - '"$result";
		ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
		issues_trace+=("$result"); log_trace+=("$trace");
		[ $LOG -eq 1 ] && printf '%s\n' "$trace"

        if [[ -e "$DYLIB_ID" ]]; then
            local_id_real="$(real_path "$DYLIB_ID")"
		    if [[ "$local_id_real" == "$f" ]]; then
				result="LC_ID_DYLIB | $DYLIB_ID | exists and match $f"; trace='  + '"$result";
				log_trace+=("$trace")
				[ $LOG -eq 1 ] && printf '%s\n' "$trace"
			else
				result="LC_ID_DYLIB | $DYLIB_ID | $local_id_real exists but do not match $f"; trace='  - '"$result";
				ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
				issues_trace+=("$result"); log_trace+=("$trace");
				[ $LOG -eq 1 ] && printf '%s\n' "$trace"
			fi
        else
		  result="LC_ID_DYLIB | $DYLIB_ID | not found path"; trace='  - '"$result";
		  ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
		  issues_trace+=("$result"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        fi
      else
        result="LC_ID_DYLIB | $DYLIB_ID | cached | should be solved in dyld cache"; trace='  * '"$result";
        log_trace+=("$trace")
		[ $LOG -eq 1 ] && printf '%s\n' "$trace"
      fi
    else
      result="LC_ID_DYLIB | $DYLIB_ID | non-standard or ambiguous relative path : should change to @rpath/$(basename "$f")"; trace='  - '"$result";
      ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
	  issues_trace+=("$result"); log_trace+=("$trace");
	  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
    fi
  fi

  DEPS=()
  # NOTE exclude itself as dependency
  while IFS= read -r line; do [[ -n "$line" && "$line" != "$DYLIB_ID" ]] && DEPS+=("$line"); done < <(deps_of "$f" || true)
  RPATHS=()
  while IFS= read -r line; do [[ -n "$line" ]] && RPATHS+=("$line"); done < <(rpaths_of "$f" || true)

  # Dependencies
  for dep in "${DEPS[@]}"; do
    output=
    result=
	trace=
    case "$dep" in
      @rpath/*)
        if output="$(resolve_dep "$dep" "$f" "$EXEC_DIR" 2>/dev/null)"; then
		  result="$dep | found | $output"; trace='  + '"$result";
		  dep_solved+=("$dep"); dep_solved_as+=("$output"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        else
          #result="$dep | not found | tried RPATHs : $(join_by ':' "${RPATHS[@]}")"
          #result="$dep | not found | tried RPATHs : $(join_by ':' "$output")"
          _joined="$(printf '%s' "$output" | tr '\n' ':' | sed 's/:$//')"
          result="$dep | not found | tried : $_joined"; trace='  - '"$result";
		  ISSUES_TOTAL=$((ISSUES_TOTAL + 1));
		  dep_not_solved+=("$dep"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        fi
        ;;
      @loader_path/*)
        if output="$(resolve_dep "$dep" "$f" "$EXEC_DIR" 2>/dev/null)"; then
          result="$dep | found | $output"; trace='  + '"$result";
          dep_solved+=("$dep"); dep_solved_as+=("$output"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        else
          result="$dep | not found | tried : $output"; trace='  - '"$result";
		  ISSUES_TOTAL=$((ISSUES_TOTAL + 1));
		  dep_not_solved+=("$dep"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        fi
        ;;
      @executable_path/*)
        if output="$(resolve_dep "$dep" "$f" "$EXEC_DIR" 2>/dev/null)"; then
		  result="$dep | found | $output"; trace='  + '"$result";
		  dep_solved+=("$dep"); dep_solved_as+=("$output"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        else
          result="$dep | not found | tried : $output"; trace='  - '"$result";
		  ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
		  dep_not_solved+=("$dep"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        fi
        ;;
      /*)
        if output="$(resolve_dep "$dep" "$f" "$EXEC_DIR" 2>/dev/null)"; then
          result="$dep | found | $output"; trace='  + '"$result";
		  dep_solved+=("$dep"); dep_solved_as+=("$output"); log_trace+=("$trace");
		  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
        else
          if [ $CHECK_DYLD_CACHE -eq 1 ]; then
		  	result="$dep | finding | checking in dyld cache"; trace='  * '"$result";
			log_trace+=("$trace");
			[ $LOG -eq 1 ] && printf '%s\n' "$trace"
			if output="$(path_exists_in_dyld_cache "$dep" 2>/dev/null)"; then
				result="$dep | cached | $output"; trace='  + '"$result";
				dep_solved+=("$dep"); dep_solved_as+=("$output"); dep_checked_cached+=("$dep"); log_trace+=("$trace");
				[ $LOG -eq 1 ] && printf '%s\n' "$trace"
			else
				result="$dep | not found | not found in dyld cache"; trace='  - '"$result";
				ISSUES_TOTAL=$((ISSUES_TOTAL + 1))
				dep_not_solved+=("$dep"); log_trace+=("$trace");
				[ $LOG -eq 1 ] && printf '%s\n' "$trace"
			fi
          else
            if ! path_in_system_prefixes "$dep"; then
              result="$dep | non standard absolute path should change to @rpath, @loader_path or @executable_path"; trace='  - '"$result";
              ISSUES_TOTAL=$((ISSUES_TOTAL + 1));
			  issues_trace+=("$result"); log_trace+=("$trace");
			  [ $LOG -eq 1 ] && printf '%s\n' "$trace"

              result="$dep | not found"; trace='  - '"$result";
			  ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
			  dep_not_solved+=("$dep"); log_trace+=("$trace");
			  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
            else
			  result="$dep | cached | mark as solved in dyld cache, to check use --check-dyld-cache"; trace='  * '"$result";
			  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
              result="$dep | cached | $dep"; trace='  + '"$result";
			  dep_solved+=("$dep"); dep_solved_as+=("$dep"); dep_should_be_cached+=("$dep"); log_trace+=("$trace");
			  [ $LOG -eq 1 ] && printf '%s\n' "$trace"
            fi
          fi

        fi
        ;;
      *)
		result="$dep | non-standard or ambiguous relative path should change to @rpath, @loader_path or @executable_path"; trace='  - '"$result";
		ISSUES_TOTAL=$((ISSUES_TOTAL + 1)); 
		dep_not_solved+=("$dep"); log_trace+=("$trace");
		[ $LOG -eq 1 ] && printf '%s\n' "$trace"
        ;;
    esac
  done

  if [[ ${#log_trace[@]} -gt 0 ]]; then
    TRACE_TOTAL=$((TRACE_TOTAL + ${#log_trace[@]}))
  fi
  if [[ ${#RPATHS[@]} -gt 0 ]]; then
    RPATHS_TOTAL=$((RPATHS_TOTAL + ${#RPATHS[@]}))
  fi
  if [[ ${#DEPS[@]} -gt 0 ]]; then
    DEP_TOTAL=$((DEP_TOTAL + ${#DEPS[@]}))
  fi
  if [[ ${#dep_not_solved[@]} -gt 0 ]]; then
    DEP_NOT_SOLVED_TOTAL=$((DEP_NOT_SOLVED_TOTAL + ${#dep_not_solved[@]}))
  fi
    if [[ ${#dep_solved[@]} -gt 0 ]]; then
    DEP_SOLVED_TOTAL=$((DEP_SOLVED_TOTAL + ${#dep_solved[@]}))
  fi
  
  if [[ ${#dep_checked_cached[@]} -gt 0 ]]; then
  	dep_checked_cached=($(unique_array "${dep_checked_cached[@]}"))
	DEP_CHECKED_CACHED_TOTAL=${#dep_checked_cached[@]}
  fi

  if [[ ${#dep_should_be_cached[@]} -gt 0 ]]; then
  	dep_should_be_cached=($(unique_array "${dep_should_be_cached[@]}"))
	DEP_SHOULD_BE_CACHED_TOTAL=${#dep_should_be_cached[@]}
  fi



  GLOBAL_ISSUES_TOTAL=$((ISSUES_TOTAL + GLOBAL_ISSUES_TOTAL))


  if [[ "$FORMAT" == "text" ]]; then
      echo "-----------------------------------------------------"
      echo "DIGEST FOR: $f"
	  echo "TYPE: $file_type"
      echo "  RPATHS: $RPATHS_TOTAL | DEPENDENCIES: $DEP_TOTAL | DEPENDENCIES SOLVED: $DEP_SOLVED_TOTAL | DEPENDENCIES NOT SOLVED: $DEP_NOT_SOLVED_TOTAL | ISSUES: $ISSUES_TOTAL"
  else
    data="{\"rpaths_total\":$RPATHS_TOTAL,\"deps_solved_total\":$DEP_SOLVED_TOTAL,\"deps_not_solved_total\":$DEP_NOT_SOLVED_TOTAL,\"deps_total\":$DEP_TOTAL,\"issues_total\":$ISSUES_TOTAL}"

    esc_file=$(json_escape "$f")
	esc_file_type=$(json_escape "$file_type")
	esc_dylib_id=$(json_escape "$DYLIB_ID")
    json_rpaths=$(json_array "${RPATHS[@]:-}")
    json_deps=$(json_array "${DEPS[@]:-}")
    json_solved=$(json_array "${dep_solved[@]:-}")
	json_solved_as=$(json_array "${dep_solved_as[@]:-}")
	json_solved_map_val=$(json_solved_map)
	json_not_solved=$(json_array "${dep_not_solved[@]:-}")
	json_should_be_cached=$(json_array "${dep_should_be_cached[@]:-}")
	json_checked_cached=$(json_array "${dep_checked_cached[@]:-}")
    json_issues=$(json_array "${issues_trace[@]:-}")
	
	JSON_ITEMS+=("{\"file\":$esc_file,\"file_type\":$esc_file_type,\"install_name\":$esc_dylib_id,\"data\":$data,\"rpaths\":$json_rpaths,\"deps\":$json_deps,\"deps_solved\":$json_solved,\"deps_should_be_cached\":$json_should_be_cached,\"deps_checked_cached\":$json_checked_cached,\"deps_solved_as\":$json_solved_as,\"deps_solved_map\":$json_solved_map_val,\"deps_not_solved\":$json_not_solved,\"issues\":$json_issues}")

  fi


	if [[ "$FORMAT" == "text" ]]; then
		echo "INSTALL NAME/LC_ID_DYLIB: $DYLIB_ID"

		echo "RPATHS: $RPATHS_TOTAL"
		if [[ $RPATHS_TOTAL -gt 0 ]]; then
			printf '  * %s\n' "${RPATHS[@]}"
		fi

		echo "DEPENDENCIES: $DEP_TOTAL"
		if [[ $DEP_TOTAL -gt 0 ]]; then
			printf '  * %s\n' "${DEPS[@]}"
		fi

		echo "DEPENDENCIES SOLVED: $DEP_SOLVED_TOTAL"
		if [[ $DEP_SOLVED_TOTAL -gt 0 ]]; then
			printf '  + %s\n' "${dep_solved[@]}"
		fi

		if [ $CHECK_DYLD_CACHE -eq 1 ]; then
			echo "DEPENDENCIES IN DYLD CACHE (checked): $DEP_CHECKED_CACHED_TOTAL"
			if [[ $DEP_CHECKED_CACHED_TOTAL -gt 0 ]]; then
				printf '  + %s\n' "${dep_checked_cached[@]}"
			fi
		else
			echo "DEPENDENCIES IN DYLD CACHE (should be): $DEP_SHOULD_BE_CACHED_TOTAL"
			if [[ $DEP_SHOULD_BE_CACHED_TOTAL -gt 0 ]]; then
				printf '  + %s\n' "${dep_should_be_cached[@]}"
			fi
		fi

		echo "DEPENDENCIES NOT SOLVED: $DEP_NOT_SOLVED_TOTAL"
		if [[ $DEP_NOT_SOLVED_TOTAL -gt 0 ]]; then
			printf '  - %s\n' "${dep_not_solved[@]}"
		fi

		echo "ISSUES: $ISSUES_TOTAL"
		if [[ ${#issues_trace[@]} -gt 0 ]]; then
			printf '  - %s\n' "${issues_trace[@]}"
		fi
	fi
done

if [[ "$FORMAT" == "json" ]]; then
  echo -n "["
  sep=""
  for item in "${JSON_ITEMS[@]}"; do
    printf '  %s%s\n' "$sep" "$item"
    sep=","
  done
  echo -n "]"
fi

if [[ $GLOBAL_ISSUES_TOTAL -gt 0 ]]; then
  exit 1
else
  exit 0
fi
