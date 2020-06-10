# Getting Started

Use this guide to help you get started when working on this repository.

## Prerequisites

### Terraform

Use `tfenv` to install the version of Terraform specified in the `.terraform-version` file:

```sh
brew install tfenv
tfenv install
```

### Data

We split data out from the Terraform manifests. Please see [this ADR for context](https://github.com/alphagov/govuk-aws/blob/master/docs/architecture/decisions/0017-terraform-data-structure.md).

Data used to configure terraform is stored in the [govuk-aws-data](https://github.com/alphagov/govuk-aws-data) repo. Follow the instructions in that repository for up-to-date information on how to work with data.

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
