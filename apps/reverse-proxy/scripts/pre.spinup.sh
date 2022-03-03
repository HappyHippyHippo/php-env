#!/bin/bash

io_pre_spinup $app

# build app image if Dockerfile is present
build_image $app

. $(path $dir_apps/$app/defs.sh)

# create docker partial swap regex string
regex="s|<dir_code>|$dir_code|g"
regex="s|<dir_apps>|$dir_apps|g;$regex"
regex="s|<dir_data>|$dir_data|g;$regex"
regex="s|<domain>|$domain|g;$regex"
regex="s|<app>|$app|g;$regex"
regex="s|<port>|$port|g;$regex"
regex="s|<sport>|$port_secure|g;$regex"

# register application in docker
spinup_container_add $regex $app

# writing the domains reverse rules
io_info_header
io_write " Writing the "
io_write_bold $app
io_write " nginx config file ..."
io_flush

sed "s|<domain>|$domain|g" < $dir_apps/$app/files/vhost.conf.template > $dir_apps/$app/files/vhost.conf

io_done
