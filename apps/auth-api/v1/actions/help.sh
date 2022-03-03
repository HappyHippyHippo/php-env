#!/bin/bash

io_help_header
io_help_title $(printf "Listing all actions available to the %s version of the %s application" $version $app)
io_help_entry_level 3 $app $version "help" "- This menu"
io_help_entry_level 3 $app $version "on" "- Activate the version"
io_help_entry_level 3 $app $version "off" "- Deactivate the version"
