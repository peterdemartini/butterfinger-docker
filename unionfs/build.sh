#!/bin/bash

setup_mount_target() {
  echo '* setting up mount target'
  local mount_target="$1"
  mkdir -p "$mount_target"
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
  echo '* clean_up'
  local mount_target="$1"
  fusermount -u "$mount_target" 2> /dev/null || return 0
}

mount_it() {
  echo '* mounting it'
  local mount_target="$1"
  exec unionfs-fuse -d -o cow,allow_other "$mount_unite" "$mount_target"
}

main() {
  local mount_unite="$MOUNT_UNITE"
  if [ -z "$mount_unite" ]; then
    echo "Missing MOUNT_UNITE env"
    exit 1
  fi

  local mount_target="$MOUNT_TARGET"
  if [ -z "$mount_target" ]; then
    echo "Missing MOUNT_TARGET env"
    exit 1
  fi
  echo " MOUNT_UNITE=$mount_unite"
  echo " MOUNT_TARGET=$mount_target"
  local wait_for_mnt="$WAIT_FOR_MNT"
  wait_for_it "$wait_for_it"
  setup_mount_target "$mount_target" && \
    clean_up "$mount_target" && \
    mount_it "$mount_unite" "$mount_target" && \
  echo '* done' && \
  exit 0

  echo '* failed to build unionfs'
  exit 1
}

main "$@"
