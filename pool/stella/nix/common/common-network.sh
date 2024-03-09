# shellcheck shell=bash
if [ ! "$_STELLA_COMMON_NET_INCLUDED_" = "1" ]; then
_STELLA_COMMON_NET_INCLUDED_=1


# --------------- PROXY INIT ----------------

__reset_proxy() {
	__reset_proxy_values
	__reset_system_proxy_values
}

__init_proxy() {
	__reset_proxy_values
	__read_proxy_values

	if [ ! "$STELLA_PROXY_ACTIVE" = "" ]; then
		# do not set system proxy values if we uses values from system
		[ ! "$STELLA_PROXY_ACTIVE" = "FROM_SYSTEM" ] && __set_system_proxy_values
		__log "INFO" "STELLA Proxy : $STELLA_PROXY_SCHEMA://$STELLA_PROXY_HOST:$STELLA_PROXY_PORT"
		__log "INFO" "STELLA Proxy : bypass for $STELLA_NO_PROXY"
		__proxy_override
	fi
}

__read_proxy_values() {

	use_system_proxy_setting="OFF"

	if [ -f "$STELLA_ENV_FILE" ]; then
		__get_key "$STELLA_ENV_FILE" "STELLA_PROXY" "ACTIVE" "PREFIX"

		if [ ! "$STELLA_PROXY_ACTIVE" = "" ]; then
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$STELLA_PROXY_ACTIVE" "PROXY_HOST" "PREFIX"
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$STELLA_PROXY_ACTIVE" "PROXY_PORT" "PREFIX"
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$STELLA_PROXY_ACTIVE" "PROXY_USER" "PREFIX"
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$STELLA_PROXY_ACTIVE" "PROXY_PASS" "PREFIX"
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$STELLA_PROXY_ACTIVE" "PROXY_SCHEMA" "PREFIX"

			# read NO_PROXY values from env file
			__get_key "$STELLA_ENV_FILE" "STELLA_PROXY" "NO_PROXY" "PREFIX"
			if [ "$STELLA_PROXY_NO_PROXY" = "" ]; then
				STELLA_NO_PROXY="$STELLA_DEFAULT_NO_PROXY"
			else
				[ "$STELLA_DEFAULT_NO_PROXY" = "" ] && STELLA_NO_PROXY="$STELLA_PROXY_NO_PROXY"
				[ ! "$STELLA_DEFAULT_NO_PROXY" = "" ] && STELLA_NO_PROXY="$STELLA_DEFAULT_NO_PROXY","$STELLA_PROXY_NO_PROXY"
			fi
			STELLA_NO_PROXY=${STELLA_NO_PROXY%,}

			eval STELLA_PROXY_HOST=$(echo '$STELLA_PROXY_'$STELLA_PROXY_ACTIVE'_PROXY_HOST')
			eval STELLA_PROXY_PORT=$(echo '$STELLA_PROXY_'$STELLA_PROXY_ACTIVE'_PROXY_PORT')
			eval STELLA_PROXY_SCHEMA=$(echo '$STELLA_PROXY_'$STELLA_PROXY_ACTIVE'_PROXY_SCHEMA')
			[ "$STELLA_PROXY_SCHEMA" = "" ] && STELLA_PROXY_SCHEMA="http"

			eval STELLA_PROXY_USER=$(echo '$STELLA_PROXY_'$STELLA_PROXY_ACTIVE'_PROXY_USER')
			if [ "$STELLA_PROXY_USER" = "" ]; then
				STELLA_HTTP_PROXY=$STELLA_PROXY_SCHEMA://$STELLA_PROXY_HOST:$STELLA_PROXY_PORT
				STELLA_HTTPS_PROXY=$STELLA_PROXY_SCHEMA://$STELLA_PROXY_HOST:$STELLA_PROXY_PORT
			else
				eval STELLA_PROXY_PASS=$(echo '$STELLA_PROXY_'$STELLA_PROXY_ACTIVE'_PROXY_PASS')
				STELLA_HTTP_PROXY=$STELLA_PROXY_SCHEMA://$STELLA_PROXY_USER:$STELLA_PROXY_PASS@$STELLA_PROXY_HOST:$STELLA_PROXY_PORT
				STELLA_HTTPS_PROXY=$STELLA_PROXY_SCHEMA://$STELLA_PROXY_USER:$STELLA_PROXY_PASS@$STELLA_PROXY_HOST:$STELLA_PROXY_PORT
			fi

			__log "INFO" "STELLA Proxy : $STELLA_PROXY_ACTIVE is ACTIVE"
		else
			use_system_proxy_setting="ON"
		fi
	else
		use_system_proxy_setting="ON"
	fi

	[ "$use_system_proxy_setting" = "ON" ] && __read_system_proxy_values

}

