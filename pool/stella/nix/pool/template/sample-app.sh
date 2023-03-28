#!/bin/bash
_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
_CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"
. $_CURRENT_FILE_DIR/stella-link.sh include


usage() {
	echo "USAGE :"
	echo "----------------"
	echo "o-- foo management :"
	echo "L     foo run [--opt=<string>]"
	echo "o-- general management :"
	echo "L     env install|uninstall : deploy/undeploy this app"
}

# COMMAND LINE -----------------------------------------------------------------------------------
PARAMETERS="
DOMAIN=											'domain' 			a				'foo env' '1' Action domain.
ID=												'' 					a				'install uninstall run'	'1' Action ID.
"
OPTIONS="
FORCE=''				   'f'		  ''					b			0		'1'					  Force.
OPT='default_val' 						'' 			'string'				s 			0			''		  Sample option.
"
$STELLA_API argparse "$0" "$OPTIONS" "$PARAMETERS" "$STELLA_APP_NAME" "$(usage)" "EXTRA_ARG ARG" "$@"

#-------------------------------------------------------------------------------------------


# --------------- FOO ----------------------------
if [ "$DOMAIN" = "foo" ]; then

	if [ "$ID" = "run" ]; then
		echo $OPT
	fi
fi


# ------------- ENV ----------------------------
if [ "$DOMAIN" = "env" ]; then
	if [ "$ID" = "install" ]; then
		echo "** Install requirements"
		$STELLA_API get_features

	fi

	if [ "$ID" = "uninstall" ]; then
		$STELLA_API del_folder "$STELLA_APP_WORK_ROOT"
	fi

fi
