if [ ! "$_xkcdpass_INCLUDED_" = "1" ]; then
_xkcdpass_INCLUDED_=1


# https://pypi.org/project/xkcdpass/
# https://github.com/redacted/XKCD-password-generator

feature_xkcdpass() {
	FEAT_NAME=xkcdpass

	FEAT_LIST_SCHEMA="1_17_2:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"

	FEAT_ENV_CALLBACK=feature_xkcdpass_env

	FEAT_DESC="Generate secure multiword passwords/passphrases, inspired by XKCD"
	FEAT_LINK="https://github.com/redacted/XKCD-password-generator"

}

feature_xkcdpass_env() {
	PYTHONPATH="$(PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" __python_get_site_packages_user_path):${PYTHONPATH}"
	export PYTHONPATH="${PYTHONPATH}"
}


feature_xkcdpass_1_17_2() {
	FEAT_VERSION=1_17_2

	FEAT_BINARY_DEPENDENCIES="miniconda3"

	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/bin/xkcdpass
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"/bin

}



feature_xkcdpass_install_binary() {
	INSTALL_DIR="${FEAT_INSTALL_ROOT}"

	PYTHONUSERBASE="${FEAT_INSTALL_ROOT}" pip install --no-warn-script-location --ignore-installed --upgrade --user "${FEAT_NAME}"=="$(echo ${FEAT_VERSION} |tr '_' '.')"

}



fi
