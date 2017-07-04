# 9. Environment bootstrapping process

Date: 2017-07-04

## Status

Pending

## Context

We need a process to bootstrap a new Amazon environment. This should be both heavily automated
and include set places where the operator can evaluate the status of the provisioning.

This bootstrapping process assumes the following:

 * The required repositories are available
 * An Amazon Web Services admin account is available
 * Backups of our data can be retrieved (for the restore process)

## Decision

The chosen process has a few, early bootstrap steps, that differ from normal operations. These
aim to quickly provide the usual level of self-service to allow teams to independently
restore services without a dependency on a central operations team. An early draft of
this process, which will be updated as changes are required, will be:

 1. Clone all the relevant repositories
 1. Build the S3 bucket for Terraform state
 1. Provision the new DNS zones for this environment
 1. Build the Puppet master
 1. Deploy the puppet code and secrets
 1. Build the deploy Jenkins
 * Rebuild everything else in the usual deployment ways

This document will be written so that one of the non-infrastructure members of the team
will be able to provision a complete environment within our allowed recovery time.

## Consequences

Having a well defined, documented, bootstrap process will allow us to test our
business continuity plans, build special environments for things like performance testing
and prevent drift between our version controlled and deployed infrastructure.

Providing the ability for non-technical specialists to build an environment will help
to reassure our management team and auditors that our BCP/DR plans are both actionable
and current.
