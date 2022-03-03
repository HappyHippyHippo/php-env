#!/bin/bash

# execution definitions
exec=run
domain=env
dns="$domain.local"

# directories definitions
dir_apps=$dir/apps
dir_code=$dir/code
dir_data=$dir/data
dir_partial=$dir/partials
dir_temp=/app
dir_sbin=/sbin
dir_home=~
dir_mount=""
dir_ssh=$(path ${dir_home}/.ssh)
