# shellcheck shell=bash
if [ ! "$_STELLA_COMMON_INCLUDED_" = "1" ]; then
_STELLA_COMMON_INCLUDED_=1

# TODO : do not hash
#turns off bash's hash function
#set +h


# VARIOUS-----------------------------


# https://stackoverflow.com/a/17975418
# https://stackoverflow.com/a/49886076
# add a scheduled command without duplication
__crontab_add() {
	local __cmd="$1"
	local __username="$2"
	if [ "${__username}" = "" ]; then
		( crontab -l 2>/dev/null || : ; echo "${__cmd}" ) | sort - | uniq - | crontab -
	else
		( crontab -u ${__username} -l 2>/dev/null || : ; echo "${__cmd}" ) | sort - | uniq - | crontab -u ${__username} -
	fi
}

# remove scheduled command without duplication
# __crontab_remove '0 * * * * /home/me/myfunction myargs > /home/me/myfunction.log 2>&1' "$(id -un)"
__crontab_remove() {
	local __cmd="$1"
	local __username="$2"
	if [ "${__username}" = "" ]; then
		( crontab -l 2>/dev/null | grep -v -F "${__cmd}" || : ) | crontab -
	else
		( crontab -u ${__username} -l 2>/dev/null | grep -v -F "${__cmd}" || : ) | crontab -u ${__username} -
	fi
}

# output a formated table
# input :
#               pass string to parse with a pipe
# options :
#		ALIGN_RIGHT : align all column text to right
#		CELL_DELIMITER : use a char to separate column when printing the table
#		SEPARATOR : define a separator which separate column in input text. default is TAB. For special character use a special notation like this
#                       __format_table "SEPARATOR "$'\t'""
# sample :
#               printf "head_1 "$'\t'" head_2\n val_1 "$'\t'" val_2" | __format_table "ALIGN_RIGHT CELL_DELIMITER |"
#				printf "head_1 | head_2 | head_3 \n val_1 || val_3" | __format_table "SEPARATOR |"
__format_table() {
        declare __str
        __str=$(</dev/stdin);
        local __opt="$1"

        local __align_right
        local __cell_delim
        local __flag_cel_delim=OFF
        local __separator=$'\t'
        local __flag_separator=OFF
        for o in ${__opt}; do
                [ "$o" = "ALIGN_RIGHT" ] && __align_right="1"
                [ "$__flag_cel_delim" = "ON" ] && __cell_delim="$o" && __flag_cel_delim="OFF"
                [ "$o" = "CELL_DELIMITER" ] && __flag_cel_delim="ON"
                [ "$__flag_separator" = "ON" ] && __separator="$o" && __flag_separator="OFF"
                [ "$o" = "SEPARATOR" ] && __flag_separator="ON"
        done
       
		# NOTE : -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g
		#		add a blank character for an empty cell because column command have a bug with empty column
        if [ "${__cell_delim}" = "" ]; then
                if [ "${__align_right}" = "1" ]; then
                        # NOTE : To work around the requirement entries in the leftmost column must be of equal width insert a dummy column and remove it later
                        #       https://stackoverflow.com/a/18022947/5027535
                        echo "${__str}" | sed -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g | sed -e s/^/FOO"${__separator}"/ | rev | column -s "${__separator}" -t | rev | cut -c4-
                else
                        echo "${__str}" | sed -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g | column -s "${__separator}" -t
                fi
        else
                if [ "${__align_right}" = "1" ]; then
                        echo "${__str}" | sed -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g | sed -e s/"${__separator}/${__separator}${__cell_delim}${__separator}"/g | sed -e s/^/FOO"${__separator}"/  | rev | column -s "${__separator}" -t | rev | cut -c4- 
                else
                        echo "${__str}" | sed -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g -e s/"${__separator}${__separator}"/"${__separator} ${__separator}"/g | sed -e s/"${__separator}/${__separator}${__cell_delim}${__separator}"/g | column -s "${__separator}" -t
                fi
        fi
		echo -n
}

# return a randomly number list separated by space
# PARAMETERS
# nb of requested number to pick
# range begin - default 0
# range end - default 65535
# OPTIONS :
# CONSECUTIVE - return a list of consecutive number
# EXCLUDE_LIST_BEGIN - begin of a list of number to exclude
# EXCLUDE_LIST_END - begin of a list of number to exclude
# SAMPLE :
#	__random_number_list_from_range "2" "0" "100"
#	__random_number_list_from_range "2" "0" "100" "CONSECUTIVE"
#	__random_number_list_from_range "2" "640" "650" "EXCLUDE_LIST_BEGIN 602 603 645 642 641 644 646 650 EXCLUDE_LIST_END CONSECUTIVE"
__random_number_list_from_range() {
	local requested_nb="${1:-1}"
	# authorized number start range (included)
	local range_begin="${2:-0}"
	# authorized number end range (included)
	local range_end="${3:-65535}"

	local opt="$4"
	local excluded_opt=
	local flag_exclude=
	local opt_consecutive=

	for o in $opt; do
		[ "$o" = "CONSECUTIVE" ] && flag_exclude= && opt_consecutive="CONSECUTIVE"
		[ "$o" = "EXCLUDE_LIST_END" ] && flag_exclude=
		[ "$flag_exclude" = "ON" ] && excluded_opt="$excluded_opt $o"
		[ "$o" = "EXCLUDE_LIST_BEGIN" ] && flag_exclude="ON"
	done

	# result list of number
	local result_list=( )
	# excluded number lists
	local original_exclude_list=( )
	local exclude_list=( )

	original_exclude_list=( $excluded_opt )
	original_exclude_list=( $(printf '%s\n' "${original_exclude_list[@]}" | sort -n | uniq ))
	#echo original_exclude_list : "${original_exclude_list[@]}"
	
	# size of authorized number range
	local range_size=$(( range_end - range_begin + 1 ))
	# CONSECUTIVE MODE : end of the range (included) of authorized number as first value of serie
	local range_end_valid=$range_end
	# CONSECUTIVE MODE : how many number are excluded from the end of the range of authorized number as first value of serie
	local nb_non_valid_from_range_end_valid
	# total of non authorized number in range (including the whole range, even last number excluded in CONSECUTIVE MODE)
	local nb_non_valid_in_range=0
	# total of available authorized number (as first value of serie in case of CONSECUTIVE mode)
	local nb_available=0

	local excluded
	local current
	local selector
	
	
	if [ "$opt_consecutive" = "CONSECUTIVE" ]; then
		# determine last valid number
		range_end_valid=$(( range_end - requested_nb ))

		nb_non_valid_from_range_end_valid=$(( range_end - range_end_valid ))
		nb_non_valid_in_range=$(( nb_non_valid_in_range + nb_non_valid_from_range_end_valid ))
	
		local temp_array=( )
		# tag all excluded number as non valid as first selected consecutive number and number preceding them
		for excluded in "${original_exclude_list[@]}"
		do
			#echo analyse excluded number : $excluded
			if [[ $excluded -ge $range_begin && $excluded -le $range_end_valid ]]; then
				
				for i in $(seq 0 $(( requested_nb - 1)) ); do
					current=$((excluded - i))
					if [ "${temp_array[$current]}" = "" ]; then
						if [[ $current -ge $range_begin ]]; then
							temp_array[$current]="1"
							exclude_list+=( $current)
							nb_non_valid_in_range=$(( nb_non_valid_in_range + 1 ))
						fi
					fi
				done
			fi
		done
	else
		for excluded in "${original_exclude_list[@]}"
		do
			#echo analyse excluded number : $excluded
			if [[ $excluded -ge $range_begin && $excluded -le $range_end ]]; then
				exclude_list+=( $excluded )
				nb_non_valid_in_range=$(( nb_non_valid_in_range + 1 ))
			fi
		done
	fi

	exclude_list=( $(printf '%s\n' "${exclude_list[@]}" | sort -n) )
	nb_available=$(( range_size - nb_non_valid_in_range ))

	# echo range_begin : $range_begin
	# echo range_end_valid : $range_end_valid
	# echo range_end : $range_end
	# echo computed exclude list : "${exclude_list[@]}"
	# echo range_size : $range_size
	# echo nb_non_valid_in_range : $nb_non_valid_in_range
	# echo nb_non_valid_from_range_end_valid : $nb_non_valid_from_range_end_valid
	# echo nb_available : $nb_available

	if [ "$opt_consecutive" = "CONSECUTIVE" ]; then
		# not enough available first number of a consecutive series
		[ $nb_available -gt 0 ] || return 1
	else
		# not enough available number
		[ $nb_available -ge $requested_nb ] || return 1
	fi


	if [ "$opt_consecutive" = "CONSECUTIVE" ]; then

		selector=$(( RANDOM % nb_available ))
		# echo --- try the position of available list as first selected number : $(( selector + 1 ))th

		selector=$(( range_begin + selector ))
		# echo this should be number : $selector

		for excluded in "${exclude_list[@]}"; do
			[ $excluded -le $selector ] && selector=$(( selector + 1))
		done

		# echo selected first number : $selector
		for i in $(seq 0 $(( requested_nb - 1)) ); do
			current=$(( selector + i ))
			result_list+=( $current )
			exclude_list+=( $current )
		done

		exclude_list=( $(printf '%s\n' "${exclude_list[@]}" | sort -n ))
		nb_available=$(( nb_available - 1 ))	
		# echo new excluded list : "${exclude_list[@]}"
		# echo there is still nb available number as first selected : $nb_available	

	else

		while [[ $nb_available -gt 0 ]]; do
			
			selector=$(( RANDOM % nb_available ))
			# echo --- try the position of available list as selected number : $(( selector + 1 ))th

			selector=$(( range_begin + selector ))
			# echo this should be number : $selector
			
			for excluded in "${exclude_list[@]}"; do
				[ $excluded -le $selector ] && selector=$(( selector + 1))
			done

			
			result_list+=( $selector )
			exclude_list+=( $selector )
			exclude_list=( $(printf '%s\n' "${exclude_list[@]}" | sort -n ))
			nb_available=$(( nb_available - 1 ))

			# echo selected number : $selector
			# echo new excluded list : "${exclude_list[@]}"
			# echo there is still nb_available : $nb_available	

			[ ${#result_list[@]} -eq $requested_nb ] && break;

		done
	fi

	[ ${#result_list[@]} -eq $requested_nb ] || return 1

	printf '%d ' "${result_list[@]}" | sort -n
}




# check if a user is member of group name
# __is_group_member <UID|user name> <group name>
# return 0 if user is a member
# https://stackoverflow.com/a/28926650/5027535
__is_group_member() {
	[[ " "$(id -Gn $2)" " == *" $1 "* ]]
}

# HASH string with sha256
# https://stackoverflow.com/questions/3358420/generating-a-sha256-from-the-linux-command-line
__sha256() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		printf "$*" | shasum -a 256 | tr -dc '[:alnum:]'
	else
		type sha256sum &>/dev/null && printf "$*" | sha256sum | tr -dc '[:alnum:]'
	fi
}

__sha1() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		printf "$*" | shasum -a 1 | tr -dc '[:alnum:]'
	else
		type sha1sum &>/dev/null && printf "$*" | sha1sum | tr -dc '[:alnum:]'
	fi
}


# HASH string with md5
__md5() {
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		# both methods works
		#printf "$*" | md5 | tr -dc '[:alnum:]'
		md5 -qs "$*" | tr -dc '[:alnum:]'
	else
		type md5sum &>/dev/null && printf '%s' "$*" | md5sum | tr -dc '[:alnum:]'
	fi
}

# https://github.com/rroutsong/bash-htpasswd/blob/master/htpasswd
# md5 is used by default to generate password with htpasswd
__htpasswd_md5() {
	openssl passwd -apr1 "$1"
}
__htpasswd_sha1() {
	__sha1 "$1"
}
__htpasswd_crypt() {
	openssl passwd -crypt "$1"
}


# generate an unique id for a machine
# MACHINE_ID (default) use /etc/machine-id https://unix.stackexchange.com/a/144915
# PRODUCT_UUID use product_uuid -- need sudo -- https://unix.stackexchange.com/a/144892
# SEED is a way to salt result with a constant
__generate_machine_id() {
	local _OPT="$1"

	local _flag_puuid=
	local _flag_mid=1
	local _seed=
	for o in $_OPT; do
		[ "$o" = "PRODUCT_UUID" ] && _flag_puuid="1"
		[ "$o" = "MACHINE_ID" ] && _flag_mid="1"
		[ "$_flag_seed" = "1" ] && _seed="$o" && _flag_seed=
		[ "$o" = "SEED" ] && _flag_seed="1"
	done

	# NOTE : order is important
	local _file_list=
	[ "${_flag_mid}" = "1" ] && _file_list="${_file_list} /etc/machine-id"
	[ "${_flag_puuid}" = "1" ] && _file_list="${_file_list} /sys/class/dmi/id/product_uuid"


	awk '{printf "'${_seed}'%s",$0}' ${_file_list} | sha256sum | tr -dc '[:alnum:]'
}

# generate a random password
# NOTE on macos : need LC_CTYPE=C http://nerdbynature.de/s9y/2010/04/11/tr-Illegal-byte-sequence
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
# expression possibles values are in man tr
#		class examples : __generate_password 8 "[:alnum:]"
__generate_password() {
	local __length="$1"
	local __expression="$2"
	[ "${__length}" = "" ] && __length=8
	[ "${__expression}" = "" ] && __expression="_A-Z-a-z-0-9"
	LC_CTYPE=C tr -dc  "${__expression}" < /dev/urandom | fold -w${__length} | head -n1;
}

# Try to sudo - if not exec without sudo
# On some systems, sudo do not exist, and we may already exec cmd as root
#		sample : __sudo_exec apt-get update
__sudo_exec() {
	if $(type sudo &>/dev/null); then
		sudo -E "$@"
	else
		"$@"
	fi
}


# Share sudo authentification between ssh sessions until __sudo_ssh_end_session is called
__sudo_ssh_begin_session() {
	local _uri="$1"
	__ssh_execute "$_uri"  '_save_tty=$(stty -g);stty raw -echo; echo "Defaults !tty_tickets" | sudo -Es tee /etc/sudoers.d/rsync_temp_hack_stella; sudo -v;stty ${_save_tty};' 'SHARED'
	# NOTE : needs time before modification is used by sshd
	sleep 3
}

__sudo_ssh_end_session() {
	local _uri="$1"
	__ssh_execute "$_uri" "rm -v /etc/sudoers.d/rsync_temp_hack_stella" "SHARED SUDO"
}

# NOTE : keep sudo authentification alive until __sudo_end_session is called
# 				https://stackoverflow.com/a/30547074
# 				https://serverfault.com/a/833888
# NOTE : trap signal
# 			 SIGKILL and SIGSTOP cannot be trapped
#				 ERR and EXIT are pseudo-signals
# https://www.ibm.com/developerworks/aix/library/au-usingtraps/
# https://linuxconfig.org/how-to-modify-scripts-behavior-on-signals-using-bash-traps
# NOTE as it catch it catch exit signal
#				could have side effect when bootstrapping an env
__sudo_begin_session() {
    sudo -v || exit $?
    ( while true; do sudo -nv; sleep 50; done; ) &
    STELLA_SUDO_PID="$!"
    trap '__sudo_end_session; exit' SIGABRT SIGHUP SIGINT SIGQUIT SIGTERM ERR EXIT
}
__sudo_end_session() {
		echo "** Ending sudo session $STELLA_SUDO_PID"
    kill -0 "$STELLA_SUDO_PID"
    trap - SIGABRT SIGHUP SIGINT SIGQUIT SIGTERM ERR EXIT
    sudo -k
}




# get the most recent version of a list
# option :
# ENDING_CHAR_REVERSE
# SEP .
__get_last_version() {
	local list="$1"
	local opt="$2"

	echo $(__sort_version "$list" "$opt DESC LIMIT 1")
}

# pick a version from a list according to constraint
# selector could be
#				a specific version number
#				or a version number with a constraint symbol >, >=, <, <=, ^
#				>version : most recent after version
#					>1.0 select the latest version after 1.0, which is not 1.0 (like 2.3.4)
#				>=version : most recent including version
#					>=1.0 select the latest version after 1.0, which may be 1.0
#				<version : most recent just before version
#					<1.0 select the latest just before 1.0, which is not 1.0 (like 0.3.4)
#				<=version : most recent just before version including version itself
#					<=1.0 select the latest version just before 1.0, which may be 1.0
#				^version : pin version and select most recent version with same version part (not exactly like npm)
#					^1.0 select the latest 1.0.* version (like 1.0.0 or 1.0.4)
#					^1 select the latest 1.* version (like 1.0.0 or 1.2.4)

# 	options LIMIT n, ENDING_CHAR_REVERSE, SEP c : see __sort_version

#		__select_version_from_list ">1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.1b
#		__select_version_from_list ">1.1.1b" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : <none>
#		__select_version_from_list ">=1.1.1a" "1.1.1 1.1.0 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.1a
#		__select_version_from_list "<=1.1.1c" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.1b
#		__select_version_from_list "<1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.0
#		__select_version_from_list "<1.1.0a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.0
#		__select_version_from_list "<=1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.0
#		__select_version_from_list "^1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0
# select_version result is : 1.1.1a
#		__select_version_from_list "^1.0" "1.0.0 1.0.1 1.1.1 1.1.1a 1.1.1b" "SEP ."
# desc list is 1.1.1b 1.1.1a 1.1.1 1.1.0 1.0.1 1.0.8
# select_version result is : 1.0.1
#			__select_version_from_list "^1.1" "1.1 1.0.0" "SEP ."
# select_version result is : 1.1
#			__select_version_from_list "^1.1" "1.1 1.1.0" "SEP ."
# select_version result is : 1.1.0
__select_version_from_list() {
	local selector="$1"
	local list="$2"
	local opt="$3"
	local result=""

	local v
	local sorted_list=
	local flag
	flag=0
	local exist
	exist=0
	case ${selector} in
		\>=*)
			selector="${selector:2}"
			if __list_contains "${list}" "${selector}"; then
				exist=1
				sorted_list="$(__sort_version "${list}" "ASC ${opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "ASC ${opt}")"
			fi
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					result="${v}"
					break;
				fi
				# if selector is the result (equal), we must check if selector exist as is in the orignal list
				if [ "${v}" = "${selector}" ]; then
					if [ "${exist}" = "1" ]; then
						result="${selector}"
						break;
					else
						flag=1
					fi
				fi
			done
			;;


		\>* )
			selector="${selector:1}"
			if __list_contains "${list}" "${selector}"; then
				sorted_list="$(__sort_version "${list}" "ASC ${opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "ASC ${opt}")"
			fi
			
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					# in case of duplicate element
					[ "${v}" = "${selector}" ] && continue
					result="${v}"
					break;
				fi
				if [ "${v}" = "${selector}" ]; then
					flag=1
				fi
			done
			;;


		\<=* )
			selector="${selector:2}"
			if __list_contains "${list}" "${selector}"; then
				exist=1
				sorted_list="$(__sort_version "${list}" "DESC ${opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "DESC ${opt}")"
			fi
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					result="${v}"
					break;
				fi
				# if selector is the result (equal), we must check if selector exist as is in the orignal list
				if [ "${v}" = "${selector}" ]; then
					if [ "${exist}" = "1" ]; then
						result="${selector}"
						break;
					else
						flag=1
					fi
				fi
			done
			;;

		\<* )
			selector="${selector:1}"
			if __list_contains "${list}" "${selector}"; then
				sorted_list="$(__sort_version "${list}" "DESC ${opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "DESC ${opt}")"
			fi
			
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					# in case of duplicate element
					[ "${v}" = "${selector}" ] && continue
					result="${v}"
					break;
				fi
				if [ "${v}" = "${selector}" ]; then
					flag=1
				fi
			done
			;;



		^* )
			selector="${selector:1}"
			# filter list only starting with selector AND check if selector exist as is in the orignal list
			filtered_list=
			for v in ${list}; do
				case ${v} in
					# selector exist in list
					${selector}) filtered_list="${filtered_list} ${v}"; exist=1;;
					# matching version in list starting with ${selector}
					${selector}*) filtered_list="${filtered_list} ${v}";;
				esac
			done
			sorted_list="$(__sort_version "${filtered_list}" "DESC ${opt}")"
			result="$(echo $sorted_list | cut -d' ' -f 1)"
			;;

		"" )
			result=""
			;;
		* )
			# check if exact version exist
			for v in ${list}; do
				if [ "${v}" = "${selector}" ]; then
					result="${v}"
					break;
				fi
			done
			;;
	esac
	echo "${result}"
}

