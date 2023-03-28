#!sh
if [ ! "$_STELLA_STACK_INCLUDED_" = "1" ]; then
_STELLA_STACK_INCLUDED_=1
# inspired from Example 26-14. Emulating a push-down stack
# http://www.linuxtopia.org/online_books/advanced_bash_scripting_guide/arrays.html

# Stack Pointer
_STELLA_STACK_SP=0
# NOTE : position 0 on stack is always empty

# Stack
declare -a _STELLA_STACK_


__stack_push() {
	# Nothing to push?
	#if [ -z "$1" ]; then
	#	return
	#fi

	_STELLA_STACK_SP=$(( _STELLA_STACK_SP + 1 ))
	_STELLA_STACK_[$_STELLA_STACK_SP]="$1"

	return
}

__stack_pop() {
	local data=

	if [ "$_STELLA_STACK_SP" -eq "0" ]; then
	 	echo
	else
		data="${_STELLA_STACK_[$_STELLA_STACK_SP]}"
		_STELLA_STACK_SP=$(( _STELLA_STACK_SP - 1 ))
		#echo $data
		eval "$1"=\"$data\"
	fi
}

fi
