if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then

    # search for dmg content
    find_primary_content() {
        local mp="$1"
        local file
        # .app à la racine du volume
        file="$(find "$mp" -maxdepth 1 -type d -name "*.app" -print -quit)"
        [ -n "$file" ] && echo $file && return 0
        # .pkg à la racine
        file="$(find "$mp" -maxdepth 1 -type f -name "*.pkg" -print -quit)"
        [ -n "$file" ] && echo $file && return 0
        # look for app or pkg insome subfolders
        file="$(find "$mp" -maxdepth 2 -type d -name "*.app" -print -quit)"
        [ -n "$file" ] && echo $file && return 0
        file="$(find "$mp" -maxdepth 3 -type f -name "*.pkg" -print -quit)"
        [ -n "$file" ] && echo $file && return 0

        return 1
    }

    extract_payload() {
        local payload="$1" dest="$2"
        mkdir -p "$dest"

        __log_stella "DEBUG" "extract payload : $payload to $dest"

        # check compression type
        is_gzip()  { od -An -t x1 -N2 "$1" 2>/dev/null | grep -qi '1f 8b'; }
        is_xz()    { od -An -t x1 -N6 "$1" 2>/dev/null | grep -qi 'fd 37 7a 58 5a 00'; }
        is_bzip2() { od -An -t x1 -N3 "$1" 2>/dev/null | grep -qi '42 5a 68'; }
        is_cpio_newc() { head -c 6 "$1" 2>/dev/null | grep -qx '070701'; } # newc ascii

        if is_gzip "$payload"; then
            __log_stella "DEBUG" "use gzip command"
            gzip -dc -- "$payload" | (cd "$dest" && cpio -idm --quiet)
            return
        fi
        if is_xz "$payload"; then
            __log_stella "DEBUG" "use xz command"
            xz -dc -- "$payload" | (cd "$dest" && cpio -idm --quiet)
            return
        fi
        if is_bzip2 "$payload"; then
            __log_stella "DEBUG" "use bzip2 command"
            bzip2 -dc -- "$payload" | (cd "$dest" && cpio -idm --quiet)
            return
        fi
        if is_cpio_newc "$payload"; then
            __log_stella "DEBUG" "use cpio command"
            (cd "$dest" && cpio -idm --quiet) < "$payload"
            return
        fi

        # last try : tar
        if tar tf "$payload" >/dev/null 2>&1; then
            __log_stella "DEBUG" "use tar command"
            (cd "$dest" && tar xf "$payload")
            return
        fi

        # generic : try gzip then xz without signature (rare case)
        if gzip -t "$payload" >/dev/null 2>&1; then
            __log_stella "DEBUG" "use gzip command (gzip file without signature in header)"
            gzip -dc -- "$payload" | (cd "$dest" && cpio -idm --quiet)
            return
        fi
        if xz -t "$payload" >/dev/null 2>&1; then
            __log_stella "DEBUG" "use xz command (xz file without signature in header)"
            xz -dc -- "$payload" | (cd "$dest" && cpio -idm --quiet)
            return
        fi

        __log_stella "WARN" "Unknown payload format"
    }

    expand_pkg() {
        local pkg="$1" outdir="$2"
        __log_stella "DEBUG" "pkgutil expand : $pkg to $outdir"
        $PKG_EXPAND_CMD "$pkg" "$outdir"
    }

    # full pkg extract
    extract_pkg_tree() {
        local pkg="$1" 
        local dest="$2"
        
        local tmpdir
        tmpdir="$(mktmpdir)"
        expand_pkg "$pkg" "$tmpdir/$(basename $pkg)"

        payloads=()
        while IFS= read -r line; do
            payloads+=("$line")
        done < <(find "$tmpdir" -type f -name 'Payload' 2>/dev/null)

        if [ ${#payloads[@]} -eq 0 ]; then
            __log_stella "WARN" "No payload found in $pkg"
        else
            for p in "${payloads[@]}"; do
                extract_payload "$p" "$dest"
            done
        fi
    }

    __extract_dmg() {
        local dmg_file_path="$1"
        local dest_dir="$2"

        [ "$dest_dir" = "" ] && dest_dir="$STELLA_CURRENT_RUNNING_DIR"
        [ ! -d "$dest_dir" ] && mkdir -p "$dest_dir"

        # check commmand pkgutil available option
        PKG_EXPAND_CMD="pkgutil --expand"
        if pkgutil --help 2>/dev/null | grep -q -- '--expand-full'; then
            PKG_EXPAND_CMD="pkgutil --expand-full"
        fi

        # mount dmg file and extract pkg file
        __log_stella "INFO" "Mount $dmg_file_path"
        output="$(hdiutil attach -nobrowse -noverify -noautoopen "$dmg_file_path")"
        dev="$(awk '/Apple_HFS|Apple_APFS|ISO9660|FAT|Windows_FAT|UDF/ {print $1; exit}' <<<"$output")"
        
        if [ -n "$dev" ]; then
            __log_stella "DEBUG" "Device mounted : $dev"
            volume_name="$(diskutil info "$dev" | awk -F': *' '/Volume Name/ {print $2}')"
            volume_path="/Volumes/$volume_name"
            __log_stella "DEBUG" "Volume name : $volume_name"
            __log_stella "DEBUG" "Volume path : $volume_path"
            if item="$(find_primary_content "$volume_path")"; then
                __log_stella "INFO" "Extract content $item into $dest_dir"
                case $item in
                    *.app)
                        cp -R "${item%/}" "$dest_dir/"
                        ;;
                    *.pkg)
                        extract_pkg_tree "$item" "$dest_dir"
                        ;;
                    *)
                        __log_stella "WARN" "No .app nor .dmg found in $dmg_file_path"
                        ;;
                esac
            else
                __log_stella "WARN" "No content found in $dmg_file_path"
            fi
            hdiutil detach "$dev" >/dev/null 2>&1
        else
            __log_stella "ERROR" "No device mounted"
        fi
        
    }
 
fi  