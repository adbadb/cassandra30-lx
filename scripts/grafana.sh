#!/usr/bin/env bash

CONTAINER=${1-cass1}
docker run -d -p 3000:3000 --net container:"$CONTAINER" --name grafana grafana/grafana
