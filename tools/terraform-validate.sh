#!/usr/bin/env bash
set -eu

for file in "$@"; do
  dirname "$file";
done \
  | sort | uniq | \
    while read -r dir; do
      rm -rf ${dir}/.terraform;
      rm -f ${dir}/terraform.tfstate.backup;
      terraform init "${dir}";
      terraform validate "${dir}";
    done
