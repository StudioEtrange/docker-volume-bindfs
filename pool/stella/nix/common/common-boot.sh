#!sh
if [ ! "$_STELLA_BOOT_INCLUDED_" = "1" ]; then
_STELLA_BOOT_INCLUDED_=1


# TODO : when booting a script, how pass arg to script ?


# [schema://][user[:password]@][host][:port][/abs_path|?rel_path]
# schema values
#     local:// (or just 'local')
#          (with local, host is never used. i.e : local:///abs_path local://?rel_path)
#     ssh://
#     vagrant://
#          (with vagrant, use vagrant machine name as host)



# When schema is 'ssh' or 'vagrant'
#     <path> is computed from default path when logging in ssh and then applying abs_path|rel_path
#     current folder for action is setted to <path>
#     When booting 'stella'
#         stella is sync with its env file in <path>/stella
#         stella requirements are installed
#         When action is
#               'shell' : launch a shell with a bootstrapped stella env inside shell
#               'script' : script is sync in <path>/<script.sh> then launch the script
#               'cmd' : eval a cmd with <path> as current folder AND inside a bootstraped stella env
#     When booting an 'app'
#         app is sync in <path>/app
#         stella is sync with its env file accordingly to its position defined in stella-link file [only if stella is outside of app]
#         stella requirements are installed
#         When action is
#               'shell' : launch a shell with a bootstrapped stella env inside shell, launched from app stella-link file
#               'script' : script is sync in <path>/<script.sh> then launch the script
#               'cmd' : launch a cmd with <path> as current folder (HERE : stella env is not bootstrapped!)


# When schema is 'local'
#     <path> is computed from current running path and then applying abs_path|rel_path
#            if abs_path|rel_path are not provided, then <path> is considered as NULL
#     current folder for wanted action is setted to <path> [if <path> is not NULL]
#     When booting 'stella'
#         stella is sync with its env file in <path>/stella [if <path> is not NULL]
#         stella requirements are NOT installed
#         When action is
#               'shell' : launch a shell with a bootstrapped stella env inside shell
#               'script' : script is sync in <path>/<script.sh> [if <path> is not NULL] then launch the script
#               'cmd' : eval a cmd with <path> as current folder AND inside a bootstraped stella env
#     When booting an 'app'
#         app is sync in <path>/app [if <path> is not NULL]
#         stella is sync with its env file accordingly to its position defined in stella-link file [only if stella is outside of app AND if <path> is not NULL]
#         stella requirements are NOT installed
#         When action is
#               'shell' : launch a shell with a bootstrapped stella env inside shell, launched from app stella-link file
#               'script' : script is sync in <path>/<script.sh> [if <path> is not NULL] then launch the script
#               'cmd' : launch a cmd with <path> as current folder (HERE : stella env is not bootstrapped!)


# SAMPLES
# from an app
# ./stella-link.sh boot shell vagrant://default
# ./stella-link.sh boot shell local
# from stella folder itself
# ./stella.sh boot shell vagrant://default
# ./stella.sh boot shell local


# MAIN FUNCTION -----------------------------------------
__boot_stella_shell() {
  local _uri="$1"
  local _opt="$2"
  __boot "$_opt STELLA SHELL" "$_uri"
}
__boot_stella_cmd() {
  local _uri="$1"
  local _cmd="$2"
  local _opt="$3"
  __boot "$_opt STELLA CMD" "$_uri" "$_cmd"
}
__boot_stella_script() {
  local _uri="$1"
  local _script="$2"
  local _arg="$3"
  local _opt="$4"
  __boot "$_opt STELLA SCRIPT" "$_uri" "$_script" "$_arg"
}


__boot_app_shell() {
  local _uri="$1"
  local _opt="$2"
  __boot "$_opt APP SHELL" "$_uri"
}
__boot_app_cmd() {
  local _uri="$1"
  local _cmd="$2"
  local _opt="$3"
  __boot "$_opt APP CMD" "$_uri" "$_cmd"
}
__boot_app_script() {
  local _uri="$1"
  local _script="$2"
  local _arg="$3"
  local _opt="$4"
  __boot "$_opt APP SCRIPT" "$_uri" "$_script" "$_arg"
}





