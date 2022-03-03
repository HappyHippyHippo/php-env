#!/bin/bash

STATE=$(state $app);

if [ $STATE == "on" ]; then
  io_info_header
  io_write " Running post docker spin-up action for the "
  io_write_bold $app
  io_write " application ...\n"
  io_flush

  . $(path $dir_apps/$app/defs.sh)

  # checking if the application container was raised and running
  container=$domain-$app
  spinup_container_check $container $app
fi
