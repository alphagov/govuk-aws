## Module: aws::node_group

This module creates an instance in a autoscaling group that expands
in the subnets specified by the variable instance_subnet_ids. An ELB
is also provisioned to access the instance. The instance AMI is Ubuntu,
you can specify the version with the instance_ami_filter_name variable.
The machine type can also be configured with a variable.

When the variable create_service_dns_name is set to true, this module
will create a DNS name service_dns_name in the zone_id specified pointing
to the ELB record.

Additionally, this module will create an IAM role that we can attach
policies to in other modules.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| asg_desired_capacity | The autoscaling groups desired capacity | string | `1` | no |
| asg_max_size | The autoscaling groups max_size | string | `1` | no |
| asg_min_size | The autoscaling groups max_size | string | `1` | no |
| create_instance_key | Whether to create a key pair for the instance launch configuration | string | `false` | no |
| default_tags | Additional resource tags | map | `<map>` | no |
| instance_additional_user_data | Append additional user-data script | string | `` | no |
| instance_ami_filter_name | Name to use to find AMI images for the instance | string | `ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*` | no |
| instance_default_policy | Name of the JSON file containing the default IAM role policy for the instance | string | `default_policy.json` | no |
| instance_elb_ids | A list of the ELB IDs to attach this ASG to | list | - | yes |
| instance_key_name | Name of the instance key | string | - | yes |
| instance_public_key | The jumpbox default public key material | string | `` | no |
| instance_security_group_ids | List of security group ids to attach to the ASG | list | - | yes |
| instance_subnet_ids | List of subnet ids where the instance can be deployed | list | - | yes |
| instance_type | Instance type | string | `t2.micro` | no |
| instance_user_data | User_data provisioning script (default user_data.sh in module directory) | string | `user_data.sh` | no |
| name | Jumpbox resources name. Only alphanumeric characters and hyphens allowed | string | - | yes |
| root_block_device_volume_size | The size of the instance root volume in gigabytes | string | `20` | no |
| vpc_id | The ID of the VPC in which the jumpbox is created | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling_group_name | The name of the node auto scaling group. |
| instance_iam_role_name | Node IAM Role Name. Use with aws_iam_role_policy_attachment to attach specific policies to the node role |

