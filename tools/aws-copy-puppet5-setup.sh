#!/usr/bin/env bash
# Set up Puppet on a remote machine. Do not call this script directly.
# Instead, use `tools/push-puppet.sh` in the govuk-provisioning repo.
set -ex

while getopts "e:s:h" option
do
  case $option in
    h ) HELP=1 ;;
    s ) STACKNAME=$OPTARG ;;
    e ) ENVIRONMENT=$OPTARG ;;
  esac
done

if [[ -z $ENVIRONMENT ]]
then
  echo "No environment set."
  HELP=1
fi

if [[ -z $STACKNAME ]]
then
  echo "No stackname set."
  HELP=1
fi

if [[ "$HELP" = "1" ]]
then
  echo "Set up Puppet on a remote machine"
  echo "-e environment name"
  echo "-s stackname"
  echo "-h show this help"
  exit 0
fi

RELEASENAME=`date +%Y%m%d%H%M%S`

if [[ "$ENVIRONMENT" != "production" ]]
then
  cp ~/govuk-puppet/hieradata_aws/${ENVIRONMENT}.yaml ~/govuk-puppet/hieradata_aws/production.yaml
  cp ~/govuk-puppet/hieradata_aws/${ENVIRONMENT}_credentials.yaml ~/govuk-puppet/hieradata_aws/production_credentials.yaml

  if [[ -d "~/govuk-puppet/hieradata_aws/${STACKNAME}" ]]
  then
    cp ~/govuk-puppet/hieradata_aws/${STACKNAME}/${ENVIRONMENT}_credentials.yaml ~/govuk-puppet/hieradata_aws/${STACKNAME}/production_credentials.yaml
  fi
fi

mkdir -p /usr/share/puppet/production/releases
mv ~/govuk-puppet /usr/share/puppet/production/releases/${RELEASENAME}
rm -f /usr/share/puppet/production/current
ln -s /usr/share/puppet/production/releases/${RELEASENAME} /usr/share/puppet/production/current

puppet apply --verbose --hiera_config=/usr/share/puppet/production/current/hiera_aws.yml --modulepath=/usr/share/puppet/production/current/modules:/usr/share/puppet/production/current/vendor/modules/  /usr/share/puppet/production/current/manifests/site.pp

chown -R deploy:deploy /usr/share/puppet/production/releases/${RELEASENAME}
