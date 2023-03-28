if [ ! "$_TEMPLATE_INCLUDED_" = "1" ]; then
_TEMPLATE_INCLUDED_=1

# NOTE : this kind of recipe is based on minicondaX and do not check specific python version
# if a feature needs a very specific python version (3.4.1), this may not work



# NOTE on install package in a specific folder
# https://stackoverflow.com/questions/2915471/install-a-python-package-into-a-different-directory-using-pip

# EXAMPLE : see feature_xkcdpass

# template_package_python_from_source : FLAVOUR source : install from python source
# template_package_python : FLAVOUR binary : install from pip or conda ==> TODO : but pip (but not conda?) may need gcc and other toolset, so this might not been a binary flavour ?

# ==> TODO : pip (but not conda?) may need gcc and other toolset, so this might not be a binary flavour ?

feature_template() {
	FEAT_NAME=template
	FEAT_LIST_SCHEMA="1_0_0:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_ENV_CALLBACK="feature_template_env"

	FEAT_DESC="template is foo"
	FEAT_LINK="https://github.com/bar/template"
}




feature_template_env() {
	PYTHONPATH="$(PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" __python_get_site_packages_user_path):${PYTHONPATH}"
	export PYTHONPATH="${PYTHONPATH}"
}


feature_template_1_0_0() {
	# if FEAT_ARCH (ie:FEAT_BINARY_URL_x86) is not not null, properties FOO_ARCH=BAR will be selected and setted as FOO=BAR (ie:FEAT_BINARY_URL)
	# if FOO_ARCH is empty, FOO will not be changed

	FEAT_VERSION=1_0_0

	# Dependencies
	FEAT_BINARY_DEPENDENCIES="miniconda3"




	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/template

	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}


feature_template_install_binary() {
	INSTALL_DIR="${FEAT_INSTALL_ROOT}"

	PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" pip install --no-warn-script-location --ignore-installed --upgrade --user "${FEAT_NAME}"=="$(echo ${FEAT_VERSION} |tr '_' '.')"

}




fi
