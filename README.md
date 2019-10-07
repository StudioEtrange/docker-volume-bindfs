# Docker volume plugin for bindfs


This project is based on vieux/docker-volume-sshfs.
With this plugin you're able to mount a given path and remap its owner and group.

This is a fork of https://github.com/lebokus/docker-volume-bindfs

## About this fork

* support multiple volume with same mount points
* can choose version of bindfs (consult available version from [here](https://github.com/StudioEtrange/stella/blob/0c4d940b255faca281f0f40b24605c0ae23c0d4c/nix/pool/feature-recipe/feature_bindfs.sh)
* add more info and clean build process
* resolve bindfs defunct process each time a volume is destroyed
* isolate bindfs-state.json state file for each plugin version

## Usage

### Install the plugin

This will install the plugin from pre-built versions

```
docker plugin install studioetrange/bindfs:1.1
```

Optional debug option while install
```
docker plugin install studioetrange/bindfs:1.1 DEBUG=1
```

## Notes on available pre-built versions

In docker hub, under [studioetrange/bindfs](https://hub.docker.com/r/studioetrange/bindfs) available versions are

|PLUGIN NAME|BINDFS VERSION|NOTES|
|---|---|---|
|studioetrange/bindfs:1.1|1.13.11|recommended|
|studioetrange/bindfs:1.0|1.13.10|*DO NOT USE* : Have a bug, create bindfs defunct process when removing volume|


### Create a volume

```
docker volume create -d studioetrange/bindfs:1.1 -o sourcePath=$PWD -o map=$(id -u)/0:@$(id -g)/@0 [-o <any_bindfs_-o_option> ] bindfsvolume

docker volume ls

DRIVER              VOLUME NAME
local               be9632386a2d396d438c9707e261f86fd9f5e72a7319417901d84041c8f14a4d
local               e1496dfe4fa27b39121e4383d1b16a0a7510f0de89f05b336aab3c0deb4dda0e
studioetrange/bindfs      bindfsvolume
```

### Use the volume

```
docker run -it -v bindfsvolume:<path> busybox ls -la <path>
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
        driver: studioetrange/bindfs:1.1
        driver_opts:
            sourcePath: "${PWD}"
            map: "${EUID}/0:@${EGID}/@0"
```


## Plugin development

### Build plugin


This will build plugin, tagged as latest, delete plugin if he already exists and install it

```
git clone https://github.com/StudioEtrange/docker-volume-bindfs
cd docker-volume-bindfs
make
```

Options : you can fix a TAG for the plugin version and choose a bindfs version

```
make PLUGIN_TAG=1.1 BINDFS_VERSION=1_13_11
```


### Enable built plugin

This will enable the plugin, you need this before using it

```
make enable
```

Option :

```
make enable PLUGIN_TAG=1.1
```



### Publish plugin

Publis a built plugin to docker hub

```
make DOCKER_LOGIN=foo DOCKER_PASSWORD=bar PLUGIN_TAG=1.1 push
```


## LICENSE

MIT
