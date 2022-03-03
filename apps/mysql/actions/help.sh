#!/bin/bash

io_help_header
io_help_title $(printf "Listing all actions available to the %s application" $app)
io_help_entry_level 2 $app "help" "- This menu"
io_help_entry_level 2 $app "on" "- Activate the version"
io_help_entry_level 2 $app "off" "- Deactivate the version"
