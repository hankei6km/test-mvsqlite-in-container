#!/bin/sh

curl http://localhost:7001/api/create_namespace -i -d '{"key":"test","metadata":""}'