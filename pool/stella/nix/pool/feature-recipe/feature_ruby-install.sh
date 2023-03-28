if [ ! "$_RUBYINSTALL_INCLUDED_" = "1" ]; then
_RUBYINSTALL_INCLUDED_=1


# https://github.com/postmodern/ruby-install

# NOTE : download any ruby distribution and built them
#	WARN : it may impact your system : it manages build tools dependencies (in exemple : it use homebrew on macos)

# Install a ruby distribution in specific location
# 		ruby-install --install-dir ~/rubies/2.4.0 ruby 2.4.0


feature_ruby-install() {
	FEAT_NAME=ruby-install
	FEAT_LIST_SCHEMA="0_6_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}



feature_ruby-install_0_6_1() {
	FEAT_VERSION=0_6_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	FEAT_BINARY_URL=https://github.com/postmodern/ruby-install/archive/v0.6.1.tar.gz
	FEAT_BINARY_URL_FILENAME=ruby-install-v0.6.1.tar.gz
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/ruby-install
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}

feature_ruby-install_install_binary() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$INSTALL_DIR" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"

}


fi
