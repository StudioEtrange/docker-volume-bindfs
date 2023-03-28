#!sh
if [ ! "$_STELLA_COMMON_API_INCLUDED_" = "1" ]; then
_STELLA_COMMON_API_INCLUDED_=1



__api_proxy() {
	local FUNC_NAME=$1
	local _result=
	local f=
	shift

	for f in $STELLA_API_COMMON_PUBLIC $STELLA_API_LOG_PUBLIC $STELLA_API_BOOT_PUBLIC $STELLA_API_BINARY_PUBLIC $STELLA_API_BUILD_PUBLIC $STELLA_API_APP_PUBLIC $STELLA_API_API_PUBLIC $STELLA_API_FEATURE_PUBLIC $STELLA_API_NETWORK_PUBLIC $STELLA_API_PLATFORM_PUBLIC; do
		if [ "$f" = "$FUNC_NAME" ]; then
			__$FUNC_NAME "$@"
			return $?
		fi
	done

	echo "** API ERROR : Function $FUNC_NAME does not exist"
}

__api_list() {
	echo "[ COMMON-API : $STELLA_API_COMMON_PUBLIC ] \
	[ FEATURE-API : $STELLA_API_FEATURE_PUBLIC ] \
	[ APP-API : $STELLA_API_APP_PUBLIC ] \
	[ BINARY-API : $STELLA_API_BINARY_PUBLIC ]  \
	[ BUILD-API : $STELLA_API_BUILD_PUBLIC ]  \
	[ PLATFORM : $STELLA_API_PLATFORM_PUBLIC ]  \
	[ BOOT : $STELLA_API_BOOT_PUBLIC ]  \
	[ API : $STELLA_API_API_PUBLIC ]  \
	"
}

# connect api function to another stella application context
__api_connect() {
	local _approot=$1

	# TODO saveSTELLA_APP_ROOT
	saveSTELLA_APP_ROOT=$STELLA_APP_ROOT
	STELLA_APP_ROOT=
  _STELLA_CONF_INCLUDED_=
  . $_approot/stella-link.sh include
}

# reconnect api to current stella application
__api_disconnect() {
	STELLA_APP_ROOT=

  _STELLA_CONF_INCLUDED_=
	# TODO saveSTELLA_APP_ROOT
  . $saveSTELLA_APP_ROOT/stella-link.sh include
}

fi
