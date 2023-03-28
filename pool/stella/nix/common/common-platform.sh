#!sh
if [ ! "$_STELLA_PLATFORM_INCLUDED_" = "1" ]; then
_STELLA_PLATFORM_INCLUDED_=1

# NOTE :
#			This file contains specific code depending on the system


# DISTRIB/OS/PLATFORM INFO ---------------------------

# NOTE :
# classification :
# 	platform <--- os <---- distrib
# 		example :
#			linux <----- ubuntu <---- ubuntu 14.04
#			linux <----- centos <---- centos 6
#			windows <--- windows <---- windows 7
# suffix platform :
# 	each platform have a suffix
#		example :
#			windows <---> win
#			linux <---> linux

__get_os_from_distro() {
	local _distro=$1

	case $_distro in
		"Red Hat Enterprise Linux")
			echo "rhel"
			;;
		Ubuntu|ubuntu*)
			echo "ubuntu"
			;;
		Debian|debian*)
			echo "debian"
			;;
		CentOS*|centos*)
			echo "centos"
			;;
		archlinux*)
			echo "archlinux"
			;;
		boot2docker*)
			echo "linuxgeneric"
			;;
		Alpine*|alpine*)
			echo "alpine"
			;;
		"Mac OS X"|macos)
			echo "macos"
			;;
		*Windows*|*windows*)
			echo "windows"
			;;
		*)
			echo "linuxgeneric"
			;;
	esac
}





__get_platform_from_os() {
	local _os=$1

	case $_os in
		centos|archlinux|ubuntu|debian|linuxgeneric|rhel|alpine)
			echo "linux"
			;;
		macos)
			echo "darwin"
			;;
		windows)
			echo "windows"
			;;
		*)
			echo "unknown"
			;;
	esac
}

__get_platform_suffix() {
	local _platform=$1

	case $_platform in
		linux)
			echo "linux"
			;;
		darwin)
			echo "darwin"
			;;
		windows)
			echo "win"
			;;
		*)
			echo "unknown"
			;;
	esac
}


__get_os_env_from_kernel() {
	local _kernel=$1

	case $kernel in
		*MINGW64*)
			echo "msys2-mingw64"
			;;
		*MINGW32*)
			echo "msys2-mingw32"
			;;
		*MSYS*)
			echo "msys2"
			;;
		*CYGWIN*)
			echo "cygwin"
			;;
	esac
}

__set_current_platform_info() {


	
	
	# some old configurations forgive to set sbin folders as PATH values
	# mainly on centos
	# https://forums.centos.org/viewtopic.php?t=53983
	PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"

	# call screenFetch once by setting/unsetting  exit function and sourcing screenfetch
	# https://github.com/KittyKatt/screenFetch
	exit() {
	:
	}
	. $STELLA_ARTEFACT/screenFetch/screenfetch-dev -n -E 1>/dev/null 2>&1
	unset exit


	STELLA_CURRENT_OS=$(__get_os_from_distro "$distro")
	STELLA_CURRENT_OS_ENV=$(__get_os_env_from_kernel "$kernel")
	STELLA_CURRENT_PLATFORM=$(__get_platform_from_os "$STELLA_CURRENT_OS")
	STELLA_CURRENT_PLATFORM_SUFFIX=$(__get_platform_suffix "$STELLA_CURRENT_PLATFORM")


	if type nproc &>/dev/null; then
		STELLA_NB_CPU=$(nproc)
	elif type sysctl &>/dev/null; then
		STELLA_NB_CPU=`sysctl hw.ncpu 2> /dev/null | awk '{print $NF}'`
	else
		STELLA_NB_CPU=1
	fi


	# http://stackoverflow.com/questions/246007/how-to-determine-whether-a-given-linux-is-32-bit-or-64-bit
	# http://stackoverflow.com/a/10140985
	# http://unix.stackexchange.com/a/24772
	# http://www.cyberciti.biz/faq/linux-how-to-find-if-processor-is-64-bit-or-not/
	# https://www.sysadmit.com/2016/02/linux-como-saber-si-es-32-o-64-bits.html
	# https://superuser.com/questions/208301/linux-command-to-return-number-of-bits-32-or-64/208306#208306

	# CPU 64Bits capable
	STELLA_CPU_ARCH=
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		grep -q -o -w 'lm' /proc/cpuinfo && STELLA_CPU_ARCH=64 || echo STELLA_CPU_ARCH=32
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		local _cpu=`sysctl hw.cpu64bit_capable | egrep -i 'hw.cpu64bit_capable' | awk '{print $NF}'`
		STELLA_CPU_ARCH=32
		[ "$_cpu" = "1" ] && STELLA_CPU_ARCH=64
	fi

	#  Note that on several architectures, a 64-bit kernel can run 32-bit userland programs,
	#  so even if the uname -m shows a 64-bit kernel, there is no guarantee that 64-bit libraries will be available.
	if [ "$(uname -m | grep 64)" = "" ]; then
		STELLA_KERNEL_ARCH=32
	else
		STELLA_KERNEL_ARCH=64
	fi

	# The getconf LONG_BIT get the default bit size of the C library
	STELLA_C_ARCH=$(getconf LONG_BIT)
	STELLA_USERSPACE_ARCH=unknown

	__get_network_info

	__platform_specifity
	

}


