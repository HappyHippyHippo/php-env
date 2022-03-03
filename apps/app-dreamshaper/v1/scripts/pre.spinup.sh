#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  io_pre_spinup $app $version

  . $(path $dir_apps/$app/$version/defs.sh)

  # build app image if Dockerfile is present
  build_image $app $version

  # check if the required mysql application is on
  spinup_check_app_on $app $version mysql

  # check if the required mongo application is on
  spinup_check_app_on $app $version mongo

  # create docker partial swap regex string
  regex="s|<dir_code>|$dir_code|g"
  regex="s|<dir_apps>|$dir_apps|g;$regex"
  regex="s|<dir_data>|$dir_data|g;$regex"
  regex="s|<user>|$user|g;$regex"
  regex="s|<group>|$group|g;$regex"
  regex="s|<domain>|$domain|g;$regex"
  regex="s|<app>|$app|g;$regex"
  regex="s|<version>|$version|g;$regex"
  regex="s|<php_version>|$php_version|g;$regex"

  # register application in docker
  spinup_container_add $regex $app $version

  # guarantee that the application directory exists
  spinup_guarantee_app_dir $app $version

  # generate container nginx vhost file
  spinup_container_nginx_vhost $app $version
else
  # remove any pending docker configuration
  spinup_container_remove $app $version
fi
