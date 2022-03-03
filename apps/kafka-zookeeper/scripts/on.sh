#!/bin/bash

# Activating the application
state_on $app

# Activating the kafka dependency
state_on_dep $app "" kafka