# __filter_version_list filter versions list with a constraint and return a filtered sorted list in ASC (by default)
# 	same as __select_version_from_list but return a matching list of versions instead of one picked version
# 	options LIMIT n, ENDING_CHAR_REVERSE, SEP c : see __sort_version
#					ASC (default), DESC : will return result filtered list in this order
# __filter_version_list ">=1.1.0" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
#		1.1.0 1.1.1 1.1.1a 1.1.1b
# __filter_version_list ">=1.1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
#		1.1.1 1.1.1a 1.1.1b
# __filter_version_list ">=1.1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP . ENDING_CHAR_REVERSE"
#		1.1.1
# __filter_version_list "<1.1.0" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
#
# __filter_version_list "<1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
#		1.1.0 1.1.1
# __filter_version_list "<=1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP ."
#		1.1.0 1.1.1 1.1.1a
# __filter_version_list "<=1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP . ENDING_CHAR_REVERSE"
#		1.1.0 1.1.1a
# __filter_version_list "^1.1.1a" "1.1.0 1.1.1 1.1.1a 1.1.1b" "SEP . ENDING_CHAR_REVERSE"
#		1.1.1a
# __filter_version_list "^1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b 1.1" "SEP ."
#		1.1 1.1.0 1.1.1 1.1.1a 1.1.1b
# __filter_version_list "^1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b 1.1" "DESC SEP ." 
#		1.1.1b 1.1.1a 1.1.1 1.1.0 1.1
# __filter_version_list "1.1" "1.1.0 1.1.1 1.1.1a 1.1.1b 1.1" "SEP ." 
#		1.1
# __filter_version_list "" "1.1.0 1.1.1 1.1.1a 1.1.1b 1.1" "SEP ." 
#		1.1.0 1.1.1 1.1.1a 1.1.1b 1.1

__filter_version_list() {
	local selector="$1"
	local list="$2"
	local opt="$3"
	local result=""
	local limit=
	local __result_order="ASC"
	local flag_sep="OFF"
	local flag_limit="OFF"
	local __sort_opt=
	for o in $opt; do
		[ "$o" = "ASC" ] && __result_order="$o"
		[ "$o" = "DESC" ] && __result_order="$o"
		[ "$o" = "ENDING_CHAR_REVERSE" ] && __sort_opt="${__sort_opt} ENDING_CHAR_REVERSE"
		[ "$flag_sep" = "ON" ] && __sort_opt="${__sort_opt} $o" && flag_sep="OFF"
		[ "$o" = "SEP" ] && flag_sep="ON" && __sort_opt="${__sort_opt} SEP"
		[ "$flag_limit" = "ON" ] && limit="$o" && flag_limit="OFF"
		[ "$o" = "LIMIT" ] && flag_limit="ON"
	done


	local v
	local sorted_list=
	local flag
	flag=0
	local exist
	exist=0
	case ${selector} in
		\>=*)
			selector="${selector:2}"
			if __list_contains "${list}" "${selector}"; then
				exist=1
				sorted_list="$(__sort_version "${list}" "ASC ${__sort_opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "ASC ${__sort_opt}")"
			fi
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					[ "${__result_order}" = "DESC" ] && result="${v} ${result}" || result="${result} ${v}"
					continue;
				fi
				# if selector is the result (equal), we must check if selector exist as is in the orignal list
				if [ "${v}" = "${selector}" ]; then
					if [ "${exist}" = "1" ]; then
						[ "${__result_order}" = "DESC" ] && result="${selector} ${result}" || result="${result} ${selector}"
						flag=1
					else
						flag=1
					fi
				fi
			done
			;;


		\>* )
			selector="${selector:1}"
			if __list_contains "${list}" "${selector}"; then
				sorted_list="$(__sort_version "${list}" "ASC ${__sort_opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "ASC ${__sort_opt}")"
			fi
			
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					# in case of duplicate element
					[ "${v}" = "${selector}" ] && continue
					[ "${__result_order}" = "DESC" ] && result="${v} ${result}" || result="${result} ${v}"
				fi
				if [ "${v}" = "${selector}" ]; then
					flag=1
				fi
			done
			;;


		\<=* )
			selector="${selector:2}"
			if __list_contains "${list}" "${selector}"; then
				exist=1
				sorted_list="$(__sort_version "${list}" "DESC ${__sort_opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "DESC ${__sort_opt}")"
			fi
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					[ "${__result_order}" = "DESC" ] && result="${result} ${v}" || result="${v} ${result}"
					continue
				fi
				# if selector is the result (equal), we must check if selector exist as is in the orignal list
				if [ "${v}" = "${selector}" ]; then
					if [ "${exist}" = "1" ]; then
						[ "${__result_order}" = "DESC" ] && result="${result} ${selector}" || result="${selector} ${result}"
						flag=1
					else
						flag=1
					fi
				fi
			done
			;;

		\<* )
			selector="${selector:1}"
			if __list_contains "${list}" "${selector}"; then
				sorted_list="$(__sort_version "${list}" "DESC ${__sort_opt}")"
			else
				sorted_list="$(__sort_version "${selector} ${list}" "DESC ${__sort_opt}")"
			fi
			
			for v in ${sorted_list}; do
				if [ "${flag}" = "1" ]; then
					# in case of duplicate element
					[ "${v}" = "${selector}" ] && continue
					[ "${__result_order}" = "DESC" ] && result="${result} ${v}" || result="${v} ${result}"
				fi
				if [ "${v}" = "${selector}" ]; then
					flag=1
				fi
			done
			;;



		^* )
			selector="${selector:1}"
			# filter list only starting with selector AND check if selector exist as is in the orignal list
			filtered_list=
			for v in ${list}; do
				case ${v} in
					# selector exist in list
					${selector}) filtered_list="${filtered_list} ${v}"; exist=1;;
					# matching version in list starting with ${selector}
					${selector}*) filtered_list="${filtered_list} ${v}";;
				esac
			done
			result="$(__sort_version "${filtered_list}" "${__result_order} ${__sort_opt}")"
			;;

		"" )
			result="$(__sort_version "${list}" "${__result_order} ${__sort_opt}")"
			;;
		* )
			# check if exact version exist
			for v in ${list}; do
				if [ "${v}" = "${selector}" ]; then
					result="${v}"
					break;
				fi
			done
			;;
	esac

	[ ! "${limit}" = "" ] && echo "${result}" | sed -e 's/^ *//' -e 's/ *$//' | cut -d' ' -f "-${limit}" \
	 	|| echo "${result}" | sed -e 's/^ *//' -e 's/ *$//'

}



# sort a list of versions

#__sort_version "build507 build510 build403 build4000 build" "ASC"
#  build build403 build507 build510 build4000
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "ASC"
#  1.1.0 1.1.1 1.1.1a 1.1.1b
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "ASC SEP ."
#  1.1.0 1.1.1 1.1.1a 1.1.1b
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "ASC SEP . ENDING_CHAR_REVERSE"
#  1.1.0 1.1.1a 1.1.1b 1.1.1
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "DESC"
#  1.1.1b 1.1.1a 1.1.1 1.1.0
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "DESC SEP ."
#  1.1.1b 1.1.1a 1.1.1 1.1.0
#__sort_version "1.1.0 1.1.1 1.1.1a 1.1.1b" "DESC SEP . ENDING_CHAR_REVERSE"
#  1.1.1 1.1.1b 1.1.1a 1.1.0
#__sort_version "1.1.0 1.1.1 1.1.1alpha 1.1.1beta1 1.1.1beta2" "ASC ENDING_CHAR_REVERSE SEP ."
#  1.1.0 1.1.1alpha 1.1.1beta1 1.1.1beta2 1.1.1
#__sort_version "1.1.0 1.1.1 1.1.1alpha 1.1.1beta1 1.1.1beta2" "DESC ENDING_CHAR_REVERSE SEP ."
#  1.1.1 1.1.1beta2 1.1.1beta1 1.1.1alpha 1.1.0
#__sort_version "1.9.0 1.10.0 1.10.1.1 1.10.1 1.10.1alpha1 1.10.1beta1 1.10.1beta2 1.10.2 1.10.2.1 1.10.2.2 1.10.0RC1 1.10.0RC2" "DESC ENDING_CHAR_REVERSE SEP ."
#  1.10.2.2 1.10.2.1 1.10.2 1.10.1.1 1.10.1 1.10.1beta2 1.10.1beta1 1.10.1alpha1 1.10.0 1.10.0RC2 1.10.0RC1 1.9.0

# options :
#		ASC : ascending order
#		DESC : decresacing order
#  		ENDING_CHAR_REVERSE ending characters in a version number can be ordered in the opposite way example :
# 			1.0.1 is more recent than 1.0.1beta so in ASC : 1.0.1beta 1.0.1 and in DESC : 1.0.1 1.0.1beta
# 			To activate this behaviour use "ENDING_CHAR_REVERSE" option
# 			we must indicate separator with SEP if we use ENDING_CHAR_REVERSE and if there is any separator (obviously)
#		LIMIT n : limit to a number of result
# NOTE : characters "}", "!" and "{" may cause problem if they are used in versions strings