# reset stella proxy values
__reset_proxy_values() {
	STELLA_PROXY_ACTIVE=
	STELLA_PROXY_HOST=
	STELLA_PROXY_SCHEMA=
	STELLA_PROXY_USER=
	STELLA_PROXY_PASS=
	STELLA_HTTP_PROXY=
	STELLA_HTTPS_PROXY=
	STELLA_PROXY_NO_PROXY=
	STELLA_NO_PROXY=
}



__read_system_proxy_values() {

	[ "$HTTP_PROXY" = "" ] && STELLA_HTTP_PROXY="$http_proxy" || STELLA_HTTP_PROXY="$HTTP_PROXY"
	[ "$HTTPS_PROXY" = "" ] && STELLA_HTTPS_PROXY="$https_proxy" || STELLA_HTTPS_PROXY="$HTTPS_PROXY"


	[ "$NO_PROXY" = "" ] && STELLA_NO_PROXY="$no_proxy" || STELLA_NO_PROXY="$NO_PROXY"
	STELLA_NO_PROXY=${STELLA_NO_PROXY%,}


	if [ ! "$STELLA_HTTP_PROXY" = "" ]; then
		STELLA_PROXY_ACTIVE="FROM_SYSTEM"

		__uri_parse "$STELLA_HTTP_PROXY"
		STELLA_PROXY_SCHEMA=$__stella_uri_schema
		STELLA_PROXY_USER="$__stella_uri_user"
		STELLA_PROXY_PASS="$__stella_uri_password"
		STELLA_PROXY_HOST="$__stella_uri_host"
		STELLA_PROXY_PORT="$__stella_uri_port"
	fi

}

__set_system_proxy_values() {

	# override already existing system proxy env var only if stella proxy is active
	if [ ! "$STELLA_PROXY_ACTIVE" = "" ]; then
		http_proxy="$STELLA_HTTP_PROXY"
		export http_proxy="$STELLA_HTTP_PROXY"

		HTTP_PROXY="$http_proxy"
		export HTTP_PROXY="$http_proxy"

		https_proxy="$STELLA_HTTPS_PROXY"
		export https_proxy="$STELLA_HTTPS_PROXY"

		HTTPS_PROXY="$https_proxy"
		export HTTPS_PROXY="$https_proxy"

		if [ ! "$STELLA_NO_PROXY" = "" ]; then
			STELLA_NO_PROXY=${STELLA_NO_PROXY%,}
			no_proxy="$STELLA_NO_PROXY"
			NO_PROXY="$STELLA_NO_PROXY"
			export no_proxy="$STELLA_NO_PROXY"
			export NO_PROXY="$STELLA_NO_PROXY"
		fi
	fi


}


# reset system proxy env (for example when disabling previously activated stella proxy)
__reset_system_proxy_values() {
	http_proxy=
	export http_proxy=
	HTTP_PROXY=
	export HTTP_PROXY=
	https_proxy=
	export https_proxy=
	HTTPS_PROXY=
	export HTTPS_PROXY=
	no_proxy=
	NO_PROXY=
	export no_proxy=
	export NO_PROXY=
}



