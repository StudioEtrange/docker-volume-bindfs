#!/usr/bin/env bash
# Usage :
# stella-bridge.sh standalone [install path] --- Path where to install STELLA the system. If not provided use ./stella by default
# stella-bridge.sh bootstrap [install path] --- boostrap a project based on stella. Provide an absolute or relative to app path where to install STELLA the system. If not provided, use setted value in link file (.-stella-link.sh) or in ./stella by default
#										after installing stella, it will set the project for use stella (if not already done)


__STELLA_URL="http://stella.sh"



#_STELLA_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "${STELLA_CURRENT_RUNNING_DIR}" = "" ]; then
     STELLA_CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"
fi


# Install stella in standalone ------------------
standalone() {

	[ "${PROVIDED_PATH}" = "" ] && PROVIDED_PATH="${STELLA_CURRENT_RUNNING_DIR}/stella"

	_STELLA_INSTALL_PATH="$(___rel_to_abs_path "${PROVIDED_PATH}" "${STELLA_CURRENT_RUNNING_DIR}")"

	if [ ! -f "${_STELLA_INSTALL_PATH}/stella.sh" ]; then
		__get_stella "${_STELLA_INSTALL_PATH}" "STABLE" "LATEST"
	fi

	. "${_STELLA_INSTALL_PATH}/conf.sh"
	__ask_install_requirements
}


# Bootstrap a stella project ------------------
bootstrap() {

	IS_STELLA_LINK_FILE="FALSE"
	IS_STELLA_LINKED="FALSE"
	STELLA_ROOT=

	IS_STELLA_JUST_INSTALLED="FALSE"

	[ "${PROVIDED_PATH}" = "" ] && PROVIDED_PATH="${STELLA_CURRENT_RUNNING_DIR}/stella"


	# Check if APP/PROJECT in current dir is linked to STELLA
	if [ -f "${STELLA_CURRENT_RUNNING_DIR}/stella-link.sh" ]; then
		IS_STELLA_LINK_FILE="TRUE"
		. "${STELLA_CURRENT_RUNNING_DIR}/stella-link.sh" nothing
		if [ ! "${STELLA_ROOT}" = "" ]; then
			if [ -f "${STELLA_ROOT}/stella.sh" ]; then
				IS_STELLA_LINKED="TRUE"
			fi
		fi
	fi

	if [ "${IS_STELLA_LINKED}" = "TRUE" ]; then
		echo "** This app/project is linked to a STELLA installation located in $STELLA_ROOT"
		. "${STELLA_ROOT}/conf.sh"

	else

		if [ "${IS_STELLA_LINK_FILE}" = "TRUE" ]; then
			# install STELLA into STELLA_ROOT defined in link file
			_STELLA_INSTALL_PATH=$(___rel_to_abs_path "${STELLA_ROOT}" "${STELLA_CURRENT_RUNNING_DIR}")
		else
			# install STELLA into default path
			_STELLA_INSTALL_PATH=$(___rel_to_abs_path "${PROVIDED_PATH}" "${STELLA_CURRENT_RUNNING_DIR}")
		fi

		if [ ! -f "${_STELLA_INSTALL_PATH}/stella.sh" ]; then
			__get_stella  "${_STELLA_INSTALL_PATH}" "${STELLA_DEP_FLAVOUR}" "${STELLA_DEP_VERSION}" "${_STELLA_INSTALL_PATH}"
			IS_STELLA_JUST_INSTALLED="TRUE"
		fi

		. "${_STELLA_INSTALL_PATH}/conf.sh"

	fi

	if [ "$IS_STELLA_JUST_INSTALLED" = "TRUE" ]; then
		__stella_requirement
	fi

	if [ "$IS_STELLA_LINK_FILE" = "FALSE" ]; then
		__ask_init_app
	fi

}

# VARIOUS FUNCTION ------------------

