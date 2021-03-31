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
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.node_autoscaling_group_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.node_autoscaling_group_attachment_classic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.node_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_notification.node_autoscaling_group_notifications](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification) | resource |
| [aws_iam_instance_profile.node_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.node_iam_policy_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.node_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.node_iam_role_policy_attachment_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.node_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_launch_configuration.node_launch_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_launch_configuration.node_with_ebs_launch_configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [null_resource.node_autoscaling_group_tags](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_ami.node_ami_ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | The autoscaling groups desired capacity | `string` | `"1"` | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | The time to wait after creation before checking the status of the instance | `string` | `"60"` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | The autoscaling groups max\_size | `string` | `"1"` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | The autoscaling groups max\_size | `string` | `"1"` | no |
| <a name="input_asg_notification_topic_arn"></a> [asg\_notification\_topic\_arn](#input\_asg\_notification\_topic\_arn) | The Topic ARN for Autoscaling Group notifications to be sent to | `string` | `""` | no |
| <a name="input_asg_notification_types"></a> [asg\_notification\_types](#input\_asg\_notification\_types) | A list of Notification Types that trigger Autoscaling Group notifications. Acceptable values are documented in https://docs.aws.amazon.com/AutoScaling/latest/APIReference/API_NotificationConfiguration.html | `list` | <pre>[<br>  "autoscaling:EC2_INSTANCE_LAUNCH",<br>  "autoscaling:EC2_INSTANCE_TERMINATE",<br>  "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"<br>]</pre> | no |
| <a name="input_create_asg_notifications"></a> [create\_asg\_notifications](#input\_create\_asg\_notifications) | Enable Autoscaling Group notifications | `string` | `true` | no |
| <a name="input_create_instance_key"></a> [create\_instance\_key](#input\_create\_instance\_key) | Whether to create a key pair for the instance launch configuration | `string` | `false` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Additional resource tags | `map` | `{}` | no |
| <a name="input_ebs_device_name"></a> [ebs\_device\_name](#input\_ebs\_device\_name) | Name of the block device to mount on the instance, e.g. xvdf | `string` | `"xvdf"` | no |
| <a name="input_ebs_device_volume_size"></a> [ebs\_device\_volume\_size](#input\_ebs\_device\_volume\_size) | Size of additional ebs volume in GB | `string` | `"20"` | no |
| <a name="input_ebs_encrypted"></a> [ebs\_encrypted](#input\_ebs\_encrypted) | Whether or not to encrypt the ebs volume | `string` | `"false"` | no |
| <a name="input_instance_additional_user_data"></a> [instance\_additional\_user\_data](#input\_instance\_additional\_user\_data) | Append additional user-data script | `string` | `""` | no |
| <a name="input_instance_ami_filter_name"></a> [instance\_ami\_filter\_name](#input\_instance\_ami\_filter\_name) | Name to use to find AMI images for the instance | `string` | `"ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"` | no |
| <a name="input_instance_default_policy"></a> [instance\_default\_policy](#input\_instance\_default\_policy) | Name of the JSON file containing the default IAM role policy for the instance | `string` | `"default_policy.json"` | no |
| <a name="input_instance_elb_ids"></a> [instance\_elb\_ids](#input\_instance\_elb\_ids) | A list of the ELB IDs to attach this ASG to | `list` | `[]` | no |
| <a name="input_instance_elb_ids_length"></a> [instance\_elb\_ids\_length](#input\_instance\_elb\_ids\_length) | Length of instance\_elb\_ids | `string` | `0` | no |
| <a name="input_instance_key_name"></a> [instance\_key\_name](#input\_instance\_key\_name) | Name of the instance key | `string` | `"govuk-infra"` | no |
| <a name="input_instance_public_key"></a> [instance\_public\_key](#input\_instance\_public\_key) | The jumpbox default public key material | `string` | `""` | no |
| <a name="input_instance_security_group_ids"></a> [instance\_security\_group\_ids](#input\_instance\_security\_group\_ids) | List of security group ids to attach to the ASG | `list` | n/a | yes |
| <a name="input_instance_subnet_ids"></a> [instance\_subnet\_ids](#input\_instance\_subnet\_ids) | List of subnet ids where the instance can be deployed | `list` | n/a | yes |
| <a name="input_instance_target_group_arns"></a> [instance\_target\_group\_arns](#input\_instance\_target\_group\_arns) | The ARN of the target group with which to register targets. | `list` | `[]` | no |
| <a name="input_instance_target_group_arns_length"></a> [instance\_target\_group\_arns\_length](#input\_instance\_target\_group\_arns\_length) | Length of instance\_target\_group\_arns | `string` | `0` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type | `string` | `"t2.micro"` | no |
| <a name="input_instance_user_data"></a> [instance\_user\_data](#input\_instance\_user\_data) | User\_data provisioning script (default user\_data.sh in module directory) | `string` | `"user_data.sh"` | no |
| <a name="input_lc_create_ebs_volume"></a> [lc\_create\_ebs\_volume](#input\_lc\_create\_ebs\_volume) | Creates a launch configuration which will add an additional ebs volume to the instance if this value is set to 1 | `string` | `"0"` | no |
| <a name="input_name"></a> [name](#input\_name) | Jumpbox resources name. Only alphanumeric characters and hyphens allowed | `string` | n/a | yes |
| <a name="input_root_block_device_volume_size"></a> [root\_block\_device\_volume\_size](#input\_root\_block\_device\_volume\_size) | The size of the instance root volume in gigabytes | `string` | `"20"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_group_name"></a> [autoscaling\_group\_name](#output\_autoscaling\_group\_name) | The name of the node auto scaling group. |
| <a name="output_instance_iam_role_name"></a> [instance\_iam\_role\_name](#output\_instance\_iam\_role\_name) | Node IAM Role Name. Use with aws\_iam\_role\_policy\_attachment to attach specific policies to the node role |
