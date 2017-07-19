# GOV.UK Digital Step-by-Step Guide

### Guide's conventions

|                                |                                           |
| ------------------------------ | ----------------------------------------- |
| AWS environment (account)      | integration                               |
| Terraform state S3 bucket name | govuk-terraform-steppingstone-integration |
| Infrastructure stack name      | govuk                                     |
| Application stack name         | delana                                    |
| Shared VPC                     | yes                                       |
| Shared Networking              | yes                                       |
| Shared Security Groups         | no                                        |

### Steps

#### Create Terraform bucket

```
aws --region eu-west-1 s3 mb "s3://govuk-terraform-steppingstone-integration"
```

#### Build VPC

```
./tools/build-terraform-project.sh init integration govuk infra-vpc
./tools/build-terraform-project.sh plan integration govuk infra-vpc
./tools/build-terraform-project.sh apply integration govuk infra-vpc
```

#### Build network

```
./tools/build-terraform-project.sh init integration govuk infra-networking
./tools/build-terraform-project.sh plan integration govuk infra-networking
./tools/build-terraform-project.sh apply integration govuk infra-networking
```

#### Build root domain Route53 zones

```
./tools/build-terraform-project.sh init integration govuk infra-root-dns-zones
./tools/build-terraform-project.sh plan integration govuk infra-root-dns-zones
./tools/build-terraform-project.sh apply integration govuk infra-root-dns-zones
```

#### Build application stack DNS zones

```
./tools/build-terraform-project.sh init integration delana infra-stack-dns-zones
./tools/build-terraform-project.sh plan integration delana infra-stack-dns-zones
./tools/build-terraform-project.sh apply integration delana infra-stack-dns-zones
```

#### Build application stack security groups

```
./tools/build-terraform-project.sh init integration delana infra-security-groups
./tools/build-terraform-project.sh plan integration delana infra-security-groups
./tools/build-terraform-project.sh apply integration delana infra-security-groups
```

#### Build Puppetmaster stack

```
./tools/build-terraform-project.sh init integration delana app-puppetmaster
./tools/build-terraform-project.sh plan integration delana app-puppetmaster
./tools/build-terraform-project.sh apply integration delana app-puppetmaster
```

Test puppetmaster build:

1. Grab puppetmaster bootstrap DNS:

Check the Terraform outputs `puppetmaster_bootstrap_elb_dns_name`:
```
...
Outputs:

puppetmaster_bootstrap_elb_dns_name = delana-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
puppetmaster_internal_elb_dns_name = internal-delana-puppetmaster-1374185806.eu-west-1.elb.amazonaws.com
service_dns_name = puppet.delana.integration.govuk-internal.digital
```

or run `terraform output`:

```
 $ cd terraform/projects/app-puppetmaster/
 $ terraform output puppetmaster_bootstrap_elb_dns_name
delana-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
```

2. Log in the Puppetmaster and find 'Hello from Puppet' in the cloud-init output:

```
ssh -i <path-to-private-key> ubuntu@delana-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
tail -20 /var/log/cloud-init-output.log
```

#### Puppetmaster bootstrap

```
 $ cd tools/
 $ bash -x ./aws-push-puppet.sh -e integration -g /var/tmp/.key -p ~/govuk/govuk-puppet -d ~/govuk/deployment -t delana-puppetmaster-bootstrap-1848527380.eu-west-1.elb.amazonaws.com
```

Ssh as ubuntu in the puppetmaster, and execute:

```
sudo ./aws-copy-puppet-setup.sh -e integration
```

#### Build Jumpbox stack

```
 $ ./tools/build-terraform-project.sh init integration delana app-jumpbox
 $ ./tools/build-terraform-project.sh plan integration delana app-jumpbox
 $ ./tools/build-terraform-project.sh apply integration delana app-jumpbox
```

#### Build monitoring

```
 $ ./tools/build-terraform-project.sh init integration delana app-monitoring
 $ ./tools/build-terraform-project.sh plan integration delana app-monitoring
 $ ./tools/build-terraform-project.sh apply integration delana app-monitoring
```

#### Build deploy

```
 $ ./tools/build-terraform-project.sh init integration delana app-deploy
 $ ./tools/build-terraform-project.sh plan integration delana app-deploy
 $ ./tools/build-terraform-project.sh apply integration delana app-deploy
```


