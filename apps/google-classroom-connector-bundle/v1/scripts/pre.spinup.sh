#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_pre_spinup $app $version

  . $(path $dir_apps/$app/$version/defs.sh)

  # build app image if Dockerfile is present
  build_image $app $version

  # check if the required application is on
  spinup_check_app_on $app $version dev
fi
