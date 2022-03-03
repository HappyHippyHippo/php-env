#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_post_spinup $app $version

  # checking if the application container was raised and running
  container=$domain-$app-$version
  spinup_container_check $container $app $version

  # adapt running container to the application (folder permissions)
  docker exec -u root -t $container chmod 777 /var/log
  docker exec -u root -t $container chmod 777 /var/cache
  docker exec -u root -t $container mkdir -p /var/log/api
  docker exec -u root -t $container mkdir -p /var/cache/api
  docker exec -u root -t $container chmod 777 /var/log/api
  docker exec -u root -t $container chmod 777 /var/cache/api

  docker cp $dir_apps/$app/$version/files/php.webdevops.ini $container:/opt/docker/etc/php/php.webdevops.ini
fi
