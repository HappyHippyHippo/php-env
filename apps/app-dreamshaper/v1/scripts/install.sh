#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  . $(path $dir_apps/$app/$version/defs.sh)

  # check if the application as not been installed already
  install_check $app $version
  if [ "$check" == "missing" ]; then
    io_not_found

    container=$domain-$app-$version

    # pull the application code and pull the correct branch
    install_pull $repo $app $version
    docker exec --user $user:$group -t $container sh -c "git clone $repo . && git checkout $branch"

    # remove the watch action form the gruntfile
    cp $dir_code/$app-$version/Gruntfile.js $dir_code/$app-$version/Gruntfile.js.bck
    sed -i "s/, 'watch'//" $dir_code/$app-$version/Gruntfile.js
 
    install_do $app $version

    # run the application configuration scripts
    docker run --user $user:$group --rm -t -v=$dir_ssh:/root/.ssh -v=$dir_code/$app-$version:/app -w=/app timbru31/node-alpine-git:latest sh -c "npm install"
    docker run --user $user:$group --rm -t -v=$dir_ssh:/root/.ssh -v=$dir_code/$app-$version:/app -w=/app timbru31/node-alpine-git:latest sh -c "cd web && yarn install"
    docker run --user $user:$group --rm -t -v=$dir_ssh:/root/.ssh -v=$dir_code/$app-$version:/app -w=/app timbru31/node-alpine-git:latest sh -c "npm install grunt && ./node_modules/grunt/bin/grunt"

    # configure the application
    sed "s|<domain>|$domain|g" \
      < $dir_apps/$app/$version/files/container/parameters.yml.template \
      > $dir_apps/$app/$version/files/container/parameters.yml
    cp $dir_apps/$app/$version/files/container/parameters.yml $dir_code/$app-$version/app/config/parameters.yml

    # run composer install
    docker exec --user $user:$group -t $container sh -c "composer install"

    # reinstate the gruntfile
    cp $dir_code/$app-$version/Gruntfile.js.bck $dir_code/$app-$version/Gruntfile.js
    rm $dir_code/$app-$version/Gruntfile.js.bck

    # create application entry file
    cp $dir_code/$app-$version/web/app_dev.php $dir_code/$app-$version/web/app.php
    sed -i '12,18d' $dir_code/$app-$version/web/app.php

  else
    io_found
  fi
fi
