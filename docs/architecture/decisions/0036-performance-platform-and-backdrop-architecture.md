# 36. Performance-Platform-And-BackDrop-Architecture

Date: 2019-01-23

## Status

Proposed

## Context

We currently have dedicated performance-platform environments for both the staging and production GovUK environments. The performance-platform is made up of the following services:

For GovUK Staging, the entire performance-platform resides in the GovUK PaaS:
  - Stagecraft
  - Spotlight
  - PP-Admin
  - Backdrop database
  - Backdrop Worker, Read & Write API

For GovUK Production:
  - Stagecraft  (GovUK PaaS)
  - Spotlight  (GovUK PaaS)
  - PP-Admin  (GovUK PaaS)
  - Backdrop database  (Carrenza performance-mongo cluster)
  - Backdrop Worker, Read & Write API  (Carrenza api-1 & api-2 nodes)

The info-frontend is the only service within the GovUK environments that makes connections to the read and write backdrop APIs. Specifically the endpoint www.gov.uk/performance/data directs traffic to backdrop. It accesses those APIs through the following environment corresponding names:
  - www.performance.service.gov.uk
  - www.staging.performance.service.gov.uk
Those names will resolve to fastly, which will serve what is required if cached, if it is not cached it will update its cache by hitting the appropriate backdrop endpoints, which for staging would be in the PaaS and for production reside on the api-1 and api-2 instances.

![Performance Platform](./0036-performance-platform-and-backdrop-architecture-img01.png?raw=true "Performance Platform")
 
## Decision

We have outlined the current architecture of the performance environment here.

This ADR outlines the current architecture of the performance platform for both the GovUK Staging and Production environments. It must be noted that the context of the ADR has been written during a migration period where GovUK services are been moved from Carrenza to AWS. It is mainly a record for people to see how the performance platform fits together with the GovUK environments.

## Consequences

Currently staging and production performance-platforms are not similar which is not ideal. But the purpose of writting up this ADR was for information gathering as part of the GovUK AWS migration.
It can also be confirmed that info-frontend service in AWS, which is due to be migrated is able to access the performancer-platform using fastly.
