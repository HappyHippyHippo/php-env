#!/bin/bash

# Activating the application
state_on $app

# Activating the mysql dependency
state_on_dep $app "" elk
