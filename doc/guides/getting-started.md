# Getting Started

Use this guide to help you get started when working on this repository.

## Prerequisites

### Terraform

Install [Terraform](https://terraform.io) by either:

 - [Downloading the binary](https://www.terraform.io/downloads.html).
 - Using [Homebrew](https://brew.sh/)

If you use Homebrew you may consider using [chtf](https://github.com/Yleisradio/homebrew-terraforms).

### Data

We split data out from the Terraform manifests. Please see [this ADR for context](https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0017-terraform-data-structure.md).

Data used to configure terraform is stored in the [govuk-aws-data](https://github.com/alphagov/govuk-aws-data) repo. Sensitive data in that repository is encrypted and decrypted using the [SOPS editor](https://github.com/mozilla/sops).

To install this (using brew):

`brew install sops`

Generally data should be encrypted/decrypted using [KMS](https://aws.amazon.com/kms/), to configure this:

```
export AWS_ACCESS_KEY_ID=<id>
export AWS_SECRET_ACCESS_KEY=<key>
```

## Developing in the repo

### Pre-commit hooks

This repo uses [pre-commit](http://pre-commit.com/) for managing its pre-commit
hooks. This is available via brew:

```
brew install pre-commit
```

The pre-commit hooks are configured in the .pre-commit-config.yaml file in the
root of this repo. To make the pre-commit hooks work you first need to install
the pre-commit shim in your local .git/hooks directory:

```
pre-commit install
```

This will now run the hooks configured in .pre-commit-config.yaml when you run a
`git commit` and will pass each hook the list of files staged as part of the
commit. You can test the hooks by doing:

```
pre-commit run
```

You can also run the hooks on all files to test the status of the entire repo.
This might be useful, for example, as part of a PR builder job:

```
pre-commit run --all-files
```

The code for this, and this documentation itself, were taken from excellent work
done by the GOV.UK Verify team in GDS.

### Writing Terraform files

Please [follow the styleguide](styleguide.md) when developing in the repository.

## Deploying code

Please see the GOV.UK Developer Docs to [Deploy AWS infrastructure with
Terraform](https://docs.publishing.service.gov.uk/manual/deploying-terraform.html)
