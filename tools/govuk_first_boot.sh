#!/bin/bash
# This script is present in /usr/loca/bin/ on the puppetmaster AMI and is called by
# rc.local. It will only execute on first boot / in presence of /var/govuk/FIRST_BOOT.
set -e
set -u
set -x

GOVUK_WORKDIR='/var/govuk'
GOVUK_LOGDIR='/var/log/govuk'

GIT_BINARY='/usr/bin/git'
AWS_BINARY='/usr/local/bin/aws'
AWS_REGION='eu-west-1'

SSH_KEYSTORE='/root/.ssh'
GPG_KEYSTORE='/root/.gnupg'
GPG_KEYNAME='gpgkey'

PUPPETMASTER_BOOTSTRAP_REPO_URL='https://github.com/alphagov/govuk-aws.git'

if [[ -e ${GOVUK_WORKDIR}/FIRST_BOOT ]]
  then
    # Make sure log dir exists
    mkdir -p ${GOVUK_LOGDIR}
    # Make sure work dir exists
    mkdir -p ${GOVUK_WORKDIR}
    # Make sure gnupg dir exists
    mkdir -p ${GPG_KEYSTORE}

    cd ${GOVUK_WORKDIR}

    # Clone repository with puppetmaster boostrap scripts
    ${GIT_BINARY} clone ${PUPPETMASTER_BOOTSTRAP_REPO_URL}
    # This is kluge for testing 
    cp /root/govuk_puppetmaster_bootstrap.sh ./govuk-aws/tools/

    # Retrieve private SSH key to allow cloning of govuk-secrets
    ${AWS_BINARY} --region=${AWS_REGION} ssm get-parameter --name "govuk_secrets_clone_ssh" --with-decryption \
    | jq .Parameter.Value | sed -e "s/^\"//;s/\"$//" > ${SSH_KEYSTORE}/id_rsa

    # This is kluge for testing
    cp /var/govuk/clone_key ${SSH_KEYSTORE}/id_rsa
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

    chmod u+x ${GOVUK_WORKDIR}/govuk-aws/tools/govuk_puppetmaster_bootstrap.sh
    ${GOVUK_WORKDIR}/govuk-aws/tools/govuk_puppetmaster_bootstrap.sh

    rm ${GOVUK_WORKDIR}/FIRST_BOOT
fi
