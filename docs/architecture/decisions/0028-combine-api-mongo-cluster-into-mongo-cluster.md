# 28. Combine api-mongo cluster into mongo cluster

Date: 2017-09-14

## Status

Accepted

## Context

Traditionally we had 4 mongo clusters:

  - api-mongo
  - mongo
  - performance-mongo
  - router-backend

Each cluster is a set of 3 instances, and the way we have built it in AWS is with one
machine in one AZ, in an ASG with it's own ELB. This was due to the way that mongo
relies on hostnames to create and join a cluster.

Performance Platform is officially out of scope as it is moving to the Government PaaS.

The only application that uses the api-mongo cluster is Content Store.

The router-backend cluster is used by Router. This should remain independent due to the
critical nature of this application.

All other applications use the mongo cluster.

## Decision

We are going to remove the api-mongo cluster, and update Content Store so it reads from
the application mongo cluster.

## Consequences

There is a chance that the main application mongo cluster becomes a point of failure
across the entire stack when several applications depend on it. Content Store is critical
for many frontend applications, and so there will be increased load on that cluster.

Removing the api-mongo cluster will simplify our architecture, and save money.
