#!/bin/bash

# download customised CARLA
wget https://figshare.com/ndownloader/files/30458664
wget https://figshare.com/ndownloader/files/30458646
wget https://figshare.com/ndownloader/files/30457506

# make a target folder
mkdir Carla_Versions

# unzip files into the target folder
unzip 30458664 -d Carla_Versions
unzip 30458646 -d Carla_Versions
unzip 30457506 -d Carla_Versions

# remove zip files
rm 30458664 30458646 30457506
