#!/bin/bash

# restarting the application
io_info_header
io_write " Restarting "
io_write_bold $app
io_write " reverse proxy container ... "
io_flush

container=$domain-$app

docker stop $container > /dev/null 2>&1
docker start $container > /dev/null 2>&1

io_done
