## Fix Elasticsearch snapshot object ownership

The Elasticsearch data sync from production to staging (and staging to
integration) works by having the production Elasticsearch take a
snapshot and store it in a bucket, and then having the staging
Elasticsearch restore that snapshot.  This means that the production
and staging accounts have access to the bucket, which is owned by the
production account.

The *staging* Elasticsearch likes to put a file into the bucket called
`incompatible-snapshots`, which then prevents *production* from taking
new snapshots, as it can't read the file.

Ideally we would change the AWS managed Elasticsearch to use a
read-only role; but that Elasticsearch doesn't like a snapshot
repository it can't write to.

This lambda function is notified by S3 when an object is written to
the bucket, and fixes the permissions.
