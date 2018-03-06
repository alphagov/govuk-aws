#!/usr/bin/env bash
# Set up Puppet on a remote machine. Do not call this script directly.
# Instead, use `tools/push-puppet.sh` in the govuk-provisioning repo.
set -ex

while getopts "e:s:h" option
do
  case $option in
    s ) STACKNAME=$OPTARG ;;
    e ) ENVIRONMENT=$OPTARG ;;
    h|* ) HELP=1 ;;
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

RELEASENAME=$(date +%Y%m%d%H%M%S)

if [[ "$ENVIRONMENT" != "production" ]]
then
  cp ~/govuk-puppet/hieradata_aws/${ENVIRONMENT}.yaml ~/govuk-puppet/hieradata_aws/production.yaml
  cp ~/govuk-puppet/hieradata_aws/${ENVIRONMENT}_credentials.yaml ~/govuk-puppet/hieradata_aws/production_credentials.yaml

  if [[ -d "${HOME}/govuk-puppet/hieradata_aws/${STACKNAME}" ]]
  then
    cp ~/govuk-puppet/hieradata_aws/${STACKNAME}/${ENVIRONMENT}_credentials.yaml ~/govuk-puppet/hieradata_aws/${STACKNAME}/production_credentials.yaml
  fi
fi

mkdir -p /usr/share/puppet/production/releases
mv ~/govuk-puppet /usr/share/puppet/production/releases/${RELEASENAME}
rm -f /usr/share/puppet/production/current
ln -s /usr/share/puppet/production/releases/${RELEASENAME} /usr/share/puppet/production/current
# We only want the permissions applied to the deepest directory, so is correct
# behaviour.
# shellcheck disable=SC2174
mkdir -p -m 0700 /etc/puppet/gpg
gpg --homedir /etc/puppet/gpg --allow-secret-key-import --import gpgkey
chown -R puppet: /etc/puppet/gpg

gem install --no-ri --no-rdoc hiera-eyaml-gpg gpgme

puppet apply --verbose --trusted_node_data --hiera_config=/usr/share/puppet/production/current/hiera_aws.yml --modulepath=/usr/share/puppet/production/current/modules:/usr/share/puppet/production/current/vendor/modules/ --manifestdir=/usr/share/puppet/production/current/manifests /usr/share/puppet/production/current/manifests/site.pp

chown -R deploy:deploy /usr/share/puppet/production/releases/${RELEASENAME}
