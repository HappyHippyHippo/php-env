#!/bin/bash

. $(path $dir_apps/$app/defs.sh)

# present the application information
list_app $app "" openapi.ui.$dns
