#!/bin/bash

################################################################################
# List
################################################################################

# arg $1 - application (optional)
list() {
  if [ -z $1 ]; then
    io_info " Listing all applications ...\n"
    io_flush

    propagate list
  else
    io_info_header
    io_write " Listing all the "
    io_write_bold $1
    io_write " application versions ...\n"
    io_flush

    propagate list $1
  fi
}

# arg $1 - application
# arg #2 - version
# arg $3 - at (optional)
list_app() {
  local _state

  io_write "   "
  pad=""
  while [ ${#pad} -ne $((35-${#1})) ]; do
    pad=" $pad"
  done
  io_write_bold $1
  io_write "$pad"

  if [ "$2" == "" ]; then
    pad="     "
    io_write "$pad"
  else
    pad=""
    while [ ${#pad} -ne $((5-${#2})) ]; do
      pad=" $pad"
    done
    io_write "$pad"
    io_write_bold $2
  fi
  io_write " >> "

  _state=$(state $1 $2)

  if [ $_state == "on" ]; then
    io_write_green $(printf "%3s" $_state)
    if ! [ -z $3 ]; then
      io_write " "
      io_write_green $(printf "@ %s" $3)
    fi
  else
    io_write_red $(printf "%3s " $_state)
    if ! [ -z $3 ]; then
      io_write " "
      io_write_red $(printf "@ %s" $3)
    fi
  fi
  io_write "\n"
  io_flush
}
