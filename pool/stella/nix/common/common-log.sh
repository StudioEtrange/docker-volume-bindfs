#!sh
if [ ! "$_STELLA_COMMON_LOG_INCLUDED_" = "1" ]; then
_STELLA_COMMON_LOG_INCLUDED_=1


__set_log_state_stella() {
	export STELLA_LOG_STATE="$1"
}

__set_log_level_stella() {
	export STELLA_LOG_LEVEL="$1"
}

__set_log_state_app() {
	export STELLA_APP_LOG_STATE="$1"
}

__set_log_level_app() {
	export STELLA_APP_LOG_LEVEL="$1"
}

# old stella log function
# 1 : level of log (INFO, WARN, ERROR, DEBUG, ASK)
# 2 : remaning parameters are the message to print
__log() {
	local _level="$1"
	shift 1

	if [ "$STELLA_LOG_STATE" = "ON" ]; then
		( __current_log_level_filter="${STELLA_LOG_LEVEL}"; __log_private "$_level" "stella" "$@" )
	fi
}

# internal lag from stella
# 1 : level of log (INFO, WARN, ERROR, DEBUG, ASK)
# 2 : remaning parameters are the message to print
__log_stella() {
	local _level="$1"
	shift 1
	if [ "$STELLA_LOG_STATE" = "ON" ]; then
		( __current_log_level_filter="${STELLA_LOG_LEVEL}"; __log_private "$_level" "stella" "$@" )
	fi
}

# lag from a stella app
# 1 : level of log (INFO, WARN, ERROR, DEBUG, ASK)
# 2 : domain is a string to indicate some sort of "category"
# 3 : remaning parameters are the message to print
__log_app() {
	if [ "$STELLA_APP_LOG_STATE" = "ON" ]; then
		( __current_log_level_filter="${STELLA_APP_LOG_LEVEL}"; __log_private "$@" )
	fi
}


# level of log (INFO, WARN, ERROR, DEBUG, ASK)
#		the level can have suffices to modify the printing of log
#			_NO_HEADER : disable print of domain and level
#			_BEGINNING_NEWLINE : start by printing a new line before the message
#		i.e 
#			__log_internal "DEBUG_NO_HEADER_BEGINNING_NEWLINE" "" "" # will print only a new line
#			__log_internal "DEBUG_BEGINNING_NEWLINE" "category" "test" # will print a new line then "category@level" then "test" message
# domain is a string to indicate some sort of "category"
# remaning parameters are the message to print
__log_private() {
	{
		local __level="$1"
		local __domain="$2"
		shift 2
		local __msg="$@"

		_print="0"

		[ ${__current_log_level_filter} = "" ] && __current_log_level_filter="INFO"
		
		local _beginning_new_line="0"
		local _no_header="0"
		while [[ "${__level}" =~ _BEGINNING_NEWLINE|_NO_HEADER ]]; do
			case ${__level} in
				*_BEGINNING_NEWLINE* ) _beginning_new_line="1"; __level="${__level//_BEGINNING_NEWLINE}";;
				*_NO_HEADER* ) _no_header="1"; __level="${__level//_NO_HEADER}";;
			esac
		done

		local _color=
		local _no_color_for_msg="1"
		case ${__level} in
				INFO )
					_color="clr_bold clr_green"
				;;
				WARN )
					_color="clr_bold"
				;;
				ERROR )
					_color="clr_bold clr_red"
					_no_color_for_msg="0"
				;;
				DEBUG )
					_color="clr_bold clr_cyan"
				;;
				ASK )
					_color="clr_bold clr_blue"
				;;
		esac
		# disable color if needed
		if [ "${STELLA_TERMINAL_COLOR}" = "OFF" ]; then
			_color=""
		fi

		case ${__current_log_level_filter} in
			INFO )
				case ${__level} in
					INFO|WARN|ERROR|ASK ) _print="1"
					;;
				esac
				;;
			WARN )
				case ${__level} in
					WARN|ERROR|ASK ) _print="1"
					;;
				esac
			;;
			ERROR )
				case ${__level} in
					ERROR|ASK ) _print="1"
					;;
				esac
			;;
			DEBUG )
				case ${__level} in
					INFO|WARN|ERROR|DEBUG|ASK ) _print="1"
					;;
				esac
			;;
		esac

		if [ "${_print}" = "1" ]; then

			[ ! ${__domain} = "" ] && __domain="@${__domain}"

			# start by printing a newline
			if [ "${_beginning_new_line}" = "1" ]; then
				printf "\n";
			fi

			# nothing to print more
			if [ "${_no_header}" = "1" ]; then
				if [ "${__msg}" = "" ]; then
					return
				fi
			fi


			case ${__level} in
				# add spaces for tab alignment
				INFO|WARN ) __level="${__level} ";;
				ASK ) __level="${__level}  ";;
			esac
			

			if [ "${_color}" = "" ]; then
				if [ "${_no_header}" = "0" ]; then
					echo "${__level}${__domain}> ${__msg}"
				else
					echo "${__msg}"
				fi
			else
				if [ "${_no_color_for_msg}" = "1" ]; then
					if [ "${_no_header}" = "0" ]; then
						${_color} -n "${__level}${__domain}> "; clr_reset "${__msg}"
					else
						clr_reset "${__msg}"
					fi
				else
					if [ "${_no_header}" = "0" ]; then
						${_color} "${__level}${__domain}> ${__msg}"
					else
						${_color} "${__msg}"
					fi
				fi
			fi
		fi
	} >&2
}

fi
