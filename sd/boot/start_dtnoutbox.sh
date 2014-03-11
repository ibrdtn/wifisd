#!/bin/sh
source /mnt/sd-ext/etc/dtnoutbox.conf

if [ -z "${NAME}" ] || [ -z "${OUTBOX}" ] || [ -z "${DESTINATION}" ]; then
  echo "error: mandatory option not defined. exiting"
  exit 1
fi

if [ "${ENABLED}" == 1 ]; then
  OPTIONS="${NAME} ${OUTBOX} ${DESTINATION}"

  if [ -n "${WORKDIR}" ]; then
    OPTIONS="$OPTIONS -w $WORKDIR"
  fi

  if [ -n "${INTERVAL}" ]; then
    OPTIONS="$OPTIONS -i $INTERVAL"
  fi

  if [ -n "${ROUNDS}" ]; then
    OPTIONS="$OPTIONS -r $ROUNDS"
  fi

  if [ -n "${PATH}" ]; then
    OPTIONS="$OPTIONS -p $PATH"
  fi

  if [ -n "${REGEX}" ]; then
    OPTIONS="$OPTIONS -R $REGEX"
  fi

  if [ "${INVERT}" == 1 ]; then
    OPTIONS="$OPTIONS -I"
  fi

  if [ "${QUIET}" == 1 ]; then
    OPTIONS="$OPTIONS -q"
  fi

  if [ "${GROUP}" == 1 ]; then
    OPTIONS="$OPTIONS -g"
  fi

  /mnt/sd-ext/bin/dtnoutbox $OPTIONS
else
  echo "dtnoutbox not enabled. exiting"
  exit 0
fi