# ---------------- SHIM FUNCTIONS -----------------------------
__proxy_override() {

	# sudo do not preserve env var by default
	type sudo &>/dev/null && \
	function sudo() {
		command sudo no_proxy="$STELLA_NO_PROXY" https_proxy="$STELLA_HTTPS_PROXY" http_proxy="$STELLA_HTTP_PROXY" "$@"
	}

	#bazel :
	# proxy arg for bazel (not tested)
	# https://github.com/bazelbuild/bazel/issues/587
	#bazel --host_jvm_args=-Dhttp.proxyHost=my.proxy -Dhttp.proxyPort=8888 -Dhttps.proxyHost=....

	#yum
	#use env var or yum.conf

	#wget :
	#use env var
	# http_proxy = http://votre_proxy:port_proxy/
	# proxy_user = votre_user_proxy
	# proxy_password = votre_mot_de_passe
	# use_proxy = on
	# wait = 15
	function wget() {
		# NOTE a lot of these wget option do not exist on different wget version
		[ ! "$STELLA_PROXY_USER" = "" ] && no_proxy="$STELLA_NO_PROXY" https_proxy="$STELLA_HTTPS_PROXY" http_proxy="$STELLA_HTTP_PROXY" command wget --wait=15 --proxy=on --proxy-user="$STELLA_PROXY_USER" --proxy-password="$STELLA_PROXY_PASS" "$@"
		[ "$STELLA_PROXY_USER" = "" ] && no_proxy="$STELLA_NO_PROXY" https_proxy="$STELLA_HTTPS_PROXY" http_proxy="$STELLA_HTTP_PROXY" command wget --wait=15 --proxy=on --proxy-user="$STELLA_PROXY_USER" --proxy-password="$STELLA_PROXY_PASS" "$@"
	}

	function curl() {
		local __port
		[ ! "${STELLA_PROXY_PORT}" = "" ] && __port=":${STELLA_PROXY_PORT}"
		[ ! "$STELLA_PROXY_USER" = "" ] && echo $(command curl --noproxy "${STELLA_NO_PROXY}" --proxy "${STELLA_PROXY_HOST}${__port}" --proxy-user "${STELLA_PROXY_USER}:${STELLA_PROXY_PASS}" "$@")
		[ "$STELLA_PROXY_USER" = "" ] && echo $(command curl --noproxy "${STELLA_NO_PROXY}" --proxy "${STELLA_PROXY_HOST}${__port}" "$@")
	}


	function git() {
		no_proxy="$STELLA_NO_PROXY" https_proxy="$STELLA_HTTPS_PROXY" http_proxy="$STELLA_HTTP_PROXY" command git "$@"
	}

	function hg() {
		local __port
		[ ! "${STELLA_PROXY_PORT}" = "" ] && __port=":${STELLA_PROXY_PORT}"
		echo $(command hg --config http_proxy.host="${STELLA_PROXY_HOST}${__port}" --config http_proxy.user="${STELLA_PROXY_USER}" --config http_proxy.passwd="${STELLA_PROXY_PASS}" "$@")
	}

	function mvn() {
		# -DnonProxyHosts=\""${STELLA_NO_PROXY//,/|}"\" => seems to not, work use instead -Dhttp.nonProxyHosts
		[ ! "$STELLA_PROXY_USER" = "" ] && command mvn -DproxyActive=true -DproxyId="$STELLA_PROXY_ACTIVE" -DproxyHost="$STELLA_PROXY_HOST" -DproxyPort="$STELLA_PROXY_PORT" -Dhttp.nonProxyHosts=\""${STELLA_NO_PROXY//,/|}"\" -DproxyUsername="$STELLA_PROXY_USER" -DproxyPassword="$STELLA_PROXY_PASS" "$@"
		[ "$STELLA_PROXY_USER" = "" ] && command mvn -DproxyActive=true  -DproxyId="$STELLA_PROXY_ACTIVE" -DproxyHost="$STELLA_PROXY_HOST" -DproxyPort="$STELLA_PROXY_PORT" -Dhttp.nonProxyHosts=\""${STELLA_NO_PROXY//,/|}"\" "$@"

	}

	function npm() {
		command npm --https-proxy="$STELLA_HTTPS_PROXY" --proxy="$STELLA_HTTP_PROXY" "$@"
	}

	function brew() {
		no_proxy="$STELLA_NO_PROXY" https_proxy="$STELLA_HTTPS_PROXY" http_proxy="$STELLA_HTTP_PROXY" command brew "$@"
	}



	# PROXY for DOCKER ----------

	# DOCKER ENGINE / DAEMON
	#		Docker daemon is used when accessing docker hub (like for search, pull, ...) and registry also when pushing (push)
	#		see https://docs.docker.com/engine/admin/systemd/#/http-proxy
	# 	Docker daemon rely on HTTP_PROXY env
	#		but the env var need to be setted in daemon environement when daemon is launched (not after)
	#		Instead configure
	# 		for Docker Upstart and SysVinit : /etc/default/docker
	#			for Systemd : /etc/systemd/system/docker.service.d/http-proxy.conf
	#			for ? : /etc/sysconfig/docker
	#			for boot2docker : /var/lib/boot2docker/profile
	#			and add proxy information
	#			/etc/default/docker
	#						export http_proxy="http://HOST:PORT"
	#						export https_proxy="http://HOST:PORT"
	#						export HTTP_PROXY="http://HOST:PORT"
	#						export HTTPS_PROXY="http://HOST:PORT"
	#			/etc/systemd/system/docker.service.d/http-proxy.conf
	#						[Service]
	#						Environment="HTTP_PROXY=http://HOST:PORT"
	#							OR EnvironmentFile=/etc/network-environment (content of envfile : HTTP_PROXY=http://HOST:PORT HTTPS_PROXY=http://HOST:PORT)
	#						TO SEE VALUES :
	#											systemctl show -p EnvironmentFile docker.service
	#											systemctl show -p Environment docker.service
	#
	#						Then use : systemctl daemon-reload docker
	#											 systemctl start docker
	#
	# DOCKER CLIENT
	# docker client rely on HTTP_PROXY env to communicate to docker daemon via http
	#		NOTE : so you may set no-proxy env var to not use proxy when accessing daemon
	# 		eval $(docker-machine env <machine-id> --no-proxy)
	#		docker run -it ubuntu /bin/bash
	#
	# DOCKER MACHINE
	# http://stackoverflow.com/a/29303930
	# Docker machine rely on HTTP_PROXY env (ie : for download boot2docker iso)
	# How to set proxy as env var inside docker-machine (ie : HTTP_PROXY)
	# 		docker-machine create -d virtualbox --engine-env http_proxy=http://example.com:8080 --engine-env https_proxy=https://example.com:8080 --engine-env NO_PROXY=example2.com <machine-id>
	# 		docker-machine create -d virtualbox --engine-env http_proxy=$STELLA_HTTP_PROXY --engine-env https_proxy=$STELLA_HTTPS_PROXY --engine-env NO_PROXY=$STELLA_NO_PROXY <machine-id>
	# 		NOTE :
	#				This will only affect docker daemon configuration file inside the VM machine (/var/lib/boot2docker/profile) and set some HTTP_PROXY env vars
	# How to retrieve ip of a docker-machine
	# 		docker-machine ip <machine-id>
	# How to setup docker client to use a docker machine
	# 		eval $(docker-machine env <machine-id>)
	# How to set no_proxy in current shell with ip of a docker machine
	# 		eval $(docker-machine env --no-proxy <machine-id>)
	#			WARN : it will set 'no_proxy' env var, not 'NO_PROXY' env var. And if 'NO_PROXY' is setted, 'no_proxy' is not used
	#						so use instead : __no_proxy_for $(docker-machine ip <machine-id>)
	#
	# DOCKER CONTAINER
	# docker <= 17.06
	# you must set appropriate environment variables within the container.
	# You can do this when you build the image or when you create or run the container.
	# into docker file : env var should be setted with ENV
	#			ENV http_proxy http://<proxy_host>:<proxy_port>
	# with docker run :
	#			docker run --env HTTP_PROXY="http://127.0.0.1:3001" --env NO_PROXY="*.test.example.com,.example2.com"
	# docker >= 17.07
	# In Docker 17.07 and higher, you can configure the Docker client to pass proxy information to containers automatically.
	# ~/.docker/config.json
	# {
	#  "proxies":
	#  {
	#    "default":
	#    {
	#      "httpProxy": "http://127.0.0.1:3001",
	#      "noProxy": "*.test.example.com,.example2.com"
	#    }
	#  }
	# }

	function docker-machine() {
		if [ "$1" = "create" ]; then
			shift 1
			command docker-machine create --engine-env http_proxy="$STELLA_HTTP_PROXY" --engine-env https_proxy="$STELLA_HTTPS_PROXY" --engine-env no_proxy="$STELLA_NO_PROXY" "$@"
		else
			if [ "$1" = "env" ]; then
				echo "
__no_proxy_for $(command docker-machine ip $2);
$(command docker-machine "$@");
"
			else
			  command docker-machine "$@"
			fi
		fi
	}

	# minishift, which relies on a boot2docker VM , needs docker daemon env to be setted
	function minishift() {
		if [ "$1" = "start" ]; then
			shift 1
			command minishift start --docker-env http_proxy="$STELLA_HTTP_PROXY" --docker-env https_proxy="$STELLA_HTTP_PROXY" "$@"
			# TODO : passing no_proxy to env is bugged in minishift args
			#--docker-env no_proxy="$STELLA_NO_PROXY"
			__no_proxy_for $(command minishift ip)
		else
			if [ "$1" = "docker-env" ]; then
				echo "
__no_proxy_for $(command minishift ip);
$(command minishift "$@");
"
			else
				__no_proxy_for $(command minishift ip)
				command minishift "$@"
			fi
		fi
	}

	function minikube() {
		if [ "$1" = "start" ]; then
			shift 1
			command minikube start --docker-env http_proxy="$STELLA_HTTP_PROXY" --docker-env https_proxy="$STELLA_HTTP_PROXY" "$@"
			# TODO : passing no_proxy to env is bugged in minikube args
			#--docker-env no_proxy="$STELLA_NO_PROXY"
			__no_proxy_for $(command minikube ip)
		else
			if [ "$1" = "docker-env" ]; then
				echo "
__no_proxy_for $(command minikube ip);
$(command minikube "$@");
"
			else
				__no_proxy_for $(command minikube ip)
				command minikube "$@"
			fi
		fi

	}


}

# -------------------- FUNCTIONS-----------------


# https://unix.stackexchange.com/questions/55913/whats-the-easiest-way-to-find-an-unused-local-port
# return a list separated by space of free tcp/udp ports
# PARAMETERS
# nb port to find
# OPTIONS :
# TCP - find a TCP port (default)
# UDP - find an UDP port
# CONSECUTIVE - return a list of consecutive port
# RANGE_BEGIN - range of port begin
# RANGE_END - range of port end
# EXCLUDE_LIST_BEGIN - begin of a list of port to exclude
# EXCLUDE_LIST_END - begin of a list of port to exclude
# NOTE : if RANGE_BEGIN/RANGE_END empty will try to populate them with /proc/sys/net/ipv4/ip_local_port_range
# SAMPLE :
#	__find_free_port "2"
#	__find_free_port "2" "UDP"
#	__find_free_port "3" "CONSECUTIVE"
#	__find_free_port "2" "TCP RANGE_BEGIN 640 RANGE_END 650 EXCLUDE_LIST_BEGIN 602 603 645 642 641 644 646 650 EXCLUDE_LIST_END CONSECUTIVE"
__find_free_port() {
	local ports="${1:-1}"
	local __opt="$2"

	local range_begin
	local range_end
	local __flag_begin=
	local __flag_end=
	local __exclude_list=
	local __flag_exclude=
	local __flag_consecutive=
	local __protocol="tcp"

	for o in $__opt; do
		[ "$__flag_begin" = "ON" ] && range_begin="$o" && __flag_begin=
		[ "$o" = "RANGE_BEGIN" ] && __flag_begin="ON"
		[ "$__flag_end" = "ON" ] && range_end="$o" && __flag_end=
		[ "$o" = "RANGE_END" ] && __flag_end="ON"

		[ "$o" = "EXCLUDE_LIST_END" ] && __flag_exclude=
		[ "$__flag_exclude" = "ON" ] && __exclude_list="$__exclude_list $o"
		[ "$o" = "EXCLUDE_LIST_BEGIN" ] && __flag_exclude="ON" && __flag_begin= && __flag_end=

		[ "$o" = "CONSECUTIVE" ] && __flag_consecutive="CONSECUTIVE" && __flag_exclude= && __flag_begin= && __flag_end=
		[ "$o" = "TCP" ] && __protocol="tcp" && __flag_exclude= && __flag_begin= && __flag_end=
		[ "$o" = "UDP" ] && __protocol="udp" && __flag_exclude= && __flag_begin= && __flag_end=
	done

	case $STELLA_CURRENT_PLATFORM in
		darwin )
			[ "$range_begin" = "" ] && range_begin="2048"
			[ "$range_end" = "" ] && range_end="65535"
			;;
		* )
			# On unix, to find authorized plage and use it as RANGE_BEGIN and RANGE_END value use
			# values in /proc/sys/net/ipv4/ip_local_port_range
			if [ -f "/proc/sys/net/ipv4/ip_local_port_range" ]; then
				read _begin _end < /proc/sys/net/ipv4/ip_local_port_range
				[ "$range_begin" = "" ] && range_begin="$_begin"
				[ "$range_end" = "" ] && range_end="$_end"
			else
				[ "$range_begin" = "" ] && range_begin="2048"
				[ "$range_end" = "" ] && range_end="65535"
			fi
			;;
	esac



	# TODO : implement netstat alternatives : https://linuxize.com/post/check-listening-ports-linux/
	local taken_ports

	local __network_cmd
	type ss &>/dev/null
	if [ $? = 0 ]; then
		__network_cmd="ss"
	else
		type netstat &>/dev/null
		if [ $? = 0 ]; then
			__network_cmd="netstat"
		else
			# we cannot list occupied port
			return
		fi
	fi

	if [ "$__protocol" = "tcp" ]; then
		taken_ports=( $( $__network_cmd -aln | egrep ^$__protocol | fgrep LISTEN | awk '{print $4}' | egrep -o '[0-9]+$' ) )
	else
		taken_ports=( $( $__network_cmd -aln | egrep ^$__protocol | awk '{print $4}' | egrep -o '[0-9]+$' ) )
	fi

	__random_number_list_from_range "$ports" "$range_begin" "$range_end" "$__flag_consecutive EXCLUDE_LIST_BEGIN ${taken_ports[@]} $__exclude_list EXCLUDE_LIST_END"

}

