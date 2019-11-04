#!/bin/bash
source $PWD/helper-funcs/setup-helpers/setup-core.sh

#rclone
#check_if_exists rclone || try_install_from_package_manager rclone || \
#    { echo 'Installation of rclone failed' ; exit 1; }

install_scripts_from_folder scripts/uni
