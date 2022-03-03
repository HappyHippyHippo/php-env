#!/bin/bash

STATE=$(state $app);

if [ $STATE == "on" ]; then
  . $(path $dir_apps/$app/defs.sh)

  # check if the application as not been installed already
  install_check $app
  if [ "$check" == "missing" ]; then
    io_not_found

    # pull the application code and pull the correct branch
    install_pull $repo $app
    mkdir -p $dir_code/$app
    cd $dir_code/$app
    git clone $repo .
    git fetch 
    git checkout $branch

    # run the application configuration scripts
    container="node:14-alpine"
    install_do $app
    docker run --user $user:$group --rm -t -v=$dir_ssh:/root/.ssh -v=$dir_code/$app:/app -w=/app $container sh -c "npm install && npm run build"
  else
    io_found
  fi
fi
