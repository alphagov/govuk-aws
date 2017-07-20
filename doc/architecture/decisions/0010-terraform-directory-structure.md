# 10. Terraform directory structure

Date: 2017-07-04

## Status

Accepted

Amended by [17. Terraform Data Structure](0017-terraform-data-structure.md)

## Context

We should have a consistent directory structure for Terraform from the beginning.

Some initial requirements:

- We want to separate code from data, so in the future we can open source the code without disclosing our implementation details,
maybe keeping the data in a private Github repository
- We want to be able to encrypt sensitive data in the repository: we want to support sensitive data encryption as part of the same
process, without having to manage secrets in a different repository, with different scripts, etc.
- We want to create Terraform modules to reuse code
- We want to separate Terraform code into different projects, each one managing an infrastructure tier or application stack. This
is especially important to separate resources between GOV.UK applications.

## Decision

The initial solution presents three directories: data, modules and projects:
- The data directory contains a subdirectory per Terraform project, to store variable values that can be customised per environment.
- The data directory also contains \_secrets files with sensitive data encrypted with 'sops'
- The modules directory contains a subdirectory per Terraform provider
- The projects directory contains the Terraform stacks/tiers
- Projects will be named such that:
    + Those to deploy common infrastructure will have a `govuk` prefix (e.g. networking, DNS zones)
    + Those to deploy applications (or groups of applications) will have an `app` prefix (e.g. frontend, puppetmaster).

```
├── data
│   ├── base
│   │   ├── common.tfvars
│   │   └── integration.tfvars
│   └── my-application
│       ├── common.tfvars
│       ├── integration.tfvars
│       └── integration_secrets.json
├── modules
│   └── aws
│       ├── route53_zone
│       │   └──  ...
│       ├── mysql_database_instance
│       │   ├── ...
│       └── network
│           └── ...
└── projects
    ├── base
    │   ├── integration.backend
    │   ├── main.tf
    │   └── variables.tf
    └── my-application
        ├── integration.backend
        ├── main.tf
        └── variables.tf
```

## Consequences

If we manage secrets as explained before, we are going to have to decrypt the secrets files at run time and
make sure we clean up unencrypted files after running the Terraform commands.

This set up requires relative paths to import modules in the Terraform stacks that depend on the directory from
where we are initialising the project. So once we feel comfortable with our modules, we'll need to consider to
put them on Github repositories so we can source them from the Terraform stacks via URL.
