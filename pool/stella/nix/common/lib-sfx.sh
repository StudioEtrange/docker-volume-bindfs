#!sh
if [ ! "$_STELLA_COMMON_MAKE_SFX_INCLUDED_" = "1" ]; then
_STELLA_COMMON_MAKE_SFX_INCLUDED_=1

# SFX means auto extractible archive
# Alternative implementation see http://megastep.org/makeself/





# About 7z SFX see
#		for official extractors binary : http://ptspts.blogspot.fr/2013/12/how-to-make-existing-7-zip-archive-self.html
#		for tiny unofficial extractors binary : http://ptspts.blogspot.fr/2013/12/tiny-7z-archive-extractors-and-sfx-for.html
# NOTE : SFX for platform windows or linux
# NOTE : output is a binary file to run
# option 7Z will consider _target as a 7Z compressed file and will not try to compress _target (which is already compressed)
__make_sevenzip_sfx_bin() {
	local _target=$1
	local _output_sfx=$2
	local _platform=$3
	local _opt="$4"

	local _opt_target_is_sevenzip=OFF
	for o in $_opt; do
		[ "$o" = "7Z" ] && _opt_target_is_sevenzip=ON
	done

	local tp_7z=$(mktmp)

	if [ "$_opt_target_is_sevenzip" = "ON" ]; then
		tp_7z="$_target"
	else
		tp_7z=$(mktmp)
	fi

	if [ "$_opt_target_is_sevenzip" = "OFF" ]; then
		__compress "7Z" "$_target" "$tp_7z"
	fi


	local extractor_binary
	case $_platform in
		win)
			__download "$STELLA_POOL_URL/common/sfx_for_7z/7z9.20Win32Con.sfx"
			extractor_binary="$STELLA_APP_CACHE_DIR/7z9.20Win32Con.sfx"
			;;
		linux)
			__download "$STELLA_POOL_URL/common/sfx_for_7z/7z9.20LinuxI386Con.sfx"
			extractor_binary="$STELLA_APP_CACHE_DIR/7z9.20LinuxI386Con.sfx"
			;;
		darwin)
			__download "$STELLA_POOL_URL/common/sfx_for_7z/7z9.20Macosx10.6I386.sfx"
			extractor_binary="$STELLA_APP_CACHE_DIR/7z9.20Macosx10.6I386.sfx"
			;;
	esac

	cat "$extractor_binary" "$tp_7z" > "$_output_sfx"

	[ "$_opt_target_is_sevenzip" = "OFF" ] && rm -Rf "$tp_7z"

	case $_platform in
		linux|darwin)
			chmod +x $_output_sfx 2>/dev/null
			;;
	esac

}

# NOTE : SFX for linux
# NOTE : output is a shell file to run
# option TARGZ will consider _target as a tar.gz file and will not try to compress _target (which is already compressed)
__make_targz_sfx_shell() {
	local _target=$1
	local _output_sfx=$2
	local _opt="$3"

	local _opt_target_is_targz=OFF
	for o in $_opt; do
		[ "$o" = "TARGZ" ] && _opt_target_is_targz=ON
	done


	local tp_header=$(mktmp)
	local tp_gz

	if [ "$_opt_target_is_targz" = "ON" ]; then
		tp_gz="$_target"
	else
		tp_gz=$(mktmp)
	fi


	echo "#!/bin/sh" > "$tp_header"
	echo "ARCHIVE=\`awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' \$0\`" >> "$tp_header"
	echo "tail -n+\$ARCHIVE \$0 | tar xzv -C ." >> "$tp_header"
	echo "exit 0" >> "$tp_header"
	echo "__ARCHIVE_BELOW__" >> "$tp_header"

	if [ "$_opt_target_is_targz" = "OFF" ]; then
		__compress "TARGZ" "$_target" "$tp_gz"
	fi

	cat "$tp_header" "$tp_gz" > "$_output_sfx"

	rm -Rf "$tp_header"
	[ "$_opt_target_is_targz" = "OFF" ] && rm -Rf "$tp_gz"

	chmod +x $_output_sfx 2>/dev/null
}



fi
