# 18. Use RDS instead of provisioned EC2 databases

Date: 2017-08-01

## Status

Accepted

## Context

We use both MySQL and PostgreSQL in our stack for different applications. These
have been traditionally provisioned as VM instances and managed with Puppet.

Puppet manages every aspect of these instances:

 - Server configuration and tuning
 - CRUD actions on databases
 - Users and permissions
 - Replication/clustering
 - Backups

AWS offers the [Relational Database Service](https://aws.amazon.com/rds/) (RDS).

Using RDS would remove the following away from being managed by Puppet:

 - Server configuration and tuning
 - Replication/clustering
 - Backups

Terraform code would be required to ensure the above is configured correctly.

## Decision

We are going to use RDS to remove a significant portion of our Puppet code that
traditionally managed both PostgreSQL and MySQL.

To manage databases, users, data loading and long-term offsite backups, we will
create a new type of node class named "db_admin". This will be able to connect
and configure each RDS instance in a stack.

## Consequences

New code will need to be written to create the "db_admin" class, and some
rewriting of our logic will be required in Puppet.

We will need to understand and create relevant monitoring for RDS instances.

We will eventually be able to remove the large amount of Puppet code related
to the management and provisioning of both MySQL and PostgreSQL servers.
