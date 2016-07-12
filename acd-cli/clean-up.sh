#!/bin/bash

main() {
  echo '* cleaning up'
  local path="$LOCAL_TARGET"
  if [ -z "$path" ]; then
    echo 'Missing LOCAL_TARGET env'
    exit 1
  fi
  find "$path" -type f -mtime +14 -exec rm -rf {} \;
}

main "$@"
