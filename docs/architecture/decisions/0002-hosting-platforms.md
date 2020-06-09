# 2. Hosting Platforms
 
Date: 2017-06-30
 
## Status
 
Accepted
 
## Context
 
We need to decide upon a platform to host the future GOV.UK infrastructure. Long term, this will be primarily the GOV.UK PaaS but in the interim, we need to converge with that plan and also upgrade and modernise the current infrastructure.
 
GDS policy for hosting of GDS internal services is PaaS first and AWS for anything that can not be run on the PaaS.
 
## Decision
 
We are using Amazon Web Services as our hosting provider of choice. This conforms to the [GDS Tech Forum Hosting Guide](https://github.com/alphagov/gds-tech/pull/7).
 
We will initially be using the `eu-west-1` region, Ireland. This region has 3 availability zones and also contains the GDS PaaS which will allow easier sharing and peering.
 
## Consequences
 
We will have to migrate our infrastructure from our current hosting provider to Amazon in the near-term "as-is" and then iterate on that infrastructure in the medium term to deliver improvements to the platform. This will also make a subsequent migration of applications to the PaaS more straightforward.
