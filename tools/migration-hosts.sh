#!/bin/bash
#
# A helper script to insert or remove migration domains from /etc/hosts
DOMAINS=(
alert
assets-origin
backend
bouncer
collections-publisher
contacts-admin
content-performance-manager
content-tagger
deploy
draft-origin
docs
grafana
graphite
hmrc-manuals-api
imminence
jumpbox
kibana
local-links-manager
manuals-publisher
maslow
publisher
release
search-admin
service-manual-publisher
short-url-manager
signon
specialist-publisher
support
transition
travel-advice-publisher
whitehall-admin
www-origin
)

usage() {
  echo "Usage: "
  echo "$0 [put/del] [environment]>"
  exit 1
}

ACTION=$1
ENV=$2

if [[ ! $ACTION ]]; then
  echo "ERROR: Must set action"
  usage
fi

if [[ ! $ENV ]]; then
  echo "ERROR: Must set environment"
  usage
fi

if [[ $ENV != "production" ]]; then
  LOOKUP="${ENV}.govuk.digital"
else
  LOOKUP="govuk.digital"
fi

if [[ $ACTION == 'put' ]]; then
  for subdomain in ${DOMAINS[*]}; do
    IP=$(dig +short ${subdomain}.${LOOKUP} |tail -n1)
    if [[ $IP != "" ]]; then
      echo "${IP} ${subdomain}.${ENV}.publishing.service.gov.uk" | sudo tee -a /etc/hosts
    else
      echo "WARNING: No results for ${subdomain}"
    fi
  done
elif  [[ $ACTION == 'del' ]]; then
  for subdomain in ${DOMAINS[*]}; do
    sudo sed -i '' /${subdomain}.${ENV}.publishing.service.gov.uk/d /etc/hosts
  done
else
  usage
fi
