#!/bin/bash

dds env launch b1 dds-centos-minimal:1.0 -d -v $HOME/tet:/work
dds env launch b2 dds-centos-minimal:1.0 -d -v $HOME/toi:/work
dds env launch b3 dds-centos-minimal:1.0 -d -v $HOME/tui:/work
dds env launch b4 dds-centos-minimal:1.0 -d -v $HOME/tui:/work
dds env list
