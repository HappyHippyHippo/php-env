#!/bin/bash

if [ -f "$1" ]; then
    FILE=`cat $1`
    for VARIABLE in `env`
    do
        if [[ "$VARIABLE" == *"="* ]]; then
            IFS='='
            read -ra FIELDS <<< "$VARIABLE"
            FILE="${FILE/\%${FIELDS[0]}\%/${FIELDS[1]}}"
            IFS=' '
        fi
    done
    echo FILE=${FILE##*( )}>$2
fi
