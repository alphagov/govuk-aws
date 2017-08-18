# GOV.UK AWS Migration

Welcome to the GOV.UK AWS Migration repo. This will contain our first attempt at a "lift and shift"
of our vcloud environment to AWS. The code here has many context specific corners cut
and is intended to provide a [Walking Skeleton](http://alistair.cockburn.us/Walking+skeleton)
that will be fleshed out as we test the migration of more things.

The code here will have a number of "older" patterns as we are attempting to move over
with as little change as possible and then iterate on the new environment, not
rearchitect and rebuild while moving.

## Building a new environment

### Bootstrap Commands

The bootstrap phase requires you to have AWS account credentials. For
this repo it's recommended that you store them in `.aws/credentials`
under distinct profile names and leave `[default]` empty.

We'll do the initial terraform configuration out of bounds to avoid
making bootstrapping difficult. First we create the S3 bucket, which
must have a globally unique name, used to store the terraform state
files. Then we enable bucket versioning in case of anything going
hideously wrong.

    export AWS_PROFILE=test-admin
    export AWS_REGION=eu-west-1
    export STACK_NAME=test

    export TERRAFORM_BUCKET="uk.gov.aws-stacks-terraform-state-${AWS_REGION}-${STACK_NAME}"

    # create the bucket
    $ aws --region $AWS_REGION s3 mb "s3://${TERRAFORM_BUCKET}"
    make_bucket: s3://...bucketname.../

    # enable versioning on the bucket
    $ aws --region $AWS_REGION       \
        s3api put-bucket-versioning  \
        --bucket ${TERRAFORM_BUCKET} \
        --versioning-configuration Status=Enabled

## Architecture Decision Records

We're recording architecture decisions we make so we have a history and context
on our implementation.

Please see the [ADR documentation](doc/architecture/README.md) for further details.

## Developing in the repo

### Pre-commit hooks

This repo uses [pre-commit](http://pre-commit.com/) for managing its pre-commit
hooks. This is available via brew:

`brew install pre-commit`

The pre-commit hooks are configured in the .pre-commit-config.yaml file in the
root of this repo. To make the pre-commit hooks work you first need to install
the pre-commit shim in your local .git/hooks directory:

`pre-commit install`

This will now run the hooks configured in .pre-commit-config.yaml when you run a
`git commit` and will pass each hook the list of files staged as part of the
commit. You can test the hooks by doing:

`pre-commit run`

You can also run the hooks on all files to test the status of the entire repo.
This might be useful, for example, as part of a PR builder job:

`pre-commit run --all-files`

The code for this, and this documentation itself, were taken from excellent work
done by the GDS Verify team.


## Tools

The `tools/` directory contains a mixture of bash scripts, some are used by the pre-commit hooks and others are intended for direct use.

* `aws-copy-puppet-setup.sh` and `aws-push-puppet.sh` These are used to provision puppet on the puppetmaster, please check the [step-by-step](doc/architecture/step-by-step.md) and [environment-provisioning](doc/guides/environment-provisioning.md) guides for how to use them.
* `build-terraform-project.sh` This is a wrapper for Terraform that simplifies building projects by fetching the correct `.tfvars` files. run `build-terraform-project.sh -h` for details. **Note** this must be run from the root of this repo.
* `create-backends.sh` a simple utility for generating backend files, see `create-backends.sh -h` for more.
* `generate-remote-state-boiler-plate.sh`, outputs the standard contents of a `remote_state.tf` project file.
* `generate-user-data-boiler-plate.sh` outputs the standard contents of a `user_data_snippets.tf` project file.

