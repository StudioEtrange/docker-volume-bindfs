#!/usr/bin/env bash
_STELLA_CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#shellcheck source=conf.sh
. "$_STELLA_CURRENT_FILE_DIR"/conf.sh


# NOTE : use "env" with source (or .) command only
# NOTE : warn : some env var (like PATH) are cumulative
if [ "$1" = "env" ]; then
	# https://stackoverflow.com/questions/2683279/how-to-detect-if-a-script-is-being-sourced
	[[ "$0" != "$BASH_SOURCE" ]] && sourced=1 || sourced=0
	if [ "$sourced" = "0" ]; then
		echo "** use source"
		echo ". <stella.sh|stella-link.sh> env"
		exit 1
	fi
	__init_stella_env
	echo "** Current env is setted/refreshed with stella env"
else

usage() {
	echo "USAGE :"
	echo "----------------"
	echo "List of commands"
	echo " o-- application management :"
	echo " L     app init <application name> [--approot=<path>] [--workroot=<abs or relative path to approot>] [--cachedir=<abs or relative path to approot>] [--samples]"
	echo " L     app get-data|get-assets|delete-data|delete-assets|update-data|update-assets|revert-data|revert-assets <data id|assets id>"
	echo " L     app get-data-pack|get-assets-pack|update-data-pack|update-assets-pack|revert-data-pack|revert-assets-pack|delete-data-pack|delete-assets-pack <data pack name|assets pack name>"
	echo " L     app get-feature <all|feature schema> : install all features defined in app properties file or install a matching one"
	echo " L     app link <app-path> [--stellaroot=<path>] : link an app to the current or a specific stella path"
	echo " L     app vendor <app-path> [--stellaroot=<path>] : vendorize stella (current or a specific one) into an app"
	echo " L     app deploy <uri> [--cache] [--workspace] [--hidden] [--sudo] : deploy current app version to an uri. Could be to local filesystem, to ssh or to a vagrant machine. Vagrant use: vagrant://machine-name. [--cache] : include app cache folder. [--workspace] : include app workspace folder. [--sudo] : execute deploy as sudo. [--hidden] : exclude hidden files"
	echo " o-- feature management :"
	echo " L     feature install <feature schema> [--depforce] [--depignore] [--buildarch=x86|x64] [--export=<path>] [--portable=<path>] : install a feature. [--depforce] will force to reinstall all dependencies. [--depignore] will ignore dependencies. schema = feature_name[#version][@arch][:binary|source][/os_restriction][\\os_exclusion]"
	echo " L     feature remove <feature schema> : remove a feature"
	echo " L     feature info <feature schema> : show some feature informations"
	echo " L     feature list <all|feature name|active|full-active> : list all available feature OR available versions of a feature OR current active features OR full list of active features even hidden ones"
	echo " o-- various :"
	echo " L     stella api list : list public functions of stella api"
	echo " L     stella install dep : install all features and systems requirements if any, for the current OS ($STELLA_CURRENT_OS)"
	echo " L     stella version print : print stella version"
	echo " L     stella search path : print current system search path"
	echo " L     stella deploy <uri> [--cache] [--workspace] [--sudo] : deploy current stella version to an uri. Could be to local filesystem, to ssh or to a vagrant machine. Vagrant use: vagrant://machine-name. [--cache] : include stella cache folder. [--workspace] : include stella workspace folder. [--sudo] : execute deploy as sudo."
	echo " o-- network management :"
	echo " L     proxy on <proxy name> : active a registered proxy"
	echo " L     proxy off now : disable current proxy and deactivate registered proxy"
	echo " L     proxy reset now : disable and set to none current proxy values"
	echo " L     proxy register <proxy name> --proxy=<protocol://user:password@host:port> : register a web proxy"
	echo " L     proxy bypass <host> : register a host that will not use proxy"
	echo " L     proxy tunnel <proxy name> --bridge=<user:password@host> : set a ssh tunnel from localhost to registered proxy <name> through a bridge, and set web traffic to use this tunnel as web proxy"
	echo " o-- bootstrap management :"
	echo " L     boot shell <uri> : launch an interactive new shell with all stella env var setted inside an <uri> (use 'local' for current host)"
	echo " L     boot cmd <uri> -- <command> : execute a command inside an <uri> (use 'local' for current host)"
	echo " L     boot script <uri> --script=<script_path> [-- script arg]"
	echo " o-- system management : "
	echo " L     sys install <package name> : install  a system package -- WARN This will affect your system"
	echo " L     sys remove <package name> : remove a system package -- WARN This will affect your system"
	echo " L     sys list all : list all available system package name"
	echo " L     sys info host : print current host info"
	echo ""
	echo "Special Usage"
	echo " o-- current shell env :"
	echo " L     . <stella.sh|stella-link.sh> env : set the current shell env with all stella env var setted"
	echo " L     . <stella.sh|stella-link.sh> <cmd> : execute any previous stella command inside current shell env"
	echo "URI"
	echo "L     URI form is <[schema://][user[:password]@]host[:port][/abs_path|?rel_path]>"

}


