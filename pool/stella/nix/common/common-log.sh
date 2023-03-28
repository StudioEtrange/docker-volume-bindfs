#!sh
if [ ! "$_STELLA_COMMON_LOG_INCLUDED_" = "1" ]; then
_STELLA_COMMON_LOG_INCLUDED_=1


# __log_init() {
# 	STELLA_LOG_STATE=
# 	STELLA_LOG_LEVEL=
# }

__set_log_state() {
	local _state="$1"
	STELLA_LOG_STATE="$_state"
}

# TODO : use level
__set_log_level() {
	local _level="$1"
	STELLA_LOG_LEVEL="$_level"
}

__log() {
	local _level="$1"
	local _msg="$2"

	[ "$STELLA_LOG_STATE" = "ON" ] && echo "$_msg"

}

fi
