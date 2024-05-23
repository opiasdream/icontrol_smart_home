#!/bin/bash
# scripts/kill_port.sh

# default mqtt port is 1883.
sudo lsof -t -i tcp:1883 | xargs kill -9
