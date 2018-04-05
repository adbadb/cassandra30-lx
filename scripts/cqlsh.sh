#!/usr/bin/env bash

CONTAINER=${1-cass1}
docker run -it --rm --net container:"$CONTAINER" adbadb/cassandra12-lx cqlsh
