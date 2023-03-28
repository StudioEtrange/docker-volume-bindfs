if [ ! "$_glances_INCLUDED_" = "1" ]; then
_glances_INCLUDED_=1

# NOTE
# glances have plugins, they can be installed with
# pip install 'glances[action,browser,cloud,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]'

# TODO : need gcc when pip install ! pip install is not a binary "flavour"
feature_glances() {
	FEAT_NAME=glances

	FEAT_LIST_SCHEMA="3_1_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_ENV_CALLBACK="feature_glances_env"

	FEAT_DESC="Glances is a cross-platform system monitoring tool written in Python."
	FEAT_LINK="https://nicolargo.github.io/glances"
}




feature_glances_env() {
	PYTHONPATH="$(PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" __python_get_site_packages_user_path):${PYTHONPATH}"
	export PYTHONPATH="${PYTHONPATH}"
}


feature_glances_3_1_0() {
	FEAT_VERSION=3_1_0

	# Dependencies
	FEAT_BINARY_DEPENDENCIES="miniconda3"




	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/glances

	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_glances_install_binary() {
	INSTALL_DIR="${FEAT_INSTALL_ROOT}"

	PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" pip install --no-warn-script-location --ignore-installed --upgrade --user "${FEAT_NAME}"=="$(echo ${FEAT_VERSION} |tr '_' '.')"

}




fi
