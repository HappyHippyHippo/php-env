#!/bin/bash

# Activating the application
state_on $app

# Activating the mongo dependency
state_on_dep $app "" mongo
