# Environment Provisioning

This document discusses how to create a new environment in AWS. Discussion as to the decisions taken can be found in the [architecture/decisions](architecture/decisions) directory, of particular note is [the environment bootstrapping process](architecture/decisions/0009-environment-bootstrapping-process.md).

To clarify terms used here there is a [glossary](#glossary). Throughout this document `<foo>` indicates a value you supply (e.g. a stack name) and:

```
bar
```
indicates a command to be run from a shell.

## Overview

The general steps for provisioning a new environment are:

1. [Clone all the relevant repositories](#cloning-the-repositories)
2. [Build the S3 bucket for Terraform state](#build-the-s3-bucket)
3. [Provision the base infrastructure](#provision-the-base-infrastructure)
4. [Build the Puppet master](#build-the-puppet-master)
5. [Deploy the puppet code and secrets](#deploy-the-puppet-code-and-secrets)
6. [Build the deploy Jenkins](#build-the-deploy-jenkins)
7. [Do the Jenkins token shuffle](#do-the-jenkins-token-shuffle)
* Rebuild everything else in the usual deployment ways

## Requirements

* Install [Homebrew](https://brew.sh) on macOS or Linux.
* Install necessary packages:

```shell
brew install git tfenv ssh-copy-id awscli
```

* Install the version of Terraform specified in `.terraform-version` with `tfenv install`.

* Clone the following repositories to your local machine

      * [govuk-puppet](https://github.com/alphagov/govuk-puppet)
      * [govuk-secrets](https://github.com/alphagov/govuk-secrets)
      * [govuk-aws-data](https://github.com/alphagov/govuk-aws-data)
      * [govuk-aws (this one)](https://github.com/alphagov/govuk-aws)

> **NOTE: Ensure Puppet has all dependencies installed**
>
> Follow the instructions [in the govuk-puppet repository](https://github.com/alphagov/govuk-puppet#installing)
> to ensure that all Puppet modules and dependencies are pulled in.
>
> If this step is not completed you may see errors when deploying about
> missing functions
>

## Build the S3 bucket

An [S3](https://aws.amazon.com/s3/) bucket needs to be created to store state for Terraform. If you're using an account that already has this set up you can skip this step, check by running:
```
export ENVIRONMENT=<environment>
export TERRAFORM_BUCKET="govuk-terraform-steppingstone-${ENVIRONMENT}"
aws s3 ls $TERRAFORM_BUCKET
```

If the bucket is missing you'll see an error:

```
An error occurred (NoSuchBucket) when calling the ListObjects operation: The specified bucket does not exist
```

otherwise you'll see the bucket's contents, one directory per existing stack:

```
PRE blue/
PRE green/
PRE govuk/
...
```

Create an S3 bucket and enable versioning on it:

```
aws s3 mb "s3://${TERRAFORM_BUCKET}"
aws s3api put-bucket-versioning  \
      --bucket ${TERRAFORM_BUCKET} \
      --versioning-configuration Status=Enabled
```


## Provision the base infrastructure

There are several Terraform projects that need to be run to set up the base infrastructure. For each of these you should run `plan` and `apply` in the build script. If you're setting up a new stack you'll also need to create `.backend` files for each project (see [below](#creating-backend-files-for-a-new-stack)), otherwise you should use an existing one (e.g. `integration-green` or `integration-blue`).

```
export DATA_DIR=<path to govuk-aws-data repository>/data
export STACKNAME=<stackname>
NOTE: the ENVIRONMENT variable also needs to be set or passed to this script.

tools/build-terraform-project.sh -c plan -p <project name>
...terraform output...
tools/build-terraform-project.sh -c apply -p <project name>
...terraform output...
```

If you choose not to use environment variables for configuration, the full commandline arguments need to include path to the govuk-aws-data/data directory, environment and stack, e.g.
```
tools/build-terraform-project.sh -d </path/to/govuk-aws-data/data> -e <environment> -s <stack> -c apply -p <project name>
```

As a rule of thumb, projects names infra-\* are using the 'govuk' stack, while projects named app-\* use the 'blue' stack (Exception to this rule is the infra-stack-dns-zones projet, which uses 'blue').

The projects that need to be initially run in this way are:

1. `infra-security`
2. `infra-monitoring`
3. `infra-vpc`
4. `infra-networking`
5. `infra-root-dns-zones`
6. `infra-stack-dns-zones`
7. `infra-certificates`
8. `infra-security-groups`
9. `infra-database-backups-bucket`
10. `infra-artefact-bucket`
11. `infra-mirror-bucket`
12. `infra-public-services`

### Update the NS records (if rebuilding infra-root-dns-zones in staging or integration)

Since we do not access multiple accounts for a single terraform run, the apex NS records for
the environment specific subdomains have to be updated if the `infra-networking` project is rebuilt and the subdomain NS resources are rewritten.

For integration these are:
- integration.publishing.service.gov.uk
- integration.govuk-internal.digital
- integration.govuk.digital

For staging these are:
- staging.publishing.service.gov.uk
- staging.govuk-internal.digital
- staging.govuk.digital

### Creating backend files for a new stack

**This is not currently required as we are only using a single "blue" stack and it's configuration is complete for the current set of projects.**

Each project stores its state in an S3 bucket in AWS. These are configured using a backend file which looks like and lives in the project directory.
```
# terraform/projects/<project name>/<environment>.<stack name>.backend
bucket  = "govuk-terraform-steppingstone-<environment>"
key     = "<stack name>/<project name>.tfstate"
encrypt = true
region  = "<region>"
```

## Build the Puppet Master

Puppet master configuration/installation is triggered by a terraform userdata snippet which clones govuk-aws and executes tools/govuk-puppetmaster-<environment>-bootstrap.sh.

1. Create new govuk-aws-data files in the app-puppetmaster directory for your environment
2. Create new userdata snippet for the new puppetmaster environment: `terraform/userdata/20-puppetmaster-<environment>`
3. Create new bootstrap script for the environment: `tools/govuk-puppetmaster-<environment>-bootstrap.sh`. Make sure the file is executable

```
chmod 755 tools/govuk-puppetmaster-<environment>-bootstrap.sh
```

4. Add SSM parameters for the Puppetmaster bootstrap:

The bootstrap script requires for secrets to be available to the `<stackname>-puppetmaster` role in the AWS SSM parameter store in base64 encoding:
- `govuk_base64_github.com_hostkey`, The public host key of github.com used to automatically clone repositories
- `govuk_base64_github.com_ssh_readonly`, The private SSH key to allow access to github.com:alphagov/govuk-secrets
- `govuk_base64_gpg_1_of_3`, First part of the GPG key. See below.
- `govuk_base64_gpg_2_of_3`, Second part of the GPG key. See below.
- `govuk_base64_gpg_3_of_3`, Third part of the GPG key. At the moment the length of SecretString in the AWS SSM parameter store is limited to 4096 characters.

5. Create Hieradata files for the new environment, changing relevant values:

- govuk-puppet/hieradata_aws/<environment>.yaml
- Credential files in govuk-secrets for the environment and apps/<environment>

6. Build the Terraform project with `enable_bootstrap` variable, to create an ELB with SSH access to the machine (We don't have any Jumpbox on the environment yet)

```
TF_VAR_enable_bootstrap=1 ./tools/build-terraform-project.sh -c plan -p app-puppetmaster -e <environment> -d ../govuk-aws-data/data -s govuk
...terraform output...
TF_VAR_enable_bootstrap=1 ./tools/build-terraform-project.sh -c apply -p app-puppetmaster -e <environment> -d ../govuk-aws-data/data -s govuk
...terraform output...
```

If you need to verify the Puppetmaster provisioning, you can access the Puppetmaster using the bootstrap ELB DNS record.

If Puppet master is rebuild (i.e. clients to already have certificates in place) it is then required to cycle the Puppet certificates by deleting the directory /etc/puppet/ssl and run `sudo puppet agent -t` on all nodes before issuing `puppet cert sign --all` on the Puppet master.  

After building a Jumpbox, you should run again Terraform without `enable_bootstrap` to destroy the initial boostrap ELB:

```
./tools/build-terraform-project.sh -c apply -p app-puppetmaster -e <environment> -d ../govuk-aws-data/data -s govuk
...terraform output...
```

## Build the jumpbox

Without the jumpbox, it's impossible to SSH into the environment once we've
deleted the Puppetmaster's ELB.

```
tools/build-terraform-project.sh -p app-jumpbox -c plan
...terraform output...
tools/build-terraform-project.sh -p app-jumpbox -c apply
```

## Build the deploy Jenkins

```
tools/build-terraform-project.sh -c plan -p app-deploy
...terraform output...
tools/build-terraform-project.sh -c apply -p app-deploy
...terraform output...
```

Once this has built and provisioned, you can navigate to
`deploy.<stackname>.<environment>.govuk.digital`.

## Do the Jenkins token shuffle

**If Jenkins already has a list of jobs when it launches, this is not required.**

For each user, Jenkins automatically generates an API token which is based upon the machine it's installed on, which means that each token is unique to each instance. Additionally, tokens stored on disk are encrypted so we are not able to manage these with Puppet in the Jenkins configuration.

We use Jenkins Job Builder to manage our jobs. This tool requires a Jenkins API user and token to be able to create jobs, and use Puppet to manage these credentials. Therefore we need to generate a token for the API user that Puppet creates, and add this token to our Puppet credentials.

Jenkins does not allow admins to view other users tokens, so there is a manual step involved.

1. SSH to the Jenkins instance
2. Edit the start up options: `sudo vim /etc/default/jenkins`
3. Append the following line to the end of `JAVA_ARGS`:

   `-Djenkins.security.ApiTokenProperty.showTokenToAdmins=true`

   It will probably look something like this:

   `JAVA_ARGS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Djenkins.security.ApiTokenProperty.showTokenToAdmins=true"`

4. Save and quit, and restart the Jenkins service: `sudo service jenkins restart`
5. You should now be able to login by going to https://deploy.\<stackname\>.\<environment\>.govuk.digital
6. Find the API user you want the token from by searching in the top bar (the default is "jenkins_api_user")
7. Click configure, and then "Show API token". Save the token, and update the credentials in the [govuk-secrets repo](https://github.com/alphagov/govuk-secrets)
8. The hiera key you're looking to update is called: `govuk::node::s_jenkins::jenkins_api_token`
9. As the Deploy_Puppet job won't yet exist, you will be unable to deploy Puppet at this point. Manually edit `/etc/jenkins_jobs/jenkins_jobs.ini` with the new token, and run the update job by running `sudo jenkins-jobs update /etc/jenkins_jobs/jobs/`.

When Jenkins Job Builder has successfully created jobs, deploy Puppet.

## Deploy the rest of the management stack

Create the following projects (in no particular order):

`app-apt`
`app-db-admin`
`app-content-data-api-db-admin`
`app-transition-db-admin`
`app-graphite`
`app-monitoring`


`app-apt` is a dependency for deploying any application instances because we need Gemstash for deployments.

## Deploy datastores

To ensure that applications deploy correctly, ensure that the datastores exist:

`app-backend-redis`
`app-elasticsearch5`
`app-elasticsearch6`
`app-mongo`
`app-mysql`
`app-postgresql`
`app-rabbitmq`
`app-router-backend`
`app-transition-postgresql`

Be aware that both RDS and Elasticache can take some time to deploy.

## Deploy the core applications

The following applications are core to the GOV.UK stack:

`app-publishing-api`
`app-content-store`
`app-search`

## Deploy the rest of the projects

Once the core of GOV.UK has been deployed, you should be able to deploy the rest of the stack. Be
aware that due to some dependencies between apps they may not come up cleanly and may need to be
redeployed.

## Glossary

This explains how these terms are used in this document.

**Environment** - A collection of stacks, these generally correspond to an AWS account. Multiple stacks may exist within a single environment (e.g. "integration-blue" & "integration-green" may both exist in the integration environment).

**Stack** - An arbitrary label for a grouping of deployed resources. In general resources within one stack work together but they may depend on resources from other stacks within the same environment (e.g. blue/green stacks which may share networking resources).

**Project** - The Terraform code to deploy some resources as a single unit. A single project may contain components to support other projects (these are generally prefixed with 'infra' e.g. `infra-security-groups`) or a single project (generally prefixed with 'app' e.g. `app-graphite`).