__get_macos_version() {
	#echo $(sw_vers -productVersion)
	echo $(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}')
}


__platform_specifity() {
	#http://unix.stackexchange.com/questions/30091/fix-or-alternative-for-mktemp-in-os-x
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		function mktmp() {
			local tempfile=$(mktemp -t stella)
	    	echo "$tempfile"
		}
		function mktmpdir(){
			local tempdir=$(mktemp -d -t stella)
	    	echo "$tempdir"
		}
	else
		function mktmp() {
			local tempfile=$(mktemp)
	    	echo "$tempfile"
		}
		function mktmpdir() {
			local tempdir=$(mktemp -d)
	    	echo "$tempdir"
		}
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		STELLA_ARGPARSE_GETOPT_DEFAULT="PURE_BASH"
	else
		STELLA_ARGPARSE_GETOPT_DEFAULT="getopt"
	fi


}


# REQUIREMENTS STELLA -------------
__ask_install_requirements() {
	echo "Do you wish to auto-install requirements for stella (may ask for sudo password)?"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes )
				__stella_requirement
				break;;
	        No ) break;;
	    esac
	done
}


# TODO
__stella_requirement() {
	case $STELLA_CURRENT_OS in
		*);;
	esac
}



# REQUIRE -------------------------
# require a specific binary.
# By default the required binary is MANDATORY
# Test if binary is present, if not :
#		if binary is OPTIONAL, just print warn and guidelines to install it as a STELLA_FEATURE or as a package SYSTEM
#		if binary is not OPTIONAL, it will install it as a STELLA_FEATURE or provide guideline to install it as a package SYSTEM
__require() {
	local _artefact="$1" # binary to test
	local _id="$2" # feature name (for stella) or sys name (for package manager)
	local _OPT="$3"

	local _result=0

	# OPTIONAL
	# SYSTEM
	# STELLA_FEATURE
	local _opt_optional=OFF
	local _opt_system=OFF
	local _opt_stella_feature=ON


	for o in $_OPT; do
		[ "$o" = "OPTIONAL" ] && _opt_optional=ON
		[ "$o" = "SYSTEM" ] && _opt_system=ON && _opt_stella_feature=OFF && _opt_stella_toolset=OFF
		[ "$o" = "STELLA_FEATURE" ] && _opt_system=OFF && _opt_stella_feature=ON && _opt_stella_toolset=OFF
	done

	echo "** REQUIRE $_id ($_artefact)"
	local _err=
	type $_artefact &>/dev/null || _err=1

	if [ "$_err" = "1" ]; then
		if [ "$_opt_optional" = "ON" ]; then
			if [ "$_opt_system" = "ON" ]; then
				echo "** WARN -- You should install $_artefact -- Try stella.sh sys install $_id OR your regular OS package manager"
			else
				if [ "$_opt_stella_feature" = "ON" ]; then
					echo "** WARN -- You should install $_artefact -- Try stella.sh feature install $_id"
				else
					if [ "$_opt_stella_toolset" = "ON" ]; then
						# TODO optionnal toolset ? it shoud not exist -- CHANGE warn message
						echo "** WARN -- You should install $_artefact -- Try stella.sh toolset install $_id"
					else
						echo "** WARN -- You should install $_artefact"
						echo "-- For a system install : try stella.sh sys install $_id OR your regular OS package manager"
						echo "-- For an install from Stella : try stella.sh feature install $_id"
					fi
				fi
			fi
		else
			if [ "$_opt_system" = "ON" ]; then
				echo "** ERROR -- Please install $_artefact"
				echo "** Try stella.sh sys install $_id OR your regular OS package manager"
				_result=1
				exit 1
			else
				if [ "$_opt_stella_feature" = "ON" ]; then
					echo "** REQUIRE $_id : installing it from stella"
					(__feature_install "$_id" "NON_DECLARED")
					__feature_init "$_id" "NON_DECLARED"
				else
					echo "** ERROR -- Please install $_artefact"
					echo "-- For a system install : try stella.sh sys install $_id OR your regular OS package manager"
					echo "-- For an install as a stella feature : try stella.sh feature install $_id"
					_result=1
					exit 1
				fi
			fi
		fi
	fi

	return $_result
}

