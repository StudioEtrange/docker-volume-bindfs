if [ ! "$_DOCKER_INCLUDED_" = "1" ]; then
_DOCKER_INCLUDED_=1



# docker have a lof ot dependencies and OS specific stuff
# consider to install it from your OS system package manager or by the provided method here http://docs.docker.com/ OR the install script here https://get.docker.com/

# this recipe will install docker binaries server AND client, or just a client, depending of your OS
# in past relase docker binary was the server AND the client, now its splitted into dockerd and docker binaries

# this recipe is based on https://docs.docker.com/engine/installation/binaries/

# NOTE service docker startup scripts : https://github.com/docker/docker/tree/master/contrib/init
#						for supervisord : https://blog.jayway.com/2015/03/14/docker-in-docker-with-jenkins-and-supervisord/
#															https://www.kf-interactive.com/blog/roll-your-own-docker-registry-with-docker-compose-supervisor-and-nginx/
feature_docker() {
	FEAT_NAME=docker
	FEAT_LIST_SCHEMA="17_12_0_CE:binary 17_03_0_CE:binary 1_13_1:binary 1_12_6:binary 1_8_1:binary 1_9_1:binary 1_10_3:binary 1_11_1:binary"
	FEAT_DEFAULT_ARCH=
	FEAT_DEFAULT_FLAVOUR="binary"
}




feature_docker_17_12_0_CE() {
	FEAT_VERSION=17_12_0_CE

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://download.docker.com/mac/static/stable/x86_64/docker-17.12.0-ce.tgz
		FEAT_BINARY_URL_FILENAME=docker-client-17.12.0-ce-darwin.tgz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://download.docker.com/linux/static/stable/x86_64/docker-17.12.0-ce.tgz
		FEAT_BINARY_URL_FILENAME=docker-17.12.0-ce-linux.tgz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_docker_17_03_0_CE() {
	FEAT_VERSION=17_03_0_CE

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-17.03.0-ce.tgz
		FEAT_BINARY_URL_FILENAME=docker-client-17.03.0-ce-darwin.tgz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-17.03.0-ce.tgz
		FEAT_BINARY_URL_FILENAME=docker-17.03.0-ce-linux.tgz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_docker_1_13_1() {
	FEAT_VERSION=1_13_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.13.1.tgz
		FEAT_BINARY_URL_FILENAME=docker-client-1.13.1-darwin.tgz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.13.1.tgz
		FEAT_BINARY_URL_FILENAME=docker-1.13.1-linux.tgz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_docker_1_12_6() {
	FEAT_VERSION=1_12_6

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.12.6.tgz
		FEAT_BINARY_URL_FILENAME=docker-client-1.12.6-darwin.tgz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.12.6.tgz
		FEAT_BINARY_URL_FILENAME=docker-1.12.6-linux.tgz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_docker_1_11_1() {
	FEAT_VERSION=1_11_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.11.1.tgz
		FEAT_BINARY_URL_FILENAME=docker-client-1.11.1-darwin.tgz
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.11.1.tgz
		FEAT_BINARY_URL_FILENAME=docker-1.11.1-linux.tgz
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP_ZIP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}


feature_docker_1_10_3() {
	FEAT_VERSION=1_10_3

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.10.3
		FEAT_BINARY_URL_FILENAME=docker-client-1.10.3-darwin
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.10.3
		FEAT_BINARY_URL_FILENAME=docker-1.10.3-linux
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_docker_1_9_1() {
	FEAT_VERSION=1_9_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.9.1
		FEAT_BINARY_URL_FILENAME=docker-client-1.9.1-darwin
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.9.1
		FEAT_BINARY_URL_FILENAME=docker-1.9.1-linux
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_docker_1_8_1() {
	FEAT_VERSION=1_8_1

	FEAT_SOURCE_DEPENDENCIES=
	FEAT_BINARY_DEPENDENCIES=

	FEAT_SOURCE_URL=
	FEAT_SOURCE_URL_FILENAME=
	FEAT_SOURCE_URL_PROTOCOL=

	if [ "$STELLA_CURRENT_PLATFORM" = "darwin" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Darwin/x86_64/docker-1.8.1
		FEAT_BINARY_URL_FILENAME=docker-client-1.8.1-darwin
	fi

	if [ "$STELLA_CURRENT_PLATFORM" = "linux" ]; then
		FEAT_BINARY_URL=https://get.docker.com/builds/Linux/x86_64/docker-1.8.1
		FEAT_BINARY_URL_FILENAME=docker-1.8.1-linux
	fi
	FEAT_BINARY_URL_PROTOCOL=HTTP

	FEAT_SOURCE_CALLBACK=
	FEAT_BINARY_CALLBACK=
	FEAT_ENV_CALLBACK=


	FEAT_INSTALL_TEST="$FEAT_INSTALL_ROOT"/docker
	FEAT_SEARCH_PATH="$FEAT_INSTALL_ROOT"

}

feature_docker_install_binary() {
	__get_resource "$FEAT_NAME" "$FEAT_BINARY_URL" "$FEAT_BINARY_URL_PROTOCOL" "$FEAT_INSTALL_ROOT" "STRIP DEST_ERASE FORCE_NAME $FEAT_BINARY_URL_FILENAME"
	[ "$FEAT_BINARY_URL_PROTOCOL" = "HTTP" ] && mv "$FEAT_INSTALL_ROOT"/"$FEAT_BINARY_URL_FILENAME" "$FEAT_INSTALL_ROOT"/docker

	chmod +x "$FEAT_INSTALL_ROOT"/docker
	[ "$STELLA_CURRENT_PLATFORM" = "darwin" ] && echo " ** On darwin, docker is in client mode only"

	echo " ** Consider create a docker group, and add your user to this group"
}


fi
