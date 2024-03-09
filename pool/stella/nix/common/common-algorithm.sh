#!sh
if [ ! "$_STELLA_STACK_INCLUDED_" = "1" ]; then
_STELLA_STACK_INCLUDED_=1
# inspired from Example 26-14. Emulating a push-down stack
# http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/arrays.html


# NOTE : we cannot use stack functions in a subshell like $(__stack_pop)
#        because stack variables modifications are not propagated to parent shell


__stack_push() {
	local __name="$1"
	if [ -z "${__name}" ]; then
		return
	fi

	local __ptr="_STELLA_STACK_SP_${__name}"
	local __stack="_STELLA_STACK_${__name}"

	eval "${__ptr}=\$(( ${__ptr} + 1 ))"
	eval "${__stack}[${!__ptr}]=\$2"

}


__stack_pop() {
	local __name="$1"
	local __var="$2"

	if [ -z "${__name}" ]; then
		return
	fi
	
	local __ptr="_STELLA_STACK_SP_${__name}"
	local __stack="_STELLA_STACK_${__name}"

	local __data=

	if [ "${!__ptr}" -eq "0" ]; then
		# stack is empty
	 	return
	else

		eval "__data=\${${__stack}[${!__ptr}]}"
		eval "unset ${__stack}[${!__ptr}]"

		eval "${__ptr}=\$(( ${__ptr} - 1 ))"

		if [ ! -z "${__var}" ]; then
			eval "${__var}=\"${__data}\""
		fi
	fi
}

__stack_init() {
	local __name="$1"
	if [ -z "$__name" ]; then
		return
	fi

	local __ptr="_STELLA_STACK_SP_${__name}"
	local __stack="_STELLA_STACK_${__name}"
	eval "unset ${__stack}"

	# NOTE : position 0 on stack is always empty
	eval "${__ptr}=0"


}

__stack_size() {
	local __name="$1"
	if [ -z "$__name" ]; then
		return
	fi

	local __ptr="_STELLA_STACK_SP_${__name}"
	echo ${!__ptr}
}


__stack_print() {
	local __name="$1"
	if [ -z "$__name" ]; then
		return
	fi

	local __stack="_STELLA_STACK_${__name}"

	eval echo "\${$__stack[@]}"

}

# init a default stella stack
__stack_init "STELLA"

fi
