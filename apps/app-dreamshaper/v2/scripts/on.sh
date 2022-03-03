#!/bin/bash

# Activating the application version
state_on $app $version

# Activating the mysql dependency
state_on_dep $app $version $app v1
