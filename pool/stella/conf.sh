#!sh
if [ ! "$_STELLA_CONF_INCLUDED_" = "1" ]; then
_STELLA_CONF_INCLUDED_=1

# disable PATH lookup command cache
set -h

# DEBUG STELLA
#set -x
#set -xv

_STELLA_CONF_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$STELLA_CURRENT_RUNNING_DIR" = "" ]; then
	#STELLA_CURRENT_RUNNING_DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" && pwd )"
	STELLA_CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"
fi
_STELLA_CONF_CURRENT_FILE="$_STELLA_CONF_CURRENT_FILE_DIR/$(basename ${BASH_SOURCE[0]})"


# STELLA PATHS ---------------------------------------------
STELLA_ROOT="$_STELLA_CONF_CURRENT_FILE_DIR"
STELLA_COMMON="$STELLA_ROOT/nix/common"
STELLA_POOL="$STELLA_ROOT/nix/pool"
STELLA_PATCH="$STELLA_POOL/patch"
STELLA_FEATURE_RECIPE="$STELLA_POOL/feature-recipe"
STELLA_FEATURE_RECIPE_EXPERIMENTAL="$STELLA_FEATURE_RECIPE/exp"

STELLA_ARTEFACT="$STELLA_POOL/artefact"
STELLA_APPLICATION="$STELLA_ROOT/app"
STELLA_TEMPLATE="$STELLA_POOL/template"

# URL PATHS ---------------------------------------------
STELLA_URL="http://stella.sh"
STELLA_POOL_URL="$STELLA_URL/pool"
STELLA_ARTEFACT_URL="$STELLA_POOL_URL/nix/artefact"
STELLA_FEATURE_RECIPE_URL="$STELLA_POOL_URL/nix/feature-recipe"
STELLA_DIST_URL="$STELLA_URL/dist"

# SITE SCHEMA
# /pool
# /pool/nix
# /pool/nix/feature-recipe
# /pool/nix/artefact
# /dist

# STELLA INCLUDE ---------------------------------------------

#shellcheck source=nix/common/common-algorithm.sh
. $STELLA_COMMON/common-algorithm.sh
#shellcheck source=nix/common/common-log.sh
. $STELLA_COMMON/common-log.sh
#shellcheck source=nix/common/common-platform.sh
. $STELLA_COMMON/common-platform.sh
#shellcheck source=nix/common/common.sh
. $STELLA_COMMON/common.sh
#shellcheck source=nix/common/common-feature.sh
. $STELLA_COMMON/common-feature.sh
#shellcheck source=nix/common/common-app.sh
. $STELLA_COMMON/common-app.sh
#shellcheck source=nix/common/common-lib-parse-bin.sh
. $STELLA_COMMON/lib-parse-bin.sh
#shellcheck source=nix/common/common-binary.sh
. $STELLA_COMMON/common-binary.sh
#shellcheck source=nix/common/common-build.sh
. $STELLA_COMMON/common-build.sh
#shellcheck source=nix/common/common-build-toolset.sh
. $STELLA_COMMON/common-build-toolset.sh
#shellcheck source=nix/common/common-build-env.sh
. $STELLA_COMMON/common-build-env.sh
#shellcheck source=nix/common/common-build-link.sh
. $STELLA_COMMON/common-build-link.sh
#shellcheck source=nix/common/common-api.sh
. $STELLA_COMMON/common-api.sh
#shellcheck source=nix/common/lib-sfx.sh
. $STELLA_COMMON/lib-sfx.sh
#shellcheck source=nix/common/common-network.sh
. $STELLA_COMMON/common-network.sh
#shellcheck source=nix/common/common-boot.sh
. $STELLA_COMMON/common-boot.sh

# STELLA ARTEFACT INCLUDE ---------------------------------------------

#. $STELLA_ARTEFACT/bash_ini_parser/read_ini_next.sh
. $STELLA_ARTEFACT/bash_ini_parser/read_ini.sh

