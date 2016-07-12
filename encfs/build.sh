#!/bin/bash

setup_it() {
  echo '* setup it'
  local mount_source="$1"
  local mount_target="$2"
  mkdir -p "$mount_source" || return 1
  mkdir -p "$mount_target" || return 1
}

wait_for_it() {
  local wait_for_mnt="$1"
  if [ ! "$wait_for_mnt" ]; then
    return 0
  fi
  echo '* wait for it'
  while true ; do
    if mount | grep -q "$wait_for_mnt" ; then
      break
    fi
    echo "* waiting for it to mount $wait_for_mnt";
    sleep 5
  done
}

clean_up() {
  echo '* cleaning up'
  local mount_target="$1"
  fusermount -u $mount_target 2> /dev/null || return 0
}

mount_it() {
  echo '* mounting it'
  local pass="$1"
  local mount_source="$2"
  local mount_target="$3"

  if [ -z "$pass" ]; then
    mount_it_without_pass "$mount_source" "$mount_target"
  else
    mount_it_with_pass "$mount_source" "$mount_target"
  fi
}

mount_it_with_pass() {
  echo '* mounting it with pass'
  local mount_source="$1"
  local mount_target="$2"
  exec encfs -o allow_root -f --extpass='/bin/echo $ENCFS_PASS' "$mount_source" "$mount_target"
}

mount_it_without_pass() {
  echo '* mounting it without pass'
  local mount_source="$1"
  local mount_target="$2"
  exec encfs -o allow_root -f "$mount_source" "$mount_target"
}

main() {
  local mount_source="$MOUNT_SOURCE"
  if [ -z "$mount_source" ]; then
    echo "Missing MOUNT_SOURCE env"
    exit 1
  fi

  local mount_target="$MOUNT_TARGET"
  if [ -z "$mount_target" ]; then
    echo "Missing MOUNT_TARGET env"
    exit 1
  fi

  echo " MOUNT_SOURCE=$mount_source"
  echo " MOUNT_TARGET=$mount_target"

  local wait_for_mnt="$WAIT_FOR_MNT"

  wait_for_it "$wait_for_mnt" && \
    setup_it "$mount_source" "$mount_target" && \
    clean_up "$mount_target" && \
    mount_it "$ENCFS_PASS" "$mount_source" "$mount_target" && \
    echo '* done' && \
    exit 0

  echo '* failed to build encfs'
  exit 1
}

main "$@"