# https://stackoverflow.com/a/14701003/5027535
# return TRUE if port is open
# return FALSE if port is unreachable
#	return nothing if we cannot test
__check_tcp_port_open() {
	local __host="$1"
	local __port="$2"
	# timeout time for check, default 3 sec
	local __timeout="$3"

	[ "${__timeout}" = "" ] && __timeout=3

	# NOTE : nc is present by default on MacOS
	type nc &>/dev/null
	if [ $? = 0 ]; then
		nc -w ${__timeout} -v ${__host} ${__port} </dev/null 2>/dev/null
		[ $? = 0 ] && echo "TRUE" || echo "FALSE"
	else
		type timeout &>/dev/null
		if [ $? = 0 ]; then
			 timeout ${__timeout} bash -c "</dev/tcp/${__host}/${__port}" 2>/dev/null
			 [ $? = 0 ] && echo "TRUE" || echo "FALSE"
		else
			# TODO : timeout nor nc are present we cannot check tcp port is open or not
			echo ""
		fi

	fi

}


# support ssh:// and vagrant://
# OPTIONS :
#			SHARED : create a shared ssh connection for targeted host for a few time
#			SUDO : use sudo
#	NOTE : sudo: sorry, you must have a tty to run sudo
# 			 http://www.cyberciti.biz/faq/linux-unix-bsd-sudo-sorry-you-must-haveattytorun/
#
__ssh_execute() {
	local __uri="$1"
	local __cmd="$2"
	local __opt="$3"

	__require "ssh" "ssh"

	local __opt_shared=
	local __opt_sudo=
	for o in $__opt; do
		[ "$o" = "SHARED" ] && __opt_shared="-o ControlPath=~/.ssh/%r@%h-%p -o ControlMaster=auto -o ControlPersist=60"
		[ "$o" = "SUDO" ] && __opt_sudo="1"
	done

	__uri_parse "$__uri"

	[ "$__stella_uri_schema" = "" ] && __stella_uri_schema="ssh"

	if [ "$__stella_uri_schema" = "ssh" ]; then
		__ssh_port="22"
		[ ! "$__stella_uri_port" = "" ] && __ssh_port="$__stella_uri_port"
		__ssh_opt="-p $__ssh_port"
	fi

	if [ "$__stella_uri_schema" = "vagrant" ]; then
		__vagrant_ssh_opt="$(__vagrant_get_ssh_options "$__stella_uri_host")"
		#__vagrant_ssh_opt="$(vagrant ssh-config $__stella_uri_host | sed '/^[[:space:]]*$/d' |  awk '/^Host .*$/ { detected=1; }  { if(start) {print " -o "$1"="$2}; if(detected) start=1; }')"
		__stella_uri_host="localhost"
	fi

	# NOTE : __stella_uri_address contain user
	# we need to build a user@host without port number
	local __ssh_user=
	[ ! "$__stella_uri_user" = "" ] && __ssh_user="$__stella_uri_user"@

	# https://stackoverflow.com/questions/5560442/how-to-run-two-commands-in-sudo
	if [ "$__opt_sudo" = "1" ]; then
		__log "DEBUG" "ssh -t $__ssh_opt $__opt_shared $__vagrant_ssh_opt $__ssh_user$__stella_uri_host sudo -Es eval ${__cmd}"
		#ssh -tt $__ssh_opt $__opt_shared $__vagrant_ssh_opt "$__ssh_user$__stella_uri_host" "sudo -Es eval '${__cmd}'"
		ssh -t $__ssh_opt $__opt_shared $__vagrant_ssh_opt "$__ssh_user$__stella_uri_host" "sudo -Es eval '${__cmd}'"
	else
		__log "DEBUG" "ssh -t $__ssh_opt $__opt_shared $__vagrant_ssh_opt $__ssh_user$__stella_uri_host ${__cmd}"
		#ssh -tt $__ssh_opt $__opt_shared $__vagrant_ssh_opt "$__ssh_user$__stella_uri_host" "${__cmd}"
		ssh -t $__ssh_opt $__opt_shared $__vagrant_ssh_opt "$__ssh_user$__stella_uri_host" "${__cmd}"
	fi

}


