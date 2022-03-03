#!/bin/bash

STATE=$(state $app $version);

if [ $STATE == "on" ]; then
  . $(path $dir_apps/$app/$version/defs.sh)

  # check if the application as not been installed already
  install_check $app $version
  if [ "$check" == "missing" ]; then
    io_not_found

    # pull the application code and pull the correct branch
    install_pull $repo $app $version
    mkdir -p $dir_code/$app-$version
    cd $dir_code/$app-$version
    git clone $repo .
    git fetch 
    git checkout $branch

    # run the application configuration scripts
    container="node:lts-alpine"
    install_do $app $version
    docker run --rm -t -v=$dir_ssh:/root/.ssh -v=$dir_code/$app-$version:/app -w=/app $container sh -c "cd vue-spa && npm install && npm run build && npm run generate"
  else
    io_found
  fi
fi