__sort_version() {
	local list=$1
	local opt="$2"

	local opposite_order_for_ending_chars="OFF"
	local mode="ASC"

	local separator=
	local limit=
	local flag_sep="OFF"
	local flag_limit="OFF"
	for o in $opt; do
		[ "$o" = "ASC" ] && mode="$o"
		[ "$o" = "DESC" ] && mode="$o"
		[ "$o" = "ENDING_CHAR_REVERSE" ] && opposite_order_for_ending_chars="ON"
		# we need separator only if we use ENDING_CHAR_REVERSE and if there is any separator (obviously)
		[ "$flag_sep" = "ON" ] && separator="$o" && flag_sep="OFF"
		[ "$o" = "SEP" ] && flag_sep="ON"
		[ "$flag_limit" = "ON" ] && limit="$o" && flag_limit="OFF"
		[ "$o" = "LIMIT" ] && flag_limit="ON"
	done

	local internal_separator="}"
	local new_list=
	local match_list=
	local max_number_of_block=0
	local number_of_block=0
	for r in $list; do
		# separate each block of number and block of letter
		[ ! "$separator" = "" ] && new_item="$(echo $r | sed "s,\([0-9]*\)\([^0-9]*\)\([0-9]*\),\1$internal_separator\2$internal_separator\3,g" | sed "s,^\([0-9]\),$internal_separator\1," | sed "s,\([0-9]\)$,\1$internal_separator$separator$internal_separator,")"
		[ "$separator" = "" ] && new_item="$(echo $r | sed "s,\([0-9]*\)\([^0-9]*\)\([0-9]*\),\1$internal_separator\2$internal_separator\3,g" | sed "s,^\([0-9]\),$internal_separator\1," | sed "s,\([0-9]\)$,\1$internal_separator,")"

		if [ "$opposite_order_for_ending_chars" = "OFF" ]; then
			# ! is before A (in C locale)
			[ "$mode" = "ASC" ] && substitute="?"
			[ "$mode" = "DESC" ] && substitute="?"
		else
			# { is after z (in C locale)
			[ "$mode" = "ASC" ] && substitute="{"
			[ "$mode" = "DESC" ] && substitute="{"
		fi

		[ ! "$separator" = "" ] && new_item="$(echo $new_item | sed "s,\\$separator,$substitute,g")"

		new_list="$new_list $new_item"
		match_list="$new_item $r $match_list"
		number_of_block="${new_item//[^$internal_separator]}"
		number_of_block=${#number_of_block}
		[ "${number_of_block}" -gt "$max_number_of_block" ] && max_number_of_block="${number_of_block}"
	done
	
	# we detect block made with non-number characters for reverse order of block with non-number characters (except the first one)
	local count=0
	local b
	local i
	local char_block_list=

	for i in $new_list; do
		
		# the first empty block count as firt
		# here there is 3 blocks, not ot 2 : }build} }build}4000} }build}403} }build}507} }build}510}
		count=1
		for b in $(echo $i | tr "$internal_separator" "\n"); do
			count=$[$count +1]
			if [ ! "$(echo $b | sed "s,[0-9]*,,g")" = "" ]; then
				char_block_list="$char_block_list $count"
			fi
		done
	done

	# make argument for sort function
	# note : for non-number characters : first non-number character is sorted as wanted (ASC or DESC) and others non-number characters are sorted in the opposite way
	# example : 1.0.1 is more recent than 1.0.1beta so in ASC : 1.0.1beta 1.0.1 and in DESC : 1.0.1 1.0.1beta
	# example : build400 is more recent than build300 so in ASC : build300 build400 and in DESC : build400 build300

	local sorted_arg=

	# first empty arg
	[ "$mode" = "DESC" ] && sorted_arg="-k 1,1r" || sorted_arg="-k 1,1"
	
	count=1
	local j
	while [ "$count" -lt "$max_number_of_block" ]; do
		count=$[$count +1]

		# -k option to sort on a certain column
		# -r Option: Sorting In Reverse Order
		# -n Option : To sort numerically
		block_arg=

		block_is_char=
		if __list_contains "$char_block_list" "$count"; then
			block_is_char=1
		fi
		if [ "$block_is_char" = "" ]; then
			block_arg="n${block_arg}"
		fi

		[ "$mode" = "DESC" ] && block_arg="r${block_arg}"

		# -k POS1[,POS2]  # we need POS2 or order is broken ;
		# this will not work :
		# echo "B.507 A.510 B.403 B.4000" | tr ' ' '\n' | LC_COLLATE=C sort -t'.' -k1,1 -k 2,2n
		sorted_arg="$sorted_arg -k $count,$count"$block_arg
		#sorted_arg="$sorted_arg -k $count"$block_arg
	done
	[ "$mode" = "ASC" ] && sorted_arg="-t$internal_separator $sorted_arg"
	[ "$mode" = "DESC" ] && sorted_arg="-t$internal_separator $sorted_arg"

	# LC_COLLATE=C fix character order
	# https://unix.stackexchange.com/a/19327
	sorted_list="$(echo "$new_list" | tr ' ' '\n' | LC_COLLATE=C sort $(echo "$sorted_arg") | tr '\n' ' ')"

	# restore original version strings (alternative to hashtable...)
	local result_list=
	local flag_found=OFF
	local flag=KEY
	for r in $sorted_list; do
		flag_found=OFF
		flag=KEY
		for m in $match_list; do
			if [ "$flag_found" = "ON" ]; then
				result_list="$result_list $m"
				break
			fi
			if [ "$flag" = "KEY" ]; then
				[ "$m" = "$r" ] && flag_found=ON
			fi
		done
	done


	[ ! "${limit}" = "" ] && echo "${result_list}" | sed -e 's/^ *//' -e 's/ *$//' | cut -d' ' -f "-${limit}" \
	 	|| echo "${result_list}" | sed -e 's/^ *//' -e 's/ *$//'
}






__url_encode() {
	if [ "$(which xxd 2>/dev/null)" = "" ]; then
		__url_encode_1 "$@"
	else
		__url_encode_with_xxd "$@"
	fi
}

# https://gist.github.com/cdown/1163649
__url_encode_1() {
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
		# local LANG=C
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

# https://gist.github.com/cdown/1163649
# xxd is used to suppoert wide characters
__url_encode_with_xxd() {
  local length="${#1}"
  for (( i = 0; i < length; i++ )); do
    local c="${1:i:1}"
    case $c in
	      [a-zA-Z0-9.~_-]) printf "$c" ;;
	    *) printf "$c" | xxd -p -c1 | while read x;do printf "%%%s" "$x";done
	  esac
	done
}

# Faster solution than __url_encode_1 ? (without xxd)
# http://unix.stackexchange.com/a/60698
__url_encode_2() {
	string=$1; format=; set --
  while
    literal=${string%%[!-._~0-9A-Za-z]*}
    case "$literal" in
      ?*)
        format=$format%s
        set -- "$@" "$literal"
        string=${string#$literal};;
    esac
    case "$string" in
      "") false;;
    esac
  do
    tail=${string#?}
    head=${string%$tail}
    format=$format%%%02x
    set -- "$@" "'$head"
    string=$tail
  done
  printf "$format\\n" "$@"
}

# https://gist.github.com/cdown/1163649
__url_decode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


# Build path part of an uri
# ./foo ==> /?foo
# ../foo ==> /?../foo
# /foo ==> /foo
__uri_build_path() {
	local __path="$1"

	if [ "$(__is_abs "$__path")" = "FALSE" ]; then
		echo "/?${__path}"
	else
		echo "${__path}"
	fi
}

# __uri_get_path ssh://host/?foo ==> ./foo
# __uri_get_path local://../foo  ==> ../foo
# __uri_get_path local://?../foo  ==> ../foo
# __uri_get_path local:///?foo	==> ./foo
# __uri_get_path ssh://host/foo  ==> /foo
# __uri_get_path local:///foo  ==> /foo
# __uri_get_path ssh://host ==> .
# NOTE : without schema, we use local as default 
#	../foo ==>	local://../foo  ==> ../foo
__uri_get_path() {
	local _uri="$@"
	local __path

	__uri_parse "$_uri"

	# if there is not schema specified, we are in local
	if [ "$__stella_uri_schema" = "" ]; then
		__stella_uri_schema="local"
		_uri="local://${_uri}"
	fi

	# we may have use absolute path or relative path.
	# if relative path is used, it is specify with local://../foo OR local://?../foo
	#	in case local://../foo form __stella_uri_host will contain the ".."
	if [ ! "${__stella_uri_query:1}" = "" ]; then
		# we use explicit relative path with local://?../foo
		__path="${__stella_uri_query:1}"
	else
		# we use relative path with local://../foo OR we use absolute path with local:///foo/bar
		[ "$__stella_uri_schema" = "local" ] && __path="${__stella_uri_host}${__stella_uri_path}"
		# we use absolute path with other protocol (ssh://host/foo)
		[ ! "$__stella_uri_schema" = "local" ] && __path="${__stella_uri_path}"
	fi

	[ "$__path" = "" ] && __path="."

	if [ "$(__is_abs "$__path")" = "FALSE" ]; then
		[ ! "${__path::1}" = "." ] && __path="./$__path"
	fi

	echo "$__path"
}



#   find uri inside a stream of strings
# 		available options
# 			[schema://][user[:password]@][host][:port][/path][?[arg1=val1]...][#fragment]
#			filter options : -will select uri based on condition- NULL : uri part is empty, NON_NULL : uri part must be non empty, VALUE : uri part must match regexp
#				SCHEMA_NULL, SCHEMA_NON_NULL, SCHEMA_VALUE, ADDRESS_NULL, ADDRESS_NON_NULL, ADDRESS_VALUE, USER_NULL, USER_NON_NULL, USER_VALUE, PASSWORD_NULL, PASSWORD_NON_NULL, PASSWORD_VALUE
#				HOST_NULL, HOST_NON_NULL, HOST_VALUE, PORT_NULL, PORT_NON_NULL, PORT_VALUE, PATH_NULL, PATH_NON_NULL, PATH_VALUE, QUERY_NULL, QUERY_NON_NULL, QUERY_VALUE, FRAGMENT_NULL, FRAGMENT_NON_NULL, FRAGMENT_VALUE
#			URI validation option : STRICT_VALIDATION : will detect only URI which respect rfc3986
#			output options : -will output one of these uri part-
#				OUTPUT_URI (output by default) , OUTPUT_SCHEMA, OUTPUT_ADDRESS, OUTPUT_USER, OUTPUT_PASSWORD, OUTPUT_HOST, OUTPUT_PORT, OUTPUT_PATH, OUTPUT_QUERY, OUTPUT_FRAGMENT
#		samples
#			echo "string http://url" | __uri_parse_stream 
#			echo "string http://url" | __uri_parse_stream "OUTPUT_ADDRESS ADDRESS_NON_NULL SCHEMA_VALUE https?"
#			docker logs <container> | $STELLA_API uri_parse_stream 'SCHEMA_VALUE https? MATCH_ONLY_STRICT_VALIDATION' | while read u; do echo "Calling HTTP request to $l"; curl -sLSk $u; done
__uri_parse_stream() {

	local __opt="$1"

	local SCHEMA_NULL=
	local SCHEMA_NON_NULL=
	local SCHEMA_VALUE=
	local _SCHEMA_VALUE=
	local ADDRESS_NULL=
	local ADDRESS_NON_NULL=
	local ADDRESS_VALUE=
	local _ADDRESS_VALUE=
	local USER_NULL=
	local USER_NON_NULL=
	local USER_VALUE=
	local _USER_VALUE=
	local PASSWORD_NULL=
	local PASSWORD_NON_NULL=
	local PASSWORD_VALUE=
	local _PASSWORD_VALUE=
	local HOST_NULL=
	local HOST_NON_NULL=
	local HOST_VALUE=
	local _HOST_VALUE=
	local PORT_NULL=
	local PORT_NON_NULL=
	local PORT_VALUE=
	local _PORT_VALUE=
	local PATH_NULL=
	local PATH_NON_NULL=
	local PATH_VALUE=
	local _PATH_VALUE=
	local QUERY_NULL=
	local QUERY_NON_NULL=
	local QUERY_VALUE=
	local _QUERY_VALUE=
	local FRAGMENT_NULL=
	local FRAGMENT_NON_NULL=
	local FRAGMENT_VALUE=
	local _FRAGMENT_VALUE=

	local OUTPUT_URI=
	local OUTPUT_SCHEMA=
	local OUTPUT_ADDRESS=
	local OUTPUT_USER=
	local OUTPUT_PASSWORD=
	local OUTPUT_HOST=
	local OUTPUT_PORT=
	local OUTPUT_PATH=
	local OUTPUT_QUERY=
	local OUTPUT_FRAGMENT=
	local VALIDATION=
	for o in ${__opt}; do
			[ "$o" = "STRICT_VALIDATION" ] && VALIDATION="$o"
			[ "$o" = "MATCH_ONLY_STRICT_VALIDATION" ] && VALIDATION="$o"
			[ "$o" = "SIMPLE_VALIDATION" ] && VALIDATION="$o"
			[ "$o" = "OUTPUT_URI" ] && OUTPUT_URI="ON"
			[ "$o" = "OUTPUT_SCHEMA" ] && OUTPUT_SCHEMA="ON"
			[ "$o" = "OUTPUT_ADDRESS" ] && OUTPUT_ADDRESS="ON"
			[ "$o" = "OUTPUT_USER" ] && OUTPUT_USER="ON"
			[ "$o" = "OUTPUT_PASSWORD" ] && OUTPUT_PASSWORD="ON"
			[ "$o" = "OUTPUT_HOST" ] && OUTPUT_HOST="ON"
			[ "$o" = "OUTPUT_PORT" ] && OUTPUT_PORT="ON"
			[ "$o" = "OUTPUT_PATH" ] && OUTPUT_PATH="ON"
			[ "$o" = "OUTPUT_QUERY" ] && OUTPUT_QUERY="ON"
			[ "$o" = "OUTPUT_FRAGMENT" ] && OUTPUT_FRAGMENT="ON"

			[ "$o" = "SCHEMA_NULL" ] && SCHEMA_NULL="ON"
			[ "$o" = "SCHEMA_NON_NULL" ] && SCHEMA_NON_NULL="ON"
			[ "$_SCHEMA_VALUE" = "ON" ] && SCHEMA_VALUE="$o" && _SCHEMA_VALUE=
			[ "$o" = "SCHEMA_VALUE" ] && _SCHEMA_VALUE="ON"

			[ "$o" = "ADDRESS_NULL" ] && ADDRESS_NULL="ON"
			[ "$o" = "ADDRESS_NON_NULL" ] && ADDRESS_NON_NULL="ON"
			[ "$_ADDRESS_VALUE" = "ON" ] && ADDRESS_VALUE="$o" && _ADDRESS_VALUE=
			[ "$o" = "ADDRESS_VALUE" ] && _ADDRESS_VALUE="ON"

			[ "$o" = "USER_NULL" ] && USER_NULL="ON"
			[ "$o" = "USER_NON_NULL" ] && USER_NON_NULL="ON"
			[ "$_USER_VALUE" = "ON" ] && USER_VALUE="$o" && _USER_VALUE=
			[ "$o" = "USER_VALUE" ] && _USER_VALUE="ON"

			[ "$o" = "PASSWORD_NULL" ] && PASSWORD_NULL="ON"
			[ "$o" = "PASSWORD_NON_NULL" ] && PASSWORD_NON_NULL="ON"
			[ "$_PASSWORD_VALUE" = "ON" ] && PASSWORD_VALUE="$o" && _PASSWORD_VALUE=
			[ "$o" = "PASSWORD_VALUE" ] && _PASSWORD_VALUE="ON"

			[ "$o" = "HOST_NULL" ] && HOST_NULL="ON"
			[ "$o" = "HOST_NON_NULL" ] && HOST_NON_NULL="ON"
			[ "$_HOST_VALUE" = "ON" ] && HOST_VALUE="$o" && _HOST_VALUE=
			[ "$o" = "HOST_VALUE" ] && _HOST_VALUE="ON"

			[ "$o" = "PORT_NULL" ] && PORT_NULL="ON"
			[ "$o" = "PORT_NON_NULL" ] && PORT_NON_NULL="ON"
			[ "$_PORT_VALUE" = "ON" ] && PORT_VALUE="$o" && _PORT_VALUE=
			[ "$o" = "PORT_VALUE" ] && _PORT_VALUE="ON"

			[ "$o" = "PATH_NULL" ] && PATH_NULL="ON"
			[ "$o" = "PATH_NON_NULL" ] && PATH_NON_NULL="ON"
			[ "$_PATH_VALUE" = "ON" ] && PATH_VALUE="$o" && _PATH_VALUE=
			[ "$o" = "PATH_VALUE" ] && _PATH_VALUE="ON"

			[ "$o" = "QUERY_NULL" ] && QUERY_NULL="ON"
			[ "$o" = "QUERY_NON_NULL" ] && QUERY_NON_NULL="ON"
			[ "$_QUERY_VALUE" = "ON" ] && QUERY_VALUE="$o" && _QUERY_VALUE=
			[ "$o" = "QUERY_VALUE" ] && _QUERY_VALUE="ON"

			[ "$o" = "FRAGMENT_NULL" ] && FRAGMENT_NULL="ON"
			[ "$o" = "FRAGMENT_NON_NULL" ] && FRAGMENT_NON_NULL="ON"
			[ "$_FRAGMENT_VALUE" = "ON" ] && FRAGMENT_VALUE="$o" && _FRAGMENT_VALUE=
			[ "$o" = "FRAGMENT_VALUE" ] && _FRAGMENT_VALUE="ON"
	done
	
	local __printed=
	local __valid="1"
	while read line; do
		echo $line | awk '{ for (i = 1; i <= NF; i++) print $i }' | while read word; do
		
			__uri_parse "$word" "$VALIDATION"
			# an uri is detected
			if [ $? -eq 0 ]; then 
				__valid="1"
				[ $__valid ] && [ "$SCHEMA_NULL" = "ON" ] && [ ! "$__stella_uri_schema" = "" ] && __valid=
				[ $__valid ] && [ "$SCHEMA_NON_NULL" = "ON" ] && [ "$__stella_uri_schema" = "" ] && __valid=
				[ $__valid ] && [ ! "$SCHEMA_VALUE" = "" ] && [[ ! "$__stella_uri_schema" =~ $SCHEMA_VALUE ]] && __valid=

				[ $__valid ] && [ "$ADDRESS_NULL" = "ON" ] && [ ! "$__stella_uri_address" = "" ] && __valid=
				[ $__valid ] && [ "$ADDRESS_NON_NULL" = "ON" ] && [ "$__stella_uri_address" = "" ] && __valid=
				[ $__valid ] && [ ! "$ADDRESS_VALUE" = "" ] && [[ ! "$__stella_uri_address" =~ $ADDRESS_VALUE ]] && __valid=

				[ $__valid ] && [ "$USER_NULL" = "ON" ] && [ ! "$__stella_uri_user" = "" ] && __valid=
				[ $__valid ] && [ "$USER_NON_NULL" = "ON" ] && [ "$__stella_uri_user" = "" ] && __valid=
				[ $__valid ] && [ ! "$USER_VALUE" = "" ] && [[ ! "$__stella_uri_user" =~ $USER_VALUE ]] && __valid=

				[ $__valid ] && [ "$PASSWORD_NULL" = "ON" ] && [ ! "$__stella_uri_password" = "" ] && __valid=
				[ $__valid ] && [ "$PASSWORD_NON_NULL" = "ON" ] && [ "$__stella_uri_password" = "" ] && __valid=
				[ $__valid ] && [ ! "$PASSWORD_VALUE" = "" ] && [[ ! "$__stella_uri_password" =~ $PASSWORD_VALUE ]] && __valid=

				[ $__valid ] && [ "$HOST_NULL" = "ON" ] && [ ! "$__stella_uri_host" = "" ] && __valid=
				[ $__valid ] && [ "$HOST_NON_NULL" = "ON" ] && [ "$__stella_uri_host" = "" ] && __valid=
				[ $__valid ] && [ ! "$HOST_VALUE" = "" ] && [[ ! "$__stella_uri_host" =~ $HOST_VALUE ]] && __valid=

				[ $__valid ] && [ "$PORT_NULL" = "ON" ] && [ ! "$__stella_uri_port" = "" ] && __valid=
				[ $__valid ] && [ "$PORT_NON_NULL" = "ON" ] && [ "$__stella_uri_port" = "" ] && __valid=
				[ $__valid ] && [ ! "$PORT_VALUE" = "" ] && [[ ! "$__stella_uri_port" =~ $PORT_VALUE ]] && __valid=
				
				[ $__valid ] && [ "$PATH_NULL" = "ON" ] && [ ! "$__stella_uri_path" = "" ] && __valid=
				[ $__valid ] && [ "$PATH_NON_NULL" = "ON" ] && [ "$__stella_uri_path" = "" ] && __valid=
				[ $__valid ] && [ ! "$PATH_VALUE" = "" ] && [[ ! "$__stella_uri_path" =~ $PATH_VALUE ]] && __valid=

				[ $__valid ] && [ "$QUERY_NULL" = "ON" ] && [ ! "$__stella_uri_query" = "" ] && __valid=
				[ $__valid ] && [ "$QUERY_NON_NULL" = "ON" ] && [ "$__stella_uri_query" = "" ] && __valid=
				[ $__valid ] && [ ! "$QUERY_VALUE" = "" ] && [[ ! "$__stella_uri_query" =~ $QUERY_VALUE ]] && __valid=

				[ $__valid ] && [ "$FRAGMENT_NULL" = "ON" ] && [ ! "$__stella_uri_fragment" = "" ] && __valid=
				[ $__valid ] && [ "$FRAGMENT_NON_NULL" = "ON" ] && [ "$__stella_uri_fragment" = "" ] && __valid=
				[ $__valid ] && [ ! "$FRAGMENT_VALUE" = "" ] && [[ ! "$__stella_uri_fragment" =~ $FRAGMENT_VALUE ]] && __valid=

				__printed=
				if [ $__valid ]; then
					[ "ON" = "$OUTPUT_URI" ] && echo "$__stella_uri" && __printed="1"
					[ "ON" = "$OUTPUT_SCHEMA" ] && echo "$__stella_uri_schema" && __printed="1"
					[ "ON" = "$OUTPUT_ADDRESS" ] && echo "$__stella_uri_address" && __printed="1"
					[ "ON" = "$OUTPUT_USER" ] && echo "$__stella_uri_user" && __printed="1"
					[ "ON" = "$OUTPUT_PASSWORD" ] && echo "$__stella_uri_password" && __printed="1"
					[ "ON" = "$OUTPUT_HOST" ] && echo "$__stella_uri_host" && __printed="1"
					[ "ON" = "$OUTPUT_PORT" ] && echo "$__stella_uri_port" && __printed="1"
					[ "ON" = "$OUTPUT_PATH" ] && echo "$__stella_uri_path" && __printed="1"
					[ "ON" = "$OUTPUT_QUERY" ] && echo "$__stella_uri_query" && __printed="1"
					[ "ON" = "$OUTPUT_FRAGMENT" ] && echo "$__stella_uri_fragment" && __printed="1"
					
					# at least by default print uri
					[ "$__printed" = "" ] && echo "$__stella_uri" && __printed="1"
				fi
			fi
		done
	done < /dev/stdin;
}