# Get vagrant ssh option for connection
# vagrant machine name
__vagrant_get_ssh_options() {
	local __name="$1"
	echo "$(vagrant ssh-config $__name | sed '/^[[:space:]]*$/d' |  awk '/^Host .*$/ { detected=1; }  { if(start) {print " -o "$1"="$2}; if(detected) start=1; }')"
}

# TODO
# https://unix.stackexchange.com/a/165067
# find an interface used to reach a given ip
# __get_interface_used_for()


# TODO : these functions support only ipv4
# https://stackoverflow.com/a/33550399
__get_network_info() {
	#local _err=
	type netstat &>/dev/null
	if [ $? = 0 ]; then
		# NOTE : we pick the first default interface if we have more than one
		STELLA_DEFAULT_INTERFACE="$(netstat -rn | awk '/^0.0.0.0/ {thif=substr($0,74,10); print thif;} /^default.*UG/ {thif=substr($0,65,10); print thif;}' | head -1)"
	else
		type ip &>/dev/null
		[ $? = 0 ] && STELLA_DEFAULT_INTERFACE="$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1)"
	fi

	# contains default ip
	STELLA_HOST_DEFAULT_IP="$(__get_ip_from_interface ${STELLA_DEFAULT_INTERFACE})"

	type ifconfig &>/dev/null
	if [ $? = 0 ]; then
		# contains all available IP
		STELLA_HOST_IP="$(ifconfig | grep -Eo 'inet (adr:|addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | tr '\n' ' ')"
	else
		type ip &>/dev/null
		if [ $? = 0 ]; then
			STELLA_HOST_IP="$(ip -o -4 addr | awk '{split($4, a, "/"); print a[1]}' | tr '\n' ' ')"
		else
			# do not work on macos
			type hostname &>/dev/null
			[ $? = 0 ] && STELLA_HOST_IP="$(hostname -I 2>/dev/null)"
		fi
	fi

}

