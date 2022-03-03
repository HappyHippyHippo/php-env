#!/bin/bash


################################################################################
# Post Spinup
################################################################################

# arg $1 - container
# arg $2 - application
# arg $3 - version (optional)
spinup_container_check() {
  if ! [ -z "$3" ]; then
    io_info_header
    io_write " Checking if the "
    io_write_bold $3
    io_write " version of the "
    io_write_bold $2
    io_write " application container "
    io_write_bold $1
    io_write " is present ... "

    if [ -z "$(docker ps | grep "$1$")" ]; then
      io_not_found

      io_error_header
      io_write " "
      io_write_bold $3
      io_write " version of the "
      io_write_bold $2
      io_write " application container "
      io_write_bold $1
      io_write " not found\n"
      io_flush

      exit 1
    else
      io_found
    fi
  else
    io_info_header
    io_write " Checking if the "
    io_write_bold $2
    io_write " application container "
    io_write_bold $1
    io_write " is present ... "

    if [ -z "$(docker ps | grep "$1$")" ]; then
      io_not_found

      io_error_header
      io_write " "
      io_write_bold $2
      io_write " application container "
      io_write_bold $1
      io_write " not found\n"
      io_flush

      exit 1
    else
      io_found
    fi
  fi
}

# arg $1 - regex
# arg $2 - app
# arg $3 - version (optional)
spinup_add_reverse_proxy_entry() {
   $regex $app $version
}