# NOTE by default path is determined giving by the current running directory
__rel_to_abs_path() {
	local _rel_path="$1"
	local _abs_root_path="$2"
	local result

	if [ "$_abs_root_path" = "" ]; then
		_abs_root_path="${STELLA_CURRENT_RUNNING_DIR}"
	fi


	if [ "$(__is_abs $_abs_root_path)" = "FALSE" ]; then
		result="$_rel_path"
	else

		case $_rel_path in
			/*)
				# path is already absolute
				result="$_rel_path"
				;;
			*)
				# relative to a given absolute path
				if [ -d "$_abs_root_path/$_rel_path" ]; then
					# NOTE call to __rel_to_abs_path_alternative_3 is equivalent
					result="$(cd "$_abs_root_path/$_rel_path" && pwd -P)"
				else
					# TODO using this method if directory does not exist returned path is not real absolute (example : /tata/toto/../titi instead of /tata/titi)
					# TODO : we rely on pure bash version, because readlink -m option used in alternative2 do not exist on some system
					result=$(__rel_to_abs_path_alternative_1 "$_rel_path" "$_abs_root_path")
					#[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && result=$(__rel_to_abs_path_alternative_1 "$_rel_path" "$_abs_root_path")
					#[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && result=$(__rel_to_abs_path_alternative_2 "$_rel_path" "$_abs_root_path")
				fi
				;;
		esac
	fi
	echo $result | tr -s '/'
}



# NOTE : http://stackoverflow.com/a/21951256
# NOTE : pure BASH : do not use readlink or cd or pwd command
# NOTE : paths do not have to exists
# NOTE : BUT do not follow symlink
__rel_to_abs_path_alternative_1(){
		local _rel_path=$1
		local _abs_root_path=$2

	  local thePath="$_abs_root_path/$_rel_path"
	  # if [[ ! "$1" =~ ^/ ]];then
	  #   thePath="$PWD/$1"
	  # else
	  #   thePath="$1"
	  # fi
	  echo "$thePath"|(
	  IFS=/
	  read -a parr
	  declare -a outp
	  for i in "${parr[@]}";do
	    case "$i" in
	    ''|.) continue ;;
	    ..)
	      len=${#outp[@]}
	      if ((len==0));then
	        continue
	      else
	        unset outp[$((len-1))]
	      fi
	      ;;
	    *)
	      len=${#outp[@]}
	      outp[$len]="$i"
	      ;;
	    esac
	  done
	  echo /"${outp[*]}"
	)
}
__get_stella() {
	local _path=$1
	# STABLE or DEV
	local _flavour=$2
	# a specific version or LATEST (for latest)
	local _ver=$3



	[ "$_flavour" = "" ] && _ver=STABLE
	[ "$_ver" = "" ] && _ver=LATEST

	if [ "$_flavour" = "DEV" ]; then
		if [[ ! -n `which git 2> /dev/null` ]]; then
			echo "*** git not present on this system. Trying to get the last stable version"
			_flavour=STABLE
			_ver=LATEST
		fi
	fi

	if [ "$_flavour" = "DEV" ]; then
		git clone https://github.com/StudioEtrange/stella "$_path"
		if [ ! "$_ver" = "LATEST" ]; then
			cd "$_path"
			git checkout $_ver
		fi
	fi

	if [ "$_flavour" = "STABLE" ]; then
		mkdir -p "$_path"
		[ "$_ver" = "LATEST" ] && _ver=latest

		curl -L -o "$_path"/$stella-all-"$_ver".gz.sh $__STELLA_URL/dist/$_ver/stella-all-"$_ver".tar.gz.run
		if [ -f "$_path"/$stella-all-"$_ver".gz.run ]; then
			chmod +x "$_path"/$stella-all-"$_ver".gz.run
			./"$_path"/$stella-all-"$_ver".gz.run
			rm -f "$_path"/$stella-all-"$_ver".gz.run
		else
			echo "*** ERROR stella $_flavour version $_ver not found"
		fi
	fi
}


# MAIN ------------------
ACTION=$1
PROVIDED_PATH=$2


# Switch mode ------------------
case $ACTION in
	bootstrap)
		bootstrap
		;;
	standalone)
		standalone
		;;
esac
