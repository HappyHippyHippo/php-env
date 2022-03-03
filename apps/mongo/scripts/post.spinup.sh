#!/bin/bash

STATE=$(state $app);

if [ $STATE == "on" ]; then
  io_post_spinup $app

  . $(path $dir_apps/$app/defs.sh)

  # checking if the application container was raised and running
  container=$domain-$app
  spinup_container_check $container $app
fi
