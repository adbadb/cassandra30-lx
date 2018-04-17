#!/usr/bin/env bash

CONTAINER=${1-cass1}
docker run -it --rm --net container:"$CONTAINER" adbadb/cassandra30-lx cqlsh
