#!/bin/bash

################################################################################
# Pre Spinup
################################################################################

# arg $1 - application
# arg $2 - version
# arg $3 - req application
# arg $4 - req version (optional)
spinup_check_app_on() {
  local _state

  if ! [ -z "$4" ]; then
    io_info_header
    io_write " Checking the state of the "
    io_write_bold $4
    io_write " version of the "
    io_write_bold $3
    io_write " application ... "
    io_flush

    _state=$(state $3 $4)
    if [ "$_state" == "on" ]; then
      io_on
      io_flush
    else
      io_write_bold "OFF\n"
      io_flush

      io_error_header
      io_write " Missing "
      io_write_bold $4
      io_write " version of the "
      io_write_bold $3
      io_write " application to be able to raise the "
      if ! [ -z "$2" ]; then
        io_write_bold $2
        io_write " version of the "
      fi
      io_write_bold $1
      io_write " application\n"
      io_flush

      exit 1
    fi
  else
    io_info_header
    io_write " Checking the state of the "
    io_write_bold $3
    io_write " application ... "
    io_flush

    _state=$(state $3)
    if [ "$_state" == "on" ]; then
      io_on
      io_flush
    else
      io_write_bold "OFF\n"
      io_flush

      io_error_header
      io_write " Missing "
      io_write_bold $3
      io_write " application to be able to raise the "
      if ! [ -z "$2" ]; then
        io_write_bold $2
        io_write " version of the "
      fi
      io_write_bold $1
      io_write " application\n"
      io_flush

      exit 1
    fi
  fi
}

# arg $1 - regex
# arg $2 - application
# arg $3 - version (optional)
spinup_container_add() {
  if ! [ -z "$3" ]; then
    io_info_header
    io_write " Adding docker partial for the "
    io_write_bold $3
    io_write " version of the "
    io_write_bold $2
    io_write " application ... "
    io_flush

    sed $1 < $(path $dir_apps/$2/$3/composer/partial.yaml) > $(path $dir_partial/$2-$3.yaml)

    io_done
  else
    io_info_header
    io_write " Adding docker partial for the "
    io_write_bold $2
    io_write " application ... "
    io_flush

    sed $1 < $(path $dir_apps/$2/composer/partial.yaml) > $(path $dir_partial/$2.yaml)

    io_done
  fi
}

# arg $1 - application
# arg $2 - version (optional)
spinup_guarantee_app_dir() {
  if ! [ -z "$2" ]; then
    io_info_header
    io_write " Garantee the existence of the storing directory of the "
    io_write_bold $2
    io_write " version of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    mkdir -p $dir_code/$1-$2

    io_done
  else
    io_info_header
    io_write " Garantee the existence of the storing directory of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    mkdir -p $dir_code/$1

    io_done
  fi
}

# arg $1 - application
# arg $2 - version (optional)
spinup_container_nginx_vhost() {
  if ! [ -z "$2" ]; then
    io_info_header
    io_write " Generate the container nginx vhost configuration file of the "
    io_write_bold $2
    io_write " version of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    regex="s|<app>|$1|g"
    regex="s|<version>|$2|g;$regex"
    regex="s|<domain>|$domain|g;$regex"
    sed $regex < $(path $dir_apps/$1/$2/files/container/vhost.conf.template) > $(path $dir_apps/$1/$2/files/container/vhost.conf)

    io_done
  else
    io_info_header
    io_write " Generate the container nginx vhost configuration file of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    regex="s|<app>|$1|g"
    regex="s|<domain>|$domain|g;$regex"
    sed $regex < $(path $dir_apps/$1/files/container/vhost.conf.template) > $(path $dir_apps/$1/files/container/vhost.conf)

    io_done
  fi
}

# arg $1 - application
# arg $2 - version (optional)
spinup_container_remove() {
  if ! [ -z "$2" ]; then
    if [ -f $(path $dir_partial/$1-$2.yaml) ]; then
      rm $(path $dir_partial/$1-$2.yaml)
    fi
  else
    if [ -f $(path $dir_partial/$1.yaml) ]; then
      rm $(path $dir_partial/$1.yaml)
    fi
  fi
}
