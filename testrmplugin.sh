#!/bin/bash
sudo docker plugin ls
sudo docker plugin disable studioetrange/bindfs:1.1
sudo docker plugin rm studioetrange/bindfs:1.1
sudo docker plugin ls