# TOOLSET specific --------------------------------------------------------

# http://stackoverflow.com/questions/5188267/checking-the-gcc-version-in-a-makefile
# return X.Y.Z as version of current gcc
# ex : 4.4.7
__gcc_version() {
	gcc -dumpversion
}

# return an int representation of current gcc version
# ex : 40407
__gcc_version_int() {
	gcc -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$/&00/'
}

# check if current gcc version hit the minimal version required
# first param : X_Y_Z (or X_Y)
# return 1 if required minimal version is fullfilled by the current gcc version
__gcc_check_min_version() {
	local _required_ver=$1
	expr $(__gcc_version_int) \>= $(echo $_required_ver | sed -e 's/_\([0-9][0-9]\)/\1/g' -e 's/_\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$/&00/')
}

# detect if current gcc binary is in fact clang (mainly for MacOS)
# return 1 if gcc is clang
__gcc_is_clang() {
	if [ "$(echo | gcc -dM -E - | grep __clang__)" = "" ]; then
		echo "0"
	else
		echo "1"
	fi
}


# return the target triplet
#			Name of CPU family/model (eg. x86_64)
#			The vendor (eg. linux)
#			Operating system name (eg. gnu)
__default_target_triplet() {
	gcc -dumpmachine
}


# LIBRARIES SEARCH PATH -------
# https://stackoverflow.com/questions/9922949/how-to-print-the-ldlinker-search-path


# SEARCH PATH AT RUNTIME - WHILE RUNNING PROGRAM override with LD_LIBRARY_PATH enn var

# dynamic libraries search path at runtime
# https://github.com/StudioEtrange/lddtree/blob/579ebe449b76ed9d22f116a6f30b87b1f2ded2ca/lddtree.sh#L169
__default_runtime_search_path() {
	local c_ldso_paths=
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then

		if [ -r /etc/ld.so.conf ] ; then
			read_ldso_conf() {
				local line p
				for p ; do
					# if the glob didnt match anything #360041,
					# or the files arent readable, skip it
					[ -r "${p}" ] || continue
					while read line ; do
						case ${line} in
							"#"*) ;;
							"include "*) read_ldso_conf ${line#* } ;;
							*) c_ldso_paths="$c_ldso_paths:/${line#/}";;
						esac
					done <"${p}"
				done
			}
			# the 'include' command is relative
			local _oldpwd="$PWD"
			cd "/etc" >/dev/null
			interp=$(__get_elf_interpreter_linux "$(which ls)")
			echo $interp
			case "$interp" in
			*/ld-musl-*)
				musl_arch=${interp%.so*}
				musl_arch=${musl_arch##*-}
				read_ldso_conf /etc/ld-musl-${musl_arch}.path
				;;
			*/ld-linux*|*/ld.so*) # glibc
				read_ldso_conf /etc/ld.so.conf
				;;
			esac
			cd "$_oldpwd"
		fi
	fi
	echo "${c_ldso_paths}"
}


# SEARCH PATH AT LINKING - WHILE BUILDING override with LIBRARY_PATH enn var

# linker search path
# library search path during linking
# arch : x64|x86
#				if empty the default system current arch will be used
# LINUX https://stackoverflow.com/questions/9922949/how-to-print-the-ldlinker-search-path
# NOTE ON MACOS :
#			 https://opensource.apple.com/source/dyld/dyld-519.2.1/src/dyld.cpp.auto.html
#			 hardcoded values https://opensource.apple.com/source/dyld/dyld-519.2.1/src/dyld.cpp.auto.html
#												can be checked with : gcc  -Xlinker -v
__default_linker_search_path() {
	local __arch="$1"
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		[ "$__arch" = "x64" ] && $__arch="-m64"
		[ "$__arch" = "x86" ] && $__arch="-m32"
		gcc $__arch -Xlinker --verbose  2>/dev/null | grep SEARCH | sed 's/SEARCH_DIR("=\?\([^"]\+\)"); */\1\n/g'  | grep -vE '^$'
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		echo "/usr/local/lib:/usr/lib"
	fi
}


