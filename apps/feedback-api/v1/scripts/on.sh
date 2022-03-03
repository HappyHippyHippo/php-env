#!/bin/bash

. $(path $dir_apps/$app/$version/defs.sh)

# Activating the application version
state_on $app $version

# Activating the mysql dependency
state_on_dep $app $version mysql
state_on_dep $app $version redis
state_on_dep $app $version auth-api $auth_api_version
state_on_dep $app $version notification-api $notification_api_version
