## Module: aws::node\_group

This module creates an instance in a autoscaling group that expands  
in the subnets specified by the variable instance\_subnet\_ids. The instance  
AMI is Ubuntu, you can specify the version with the instance\_ami\_filter\_name  
variable. The machine type can also be configured with a variable.

When the variable create\_service\_dns\_name is set to true, this module  
will create a DNS name service\_dns\_name in the zone\_id specified pointing  
to the ELB record.

Additionally, this module will create an IAM role that we can attach  
policies to in other modules.

You can specify a list of Classic ELB ids to attach to the Autoscaling Group  
with the `instance_elb_ids` variable, or alternatively a list of Target Group ARNs  
to use with Application Load Balancers with the `instance_target_group_arns` variable.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| asg\_desired\_capacity | The autoscaling groups desired capacity | `string` | `"1"` | no |
| asg\_health\_check\_grace\_period | The time to wait after creation before checking the status of the instance | `string` | `"60"` | no |
| asg\_max\_size | The autoscaling groups max\_size | `string` | `"1"` | no |
| asg\_min\_size | The autoscaling groups max\_size | `string` | `"1"` | no |
| asg\_notification\_topic\_arn | The Topic ARN for Autoscaling Group notifications to be sent to | `string` | `""` | no |
| asg\_notification\_types | A list of Notification Types that trigger Autoscaling Group notifications. Acceptable values are documented in https://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_NotificationConfiguration.html | `list` | <pre>[<br>  "autoscaling:EC2_INSTANCE_LAUNCH",<br>  "autoscaling:EC2_INSTANCE_TERMINATE",<br>  "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"<br>]</pre> | no |
| create\_asg\_notifications | Enable Autoscaling Group notifications | `string` | `true` | no |
| create\_instance\_key | Whether to create a key pair for the instance launch configuration | `string` | `false` | no |
| default\_tags | Additional resource tags | `map` | `{}` | no |
| ebs\_device\_name | Name of the block device to mount on the instance, e.g. xvdf | `string` | `"xvdf"` | no |
| ebs\_device\_volume\_size | Size of additional ebs volume in GB | `string` | `"20"` | no |
| ebs\_encrypted | Whether or not to encrypt the ebs volume | `string` | `"false"` | no |
| instance\_additional\_user\_data | Append additional user-data script | `string` | `""` | no |
| instance\_ami\_filter\_name | Name to use to find AMI images for the instance | `string` | `"ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"` | no |
| instance\_default\_policy | Name of the JSON file containing the default IAM role policy for the instance | `string` | `"default_policy.json"` | no |
| instance\_elb\_ids | A list of the ELB IDs to attach this ASG to | `list` | `[]` | no |
| instance\_elb\_ids\_length | Length of instance\_elb\_ids | `string` | `0` | no |
| instance\_key\_name | Name of the instance key | `string` | `"govuk-infra"` | no |
| instance\_public\_key | The jumpbox default public key material | `string` | `""` | no |
| instance\_security\_group\_ids | List of security group ids to attach to the ASG | `list` | n/a | yes |
| instance\_subnet\_ids | List of subnet ids where the instance can be deployed | `list` | n/a | yes |
| instance\_target\_group\_arns | The ARN of the target group with which to register targets. | `list` | `[]` | no |
| instance\_target\_group\_arns\_length | Length of instance\_target\_group\_arns | `string` | `0` | no |
| instance\_type | Instance type | `string` | `"t2.micro"` | no |
| instance\_user\_data | User\_data provisioning script (default user\_data.sh in module directory) | `string` | `"user_data.sh"` | no |
| lc\_create\_ebs\_volume | Creates a launch configuration which will add an additional ebs volume to the instance if this value is set to 1 | `string` | `"0"` | no |
| name | Jumpbox resources name. Only alphanumeric characters and hyphens allowed | `string` | n/a | yes |
| root\_block\_device\_volume\_size | The size of the instance root volume in gigabytes | `string` | `"20"` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The name of the node auto scaling group. |
| instance\_iam\_role\_name | Node IAM Role Name. Use with aws\_iam\_role\_policy\_attachment to attach specific policies to the node role |

