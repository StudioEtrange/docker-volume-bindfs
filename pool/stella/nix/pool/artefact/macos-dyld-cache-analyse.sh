#!/usr/bin/env bash
# macos-dyld-cache-analyse.sh
# https://gist.github.com/StudioEtrange/8c2801df68969538cfccc6dcdb8d6bcc
# Author: StudioEtrange https://github.com/StudioEtrange
# License: MIT
set -euo pipefail

man() {
cat <<MAN
Usage: macos-dyld-cache-analyse.sh [options]

Purpose:
  List and search content in dyld shared cache using the "ipsw" tool.
  Usefull to analyse libraries installed into macos system.

Options:
  --cache <file>          Use a specific dyld_shared_cache file
  --images                Output full image paths (files) instead of directories
  --dir                   Output containing directory paths
  --only-dylib            Keep only entries ending with .dylib
  --count                 Show a count per item (directory or image)
  --json                  Output results as JSON
  --quiet                 Do not output extra text in text mode
  --exclude-regex <regex>    (repeatable) Add an extra exclude regex
  --no-default-excludes   Do not apply the built-in default exclude path list
  --usrlib                Keep only /usr/lib (overrides default and extra exclude path)
  --exists <regex>        (repeatable) List all matching files and folders in the cache for this regex
  --exists-one <regex>    (repeatable) List the first matching file or folder in the cache for this regex
  -h|--help               Show help

The result list is first filtered with:
	* --exclude-regex : add additional extra exclude regex from result (repeatable)
	* a list of default path exclusion unless --no-default-excludes
	* --usrlib : only keep result from /usr/lib and /usr/lib/system paths
				override default excludes and extra exclude path (--exclude-regex)
	* --only-dylib : only keep .dylib files in result
You can check in filtered result list if a regex of an item is present:
	* --exists : check a regex from the result list
				allow to check if a library or folder exists in the cache
	* --exists-one : first matching regex only
The final ouptut result :
	* content only images (--images, by default)
	  or only parent folder containing the resulting images (--dir)
	* --count : add count of result
	* --json : output format is json instead of text
			JSON in exists-mode:
			When using --json together with one or more --exists / --exists-one, the script
			emits a single JSON array where each element describes one expression, e.g.:
			[
				{ "regex": "libz", "total_nb_matches": 1, "matches": ["/usr/lib/libz.1.dylib"] },
				{ "regex": "libfoo", "total_nb_matches": 0, "matches": [] }
			]


About dyld cache files :
	* --cache : option to specify a dyld cache file, 
            by default dyld cache files are autodetected and compatible with dyld4 subcaches (macOS 12+)

About path/regex filters :
	* --exclude-regex : add extra excludes regexes
	* --no-default-excludes : remove defaults exclude path
	* default excludes path is a hardcoded list of path in variable DEFAULT_EXCLUDES_PATH excluded from result
	  see below to see its content
	* --usrlib to only keep /usr/lib/

Requirements:
  - bash (3.2+)
  - ipsw (https://github.com/blacktop/ipsw)

Usage examples:
  # Existence check (prints first match, exit 0/1):
  ./macos-dyld-cache-analyse.sh --exists-one '^/usr/lib/libz(\.1)?\.dylib$'
  > --- REGEX 1: ^/usr/lib/libz(\.1)?\.dylib$ - FLAG: only one match - TOTAL_NB_MATCHES: 1 ---
  > /usr/lib/libz.1.dylib

  # Default listing of items cached:
  ./macos-dyld-cache-analyse.sh
  > /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libLLVMContainer.dylib
  > /System/Library/Frameworks/OpenGL.framework/Versions/A/OpenGL
  > ...

  # Full dylib files list
  ./macos-dyld-cache-analyse.sh --only-dylib
  > /usr/lib/system/libunwind.dylib
  > /usr/lib/system/libxpc.dylib
  > ...

  # Count by directory, JSON output:
  ./macos-dyld-cache-analyse.sh --dir --count --json
  
  # search libz items in only in /usr/lib and json output
  ./macos-dyld-cache-analyse.sh --usrlib --exists libz --json
  > ["/usr/lib/libz.1.dylib"]

   # search first matching libz item in only in /usr/lib and print containing folder
  ./macos-dyld-cache-analyse.sh --dir --usrlib --exists-one libz --quiet
  > /usr/lib

  # print count of files into content directories of /usr/lib
  ./macos-dyld-cache-analyse.sh --dir --usrlib --count
  > 216 /usr/lib
  >  74 /usr/lib/swift
  >  43 /usr/lib/system
  > ...

  # Provide additional excludes and disable defaults:
  ./macos-dyld-cache-analyse.sh --no-default-excludes --exclude-regex ^/System/Library/Frameworks/Metal.framework

Default excluded paths:
$(printf '  %s\n' "${DEFAULT_EXCLUDES_PATH[@]}")

Default dyld cache files search patterns:
$(printf '  %s\n' "${DYLD_CACHE_SEARCH_PATTERNS[@]}")

MAN
}

# ------------------------ argument parsing ------------------------

DYLD_CACHE_FILE=""
MODE="images"         # "dir" or "images"
ONLY_DYLIB=0
DO_COUNT=0
AS_JSON=0
USRLIB=0
USE_DEFAULT_EXCLUDES_PATH=1
EXTRA_EXCLUDES_REGEX=()
QUIET=0

# we store all regex in a parallel array (+ flag)
EXISTS_REGEXES=()             # all patterns (from --exists and --exists-one)
EXISTS_REGEX_FIRST_MATCHING=() # "", or "-m1" for --exists-one

# fill this with a path by line
# it will be turned into regex like this:
# ^line1|^line2|^line3
DEFAULT_EXCLUDES_PATH=(
)

arch="$(uname -m)"
DYLD_CACHE_SEARCH_PATTERNS=(
  "/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_${arch}*"
  "/System/Library/dyld/dyld_shared_cache_${arch}*"
  "/var/db/dyld/dyld_shared_cache_${arch}*"
)


# Helper: detect dyld_shared_cache files for current arch 
# exclude subcaches files .01 .02 ... because we do not need subcaches when using ipsw dyld info
# stdout: list of cache files, one per line
detect_dyld_cache() {
	local files
		files="$(for p in "${DYLD_CACHE_SEARCH_PATTERNS[@]}"; do compgen -G "$p" 2>/dev/null; done \
				| grep -Ev '\.(map|symbols|plist)$' \
				| sort -u)"
	# try to prefer non-suffixed, else fall back to all
	if grep -qvE '\.[0-9][0-9]?$' <<<"$files"; then
		grep -Ev '\.[0-9][0-9]?$' <<<"$files"
	else
		printf '%s\n' "$files"
	fi
}

# ------------------------ helpers ------------------------
# Stream all image paths from one cache file
stream_cache_images() {
	ipsw dyld info -l -s "$1" 2>/dev/null \
		| awk '{for(i=1;i<=NF;i++) if ($i ~ /^\//) {print $i; break}}'
}

# Stream all images from all detected caches
stream_all_images() {
	local c
	for c in "${DYLD_CACHE_FILES[@]}"; do
		stream_cache_images "$c"
	done
}

# Apply all filters (usrlib, excludes, only-dylib)
apply_filters() {
	
	local exclude_default=()
	local exclude_extra=()
	local pattern

	# 1. apply default excludes path
	if [ "${#DEFAULT_EXCLUDES_PATH[@]:-0}" -gt 0 ]; then
		(( USE_DEFAULT_EXCLUDES_PATH )) && exclude_default=("${DEFAULT_EXCLUDES_PATH[@]}")
		# turn ("foo" "bar/baz" "test(1)") into '^foo|^bar/baz|^test\(1\)'
		# add ^ at the beginning and  escape regex characters
		pattern="$(printf '%s\n' "${exclude_default[@]}" \
			| sed -e 's/[.[\*^$()+?{|]/\\&/g' \
			| sed 's/^/^/' \
			| paste -sd'|' -)"
		grep -vE "$pattern" || true
	else
		cat
	fi |
	# 2. apply extra excludes regexes
	if [ "${#EXTRA_EXCLUDES_REGEX[@]:-0}" -gt 0 ]; then
		exclude_extra=("${EXTRA_EXCLUDES_REGEX[@]}")
		# add | separator and do not escape regex characters
		pattern="$(printf '%s\n' "${exclude_extra[@]}" \
			| paste -sd'|' -)"
		grep -vE "$pattern" || true
	else
		cat
	fi |
	# 3. keep only starting with /usr/lib
	if (( USRLIB )); then
		grep -E '^/usr/lib/' || true
	else
		cat
	fi |
	# 4. keep only .dylib if requested
	if (( ONLY_DYLIB )); then
		grep -E '\.dylib$' || true
	else
		cat
	fi
}

json_escape_light() {
  	sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
}

# Print JSON array from newline-separated list
print_json_array() {
	local first=1 line esc
	echo -n '['
	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
		esc="$(printf '%s' "$line" | json_escape_light)"
		if [[ $first -eq 0 ]]; then
			echo -n ','
		else
			first=0
		fi
		printf '"%s"' "$esc"
	done
	echo -n ']'
}

# Print JSON array of {"item":"...","count":N} from "count item" lines
print_json_with_counts() {
	local first=1 line count item esc
	echo -n '['
	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
			count=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*([0-9]+).*/\1/')
			item=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//')
			esc="$(printf '%s' "$item" | json_escape_light)"
		if [[ $first -eq 0 ]]; then
			echo -n ','
		else
			first=0
		fi
		printf '{"item":"%s","count":%d}' "$esc" "$count"
	done
	echo -n ']'
}

usage() { man; }

# ------------------------ CLI parsing ------------------------

while [[ $# -gt 0 ]]; do
	case "$1" in
		--cache)               DYLD_CACHE_FILE="${2:-}"; shift 2 ;;
		--images)              MODE="images"; shift ;;
		--dir)                 MODE="dir"; shift ;;
		--only-dylib)          ONLY_DYLIB=1; shift ;;
		--count)               DO_COUNT=1; shift ;;
		--json)                AS_JSON=1; shift ;;
		--quiet)			   QUIET=1; shift ;;
		--exclude-regex)       EXTRA_EXCLUDES_REGEX+=("${2:-}"); shift 2 ;;
		--no-default-excludes) USE_DEFAULT_EXCLUDES_PATH=0; shift ;;
		--usrlib)            USRLIB=1; shift ;;
		--exists)              EXISTS_REGEXES+=("${2:-}"); EXISTS_REGEX_FIRST_MATCHING+=(""); shift 2 ;;
		--exists-one)          EXISTS_REGEXES+=("${2:-}"); EXISTS_REGEX_FIRST_MATCHING+=("-m1"); shift 2 ;;
		-h|--help)             usage; exit 0 ;;
		*) echo "Unknown option: $1" >&2; usage; exit 2 ;;
	esac
