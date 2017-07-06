#!/usr/bin/env bash
set -eu

for file in "$@"; do
  dirname "$file";
done \
  | sort | uniq | \
    while read -r dir; do
      terraform validate "${dir}";
    done