__get_ip_from_interface() {
	local _if="$1"
	type ifconfig &>/dev/null
	if [ $? = 0 ]; then
		echo "$(ifconfig ${_if} 2>/dev/null | grep -Eo 'inet (adr:|addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')"
	else
		#https://unix.stackexchange.com/a/407128
		type ip &>/dev/null
		[ $? = 0 ] && echo "$(ip -4 -o addr show dev ${_if} | awk '{split($4, a, "/"); print a[1]}')"
	fi
}

# TODO : do an equivalent without "ip" command
#
#__print_ip_info() {
#	type ip &>/dev/null
#	if [ $? = 0 ]; then
#		PROBLEM : this command show only interface wich have an ip
#		ip -o addr | awk '{split($4, a, "/"); print $2" : "a[1]}'
#	fi
#}

# https://unix.stackexchange.com/questions/20784/how-can-i-resolve-a-hostname-to-an-ip-address-in-a-bash-script
# NOTE : host, dig, nslookup only request dns and do not look for ip in /etc/hosts
# NOTE on getent :
#					ipv4 adress
#						getent ahostsv4 www.google.de | grep STREAM | head -n 1 | cut -d ' ' -f 1
#					ipv6 adress
#						getent ahostsv6 www.google.de | grep STREAM | head -n 1 | cut -d ' ' -f 1
# 				give owners preferred address what may IPv4 or IPv6 address.
#						getent hosts google.de | head -n 1 | cut -d ' ' -f 1
#					list all resolved address
#						getent ahosts google.de
# 					getent ahosts google.de | head -n 1 | cut -d ' ' -f 1
__get_ip_from_hostname() {
	type getent &>/dev/null
	if [ $? = 0 ]; then
		echo "$(getent ahostsv4 $1 | grep STREAM | head -n 1 | cut -d ' ' -f 1)"
	else
		echo "$(ping -q -c 1 -t 1 $1 2>/dev/null | grep -m 1 PING | cut -d "(" -f2 | cut -d ")" -f1)"
	fi
}

