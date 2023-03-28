# *TODO & NOTES*


# Recipe, package manager inspiration

## Nix

* nixos (https://github.com/NixOS/nixpkgs)
* homebrew (https://github.com/Homebrew/homebrew-core)
* 0install (http://0install.net/)
* rudix (http://rudix.org/)
* appimage https://appimage.github.io/apps/
* snapcraft - snapd
* flatpak https://flatpak.org/

## WIN

* bluego (https://bitbucket.org/Vertexwahn/bluego)

* mingw-w64 RECIPE :
 * http://www.gaia-gis.it/spatialite-3.0.0-BETA/mingw64_how_to.html

* msys2 + mingw-w64 RECIPES :
 * https://github.com/Alexpux/MINGW-packages
 * https://github.com/Alexpux/MSYS2-packages

## both
* cmake recipes
  * hunter https://github.com/ruslo/hunter
* C++ package manager : conan https://conan.io/

# games
* https://ttygames.wordpress.com/
* https://github.com/herrbischoff/awesome-command-line-apps#games
* https://www.ubuntupit.com/top-20-best-linux-terminal-console-games-that-you-can-play-right-now/

* [ ] https://github.com/vaniacer/piu-piu-SH
* [ ] PWMAngband - multiplayer angband
http://powerwyrm.monsite-orange.fr
http://angband.online/
http://tangar.info/en/p
* [ ] Mangband - another multiplayer version of angband
  https://mangband.org/
  https://github.com/mangband/mangband
  http://tangar.info/en/m
* [ ] TomeNet - indeep online roguelike game which include both MMORPG genre features and roguelike gameplay
  https://www.tomenet.eu/
  http://tangar.info/en/t


# command line tools list
* https://github.com/agarrharr/awesome-cli-apps
* https://terminalsare.sexy/
* https://github.com/herrbischoff/awesome-command-line-apps
* https://hackernoon.com/macbook-my-command-line-utilities-f8a121c3b019

# various recipe to write
* [ ] https://github.com/ivanilves/lstags
* [X] https://nicolargo.github.io/glances/
* [X] cointop https://github.com/miguelmota/cointop


# bash : builder - transpiler 

* to batch and bash : https://github.com/BYVoid/Batsh
* bash static linked : https://github.com/robxu9/bash-static


# Various

* NOTE : homebrew flag setting system https://github.com/Homebrew/homebrew/blob/master/Library/Homebrew/extend/ENV/super.rb



* NOTE history : FIRST PUSH OF stella pre version : https://bitbucket.org/StudioEtrange/ryzomcore-script/src/1308706a1dc3f1dde7d65b048e9b16f2a2f2f518


# Development environment

* Shellcheck -- https://github.com/koalaman/shellcheck

in Atom Editor

  ```
    brew install shellcheck
    apm install linter
    apm install linter-shellcheck
  ```

then use
  `shellcheck stella.sh`

* checkbashisms

```
  brew install checkbashisms
  apm install linter
  apm install linter-checkbashisms
```

* shell code style guideline

in shell

  ```
    pip install bashate
  ```

use
  `bashate stella.sh`


# Various List

* [ ] nix : __get_keys for ini files do not support character others than [a-zA-Z0-9._]{1,}[[:space:]]*= for key/value pair
* [ ] path management (absolute, relative, ...) use https://github.com/bashup/realpaths ?
* [ ] review argparse : too long !
  * getopt alternatives implementation
      https://github.com/droundy/goopt
      https://code.google.com/p/opts-go/
      https://godoc.org/code.google.com/p/getopt
      https://github.com/kesselborn/go-getopt
  * generate argument parser 
      https://argbash.io/
      https://github.com/matejak/argbash
* [ ] use https://github.com/icy/bocker to turn stella app into docker
* [ ] common-app : different behavior between __get_all_properties and __get_app_property. The first evaluate property with eval BUT NOT the second.
* [X] bug recipe m4 (and maybe bison, automake, autoconf, ...) build is broken with glibc 2.28
* https://www.reddit.com/r/archlinux/comments/97gsb1/glibc_update_breaks_buildroot/
* https://bugs.archlinux.org/task/59562
* https://github.com/coreutils/gnulib/commit/4af4a4a71827c0bc5e0ec67af23edef4f15cee8e#diff-5bcce8ce55246264586c4aed2a45ff89
* https://github.com/buildroot/buildroot/commit/c48f8a64626c60bd1b46804b7cf1a699ff53cdf3

* various cross compiler https://blog.filippo.io/easy-windows-and-linux-cross-compilers-for-macos/
 * [ ] use of mingw-w64 for target : windows https://github.com/Homebrew/homebrew-core/blob/master/Formula/mingw-w64.rb
 * [ ] target : linux musl based system OR any linux if we static link musl
  * https://github.com/richfelker/musl-cross-make (works on linux and macos)
  * https://github.com/FiloSottile/homebrew-musl-cross (same thing than previous but in homebrew style)

* [ ] win : implement version constraint number like npm (https://github.com/npm/node-semver) instead of only  get_last_version() function
* [ ] Test and remove DEST_ERASE in each feature_recipe : cause problem when bundled in merge mode. But only for binary ? keep it for source? only when get binary
* [ ] win : add FEATURE_LIST_ENABLED_VISIBLE
* [ ] win : feat_install() split HIDDEN into HIDDEN and NON_DECLARED
* [ ] win : while feat_init() pre init dependencies
* [X] nix : replace ini management
  * [-] https://github.com/albfan/bash-ini-parser do not work on MacOS (https://github.com/albfan/bash-ini-parser/issues/8)
  * [X] https://github.com/rudimeier/bash_ini_parser
* [ ] bash formatter https://github.com/mvdan/sh
* [ ] openssl and zlib binaries from conan.io https://bintray.com/conan-community/conan/OpenSSL%3Aconan https://github.com/conan-community/conan-openssl
* [ ] app vendor do not work with stella-link.sh with stellaroot option
* [ ] binary bundle go+bash + busybox ?
    https://github.com/progrium/go-basher
    https://github.com/robxu9/bash-static


* [ ] nix : color & style https://odb.github.io/shml/
* [ ] nix : explore https://github.com/alebcay/awesome-shell
* [ ] nix : shell framework https://github.com/shellfire-dev/shellfire

* [ ] nix : bash-lib : https://github.com/aks/bash-lib
* [ ] COMMENTS code
* [ ] Format output (log system)


* [ ] nix : review speed and optimization
https://stackoverflow.com/questions/5014823/how-to-profile-a-bash-shell-script-slow-startup
https://stackoverflow.com/a/20855353
https://github.com/F-Hauri/bashProfiler
https://github.com/paypal/gnomon
http://applocator.blogspot.fr/2013/10/speed-up-bash-scripts-that-use-grep.html

* [ ] nix : common-platform if netstat or ifconfig not present (centos7/rhel7) provide alternative with ip addr to get IP & interface

* [ ] nix : make a flat distro of stella in one file https://github.com/shellfire-dev/fatten

* [X] nix : test sourced https://stackoverflow.com/a/28776166

* [ ] nix : zsh compatibility https://stackoverflow.com/questions/9901210/bash-source0-equivalent-in-zsh


* [ ] win : review 'select_official_schema' function, like in nix, to take care of all arch/flavour possibility
* [ ] nix : use busybox to get binaries small unix tool without building them (i.e unzip) https://busybox.net/
* [ ] nix : embedded ssh server/client : https://matt.ucc.asn.au/dropbear/dropbear.html
* [ ] Test and fix path with space
* [ ] win : function require
* [ ] function get_resource : change option STRIP to option NO_STRIP. STRIP will be by default if possible
* [ ] win : review link feature library and lib isolation
* [ ] win : portable mode review copy dependencies
* [ ] win add recipes for these libs :
 https://ryzomcore.atlassian.net/wiki/display/RC/MinGW+External+Libraries
 https://ryzomcore.atlassian.net/wiki/display/RC/Create+External+Libs
* [ ] win : build mingw-w64 compiler from source https://github.com/niXman/mingw-builds
* [ ] nix : replace each echo informative message (not return string function) with log() call
* [ ] Default build arch equivalent to current cpu arch ? (and change option name buildarch with forcearch) (set STELLA_BUILD_ARCH_DEFAULT)
* [ ] win : sort version : http://stackoverflow.com/questions/34417346/how-to-sort-lines-of-a-text-file-containing-version-numbers-in-format-major-mino
* [ ] feature system : FEAT_DEFAULT_ARCH must be fill with current cpu arch
* [X] feature system nix : FEAT_DEFAULT_VERSION should be the last version available
* [ ] feature system win : FEAT_DEFAULT_VERSION should be the last version available
* [ ] feature built from source must pick an arch and be installed in a folder with version@arch -* buildarch option should be remove -* by default built arch should be current cpu arch
* [ ] win : replace patch from gnuwin32 (pb with UAC)
* [ ] nix : FORCE_RENAME on link_feature_library (see windows implementation)
* [X] win : check library dynamic dependencies * use dependencywalker in console mode ? use dumpbin http://stackoverflow.com/a/475323 ? use CMAKE GetPrerequisites. FINISH check_linked_lib.cmake use it with cmake -P check_linked_lib.cmake -DMY_BINARY_LOCATION=<path>
* [ ] nix : when ckecking dependencies dynamic -* print all libs
* [ ] add possibility of a last step before/after install, to do some test like make test or make check (i.e : for gmp lib)
* [ ] win : sys_install_vs2015community => this chocolatey recipe do not install all VC Tools by default
* [ ] stella-env file : make it local or global with an option ?
* [X] "no_proxy" should be in stella-env file
* [ ] proxy values in stella-env should be local or global
* [X] win : link-app : add option to align workspace/cache path (like on nix)
* [ ] ssh : launch stella app through ssh
 https://thornelabs.net/2013/08/21/simple-ways-to-send-multiple-line-commands-over-ssh.html
 http://stackoverflow.com/questions/4412238/whats-the-cleanest-way-to-ssh-and-run-multiple-commands-in-bash
 http://tldp.org/LDP/abs/html/here-docs.html
 http://stackoverflow.com/questions/305035/how-to-use-ssh-to-run-shell-script-on-a-remote-machine
 SSHFS ? cache delivering only via HTTP ?

* [ ] win : harmonization of internal recipe (patch, unzip, wget, ...)
* [ ] configuration step for each feature recipe
    nix : use augeas https://github.com/hercules-team/augeas ? -* see ryba ? (nodejs) -* use simple sed ?
    win : ?
* [ ] turn stella/nix/common/* folder into module ?
    module/core
    module/feature
    module/app
    module/boot
* [ ] unit test : app/test/nix app/text/win
    nix :
      * bats
      * sharness : https://github.com/chriscool/sharness
    win : ?
    * Tests using mbland/bats, an optimized version of Sam Stephenson's Bash Automated Testing System (BATS).
    * Code coverage comes from Simon Kagstrom's kcov code coverage tool, which not only provides code coverage for Bash scripts (!!!) but can push the results to Coveralls!

* [ ] ryzom nix : openal, libgnu_regex (?), libmysql, lua51, lua52, luabind, stlport (?)
 https://github.com/Shopify/homebrew-shopify/blob/master/mysql-client.rb
 https://github.com/Homebrew/homebrew-core/blob/master/Formula/mysql.rb
* [ ] macos : capacity to download homebrew binary (but special build and should depend on brew installed library ?) (i.e : https://homebrew.bintray.com/bottles/libzip-1.0.1.el_capitan.bottle.tar.gz)

* [ ] distinguish PATH env for current stella app with PATH from stella in 2 variable, and give the possibility to retrieve them in a separate way

* [ ] win/nix : remove FORCE global option, add it as option for each function

* [X] win : change proxyport, proxyhost, proxyuser, proxypassword in stella.sh command line as a unique arg --proxy=uri, and use  function uri_parse

* [ ] download cache folder : first lookup in APP CACHE FOLDER, then in STELLA CACHE FOLDER. Linux [X] Win [ ]

* [ ] shadow features : rename temporary some folder to deactivate features ? (for example, different build tools, to select the right one) or use symlink in case of build tools

* [X] win : remove bin/ folder

* [ ] nix : when using link_feature_library with option FORCE_STATIC, there should be no rpath setted path, because lib is statically linked * no need of an internal registerd search path (=rpath)

* [ ] nix/win : lib parse windows binary (PE File) https://github.com/soluwalana/pefile-go


* [ ] REWORK :
    DEPRECATED STELLA_BUILD_RELOCATE




    STELLA_LINK_PATH_MODE (ex STELLA_BUILD_LINK_PATH :  DEFAULT | ABSOLUTE | RELATIVE
                            and STELLA_FEATURE_LINK_PATH)
          while building feature AND installing feature
            => inspect_and_fix_build (should be inspect_and_fix_feature or inspect_and_fix_binary ?) should be outside build module, but after install ? NO because build module could be use independently
    A/stella link management :
      force ABSOLUTE LINK to dynamic dependencies (do not use of RPATH)
        macho : each dynamic dependency should have install_name should contain PATH of lib
        macho and elf : binary file should have linked lib with "path/linked_lib_file"
      force RELATIVE LINK to dynamic dependencies (use of RPATH)
        macho : each dependency should have install_name should contain RPATH : @rpath/lib_filename
        macho : binary file should have linked lib with "@rpath/linked_lib_file" AND add an RPATH value with "@loader_path/<rel_path>"
        elf : binary file should have linked lib with "linked_lib_file" AND add an RPATH value with "$ORIGIN/<rel_path>"
      DEFAULT do not change anything while building OR installing feature


    STELLA_BUILD_LINK_MODE
    B/ stella build preference link mode while building
      STATIC prefer link to static version of dependencies
      DYNAMIC prefer link to dynamic version of dependencies

    STELLA_FEATURE_INSTALL_MODE (ex STELLA_BUILD_RELOCATE and EXPORT and RELOCATE mode when install feature)
    C/stella install feature mode :
      PORTABLE
          regroup all dependencies into a single /lib folder
          should be force RELATIVE LINK for all dynamic dependencies
      EXPORT
          install feature outside stella/app folder
          could be PORTABLE or not
          could be ABSOLUTE LINK or RELATIVE LINK
      DEFAULT
          do not change anything while building OR installing feature


* [ ] waiting loader
 progress bar :
 http://stackoverflow.com/questions/238073/how-to-add-a-progress-bar-to-a-shell-script
 https://github.com/dspinellis/pmonitor
 http://stackoverflow.com/a/238140/5027535
 https://gist.github.com/unhammer/b0ab6a6aa8e1eeaf236b
 https://github.com/edouard-lopez/progress-bar.sh
 http://stackoverflow.com/a/16348366/5027535
 dtruss/strace : https://www.reddit.com/r/golang/comments/363dhp/how_do_i_make_go_get_to_display_the_progress_of/
 spinner :
 http://stackoverflow.com/a/3330834/5027535
 https://github.com/marascio/bash-tips-and-tricks/tree/master/showing-progress-with-a-bash-spinner

* [ ] git do not support always all options see function git_project_version

* [ ] note on bootstrap applications
Bootstrap a brand new application and use stella as a library or tools collection inside your project
NIX :
	cd your_project
	curl -sSL https://raw.githubusercontent.com/StudioEtrange/stella/master/nix/pool/stella-bridge.sh | bash -s -* bootstrap [stella folder]

WIN:
  cd your_project
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/StudioEtrange/stella/master/win/pool/stella-bridge.bat', 'stella-bridge.bat')" && stella-bridge.bat bootstrap & del /q stella-bridge.bat

* [ ] note on bootstrap a standalone stable stella
NIX
curl -sSL https://raw.githubusercontent.com/StudioEtrange/stella/master/nix/pool/stella-bridge.sh | bash -s -- standalone stella

WIN
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/StudioEtrange/stella/master/win/pool/stella-bridge.bat', 'stella-bridge.bat')" && stella-bridge.bat standalone & del /q stella-bridge.bat

* [ ] openal
http://repo.or.cz/openal-soft.git
https://github.com/kcat/openal-soft

* [ ] nix : init management detection (systemd, upstart, sysV(=init))
http://unix.stackexchange.com/questions/196166/how-to-find-out-if-a-system-uses-sysv-upstart-or-systemd-initsystem
http://unix.stackexchange.com/questions/18209/detect-init-system-using-the-shell
http://unix.stackexchange.com/questions/138994/init-systems-and-service-management-on-different-distributions
https://github.com/ansible/ansible-modules-core/blob/devel/system/service.py



* [X] nix : add "vendor" command to embed a minimal stella inside app
* [ ] win : add "vendor" command to embed a minimal stella inside app

* [ ] win : visual c++ build tools 2015 et 2017 http://landinghub.visualstudio.com/visual-cpp-build-tools


* [ ] ruby :
    uru : manage ruby environnement https://bitbucket.org/jonforums/uru
    ruby-build : download ruby source and build ruby. Do not manage dependencies. Do not manage ruby env https://github.com/rbenv/ruby-build
    ruby-install : download ruby source and build ruby. Manage dependencies. Do not manage ruby env.
    rbenv : manage ruby env https://github.com/rbenv/rbenv
    chruby : manage ruby env
    rvm : download ruby source and build ruby. Manage dependencies. Manage ruby env


* [X] nix : review boost recipes (replace prepare_build with start_manual_build)
* [ ] win  : review all recipes (replace prepare_build with start_manual_build)
* [ ] win build :
  * auto_build launch_configure : implements autotools (mingw or msys)
  * auto_build :  # INCLUDE_FILTER <expr> -- include these files for inspect and fix
                  # EXCLUDE_FILTER <expr> -- exclude these files for inspect and fix
                  # INCLUDE_FILTER is apply first, before EXCLUDE_FILTER
                  # BUILD_ACTION <action1> <action2>


------

# DEPLOY PROJECTS

## bare metal deploy

* cobbler
** http://cobbler.github.io/
** https://github.com/cobbler/cobbler
** relocating cobbler http://cobbler.github.io/manuals/2.6.0/2/5_-_Relocating_Your_Installation.html
** cobbler in docker 1 : http://container-solutions.com/cobbler-in-a-docker-container/ https://github.com/ContainerSolutions/docker-cobbler https://github.com/honnix/docker-cobbler
** cobbler in docker 2 : https://github.com/yongfengdu/docker-cobbler

* foreman
** https://theforeman.org/

* stacki
** https://github.com/StackIQ/stacki

* terraform + packet : https://www.terraform.io/docs/providers/packet/index.html

* matchbox https://github.com/coreos/matchbox
https://coreos.com/blog/matchbox-with-terraform
https://coreos.com/tectonic/docs/latest/install/bare-metal/metal-terraform.html

## hadoop deploy

* from bare metal to hadoop : cobbler + ansible + cloudera manager
** https://blog.godatadriven.com/bare-metal-hadoop-provisioning-ansible-cobbler.html

* structor for VM deploy
  https://github.com/cartershanklin/structor (and forks)

* 3 nodes HDFS Yarn MapReduce :
  https://www.linode.com/docs/databases/hadoop/how-to-install-and-set-up-hadoop-cluster/
  add spark :
  https://www.linode.com/docs/databases/hadoop/install-configure-run-spark-on-top-of-hadoop-yarn-cluster/

* http://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-common/SingleCluster.html
  http://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-common/ClusterSetup.html

## Kubernetes deploy

* several contribution of kubernetes deploy techniques : https://github.com/kubernetes/kube-deploy
* kops : https://github.com/kubernetes/kops
* kubernetes-everywhere : https://github.com/kubernetes/kubernetes-anywhere
* ansible : http://blog.jameskyle.org/2014/08/deploying-baremetal-kubernetes-cluster/
* quickstart kubernetes https://www.linode.com/docs/applications/containers/manage-a-docker-cluster-with-kubernetes/


## VM
    terraform agnostic IaaS management : https://www.terraform.io/
    libvirt : VM management library (qemu, lxc, virtualbox, vmware ...)
        https://github.com/Homebrew/homebrew-core/blob/master/Formula/libvirt.rb
    terraform libvirt provider https://github.com/dmacvicar/terraform-provider-libvirt
    archipel https://github.com/ArchipelProject/Archipel http://archipelproject.org/
        archipel client : https://hub.docker.com/r/schrauber/archipelclient/
    nobullshitvm https://github.com/ChoHag/nbsvm

## infra management
  https://blog.docker.com/2017/01/infrakit-hood-high-availability/
  https://github.com/docker/infrakit
    OS
  https://github.com/linuxkit/linuxkit
