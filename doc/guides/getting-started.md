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

There are two ways to deploy code, and either are fine to use.

Both are wrappers for Terraform which make use of our specific [project](https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0010-terraform-directory-structure.md) and [data](https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0017-terraform-data-structure.md) structure.

Please see the [documentation about deployment](deploying-terraform.md).

### build-terraform-project.sh

Default tool written in Bash.

It takes several command line arguments which can also be set using environment
variables.

Run `tools/build-terraform-project.sh -h` for details.

**this must be run from the root of this repo.**

### Terragov

Alternative tool written in Ruby.

Install: `gem install terragov`

If you are working on the same environment, stack or project for a long period,
commands can be simplified with a config file:

```
$ cat ~/.terragov.yml
---
default:
  environment: 'integration'
  stack: 'blue'
  repo_dir: '~/govuk/govuk-aws'
  data_dir: '~/govuk/govuk-aws-data/data'

infra-security-groups:
  stack: 'govuk'
```

Add the config file location to your shell:

Bash:
`echo "export TERRAGOV_CONFIG_FILE=~/.terragov.yml" >> ~/.bashrc`

Zsh:
`echo "export TERRAGOV_CONFIG_FILE=~/.terragov.yml" >> ~/.zshrc`

This tool can be run from within any directory.

Further information can be found [in the Terragov repo](https://github.com/surminus/terragov).
