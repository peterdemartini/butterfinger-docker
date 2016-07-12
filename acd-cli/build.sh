#!/bin/bash

setup_mount_target() {
  echo '* setting up mount target'
  local mount_target="$1"
  mkdir -p "$(dirname $mount_target)/acd_cli"
  mkdir -p "$mount_target"
}

sync_it() {
  echo '* syncing it'
  acd_cli sync
}

clean_up() {
  echo '* clean_up'
  local mount_target="$1"
  fusermount -u $mount_target 2> /dev/null || return 0
}

mount_it() {
  echo '* mounting it'
  local mount_target="$1"
  exec acd_cli --allow-root --debug mount -i60 --foreground "$mount_target"
}

copy_oauth() {
  echo '* copying oauth'
  cat /config/oauth_data
  cp /config/oauth_data "$ACD_CLI_CACHE_PATH"
}

main() {
  local mount_target="$MOUNT_TARGET"

  if [ -z "$mount_target" ]; then
    echo "Missing MOUNT_TARGET env"
    exit 1
  fi

  echo " MOUNT_TARGET=$mount_target"

  setup_mount_target "$mount_target" && \
    copy_oauth && \
    sync_it && \
    clean_up "$mount_target" && \
    mount_it "$mount_target" && \
    echo '* done' && \
    exit 0

  echo '* failed to build acd-cli'
  exit 1
}

main "$@"
