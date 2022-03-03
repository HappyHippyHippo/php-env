#!/bin/bash

################################################################################
# IO
################################################################################

io_buffer=()
io_buffer[0]=""
io_index=0

io_push() { io_index=$io_index+1; io_buffer[$io_index]=""; }
io_pop() { io_buffer[$io_index]=""; io_index=$io_index-1; }

io_clear() { io_write "\e[0m"; }
io_bold()  { io_write "\e[1m"; }
io_red()   { io_write "\e[31m"; }
io_green() { io_write "\e[32m"; }
io_blue()  { io_write "\e[34m"; }

io_write() { local cur="${io_buffer[$io_index]}"; io_buffer[$io_index]="$cur${@}"; }
io_write_bold() { io_bold; io_write "${@}"; io_clear; }
io_write_red() { io_bold; io_red; io_write "${@}"; io_clear; }
io_write_green() { io_bold; io_green; io_write "${@}"; io_clear; }
io_write_blue() { io_bold; io_blue; io_write "${@}"; io_clear; }
io_flush() { local cur="${io_buffer[$io_index]}"; printf "${cur[@]}"; io_buffer[$io_index]=""; }

io_done() { io_bold; io_write_green "DONE\n"; io_clear; io_flush; }
io_on() { io_bold; io_write_green "ON\n"; io_clear; io_flush; }
io_found() { io_bold; io_write_green "FOUND\n"; io_clear; io_flush; }
io_not_found() { io_bold; io_write_red "NOT FOUND\n"; io_clear; io_flush; }
io_finished() { io_write "> "; io_write_blue "[INFO]"; io_write_green " FINISHED\n"; io_flush; exit 0; }

io_info_header() { io_write "> "; io_write_blue "[INFO]"; }
io_info() { io_info_header; io_write " ${@}"; }
io_error_header() { io_write "> "; io_write_red "[ERROR]"; }
io_error() { io_error_header; io_write " ${@}"; io_flush; exit 1; }

io_help_header() {
  io_write "> "
  io_write_blue "[HELP]"
  io_write " Docker spin up script\n"
  io_flush
}
# arg ... - text
io_help_title() {
  io_write "      ";
  io_write_bold "${@}\n"
  io_flush
}

# arg $1 - level
# arg ... - options + descriptions
io_help_entry_level() {
  case $1 in
    1) io_help_entry "$(printf "./%s %s " $exec $2)" ${@:3};;
    2) io_help_entry "$(printf "./%s %s %s " $exec $2 $3)" ${@:4};;
    3) io_help_entry "$(printf "./%s %s %s %s " $exec $2 $3 $4)" ${@:5};;
    4) io_help_entry "$(printf "./%s %s %s %s %s " $exec $2 $3 $4 $5)" ${@:6};;
    5) io_help_entry "$(printf "./%s %s %s %s %s %s " $exec $2 $3 $4 $5 $6)" ${@:7};;
  esac
}

# arg $1 - highlighted text
# arg ... - description
io_help_entry() {
  io_write "          "
  io_write_green $1
  io_write " ${@:2}\n"
}

io_option_missing() {
  io_error_header
  io_write " Missing option argument (type "
  case $# in
    1) io_write_green "$(printf "./%s %s help" $exec $1)" ;;
    2) io_write_green "$(printf "./%s %s %s help" $exec $1 $2)" ;;
    3) io_write_green "$(printf "./%s %s %s %s help" $exec $1 $2 $3)" ;;
    4) io_write_green "$(printf "./%s %s %s %s %s help" $exec $1 $2 $3 $4)" ;;
  esac
  io_write " for more information)\n"
  io_flush

  exit 1
}

io_option_unknown() {
  io_error_header
  io_write " Unknown "
  io_write_bold $1
  io_write " option (type "
  case $# in
    2) io_write_green "$(printf "./%s %s help" $exec $2)" ;;
    3) io_write_green "$(printf "./%s %s %s help" $exec $2 $3)" ;;
    4) io_write_green "$(printf "./%s %s %s %s help" $exec $2 $3 $4)" ;;
    5) io_write_green "$(printf "./%s %s %s %s %s help" $exec $2 $3 $4 $5)" ;;
  esac
  io_write " for more information)\n"
  io_flush

  exit 1
}

# arg $1 - app
# arg #2 - version (optional)
io_pre_spinup() {
  io_info_header
  io_write " Running pre docker spin-up action for the "
  if [ -z "$2" ]; then
    io_write_bold $version
    io_write " version of the "
  fi
  io_write_bold $app
  io_write " application ...\n"
  io_flush
}

# arg $1 - app
# arg #2 - version (optional)
io_post_spinup() {
  io_info_header
  io_write " Running post docker spin-up action for the "
  if [ -z "$2" ]; then
    io_write_bold $version
    io_write " version of the "
  fi
  io_write_bold $app
  io_write " application ...\n"
  io_flush
}

# arg $1 - app
# arg #2 - version (optional)
io_spinup_add_to_reverse_proxy() {
  io_info_header
  io_write " Configuring the reverse proxy container to serve the "
  if ! [ -z "$2" ]; then
    io_write_bold $2
    io_write " version of the "
  fi
  io_write_bold $1
  io_write " application ...\n"
  io_flush
}

# arg $1 - app
# arg #2 - version (optional)
io_spinup_remove_from_reverse_proxy() {
  io_info_header
  io_write " Removing the configuring of the "
  if ! [ -z "$2" ]; then
    io_write_bold $2
    io_write " version of the "
  fi
  io_write_bold $1
  io_write " application from the reverse proxy...\n"
  io_flush
}