# INTERNAL -----------------------------------------


# ITEM : APP | STELLA
# MODE : SHELL | CMD | SCRIPT
# OTHER OPTIONS : SUDO COPY_LINKS
# NOTE : when using ssh while booting commands, it use shared connection by default
__boot() {
  local _opt="$1"
  local _uri="$2"
  local _arg="$3"
  local _arg2="$4"

  local _mode=
  local _item=
  local _opt_sudo=
  local _opt_copy_links=
  local _opt_delete_excluded=
  for o in $_opt; do
    [ "$o" = "SCRIPT" ] && _mode="SCRIPT"
    [ "$o" = "SHELL" ] && _mode="SHELL"
		[ "$o" = "CMD" ] && _mode="CMD"

		[ "$o" = "APP" ] && _item="APP"
    [ "$o" = "STELLA" ] && _item="STELLA"

		[ "$o" = "SUDO" ] && _opt_sudo="SUDO"
    [ "$o" = "COPY_LINKS" ] && _opt_copy_links="COPY_LINKS"
    [ "$o" = "DELETE_EXCLUDED" ] && _opt_delete_excluded="DELETE_EXCLUDED"
	done

  __log "INFO" "** ${_opt_sudo} Boot $_item $_mode to $_uri with '$_arg'"

  local __have_to_transfer=0

  if [ "$_uri" = "local" ]; then
    # we do not have to transfer anything
    __have_to_transfer=0
    __stella_uri_schema="local"

  else
    # [schema://][user[:password]@][host][:port][/abs_path|?rel_path]
    __have_to_transfer=1

    __path="$(__uri_get_path "$_uri")"
    __uri_parse "$_uri"

    # TODO : dangerous tweak because it impacts the target OS.
    #       Maybe, use __ssh_sudo_begin_session only with an explicit option like --sudopersist
    if [ ! "$_opt_sudo" = "" ]; then
      case $__stella_uri_schema in
        #local )
          # NOTE : do not use this because it catch exit signal
          #     and could have side effect when bootstrapping an env
          #__sudo_begin_session
        #;;
        ssh|vagrant )
          __sudo_ssh_begin_session "$_uri"
        ;;
      esac
    fi

    # boot stella itself
    if [ "$_item" = "STELLA" ]; then
      __transfer_stella "$_uri" "ENV $_opt_sudo $_opt_delete_excluded"

      __boot_folder="$__path"
      if [ "$__stella_uri_schema" = "local" ]; then
        # compute relative boot folder to current running dir when on local
        if [ "$(__is_abs "$__boot_folder")" = "FALSE" ]; then
          __boot_folder="$(__rel_to_abs_path "$__boot_folder")"
        fi
      fi
      __stella_path="stella"
      __stella_entrypoint="$__stella_path/stella.sh"
    fi

    if [ "$_item" = "APP" ]; then
      # boot an app
      __transfer_app "$_uri" "$_opt_sudo $_opt_copy_links $_opt_delete_excluded"

      __boot_folder="$__path"
      if [ "$__stella_uri_schema" = "local" ]; then
        # compute relative boot folder to current running dir when on local
        if [ "$(__is_abs "$__boot_folder")" = "FALSE" ]; then
          __boot_folder="$(__rel_to_abs_path "$__boot_folder")"
        fi
      fi
      __app_path="$(basename "$STELLA_APP_ROOT")"
      __stella_entrypoint="${__app_path}/stella-link.sh"
    fi

    if [ "$_mode" = "SCRIPT" ]; then
      __script_filename="$(__get_filename_from_string $_arg)"
      __transfer_file_rsync "$_arg" "$_uri/$__script_filename" "$_opt_sudo $_opt_copy_links $_opt_delete_excluded"

      __boot_folder="$__path"
      if [ "$__stella_uri_schema" = "local" ]; then
        # compute relative boot folder to current running dir when on local
        if [ "$(__is_abs "$__boot_folder")" = "FALSE" ]; then
          __boot_folder="$(__rel_to_abs_path "$__boot_folder")"
        fi
      fi
      __script_path="./$__script_filename"
    fi

  fi


  case $__stella_uri_schema in

    local )
      if [ "$__have_to_transfer" = "0" ]; then
        # local
        case $_mode in
          SHELL )
            __bootstrap_stella_env
            ;;
          CMD )
              eval "$_arg"
              eval "$@"
            ;;
          SCRIPT )
              eval "$_arg2"
              eval "$_arg" "$@"
            ;;
        esac
      else
          #local://[/abs_path|?rel_path]
          case $_mode in
            SHELL )
              if [ "$_opt_sudo" = "" ]; then
                 cd $__boot_folder
                 $__stella_entrypoint stella install dep
                 $__stella_entrypoint boot shell local
              else
                sudo -Es eval "cd $__boot_folder && $__stella_entrypoint stella install dep && $__stella_entrypoint boot shell local"
              fi
              ;;
            CMD )
              eval "$_arg"
              if [ "$_opt_sudo" = "" ]; then
                 cd $__boot_folder
                 $__stella_entrypoint stella install dep
                 # cmd as is, without a bootstraped env
                 [ "$_item" = "STELLA" ] && eval $__stella_entrypoint boot cmd local -- "$@"
                 # cmd as is, without a bootstraped env
                 [ "$_item" = "APP" ] && eval "$@"
              else
                # cmd is run into a bootstraped env
                [ "$_item" = "STELLA" ] && sudo -Es eval "cd $__boot_folder && $__stella_entrypoint stella install dep && $__stella_entrypoint boot cmd local -- $@"
                # cmd as is, without a bootstraped env
                [ "$_item" = "APP" ] && sudo -Es eval "cd $__boot_folder && $__stella_entrypoint stella install dep && $@"
              fi

              ;;
            SCRIPT )
              eval "$_arg2"
              if [ "$_opt_sudo" = "" ]; then
                cd $__boot_folder
                $__stella_entrypoint stella install dep
                $__script_path $@
              else
               sudo -Es eval "cd $__boot_folder && $__stella_entrypoint stella install dep && $__script_path $@"
              fi
              ;;
          esac

      fi
      ;;

    docker)
      # docker://image:version[/abs_path|?rel_path]
      echo "TODO"
    ;;

    ssh|vagrant )
      #ssh://user@host:port[/abs_path|?rel_path]
      #vagrant://vagrant-machine[/abs_path|?rel_path]

      case $_mode in
        SHELL )
          __ssh_execute "$_uri" "cd $__boot_folder; $__stella_entrypoint stella install dep; $__stella_entrypoint boot shell local" "SHARED $_opt_sudo"
          ;;
        CMD )
          eval "$_arg"
          # cmd is run into a bootstraped env
          [ "$_item" = "STELLA" ] && __ssh_execute "$_uri" "cd $__boot_folder; $__stella_entrypoint stella install dep; $__stella_entrypoint boot cmd local -- $@"
          # cmd as is, without a bootstraped env
          [ "$_item" = "APP" ] && __ssh_execute "$_uri" "cd $__boot_folder; $__stella_entrypoint stella install dep; $@" "SHARED $_opt_sudo"
          ;;
        SCRIPT )
          eval "$_arg2"
          __ssh_execute "$_uri" "cd $__boot_folder; $__stella_entrypoint stella install dep; $__script_path $@" "SHARED $_opt_sudo"
          ;;
      esac
      [ ! "$_opt_sudo" = "" ] && __sudo_ssh_end_session "$_uri"
      ;;
    *)
      echo " ** ERROR uri protocol unknown"
      ;;

  esac

}


__bootstrap_stella_env() {
	export PS1="[stella] \u@\h|\W>"

	local _t=$(mktmp)
	#(set -o posix; set) >$_t
	declare >$_t
	declare -f >>$_t
( exec bash -i 3<<HERE 4<&0 <&3
. $_t 2>/dev/null;rm $_t;
echo "** STELLA SHELL with env var setted (type exit to exit...) **"
exec  3>&- <&4
HERE
)
}



fi
