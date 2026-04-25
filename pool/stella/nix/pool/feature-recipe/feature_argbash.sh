if [ ! "$_argbash_INCLUDED_" = "1" ]; then
_argbash_INCLUDED_=1

# https://github.com/matejak/argbash

feature_argbash() {
	FEAT_NAME=argbash
	FEAT_LIST_SCHEMA="2_11_0:binary 2_8_1:binary"
	
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_DESC="Bash argument parsing code generator"
	FEAT_LINK="https://github.com/matejak/argbash https://argbash.dev/"
}



feature_argbash_2_11_0() {

	FEAT_VERSION="2_11_0"

	FEAT_BINARY_URL="https://github.com/matejak/argbash/archive/refs/tags/2.11.0.tar.gz"
	FEAT_BINARY_URL_FILENAME="argbash-2.11.0.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/argbash"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}


feature_argbash_2_8_1() {

	FEAT_VERSION="2_8_1"

	FEAT_BINARY_URL="https://github.com/matejak/argbash/archive/2.8.1.tar.gz"
	FEAT_BINARY_URL_FILENAME="argbash-2.8.1.tar.gz"
	FEAT_BINARY_URL_PROTOCOL="HTTP_ZIP"


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/argbash"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_argbash_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}





fi