# gcc hardcoded libraries search path when linking
# gcc passes a few extra -L paths to the linker, which you can list with the following command:
# https://stackoverflow.com/a/21610523/5027535
__gcc_linker_search_path() {
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		gcc -print-search-dirs | sed '/^lib/b 1;d;:1;s,/[^/.][^/]*/\.\./,/,;t 1;s,:[^=]*=,:;,;s,;,;  ,g' | tr \; \\012
	fi
}

# library search path during linking (-L flag) 
# NOT AT RUNTIME ==> parse ld.so.conf to see search path at runtime
# see __default_linker_search_path
# ld not used on macos
# https://stackoverflow.com/a/21610523/5027535
__ld_linker_search_path() {
	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		ld --verbose 2>/dev/null | grep SEARCH | sed 's/SEARCH_DIR("=\?\([^"]\+\)"); */\1\n/g'  | grep -vE '^$'
	fi
}

# pkg-config full search path
# https://linux.die.net/man/1/pkg-config
__pkgconfig_search_path() {
	if $(type pkg-config &>/dev/null); then
		echo ${PKG_CONFIG_PATH}:$(pkg-config --variable pc_path pkg-config)
	fi
}

# NOTE apple-clang-llvm versions are not synchronized with clang-llvm versions
__clang_version() {
	clang --version | head -n 1 | grep -o -E "[[:digit:]].[[:digit:]].[[:digit:]]" | head -1
}

# RUNTIME specific --------------------------------------------------------

# PYTHON VERSION
# get python version on 1 digits (2, 3, ...)
__python_major_version() {
	# 2
	python -c 'import sys;print(str(sys.version_info.major));'
}

# get python version on 2 digits (2.7, 3.4, ...)
__python_short_version() {
	# 2.7
	python -c 'import sys;print(str(sys.version_info.major) + "." + str(sys.version_info.minor));'
}


# PYTHON PACKAGE INSTALL PATH
# get python global site-packages path
# https://stackoverflow.com/a/46071447
__python_get_site_packages_global_path() {
	# /Library/Python/2.7/site-packages
	python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"
}

# get python current user	site-packages path
# https://stackoverflow.com/a/46071447
__python_get_site_packages_user_path() {
	# /Library/Python/2.7/site-packages
	python -m site --user-site
}

# get standard python libraries install dir
__python_get_standard_packages_path() {
	# /Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7
	python -c 'import sysconfig;print(sysconfig.get_path("stdlib"));'
}



# LIBRARIES INSTALL DIRECTORIES inside python
# get library install dir within python environment
__python_get_lib_dir() {
		python -c 'import sysconfig;print(sysconfig.get_config_var("LIBDIR"));'
}
# get include install dir within python environment
__python_get_include_dir() {
		python -c 'import sysconfig;print(sysconfig.get_config_var("INCLUDEDIR"));'
}
# get binary install dir within python environment
__python_get_bin_dir() {
		python -c 'import sysconfig;print(sysconfig.get_config_var("BINDIR"));'
}


# BUILD USE CASE
# python build functions using python-config for build use case
# python-config : output  build  options for python C/C++ extensions or embedding
# http://manpages.ubuntu.com/manpages/xenial/en/man1/i386-linux-gnu-python2.7-config.1.html
__python_build_get_libs() {
	# -lpython2.7 -ldl -framework CoreFoundation
	python$(__python_short_version)-config --libs
}
__python_build_get_ldflags() {
	#-L/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/config -lpython2.7 -ldl -framework CoreFoundation
	python$(__python_short_version)-config --ldflags
}
__python_build_get_clags() {
	#-I/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -I/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -fno-strict-aliasing -fno-common -dynamic -arch i386 -arch x86_64 -g -DNDEBUG -g -fwrapv -O3 -Wall -Wstrict-prototypes
	python$(__python_short_version)-config --cflags
}
__python_build_get_prefix() {
	# /Library/Frameworks/Python.framework/Versions/2.7
	python$(__python_short_version)-config --prefix
}
__python_build_get_includes() {
	#-I/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7 -I/Library/Frameworks/Python.framework/Versions/2.7/include/python2.7
	python$(__python_short_version)-config --includes
}

# VARIOUS
# retrieve current pyconfig.h
__python_get_pyconfig() {
	# /Library/Frameworks/Python.framework/Versions/2.7/include/python2.7/pyconfig.h
	python -c 'import sysconfig;print(sysconfig.get_config_h_filename());'
}



