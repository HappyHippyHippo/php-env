#!/bin/bash

################################################################################
# PROPAGATE
################################################################################

# arg $1 - script
# arg #2 - application (optional)
propagate() {
  if [ -z "$2" ]; then
    for app in `ls $dir_apps`; do
      if [ -f $(path $dir_apps/$app/scripts/$1.sh) ]; then
        . $(path $dir_apps/$app/scripts/$1.sh)
      fi
    done
  else
    for version in `ls $dir_apps/$2`; do
      if [ -f $(path $dir_apps/$2/$version/scripts/$1.sh) ]; then
        . $(path $dir_apps/$2/$version/scripts/$1.sh)
      fi
    done
  fi
}
