# GOV.UK Digital Step-by-Step Guide

### Guide's conventions

|                                |                                           |
| ------------------------------ | ----------------------------------------- |
| AWS environment (account)      | integration                               |
| Terraform state S3 bucket name | govuk-terraform-steppingstone-integration |
| Infrastructure stack name      | govuk                                     |
| Application stack name         | blue                                    |
| Shared VPC                     | yes                                       |
| Shared Networking              | yes                                       |
| Shared Security Groups         | no                                        |

### Steps

#### Create Terraform bucket

```
export ENVIRONMENT=integration
aws --region eu-west-1 s3 mb "s3://govuk-terraform-steppingstone-${ENVIRONMENT}"
```

#### Build VPC

```
# All of these commands are carried out in the 'govuk' infrastructure stack
# the build-terraform-project will pick up the ENVIRONMENT & STACKNAME 
# environment variables.
export DATA_DIR=~/govuk-aws-data/data
export STACKNAME=govuk
./tools/build-terraform-project.sh -c init -p infra-vpc
./tools/build-terraform-project.sh -c plan -p infra-vpc
./tools/build-terraform-project.sh -c apply -p infra-vpc
```

#### Build network

```
export STACKNAME=govuk
./tools/build-terraform-project.sh -c init -p infra-networking
./tools/build-terraform-project.sh -c plan -p infra-networking
./tools/build-terraform-project.sh -c apply -p infra-networking
```

#### Build root domain Route53 zones

```
export STACKNAME=govuk
./tools/build-terraform-project.sh -c init -p infra-root-dns-zones
./tools/build-terraform-project.sh -c plan -p infra-root-dns-zones
./tools/build-terraform-project.sh -c apply -p infra-root-dns-zones
```

#### Build application stack DNS zones

```
# Most of these commands are carried out in the 'blue' application stack
export STACKNAME=blue
./tools/build-terraform-project.sh -c init -p infra-stack-dns-zones
./tools/build-terraform-project.sh -c plan -p infra-stack-dns-zones
./tools/build-terraform-project.sh -c apply -p infra-stack-dns-zones
```

#### Build application stack security groups

```
# Note that security groups are in the 'govuk' stack
export STACKNAME=govuk
./tools/build-terraform-project.sh -c init -p infra-security-groups
./tools/build-terraform-project.sh -c plan -p infra-security-groups
./tools/build-terraform-project.sh -c apply -p infra-security-groups
```

#### Build Puppetmaster stack

```
export STACKNAME=blue
./tools/build-terraform-project.sh -c init -p app-puppetmaster
./tools/build-terraform-project.sh -c plan -p app-puppetmaster
./tools/build-terraform-project.sh -c apply -p app-puppetmaster
```

Test puppetmaster build:

1. Grab puppetmaster bootstrap DNS:

Check the Terraform outputs `puppetmaster_bootstrap_elb_dns_name`:
```
...
Outputs:

puppetmaster_bootstrap_elb_dns_name = blue-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
puppetmaster_internal_elb_dns_name = internal-blue-puppetmaster-1374185806.eu-west-1.elb.amazonaws.com
service_dns_name = puppet.blue.integration.govuk-internal.digital
```

or run `terraform output`:

```
 $ cd terraform/projects/app-puppetmaster/
 $ terraform output puppetmaster_bootstrap_elb_dns_name
blue-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
```

2. Log in the Puppetmaster and find 'Hello from Puppet' in the cloud-init output:

```
ssh -i <path-to-private-key> ubuntu@blue-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
tail -20 /var/log/cloud-init-output.log
```

#### Puppetmaster bootstrap

```
 $ cd tools/
 $ bash -x ./aws-push-puppet.sh -e ${ENVIRONMENT} \
        -g /var/tmp/.key \
        -p ~/govuk/govuk-puppet \
        -d ~/govuk/govuk-secrets \
        -t blue-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
```

SSH as ubuntu in the puppetmaster, and execute:

```
sudo ./aws-copy-puppet-setup.sh -e integration -s blue
```

#### Build Jumpbox stack

```
export STACKNAME=blue
 $ ./tools/build-terraform-project.sh -c init -p app-jumpbox
 $ ./tools/build-terraform-project.sh -c plan -p app-jumpbox
 $ ./tools/build-terraform-project.sh -c apply -p app-jumpbox
```

#### Build monitoring

```
export STACKNAME=blue
 $ ./tools/build-terraform-project.sh -c init -p app-monitoring
 $ ./tools/build-terraform-project.sh -c plan -p app-monitoring
 $ ./tools/build-terraform-project.sh -c apply -p app-monitoring
```

#### Build deploy

```
export STACKNAME=blue
 $ ./tools/build-terraform-project.sh -c init -p app-deploy
 $ ./tools/build-terraform-project.sh -c plan -p app-deploy
 $ ./tools/build-terraform-project.sh -c apply -p app-deploy
```


