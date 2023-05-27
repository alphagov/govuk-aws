#!/bin/dash
set -eu

for file in "$@"; do
  if jq -r . "$file" >/dev/null 2>&1; then
    echo "$file has invalid JSON"
    exit 1
  fi
done
