# Linking & Libraries — Linux & macOS

## 1. Tools Overview

### 1.1 Linux ELF Tools
- **objdump** — binary analysis (GNU binutils)  
  ⚠ may not be installed on all systems — `readelf` recommended alternative.
- **ldd** — list dynamic dependencies  
  ⚠ can pose security risks when executed on untrusted binaries.
- **patchelf** — modify or inspect RPATH (Stella recipe `patchelf`)
- **scanelf** — ELF inspection (`pax-utils` package)
- **readelf** — read ELF structure and headers (GNU binutils package)

### 1.2 macOS Binary Tools
- **otool** — inspect Mach-O binaries
- **install_name_tool** — modify existing linked library paths, install names, and RPATH  
  ⚠ cannot add or remove dependencies; modification only.

### 1.3 macOS Linking References
install_name, rpath, loader_path, executable_path

- https://mikeash.com/pyblog/friday-qa-2009-11-06-linking-and-install-names.html
- http://jorgen.tjer.no/post/2014/05/20/dt-rpath-ld-and-at-rpath-dyld/
- https://wincent.com/wiki/@executable_path,_@load_path_and_@rpath

---

## 2. Linked Libraries Handling

### 2.1 macOS Dynamic Libraries
Starting macOS 11, system libraries are embedded in the **dyld shared cache** rather than stored as normal files.

**Cache locations**
/System/Library/dyld/dyld_shared_cache*
/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache*

**Exploration Tools**

* tool https://github.com/arandomdev/DyldExtractor (python)
dyldex -l -f /usr/lib/libz /System/.../dyld_shared_cache_x86_64h

* ipsw tool
ipsw dyld image /System/.../dyld_shared_cache_x86_64h /usr/lib/libz.1.dylib

**SDK static libraries**
xcrun --sdk macosx --show-sdk-path
# /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk

---

## 3. Search Order for Libraries at Runtime

### 3.1 Linux Runtime Search Order
1. DT_RPATH
   a list of directories which is harcoded into the executable, supported on most UNIX systems.
   The DT_RPATH entries are ignored if DT_RUNPATH entries exist. 
2. LD_LIBRARY_PATH
   an environment variable which holds a list of directories
3. DT_RUNPATH
  same as DT_RPATH, supported only on most recent UNIX systems, e.g. on most current Linux systems
1. /etc/ld.so.conf and /etc/ld.so.conf.d/*
2. /lib /usr/lib

### 3.2 macOS Equivalent

Uses `DYLD_LIBRARY_PATH` instead of `LD_LIBRARY_PATH`, but SIP ((Security Integrity Protection,since Macos 10.11) removes its value in many cases.

Example:
  * DYLD_LIBRARY_PATH=foo /bin/sh -c 'echo $DYLD_LIBRARY_PATH'
   * prints nothing because SIP strips it


* DYLD_LIBRARY_PATH=foo /bin/sh -c 'echo $DYLD_LIBRARY_PATH'
  * Print nothing

* Valid usage when using wrappers, shims (rbenv, asdf, ...) or binary from /bin or /usr/bin (like /bin/sh)

  * DYLD_LIBRARY_PATH cannot be exported but could be used like this : 
    * DYLD_LIBRARY_PATH="<path here>" <your command here or full path to executable>
    * DYLD_LIBRARY_PATH="/path/to/libs" ./executable


* see https://github.com/ros2/ros2/issues/409
* see https://github.com/rbenv/rbenv/issues/962


---

## 4. Library Search Order at Build Time

1. LIBRARY_PATH
    MACOS : Environment variable is also LIBRARY_PATH
2. gcc -L <path>
3. builtin linker paths

---

## 5. Loader vs Linker

| Role | Linux | macOS |
| Loader | ld.so / ld-linux.so / ld-musl.so | dyld |
| Linker | ld | ld64 |

---

## 6. Debugging

### Linux
LD_TRACE_LOADED_OBJECTS=1 LD_DEBUG=libs ./program
LD_DEBUG values http://www.bnikolic.co.uk/blog/linux-ld-debug.html

### macOS
DYLD_PRINT_LIBRARIES=1 DYLD_PRINT_SEARCHING=1 ./program
DYLD_PRINT_LIBRARIES=1 : print loaded libraries
DYLD_PRINT_SEARCHING=1 : print search libraries result 

---

## 7. RPATH Handling on Linux (`patchelf`)
- using patchelf  "--set-rpath", "--shrink-rpath" and "--print-rpat"h now prefer DT_RUNPATH over DT_RPATH, 
- If both DT_RPATH and DT_RUNPATH exist → update both
- If only DT_RPATH exists → convert to DT_RUNPATH unless `--force-rpath`
- If none exist → create DT_RUNPATH unless --force-rpath is specified, in which case a DT_RPATH is added."


which is obsolete. When updating, if both are present, both are updated.
---

## 8. Useful Tools & References

### Tools
- https://github.com/gentoo/pax-utils
- https://github.com/ncopa/lddtree

### Articles
- http://blog.tremily.us/posts/rpath/
- https://bbs.archlinux.org/viewtopic.php?id=6460
- http://www.cyberciti.biz/tips/linux-shared-library-management.html
- http://www.kaizou.org/2015/01/linux-libraries/
- https://stackoverflow.com/a/4250666/5027535