# MAIN -----------------------------------------------------------------------------------

# arguments
PARAMETERS="
DOMAIN=                          'domain'     		a           'app feature stella proxy sys boot' '1'    										   				Action domain.
ACTION=                         'action'   					a           'reset info tunnel deploy script shell cmd version search remove on off register link vendor api install init get-data get-assets get-data-pack get-assets-pack delete-data delete-data-pack delete-assets delete-assets-pack update-data update-assets revert-data revert-assets update-data-pack update-assets-pack revert-data-pack revert-assets-pack get-feature install list'  '1'       	Action to compute.
ID=							 								''								s 						''	'1' 			A parameter
"
OPTIONS="
FORCE=''                       	'f'    		''            		b     		0     		'1'           			Force operation.
APPROOT=''						'' 			'path'				s 			0			'' 						App path (default current)
WORKROOT='' 					'' 			'path'				s 			0			''						Work app path (default equal to app path)
CACHEDIR=''						'' 			'path'				s 			0			''						Cache folder path
STELLAROOT=''                   ''          'path'              s           0           ''                      Stella path to link.
SAMPLES=''                      ''         ''                  b           0       '1'                     Generate app samples.
BRIDGE='' 						'' 			'uri'				s 			0			''					bridge uri in case of a web proxy tunnel
PROXY='' 					'' 			'uri'				s 			0			''					proxy uri
DEPFORCE=''						''    		''            		b     		0     		'1'           			Force reinstallation of all dependencies.
DEPIGNORE=''					''    		''            		b     		0     		'1'           		Will not process any dependencies.
EXPORT=''                     ''          'path'              s           0           ''                      	Export feature to this dir.
PORTABLE=''                   ''          'path'              s           0           ''                      Make a portable version of this feature in this dir
BUILDARCH=''				'a'				'arch'			a 			0 			 'x86 x64'
CACHE=''                       	''    		''            		b     		0     		'1'           			Include cache folder when deploying.
WORKSPACE=''                       	''    		''            		b     		0     		'1'           			Include workspace folder when deploying.
HIDDEN=''                       	''    		''            		b     		0     		'1'           			Exclude hidden files.
SUDO=''                       	''    		''            		b     		0     		'1'           			Execute as sudo.
SCRIPT=''                   ''          'path'              s           0           ''                      Script path.
"
__argparse "${BASH_SOURCE[0]}" "$OPTIONS" "$PARAMETERS" "Stella" "$(usage)" "EXTRA_ARG OTHERARG EXTRA_ARG_EVAL OTHERARG_EVAL" "$@"


