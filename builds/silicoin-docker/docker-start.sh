#!/usr/bin/env bash

# shellcheck disable=SC2154
if [[ ${farmer} == 'true' ]]; then
  silicoin start farmer-only
elif [[ ${harvester} == 'true' ]]; then
  if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
    echo "A farmer peer address, port, and ca path are required."
    exit
  else
    silicoin configure --set-farmer-peer "${farmer_address}:${farmer_port}"
    silicoin start harvester
  fi
else
  silicoin start farmer
fi

trap "silicoin stop all -d; exit 0" SIGINT SIGTERM

# Ensures the log file actually exists, so we can tail successfully
touch "$SILICOIN_ROOT/log/debug.log"
tail -f "$SILICOIN_ROOT/log/debug.log" &
while true; do sleep 1; done
