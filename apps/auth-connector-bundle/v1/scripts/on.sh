#!/bin/bash

. $(path $dir_apps/$app/$version/defs.sh)

# Activating the application version
state_on $app $version

# Activating the dependency
state_on_dep $app $version dev $php_version
