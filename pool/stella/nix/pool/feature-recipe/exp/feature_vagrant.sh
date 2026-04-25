if [ ! "$_vagrant_INCLUDED_" = "1" ]; then
_vagrant_INCLUDED_=1

# for linux, the downloaded .deb file contains compiled libraries but these libraries may not work on some linux distro
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/tools/vagrant/default.nix

# NOTE : for vagrant code source may use this : https://p8952.info/2014/12/08/installing-vagrant-in-non-supported-environments/

# homebrew recipe : https://github.com/Homebrew/homebrew-cask/blob/main/Casks/v/vagrant.rb

# QUICK FIRST STEPS
# cd $HOME
# vagrant --version
# vagrant plugin install vagrant-qemu
# vagrant status
# vagrant init bento/ubuntu-22.04
# vagrant up

feature_vagrant() {
	FEAT_NAME="vagrant"
	FEAT_LIST_SCHEMA="2_4_9@x64:binary"

	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_LINK="https://developer.hashicorp.com/vagrant"
	FEAT_DESC="Use Vagrant to create and configure a reproducible and portable work environment."

}


feature_vagrant_2_4_9() {
	FEAT_VERSION="2_4_9"

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/vagrant/2.4.9/vagrant_2.4.9_linux_amd64.zip"
			FEAT_BINARY_URL_FILENAME_x64="vagrant_2.4.9_linux_amd64.zip"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP_ZIP"
		fi
	fi
	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "intel" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/vagrant/2.4.9/vagrant_2.4.9_darwin_amd64.dmg"
			FEAT_BINARY_URL_FILENAME_x64="vagrant_2.4.9_darwin_amd64.dmg"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
		if [ "$STELLA_CURRENT_CPU_FAMILY" = "arm" ]; then
			FEAT_BINARY_URL_x64="https://releases.hashicorp.com/vagrant/2.4.9/vagrant_2.4.9_darwin_arm64.dmg"
			FEAT_BINARY_URL_FILENAME_x64="vagrant_2.4.9_darwin_arm64.dmg"
			FEAT_BINARY_URL_PROTOCOL_x64="HTTP"
		fi
	fi


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/bin/vagrant"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/bin"

}



feature_vagrant_install_binary() {

	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE"


	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		__uncompress_dmg "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT"
		rm -f "$FEAT_INSTALL_ROOT/$FEAT_BINARY_URL_FILENAME"

		# NOTE : there is a problem with linked lib and bin
		# we cannot solve those problem with DYLD_LIBRARY_PATH
		#__tweak_binary_file "$FEAT_INSTALL_ROOT/bin" "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"
		#__check_binary_file "$FEAT_INSTALL_ROOT/bin"

		# __tweak_binary_file "$FEAT_INSTALL_ROOT/embedded/bin" "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"
		# __check_binary_file "$FEAT_INSTALL_ROOT/embedded/bin"

		# __tweak_binary_file "$FEAT_INSTALL_ROOT/embedded/lib" "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"
		# __check_binary_file "$FEAT_INSTALL_ROOT/embedded/lib" "EXCLUDE_FILTER python*|ruby*"

	fi



	# if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
	# 	if [ "$STELLA_CURRENT_OS" = "ubuntu" ]; then
	# 		__uncompress "$FEAT_BINARY_URL_FILENAME" "$STELLA_APP_TEMP_DIR"

	# 		__copy_folder_content_into "$STELLA_APP_TEMP_DIR/opt/vagrant" "$FEAT_INSTALL_ROOT"
	# 		__copy_folder_content_into "$STELLA_APP_TEMP_DIR/usr/bin" "$FEAT_INSTALL_ROOT"

	# 		sed -i".bak" "s,/opt/vagrant,$FEAT_INSTALL_ROOT," "$FEAT_INSTALL_ROOT"/vagrant

	# 		#__tweak_binary_file "$FEAT_INSTALL_ROOT"/bin "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"

	# 		__tweak_binary_file "$FEAT_INSTALL_ROOT/embedded/bin" "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"
	# 		__tweak_binary_file "$FEAT_INSTALL_ROOT/embedded/lib" "FIX_LINKED_LIB $FEAT_INSTALL_ROOT/embedded/lib"
	# 		__check_binary_file "$FEAT_INSTALL_ROOT/bin"
	# 		__check_binary_file "$FEAT_INSTALL_ROOT/embedded/lib" "EXCLUDE_FILTER python*|ruby*"
	# 	else

	# 		echo "** WARN : only ubuntu linux supported for now"
	# 	fi
	# fi

}


fi
