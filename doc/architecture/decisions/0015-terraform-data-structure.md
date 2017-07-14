# 15. Terraform Data Structure

Date: 2017-07-14

## Status

Accepted

Amends [10. Terraform directory structure](0010-terraform-directory-structure.md)

## Context

Our various Terraform projects share a significant amount of similar configuration (e.g. remote state buckets, stackname).

Under [ADR 10](0010-terraform-directory-structure.md) this is repeated for every project and every stack.

## Decision

The data portion of ADR 0010 will now be:

```
├── data
│   ├── common
│   │   └── <aws environment>
│   │       ├── common.tfvars
│   │       └── <stackname>.tfvars
│   ├── <project>
│   │   └── <aws environment 1>
│   │       ├── common.tfvars
│   │       ├── <stackname>.tfvars
│   │       └── <stackname>_secrets.json
```

Where:

* `<aws environment>` is the AWS account being deployed to (e.g. 'integration', 'staging')
* `<stackname>` is the specific collection of projects (e.g. 'integration-green', 'foo-test')
* `<project>` is the project describing the resources to build (e.g. 'puppetmaster', 'frontend')

The tfvar files will be applied in this order:

* `common/<aws environment>/common.tfvars`
* `common/<aws environment>/<stackname>.tfvars`
* `common/<project>/common.tfvars`
* `common/<project>/<stackname>.tfvars`
* `common/<project>/<stackname>_secrets.tfvars`

## Consequences

* Values only need to be defined in one place
