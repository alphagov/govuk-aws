# 8. Postgres on Puppetmaster

Date: 2017-07-04

## Status

Accepted

## Context

We need to decide whether to run PostgreSQL on the Puppetmaster itself or use
RDS from the off.

Currently our Puppetmaster uses a local PostgreSQL instance as its database. In moving to AWS we have the opportunity to replace this with an RDS instance.

This may remove a reasonable amount of puppet code used to configure the database and associated tasks (e.g. backups). It would also require an amount of Terraform work to provision the RDS instance and some updates to the Puppetmaster code to use that instance.

## Decision

The Puppetmaster will continue to use a local instance of PostgreSQL.

## Consequences

This should decrease the number of changes made to existing code.

This should reduce the amount of new work being done in Terraform.

We will not be able to use the Puppetmaster as a test-bed for RDS work.

We will maintain the existing puppet code.

We can continue to use existing backup & restore strategies.
