#!/bin/sh

export RUST_LOG=info MVSQLITE_DATA_PLANE="http://localhost:7000"

cd /home/vscode/mvsqlite/sqlite-amalgamation-3390200

gen_insert () {
  for i in $(seq 200) ; do
    echo "insert into tbl1 (col1) values('data${i}');"
  done
}

gen_insert | LD_PRELOAD=../libmvsqlite_preload.so LD_LIBRARY_PATH=. ./sqlite3 test