# http://wp.vpalos.com/537/uri-parsing-using-bash-built-in-features/ (customized)
# https://tools.ietf.org/html/rfc3986
# URI parsing function
#
# The function creates global variables with the parsed results.
# It returns 0 if parsing was successful or non-zero otherwise.
#
# [schema://][user[:password]@][host][:port][/path][?[arg1=val1]...][#fragment]
#
#  AVAILABLE OPTIONS
#		MODE :  * SIMPLE_VALIDATION : (default mode) will try to match each URI part from a simple regex by parsing input string
#				* STRICT_VALIDATION : will valid the input string against strict rules from rfc3986 and match each URI part (need url encoding for most of special characters to be an URI valid)
#				* MATCH_ONLY_STRICT_VALIDATION : will try to match URI parts with rules from rfc3986 from an input string. parts of the string illegals for an URI are cut
#  EXPRESSIONS
#
#  GENERIC type
#  pct-encoded = "%" HEXDIG HEXDIG
#  reserved    = gen-delims / sub-delims
#  gen-delims  = ":" / "/" / "?" / "#" / "[" / "]" / "@"
#  sub-delims  = "!" / "$" / "&" / "'" / "(" / ")"
#                  / "*" / "+" / "," / ";" / "="
#  unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
#  IP-literal = "[" ( IPv6address / IPvFuture  ) "]"
#  IPvFuture  = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )
#  pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
#
#  URI EXPRESSION
#  URI         = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
#  scheme      = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
#  authority   = [ userinfo "@" ] host [ ":" port ]
#  userinfo    = *( unreserved / pct-encoded / sub-delims / ":" )
#  host        = IP-literal / IPv4address / reg-name
#  reg-name    = *( unreserved / pct-encoded / sub-delims )
#  port        = *DIGIT
#  path        = *( "/" segment )
#  segment     = *pchar
#  query       = *( pchar / "/" / "?" )
#  fragment    = *( pchar / "/" / "?" )
__uri_parse() {
	__stella_uri="$1"

	local __mode="SIMPLE_VALIDATION"
	[ ! "$2" = "" ] && __mode="$2"

	local path
	local count
	local query

	# for a more restrictive ipv4 regexp see https://stackoverflow.com/a/36760050
	local class_ipv4='([0-9]{1,3}.){3}.([0-9]{1,3})'
	# see https://datatracker.ietf.org/doc/html/rfc2732 for ipv6 usage inside an URI
	local class_ipv6="\[[a-fA-F0-9.:]*\]"
	local class_scheme='-a-zA-Z0-9+.'
	local class_unreserved='-a-zA-Z0-9._~'
	local class_subdelims="!$&'\(\)*+,;="
	local class_pctencoded="\%a-fA-F0-9"
	local class_port='0-9'
	local class_pchar="${class_unreserved}${class_pctencoded}${class_subdelims}:@"
	local class_host="${class_ipv6}|${class_ipv4}|[${class_unreserved}${class_pctencoded}${class_subdelims}]*"
	#local class_host="${class_ipv6}|${class_ipv4}|[${class_unreserved}${class_subdelims}]*"
	local class_path_segment="\/[${class_pchar}]*"
	local class_query="\?[${class_pchar}\/?]*"
	local class_fragment="#[${class_pchar}\/?]*"


	local pattern
	case $__mode in
		SIMPLE_VALIDATION )
			pattern='^((['${class_scheme}']+):\/\/)?((([^:\/]+)(:([^@\/]*))?@)?([^:\/?]*)(:([0-9]+))?)(\/[^?#]*)?(\?[^#]*)?(#.*)?$'
			# computed value : ^(([-a-zA-Z0-9+.]+):\/\/)?((([^:\/]+)(:([^@\/]*))?@)?([^:\/?]*)(:([0-9]+))?)(\/[^?#]*)?(\?[^#]*)?(#.*)?$
		;;
		STRICT_VALIDATION )
			pattern='^((['${class_scheme}']+):\/\/)?((([^:\/]+)(:([^@\/]*))?@)?('${class_host}')(:(['${class_port}']+))?)(('${class_path_segment}')*)('${class_query}')?('${class_fragment}')?$'
		;;
		MATCH_ONLY_STRICT_VALIDATION )
			pattern='((['${class_scheme}']+):\/\/)?((([^:\/]+)(:([^@\/]*))?@)?('${class_host}')(:(['${class_port}']+))?)(('${class_path_segment}')*)('${class_query}')?('${class_fragment}')?'
		;;
	esac

	__stella_uri_schema=
	__stella_uri_address=
	__stella_uri_user=
	__stella_uri_password=
	__stella_uri_host=
	__stella_uri_port=
	__stella_uri_path=
	__stella_uri_query=
	__stella_uri_fragment=

	unset __stella_uri_parts[@]
	unset __stella_uri_args[@]
	for v in $(compgen -A variable | grep ^__stella_uri_arg_); do
			unset $v
	done


	if [[ ! ${__stella_uri} =~ ${pattern} ]]; then
		__stella_uri=
		return 1;
	fi

	case $__mode in
		SIMPLE_VALIDATION )
			__stella_uri=${BASH_REMATCH[0]}
			__stella_uri_schema=${BASH_REMATCH[2]}
			# in rfc it is called : authority
			__stella_uri_address=${BASH_REMATCH[3]}
			__stella_uri_user=${BASH_REMATCH[5]}
			__stella_uri_password=${BASH_REMATCH[7]}
			__stella_uri_host=${BASH_REMATCH[8]}
			__stella_uri_port=${BASH_REMATCH[10]}
			__stella_uri_path=${BASH_REMATCH[11]}
			__stella_uri_query=${BASH_REMATCH[12]}
			__stella_uri_fragment=${BASH_REMATCH[13]}
			;;
		MATCH_ONLY_STRICT_VALIDATION|STRICT_VALIDATION )
			# component extraction
			__stella_uri=${BASH_REMATCH[0]}
			__stella_uri_schema=${BASH_REMATCH[2]}
			# in rfc it is called : authority
			__stella_uri_address=${BASH_REMATCH[3]}
			__stella_uri_user=${BASH_REMATCH[5]}
			__stella_uri_password=${BASH_REMATCH[7]}
			__stella_uri_host=${BASH_REMATCH[8]}
			__stella_uri_port=${BASH_REMATCH[12]}
			__stella_uri_path=${BASH_REMATCH[13]}
			__stella_uri_query=${BASH_REMATCH[15]}
			__stella_uri_fragment=${BASH_REMATCH[16]}
			;;
	esac


	# path parsing
	count=0
	path="$__stella_uri_path"
	pattern='^/+([^/]+)'
	while [[ $path =~ $pattern ]]; do
			eval "__stella_uri_parts[$count]='${BASH_REMATCH[1]}'"
			path="${path:${#BASH_REMATCH[0]}}"
			#let count++
			count="$(( count + 1 ))"
	done

	# query parsing
	count=0
	query="$__stella_uri_query"
	pattern='^[?&]+([^= ]+)(=([^&]*))?'
	while [[ "$query" =~ $pattern ]]; do
			eval "__stella_uri_args[$count]='${BASH_REMATCH[1]}'"
			[ ! "${BASH_REMATCH[3]}" = "" ] && eval "__stella_uri_arg_${BASH_REMATCH[1]}='${BASH_REMATCH[3]}'"
			query="${query:${#BASH_REMATCH[0]}}"
			#let count++
			count=$(( count + 1 ))
	done

	# return success
	return 0
}

# [schema://][user@][host][:port][/abs_path|?rel_path]
# By default
# CACHE, WORKSPACE, ENV, GIT are excluded ==> use theses options to force include
# APP, WIN are included ==> uses these option to force exclude
# SUDO use sudo on the target
# FOLDER_CONTENT use this option to transfer content of stella folder only (not stella folder itself)
__transfer_stella() {
	local _uri="$1"
	local _OPT="$2"
	local _opt_ex_cache
	_opt_ex_cache="EXCLUDE /$(__abs_to_rel_path "$STELLA_INTERNAL_CACHE_DIR" "$STELLA_ROOT")/"
	local _opt_ex_workspace
	_opt_ex_workspace="EXCLUDE /$(__abs_to_rel_path "$STELLA_INTERNAL_WORK_ROOT" "$STELLA_ROOT")/"
	local _opt_ex_env
	_opt_ex_env="EXCLUDE /.stella-env"
	local _opt_ex_git
	_opt_ex_git="EXCLUDE /.git/"
	local _opt_ex_win
	_opt_ex_win=
	local _opt_ex_app
	_opt_ex_app=
	local _opt_sudo
	_opt_sudo=
	local _opt_folder_content
	_opt_folder_content=
	local _opt_delete_excluded=

	for o in $_OPT; do
		[ "$o" = "CACHE" ] && _opt_ex_cache=
		[ "$o" = "WORKSPACE" ] && _opt_ex_workspace=
		[ "$o" = "ENV" ] && _opt_ex_env=
		[ "$o" = "GIT" ] && _opt_ex_git=
		[ "$o" = "WIN" ] && _opt_ex_win="EXCLUDE /win/ EXCLUDE /stella.bat EXCLUDE /conf.bat"
		[ "$o" = "APP" ] && _opt_ex_app="EXCLUDE /app/"
		[ "$o" = "SUDO" ] && _opt_sudo="SUDO"
		[ "$o" = "FOLDER_CONTENT" ] && _opt_folder_content="FOLDER_CONTENT"
		[ "$o" = "DELETE_EXCLUDED" ] && _opt_delete_excluded="DELETE_EXCLUDED"
	done
	__log "DEBUG" "** ${_opt_sudo} Transfer stella to $_uri"
	__transfer_folder_rsync "$STELLA_ROOT" "$_uri" "$_opt_delete_excluded $_opt_ex_win $_opt_ex_app $_opt_ex_cache $_opt_ex_workspace $_opt_ex_env $_opt_ex_git $_opt_sudo $_opt_folder_content"
}



