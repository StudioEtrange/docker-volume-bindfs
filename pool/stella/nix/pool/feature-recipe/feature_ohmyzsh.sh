if [ ! "$_GOCROSSCOMPILE_INCLUDED_" = "1" ]; then
_GOCROSSCOMPILE_INCLUDED_=1


feature_ohmyzsh() {
	FEAT_NAME="ohmyzsh"
	FEAT_LIST_SCHEMA="SNAPSHOT:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"
}

feature_ohmyzsh_SNAPSHOT() {
	FEAT_VERSION=SNAPSHOT

	# need zsh
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=https://github.com/robbyrussell/oh-my-zsh
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=GIT

	FEAT_BINARY_URL=
	FEAT_BINARY_URL_FILENAME=
	FEAT_BINARY_URL_PROTOCOL=

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=feature_ohmyzsh_env

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/ohmyzsh/oh-my-zsh.sh
	FEAT_SEARCH_PATH=


}

# a function to run ohmyzsh
launch_ohmyzsh() {
	export ZDOTDIR="$FEAT_INSTALL_ROOT/env"
	ZDOTDIR="$FEAT_INSTALL_ROOT/env" zsh
}

feature_ohmyzsh_env() {
	export ZDOTDIR="$FEAT_INSTALL_ROOT/env"
	echo "** Oh My zsh is active -- env file is in $FEAT_INSTALL_ROOT/env/.zshrc"
	echo "** Just launch zsh from within stella"
}

feature_ohmyzsh_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"
	SRC_DIR="$STELLA_APP_FEATURE_ROOT/$FEAT_NAME-$FEAT_VERSION-src"



	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$SRC_DIR" "DEST_ERASE"

	mkdir -p "$INSTALL_DIR/ohmyzsh"
	mkdir -p "$INSTALL_DIR/env"

	__copy_folder_content_into "$SRC_DIR" "$INSTALL_DIR/ohmyzsh"

	cp "$SRC_DIR/templates/zshrc.zsh-template" "$INSTALL_DIR/env/.zshrc"
	sed -i .bak "s,export ZSH=.*,export ZSH=$INSTALL_DIR/ohmyzsh," "$INSTALL_DIR/env/.zshrc"

	rm -Rf "$SRC_DIR"

}


fi
