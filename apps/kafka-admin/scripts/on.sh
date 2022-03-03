#!/bin/bash

# Activating the application
state_on $app

# Activating dependency
state_on_dep $app "" kafka
state_on_dep $app "" kafka-zookeeper