# PACKAGE SYSTEM ----------------------------
# set a global proxy for yum
# sample : __yum_proxy_set $STELLA_HTTP_PROXY
__yum_proxy_set() {
	local _uri="$1"

	__yum_proxy_unset

	__log "INFO" " * Set yum HTTP proxy with $_uri"

	[ ! -f "/etc/yum.conf" ] && echo [main] | sudo -E tee /etc/yum.conf > /dev/null
	echo proxy=${_uri} | sudo -E tee -a /etc/yum.conf > /dev/null
}

# unset global proxy for yum
__yum_proxy_unset() {
	__log "INFO" " * Unset any yum HTTP proxy"

	[ -f "/etc/yum.conf" ] && sudo sed -i '/proxy=/d' /etc/yum.conf > /dev/null
}

# set a proxy only for a soecific repo
# __yum_proxy_set_repo "epel" "$STELLA_HTTP_PROXY"
__yum_proxy_set_repo() {
	local _repo_name="$1"
	local _uri="$2"

	[ "${_uri}" = "" ] && _uri="_none_"

	__log "INFO" " * Set yum HTTP proxy with $_uri for repo ${_repo_name}"

	__sudo_exec yum-config-manager --setopt=${_repo_name}.proxy=${_uri} --save
}

# unset proxy only for a soecific repo
# __yum_proxy_set_repo "epel" "$STELLA_HTTP_PROXY"
__yum_proxy_unset_repo() {
	local _repo_name="$1"
	__log "INFO" " * Unset yum HTTP proxy for repo ${_repo_name}"

	__sudo_exec yum-config-manager --setopt=${_repo_name}.proxy=_none_ --save
}


# add epel
# _version could be 6 or 7 (for RHEL/Centos 6.x or 7.x)
__yum_add_extra_repositories() {
	local _version="$1"

	__log "INFO" "Set some yum repositories into current OS ($STELLA_CURRENT_OS)"

	[ ! "$_version" = "6" ] && [ ! "$_version" = "7" ] && return

	# TODO : there yum repositories use a mirroring system, and it do not work every time. Beside EPEL repositories is enough
	# TODO : remove centos-7-base.repo from pool folder
	# http://redhat-centos.blogspot.fr/2013/06/configuring-centos-base-repo-for-redhat.html
	#__log "INFO" "** Set base repositories of Centos"
	#__sudo_exec cp -f "$STELLA_ARTEFACT/centos-repo/centos-${_version}-base.repo" /etc/yum.repos.d/
	#__get_resource "gpg key" "http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-${_version}" "HTTP" "$STELLA_APP_WORK_ROOT" "FORCE_NAME RPM-GPG-KEY-CentOS-${_version}"
	#__sudo_exec cp -f "$STELLA_APP_WORK_ROOT/RPM-GPG-KEY-CentOS-${_version}" /etc/pki/rpm-gpg/

	# http://www.rackspace.com/knowledge_center/article/install-epel-and-additional-repositories-on-centos-and-red-hat
	__log "INFO" "** Add EPEL repositories"
	__get_resource "epel" "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${_version}.noarch.rpm" "HTTP" "$STELLA_APP_WORK_ROOT" "FORCE_NAME epel-release-latest-${_version}.noarch.rpm"
	__sudo_exec rpm -Uvh "$STELLA_APP_WORK_ROOT/epel-release-latest-${_version}.noarch.rpm"

	__yum_proxy_set_repo "epel" "${STELLA_HTTP_PROXY}"
	__sudo_exec yum-config-manager --enable epel
	__sudo_exec yum clean all
}


__yum_remove_extra_repositories() {
	__log "INFO" "** Disable EPEL repositories"

	__sudo_exec yum-config-manager --disable epel
	__sudo_exec yum clean all
}



__get_current_package_manager() {
	local _package_manager=

	local p=
	local plist=

	case $STELLA_CURRENT_PLATFORM in
		linux)
				plist="apt-get yum apk"
			;;
		darwin)
				plist="brew"
			;;
	esac

	for p in $plist; do
		if [[ -n `which $p 2> /dev/null` ]]; then
			_package_manager="$p"
			break
		fi
	done

	echo "$_package_manager"
}




