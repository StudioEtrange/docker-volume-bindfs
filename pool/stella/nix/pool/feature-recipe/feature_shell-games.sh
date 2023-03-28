if [ ! "$_shellgames_INCLUDED_" = "1" ]; then
_shellgames_INCLUDED_=1

# https://www.tecmint.com/best-linux-terminal-console-games/
# https://www.fossmint.com/linux-terminal-console-games/
# https://linoxide.com/linux-how-to/linux-command-line-games/

feature_shell-games() {
	FEAT_NAME="shell-games"
	FEAT_LIST_SCHEMA="1_0"
	FEAT_DEFAULT_ARCH=

	FEAT_BUNDLE=LIST
}

feature_shell-games_1_0() {
	FEAT_VERSION=1_0

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_BUNDLE_ITEM="unnethack"

	FEAT_ENV_CALLBACK=
	FEAT_BUNDLE_CALLBACK=feature_shell-games_print

	FEAT_INSTALL_TEST=
	FEAT_SEARCH_PATH=
}


feature_shell-games_print() {

	figlet " ** Games in Shell **"
	echo " -- a collection of amazing shell games."
	echo " 		figlet"


}


fi
