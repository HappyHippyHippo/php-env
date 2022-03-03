#!/bin/bash

io_post_spinup $app

# checking if the application container was raised and running
container=$domain-$app
spinup_container_check $container $app
