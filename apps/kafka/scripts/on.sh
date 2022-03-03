#!/bin/bash

# Activating the application
state_on $app

# Activating the kafka-zookeper dependency
state_on_dep $app "" "kafka-zookeeper"