# LOG ---------------------------
# Before include stella-link.sh, you can override log state
# 	STELLA_LOG_STATE="OFF" ==> Disable log
# STELLA_LOG_STATE : ON|OFF
STELLA_LOG_STATE_DEFAULT="ON"
STELLA_LOG_LEVEL_DEFAULT="1"
[ "$STELLA_LOG_STATE" = "" ] && __set_log_state "$STELLA_LOG_STATE_DEFAULT"
[ "$STELLA_LOG_LEVEL" = "" ] && __set_log_level "$STELLA_LOG_LEVEL_DEFAULT"


# GATHER PLATFORM INFO ---------------------------------------------
__set_current_platform_info

# GATHER CURRENT APP INFO ---------------------------------------------
# Before include stella-link.sh, you can override file properties file
# 	STELLA_APP_PROPERTIES_FILENAME="foo.properties" ==> change properties name
[ "$STELLA_APP_PROPERTIES_FILENAME" = "" ] && STELLA_APP_PROPERTIES_FILENAME="stella.properties"

# define if current app is stella itself
STELLA_APP_IS_STELLA=0

# default app root folder is stella root folder
if [ "$STELLA_APP_ROOT" = "" ]; then
	# STELLA_APP_ROOT is define in stella-link file
	STELLA_APP_ROOT="$STELLA_ROOT"
	STELLA_APP_IS_STELLA=1
	STELLA_APP_NAME=stella
else
	STELLA_APP_NAME=
	_STELLA_APP_PROPERTIES_FILE="$(__select_app $STELLA_APP_ROOT)"
	__get_all_properties $_STELLA_APP_PROPERTIES_FILE

	[ "$STELLA_APP_NAME" = "" ] && STELLA_APP_NAME=default-app
fi


# you can override STELLA_ARGPARSE_GETOPT in properties file
# STELLA_ARGPARSE_GETOPT : getopt command instead of "getopt"
# STELLA_ARGPARSE_GETOPT_DEFAULT is the default value depending of the current platform (defined in common-platform.sh)
# <command> | PURE_BASH
if [ "$STELLA_ARGPARSE_GETOPT" = "" ]; then
	STELLA_ARGPARSE_GETOPT=$STELLA_ARGPARSE_GETOPT_DEFAULT
fi



# APP PATH ---------------------------------------------
STELLA_APP_ROOT=$(__rel_to_abs_path "$STELLA_APP_ROOT" "$STELLA_CURRENT_RUNNING_DIR")

[ "$STELLA_APP_WORK_ROOT" = "" ] && STELLA_APP_WORK_ROOT="$STELLA_APP_ROOT/workspace"
STELLA_APP_WORK_ROOT=$(__rel_to_abs_path "$STELLA_APP_WORK_ROOT" "$STELLA_APP_ROOT")

[ "$STELLA_APP_CACHE_DIR" = "" ] && STELLA_APP_CACHE_DIR="$STELLA_APP_ROOT/cache"
STELLA_APP_CACHE_DIR=$(__rel_to_abs_path "$STELLA_APP_CACHE_DIR" "$STELLA_APP_ROOT")

STELLA_APP_TEMP_DIR="$STELLA_APP_WORK_ROOT/temp"
STELLA_APP_FEATURE_ROOT="$STELLA_APP_WORK_ROOT/feature_$STELLA_CURRENT_PLATFORM_SUFFIX/$STELLA_CURRENT_ARCH/$STELLA_CURRENT_OS"
ASSETS_ROOT="$STELLA_APP_WORK_ROOT/assets"
ASSETS_REPOSITORY=$(__rel_to_abs_path "../assets_repository" "$STELLA_APP_WORK_ROOT")

# for internal features
STELLA_INTERNAL_WORK_ROOT=$STELLA_ROOT/workspace
STELLA_INTERNAL_FEATURE_ROOT=$STELLA_INTERNAL_WORK_ROOT/feature_$STELLA_CURRENT_PLATFORM_SUFFIX/$STELLA_CURRENT_ARCH/$STELLA_CURRENT_OS
STELLA_INTERNAL_CACHE_DIR=$STELLA_ROOT/cache
STELLA_INTERNAL_TEMP_DIR=$STELLA_INTERNAL_WORK_ROOT/temp

STELLA_INTERNAL_TOOLSET_ROOT=$STELLA_INTERNAL_WORK_ROOT/toolset_$STELLA_CURRENT_PLATFORM_SUFFIX/$STELLA_CURRENT_ARCH/$STELLA_CURRENT_OS


