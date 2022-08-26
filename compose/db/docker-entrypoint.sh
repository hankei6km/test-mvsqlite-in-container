#!/bin/bash

case "${1}" in
  "start") exec /docker-entrypoint-start.sh ;;
  "node") exec /docker-entrypoint-node.sh ;;
esac


echo "USAGE: docker run [OPTIONS] <IMAGE> [start | node]"