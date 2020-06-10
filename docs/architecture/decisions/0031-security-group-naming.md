# 31. Security Groups in Terraform

Date: 2017-11-28

## Status

Pending

## Context

Each terraform `aws_security_group_rule` requires a name. We need these to be both unique and useful so we
need to define a basic standard for them. We have a few basic patterns shown below:

```
Rule 1:
`allow_${source-name}_from_${dest-name}_$service_(ingress|egress)`

Example:
allow_bastion-elb_from_bastion-asg_ssh_ingress

Rule 2:
allow_${source-name}_(ingress|egress)_${dest-name}_$service

Example:
allow_bastion-elb_ingress_bastion-asg_ssh

Rule 3:
${source-name}_(ingress|egress)_${dest-name}_$service

Example:
monitoring2_ingress_webapps-elb_nrpe

Rule 4:
${source-name}_$service_(ingress|egress)_${dest-name}

Example:
monitoring2_nrpe_ingress_webapps-elb
```

There are a few other guidelines that will be the same between rules. `$service` will be a named service,
not just a port number. If the rule uses a protocol other than TCP we will add an additional `_$proto` to the end.

## Decision

We will use "rule 3" and change all the existing rule names to comply with it.

## Consequences

All our `aws_security_group_rule` terraform resources will match a consistent naming scheme.

If we've missed a use case we will have to redo this document and change the actual names again.
