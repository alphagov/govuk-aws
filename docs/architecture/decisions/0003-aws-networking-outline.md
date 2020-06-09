# 3. Networking Outline
 
Date: 2017-06-30
 
## Status
 
Partly superseded
 
## Context
 
As part of the migration to AWS we need to define our IP addressing strategy and assign ranges to different environments. We will attempt to keep the new IP layout as close as possible to the current one in order to ease migration. This is not completely possible due to Amazon AZs necessarily being on different subnets within the same VPC range. 
 
This record does not currently cover the disaster recovery environments and treats CI as an embedded part of integration.
 
## Decision
 
 * 1 VPC per environment (currently integration, staging and production)
 * 3 public subnets, spread across availability zones
 * 3 private subnets, spread across availability zones

**These IP ranges have been superseded by [ADR #0033](0033-ip-ranges.md).**

The VPCs will be assigned the following IP ranges:
 
|Environment|IP Range|
|-----------|--------|
|Integration|10.1.0.0/16|
|Staging|10.2.0.0/16|
|Production|10.3.0.0/16|
|Test|10.200.0.0/16|
 
Each AZ shall be a `/24` within the above ranges.
 
eg. Integration - AZ1: 10.1.1.0/24, AZ2: 10.1.2.0/24, AZ3: 10.1.3.0/24
 
We will be deliberately flattening the current VDC separation and placing all the hosts in a private subnet per availability zone and using security groups to maintain our current network isolation.
 
## Consequences
 
Disaster recovery environments will be addressed in a future ADR.
 
The extraction and isolation of the CI environments will be addressed in a future ADR once they have been confirmed to work in the current way - as part of integration.

