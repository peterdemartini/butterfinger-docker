#!/bin/bash

main() {
  echo '* uploading'
  local path="$LOCAL_TARGET"
  if [ -z "$path" ]; then
    echo 'Missing LOCAL_TARGET env'
    exit 1
  fi
  acd_cli upload --overwrite $path/* /
}

main "$@"