# current config env
# Before include stella-link.sh, you can override env file
# 	STELLA_APP_ENV_FILE="$HOME/.my-env" ==> change stella config env
# or you can override it with a APP_ENV_FILE in properties file
if [ "$STELLA_APP_ENV_FILE" = "" ]; then
	# app env config has priority over stella config env
	if [ -f "$STELLA_APP_ROOT/.stella-env" ]; then
		STELLA_APP_ENV_FILE="$STELLA_APP_ROOT/.stella-env"
		STELLA_ENV_FILE=$STELLA_APP_ENV_FILE
	else
		STELLA_ENV_FILE="$STELLA_ROOT/.stella-env"
	fi
else
	STELLA_ENV_FILE=$STELLA_APP_ENV_FILE
fi


# OTHERS ---------------------------------------------
FEATURE_LIST_ENABLED=
FEATURE_LIST_ENABLED_VISIBLE=
STELLA_DEFAULT_NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"


# FEATURE LIST---------------------------------------------
__STELLA_FEATURE_LIST=
__STELLA_FEATURE_LIST_STABLE=
__STELLA_FEATURE_LIST_EXP=

# add standard repo
__feature_add_repo "$STELLA_FEATURE_RECIPE" "__STELLA_FEATURE_LIST_STABLE"
# add experimental repo
__feature_add_repo "$STELLA_FEATURE_RECIPE_EXPERIMENTAL" "__STELLA_FEATURE_LIST_EXP"

# Before include stella-link.sh
# 	STELLA_FEATURE_RECIPE_EXTRA=/foo/recipe ==> add a recipe folder
__STELLA_FEATURE_LIST_EXTRA=
if [ ! "$STELLA_FEATURE_RECIPE_EXTRA" = "" ]; then
	__feature_add_repo "$STELLA_FEATURE_RECIPE_EXTRA" "__STELLA_FEATURE_LIST_EXTRA"
fi


