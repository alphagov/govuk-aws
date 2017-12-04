#!/usr/bin/env bash
set -eu

for file in "$@"; do
  dirname "$file";
done \
  | sort | uniq | \
    while read -r dir; do
      rm -rf ${dir}/.terraform;
      rm -f ${dir}/terraform.tfstate.backup;
      terraform init -backend=false "${dir}";
      terraform validate -check-variables=false "${dir}";
    done
