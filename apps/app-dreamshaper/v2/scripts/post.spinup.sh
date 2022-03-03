#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_post_spinup $app $version

  . $(path $dir_apps/$app/defs.sh)
  . $(path $dir_apps/$app/$version/defs.sh)

  # checking if the application version container was raised and running
  container=$domain-$app-$version
  spinup_container_check $container $app $version

  # add the application version redirect rule on the proxies vhost configuration
  io_spinup_add_to_reverse_proxy $app $version
  sed "s|<app>|$app|g;s|<version>|$version|g;s|<container>|$container|g;s|<port>|$port|g" \
    < $dir_apps/$app/$version/files/proxy/vhost.conf \
    > $dir_data/reverse-proxy/vhosts/all/$app-$version.conf

else
  # remove any proxy registration of the application
  if [ -f $(path $dir_data/reverse-proxy/vhosts/all/$app-$version.conf) ]; then
    io_spinup_remove_from_reverse_proxy $app $version
    rm $dir_data/reverse-proxy/vhosts/all/$app-$version.conf
  fi
fi
