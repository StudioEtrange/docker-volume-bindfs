if [ ! "$_GOCROSSCOMPILE_INCLUDED_" = "1" ]; then
_GOCROSSCOMPILE_INCLUDED_=1


# NOTE : deprecated cause gonative is deprecated and no longer usefull


feature_go-crosscompile-chain() {
	FEAT_NAME="go-crosscompile-chain"
	FEAT_LIST_SCHEMA="1_4_3"
	FEAT_DEFAULT_ARCH=

	FEAT_BUNDLE=NESTED
}

feature_go-crosscompile-chain_1_4_3() {
	FEAT_VERSION=1_4_3

	# need gcc
	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_BUNDLE_ITEM="go#1_4_3"

	FEAT_ENV_CALLBACK=feature_go_crosschain_setenv
	FEAT_BUNDLE_CALLBACK="feature_go_crosschain_setenv feature_go_prepare_crosschain"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT/_GONATIVE_TOOLCHAIN_/go/pkg/windows_386/go/parser.a"
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT/_WORKSPACE_/bin:$FEAT_INSTALL_ROOT/_GONATIVE_TOOLCHAIN_/go/bin"

	BUILDCHAIN_GO_VERSION="$FEAT_VERSION"
}


feature_go_crosschain_setenv() {
	GOPATH="$FEAT_INSTALL_ROOT/_WORKSPACE_"

	echo " ** GOLANG cross-compile environment"
	echo " GOROOT = $GOROOT"
	echo " GOPATH = $GOPATH"
	echo "   ** To restore your dependencies from folder containing Godeps :"
	echo "      godep restore"
	echo "   ** Cross-compile your project from source"
	echo "      gox -verbose -osarch=\"windows/386 windows/amd64 linux/386 linux/amd64 darwin/386 darwin/amd64\" <PATH_TO_PROJECT_ROOT|PROJECT_NAME in your GOPATH>"
}


feature_go_prepare_crosschain() {
	PATH="$FEAT_SEARCH_PATH:$PATH"


	echo "** install godep"
	go get github.com/tools/godep

	echo "** install gox"
  go get github.com/mitchellh/gox

	echo "** install gonative"
	go get github.com/inconshreveable/gonative

	echo "** build toolchain"
	mkdir -p "$FEAT_INSTALL_ROOT/_GONATIVE_TOOLCHAIN_"
	cd "$FEAT_INSTALL_ROOT/_GONATIVE_TOOLCHAIN_"
	gonative build --version="$BUILDCHAIN_GO_VERSION" --platforms="windows_386 windows_amd64 linux_386 linux_amd64 darwin_386 darwin_amd64"

}

fi
