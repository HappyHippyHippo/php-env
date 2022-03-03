#!/bin/bash

################################################################################
# Build
################################################################################

# arg $1 - application
# arg $2 - version (optional)
build_image() {
  if ! [ -z "$2" ]; then
    if [ -f $(path $dir_apps/$1/$2/Dockerfile) ]; then
      image=$domain/$1-$2

      # check if the application image is present
      io_info_header
      io_write " Checking if the "
      io_write_bold $2
      io_write " version of the "
      io_write_bold $1
      io_write " application image "
      io_write_bold $image
      io_write " is present ... "
      io_flush

      if [ -z "$(docker images | grep "^$image ")" ]; then
        io_not_found

        # create the application image
        io_info_header
        io_write " Creating the "
        io_write_bold $2
        io_write " version of the "
        io_write_bold $1
        io_write " application image "
        io_write_bold $image
        io_write " ... \n"
        io_flush

        docker build -t "$image" $(path $dir_apps/$1/$2/)
      else
        io_found
      fi
    fi
  else
    if [ -f $(path $dir_apps/$1/Dockerfile) ]; then
      image=$domain/$1

      # check if the application image is present
      io_info_header
      io_write " Checking if the "
      io_write_bold $1
      io_write " application image "
      io_write_bold $image
      io_write " is present ... "
      io_flush

      if [ -z "$(docker images | grep "^$image ")" ]; then
        io_not_found

        # create the application image
        io_info_header
        io_write " Creating the "
        io_write_bold $1
        io_write " application image "
        io_write_bold $image
        io_write " ... \n"
        io_flush

        docker build -t "$image" $(path $dir_apps/$1/)
      else
        io_found
      fi
    fi
  fi
}
