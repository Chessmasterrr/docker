#!/bin/bash

# Start the first process
/usr/local/bin/apache2-foreground &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apache2-foreground: $status"
  exit $status
fi

# Start the second process
cron &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start cron: $status"
  exit $status
fi

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container will exit with an error
# if it detects that either of the processes has exited.
# Otherwise it will loop forever, waking up every 60 seconds

while /bin/true; do
  sleep 60
  ps aux |grep apache2 |grep -q -v grep
  PROCESS_1_STATUS=$?
  echo "status1: $PROCESS_1_STATUS"
  ps aux |grep cron |grep -q -v grep
  PROCESS_2_STATUS=$?
  echo "status2: $PROCESS_2_STATUS"
  # If the greps above find anything, they will exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
done
