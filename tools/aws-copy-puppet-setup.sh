#!/usr/bin/env bash
# Set up Puppet on a remote machine. Do not call this script directly.
# Instead, use `tools/push-puppet.sh` in the govuk-provisioning repo.
set -ex

while getopts "e:h" option
do
  case $option in
    h ) HELP=1 ;;
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
mkdir -p -m 0700 /etc/puppet/gpg
gpg --homedir /etc/puppet/gpg --allow-secret-key-import --import gpgkey
chown -R puppet: /etc/puppet/gpg

# Switch Jenkins config management off
for filename in /usr/share/puppet/production/current/hieradata_aws/*.yaml; do
  sed -i 's/govuk_jenkins::config::manage_config: .*/govuk_jenkins::config::manage_config: false/g' "$filename"
done


puppet apply --verbose --trusted_node_data --hiera_config=/usr/share/puppet/production/current/hiera_aws.yml --modulepath=/usr/share/puppet/production/current/modules:/usr/share/puppet/production/current/vendor/modules/ --manifestdir=/usr/share/puppet/production/current/manifests /usr/share/puppet/production/current/manifests/site.pp

chown -R deploy:deploy /usr/share/puppet/production/releases/${RELEASENAME}
