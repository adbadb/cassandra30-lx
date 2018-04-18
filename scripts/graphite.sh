#!/usr/bin/env bash

CONTAINER=${1-cass1}
docker run -d  -p 8099:80 -p 2003:2003 --net container:"$CONTAINER" --name graphite sitespeedio/graphite:0.9.14
