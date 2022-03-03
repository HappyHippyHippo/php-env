#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_post_spinup $app $version

  . $(path $dir_apps/$app/defs.sh)
  . $(path $dir_apps/$app/$version/defs.sh)

  # checking if the application version container was raised and running
  container=$domain-$app-$version
  spinup_container_check $container $app $version

  # check if the application is installed (and install if needed)
  . $(path $dir_apps/$app/$version/scripts/install.sh)

  sed "s|<domain>|$domain|g;s|<app>|$app|g;s|<version>|$version|g" \
    < $dir_apps/$app/$version/files/container/vhost.conf.template \
    > $dir_apps/$app/$version/files/container/vhost.conf

  docker cp $dir_apps/$app/$version/files/container/nginx.conf $container:/opt/docker/etc/nginx/conf.d/10-buffering.conf
  docker cp $dir_apps/$app/$version/files/container/nginx-log.conf $container:/opt/docker/etc/nginx/vhost.common.d/10-log.conf
  docker cp $dir_apps/$app/$version/files/container/vhost.conf $container:/opt/docker/etc/nginx/vhost.conf
  docker cp $dir_apps/$app/$version/files/container/php.conf $container:/opt/docker/etc/php/fpm/pool.d/docker.conf
  docker cp $dir_apps/$app/$version/files/container/envjson.sh $container:/sbin/envjson.sh

  # add the application version redirect rule on the proxies vhost configuration
  io_spinup_add_to_reverse_proxy $app $version
  sed "s|<domain>|$domain|g;s|<app>|$app|g;s|<version>|$version|g;s|<container>|$container|g;s|<port>|$port|g" \
    < $dir_apps/$app/$version/files/proxy/vhost.conf \
    > $dir_data/reverse-proxy/vhosts/all/$app-$version.conf

  # create container env json file
  io_info_header
  io_write " Running script to create env json for the "
  io_write_bold $version
  io_write " of the "
  io_write_bold $app
  io_write " ... "

  docker exec -t $domain-$app-$version /sbin/envjson.sh $envinput $envoutput

  io_done

else
  # remove any proxy registration of the application
  if [ -f $(path $dir_data/reverse-proxy/vhosts/all/$app-$version.conf) ]; then
    io_spinup_remove_from_reverse_proxy $app $version
    rm $dir_data/reverse-proxy/vhosts/all/$app-$version.conf
  fi
fi
