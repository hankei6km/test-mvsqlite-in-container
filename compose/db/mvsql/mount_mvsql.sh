#!/bin/sh

RUST_LOG=info ./mvsqlite-fuse --data-plane http://localhost:7000 \
  --mountpoint ./my_databases \
  --namespaces "mydb=test"