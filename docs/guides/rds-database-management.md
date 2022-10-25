# RDS Database Management

We're using [Amazon Relational Database Service (RDS)](https://aws.amazon.com/rds/) to manage shared MySQL and PostgreSQL backend databases.

Please see the [related ADR](https://github.com/alphagov/govuk-aws/blob/master/docs/architecture/decisions/0018-use-rds-instead-of-provisioned-ec2-databases.md) for context on this decision.

PuppetDB is the one exception to this (it is using a local PostgreSQL instance)

## Administering RDS databases

Administer RDS databases using the `db_admin` machine class.

This machine class has full access to RDS, and has both PostgreSQL and MySQL clients installed.

It also is responsible for running the Puppet code that creates databases and users.

### MySQL

Connect to the MySQL database:

`sudo -i mysql`

All commands such as `mysqldump` work as normal.

### PostgreSQL

If a `db_admin` instance is managing a PostgreSQL RDS instance, then it should have a `pgpass` file provided. To view details on connections, view the file:

`sudo less /root/.pgpass`

This is in the format of:

`<hostname>:<port>:<database>:<username>:<password>`

To connect to the PostgreSQL database, you need to provide the username and hostname that is provided in the `pgpass` file:

`sudo psql -U <username> -h <hostname> postgres`

The `pgpass` file will provide authentication when connecting, so there should be no prompt for a password.
