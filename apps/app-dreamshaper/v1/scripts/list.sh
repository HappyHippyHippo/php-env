#!/bin/bash

. $(path $dir_apps/$app/defs.sh)

# present the application version information
list_app $app $version $dns
