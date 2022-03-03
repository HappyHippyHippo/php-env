#!/bin/bash

. $(path $dir_apps/$app/defs.sh)
. $(path $dir_apps/$app/$version/defs.sh)

# present the application version information
list_app $app $version
