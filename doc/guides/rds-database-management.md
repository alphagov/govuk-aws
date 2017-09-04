# RDS Database Management

We're using [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/) to manage shared MySQL and PostgreSQL backend databases.

Please see the [related ADR](https://github.com/alphagov/govuk-aws/blob/master/doc/architecture/decisions/0018-use-rds-instead-of-provisioned-ec2-databases.md) for context on this decision.

There are two exceptions to this:

  - PuppetDB is using a local PostgreSQL instance
  - Mapit uses a local PostgreSQL on each instance

## Administering RDS databases

Administer RDS databases using the `db_admin` machine class.

This machine class has full access to RDS, and has both PostgreSQL and MySQL clients installed.

It also is responsible for running the Puppet code that creates databases and users.

### MySQL

Connect to the MySQL database:

`sudo -i mysql`

All commands such as `mysqldump` work as normal.

### PostgreSQL

Connect to the PostgreSQL database:

`sudo -i psql`
