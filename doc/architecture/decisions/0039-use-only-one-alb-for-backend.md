# 39. Use only one ALB for backend

Date: 2020-04-17

## Status

Accepted

## Context

This is the initial infrastructure that was planned for backend in AWS:

 +-----+                  +-----+
 |     |                  |     |
 | ALB |                  | ALB |
 | EXT +---+       +------+ INT |
 |     |   |       |      |     |
 +-----+   |       |      +-----+
           |       |
           v       v
+----------+-------+---------------+
|                                  |
| +--------+ +--------+ +--------+ |
| |        | |        | |        | |
| | SERVER | | SERVER | | SERVER | |
| |        | |        | |        | |
| +--------+ +--------+ +--------+ |
|                                  |
|  ASG                             |
|                                  |
+----------------------------------+

Three backend servers are part of an autoscaling group.
External traffic is coming through an ALB with a public IP.
Internal traffic is coming through an ALB with a private IP.
Each ALB has a list of target groups, one for each app, this allows the ALB to do health check at the app level.
All the target groups are associated with the ASG so that the target groups are automatically updated when we upscal/downscale or when a server is recycled.
Since we have more than 25 apps running on backend, the total number of target groups is more than 50 (we need 2 target groups per app, one for external and the other for internal)
AWS has a hard limit of 50 target groups per ASG.


## Decision

In order to get the total number of target groups under the limit of 50, we use only one ALB.

     +--------+
     |        |
     |  ALB   |
     | EXT/INT+---+
     |        |   |
     +--------+   |
                  |
                  v
+-----------------+----------------+
|                                  |
| +--------+ +--------+ +--------+ |
| |        | |        | |        | |
| | SERVER | | SERVER | | SERVER | |
| |        | |        | |        | |
| +--------+ +--------+ +--------+ |
|                                  |
|  ASG                             |
|                                  |
+----------------------------------+

This way we only need one target group per app to be associated to the ASG, which is under the limit of 50.


## Consequences

Internal traffic will now go outside of our VPC and go through the public IP of the ALB.
While that doesn't seem ideal, in practice there should be very little concern about this setup. Traffic should not leave the AWS network and is encrypted anyway.
