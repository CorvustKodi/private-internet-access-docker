#!/bin/sh
#
# Enable port forwarding when using Private Internet Access
#
# Usage:
#  ./port_forwarding.sh

error( )
{
  echo "$@" 1>&2
  exit 1
}

port_forward_assignment( )
{
  echo 'Start delay, just in case'
  sleep 5
  echo 'Loading port forward assignment information...'
  if [ "$(uname)" == "Linux" ]; then
    client_id=`head -n 100 /dev/urandom | sha256sum | tr -d " -"`
  fi
  if [ "$(uname)" == "Darwin" ]; then
    client_id=`head -n 100 /dev/urandom | shasum -a 256 | tr -d " -"`
  fi
  echo "Generated client ID: $client_id"
  json=`curl "http://209.222.18.222:2000/?client_id=$client_id" 2>/dev/null`
  if [ "$json" == "" ]; then
    echo "Failed to configure port forwarding"
    exit 1
  fi

  echo $json
  PIAPORT=$(echo $json | cut -d':' -f2 | cut -d'}' -f1)
  echo $PIAPORT > /pf/port
}

EXITCODE=0
PROGRAM=`basename $0`
VERSION=1.0

while true
do
    port_forward_assignment

    exit 0
done &
