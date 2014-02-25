#!/bin/sh
source /mnt/sd-ext/etc/dtnoutbox.conf

if [ -z $NAME ] || [ -z $OUTBOX ] || [ -z $DESTINATION ]; then
  echo "error: mandatory option not defined. exiting"
  exit 1
fi

if [ -z $ENABLED ]; then
  echo "dtnoutbox not enabled. exiting"
  exit 0
else
  OPTIONS="$NAME $OUTBOX $DESTINATION"

  if [ $WORKDIR ]; then
    OPTIONS="$OPTIONS -w $WORKDIR"
  fi

  if [ $INTERVAL ]; then
    OPTIONS="$OPTIONS -i $INTERVAL"
  fi

  if [ $ROUNDS ]; then
    OPTIONS="$OPTIONS -r $ROUNDS"
  fi

  if [ $PATH ]; then
    OPTIONS="$OPTIONS -p $PATH"
  fi

  if [ $REGEX ]; then
    OPTIONS="$OPTIONS -R $REGEX"
  fi

  if [ $INVERT ]; then
    OPTIONS="$OPTIONS -I"
  fi

  if [ $QUIET ]; then
    OPTIONS="$OPTIONS -q"
  fi

  if [ $GROUP ]; then
    OPTIONS="$OPTIONS -g"
  fi

  /mnt/sd-ext/bin/dtnoutbox $OPTIONS
fi
