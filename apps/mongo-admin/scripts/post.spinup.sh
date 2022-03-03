#!/bin/bash

STATE=$(state $app);

if [ $STATE == "on" ]; then
  io_post_spinup $app

  . $(path $dir_apps/$app/defs.sh)

  # checking if the application container was raised and running
  container=$domain-$app
  spinup_container_check $container $app

  # add the application version redirect rule on the proxies vhost configuration
  io_spinup_add_to_reverse_proxy $app
  sed "s|<app>|$app|g;s|<container>|$container|g;s|<port>|$port|g" \
    < $dir_apps/$app/files/proxy/vhost.conf \
    > $dir_data/reverse-proxy/vhosts/mongo/$app.conf
else
  # remove any proxy registration of the application
  if [ -f $(path $dir_data/reverse-proxy/vhosts/mongo/$app.conf) ]; then
    io_spinup_remove_from_reverse_proxy $app
    rm $dir_data/reverse-proxy/vhosts/mongo/$app.conf
  fi
fi
