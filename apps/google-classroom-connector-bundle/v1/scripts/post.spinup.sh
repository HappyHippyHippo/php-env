#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_post_spinup $app $version

  . $(path $dir_apps/$app/defs.sh)
  . $(path $dir_apps/$app/$version/defs.sh)

  # check if the application is installed (and install if needed)
  . $(path $dir_apps/$app/$version/scripts/install.sh)
fi
