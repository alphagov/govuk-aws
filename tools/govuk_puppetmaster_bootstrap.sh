#!/bin/bash
# This script replaces aws-push-puppet and aws-copy-puppet-config.sh
# as part of a new automated bootstrap process based on an AMI and
# SSM secrets store. It relies on being called by govuk_first_boot.sh
# which is present in /usr/local/bin/ within the AMI and is called by
# rc.local on first boot.
set -x
set -u

GIT_BINARY='/usr/bin/git'
BUNDLE_BINARY='/usr/bin/bundle'
RAKE_BINARY='/usr/local/bin/rake'
GEM_BINARY='/usr/bin/gem'
PUPPET_BINARY='/usr/local/bin/puppet'
GPG_BINARY='/usr/bin/gpg'

GOVUK_ENVIRONMENT='staging'
GOVUK_STACKNAME='blue'

GOVUK_WORKDIR='/var/govuk'
GOVUK_LOGDIR='/var/log/govuk'

GOVUK_GIT_URL='git@github.com:alphagov'

GOVUK_SECRETS_REPO='govuk-secrets'
GOVUK_PUPPET_REPO='govuk-puppet'

GPG_KEYSTORE='/root/.gnupg'
GPG_KEYNAME='gpgkey'

apt-get -y install bundler
apt-get -y install python3-pip
pip3 install awscli

cd ${GOVUK_WORKDIR}

# Retrieve private SSH key to allow cloning of govuk-secrets
${AWS_BINARY} --region=${AWS_REGION} ssm get-parameter --name "govuk_secrets_clone_ssh" --with-decryption \
| jq .Parameter.Value | sed -e "s/^\"//;s/\"$//" > ${SSH_KEYSTORE}/id_rsa
chmod 600 ${SSH_KEYSTORE}/id_rsa

# Retrieve private GPG key to allow decryption of govuk-secrets
GPG_1_OF_2=$(${AWS_BINARY} --region=${AWS_REGION} ssm get-parameter --name "govuk_staging_secrets_1_of_2_gpg" --with-decryption \
| jq .Parameter.Value | sed -e "s/^\"//;s/\"$//")
GPG_2_OF_2=$(${AWS_BINARY} --region=${AWS_REGION} ssm get-parameter --name "govuk_staging_secrets_2_of_2_gpg" --with-decryption \
| jq .Parameter.Value | sed -e "s/^\"//;s/\"$//")

{
echo "-----BEGIN PGP PRIVATE KEY BLOCK-----";
echo "Version: GnuPG v1.4.11 (GNU/Linux)";
echo "";
echo ${GPG_1_OF_2}${GPG_2_OF_2}|sed -e s/' '/'\n'/g;
echo "-----END PGP PRIVATE KEY BLOCK-----"; 
} >>${GPG_KEYSTORE}/${GPG_KEYNAME}

# Clone Puppet repo
${GIT_BINARY} clone ${GOVUK_GIT_URL}/${GOVUK_PUPPET_REPO}

# Clone secrets repo
${GIT_BINARY} clone ${GOVUK_GIT_URL}/${GOVUK_SECRETS_REPO}

cp ${GOVUK_WORKDIR}/${GOVUK_SECRETS_REPO}/puppet_aws/hieradata/* ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/

RELEASENAME=$(date +%Y%m%d%H%M%S)

if [[ "${GOVUK_ENVIRONMENT}" != "production" ]]
then
  cp ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/${GOVUK_ENVIRONMENT}.yaml ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/production.yaml
  cp ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/${GOVUK_ENVIRONMENT}_credentials.yaml ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/production_credentials.yaml

  if [[ -d "${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/${GOVUK_STACKNAME}" ]]
  then
    cp ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/${GOVUK_STACKNAME}/${GOVUK_ENVIRONMENT}_credentials.yaml ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO}/hieradata_aws/${GOVUK_STACKNAME}/production_credentials.yaml
  fi
fi

mkdir -p /usr/share/puppet/production/releases
mv ${GOVUK_WORKDIR}/${GOVUK_PUPPET_REPO} /usr/share/puppet/production/releases/${RELEASENAME}
rm -f /usr/share/puppet/production/current
ln -s /usr/share/puppet/production/releases/${RELEASENAME} /usr/share/puppet/production/current
# We only want the permissions applied to the deepest directory, so is correct
# behaviour.
# shellcheck disable=SC2174
mkdir -p -m 0700 /etc/puppet/gpg
${GPG_BINARY} --homedir /etc/puppet/gpg --allow-secret-key-import --import ${GPG_KEYSTORE}/${GPG_KEYNAME}
chown -R puppet: /etc/puppet/gpg

${GEM_BINARY} install --no-ri --no-rdoc hiera-eyaml-gpg gpgme

cd /usr/share/puppet/production/current/

# Installing Puppet dependencies
${BUNDLE_BINARY} install
${BUNDLE_BINARY} exec ${RAKE_BINARY} librarian:install
cd ${GOVUK_WORKDIR}

${PUPPET_BINARY} apply --verbose --trusted_node_data --hiera_config=/usr/share/puppet/production/current/hiera_aws.yml --modulepath=/usr/share/puppet/production/current/modules:/usr/share/puppet/production/current/vendor/modules/ --manifestdir=/usr/share/puppet/production/current/manifests /usr/share/puppet/production/current/manifests/site.pp >> ${GOVUK_LOGDIR}/govuk_puppet_apply.log 2>&1
chown -R deploy:deploy /usr/share/puppet/production/releases/${RELEASENAME}
