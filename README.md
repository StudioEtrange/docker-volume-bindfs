# Docker volume plugin for bindfs


This project is based on vieux/docker-volume-sshfs.
With this plugin you're able to mount a given path and remap its owner and group.

I recommend using this plugin with dev-environments **only**, cause of potential security issues.

## About this fork

* support multiple volume with same mount points
* can choose version of bindfs (consult available version from https://github.com/StudioEtrange/stella/blob/master/nix/pool/feature-recipe/feature_bindfs.sh)
* add more info and clean build process
* change plugin namespace

## Usage

1 - Install the plugin

```
$ docker plugin install studioetrange/bindfs

# or to enable debug
docker plugin install studioetrange/bindfs DEBUG=1

```

2 - Create a volume

```
$ docker volume create -d studioetrange/bindfs -o sourcePath=$PWD -o map=$(id -u)/0:@$(id -g)/@0 [-o <any_bindfs_-o_option> ] bindfsvolume

$ docker volume ls
DRIVER              VOLUME NAME
local               be9632386a2d396d438c9707e261f86fd9f5e72a7319417901d84041c8f14a4d
local               e1496dfe4fa27b39121e4383d1b16a0a7510f0de89f05b336aab3c0deb4dda0e
studioetrange/bindfs      bindfsvolume
```

3 - Use the volume

```
$ docker run -it -v bindfsvolume:<path> busybox ls -la <path>
```

## build plugin

```
git clone https://github.com/StudioEtrange/docker-volume-bindfs
cd docker-volume-bindfs
make
```

You can fix a TAG for plugin version and choose a bindfs version with
```
make PLUGIN_TAG=1.0 BINDFS_VERSION=1_13_10
```

## publish plugin
```
make DOCKER_LOGIN=foo DOCKER_PASSWORD=bar PLUGIN_TAG=1.0 push
```

## docker-compose example
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
        driver: studioetrange/bindfs:latest
        driver_opts:
            sourcePath: "${PWD}"
            map: "${EUID}/0:@${EGID}/@0"
```

## LICENSE

MIT