# determine external IP
# https://unix.stackexchange.com/a/194136
# TODO : work only ipv4
__get_ip_external() {
	
	type dig &>/dev/null
	if [ $? = 0 ]; then
		__result="$(dig @resolver1.opendns.com A myip.opendns.com +short -4)"
		#__result="$(dig @resolver1.opendns.com AAAA myip.opendns.com +short -6)"
	else
		__result="$(curl -s ipinfo.io/ip)"
	fi

	echo "${__result}"
}


__proxy_tunnel() {
	local _target_proxy_name="$1"
	local _bridge_uri="$2"

	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_target_proxy_name" "PROXY_HOST" "PREFIX"
	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_target_proxy_name" "PROXY_PORT" "PREFIX"
	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_target_proxy_name" "PROXY_USER" "PREFIX"
	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_target_proxy_name" "PROXY_PASS" "PREFIX"
	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_target_proxy_name" "PROXY_SCHEMA" "PREFIX"

	eval _target_proxy_host=$(echo '$STELLA_PROXY_'$_target_proxy_name'_PROXY_HOST')
	eval _target_proxy_port=$(echo '$STELLA_PROXY_'$_target_proxy_name'_PROXY_PORT')
	eval _target_proxy_schema=$(echo '$STELLA_PROXY_'$_target_proxy_name'_PROXY_SCHEMA')

	__register_proxy "_STELLA_TUNNEL_" "http://localhost:7999"
	__enable_proxy "_STELLA_TUNNEL_"

	# TODO : what if targeted proxy require a user/password ?

	# NOTE : -4 : force ipv4 connection
	ssh -4 -N -L 7999:$_target_proxy_host:$_target_proxy_port $_bridge_uri

	__disable_proxy
}

