#!/bin/bash

#__BASE________________________________________________________________________
source $PWD/setup-base.sh

#__DEV_________________________________________________________________________
source $PWD/setup-dev.sh

#__STATION_____________________________________________________________________
source $PWD/setup-station.sh

#__OFFICE______________________________________________________________________
source $PWD/setup-office.sh

#__HARVEY______________________________________________________________________
source $PWD/setup-harvey.sh

#__MUSIC_______________________________________________________________________
source $PWD/setup-music.sh

#TODO: where does this go?
sudo ldconfig