# these features will be picked from the system
# have an effect only for feature declared in FEAT_SOURCE_DEPENDENCIES, FEAT_BINARY_DEPENDENCIES or passed to __link_feature_libray
[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && STELLA_FEATURE_FROM_SYSTEM="python krb5"
[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && STELLA_FEATURE_FROM_SYSTEM="openssl python krb5"

# SYS PACKAGE --------------------------------------------
# list of available installable system package
[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && STELLA_SYS_PACKAGE_LIST="git brew x11 build-chain-standard sevenzip wget curl unzip cmake"
[ "$STELLA_CURRENT_PLATFORM" = "linux" ] && STELLA_SYS_PACKAGE_LIST="git build-chain-standard sevenzip wget curl unzip cmake"



# BUILD MODULE ---------------------------------------------

# parallelize build (except specificied unparallelized one)
# ON | OFF
__set_build_mode_default "PARALLELIZE" "ON"
# compiler optimization
__set_build_mode_default "OPTIMIZATION" "2"


# Define linking mode.
# have an effect only for feature linked with __link_feature_libray (do not ovveride specific FORCE_STATIC or FORCE_DYNAMIC)
# DEFAULT | STATIC | DYNAMIC
__set_build_mode_default "LINK_MODE" "DEFAULT"
# TODO : REWORK
# rellocatable shared libraries
# you will not enable to move from another system any binary (executable or shared libs) linked to stella shared libs
# everything will be sticked to your stella shared lib installation path
# this will affect rpath values (and install_name for darwin)
__set_build_mode_default "RELOCATE" "OFF"
# DEFAULT | ABSOLUTE | RELATIVE
STELLA_FEATURE_LINK_PATH="DEFAULT"
__set_build_mode_default "LINK_PATH" "$STELLA_FEATURE_LINK_PATH"


# ARCH x86 x64
# By default we do not provide any build arch information
#__set_build_mode_default "ARCH" ""
# do not mix CPPFLAGS with CXXFLAGS and CFLAGS
__set_build_mode_default "MIX_CPP_C_FLAGS" "OFF"
# activate some usefull default linker flags
__set_build_mode_default "LINK_FLAGS_DEFAULT" "ON"

[ "$STELLA_CURRENT_OS" = "macos" ] && __set_build_mode_default MACOSX_DEPLOYMENT_TARGET "$(__get_macos_version)"

STELLA_BUILD_DEFAULT_TOOLSET="STANDARD"


# TODO : useless
# . is current running directory
# $ORIGIN and @loader_path is directory of the file who wants to load a shared library
# NOTE : '@loader_path' does not work, you have to write '@loader_path/.'
# NOTE : $ORIGIN may have problem with cmake, see : http://www.cmake.org/pipermail/cmake/2008-January/019290.html
STELLA_BUILD_RPATH_DEFAULT=

# buid engine reset
__reset_build_env

# BINARY MODULE ---------------------------
# linked libs we do not want to tweak (change link to)
STELLA_BINARY_DEFAULT_LIB_IGNORED='^/System/Library|^/usr/lib|^/lib'


# API ---------------------------------------------
STELLA_API_COMMON_PUBLIC="uri_parse_stream crontab_add crontab_remove filter_version_list string_contains htpasswd_md5 htpasswd_sha1 htpasswd_crypt list_contains filter_list_with_list is_dir_empty list_filter_duplicate abs_to_rel_path symlink_abs_to_rel_path random_number_list_from_range format_table generate_password generate_machine_id sha256 is_logical_equalpath is_logical_subpath sort_version transfer_stella filter_list uri_build_path uri_get_path uri_parse find_folder_up get_active_path uncompress daemonize rel_to_abs_path is_abs argparse get_filename_from_string \
get_resource delete_resource update_resource revert_resource download_uncompress copy_folder_content_into del_folder \
get_key get_keys add_key del_key mercurial_project_version git_project_version get_stella_version \
make_sevenzip_sfx_bin make_targz_sfx_shell compress trim transfer_stella transfer_folder_rsync transfer_file_rsync md5"
STELLA_API_API_PUBLIC="api_connect api_disconnect"
STELLA_API_APP_PUBLIC="transfer_app get_app_property link_app get_data get_assets get_data_pack get_assets_pack delete_data delete_assets delete_data_pack delete_assets_pack update_data update_assets revert_data revert_assets update_data_pack update_assets_pack revert_data_pack revert_assets_pack get_feature get_features remove_features install_features uninstall_features"
STELLA_API_FEATURE_PUBLIC="feature_add_repo feature_info list_feature_version feature_remove feature_remove_list feature_catalog_info feature_install feature_install_list feature_init list_active_features feature_reinit_installed feature_inspect"
STELLA_API_BINARY_PUBLIC="tweak_linked_lib get_rpath add_rpath check_rpath check_binary_file tweak_binary_file"
STELLA_API_BUILD_PUBLIC="toolset_info set_toolset start_build_session set_build_mode auto_build"
STELLA_API_PLATFORM_PUBLIC="ansible_play ansible_play_localhost python_get_lib_dir python_get_include_dir python_get_bin_dir python_get_site_packages_global_path python_get_site_packages_user_path python_get_standard_packages_path yum_proxy_unset yum_proxy_unset_repo yum_proxy_set yum_proxy_set_repo yum_add_extra_repositories yum_remove_extra_repositories python_build_get_libs python_build_get_includes python_build_get_ldflags python_build_get_clags python_build_get_prefix python_major_version python_short_version sys_install sys_remove require"
STELLA_API_NETWORK_PUBLIC="find_free_port get_ip_external check_tcp_port_open ssh_execute get_ip_from_hostname get_ip_from_interface proxy_tunnel enable_proxy disable_proxy no_proxy_for register_proxy register_no_proxy"
STELLA_API_BOOT_PUBLIC="boot_stella_shell boot_stella_cmd boot_stella_script boot_app_shell boot_app_cmd boot_app_script"
STELLA_API_LOG_PUBLIC="log set_log_level set_log_state"
STELLA_API_ALGORITHM_PUBLIC="stack_init stack_push stack_pop"

# SAMPLE : to test a function that return an exit code :
# 		if $($STELLA_API "is_dir_empty" "/bin"); then
# 			echo empty
# 		else
# 			echo non empty
# 		fi
STELLA_API=__api_proxy


fi