__register_proxy() {
	local _proxy_name="$1"

	__uri_parse "$2"

	local _host="$__stella_uri_host"
	local _port="$__stella_uri_port"
	local _user="$__stella_uri_user"
	local _pass="$__stella_uri_password"
	local _schema="$__stella_uri_schema"

	if [ "$_schema" = "" ]; then
		_schema="http"
	fi

	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_proxy_name" "PROXY_HOST" "$_host"
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_proxy_name" "PROXY_PORT" "$_port"
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_proxy_name" "PROXY_USER" "$_user"
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_proxy_name" "PROXY_PASS" "$_pass"
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY_$_proxy_name" "PROXY_SCHEMA" "$_schema"
}

__enable_proxy() {
	local _name=$1
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY" "ACTIVE" "$_name"
	__init_proxy
}

__disable_proxy() {
	__add_key "$STELLA_ENV_FILE" "STELLA_PROXY" "ACTIVE"

	__log "INFO" "STELLA Proxy Disabled"
	__reset_proxy_values
	__reset_system_proxy_values
}


# no_proxy is read from conf file only if a stella proxy is active
# _list_uri could be a list of no proxy values separated with comma
__register_no_proxy() {
	local _list_uri="$1"
	__get_key "$STELLA_ENV_FILE" "STELLA_PROXY" "NO_PROXY" "PREFIX"

	_list_uri="${_list_uri//,/ }"
	for p in $_list_uri; do
			__uri_parse "$p"

			_host="$__stella_uri_host"

			_exist=
			STELLA_PROXY_NO_PROXY="${STELLA_PROXY_NO_PROXY//,/ }"
			for h in $STELLA_PROXY_NO_PROXY; do
				[ "$h" = "$_host" ] && _exist=1
			done

			if [ "$_exist" = "" ]; then
				if [ "$STELLA_PROXY_NO_PROXY" = "" ]; then
					STELLA_PROXY_NO_PROXY="$_host"
				else
					STELLA_PROXY_NO_PROXY="$STELLA_PROXY_NO_PROXY $_host"
				fi

				__add_key "$STELLA_ENV_FILE" "STELLA_PROXY" "NO_PROXY" "${STELLA_PROXY_NO_PROXY// /,}"
			fi
	done
	__init_proxy

}

# only temporary no proxy
# will be reseted each time proxy values are read from env file
__no_proxy_for() {
	local _uri="$1"

	if [ "$_uri" == "" ]; then
		return
	fi
	__uri_parse "$_uri"
	local _host="$__stella_uri_host"

	if [ "$_host" == "" ]; then
		return
	fi

	local _exist=
	local _tmp_no_proxy="${STELLA_NO_PROXY//,/ }"
	for h in $_tmp_no_proxy; do
		[ "$h" = "$_host" ] && _exist=1
	done

	if [ "$_exist" = "" ]; then
		__log "INFO" "STELLA Proxy : temp proxy bypass for $_host"
		[ ! "$STELLA_NO_PROXY" = "" ] && STELLA_NO_PROXY="$STELLA_NO_PROXY","$_host"
		[ "$STELLA_NO_PROXY" = "" ] && STELLA_NO_PROXY="$_host"
		__set_system_proxy_values
	fi

}
fi
