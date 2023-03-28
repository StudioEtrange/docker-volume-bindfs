if [ ! "$_lynis_INCLUDED_" = "1" ]; then
_lynis_INCLUDED_=1


feature_lynis() {
	FEAT_NAME=lynis
	FEAT_LIST_SCHEMA="3_0_4:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="Security auditing tool for Linux, macOS, and UNIX-based systems. Assists with compliance testing (HIPAA/ISO27001/PCI DSS) and system hardening. Agentless, and installation optional."
	FEAT_LINK="https://cisofy.com/lynis/"
}


# NOTE : lynis MUST be launched within its directory
feature_lynis_setenv() {
	LYNIS_HOME="$FEAT_INSTALL_ROOT"
	export LYNIS_HOME

	lynis() {
		(
			cd "$LYNIS_HOME"
			command lynis "$@"
		)
	}

	lynis_root() {
		(
			cd "$LYNIS_HOME"
			sudo "$LYNIS_HOME/lynis" "$@"
		)
	}

	echo "LYNIS command is overrided to fix the fact it needs to be run from its own install directory."
	echo "NOTE that to use lynis with sudo/root use lynis_root command"
}



feature_lynis_3_0_4() {
	FEAT_VERSION=3_0_4



	FEAT_SOURCE_URL="https://github.com/CISOfy/lynis/archive/refs/tags/3.0.4.tar.gz"
	FEAT_SOURCE_URL_FILENAME="lynis_3.0.4.tar.gz"
	FEAT_SOURCE_URL_PROTOCOL="HTTP_ZIP"

	FEAT_ENV_CALLBACK="feature_lynis_setenv"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/lynis
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}



feature_lynis_install_source() {
	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP FORCE_NAME $FEAT_SOURCE_URL_FILENAME"


}


fi
