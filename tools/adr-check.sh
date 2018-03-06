#!/bin/bash

for i in $(find doc/architecture/decisions/*.md |cut -d"-" -f1 |cut -d"/" -f4); do
  if [[  $(find doc/architecture/decisions/ -name "*.md" |grep -c ${i}) -gt 1 ]]; then
    echo "There is a conflict in ADR naming:"
    find doc/architecture/decisions -name "*.md" |grep $i
    exit 1
  fi
done