# ARG _folder folder to transfer
# ARG _uri target
# 	[schema://][user@][host][:port][/abs_path|?rel_path]
#		uri path must not finish with / or only folder content will be transfered, not folder itself
#	OPTIONS
# 		EXCLUDE (repeat this option for each exclude filter to set - path are absolute to the root of the folder to transfert. example : /workspace/)
# 		INCLUDE (This option override exclude rules. Repeat this option for each include filter to set - path are absolute to the root of the folder to transfert. example : /workspace/)
# 		FOLDER_CONTENT will transfer folder content not folder itself
# 		EXCLUDE_HIDDEN exclude hidden files
#
#	example
# __transfer_folder_rsync /foo/folder ssh://user@ip
#			here target host is 'ip'
#			here path is empty, so folder will be sync inside home directory of user as /home/user/folder
# __transfer_folder_rsync /foo/folder ssh://user@ip/path
#			transfert /foo/folder to host 'ip' into absolute path '/path'
# __transfer_folder_rsync /foo/folder vagrant://default
#			use ssh configuration of vagrant to connect to machine named 'default'
# __transfer_folder_rsync /foo/folder local://../path OR __transfer_folder_rsync /foo/folder ../path
__transfer_folder_rsync() {
	local _folder="$1"
	local _uri="$2"
	local _opt="$3"
	__transfer_rsync "FOLDER" "$_folder" "$_uri" "$_opt"
}


# ARG _file file to transfer
# ARG _uri target
# 		[schema://][user@][host][:port][/abs_path|?rel_path]
#			if uri path end with a "/" it will be a destination folder, else it will be the name of the transfered file
#	OPTIONS
#			SUDO use sudo while transfering to uri
#
# example
# __transfer_file_rsync /foo/file1 ssh://user@ip/?folder/file2
#			file1 will be sync inside home directory of user as /home/user/folder/file2
__transfer_file_rsync() {
	local _file="$1"
	local _uri="$2"
	local _opt="$3"

	__log "DEBUG" "** Transfer file $_file to $_uri"
	__transfer_rsync "FILE" "$_file" "$_uri" "$_opt"
}


# ARG mode FOLDER|FILE
# ARG source
# ARG uri
#			[schema://][user@][host][:port][/abs_path|?rel_path]
# 		path could be absolute path in the target system
# 		or could be relavite path to a default folder
# 		default schema is local
#			available schemas
#					ssh://user@host:port[/abs_path|?rel_path]
#					vagrant://vagrant-machine[/abs_path|?rel_path]
#					local://[/abs_path|[?]rel_path]  ==> with local:// char '?' is optionnal to use relative_path
#
#	NOTE : use ssh shared connection by default
#
#	OPTIONS
# 		EXCLUDE (repeat this option for each exclude filter to set - path are absolute to the root of the folder to transfert. example : /workspace/)
# 		INCLUDE (This option override exclude rules. Repeat this option for each include filter to set - path are absolute to the root of the folder to transfert. example : /workspace/)
# 		FOLDER_CONTENT will transfer folder content not folder itself
# 		EXCLUDE_HIDDEN exclude hidden files
#			SUDO use sudo while transfering to uri
#			COPY_LINKS copy real files linked by a symlink instead of the symlink
#			DELETE_EXCLUDED delete excluded files on the target
__transfer_rsync() {
	local _mode="$1"
	local _source="$2"
	local _uri="$3"
	local _OPT="$4"


	local _flag_exclude=OFF
	local _exclude=
	local _flag_include=OFF
	local _include=
	local _opt_folder_content=OFF
	local _opt_sudo=OFF
	local _opt_exclude_hidden=OFF
	local _opt_copy_links=OFF
	local _opt_delete_excluded=OFF
	for o in $_OPT; do
		[ "$_flag_exclude" = "ON" ] && _exclude="$o $_exclude" && _flag_exclude=OFF
		[ "$o" = "EXCLUDE" ] && _flag_exclude=ON
		[ "$_flag_include" = "ON" ] && _include="$o $_include" && _flag_include=OFF
		[ "$o" = "INCLUDE" ] && _flag_include=ON
		[ "$o" = "FOLDER_CONTENT" ] && _opt_folder_content=ON
		[ "$o" = "EXCLUDE_HIDDEN" ] && _opt_exclude_hidden=ON
		[ "$o" = "SUDO" ] && _opt_sudo=ON
		[ "$o" = "COPY_LINKS" ] && _opt_copy_links=ON
		[ "$o" = "DELETE_EXCLUDED" ] && _opt_delete_excluded=ON
	done

	# NOTE : rsync needs to be present on both host (source AND target)
	__require "rsync" "rsync"

	__uri_parse "$_uri"

	[ "$__stella_uri_schema" = "" ] && __stella_uri_schema="local"

	local _local_filesystem="OFF"
	if [ "$__stella_uri_schema" = "local" ]; then
		_local_filesystem="ON"
	fi

	if [ "$__stella_uri_schema" = "ssh" ]; then
		__require "ssh" "ssh"
		_ssh_port="22"
		[ ! "$__stella_uri_port" = "" ] && _ssh_port="$__stella_uri_port"
	fi

	if [ "$__stella_uri_schema" = "vagrant" ]; then
		__vagrant_ssh_opt="$(__vagrant_get_ssh_options "$__stella_uri_host")"
		#__vagrant_ssh_opt="$(vagrant ssh-config $__stella_uri_host | sed '/^[[:space:]]*$/d' |  awk '/^Host .*$/ { detected=1; }  { if(start) {print " -o "$1"="$2}; if(detected) start=1; }')"
		__stella_uri_host="localhost"
	fi


	local _target=
	local _target_path=


	if [ "$_local_filesystem" = "ON" ]; then
		_target="$(__uri_get_path "$_uri")"
		_target_path="$_target"
	fi

	if [ "$_local_filesystem" = "OFF" ]; then
		_target="$(__uri_get_path "$_uri")"
		_target_path="$_target"
		_target_address="$__stella_uri_host"
		[ ! "$__stella_uri_user" = "" ] && _target_address="$__stella_uri_user"@"$_target_address"

		_target="$_target_address":"$_target"
	fi

	local _base_folder=
	local _opt_include=
	local _opt_exclude=
	local _opt_links=
	[ "$_opt_copy_links" = "ON" ] && _opt_links="--copy-links  --keep-dirlinks"
	[ "$_opt_delete_excluded" = "ON" ] && _opt_exclude="--delete-excluded $_opt_exclude"

	case $_mode in
		FOLDER )
				# _source must not finish with / or only folder content will be transfered, not folder itself
				if [ "$_opt_folder_content" = "ON" ]; then
					_source="$_source/"
				else
					_source="${_source%/}"
					_base_folder="/$(basename "${_source}")/"
				fi

				for o in $_include; do
					_opt_include="--include=$(echo $_base_folder$o | sed 's,//,/,') $_opt_include"
				done

				for o in $_exclude; do
					_opt_exclude="--exclude=$(echo $_base_folder$o | sed 's,//,/,') $_opt_exclude"
				done
				[ "$_opt_exclude_hidden" = "ON" ] && _opt_exclude="$_opt_exclude --exclude=${_base_folder}.*"

			;;
		FILE )
			;;
	esac

	# NOTE : rsync do not create parent folders of the target. It creates only last level
	#				solution ; http://www.schwertly.com/2013/07/forcing-rsync-to-create-a-remote-path-using-rsync-path/
	# NOTE : rxync progress option https://serverfault.com/questions/219013/showing-total-progress-in-rsync-is-it-possible
	#				--info=progress2 --no-inc-recursive is not portable because it needs a minimum version of rsync
	# NOTE : rsync + ssh + sudo
	#				https://serverfault.com/questions/534683/rsync-over-ssh-getting-no-tty-present
	#				https://superuser.com/questions/270911/run-rsync-with-root-permission-on-remote-machine
	# NOTE : rsync -l (--links) option keep symlink as is
	#	 rsync -a option include -l (--links)
	case $__stella_uri_schema in
		ssh )
			if [ "$_opt_sudo" = "ON" ]; then
				__log "DEBUG" "__sudo_ssh_begin_session $_uri"
				__sudo_ssh_begin_session "$_uri"
				rsync $_opt_links $_opt_include $_opt_exclude --rsync-path='sudo -Es mkdir -p '$_target_path'; sudo -Es rsync' --no-owner --no-group --force --delete -prltD -vz -e "ssh -o ControlPath=~/.ssh/%r@%h-%p -o ControlMaster=auto -o ControlPersist=60 -p $_ssh_port" "$_source" "$_target"
				__log "DEBUG" "__sudo_ssh_end_session $_uri"
				__sudo_ssh_end_session "$_uri"
			fi
			[ "$_opt_sudo" = "OFF" ] && rsync $_opt_links $_opt_include $_opt_exclude --rsync-path="mkdir -p '$(dirname "${_target_path}")'; rsync" --no-owner --no-group --force --delete -prltD -vz -e "ssh -o ControlPath=~/.ssh/%r@%h-%p -o ControlMaster=auto -o ControlPersist=60 -p $_ssh_port" "$_source" "$_target"
			;;
		vagrant )
			if [ "$_opt_sudo" = "ON" ]; then
				__sudo_ssh_begin_session "$_uri"
				rsync $_opt_links $_opt_include $_opt_exclude --rsync-path="sudo -Es mkdir -p '$_target_path'; sudo -Es rsync" --no-owner --no-group --force --delete -prltD -vz -e "ssh -o ControlPath=~/.ssh/%r@%h-%p -o ControlMaster=auto -o ControlPersist=60 $__vagrant_ssh_opt" "$_source" "$_target"
				__sudo_ssh_end_session "$_uri"
			fi
			[ "$_opt_sudo" = "OFF" ] && rsync $_opt_links $_opt_include $_opt_exclude --rsync-path="mkdir -p '$(dirname "${_target_path}")'; rsync" --no-owner --no-group --force --delete -prltD -vz -e "ssh $__vagrant_ssh_opt -o ControlPath=~/.ssh/%r@%h-%p -o ControlMaster=auto -o ControlPersist=60" "$_source" "$_target"
			;;
		local )
			if [ "$_source" = "$_target" ]; then
				__log "INFO" " ** source $_source and target $_target are equivalent, so no transfer"
			else
				# '--rsync-path' option seems to not work when we are on the same host (local)
				if [ "$_opt_sudo" = "ON" ]; then
					sudo -E mkdir -p "$(dirname "${_target_path}")"
					sudo -E rsync $_opt_links $_opt_include $_opt_exclude --force --delete -avz "$_source" "$_target"
				fi
				if [ "$_opt_sudo" = "OFF" ]; then
					mkdir -p "$(dirname "${_target_path}")"
					rsync $_opt_links $_opt_include $_opt_exclude --force --delete -avz "$_source" "$_target"
				fi
			fi
			;;
		*)
			echo "** ERROR protocol unknown"
			;;
	esac
}


__daemonize() {
	local _item_path="$1"
	local _log_file="$2"

	if [ "$_log_file" = "" ]; then
		nohup -- $_item_path 1>/dev/null 2>&1 &
	else
		nohup -- $_item_path 1>$_log_file 2>&1 &
	fi

}

__get_active_path() {
	echo "$PATH"
}


# filter a list with include and exclude elements
# alternative : __filter_list_with_list 
__filter_list() {
	local _list="$1"
	local _opt="$2"

	local _result_list=

	[ -z "$_list" ] && return

	# INCLUDE_TAG -- option name of include option -- must be setted before using	 INCLUDE_TAG
	# EXCLUDE_TAG -- option name of exclude option -- must be setted before using EXCLUDE_TAG
	# ${INCLUDE_TAG} <expr> -- include these items
	# ${EXCLUDE_TAG} <expr> -- exclude these items
	# ${INCLUDE_TAG} is apply first, before ${EXCLUDE_TAG}

	local _tag_include=
	local _flag_tag_include=OFF
	local _tag_exclude=
	local _flag_tag_exclude=OFF
	local _flag_exclude_filter=OFF
	local _exclude_filter=
	local _invert_filter=
	local _flag_include_filter=OFF
	local _include_filter=
	local _opt_filter=OFF
	for o in $_opt; do
		[ "$_flag_include_filter" = "ON" ] && _include_filter="$o" && _flag_include_filter=OFF
		[ ! "$_tag_include" = "" ] && [ "$o" = "$_tag_include" ] && _flag_include_filter=ON && _opt_filter=ON
		[ "$_flag_exclude_filter" = "ON" ] && _exclude_filter="$o" && _flag_exclude_filter=OFF
		[ ! "$_tag_exclude" = "" ] && [ "$o" = "$_tag_exclude" ] && _flag_exclude_filter=ON && _invert_filter="-Ev" && _opt_filter=ON
		[ "$_flag_tag_include" = "ON" ] && _tag_include="$o" && _flag_tag_include=OFF
		[ "$o" = "INCLUDE_TAG" ] && _flag_tag_include=ON
		[ "$_flag_tag_exclude" = "ON" ] && _tag_exclude="$o" && _flag_tag_exclude=OFF
		[ "$o" = "EXCLUDE_TAG" ] && _flag_tag_exclude=ON
	done

	if [ "$_opt_filter" = "OFF" ]; then
		echo "$_list"
	else
		for l in $_list; do
			[ -z "$(echo "$l" | grep -E "$_include_filter" | grep $_invert_filter "$_exclude_filter")" ] || _result_list="$_result_list $l"
		done
		echo "$_result_list"
	fi
}