# --------------- APP ----------------------------
if [ "$DOMAIN" = "app" ]; then
	__init_stella_env

	if [ "$ACTION" = "init" ]; then
		[ "$APPROOT" = "" ] && APPROOT="$STELLA_CURRENT_RUNNING_DIR/$ID"
		[ "$WORKROOT" = "" ] && WORKROOT="$APPROOT/workspace"
		[ "$CACHEDIR" = "" ] && CACHEDIR="$APPROOT/cache"

		__init_app "$ID" "$APPROOT" "$WORKROOT" "$CACHEDIR"
		[ "$SAMPLES" ] && __create_app_samples "$APPROOT"
	fi

	if [ "$ACTION" = "link" ]; then
		__link_app "$ID" "STELLA_ROOT $STELLAROOT"
	fi

	if [ "$ACTION" = "vendor" ]; then
		__vendorize_stella "$ID" "STELLA_ROOT $STELLAROOT"
	fi

	case $ACTION in
		init|link|vendor);;
		*)
		if [ ! -f "$_STELLA_APP_PROPERTIES_FILE" ]; then
				echo "** ERROR properties file does not exist"
				exit
		fi;;
	esac

	case $ACTION in
		deploy)
				_deploy_options=
				[ "$CACHE" = "1" ] && _deploy_options="CACHE"
				[ "$WORKSPACE" = "1" ] && _deploy_options="$_deploy_options WORKSPACE"
				[ "$HIDDEN" = "1" ] && _deploy_options="$_deploy_options EXCLUDE_HIDDEN"
				[ "$SUDO" = "1" ] && _deploy_options="$_deploy_options SUDO"
				__transfer_app "$ID" "$_deploy_options"
				;;
		get-feature)
				if [ "$ID" = "all" ]; then
						__get_features
				else
						__get_feature "$ID"
				fi
				;;
		get-data)
		__get_data "$ID";;
		get-data-pack)
		__get_data_pack "$ID";;
		get-assets)
		__get_assets "$ID";;
		get-assets-pack)
		__get_assets_pack "$ID";;
		delete-data)
		__delete_data "$ID";;
		delete-assets)
		__delete_assets "$ID";;
		delete-data-pack)
		__delete_data_pack "$ID";;
		delete-assets-pack)
		__delete_assets_pack "$ID";;
		udpate-data)
		__update_data "$ID";;
		update-assets)
		__update_assets "$ID";;
		revert-data)
		__revert_data "$ID";;
		revert-assets)
		__revert_assets "$ID";;
	esac
fi



# --------------- FEATURE ----------------------------
if [ "$DOMAIN" = "feature" ]; then
	__init_stella_env
	case $ACTION in
		remove)
			__feature_remove "$ID";;
	  install)
			[ ! "$BUILDARCH" = "" ] && __set_build_mode_default "ARCH" "$BUILDARCH"
			_OPT=
			[ "$DEPFORCE" = "1" ] && _OPT="$_OPT DEP_FORCE"
			[ "$DEPIGNORE" = "1" ] && _OPT="$_OPT DEP_IGNORE"
			[ ! "$EXPORT" = "" ] && _OPT="$_OPT EXPORT $EXPORT"
			[ ! "$PORTABLE" = "" ] && _OPT="$_OPT PORTABLE $PORTABLE"
			__feature_install "$ID" "$_OPT"
			;;

		info)
			__feature_catalog_info "$ID"
			if [ ! "$FEAT_SCHEMA_SELECTED" = "" ]; then
				echo "** $FEAT_NAME"
				echo " Available versions : $FEAT_LIST_SCHEMA"
				echo " Link : $FEAT_LINK"
				echo " $FEAT_DESC"
			else
				echo "** Feature unknown"
			fi
			;;

		list)
			case $ID in
				all)
					echo "STABLE : $__STELLA_FEATURE_LIST_STABLE"
					echo "EXPERIMENTAL : $__STELLA_FEATURE_LIST_EXP"
					;;
				active)
					#echo "$(__list_active_features)"
					__list_active_features
					;;
				full-active)
					__list_active_features_full
					;;
				*)
					#echo "$(__list_feature_version $ID)"
					__list_feature_version "$ID"
					;;
			esac
			;;
	esac
