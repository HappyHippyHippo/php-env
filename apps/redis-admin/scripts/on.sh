#!/bin/bash

# Activating the application
state_on $app

# Activating the redis dependency
state_on_dep $app "" redis
