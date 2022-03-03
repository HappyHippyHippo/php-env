#!/bin/bash

################################################################################
# State
################################################################################

# arg $1 - application
# arg $2 - version (optional)
state() {
  local _state
  local _path

  if ! [ -z $2 ]; then
    _path=$(path $dir_apps/$1/$2/state.sh)
  else
    _path=$(path $dir_apps/$1/state.sh)
  fi

  _state="off"
  if [ -f $_path ]; then
    . $_path
    _state=$STATE
  fi

  echo $_state
}

# arg $1 - application
state_on_all() {
  io_info_header
  io_write " Activating all versions of the "
  io_write_bold $1
  io_write " application ...\n"
  io_flush

  propagate on $1
}

# arg $1 - application
state_off_all() {
  io_info_header
  io_write " Deactivating all versions of the "
  io_write_bold $1
  io_write " application ...\n"
  io_flush

  propagate off $1
}

# arg $1 - application
# arg $2 - version (optional)
state_on() {
  local _path

  if ! [ -z $2 ]; then
    io_info_header
    io_write " Activating "
    io_write_bold $2
    io_write " version of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    _path=$(path $dir_apps/$1/$2/state.sh)
  else
    io_info_header
    io_write " Activating "
    io_write_bold $1
    io_write " application ... "
    io_flush

    _path=$(path $dir_apps/$1/state.sh)
  fi

  sed -i "s|STATE.*|STATE\=on|g;" $_path;

  io_done
}

# arg $1 - application
# arg $2 - version (optional)
state_off() {
  local _path

  if ! [ -z $2 ]; then
    io_info_header
    io_write " Deactivating "
    io_write_bold $2
    io_write " version of the "
    io_write_bold $1
    io_write " application ... "
    io_flush

    _path=$(path $dir_apps/$1/$2/state.sh)
  else
    io_info_header
    io_write " Deactivating "
    io_write_bold $1
    io_write " application ... "
    io_flush

    _path=$(path $dir_apps/$1/state.sh)
  fi

  sed -i "s|STATE.*|STATE\=off|g;" $_path;

  io_done
}

# arg $1 - application
# arg $3 - version
# arg $2 - req application
# arg $4 - req version (optional)
state_on_dep() {
  local _path

  if ! [ -z $4 ]; then
    io_info_header
    io_write " "
    if ! [ -z "$2" ]; then
      io_write_bold $2
      io_write " version of the "
    fi
    io_write_bold $1
    io_write " application needed to run the "
    io_write_bold $4
    io_write " version of the "
    io_write_bold $3
    io_write " application\n"
    io_flush

    state_on $3 $4
  else
    io_info_header
    io_write " "
    if ! [ -z "$2" ]; then
      io_write_bold $2
      io_write " version of the "
    fi
    io_write_bold $1
    io_write " application needed to run the "
    io_write_bold $3
    io_write " application\n"
    io_flush

    state_on $3
  fi
}