# filter a list with items of another list
# FILTER_REMOVE option (by default) :  will remove from __list_src items present in __list_filter
# FILTER_KEEP option : will remove from __list_src items not present in __list_filter
# alternative : __filter_list
__filter_list_with_list() {
	local __list_src="$1"
	local __list_filter="$2"
	local __opt="$3"

	local __opt_keep=
	for o in ${__opt}; do
		[ "$o" = "FILTER_REMOVE" ] && __opt_keep=
		[ "$o" = "FILTER_KEEP" ] && __opt_keep="ON"
	done

	[ -z "${__list_src}" ] && return

	if [ "$__opt_keep" = "ON" ]; then
		[ -z "${__list_filter}" ] && return
	else
		[ -z "${__list_filter}" ] && echo -n "${__list_src}" && return
	fi

	local __result_list=
	if [ "$__opt_keep" = "ON" ]; then
		for s in ${__list_src}; do
			[[ " ${__list_filter} " =~ .*\ "${s}"\ .* ]] && __result_list="${__result_list} ${s}"
		done
	else
		for s in ${__list_src}; do
			[[ " ${__list_filter} " =~ .*\ "${s}"\ .* ]] || __result_list="${__result_list} ${s}"
		done
	fi

	# remove trailing whitespace and return list
	echo -n "${__result_list%"${__result_list##*[![:space:]]}"}"
}


# http://stackoverflow.com/questions/369758/how-to-trim-whitespace-from-a-bash-variable
__trim3() {
	echo -e "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

# trim whitespace
__trim2() {
	echo $(echo "$1" | sed -e 's/^ *//' -e 's/ *$//')
}

__trim() {
    local var="$*"
    var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
    echo -n "$var"
}

# http://stackoverflow.com/a/20460402
__string_contains() { [ -z "${1##*$2*}" ] && [ -n "$1" -o -z "$2" ]; }

# return 0 if list contains items, else 1
# __list_contains "aa bb xx" "bb"
# echo $? ==> 0
# __list_contains "aa bb xx" "b"
# echo $? ==> 1
# __list_contains "aa bb xx" "bb xx"
# echo $? ==> 0
# __list_contains "aa bb xx" "aa xx"
# echo $? ==> 1
# https://stackoverflow.com/a/20473191/5027535
# in a test : 
# if $STELLA_API list_contains "aa bb xx" "bb"; then
# fi
__list_contains() {
	local _list="$1"
	local _item="$2"
	[ "$_list" = "" ] && return 1
	[[ "$_list" =~ (^|[[:space:]])"$_item"($|[[:space:]]) ]]
}

# remove duplicate values in list and return it sorted
# result="$(__list_filter_duplicate "aa b bb aa ddd aaa cc bb aa")"
# echo $result
# aa aaa b bb cc ddd
__list_filter_duplicate() {
	local _list="$1"
	# this alter order do not use :s
	#_list="$(printf '%s\n' ${_list} | sort | uniq | tr '\n' ' ')"

	_list="$(printf '%s\n' ${_list} | awk '!tab[$0]++' | tr '\n' ' ')"

	# remove trailing whitespace and return list
	echo -n "${_list%"${_list##*[![:space:]]}"}"
}

__get_stella_version() {
	local _stella_root_="$1"

	[ "$_stella_root_" = "" ] && _stella_root_="$STELLA_ROOT"

	_s_flavour=$(__get_stella_flavour "$_stella_root_")

	case "$_s_flavour" in
		STABLE)
				cat "$_stella_root_/VERSION"
		;;

		DEV)
				echo "$(__git_project_version "$_stella_root_" "LONG")"
		;;

		*)
				echo "unknown"
		;;

	esac
}


# return STABLE or DEV
__get_stella_flavour() {
	local _stella_root_="$1"
	[ "$_stella_root_" = "" ] && _stella_root_="$STELLA_ROOT"

	local _s_flavour=unknown

	[ -f "$_stella_root_/VERSION" ] && _s_flavour="STABLE"
	[ -d "$_stella_root_/.git" ] && _s_flavour="DEV"

	echo $_s_flavour
}

# return 0 if empty or do not exist, 1 otherwize
__is_dir_empty() {
	[ ! -d "$1" ] && return 0
	return $([ -z "$(ls -A "$1" 2>/dev/null)" ])
}

# To get: /tmp/my.dir (like dirname)
# path = ${foo%/*}
# To get: filename.tar.gz (like basename)
# file = ${foo##*/}
# To get: filename
# base = ${file%%.*}
__get_path_from_string() {
	if [ "$1" = "${1%/*}" ]; then
		echo "."
	else
		echo ${1%/*}
	fi
}

__get_filename_from_string() {
	echo ${1##*/}
}

__get_filename_from_url() {
	local _AFTER_SLASH
	_AFTER_SLASH=${1##*/}
	echo ${_AFTER_SLASH%%\?*}
}

__get_extension_from_string() {
	local _AFTER_DOT
	_AFTER_DOT=${1##*\.}
	echo $_AFTER_DOT
	#echo ${_AFTER_DOT%%\?*}
}


# NOTE : alternative : [ -z "${_path##/*}" ]
__is_abs() {
	local _path="$1"

	case $_path in
		/*)
			echo "TRUE"
			;;
		*)
			echo "FALSE"
			;;
	esac
}

# search a specific folder starting from a root folder and searching in parent folder
__find_folder_up() {
	local _root="$1"
	local _search="$2"

	cwd="$_root"
	while [ ! -d "$cwd/$_search" ] && [ "x$cwd" != x/ ]; do
		cwd=`dirname "$cwd"`
	done
	if [ -d "$cwd/$_search" ]; then
		echo "$cwd/$_search"
	else
		echo
	fi
}

# NOTE : paths do not have to exist
# if path are relative, they are resolved accordingly to current path
# __is_logical_equalpath / / ==> TRUE
# __is_logical_equalpath / /foo ==> FALSE
# __is_logical_equalpath /foo1 /foo1/foo2 ==> FALSE
# __is_logical_equalpath /foo /foo ==> TRUE
# __is_logical_equalpath /foo /foo/ ==> FALSE
# __is_logical_equalpath /foo/ /foo ==> FALSE
# __is_logical_equalpath /foo/ /foo/ ==> TRUE
# __is_logical_equalpath /foo /foo/file ==> FALSE
__is_logical_equalpath() {
	local _path1="$1"
	local _path2="$2"

	local _result

	if [ "$_path1" = "$_path2" ]; then
		_result="TRUE"
	else
		_path1="$(__rel_to_abs_path "$_path1")"
		_path2="$(__rel_to_abs_path "$_path2")"
		if [ "${_path1}" = "${_path2}" ]; then
			_result="TRUE"
		else
			_result="FALSE"
		fi
	fi
	echo "$_result"
}

# NOTE : paths do not have to exist
# if path are relative, they are resolved accordingly to current path
# __is_logical_subpath / / ==> FALSE
# __is_logical_subpath / /foo ==> TRUE
# __is_logical_subpath /foo1 /foo1/foo2 ==> TRUE
# __is_logical_subpath /foo /foo ==> FALSE
# __is_logical_subpath /foo /foo/ ==> TRUE
# __is_logical_subpath /foo/ /foo ==> FALSE
# __is_logical_subpath /foo/ /foo/ ==> FALSE
# __is_logical_subpath /foo /foo/file ==> TRUE
__is_logical_subpath() {
	local _root="$1"
	local _subpath="$2"

	local _result

	if [ "$_root" = "/" ]; then
		if [ "$_subpath" = "/" ]; then
			_result="FALSE"
		else
			_result="TRUE"
		fi
	else
		_root="$(__rel_to_abs_path "$_root")"
		_subpath="$(__rel_to_abs_path "$_subpath")"
		if [ "${_subpath}" = "${_root}" ]; then
			_result="FALSE"
		else
			if [ "${_subpath}" = "${_root}/" ]; then
				_result="TRUE"
			else
				if [ ! "${_subpath##$_root/}" = "$_subpath" ]; then
					_result="TRUE"
				else
					_result="FALSE"
				fi
			fi
		fi
	fi
	echo "$_result"
}

# NOTE by default path is determined giving by the current running directory
__rel_to_abs_path() {
	local _rel_path="$1"
	local _abs_root_path="$2"
	local result

	if [ "$_abs_root_path" = "" ]; then
		_abs_root_path=$STELLA_CURRENT_RUNNING_DIR
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

# NOTE : http://stackoverflow.com/a/13599997
# NOTE : use basename/dirname/readlink : follow symlink
# NOTE : readlink option -m do not exists on some version
__rel_to_abs_path_alternative_2(){
	local _rel_path=$1
	local _abs_root_path=$2

	local F="$_abs_root_path/$_rel_path"

	#echo "$(dirname "$(readlink -e $F))"/$(basename $F)"
	echo "$(readlink -m "$F")"

}


# NOTE use a subprocess, cd and pwd
# NOTE resolve symlinks
# NOTE but all paths must exist !
__rel_to_abs_path_alternative_3() {
	local _rel_path=$1
	local _abs_root_path=$2

	echo "$(cd "$_abs_root_path/$_rel_path" && pwd -P)"
}


# How to go from _abs_path_root (ARG2) to _abs_path_to_translate (ARG1)
# example :
#	ARG1 /path1
#	ARG2 /path1/path2
# result ..
# cd /path1/path2/.. is equivalent to /path1
# NOTE by default relative to current running directory
__abs_to_rel_path() {
	local _abs_path_to_translate="$1"/
	local _abs_path_root="$2"

	local result=""

	if [ "${_abs_path_root}" = "" ]; then
		_abs_path_root="${STELLA_CURRENT_RUNNING_DIR}"
	fi

	_abs_path_root="${_abs_path_root}"/

	local common_part="${_abs_path_root}" # for now

	if [ "$(__is_abs ${_abs_path_to_translate})" = "FALSE" ]; then
		result="${_abs_path_to_translate}"
	else

		case ${_abs_path_root} in
			/*)
				while [ "${_abs_path_to_translate#$common_part}" = "${_abs_path_to_translate}" ]; do
					# no match, means that candidate common part is not correct
					# go up one level (reduce common part)
					common_part="$(dirname "${common_part}")"

					# and record that we went back
					if [ -z "${result}" ]; then
						result=".."
					else
						result="../${result}"
					fi

				done

				if [ "${common_part}" = "/" ]; then
					# special case for root (no common path)
					result="${result}/"
				fi


				# since we now have identified the common part,
				# compute the non-common part
				forward_part="${_abs_path_to_translate#$common_part}"
				if [[ -n ${result} ]] && [[ -n ${forward_part} ]]; then
					result="${result}${forward_part}"
				elif [[ -n ${forward_part} ]]; then
					result="${forward_part}"

				else
					if [[ ! -n ${result} ]] && [[ "${common_part}" == "${_abs_path_to_translate}" ]]; then
						result="."
					fi
				fi
				;;

			*)
				result="${_abs_path_to_translate}"
				;;
		esac
	fi

	if [ "${result:(-1)}" = "/" ]; then
		result="${result%?}"
	fi
	echo "${result}"

}



# This function transform any absolute symlink into a relative symlink
# ARG _target convert this - could be a folder or a symlink
# OPTIONS
#       ONLY_LINKED_TO_SUBPATH_OF <path> : convert only absolute link which point to a subpath of a path given as option arg, do not convert the others link.
# NOTE : some other implementation use readlink --relative-to which is not portable
__symlink_abs_to_rel_path() {
        local _target="$1"
        local _opt="$2"

        local _linked_target
        local _linked_target_abs
        local _symlink
        local _only_subpath_link=OFF
        local _path=
        for o in ${_opt}; do
                [ "$_only_subpath_link" = "ON" ] && _path="$o"
                [ "$o" = "ONLY_LINKED_TO_SUBPATH_OF" ] && _only_subpath_link="ON"
        done

        _target="$(__rel_to_abs_path "${_target}")"
        find "${_target}" -lname "/*" 2>/dev/null | while read _symlink; do \
                        _linked_target_abs="$(readlink "${_symlink}")"; \
                        _result1="TRUE"; _result2="TRUE"; \
                        [ "${_only_subpath_link}" = "ON" ] && _result1=$(__is_logical_subpath "${_path}" "${_linked_target_abs}"); \
                        [ "${_result1}" = "FALSE" ] && _result2=$(__is_logical_equalpath "${_path}" "${_linked_target_abs}"); \
                        [ "${_result2}" = "TRUE" ] && _linked_target="$(__abs_to_rel_path "$(readlink "${_symlink}")" "$(dirname "${_symlink}")")" || continue; \
                        echo "* CONVERT ${_symlink} LINKED to ${_linked_target_abs} INTO ${_linked_target}"; rm "${_symlink}"; ln -sf "${_linked_target}" "${_symlink}"; done
}





# init stella environment
__init_stella_env() {
	__feature_init_installed
	# PROXY
	__init_proxy
}

#MEASURE TOOL----------------------------------------------
# __timecount_start "count_id"
__timecount_start() {
	local _count_name_var=$1
	local _id=$RANDOM$RANDOM

	eval __stella_timecount_$_id="$(date +%s)"
	eval $_count_name_var="__stella_timecount_$_id"

}

# elapsed_time=$(__timecount_stop "count_id")
__timecount_stop() {
	local _end_count="$(date +%s)"
	local _ellapsed=
	local _tmp="$1"
	local _start_count=${!_tmp}

	local _ellapsed=$(echo "$_end_count - ${!_start_count}" | bc)
	echo $_ellapsed
}


#FILE TOOLS----------------------------------------------
#http://stackoverflow.com/a/17902999/5027535
__count_folder_item() {
	local _path="$1"
	local _filter="$2"

	if [ "$_filter" = "" ]; then

		_filter="*"
	fi

	local files=$(shopt -s nullglob dotglob; echo $_path/$_filter)
	echo ${#files[@]}

}

__del_folder() {
	echo "** Deleting $1 folder"
	[ -d $1 ] && rm -Rf $1
}

# copy content of folder ARG1 into folder ARG2
__copy_folder_content_into() {
	local source="$1"
	local dest="$2"
	local select_filter="$3"
	if [ "$select_filter" = "" ]; then
		select_filter="*"
	fi
	if [ -d "$source" ]; then
		if [ $(__count_folder_item $1 $select_filter) -gt 0 ]; then
			mkdir -p "$dest"
			if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
				cp -fa "$source/"$select_filter "$dest"
			else
				cp -fa "$source/"$select_filter --target-directory="$dest"
			fi
		fi
	fi
}


#RESSOURCES MANAGEMENT ---------------------------------------------------
__get_resource() {
	local OPT="$5"
	OPT="$OPT GET"
	__resource "$1" "$2" "$3" "$4" "$OPT"
}

__update_resource() {
	local OPT="$5"
	OPT="$OPT UPDATE"
	__resource "$1" "$2" "$3" "$4" "$OPT"
}

__delete_resource() {
	local OPT="$5"
	OPT="$OPT DELETE"
	__resource "$1" "$2" "$3" "$4" "$OPT"
}

__revert_resource() {
	local OPT="$5"
	OPT="$OPT REVERT"
	__resource "$1" "$2" "$3" "$4" "$OPT"
}

__resource() {
	local NAME="$1"
	local URI="$2"
	local PROTOCOL="$3"
	# FINAL_DESTINATION is the folder inside which one the resource will be put
	local FINAL_DESTINATION="$4"
	local OPT="$5"
	# option should passed as one string "OPT1 OPT2"
	# 	"MERGE" for merge in FINAL_DESTINATION
	# 	"STRIP" for remove root folder and copy content of root folder in FINAL_DESTINATION
	# 	"FORCE_NAME" force name of downloaded file
	# 	"GET" get resource (action by default)
	# 	"UPDATE" pull and update resource (only for HG or GIT)
	# 	"REVERT" complete revert of the resource (only for HG or GIT)
	# 	"DELETE" delete resource
	#  	"VERSION" retrieve specific version (only for HG or GIT) when GET or UPDATE
	#		"DEST_ERASE" when GET, will erase FINAL_DESTINATION first
	# TODO : remove illegal characters in NAME. NAME is used in flag file name when merging

	local _opt_merge=OFF
	local _opt_strip=OFF
	local _opt_get=ON
	local _opt_delete=OFF
	local _opt_update=OFF
	local _opt_revert=OFF
	local _opt_force_name=OFF
	local _opt_version=OFF
	local _opt_dest_erase=OFF
	local _checkout_version=
	local _download_filename=_AUTO_
	for o in $OPT; do
		if [ "$_opt_force_name" = "ON" ]; then
			_download_filename=$o
			_opt_force_name=OFF
		else
			if [ "$_opt_version" = "ON" ]; then
				_checkout_version=$o
				_opt_version=OFF
			else
				[ "$o" = "VERSION" ] && _opt_version=ON
				[ "$o" = "MERGE" ] && _opt_merge=ON
				[ "$o" = "DEST_ERASE" ] && _opt_dest_erase=ON
				[ "$o" = "STRIP" ] && _opt_strip=ON
				[ "$o" = "FORCE_NAME" ] && _opt_force_name=ON
				if [ "$o" = "DELETE" ]; then _opt_delete=ON;  _opt_revert=OFF;  _opt_get=OFF; _opt_update=OFF; fi
				if [ "$o" = "UPDATE" ]; then _opt_update=ON;  _opt_revert=OFF;  _opt_get=OFF; _opt_delete=OFF; fi
				if [ "$o" = "REVERT" ]; then _opt_revert=ON;  _opt_update=OFF;  _opt_get=OFF; _opt_delete=OFF; fi
			fi
		fi
	done

	[ "$_opt_revert" = "ON" ] && __log "INFO" " ** Reverting resource :"
	[ "$_opt_update" = "ON" ] && __log "INFO" " ** Updating resource :"
	[ "$_opt_delete" = "ON" ] && __log "INFO" " ** Deleting resource :"
	[ "$_opt_get" = "ON" ] && __log "INFO" " ** Getting resource :"
	[ ! "$FINAL_DESTINATION" = "" ] && __log "INFO" " $NAME in $FINAL_DESTINATION" || __log "INFO" " $NAME"

	#[ "$FORCE" ] && rm -Rf $FINAL_DESTINATION
	if [ "$_opt_get" = "ON" ]; then
		#if [ "$FORCE" ]; then
		#	[ "$_opt_merge" = "OFF" ] && rm -Rf "$FINAL_DESTINATION"
		#	[ "$_opt_merge" = "ON" ] && rm -f "$FINAL_DESTINATION/._MERGED_$NAME"
		#fi
		if [ "$_opt_dest_erase" = "ON" ]; then
			[ "$_opt_merge" = "OFF" ] && rm -Rf "$FINAL_DESTINATION"
			[ "$_opt_merge" = "ON" ] && rm -f "$FINAL_DESTINATION/._MERGED_$NAME"
		fi
	fi


	if [ "$_opt_delete" = "ON" ]; then
		[ "$_opt_merge" = "OFF" ] && rm -Rf "$FINAL_DESTINATION"
		[ "$_opt_merge" = "ON" ] && rm -f "$FINAL_DESTINATION/._MERGED_$NAME"
		_FLAG=0
	fi

	if [ "$_opt_delete" = "OFF" ]; then
		# strip root folder mode
		_STRIP=
		[ "$_opt_strip" = "ON" ] && _STRIP="STRIP"


		_FLAG=1
		case ${PROTOCOL} in
			HTTP_ZIP|FILE_ZIP )
				[ "$_opt_revert" = "ON" ] && __log "INFO" "REVERT Not supported with this protocol" && _FLAG=0
				[ "$_opt_update" = "ON" ] && __log "INFO" "UPDATE Not supported with this protocol" && _FLAG=0
				if [ -d "$FINAL_DESTINATION" ]; then
					if [ "$_opt_get" = "ON" ]; then
						if [ "$_opt_merge" = "ON" ]; then
							if [ -f "$FINAL_DESTINATION/._MERGED_$NAME" ]; then
								__log "INFO" " ** Ressource already merged"
								_FLAG=0
							fi
						fi
						if [ "$_opt_strip" = "ON" ]; then
							#__log " ** Ressource already stripped"
							__log "INFO" " ** Destination folder exist"
							#_FLAG=0
						fi
					fi
				fi
				;;
			HTTP|FILE )
				[ "$_opt_strip" = "ON" ] && __log "INFO" "STRIP option not in use"
				[ "$_opt_revert" = "ON" ] && __log "INFO" "REVERT Not supported with this protocol" && _FLAG=0
				[ "$_opt_update" = "ON" ] && __log "INFO" "UPDATE Not supported with this protocol" && _FLAG=0

				if [ -d "$FINAL_DESTINATION" ]; then
					if [ "$_opt_get" = "ON" ]; then
						if [ "$_opt_merge" = "ON" ]; then
							if [ -f "$FINAL_DESTINATION/._MERGED_$NAME" ]; then
								__log "INFO" " ** Ressource already merged"
								_FLAG=0
							fi
						fi
					fi
				fi
				;;
			HG|GIT )
				[ "$_opt_strip" = "ON" ] && __log "INFO" "STRIP option not supported with this protocol"
				[ "$_opt_merge" = "ON" ] && __log "INFO" "MERGE option not supported with this protocol"
				if [ -d "$FINAL_DESTINATION" ]; then
					if [ "$_opt_get" = "ON" ]; then
						__log "INFO" " ** Ressource already exist"
						_FLAG=0
					fi
				else
					[ "$_opt_revert" = "ON" ] && __log "INFO" " ** Ressource does not exist" && _FLAG=0
					[ "$_opt_update" = "ON" ] && __log "INFO" " ** Ressource does not exist" && _FLAG=0
				fi
				;;
		esac
	fi

	if [ "$_FLAG" = "1" ]; then
		[ ! -d $FINAL_DESTINATION ] && mkdir -p $FINAL_DESTINATION

		case ${PROTOCOL} in
			HTTP_ZIP )
				if [ "$_opt_get" = "ON" ]; then __download_uncompress "$URI" "$_download_filename" "$FINAL_DESTINATION" "$_STRIP"; fi
				if [ "$_opt_merge" = "ON" ]; then echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"; fi
				;;
			HTTP )
				# HTTP protocol use always merge by default : because it never erase destination folder
				# but the 'merged' flag file will be created only if we pass the option MERGE
				if [ "$_opt_get" = "ON" ]; then __download "$URI" "$_download_filename" "$FINAL_DESTINATION"; fi
				if [ "$_opt_merge" = "ON" ]; then echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"; fi
				;;
			HG )
				if [ "$_opt_revert" = "ON" ]; then cd "$FINAL_DESTINATION"; hg revert --all -C; fi
				if [ "$_opt_update" = "ON" ]; then cd "$FINAL_DESTINATION"; hg pull; hg update $_checkout_version; fi
				if [ "$_opt_get" = "ON" ]; then hg clone $URI "$FINAL_DESTINATION"; if [ ! "$_checkout_version" = "" ]; then cd "$FINAL_DESTINATION"; hg update $_checkout_version; fi; fi
				# [ "$_opt_merge" = "ON" ] && echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"
				;;
			GIT )
				__require "git" "git" "SYSTEM"
				if [ "$_opt_revert" = "ON" ]; then cd "$FINAL_DESTINATION"; git reset --hard; fi
				if [ "$_opt_update" = "ON" ]; then cd "$FINAL_DESTINATION"; git pull;if [ ! "$_checkout_version" = "" ]; then git checkout $_checkout_version; fi; fi
				if [ "$_opt_get" = "ON" ]; then git clone --recursive $URI "$FINAL_DESTINATION"; if [ ! "$_checkout_version" = "" ]; then cd "$FINAL_DESTINATION"; git checkout $_checkout_version; fi; fi
				# [ "$_opt_merge" = "ON" ] && echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"
				;;
			FILE )
				if [ "$_opt_get" = "ON" ]; then __copy_folder_content_into "$URI" "$FINAL_DESTINATION"; fi
				if [ "$_opt_merge" = "ON" ]; then echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"; fi
				;;
			FILE_ZIP )
				__uncompress "$URI" "$FINAL_DESTINATION" "$_STRIP"
				if [ "$_opt_merge" = "ON" ]; then echo 1 > "$FINAL_DESTINATION/._MERGED_$NAME"; fi
				;;
			* )
				__log "INFO" " ** ERROR Unknow protocol"
				;;
		esac
	fi
}

# DOWNLOAD AND ZIP FUNCTIONS---------------------------------------------------
__download_uncompress() {
	local URL
	local FILE_NAME
	local UNZIP_DIR
	local OPT
	# DEST_ERASE delete destination folder
	# STRIP delete first folder in archive

	URL="$1"
	FILE_NAME="$2"
	UNZIP_DIR="$3"
	OPT="$4"


	if [ "${FILE_NAME}" = "_AUTO_" ]; then
		#_AFTER_SLASH=${URL##*/}
		FILE_NAME=$(__get_filename_from_url "$URL")
		__log "INFO" "** Guessed file name is $FILE_NAME"
	fi

	__download "$URL" "$FILE_NAME"
	if [ -f "$STELLA_APP_CACHE_DIR/$FILE_NAME" ]; then
		__uncompress "$STELLA_APP_CACHE_DIR/$FILE_NAME" "$UNZIP_DIR" "$OPT"
	else
		if [ -f "$STELLA_INTERNAL_CACHE_DIR/$FILE_NAME" ]; then
			__uncompress "$STELLA_INTERNAL_CACHE_DIR/$FILE_NAME" "$UNZIP_DIR" "$OPT"
		fi
	fi

}

__compress() {
	local _mode=$1
	local _target=$2
	local _output_archive=$3

	local _tar_flag

	case $_mode in
		TARGZ )
			_tar_flag=-z
			;;
		TARBZ )
			_tar_flag=-j
			;;
		TARXZ )
			_tar_flag=-J
			;;
		TARLZMA )
			_tar_flag=--lzma
			;;
	esac

	case $_mode in
		7Z)
			if [ -d "$_target" ]; then
				cd "$_target/.."
				7z a -t7z "$_output_archive" "$(basename "${_target}")"
				mv "$_output_archive" "$_output_archive"
			fi
			if [ -f "$_target" ]; then
				cd "$(dirname "${_target}")"
				7z a -t7z "$_output_archive" "$(basename "${_target}")"
				mv "$_output_archive" "$_output_archive"
			fi
			;;
		ZIP)
			__log "DEBUG" "TODO: *********** ZIP NOT IMPLEMENTED"
			;;
		TAR*)
				[ -d "$_target" ] && tar -c -v $_tar_flag -f "$_output_archive" -C "$_target/.." "$(basename "${_target}")"
				[ -f "$_target" ] && tar -c -v $_tar_flag -f "$_output_archive" -C "$(dirname "${_target}")" "$(basename "${_target}")"
			;;
	esac


}

