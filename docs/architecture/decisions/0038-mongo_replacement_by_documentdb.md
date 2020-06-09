# 38. Mongo Replacement by DocumentDB

Date: 2019-10-17

## Status

Approved

## Context

GOV.UK uses MongoDB as the backing database for a number of apps. In a generic
GOV.UK environment, there are 5 MongoDB clusters: one for Licensify (a legacy
service), one for performance monitoring, one for router and another per cloud
provider (i.e. AWS and Carrenza) for all other apps (e.g. assets, imminence,
maslow, content, publisher and short url manager).

One architectural strategy principle of TechOps is to make use as much as
possible AWS managed services in order to reduce the burden on GOV.UK teams to
manage Commercial off-the-shelf (COTS) functionality/services.

## Decision

The approaches taken for migrating from MongoDB to AWS DocumentDB are:

1. new apps that are being migrated from legacy cloud providers (e.g UKCloud and
   Carrenza) to AWS and use MongoDB should be evaluated for compatibility with
   AWS DocumentDB during the migration phase. Based on this evaluation, a
   decision should be made based on cost benefit whether a particular migrating
   app should be using DocumentDB or MongoDB.

2. there are some apps (e.g. content store and imminence) that have already been
   migrated to AWS and uses the MongoDB cluster there. These apps should be
   evaluated for compatibility with AWS DocumentDB and prioritised accordingly
   for migration to AWS DocumentDB.

## Consequences

While migrating to AWS DocumentDB, there are a few facts to be aware of:

1. AWS DocumentDB has been developed to be [compatible](https://docs.aws.amazon.com/documentdb/latest/developerguide/mongo-apis.html)
   with the open source MongoDB API 3.6. The version of MongoDB that GOV.UK uses
   is 3.2.7 for Licensify and 2.4.9 for the other apps.

   In addition, we are aware that AWS DocumentDB does not support the null
   character in any string and you should amend any records that contain
   these before migrating to AWS DocumentDB.

2. AWS DocumentDB requires authentication using username and password. This is
   in contrast with the current GOV.UK MongoDB clusters that are protected based
   on IP only. Hence, the relevant GOV.UK apps should have the ability to
   retrieve authentication credentials from GOV.UK credential management system
   and authenticate with AWS DocumentDB. This may require some code changes in
   some instances.

3. AWS DocumentDB supports multiple users but with the important caveat that
   all users are effectively super users and have access to all databases of
   their DocumentDB cluster. More information is available
   [here](https://docs.aws.amazon.com/documentdb/latest/developerguide/security.managing-users.html).

4. If TLS is activated on the AWS DocumentDB cluster, the connecting GOV.UK app
   will have to include the AWS DocumentDB certificates in its TLS certificates
   store. It should be noted that these certificates are AWS ones and cannot be
   customised by the user. This means that no custom GOV.UK CNAME can be
   generated for the AWS DocumentDB cluster and GOV.UK apps will have to use the
   Fully Qualified Domain Name (FQDN) that AWS has allocated to the DocumentDB
   cluster. If the DocumentDB has to be re-created, a new FQDN will be provided
   by AWS and will have to be propagated in GOV.UK infrastructure.

5. If a database is migrated to AWS DocumentDB, the relevant database backup
   mechanism needs to be updated. The GOV.UK `govuk_env_sync` tool has been
   updated to support DocumentDB as a database type. It should be noted that in
   addition to configuring `govuk_env_sync` in the usual manner, the
   authentication credentials to access the DocumentDB will have to be provided.
