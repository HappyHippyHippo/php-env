#!/bin/bash

STATE=$(state $app);

if [ $STATE == "on" ]; then
  io_pre_spinup $app

  # build app image if Dockerfile is present
  build_image $app

  . $(path $dir_apps/$app/defs.sh)

  # check if the required redis application is on
  spinup_check_app_on $app "" redis

  # create docker partial swap regex string
  regex="s|<dir_code>|$dir_code|g"
  regex="s|<dir_apps>|$dir_apps|g;$regex"
  regex="s|<dir_data>|$dir_data|g;$regex"
  regex="s|<domain>|$domain|g;$regex"
  regex="s|<app>|$app|g;$regex"

  # register application in docker
  spinup_container_add $regex $app
else
  # remove any pending docker configuration
  spinup_container_remove $app
fi