__uncompress() {
	local FILE_PATH
	local UNZIP_DIR
	local OPT
	FILE_PATH="$1"
	UNZIP_DIR="$2"
	OPT="$3"

	local _opt_dest_erase=OFF # delete destination folder (default : FALSE)
	local _opt_strip=OFF # delete first folder in archive  (default : FALSE)
	for o in $OPT; do
		[ "$o" = "DEST_ERASE" ] && _opt_dest_erase=ON
		[ "$o" = "STRIP" ] && _opt_strip=ON
	done


	if [ "$_opt_dest_erase" = "ON" ]; then
		rm -Rf "$UNZIP_DIR"
	fi

	mkdir -p "$UNZIP_DIR"

	__log "INFO" " ** Uncompress $FILE_PATH in $UNZIP_DIR"

	cd "$UNZIP_DIR"

	case "$FILE_PATH" in
		*.zip)
			__require "unzip" "unzip" "SYSTEM"
			[ "$_opt_strip" = "OFF" ] && unzip -a -o "$FILE_PATH"
			[ "$_opt_strip" = "ON" ] && __unzip-strip "$FILE_PATH" "$UNZIP_DIR"
			;;
		*.tar )
			if [ "$_opt_strip" = "OFF" ]; then
				tar xf "$FILE_PATH"
			else
				tar xf "$FILE_PATH" --strip-components=1 2>/dev/null || __untar-strip "$FILE_PATH" "$UNZIP_DIR"
			fi
			;;
		*.gz | *.tgz)
			if [ "$_opt_strip" = "OFF" ]; then
				tar xzf "$FILE_PATH"
			else
				tar xzf "$FILE_PATH" --strip-components=1 2>/dev/null || __untar-strip "$FILE_PATH" "$UNZIP_DIR"
			fi
			;;
		*.xz | *.tar.bz2 | *.tbz2 | *.tbz)
			if [ "$_opt_strip" = "OFF" ]; then
				tar xf "$FILE_PATH"
			else
				tar xf "$FILE_PATH" --strip-components=1 2>/dev/null || __untar-strip "$FILE_PATH" "$UNZIP_DIR"
			fi
			;;
		*.bz2|*.bz)
			if [ "$_opt_strip" = "OFF" ]; then
				cp -f "$FILE_PATH" .
				bzip2 -d *
			else
				# NOTE : maybe not needed because a bz2 file contains always only one files and not a directory ?
				__bzip2-strip "$FILE_PATH" "$UNZIP_DIR"
			fi
			;;
		*.7z)
			__require "7z" "7z" "SYSTEM"
			[ "$_opt_strip" = "OFF" ] && 7z x "$FILE_PATH" -y -o"$UNZIP_DIR"
			[ "$_opt_strip" = "ON" ] && __sevenzip-strip "$FILE_PATH" "$UNZIP_DIR"
			;;
		*.deb)
			# STRIP not supported. Often in debian packages, there is a lot of folder at first level
			# https://www.g-loaded.eu/2008/01/28/how-to-extract-rpm-or-deb-packages/
			ar p "$FILE_PATH" data.tar.xz | tar x 2>/dev/null || \
				ar p "$FILE_PATH" data.tar.gz | tar xz
			;;
		*)
			__log "INFO" " ** ERROR : Unknown archive format"
			;;
	esac
}

__download() {
	local URL
	local FILE_NAME
	local DEST_DIR

	URL="$1"
	FILE_NAME="$2"
	DEST_DIR="$3"

	if [ "$FILE_NAME" = "" ]; then
		FILE_NAME="_AUTO_"
	fi

	if [ "$FILE_NAME" = "_AUTO_" ]; then
		#_AFTER_SLASH=${URL##*/}
		FILE_NAME=$(__get_filename_from_url "$URL")
		__log "INFO" "** Guessed file name is $FILE_NAME"
	fi

	mkdir -p "$STELLA_APP_CACHE_DIR"

	__log "INFO" " ** Download $FILE_NAME from $URL into cache"

	#if [ "$FORCE" = "1" ]; then
	#	rm -Rf "$STELLA_APP_CACHE_DIR/$FILE_NAME"
	#fi


	if [ ! -f "$STELLA_APP_CACHE_DIR/$FILE_NAME" ]; then
		if [ ! -f "$STELLA_INTERNAL_CACHE_DIR/$FILE_NAME" ]; then
			# NOTE : curl seems to be more compatible
			if [[ -n `which curl 2> /dev/null` ]]; then
				# TODO : why two curl call ?
				curl -fkSL -o "$STELLA_APP_CACHE_DIR/$FILE_NAME" "$URL" || \
				curl -fkSL -o "$STELLA_APP_CACHE_DIR/$FILE_NAME" "$URL" || \
				rm -f "$STELLA_APP_CACHE_DIR/$FILE_NAME"
			else
				if [[ -n `which wget 2> /dev/null` ]]; then
					wget "$URL" -O "$STELLA_APP_CACHE_DIR/$FILE_NAME" --no-check-certificate || \
					wget "$URL" -O "$STELLA_APP_CACHE_DIR/$FILE_NAME" || \
					rm -f "$STELLA_APP_CACHE_DIR/$FILE_NAME"
				else
					__require "curl" "curl" "SYSTEM"
				fi
			fi
		else
			__log "INFO" " ** Already downloaded"
		fi
	else
		__log "INFO" " ** Already downloaded"
	fi

	local _tmp_dir
	if [ -f "$STELLA_APP_CACHE_DIR/$FILE_NAME" ]; then
		_tmp_dir="$STELLA_APP_CACHE_DIR"
	else
		if [ -f "$STELLA_INTERNAL_CACHE_DIR/$FILE_NAME" ]; then
			_tmp_dir="$STELLA_INTERNAL_CACHE_DIR"
		fi
	fi

	if [ ! "$_tmp_dir" = "" ]; then
		if [ ! "$DEST_DIR" = "" ]; then
			if [ ! "$DEST_DIR" = "$STELLA_APP_CACHE_DIR" ]; then
				if [ ! -d "$DEST_DIR" ]; then
					mkdir -p "$DEST_DIR"
				fi
				cp "$_tmp_dir/$FILE_NAME" "$DEST_DIR/"
				__log "INFO" "** Downloaded $FILE_NAME is in $DEST_DIR"
			fi
		fi
	else
		__log "INFO" "** ERROR downloading $URL"
	fi
}