fi


# --------------- SYS ----------------------------
if [ "$DOMAIN" = "sys" ]; then
	__init_stella_env
	if [ "$ACTION" = "install" ]; then
		__sys_install "$ID"
	fi
	if [ "$ACTION" = "remove" ]; then
		__sys_remove "$ID"
	fi
	if [ "$ACTION" = "list" ]; then
		echo "$STELLA_SYS_PACKAGE_LIST"
	fi

	if [ "$ACTION" = "info" ]; then
		$STELLA_ARTEFACT/screenFetch/screenfetch-dev -v -E
	fi
fi

# --------------- BOOT ----------------------------
if [ "$DOMAIN" = "boot" ]; then
	__init_stella_env

	[ "$SUDO" = "1" ] && _options="SUDO"

	if [ "$ACTION" = "cmd" ]; then
		if [ "$STELLA_APP_IS_STELLA" = "1" ]; then
			__boot_stella_cmd "$ID" "$OTHERARG_EVAL" "$_options"
		else
			__boot_app_cmd "$ID" "$OTHERARG_EVAL" "$_options"
		fi
	fi
	if [ "$ACTION" = "shell" ]; then
		if [ "$STELLA_APP_IS_STELLA" = "1" ]; then
			__boot_stella_shell "$ID" "$_options"
		else
			__boot_app_shell "$ID" "$_options"
		fi
	fi
	if [ "$ACTION" = "script" ]; then
		if [ "$SCRIPT" = "" ]; then
			__log "ERROR" "** ERROR : please specify a script path"
			exit 1
		fi
		if [ "$STELLA_APP_IS_STELLA" = "1" ]; then
			__boot_stella_script "$ID" "$SCRIPT" "$OTHERARG_EVAL" "$_options"
		else
			__boot_app_script "$ID" "$SCRIPT" "$OTHERARG_EVAL" "$_options"
		fi
	fi
fi

# --------------- PROXY ----------------------------
if [ "$DOMAIN" = "proxy" ]; then
	__init_stella_env

	if [ "$ACTION" = "tunnel" ]; then
		__proxy_tunnel "$ID" "$BRIDGE"
	fi
	if [ "$ACTION" = "on" ]; then
		__enable_proxy "$ID"
	fi
	if [ "$ACTION" = "off" ]; then
		__disable_proxy
	fi
	if [ "$ACTION" = "reset" ]; then
		__reset_proxy
	fi
	if [ "$ACTION" = "bypass" ]; then
		__register_no_proxy "$ID"
	fi
	if [ "$ACTION" = "register" ]; then
		__register_proxy "$ID" "$PROXY"
	fi
fi

# --------------- STELLA ----------------------------
if [ "$DOMAIN" = "stella" ]; then
	__init_stella_env

	if [ "$ACTION" = "api" ]; then
		if [ "$ID" = "list" ]; then
			#echo "$(__api_list)"
			__api_list
		fi
	fi

	if [ "$ACTION" = "install" ]; then
		if [ "$ID" = "dep" ]; then
			__stella_requirement
		fi
	fi

	if [ "$ACTION" = "version" ]; then
		if [ "$ID" = "print" ]; then
			v1="$(__get_stella_flavour)"
			v2="$(__get_stella_version)"
			echo "$v1 -- $v2"
		fi
	fi

	if [ "$ACTION" = "search" ]; then
    if [ "$ID" = "path" ]; then
        #echo "$(__get_active_path)"
				__get_active_path
    fi
	fi

	if [ "$ACTION" = "deploy" ]; then
		_deploy_options=
		[ "$CACHE" = "1" ] && _deploy_options="CACHE"
		[ "$WORKSPACE" = "1" ] && _deploy_options="$_deploy_options WORKSPACE"
		[ "$SUDO" = "1" ] && _deploy_options="$_deploy_options SUDO"
		__transfer_stella "$ID" "$_deploy_options"
	fi

fi


__log "INFO" "** END **"
fi