# use a package manager
# arg _package_manager is optionnal - if not set, try to autodetect
__use_package_manager() {
	# INSTALL or REMOVE
	local _action="$1"
	local _id="$2"
	local _packages_list="$3"
	local _package_manager="$4"

	echo " ** $_action $_id on your system"

	if [ "$_package_manager" = "" ]; then
		_package_manager="$(__get_current_package_manager)"
	fi

	echo " ** use $_package_manager as package manager"

	local _flag_package_manager=OFF
	local _packages=
	for o in $_packages_list; do
		[ "$o" = "|" ] && _flag_package_manager=OFF
		[ "$_flag_package_manager" = "ON" ] && _packages="${_packages} $o"
		# NOTE : exception here for "brew-cask", because the package manager name is always just "brew"
		[ "$o" = "$_package_manager"-cask ] && _flag_package_manager=ON && _package_manager="brew-cask"
		[ "$o" = "$_package_manager" ] && _flag_package_manager=ON
	done

	[ "${_packages}" = "" ] && echo " ** WARN : we do not find any configured package for $_id with $_package_manager"

	if [ "$_action" = "INSTALL" ]; then
		case $_package_manager in
			apt-get)
				__sudo_exec apt-get update
				__sudo_exec apt-get -y install ${_packages}
				;;
			brew)
				brew install ${_packages}
				;;
			brew-cask)
				brew cask install ${_packages}
				;;
			yum)
				__sudo_exec yum install -y ${_packages}
				;;
			apk)
				__sudo_exec apk update
				__sudo_exec apk add ${_packages}
				;;
			*)	echo " ** WARN : dont know how to install $_id"
				;;
		esac
	fi
	if [ "$_action" = "REMOVE" ]; then
		case $_package_manager in
			apt-get)
				__sudo_exec apt-get update
				__sudo_exec apt-get -y autoremove --purge ${_packages}
				;;
			brew)
				brew uninstall ${_packages}
				;;
			brew-cask)
				brew cask uninstall ${_packages}
				;;
			yum)
				__sudo_exec yum remove -y ${_packages}
				;;
			apk)
				__sudo_exec apk del ${_packages}
				;;
			*)	echo " ** WARN : dont know how to remove $_id"
				;;
		esac
	fi

}
# ----------- ANSIBLE -----------------------------------------------------


# ARG1 playbook yml file
# ARG2 roles root folder
# ARG3 inventory file
# OPTION
#	LIMIT restrict execution to some host
#	TAGS execute tasks tagged by one of these tags, separated by comma
#	PYTHON path to python interpreter
#	DEBUG enable more debug output
__ansible_play() {
	local __playbook="$1"
	local __roles="$2"
	local __inventory_file="$3"
	local __opt="$4"

	local __limit=
	local __tags=
	local __python=
	local __debug="-v"
	for o in ${__opt}; do
		[ "$__limit" = "1" ] && __limit="--limit=$o"
		[ "$o" = "LIMIT" ] && __limit="1"
		[ "$__tags" = "1" ] && __tags="--tags=$o"
		[ "$o" = "TAGS" ] && __tags="1"
		[ "$__python" = "1" ] && __python="-e ansible_python_interpreter=$o"
		[ "$o" = "PYTHON" ] && __python="1"
		[ "$o" = "DEBUG" ] && __debug="-vvv"
	done
	
	[ -z $__limit ] && __limit=all

	ANSIBLE_ROLES_PATH="$__roles" PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook --inventory-file="$__inventory_file" $__limit $__debug "$__playbook" $__tags $__python
}

# ARG1 playbook yml file
# ARG2 roles root folder
# OPTION
#	TAGS execute tasks tagged by one of these tags, separated by comma
#	PYTHON path to python interpreter (by default use python found in PATH)
__ansible_play_localhost() {
	local __playbook="$1"
	local __roles="$2"
	local __opt="$3"

	local __tags=
	local __python="-e ansible_python_interpreter=$(which python)"
	local __debug="-v"
	for o in ${__opt}; do
		[ "$__tags" = "1" ] && __tags="--tags=$o"
		[ "$o" = "TAGS" ] && __tags="1"
		[ "$__python" = "1" ] && __python="-e ansible_python_interpreter=$o"
		[ "$o" = "PYTHON" ] && __python="1"
		[ "$o" = "DEBUG" ] && __debug="-vvv"
	done

	# https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-at-runtime
	# --extra-vars "version=1.23.45 other_variable=foo"
	# --extra-vars '{"version":"1.23.45","other_variable":"foo"}'
	# ansible-playbook arcade.yml --extra-vars "{\"name\":\"Conan O\'Brien\"}"
	# ansible-playbook arcade.yml --extra-vars '{"name":"Conan O'\\\''Brien"}'
	# ansible-playbook script.yml --extra-vars "{\"dialog\":\"He said \\\"I just can\'t get enough of those single and double-quotes"\!"\\\"\"}"
	# EXTRA_VARS=\{\"infra_name\":\"$INFRA_NAME\",\"proxy_name\":\"sesame\"\}
	#--extra-vars=$EXTRA_VARS

	# use same python interpreter than the one which launch ansible
	# by default, ansible will lookup python in some default place like /usr/bin/python not in PATH
	# https://github.com/ansible/ansible/issues/6345
	ANSIBLE_ROLES_PATH="$__roles" PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook --connection local --inventory 'localhost,' $__debug "$__playbook" $__tags $__python


}

