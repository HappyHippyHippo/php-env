#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_post_spinup $app $version

  . $(path $dir_apps/$app/defs.sh)
  . $(path $dir_apps/$app/$version/defs.sh)

  # checking if the application version container was raised and running
  container=$domain-$app-$version
  spinup_container_check $container $app $version

  # copy config files to the container
  docker cp $dir_apps/$app/$version/files/container/nginx.conf $container:/opt/docker/etc/nginx/conf.d/10-buffering.conf
  docker cp $dir_apps/$app/$version/files/container/nginx-log.conf $container:/opt/docker/etc/nginx/vhost.common.d/10-log.conf
  docker cp $dir_apps/$app/$version/files/container/vhost.conf $container:/opt/docker/etc/nginx/vhost.conf
  docker cp $dir_apps/$app/$version/files/container/php.conf $container:/opt/docker/etc/php/fpm/pool.d/docker.conf
  docker cp $dir_apps/$app/$version/files/container/php.webdevops.ini $container:/opt/docker/etc/php/php.webdevops.ini

  # restart php and nginx
  docker exec -u root -t $container supervisorctl restart php-fpm:php-fpmd >/dev/null
  docker exec -u root -t $container supervisorctl restart nginx:nginxd >/dev/null

  # adapt running container to the application (folder permissions)
  docker exec -u root -t $container chmod 777 /var/log
  docker exec -u root -t $container chmod 777 /var/cache
  docker exec -u root -t $container mkdir -p /var/log/api
  docker exec -u root -t $container mkdir -p /var/cache/api
  docker exec -u root -t $container chmod 777 /var/log/api
  docker exec -u root -t $container chmod 777 /var/cache/api

  # check if the application is installed (and install if needed)
  . $(path $dir_apps/$app/$version/scripts/install.sh)

  # add the application version redirect rule on the proxies vhost configuration
  io_spinup_add_to_reverse_proxy $app $version
  sed "s|<app>|$app|g;s|<container>|$container|g;s|<port>|80|g" \
    < $dir_apps/$app/$version/files/proxy/vhost.conf \
    > $dir_data/reverse-proxy/vhosts/api/$app-$version.conf
else
  # remove any proxy registration of the application
  if [ -f $(path $dir_data/proxy/vhosts/api/$app-$version.conf) ]; then
    io_spinup_remove_from_reverse_proxy $app $version
    rm $dir_data/reverse-proxy/vhosts/api/$app-$version.conf
  fi
fi
