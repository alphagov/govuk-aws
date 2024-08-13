# Environment Provisioning

This document discusses how to create a new environment in AWS. Discussion as to the decisions taken can be found in the [docs/architecture/decisions](/docs/architecture/decisions) directory, of particular note is [the environment bootstrapping process](/docs/architecture/decisions/0009-environment-bootstrapping-process.md).

To clarify terms used here there is a [glossary](#glossary). Throughout this document `<foo>` indicates a value you supply (e.g. a stack name) and:

```
bar
```
indicates a command to be run from a shell.

## Cautionary note

Creating a new environment can take up to three weeks.
You may find things that are broken, such as outdated docs, Puppet, Jenkins,
and application deployment pipelines.

You may find that steps are missing from the list below.

Seek help in the Slack channels #re-govuk and #reliability-eng.

## Overview

The general steps for provisioning a new environment are:

1. [Clone all the relevant repositories](#cloning-the-repositories)
1. [Build the S3 bucket for Terraform state](#build-the-s3-bucket)
1. [Provision the base infrastructure](#provision-the-base-infrastructure)
1. [Add DNS NS records](#add-dns-ns-records)
1. [Create hieradata for new environments](#create-hieradata-for-new-environments)
1. [Build the Puppet master](#build-the-puppet-master)
1. [Deploy the puppet code and secrets](#deploy-the-puppet-code-and-secrets)
1. [Build the deploy Jenkins](#build-the-deploy-jenkins)
1. [Do the Jenkins token shuffle](#do-the-jenkins-token-shuffle)
1. Rebuild everything else in the usual deployment ways

## Requirements

* Install [Homebrew](https://brew.sh) on macOS or Linux.
* Install necessary packages:

  ```shell
  brew install git tfenv ssh-copy-id awscli sops
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

## Glossary

This explains how these terms are used in this document.

**Environment** - A collection of stacks, these generally correspond to an AWS account. Multiple stacks may exist within a single environment (e.g. "integration-blue" & "integration-green" may both exist in the integration environment).

**Stack** - An arbitrary label for a grouping of deployed resources. In general resources within one stack work together but they may depend on resources from other stacks within the same environment (e.g. blue/green stacks which may share networking resources).

**Project** - The Terraform code to deploy some resources as a single unit. A single project may contain components to support other projects (these are generally prefixed with 'infra' e.g. `infra-security-groups`) or a single project (generally prefixed with 'app' e.g. `app-graphite`).

## A note on stacks

'Stacks' are pseudo-environments within environments, which are to
be deprecated.

The intent of introducing stacks was to provide via DNS a mechanism of
[blue-green deployments][].

For example, there exist current the `blue`, `govuk`, and `pink` stacks.
You may also see reference to a `green` stack.

An environment such as `production` or `staging` can contain multiple
stacks. So one could make requests to "https://my-app.blue.production.govuk.digital"
or "https://my-app.green.production.govuk.digital", in order to gracefully deploy
changes in a single environment.

However, the stacks approach has been deprecated. One should avoid using stacks
where possible. Where a stack is required, try to use the same one everywhere,
such as `govuk`.

Avoid adding new stack names such as 'yellow'. In the terraform in this repo
you'll find the `blue` and `govuk` stack names hard coded. You'll need to fix
those if you've chosen a different name for your stack.

When using multiple stacks, you should be really careful about choosing the
correct one when applying terraform projects, since you may later find that
you need to destroy and re-apply changes with the correct stack.

[blue-green deployments]: https://martinfowler.com/bliki/BlueGreenDeployment.html

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

> **Note:** in a new AWS account you'll need to apply projects like infra-security
using the AWS account root user since no other users will exist. Make sure
you don't delete or lose access to this user's credentials, since you won't
be able to recover the AWS account if someone deletes the infra-security project.

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

If you choose not to use environment variables for configuration, the full command line arguments need to include path to the govuk-aws-data/data directory, environment and stack, e.g.
```
tools/build-terraform-project.sh -d </path/to/govuk-aws-data/data> -e <environment> -s <stack> -c apply -p <project name>
```

**Important**: As a rule of thumb, projects names infra-\* are using the 'govuk'
stack, while projects named app-\* use the 'blue' stack (exception to this rule
is the infra-stack-dns-zones project, which uses 'blue').

The projects that need to be initially run in this way are:

1. `infra-security`
2. `infra-monitoring`
3. `infra-vpc`
4. `infra-networking`
5. `infra-root-dns-zones`
6. `infra-stack-dns-zones`
7. `infra-certificates`

You will need to purchase a certificate from Fastly for your new environment,
and then upload the certificate to AWS Route53. The steps in [Renew a TLS
certificate for GOV.UK][] are broadly the same for creating a new certificate.
Copy the approach that you see in staging/production. We use Fastly rather than
AWS, because AWS does not permit downloading public certificates and we need
the certificate in both AWS Route53 and Fastly.

8. `infra-security-groups`
9. `infra-database-backups-bucket`
10. `infra-artefact-bucket`
11. `infra-mirror-bucket`
12. `infra-public-services`

  You will find that applying the `infra-public-services` project fails until
  you have applied the `backend` and `cache` projects.

If you are using the [GDS CLI][] you can authenticate with AWS and run a
terraform command as below. This will only work once you have applied
`infra-security` since this creates the IAM roles.

```sh
gds aws <env> -- tools/build-terraform-project.sh ...
```

[Renew a TLS certificate for GOV.UK]: https://docs.publishing.service.gov.uk/manual/request-fastly-tls-certificate.html
[GDS CLI]: https://github.com/alphagov/gds-cli

### Update the NS records (if rebuilding infra-root-dns-zones in staging or integration)

Since we do not access multiple accounts for a single terraform run, the apex NS
records for the environment specific subdomains have to be updated if the
`infra-networking` project is rebuilt and the subdomain NS resources are rewritten.

For integration these are:
- integration.publishing.service.gov.uk
- integration.govuk-internal.digital
- integration.govuk.digital

For staging these are:
- staging.publishing.service.gov.uk
- staging.govuk-internal.digital
- staging.govuk.digital

### Creating backend files for a new stack

**This is not currently required as we are only using a single "blue" stack and it's configuration is complete for the current set of projects.** It is however
required if you are creating a new environment.

Each project stores its state in an S3 bucket in AWS. These are configured using a backend file which looks like and lives in the project directory.
```
# terraform/projects/<project name>/<environment>.<stack name>.backend
bucket  = "govuk-terraform-steppingstone-<environment>"
key     = "<stack name>/<project name>.tfstate"
encrypt = true
region  = "<region>"
```

If you are adding a new environment, you'll need to create a backend file for
each project. Additionally, you'll need to create tfvars files in `govuk-aws-data`.
See that repo for more detail on what tfvars files each project requires.

## Add DNS NS records

For internal and external networking in a new environment to work, you must
also create CNAME records in the production AWS account's Route53 service.

The production AWS account route53 hosted zones must be updated:

- the production DNS entries must be updated manually for
`.<environment>.govuk-internal.digital` and `.<environment>.govuk.digital`.
- for the publishing.service.gov.uk domain, e.g. `*.<environment>.publishing.service.gov.uk`,
  one must update the records using govuk-dns-config (see below)

### Manually create environment subdomain records for .digital in production

As mentioned in [RFC 0015][] one must create new NS records for a new environment's
subdomain in the production AWS account's Route53 service.

E.g. `.<environment>.govuk-internal.digital` and `.<environment>.govuk.digital`.

[RFC 0015]: https://github.com/alphagov/govuk-aws/blob/master/docs/architecture/decisions/0015-dns-infrastructure.md

### Use govuk-dns to create environment subdomains for publishing.service.gov.uk

If you are running the signon application in the new environment
you will need to create a CNAME for `signon.<env>.publishing.service.gov.uk`
that (probably) points to `signon.<env>.govuk.digital`, the A records for
the environment are all contained in Route53 of the environment's AWS account.

This change is done using [govuk-dns][] and [govuk-dns-config][]. Here's [an
example PR](https://github.com/alphagov/govuk-dns-config/pull/568) - you
can copy the records used for other environments if you're creating a new
environment.

[govuk-dns]: https://github.com/alphagov/govuk-dns
[govuk-dns-config]: https://github.com/alphagov/govuk-dns-config


## Create hieradata for new environments

If you're creating a completely new environment, you will need to duplicate
quite a few hieradata files in govuk-puppet and govuk-secrets.

A good approach would be to find every environment-specific hieradata
directory and file and duplicate it for your new environment.

Remember to update the files with new values once you have them.

You will also need to set configuration in 'sops' and tfvars files in
govuk-aws-data. These configuration variables must be in-sync with
hieradata in govuk-secrets and govuk-puppet.

Important! Make sure that when you update sops, that you also update govuk-secrets.
For example, db creds are set in both places.

Consistency between the tfvars data and puppet hieradata can be incredibly
important. For example, the VPC subnet addresses should be the same in both
puppet and govuk-aws-data.

## Build the Puppet Master

> **Warning:** Try to keep the instance sizes consistent with production,
especially with the puppetmaster instance. You may see errors like
> `Exception in thread "main" java.lang.Error: Not enough RAM. Puppet Server requires at least 10904MB of RAM.`
if you try to use too small an instance.

> **Warning:** The puppet hostname (https://puppet) is used to communicate with
puppet. This relies on /etc/resolv.conf files on instances having a
`search <env>.govuk-internal.digital` entry and there being a DNS record in
the <env>.govuk-internal.digital private hosted zone in AWS Route53 for puppet.
If this isn't present, puppet can't run on any machines. Try `dig puppet` to debug.

> **Warning:** You may find puppet's userdata script (run when booting a machine)
times out when running (e.g. when installing secrets, running `bundle`). It
adds user ssh keys as a final step, so if it fails you won't be able to ssh in
to debug the issue. To debug it, you can look at the userdata script logs in the
AWS console. The solution is usually to fix the script and get it to install
things more efficiently.

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

If the puppetmaster is rebuilt (i.e. clients already have certificates in place) it is then required to cycle the Puppet certificates by deleting the directory /etc/puppet/ssl and run `sudo puppet agent -t` on all nodes before issuing `sudo puppet cert sign --all` on the Puppet master.  

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

If the jumpbox is built and provisioned successfully, you should be able
to SSH onto it using the GDS CLI, e.g.

```sh
gds govuk connect ssh -e <environment> jumpbox
```

## Build the deploy Jenkins

> **Warning:** Use the same instance size as in production for Jenkins, i.e.
this has been a t2.medium, but check!

> **Warning:** You may find Python dependencies are out of date, or incompatible.
The solution is to update all Python dependencies and pip in Puppet. For example
the python scripts `jenkins-jobs` and `jenkins-cli` won't run successfully until
Python dependencies are installed/upgraded. `jenkins-cli` also has a hardcoded
API token, so make sure you've updated govuk-secrets with the token it needs,
it may be that you need to the token shuffle first.

You'll first want to ensure that Jenkins has the right credentials in
the govuk-secrets hieradata.

1. Get a GitHub admin to [create a GitHub OAuth token for Jenkins](https://github.com/organizations/alphagov/settings/applications).
1. Add the github_client_id and github_client_secret to govuk-secrets.

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

For each user, Jenkins automatically generates an API token which is based upon
the machine it's installed on, which means that each token is unique to each
instance. Additionally, tokens stored on disk are encrypted so we are not able
to manage these with Puppet in the Jenkins configuration.

We use Jenkins Job Builder to manage our jobs. This tool requires a Jenkins API
user and token to be able to create jobs, and use Puppet to manage these credentials.
Therefore we need to generate a token for the API user that Puppet creates, and
add this token to our Puppet credentials.

Jenkins does not allow admins to view other users tokens, so there is a manual
step involved.

1. SSH to the Jenkins instance
1. Edit the start up options: `sudo vim /etc/default/jenkins`
1. Append the following line to the end of `JAVA_ARGS`:

   `-Djenkins.security.ApiTokenProperty.showTokenToAdmins=true`

   It will probably look something like this:

   `JAVA_ARGS="-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false -Djenkins.security.ApiTokenProperty.showTokenToAdmins=true"`

1. Save and quit, and restart the Jenkins service: `sudo service jenkins restart`
1. You should now be able to login by going to https://deploy.\<stackname\>.\<environment\>.govuk.digital
1. Find the API user you want the token from by searching in the top bar (the default is "jenkins_api_user")

    If the API user doesn't exist (puppet doesn't create it),
    you need to manually create the user by going to
    Manage Jenkins > Configure Global Security > change the radio button
    “Jenkins’ own user database”, save, log out, then sign up as
    jenkins_api_user, generate a token for that user, save that, then go
    back to Manage Jenkins > Configure Global Security, click the radio
    button “Github Authentication Plugin” and adding the github credentials
    through UI on the same page then saving and logging out, then signing in
    again as a github user. Then test the API token you have generated for
    the api_user by running the command within the `jenkins-cli` script manually.

1. Click configure, and then "Show API token". Save the token, and update the credentials in the [govuk-secrets repo](https://github.com/alphagov/govuk-secrets)
1. The hiera key you're looking to update is called: `govuk::node::s_jenkins::jenkins_api_token`
1. As the Deploy_Puppet job won't yet exist, you will be unable to deploy Puppet at this point. Manually edit `/etc/jenkins_jobs/jenkins_jobs.ini` with the new token, and run the update job by running `sudo jenkins-jobs update /etc/jenkins_jobs/jobs/`.

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
`app-elasticsearch6`
`app-mongo`
`app-mysql`
`app-postgresql`
`app-publishing-amazonmq`
`app-rate-limit-redis`
`app-router-backend`
`app-shared-documentdb`
`app-transition-postgresql`

Be aware that both RDS and Elasticache can take some time to deploy.

## Deploy the core applications

The following applications are core to the GOV.UK stack:

`app-cache`
`app-content-store`
`app-draft-cache`
`app-draft-content-store`
`app-publishing-api`
`app-router-backend`
`app-search`
`app-signon`

Before deploying apps via Jenkins deploy jobs, you'll first need to go to
Jenkins (`https://deploy.<stack>.<env>.govuk.digital/credentials/store/system/domain/_/`)
and manually add a `govukci` credential for DockerHub, so that Jenkins can push
new images to Docker Hub.

You may find that deploying apps fails due to various issues such as migrations
failing. Apps are not frequently tested in new environments, so may behave
strangely when coming up for the first time.

For example, expected environments are often hard coded into dependencies
such as govuk-app-deployment and govuk_admin_template. You'll need to add your
new environment name in there to avoid unexpected failures.

**Note:** To get router to deploy, you'll need to run `infra-artefact-bucket`.

### Enable OAuth authentication between apps

Signon enables applications to authenticate with each other. [Refer to signons
docs](https://github.com/alphagov/signon/blob/master/docs/usage.md#setup-rake-tasks)
to find out how to create users, applications, and bearer tokens if you are not
using the data sync to populate the signon db.

Once you have generated the signon credentials, add them to govuk-secrets,
and deploy puppet.

For example, content store currently requires the following hieradata in
govuk-secrets:

```
govuk::apps::content_store::oauth_id
govuk::apps::content_store::oauth_secret
govuk::apps::content_store::publishing_api_bearer_token
govuk::apps::content_store::draft_router_api_bearer_token
govuk::apps::content_store::router_api_bearer_token
```

## Deploy the rest of the projects

Once the core of GOV.UK has been deployed, you should be able to deploy the rest of the stack. Be
aware that due to some dependencies between apps they may not come up cleanly and may need to be
redeployed.

Additionally, you may find that some apps depend on their equivalent draft machine
to be up and running in order for the deploy pipeline to function. For example,
to deploy content-store via Jenkins, you first need to apply the terraform
project `app-draft-content-store`.

Finally, unless you do a data sync, or use db backups, you'll find that www.gov.uk
returns a 404 to every request. This is expected, since you will need to publish
content items.
