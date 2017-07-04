# GOV.UK AWS Migration

Welcome to the GOV.UK AWS Migration repo. This will contain our first attempt at a "lift and shift"
of our vcloud environment to AWS. The code here has many context specific corners cut
and is intended to provide a [Walking Skelton](http://alistair.cockburn.us/Walking+skeleton)
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