#
# __ansible_play_vagrant() {
#   INFRA_NAME="$1"
#   PLAYBOOK="$2"
#   LIMIT="$3"
#   [ -z $LIMIT ] && LIMIT=all
#
#   ANSIBLE_INVENTORY_FILE=$STELLA_APP_ROOT/infra/$INFRA_NAME/.vagrant/provisioners/ansible/inventory
#   ANSIBLE_PLAYBOOK=$STELLA_APP_ROOT/infra/playbook/$PLAYBOOK.yml
#
#   ANSIBLE_EXTRA_VARS=\{\"infra_name\":\"$INFRA_NAME\",\"proxy_name\":\"sesame\"\}
#   ANSIBLE_ROLES_PATH=$STELLA_APP_ROOT/infra/roles PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --connection=ssh --timeout=30 --inventory-file=$ANSIBLE_INVENTORY_FILE --limit=$LIMIT --extra-vars=$ANSIBLE_EXTRA_VARS -v $ANSIBLE_PLAYBOOK
# }


# --------- SYSTEM INSTALL/REMOVE RECIPES------------------------------------
__sys_install() {
	# _item package name
	# other args : optionnal arguments
	local _item=$1
	shift
	__sys_install_$_item $@
}

__sys_remove() {
	__sys_remove_$1
}

__sys_install_docker() {
	# NOTE install with ansible : https://medium.com/@tedchength/installing-docker-using-ansible-script-c182787f2fa1
	# NOTE install specific version : https://forums.docker.com/t/how-can-i-install-a-specific-version-of-the-docker-engine/1993/6
	#																	http://www.hashjoin.com/t/upgrade-docker-engine-specific-version.html
	#																	https://github.com/StudioEtrange/install-docker
	# NOTE dockerd service is not always auto started
	#					sudo systemctl enable docker
	#					sudo systemctl start docker
	local _version=$1
	echo " ** Install Docker $_version on your system"
	if [ "$STELLA_CURRENT_OS" = "macos" ]; then
		echo "ERROR : Docker is not directly available on macos"
		return
	fi

	echo "WARN : it may modify your system config and ask you sudo/root access"
	__download "https://get.docker.com" "docker-install.sh" "$STELLA_APP_TEMP_DIR"
	chmod +x "$STELLA_APP_TEMP_DIR"/docker-install.sh
	"$STELLA_APP_TEMP_DIR"/docker-install.sh

	# override last default version
	if [ ! -z "$_version" ]; then
		__use_package_manager "INSTALL" "docker" "apt-get docker-ce=$_version | yum docker-ce-$_version"
	fi

	echo "NOTE : you should add a user to docker group, to use docker without sudo"
	echo "			sudo usermod -aG docker USER"
}


# NOTE: The following new directories will be created:
# /usr/local/etc
# /usr/local/sbin
# /usr/local/var
# /usr/local/opt
# /usr/local/var/homebrew
# /usr/local/var/homebrew/linked
# /usr/local/Cellar
# /usr/local/Caskroom
# /usr/local/Homebrew
# /usr/local/Frameworks
__sys_install_brew() {
	echo " ** Install Homebrew on your system"
	echo " ** As of December 2015, Cask comes installed with Homebrew"

	__download "https://raw.githubusercontent.com/Homebrew/install/master/install" "brew-install.rb" "$STELLA_APP_TEMP_DIR"

	ruby "$STELLA_APP_TEMP_DIR/brew-install.rb"
	rm -f "$STELLA_APP_CACHE_DIR/brew-install.rb"


	echo " ** Check Homebrew"
	if [[ -n `which brew 2> /dev/null` ]]; then
		echo " ** brew doctor"
		brew doctor
		local _brewLocation=`which brew`
		local _appLocation=`brew --prefix`
		echo " ** -------------- **"
		echo "Homebrew is installed in $_brewLocation"
		echo "Homebrew apps are run from $_appLocation"

	else
		echo " ** Error while installing Homebrew"
	fi
}
__sys_remove_brew() {
	echo " ** Remove Homebrew from your system"

	rm -rf /usr/local/Cellar /usr/local/.git 2>/dev/null
	brew cleanup 2>/dev/null

	__download "https://raw.githubusercontent.com/Homebrew/install/master/uninstall" "brew-uninstall.rb" "$STELLA_APP_TEMP_DIR"

	ruby "$STELLA_APP_TEMP_DIR/brew-uninstall.rb"
	rm -f "$STELLA_APP_CACHE_DIR/brew-uninstall.rb"
}


