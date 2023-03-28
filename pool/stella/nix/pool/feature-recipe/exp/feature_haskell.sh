if [ ! "$_haskell_INCLUDED_" = "1" ]; then
_haskell_INCLUDED_=1

# TODO NOT FINISHED

# For MacOs binary : it is the Haskell Minimal install way
# https://ghcformacosx.github.io/
# Version 7_10_3 includes
# 	GHC 7.10.3
# 	cabal-install 1.22.8.0
# 	stack 1.0.4


# For Linux binary : it is the Haskell Platform install way
# https://www.haskell.org/downloads#minimal
# https://www.haskell.org/platform/#linux
# Version 7_10_3 includes
# 	GHC 7.10.3
# 	cabal-install
# 	Some libraries



feature_haskell() {
	FEAT_NAME=haskell
	FEAT_LIST_SCHEMA="7_10_3:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}



feature_haskell_7_10_3() {
	FEAT_VERSION=7_10_3

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://github.com/ghcformacosx/ghc-dot-app/releases/download/v7.10.3-r1/ghc-7.10.3-r1.zip
		FEAT_BINARY_URL_FILENAME=ghcformacosx-ghc-7.10.3-r1.zip
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		# need libreadline, libgmp
		FEAT_BINARY_URL=https://haskell.org/platform/download/7.10.3/haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz
		FEAT_BINARY_URL_FILENAME=haskell-platform-7.10.3-unknown-posix-x86_64.tar.gz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/haskell
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_haskell_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_BINARY_URL_FILENAME"
}


fi
