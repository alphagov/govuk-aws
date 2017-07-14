# 14. Launch Config change propagation process

Date: 2017-07-14

## Status

Accepted

## Context

An Auto-scaling Group's (ASG) instances are all created using a Launch Configuration (LC). The LC manages the image used to build instances as well as any user-data, security groups or tags.

When the LC of an ASG is changed those changes are only propagated to new instances. New instances are only created if the ASG scales-out or if an existing instance goes away (e.g. is terminated or fails).

Historically many of our instances are long lived (e.g. production puppetmaster, at time of writing, has an uptime of 79 days). This means that changes to the LC may take a long time to propagate fully. In the case of important changes to the LC (e.g. new security groups or tags that add Puppet facts) this is undesirable.

There are several possible ways to force propagation of LC changes within the existing Terraform code were considered ([issue](https://github.com/hashicorp/terraform/issues/1552)):

* Manual termination of instances
* Embedding CloudFormation in Terraform to more tightly manage instance life-cycle ([e.g. see this comment](https://github.com/hashicorp/terraform/issues/1552#issuecomment-191847434))
* Creating a new ASG for every LC ([e.g. see this post](https://groups.google.com/forum/#!msg/terraform-tool/7Gdhv1OAc80/iNQ93riiLwAJ))


## Decision

In order to propagate LC changes we will manually terminate effected instances.

## Consequences

* Dev time that involves changing the LC may slow slightly or require further automation to enable rapid work on instances
* Our Terraform will remain simple
* ASGs will persist between LCs
* LC deploys will need to manage instance life-cycles 