# when --strip-components option on tar does not exist
__untar-strip() {
	local zip=$1
	local dest=${2:-.}
	local temp=$(mktmpdir)

	cd "$temp"
	tar xzf "$FILE_PATH"

	shopt -s dotglob
	local f=("$temp"/*)

	if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
			mv "$temp"/*/* "$dest"
	else
			mv "$temp"/* "$dest"
	fi
	rm -Rf "$temp"
}

__unzip-strip() {
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktmpdir)

    unzip -a -o -d "$temp" "$zip"
    shopt -s dotglob
    local f=("$temp"/*)

    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi
    rm -Rf "$temp"
}

__sevenzip-strip() {
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktmpdir)
    7z x "$zip" -y -o"$temp"
    shopt -s dotglob
    local f=("$temp"/*)

    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi
    rm -Rf "$temp"
}



__bzip2-strip() {
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktmpdir)

	cp -f $zip $temp/
	cd $temp
    bzip2 -d *

    shopt -s dotglob
    local f=("$temp"/*)

    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv "$temp"/*/* "$dest"
    else
        mv "$temp"/* "$dest"
    fi
    rm -Rf "$temp"
}

# SCM ---------------------------------------------
# https://vcversioner.readthedocs.org/en/latest/
# TODO : should work only if at least one tag exist ?
__mercurial_project_version() {
	local _PATH=$1
	local _OPT=$2

	_opt_version_short=OFF
	_opt_version_long=OFF
	for o in $_OPT; do
		[ "$o" = "SHORT" ] && _opt_version_short=ON
		[ "$o" = "LONG" ] && _opt_version_long=ON
	done

	if [[ -n `which hg 2> /dev/null` ]]; then
		if [ "$_opt_version_long" = "ON" ]; then
			echo "$(hg log -R "$_PATH" -r . --template "{latesttag}-{latesttagdistance}-{node|short}")"
		fi
		if [ "$_opt_version_short" = "ON" ]; then
			echo "$(hg log -R "$_PATH" -r . --template "v{latesttag}")"
		fi
	fi
}

# NOTE git "--first-parent" option needs git version >= 1.8.4
__git_project_version() {
	local _path=$1
	local _OPT=$2

	_opt_version_short=ON
	_opt_version_long=OFF
	for o in $_OPT; do
		[ "$o" = "SHORT" ] && _opt_version_short=ON && _opt_version_long=OFF
		[ "$o" = "LONG" ] && _opt_version_long=ON && _opt_version_short=OFF
	done

	if [ -d "${_path}/.git" ]; then
		if [[ -n `which git 2> /dev/null` ]]; then
			if [ "$_opt_version_long" = "ON" ]; then
				echo "$(git --git-dir "${_path}/.git" describe --tags --long --always --first-parent)"
			fi
			if [ "$_opt_version_short" = "ON" ]; then
				echo "$(git --git-dir "${_path}/.git" describe --tags --abbrev=0 --always --first-parent)"
			fi
		fi
	fi
}


# INI FILE MANAGEMENT---------------------------------------------------
# eval a specific key from a specific SECTION
# OPT :
# PREFIX add section name as prefix for variable name
__get_key() {
	local _FILE=$1
	local _SECTION=$2
	local _KEY=$3
	local _OPT=$4

	# NOTE : by default we activate the EOL compatibility mode for reading keys in ini files
	__get_keys "${_FILE}" "ASSIGN EVAL ${_OPT} KEY ${_KEY} SECTION ${_SECTION} COMPATIBLE_EOL"

}




# get all keys from an ini file
# or get all keys from a specific section
# or get a specific key (which may be from a specitic section or not)
# TODO : do not support section name like [[radarr]]
# TODO : do not support other character than [a-zA-Z0-9._]{1,}[[:space:]]*= in key/value pair (see line 208 in read_ini.sh)
# OPTION
# ASSIGN|PRINT will assign to each key with its own value OR will only print values (PRINT is default mode)
# EVAL will eval each key value before AFFECT it or PRINT it
# PREFIX will add section name to key name
# KEY | SECTION : will look up for a KEY | SECTION
# COMPATIBLE_EOL : treat any EOL (windows \r\n, mac or linux) as an eol
# TEST SAMPLE :
# a1 = 12
# abcd=22
# az = 4
# abab=AA
# u =
# foo=3=4=
# A=3
# bar_A=1
# [bar]
# A=2
# zer=2
# S="a b c d AB# ED="
# H1=$HOME $USER
# H2="$HOME"
# H3='$HOME $USER'
__get_keys() {
	local _FILE=$1
	local _OPT=$2

	_opt_section_prefix=OFF
	_flag_section=
	_opt_section=
	_flag_key=
	_opt_key=
	_opt_eval=OFF
  	_opt_assign=OFF
	_opt_eol=OFF
	for o in $_OPT; do
		[ "$o" = "COMPATIBLE_EOL" ] && _opt_eol=ON
		[ "$o" = "PREFIX" ] && _opt_section_prefix=ON
		[ "$o" = "EVAL" ] && _opt_eval=ON
    	[ "$o" = "ASSIGN" ] && _opt_assign=ON
    	[ "$o" = "PRINT" ] && _opt_assign=OFF
		[ "$_flag_section" = "ON" ] && _opt_section="${o}" && _flag_section=OFF
		[ "$o" = "SECTION" ] && _flag_section=ON
		[ "$_flag_key" = "ON" ] && _opt_key="${o}" && _flag_key=OFF
		[ "$o" = "KEY" ] && _flag_key=ON
	done

  	# escape regexp special characters
	# http://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
  	# TODO do we need this two lines below ?
	#_opt_section=$(echo ${_opt_section} | sed -e 's/[]\/$*.^|[]/\\&/g')
	#_opt_key=$(echo "$_opt_key" | sed -e 's/\\/\\\\/g')

  	# unset some specific asked key
	if [ "${_opt_assign}" = "ON" ]; then
		if [ ! "${_opt_key}" = "" ]; then
			if [ "${_opt_section_prefix}" = "ON" ]; then
				if [ ! "${_opt_section}" = "" ]; then
						eval "${_opt_section}"_"${_opt_key}"=
				else
						eval "${_opt_key}"=
				fi
			else
				eval "${_opt_key}"=
			fi
		fi
	fi
	[ ! -f "${_FILE}" ] && return

	local __file=${_FILE}
	if [ "${_opt_eol}" = "ON" ]; then
		__file="$(mktmp)"
		# win : remove CRLF and write LF
		# old mac : replace CR with LF
		awk '{ sub("\r$", ""); print }' ${_FILE} | tr '\r' '\n' > ${__file}
	fi

	# NOTE read_ini : Dots are converted to underscores in all variable names.
	read_ini ${__file} ${_opt_section} --prefix "INTERNAL__INI" --booleans 0


  _list_var="${INTERNAL__INI__ALL_VARS}"
  for s in ${INTERNAL__INI__ALL_SECTIONS}; do
    _t="INTERNAL__INI__${s}__"
    # parse all variable of current section
    for v in $(compgen -v "${_t}"); do
      key="${v/$_t/}"
      if [ ! "${_opt_key}" = "" ]; then
        [ ! "$key" = "${_opt_key}" ] && continue
      fi
      [ "$_opt_section_prefix" = "ON" ] && key="${s}_${key}"
      if [ "$_opt_assign" = "ON" ]; then
        if [ "$_opt_eval" = "ON" ]; then
          eval $(echo $key=\"${!v}\")
        else
          # NOTE affectation to variable name but without value evaluation
          eval "$key='$(echo "${!v}")'"
        fi
      else
        if [ "$_opt_eval" = "ON" ]; then
          # NOTE : just print out evaluated variable value
          eval echo \"${!v}\"
        else
          # NOTE : just print out variable value
          eval "echo '$(echo "${!v}")'"
        fi
      fi
      # remove already parsed variable
      _list_var=${_list_var/$v/}
    done
  done

  # parse not already parsed variable, the ones wich are not inside section
  # these variable override already defined variable
  # BAR_A=1
  # [BAR]
  # A=2
  # ==> if PREFIX mode is active then BAR_A will be 1
  for v in ${_list_var}; do
    key="${v/INTERNAL__INI__/}"
    if [ ! "${_opt_key}" = "" ]; then
      [ ! "$key" = "${_opt_key}" ] && continue
    fi
    if [ "$_opt_assign" = "ON" ]; then
      if [ "$_opt_eval" = "ON" ]; then
        eval $(echo $key=\"${!v}\")
      else
        # NOTE affectation to variable name but without value evaluation
        eval "$key='$(echo "${!v}")'"
      fi
    else
      if [ "$_opt_eval" = "ON" ]; then
        # NOTE : just print out evaluated variable value
        eval echo \"${!v}\"
      else
        # NOTE : just print out variable value
        eval "echo '$(echo "${!v}")'"
      fi
    fi
  done

  # delete all read_ini initialized variable
  unset "${!INTERNAL__INI__@}"

}


__del_key() {
	local _FILE=$1
	local _SECTION=$2
	local _KEY=$3

	[ -f "$_FILE" ] && __ini_file "DEL" "$_FILE" "$_SECTION" "$_KEY"
}

__add_key() {
	local _FILE=$1
	local _SECTION=$2
	local _KEY=$3
	local _VALUE=$4

	if [ ! -f "$_FILE" ]; then
		touch $_FILE
	fi

	__ini_file "ADD" "$_FILE" "$_SECTION" "$_KEY" "$_VALUE"
}

__ini_file() {
	local _MODE=$1
	local _FILE=$2
	local _SECTION=$3
	local _KEY=$4
	if [ ! "$_KEY" = "" ]; then
		local _VALUE=$5
	fi

	# escape regexp special characters
	# http://stackoverflow.com/questions/407523/escape-a-string-for-a-sed-replace-pattern
	_SECTION_NAME=$_SECTION
	_SECTION=$(echo $_SECTION | sed -e 's/[]\/$*.^|[]/\\&/g')
	_VALUE=$(echo "$_VALUE" | sed -e 's/\\/\\\\/g')
	_KEY=$(echo "$_KEY" | sed -e 's/\\/\\\\/g')

	tp=$(mktmp)

	awk -F= -v mode="$_MODE" -v val="$_VALUE" '
	# Clear the flags
	BEGIN {
		processing = 0;
		skip = 0;
		modified = 0;
	}

	# Leaving the found section
	/\[/ {
		if(processing) {
			if ( mode == "ADD" ) {
				print "'$_KEY'="val;
				modified = 1;
				processing = 0;
			}

			if ( mode == "DEL" ) {
				processing = 0;
			}
		}
	}


	# Entering the section, set the flag
	/^\['$_SECTION']/ {
		processing = 1;
	}

	# Modify the line, if the flag is set
	/^'$_KEY'=/ {
		if (processing) {
		   	if ( mode == "ADD" ) {
		   		print "'$_KEY'="val;
				skip = 1;
				modified = 1;
				processing = 0;
			}

			if ( mode == "DEL" ) {
				skip = 1;
				processing = 0;
			}

		}
	}


	# Output a line (that we didnt output above)
	/.*/ {

		if (skip)
		    skip = 0;
		else
			print $0;
	}
	END {
		if(!modified && mode == "ADD") {
			if(!processing) print "['$_SECTION_NAME']"
			if("'$_KEY'" != "") {
				print "'$_KEY'="val;
			}
		}

	}

	' "${_FILE}" > $tp
	cat "${tp}" > "${_FILE}"
	rm -f "${tp}"
	# mv change permission on file
	#mv -f $tp "$_FILE"
}



# ARG COMMAND LINE MANAGEMENT---------------------------------------------------
#		STELLA_ARGPARSE_GETOPT : getopt command instead of "getopt"
# DEFINITIONS :
#				OPTION : an option begin with - or --
#				PARAMETER : a parameter do not have -
#				EXTRA PARAMETER : non parsed parameter are non defined parameter passed to command line
#				EXTRA ARG : end of options arg are arguments after '--'
__argparse(){
	local PROGNAME
	PROGNAME="$(__get_filename_from_string "$1")"
	local OPTIONS="$2"
	local PARAMETERS="$3"
	local SHORT_DESCRIPTION="$4"
	local LONG_DESCRIPTION="$5"
	local OPT="$6"
	# available options
	#		EXTRA_PARAMETER : a variable name which will contains non parsed parameter (parameter BEFORE -- which are not defined)
	#		EXTRA_ARG : a variable name which will contains a string with EXTRA ARG (arguments AFTER --)
	#		EXTRA_ARG_EVAL : a variable name which will contains a string (arguments AFTER --) to be evaluted, that will set variable '$@' with EXTRA ARG
	#		see samples in test/argparse/sample-app.sh

	shift 6

	local _flag_extra_arg_eval_var=
	local _extra_arg_eval_var=
	local _flag_extra_arg_var=
	local _extra_arg_var=
	local _flag_extra_parameter_var=
	local _extra_parameter_var=
	for o in $OPT; do
		[ "$_flag_extra_parameter_var" = "ON" ] && _extra_parameter_var="$o" && _flag_extra_parameter_var=
		[ "$o" = "EXTRA_PARAMETER" ] && _flag_extra_parameter_var="ON"

		[ "$_flag_extra_arg_eval_var" = "ON" ] && _extra_arg_eval_var="$o" && _flag_extra_arg_eval_var=
		[ "$o" = "EXTRA_ARG_EVAL" ] && _flag_extra_arg_eval_var="ON"

		[ "$_flag_extra_arg_var" = "ON" ] && _extra_arg_var="$o" && _flag_extra_arg_var=
		[ "$o" = "EXTRA_ARG" ] && _flag_extra_arg_var="ON"
	done


	ARGP="
	--HEADER--
	ARGP_PROG=$PROGNAME
	ARGP_DELETE=quiet verbose version
	ARGP_VERSION=$STELLA_APP_NAME
	ARGP_OPTION_SEP=:
	ARGP_SHORT=$SHORT_DESCRIPTION
	ARGP_LONG_DESC=$LONG_DESCRIPTION
	ARGP_EXTRA_PARAMETER_VAR=$_extra_parameter_var
	ARGP_EXTRA_ARG_EVAL_VAR=$_extra_arg_eval_var
	"

	ARGP=$ARGP"
	--OPTIONS--
	$OPTIONS
	--PARAMETERS--
	$PARAMETERS
	"

	# Debug mode
	# for DEBUG :
	#export ARGP_DEBUG=1
	export ARGP_HELP_FMT=
	#export ARGP_HELP_FMT="rmargin=$(tput cols)"
	#echo $ARGP
	exec 4>&1 # fd4 is now a copy of fd1 ie stdout
	RES=$( echo "$ARGP" | GETOPT_CMD=$STELLA_ARGPARSE_GETOPT $STELLA_COMMON/argp.sh "$@" 3>&1 1>&4 || echo exit $? )
	exec 4>&-


	[ "$RES" ] || exit 0

	# for DEBUG :
	#echo $RES
	eval $RES

	# NOTE : here @ contains now EXTRA ARG
	if [ ! "$_extra_arg_var" = "" ]; then
		eval "export $_extra_arg_var=\$@"
	fi


}



fi
