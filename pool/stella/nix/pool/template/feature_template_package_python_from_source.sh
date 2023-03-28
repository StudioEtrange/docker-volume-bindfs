if [ ! "$_TEMPLATE_INCLUDED_" = "1" ]; then
_TEMPLATE_INCLUDED_=1



# NOTE : this kind of recipe is based on minicondaX and do not check specific python version
# if a feature needs a very specific python version (3.4.1), this may not work

# NOTE : https://stackoverflow.com/questions/41535915/python-pip-install-from-local-dir

# EXAMPLE : see feature_ansible

# template_package_python_from_source : FLAVOUR source : install from python source
# template_package_python : FLAVOUR binary : install from pip or conda ==> TODO : but pip (but not conda?) may need gcc and other toolset, so this might not been a binary flavour ?

feature_template() {
	FEAT_NAME=template
	FEAT_LIST_SCHEMA="1_0_0:source"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="source"

	FEAT_DESC="template is foo"
	FEAT_LINK="https://github.com/bar/template"
}




feature_template_1_0_0() {
	# if FEAT_ARCH (ie:FEAT_BINARY_URL_x86) is not not null, properties FOO_ARCH=BAR will be selected and setted as FOO=BAR (ie:FEAT_BINARY_URL)
	# if FOO_ARCH is empty, FOO will not be changed

	FEAT_VERSION=1_0_0

	# Dependencies
	FEAT_SOURCE_DEPENDENCIES="miniconda3"


	# For multiple FEAT_SOURCE_URL or FEAT_BINARY_URL, there is 1 example methods in gcc recipe

	# Properties for SOURCE flavour
	FEAT_SOURCE_URL=https://releases.tenplate.com/tenplate/tenplate-2.7.2.tar.gz
	FEAT_SOURCE_URL_FILENAME=tenplate-2.7.2.tar.gz
	FEAT_SOURCE_URL_PROTOCOL=HTTP_ZIP

	# List of files to test if feature is installed
	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/tenplate

	# PATH to add to system PATH
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_template_install_source() {
	INSTALL_DIR="$FEAT_INSTALL_ROOT"

	__set_toolset "STANDARD"

	__get_resource "$FEAT_NAME" "$FEAT_SOURCE_URL" "$FEAT_SOURCE_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "DEST_ERASE STRIP"

	pip install -e "$INSTALL_DIR"

	__feature_callback

}





fi
