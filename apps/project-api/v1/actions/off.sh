#!/bin/bash

# check for help option
if [ "$4" == "help" ]; then
  io_help_header
  io_help_title $(printf "Listing all options available to the %s action of the %s version of the %s application" $action $version $app)
  io_help_entry_level 4 $app $version $action "help" "- This menu"
  io_help_entry_level 3 $app $version $action "- Deactivate the version"
else
  # check for unexpected option
  if [ "$#" -ge 4 ]; then
    io_option_unknown $4 $app $version $action
  fi

  # call application version action script
  . $(path $dir_apps/$app/$version/scripts/off.sh)
fi
