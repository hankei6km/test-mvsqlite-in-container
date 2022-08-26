#!/bin/bash

set -e

IP_ADDR="192.168.10.10"

test -f /opt/ready.tmp && rm /opt/ready.tmp
trap 'test -f /opt/ready.tmp && rm /opt/ready.tmp' EXIT

grep 127.0.0.1 /etc/foundationdb/fdb.cluster > /dev/null && python3 /usr/lib/foundationdb/make_public.py -a "${IP_ADDR}"
service foundationdb start

cp /etc/foundationdb/fdb.cluster /opt
touch /opt/ready.tmp

for i in $(seq 10) ; do
  test "${i}" -eq 10 && exit 1

  fdbcli --exec 'configure triple' && break;

  sleep 10
  echo retry...
done

echo running...

tail -f /dev/null