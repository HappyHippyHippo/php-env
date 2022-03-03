#!/bin/bash

# check for help option
if [ "$3" == "help" ]; then
  io_help_header
  io_help_title $(printf "Listing all options available to the %s action of the %s application" $action $app)
  io_help_entry_level 3 $app $action "help" "- This menu"
  io_help_entry_level 2 $app "list" "- List all the application versions"
else
  # check for unexpected option
  if [ "$#" -ge 3 ]; then
    io_option_unknown $3 $app $action
  fi

  # list the application versions
  list $app
fi
