#!/bin/bash
# exit when an error occurs in one line
set -eo pipefail

# start wireguard
wg-quick up wg0

# wait
sleep infinity
