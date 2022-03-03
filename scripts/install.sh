#!/bin/bash

################################################################################
# Install
################################################################################

# arg $1 - application
# arg $2 - version (optional)
install_check() {
  check="missing"
  if ! [ -z "$2" ]; then
    io_info_header
    io_write " Checking if the "
    io_write_bold $2
    io_write " version of the "
    io_write_bold $1
    io_write " application is installed ... "
    io_flush

    if [ -d $(path $dir_code/$1-$2) ] && ! [ -z "$(ls $(path $dir_code/$1-$2))" ]; then
      check="installed"
    fi
  else
    io_info_header
    io_write " Checking if the "
    io_write_bold $1
    io_write " application is installed ... "
    io_flush

    if [ -d $(path $dir_code/$1) ] && ! [ -z "$(ls $(path $dir_code/$1))" ]; then
      check="installed"
    fi
  fi
}

# arg $1 - application
# arg $2 - version
# arg $3 - req image
# arg $4 - req app
# arg $5 - req version (optiona)
install_check_image() {
  io_info_header
  io_write " Checking if the "
  io_write_bold $3
  io_write " image is present ... "

  if [ -z "$(docker images | grep "^$1 ")" ]; then
    io_not_found

    if ! [ -z $5 ]; then
      if [ -f $(path $dir_apps/$4/$5/scripts/build.sh) ]; then
        build_image $4 $5
      else
        io_error_header
        io_write " Missing "
        io_write_bold $3
        io_write " instalation image needed for "
        io_write_bold $1
        io_write " application\n"
        io_flush

        exit 1
      fi
    else
      if [ -f $(path $dir_apps/$4/scripts/build.sh) ]; then
        build_image $4
      else
        io_error_header
        io_write " Missing "
        io_write_bold $3
        io_write " instalation image needed for "
        io_write_bold $2
        io_write " version of the "
        io_write_bold $1
        io_write " application\n"
        io_flush

        exit 1
      fi
    fi
  else
    io_found
  fi
}

# arg $1 - repo
# arg $2 - application
# arg $3 - version
install_pull() {
  io_info_header
  io_write " Pulling "
  if ! [ -z $3 ]; then
    io_write_bold $3
    io_write " version of the "
  fi
  io_write_bold $2
  io_write " application repository from "
  io_write_bold $1
  io_write " ... \n"
  io_flush
}

# arg $1 - application
# arg $2 - version
install_do() {
  io_info_header
  io_write " Running "
  if ! [ -z "$2" ]; then
    io_write_bold $2
    io_write " version of the "
  fi
  io_write_bold $1
  io_write " application configuration scripts ... \n"
  io_flush
}
