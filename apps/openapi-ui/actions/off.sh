#!/bin/bash

# check for help option
if [ "$4" == "help" ]; then
  io_help_header
  io_help_title $(printf "Listing all options available to the %s action of thethe %s application" $action $app)
  io_help_entry_level 3 $app $action "help" "- This menu"
  io_help_entry_level 2 $app $action "- Deactivate the version"
else
  # check for unexpected option
  if [ "$#" -ge 3 ]; then
    io_option_unknown $3 $app $action
  fi

  # call application action script
  . $(path $dir_apps/$app/scripts/off.sh)
fi
