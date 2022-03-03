#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  . $(path $dir_apps/$app/$version/defs.sh)

  # check if the application as not been installed already
  install_check $app $version
  if [ "$check" == "missing" ]; then
    io_not_found

    container=$domain-dev-$php_version

    # pull the application code and pull the correct branch
    install_pull $repo $app $version
    docker exec --user $user:$group -t $container sh -c "git clone $repo $app-$version && cd $app-$version && git checkout $branch"

    # run the application configuration scripts
    install_do $app $version
    docker exec --user $user:$group -t $container sh -c "cd $app-$version && composer install"
  else
    io_found
  fi
fi