__sys_install_build-chain-standard() {
	local _package_manager=

	if [ "$STELLA_CURRENT_OS" = "macos" ]; then
		echo " ** Install build-chain-standard on your system"
		# from https://github.com/lockfale/msf-installer/blob/master/msf_install.sh
		# http://docs.python-guide.org/en/latest/starting/install/osx/
		local PKGS=`pkgutil --pkgs`
		if [[ $PKGS =~ com.apple.pkg.Xcode ]]; then
			echo " ** Xcode detected"
		else
			echo " ** WARN Xcode not detected."
			echo " It is NOT mandatory but you may want to install it from the Apple AppStore"
			echo " or download it from https://developer.apple.com/downloads."
			# difference between appstore and download site
			# http://apple.stackexchange.com/questions/62201/download-xcode-from-developer-site-vs-install-from-app-store

			# TODO make a separate script to install xcode
			# http://stackoverflow.com/questions/4081568/downloading-xcode-with-wget-or-curl
		fi
		if [[ $PKGS =~ com.apple.pkg.DeveloperToolsCLI || $PKGS =~ com.apple.pkg.CLTools_Executables ]]; then
			echo " ** Command Line Development Tools is already intalled"
		else
			echo " ** WARN Command Line Development Tools not intalled. See https://developer.apple.com/downloads"
			xcode-select --install
		fi

	else
		#bison util-linux build-essential gcc-multilib g++-multilib g++ pkg-config
		__use_package_manager "INSTALL" "build-chain-standard" "apt-get build-essential gcc-multilib g++-multilib | yum gcc gcc-c++ make kernel-devel | apk gcc g++ make"
	fi
}
__sys_remove_build-chain-standard() {
	if [ "$STELLA_CURRENT_OS" = "macos" ]; then
		echo " ** Remove Xcode and Command Line Development Tools by hand"
	else
		__use_package_manager "REMOVE" "build-chain-standard" "apt-get build-essential gcc-multilib g++-multilib | yum gcc gcc-c++ make kernel-devel | apk gcc g++ make"
	fi
}


# recipes using system package manager ------------------
__sys_install_x11() {
	__use_package_manager "INSTALL" "x11" "brew-cask xquartz"
}
__sys_remove_x11() {
	__use_package_manager "REMOVE" "x11" "brew-cask xquartz"
}

__sys_install_sevenzip() {
	__use_package_manager "INSTALL" "7z" "apt-get p7zip-full | brew p7zip | yum p7zip | apk p7zip"
}
__sys_remove_sevenzip() {
	__use_package_manager "REMOVE" "7z" "apt-get p7zip-full | brew p7zip | yum p7zip | apk p7zip"
}

__sys_install_curl() {
	__use_package_manager "INSTALL" "curl" "apt-get curl | brew curl | yum curl | apk curl"
}
__sys_remove_curl() {
	__use_package_manager "REMOVE" "curl" "apt-get curl | brew curl | yum curl | apk curl"
}

__sys_install_wget() {
	__use_package_manager "INSTALL" "wget" "apt-get wget | brew wget | yum wget | apk get"
}
__sys_remove_wget() {
	__use_package_manager "REMOVE" "wget" "apt-get wget | brew wget | yum wget | apk get"
}

__sys_install_unzip() {
	__use_package_manager "INSTALL" "unzip" "apt-get unzip | brew unzip | yum unzip"
}
__sys_remove_unzip() {
	__use_package_manager "REMOVE" "unzip" "apt-get unzip | brew unzip | yum unzip"
}

__sys_install_cmake() {
	__use_package_manager "INSTALL" "cmake" "apt-get cmake | brew cmake | yum cmake | apk cmake"
}
__sys_remove_cmake() {
	__use_package_manager "REMOVE" "cmake" "apt-get cmake | brew cmake | yum cmake | apk cmake"
}

__sys_install_git() {
	__use_package_manager "INSTALL" "git" "apt-get git | brew git | yum git | apk git"
}
__sys_remove_git() {
	__use_package_manager "REMOVE" "git" "apt-get git | brew git | yum git | apk git"
}


fi
