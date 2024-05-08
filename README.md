# Docker volume plugin for bindfs


This project is based on vieux/docker-volume-sshfs.
With this plugin you're able to mount a given path and remap its owner and group.

The plugin is based on bindfs usage to mount folders. https://bindfs.org/


## About this fork


This is a fork of https://github.com/clecherbauer/docker-volume-bindfs


* support multiple volume with same mount points
* add more info and clean build process
* resolve bindfs defunct process each time a volume is destroyed
* isolate bindfs-state.json state file for each plugin version
* make concurrent usage of the plugin more robust to be used in a context with a lot operation of volume
* when building can choose a version of bindfs to build (consult available version from [here](https://github.com/StudioEtrange/stella/blob/0b7f32a1a1d36248333f5a9ac6b9aefdaa9faffc/nix/pool/feature-recipe/feature_bindfs.sh)).
* available plugin versions for linux/amd64 and linux/arm64 platform
* support multi platform build for linux/amd64 and linux/arm64

## Usage

### Install the plugin

* This will install the pre-built versions of the plugin.

    ```
    docker plugin install ghcr.io/studioetrange/bindfs:latest
    ```

* To choose an arch :

    ```
    docker plugin install ghcr.io/studioetrange/bindfs:latest-arm64
    docker plugin install ghcr.io/studioetrange/bindfs:2.3a-arm64
    docker plugin install ghcr.io/studioetrange/bindfs:latest-amd64
    ```
    NOTE : By default this is an amd64 image, when no arch is specified the tag name. (i.e : ghcr.io/studioetrange/bindfs:latest is an amd64 image)


## Official repository and available built versions

The __main repository__ for this plugin is Github Container Registry. DockerHub may contains some other test versions and may have a restricted acces.

In Github Container Registry [ghcr.io/studioetrange/bindfs](https://github.com/StudioEtrange/docker-volume-bindfs/pkgs/container/bindfs)
and in docker hub [studioetrange/bindfs](https://hub.docker.com/r/studioetrange/bindfs) available versions are

|PLUGIN NAME|BINDFS VERSION|GO VERSION|NOTES|GHCR|DOCKER HUB|AMD64|ARM64|
|---|---|---|---|---|---|---|---|
|studioetrange/bindfs:2.3|1.17.6|1.22.1|support of arm64/amd64 build|YES|YES|YES|YES|
|studioetrange/bindfs:2.3a|1.17.6|1.22.1|first support of arm64 build|-|YES|-|YES|
|studioetrange/bindfs:2.2|1.17.6|1.22.1|update bindfs version|YES|YES|YES|-|
|studioetrange/bindfs:2.2a|1.17.6|1.22.1|update bindfs version|-|YES|YES|-|
|studioetrange/bindfs:2.1|1.13.11|1.22.1|improve mutex to lock operation on driver when concurrent access is made|YES|YES|YES|-|
|studioetrange/bindfs:2.1a|1.13.11|1.21.6|improve mutex to lock operation on driver when concurrent access is made|-|YES|YES|-|
|studioetrange/bindfs:2.0b|1.13.11|1.20.1|upgrade plugin logic itself and version of go|-|YES|YES|-|
|studioetrange/bindfs:2.0a|1.17.2|1.20.1|upgrade plugin logic itself and version of bindfs and go|-|YES|YES|-|
|studioetrange/bindfs:1.2|1.13.11|1.14.12|upgrade of docker go-plugin-helpers to remove useless docker log spam|-|YES|YES|-|
|studioetrange/bindfs:1.1|1.13.11|||-|YES|YES|-|
|studioetrange/bindfs:1.0|1.13.10||*DO NOT USE* : Have a bug, create bindfs defunct process when removing volume|-|YES|YES|-|


* Github worflow will built and publish versions for Github Container Registry and docker hub when a git tag is created

* ARM64/AMD64 versions are identified with "-arm64" and "-amd64"  in tag name. When there is no arch in tag name, this is an amd64 version

### Create a volume

Create a volume which have the current user id and group id mapped to root user (uid/gid 0)

    ```
    docker volume create -d studioetrange/bindfs:latest -o sourcePath=$(pwd) -o map=$(id -u)/0:@$(id -g)/@0 myvolume

    docker volume ls

    DRIVER                          VOLUME NAME
    studioetrange/bindfs:latest      myvolume
    ```

Use bindfs options : [bindfs options](https://bindfs.org/docs/bindfs-help.txt)

    ```
    docker volume create -d studioetrange/bindfs:latest -o sourcePath=$(pwd) -o map=$(id -u)/0:@$(id -g)/@0 [-o <any_bindfs_-o_option> ] myvolume
    ```

### Use the volume

```
docker run -it -v myvolume:<path> busybox ls -la <path>
```



## Example for docker-compose file

```
export EUID=$(id -u)
export EGID=$(id -g)
```

```
version: '2'
services:
    app:
        image: busybox
        command: "ls -la /mnt/test"
        volumes:
          - data:/mnt/test

volumes:
    data:
        driver: ghcr.io/studioetrange/bindfs:latest
        driver_opts:
            sourcePath: "${PWD}"
            map: "${EUID}/0:@${EGID}/@0"
```


## Plugin development

### Build plugin


* This will build plugin, tagged as latest, delete plugin if he already exists and install it

    ```
    git clone https://github.com/StudioEtrange/docker-volume-bindfs
    cd docker-volume-bindfs
    make all
    ```

* Options : you can fix a TAG for the plugin version and choose a bindfs version (default is 1_17_6)
    ```
    make PLUGIN_TAG=2.3 BINDFS_VERSION=1_17_6 all
    
    # without using docker cache :
    make PLUGIN_TAG=2.3 BINDFS_VERSION=1_17_6 all-nocache 
    ```



### Select a target platform

* Available supported platforms : `linux/amd64` and `linux/arm64`. By default, the current host platform is used.
* You can force to select a supported platforms using any make target by setting `PLATFORM` variable with `amd64` or `arm64`
    ```
    make PLATFORM=amd64 PLUGIN_TAG=2.3 BINDFS_VERSION=1_17_6 all
    make PLATFORM=arm64 PLUGIN_TAG=2.3 BINDFS_VERSION=1_17_6 all
    ```
* The build target will generate an image tag joining `PLUGIN_TAG` and `PLATFORM` : `2.3-amd64`. If no `PLATFORM` is setted, then the image will be : `2.3`
* If you select a platform different from the host, you have to use qemu emulators (see https://gist.github.com/StudioEtrange/ab9b118b778fac8e815c872826ed2cd8#run-multiplatorm-images)
    ```
    docker run --privileged --rm tonistiigi/binfmt -install linux/arm64
    docker run --privileged --rm tonistiigi/binfmt -install linux/amd64
    ```


### Enable built plugin

* This will enable the plugin, you need this before using it

    ```
    make enable
    ```

* Choose the version to enable

    ```
    make enable PLUGIN_TAG=2.3
    ```

### Debug


* Enable debug mode on the installed plugin

    ```
    make enable-debug
    ```

    OR

    ```
    docker plugin disable studioetrange/bindfs:latest
    docker plugin set studioetrange/bindfs:latest DEBUG=1
    docker plugin enable studioetrange/bindfs:latest
    ```

* Exec into the installed and running plugin

    ```
    # get ID of the plugin
    sudo runc --root /run/docker/runtime-runc/plugins.moby list 
    # exec shell into plugin
    sudo runc --root /run/docker/runtime-runc/plugins.moby exec -t <ID> sh
    ```


* Build and launch a new container with plugin binaries inside

    ```
    make test
    # without using docker cache :
    make test-nocache
    ```

### Publish plugin

* Publish a built plugin to docker hub

    ```
    make DOCKER_LOGIN='studioetrange' DOCKER_PASSWORD='password' PLUGIN_TAG=2.3 push
    make PLATFORM=arm64 DOCKER_LOGIN='studioetrange' DOCKER_PASSWORD='password' PLUGIN_TAG=2.3a push
    ```


### GO update version and dependency management

* GO VERSION UPDATE :
    * Edit Dockerfile and change FROM image with one from dockerhub https://hub.docker.com/_/golang/tags?page=1&name=bullseye based on debian bullseye (i.e : `FROM golang:1.22.1-bullseye as builder`)
    * Use this version in dependencies management step   

* NEW DEPENDENCIES MANAGEMEMENT : For go 1.20+ using standard Go Modules (without govendor) (project tag =>2.0)

    ```
    git clone https://github.com/StudioEtrange/docker-volume-bindfs
    cd docker-volume-bindfs
    docker run -it --rm --volume=$(pwd):/go/src/github.com/StudioEtrange/docker-volume-bindfs golang:1.22.1-bullseye bash

    # FROM INSIDE CONTAINER
    cd /go/src/github.com/StudioEtrange/docker-volume-bindfs


    # check status of used packaged from source code
    go mod verify

    # INIT Go modules management
    go mod init

    # SYNC package between vendor content and vendor.json 
    go mod vendor

    # FROM OUTSIDE CONTAINER
    sudo chown -R $(id -u):$(id -g) vendor
    sudo chown -R $(id -u):$(id -g) go.mod
    sudo chown -R $(id -u):$(id -g) go.sum
    ```

* OLD DEPENDENCIES MANAGEMEMENT : For go 1.14 with govendor (project tag <=1.2)

    ```
    git clone https://github.com/StudioEtrange/docker-volume-bindfs
    git checkout 1.2
    cd docker-volume-bindfs
    docker run -it --rm --volume=$(pwd):/go/src/github.com/StudioEtrange/docker-volume-bindfs golang:1.14.12-stretch bash

    # FROM INSIDE CONTAINER
    go get github.com/StudioEtrange/govendor
    cd /go/src/github.com/StudioEtrange/docker-volume-bindfs


    # check status of used packaged from source code
    govendor list

    # INIT a vendor folder
    govendor init

    # ADD/UPDATE a package with a specific version into vendor and update vendor.json
    govendor fetch <dep>@<version>
    govendor fetch github.com/Sirupsen/logrus@181d419aa9e2223811b824e8f0b4af96f9ba930

    # SYNC package between vendor content and vendor.json 
    govendor sync

    # FROM OUTSIDE CONTAINER
    sudo chown -R $(id -u):$(id -g) vendor
    ```

## Things to think to do

* [ ] migrate logrus to zerolog like in docker-volume-rclone for logging purpose
    * https://github.com/rs/zerolog
    * https://github.com/sapk/docker-volume-rclone/blob/master/rclone/driver/driver.go

* [ ] change the path of the persistent file from `/var/lib/docker/plugins` to `/etc/docker-volume-bindfs` ?

* [X] Protect the volume list with mutex for every driver operation : 
    * https://github.com/sapk/docker-volume-rclone/blob/master/rclone/driver/driver.go
    * https://github.com/fentas/docker-volume-davfs/blob/master/main.go

* [X] linux/arm64 support

## LICENSE

MIT
