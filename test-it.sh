#!/bin/bash

eval $(docker-machine env --shell bash octoblu-dev)
docker-compose up -d