done

# ------------------------ check tools ------------------------

if ! command -v ipsw >/dev/null 2>&1; then
	echo "Error: 'ipsw' is not in PATH." >&2
	exit 127
fi

# ------------------------ detect cache files ------------------------

DYLD_CACHE_FILES=()
if [[ -n "$DYLD_CACHE_FILE" ]]; then
	if [[ ! -f "$DYLD_CACHE_FILE" ]]; then
		echo "Error: dyld cache file not found: $DYLD_CACHE_FILE" >&2
		exit 3
	fi
	DYLD_CACHE_FILES+=("$DYLD_CACHE_FILE")
else
	while IFS= read -r c; do
		DYLD_CACHE_FILES+=("$c")
	done < <(detect_dyld_cache || true)
	if ((${#DYLD_CACHE_FILES[@]}==0)); then
		echo "Error: no dyld_shared_cache detected for $(uname -m)." >&2
		echo "Searched patterns:" >&2
		for p in "${DYLD_CACHE_SEARCH_PATTERNS[@]}"; do
			printf '  %s\n' "$p" >&2
		done
		exit 4
	fi
fi

# ------------------------ EXISTS MODE (multi) ------------------------

if [ "${#EXISTS_REGEXES[@]:-0}" -gt 0 ]; then

  ALL_FILTERED_IMAGES="$(stream_all_images | apply_filters || true)"
  global_rc=0
  cpt=0
  first_match_flag=""

  if (( AS_JSON )); then echo -n '[ '; fi

  for rx in "${EXISTS_REGEXES[@]}"; do
	first_match_flag="${EXISTS_REGEX_FIRST_MATCHING[$cpt]}"
	((cpt++))
	MATCHES="$(printf '%s\n' "$ALL_FILTERED_IMAGES" | grep -E $first_match_flag -- "$rx" || true)"

    if [[ -z "$MATCHES" ]]; then
		total_nb_matches=0
		global_rc=1
    else
		total_nb_matches="$(printf '%s\n' "$MATCHES" | LC_ALL=C sort -u | wc -l | xargs)"
    fi

    if (( AS_JSON )); then
		# separator between objects
		if [[ $cpt -gt 1 ]]; then
		echo ','
		fi
		echo -n '{ "regex": "'
		printf '%s' "$rx" | json_escape_light
		echo -n '", "total_nb_matches": '"$total_nb_matches"', "matches": '
		[[ -z "$MATCHES" ]] && echo -n '[] }'
    else
		if [ $QUIET -eq 0 ]; then
			if [ -z "$first_match_flag" ]; then
				echo "--- REGEX $cpt: $rx - TOTAL_NB_MATCHES: $total_nb_matches ---"
			else
				echo "--- REGEX $cpt: $rx - FLAG: only one match - TOTAL_NB_MATCHES: $total_nb_matches ---"
			fi
		fi
	fi
	[[ -z "$MATCHES" ]] && continue

	if (( DO_COUNT )); then
		if [[ "$MODE" == "dir" ]]; then
			printf '%s\n' "$MATCHES" \
				| awk '{d=$0; sub("/[^/]+$","",d); print d}' \
				| LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr \
				| { if (( AS_JSON )); then print_json_with_counts; else cat; fi; }
		else
			printf '%s\n' "$MATCHES" \
				| LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr \
				| { if (( AS_JSON )); then print_json_with_counts; else cat; fi; }
		fi
	else
		if [[ "$MODE" == "dir" ]]; then
			printf '%s\n' "$MATCHES" \
				| awk '{d=$0; sub("/[^/]+$","",d); print d}' \
				| LC_ALL=C sort -u \
				| { if (( AS_JSON )); then print_json_array; else cat; fi; }
		else
			printf '%s\n' "$MATCHES" \
				| LC_ALL=C sort -u \
				| { if (( AS_JSON )); then print_json_array; else cat; fi; }
		fi
	fi

    if (( AS_JSON )); then echo -n '}'; fi
  done

  if (( AS_JSON )); then echo -n ' ]'; fi

  exit "$global_rc"
fi

# ------------------------ DEFAULT LISTING MODE ------------------------

stream_all_images \
	| apply_filters \
	| {
		if (( DO_COUNT )); then
			if [[ "$MODE" == "dir" ]]; then
				awk '{d=$0; sub("/[^/]+$","",d); print d}' \
					| LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr \
					| { if (( AS_JSON )); then print_json_with_counts; else cat; fi; }
			else
				LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr \
					| { if (( AS_JSON )); then print_json_with_counts; else cat; fi; }
			fi
		else
			if [[ "$MODE" == "dir" ]]; then
				awk '{d=$0; sub("/[^/]+$","",d); print d}' \
					| LC_ALL=C sort -u \
					| { if (( AS_JSON )); then print_json_array; else cat; fi; }
			else
				LC_ALL=C sort -u \
					| { if (( AS_JSON )); then print_json_array; else cat; fi; }
			fi
		fi
	}
