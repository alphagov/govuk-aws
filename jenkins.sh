#!/bin/bash
#
# This script invokes the build-terraform-project.sh tool to deploy the code.
#
set -e

if [[ ! $(command -v sops) ]]; then
  echo "sops not installed, exiting"
  exit 1
fi

# Set the Terraform version to enable testing new versions.
if [[ $TERRAFORM_VERSION != '' ]]; then
  BIN='tmp-bin'

  echo "Creating temporary bin directory"
  rm -rf $BIN && mkdir $BIN && cd $BIN

  echo "Downloading Terraform ${TERRAFORM_VERSION}"

  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS

  SHASUM256=$(shasum -a 256 terraform_${TERRAFORM_VERSION}_linux_amd64.zip |cut -d ' ' -f1)

  echo "Checking integrity of file"
  grep -q $SHASUM256 terraform_${TERRAFORM_VERSION}_SHA256SUMS || (echo "SHASUM256 does not match, exiting"; exit 1)

  echo "Checked, unpacking"
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip

  cd ..

  echo "Setting path:"
  PATH=$(pwd)/$BIN:$PATH
  echo $PATH

  echo "Terraform binary: $(command -v terraform)"
fi

rm -rf govuk-aws-data

if [[ "$GOVUK_AWS_DATA_BRANCH" == "" ]]; then
  GOVUK_AWS_DATA_BRANCH="main"
fi

echo "Cloning govuk-aws-data"
git clone --single-branch --branch "$GOVUK_AWS_DATA_BRANCH" git@github.com:alphagov/govuk-aws-data.git

case $COMMAND in
  'apply') EXTRA='-auto-approve';;
  'plan (destroy)') COMMAND='plan'; EXTRA='-detailed-exitcode -destroy';;
  # This flag must be -auto-approve for terraform v1.0+
  # TODO: either also support -force for terraform v0.x, or update remaining
  #       projects that require terraform v0.x 
  'destroy') EXTRA='-auto-approve';;
  'plan') EXTRA='-detailed-exitcode';;
esac

tools/build-terraform-project.sh -d './govuk-aws-data/data' \
                                 -c $COMMAND \
                                 -p $PROJECT \
                                 -s $STACKNAME \
                                 -e $ENVIRONMENT \
                                 -- $EXTRA
