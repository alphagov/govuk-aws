#!/usr/bin/env bash

PUPPET_REPO=$1
PUPPETMASTER_ELB=$2

if [[ ! -d "$PUPPET_REPO" ]]; then
  echo "Couldn't find puppet directory: ${PUPPET_REPO}"
  exit 1
fi

if [[ -z "$PUPPETMASTER_ELB" ]]; then
  echo "Specify a puppetmaster ELB"
  exit 1
fi

rsync -avz \
      --exclude='.git/' \
      "${PUPPET_REPO%/}" "$PUPPETMASTER_ELB":

cat << EOF
WARNING: This is intended for testing purposes only.
It will break any local changes to the puppetmaster and always sets itself
in the 'puppet/production/current' directory.
EOF

ssh "$PUPPETMASTER_ELB"<<EOF
sudo rsync -avz govuk-puppet/ /usr/share/puppet/production/current/
sudo service puppetmaster restart
EOF
