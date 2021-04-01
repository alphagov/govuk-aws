## Project: infra-public-services

This project adds global resources for app components:
  - public facing LBs and DNS entries
  - internal DNS entries

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.11.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alarms-elb-jumpbox-public"></a> [alarms-elb-jumpbox-public](#module\_alarms-elb-jumpbox-public) | ../../modules/aws/alarms/elb |  |
| <a name="module_backend_public_lb"></a> [backend\_public\_lb](#module\_backend\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_backend_public_lb_rules"></a> [backend\_public\_lb\_rules](#module\_backend\_public\_lb\_rules) | ../../modules/aws/lb_listener_rules |  |
| <a name="module_bouncer_public_lb"></a> [bouncer\_public\_lb](#module\_bouncer\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_cache_public_lb"></a> [cache\_public\_lb](#module\_cache\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_cache_public_lb_rules"></a> [cache\_public\_lb\_rules](#module\_cache\_public\_lb\_rules) | ../../modules/aws/lb_listener_rules |  |
| <a name="module_ckan_public_lb"></a> [ckan\_public\_lb](#module\_ckan\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_content-store_public_lb"></a> [content-store\_public\_lb](#module\_content-store\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_deploy_public_lb"></a> [deploy\_public\_lb](#module\_deploy\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_draft_cache_public_lb"></a> [draft\_cache\_public\_lb](#module\_draft\_cache\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_email_alert_api_public_lb"></a> [email\_alert\_api\_public\_lb](#module\_email\_alert\_api\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_feedback_public_lb"></a> [feedback\_public\_lb](#module\_feedback\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_graphite_public_lb"></a> [graphite\_public\_lb](#module\_graphite\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_licensify_backend_public_lb"></a> [licensify\_backend\_public\_lb](#module\_licensify\_backend\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_licensify_frontend_public_lb"></a> [licensify\_frontend\_public\_lb](#module\_licensify\_frontend\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_mapit_public_lb"></a> [mapit\_public\_lb](#module\_mapit\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_monitoring_public_lb"></a> [monitoring\_public\_lb](#module\_monitoring\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_prometheus_public_lb"></a> [prometheus\_public\_lb](#module\_prometheus\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_search_api_public_lb"></a> [search\_api\_public\_lb](#module\_search\_api\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_search_api_public_lb_rules"></a> [search\_api\_public\_lb\_rules](#module\_search\_api\_public\_lb\_rules) | ../../modules/aws/lb_listener_rules |  |
| <a name="module_sidekiq_monitoring_public_lb"></a> [sidekiq\_monitoring\_public\_lb](#module\_sidekiq\_monitoring\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_static_public_lb"></a> [static\_public\_lb](#module\_static\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_support_api_public_lb"></a> [support\_api\_public\_lb](#module\_support\_api\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_whitehall_backend_public_lb"></a> [whitehall\_backend\_public\_lb](#module\_whitehall\_backend\_public\_lb) | ../../modules/aws/lb |  |
| <a name="module_whitehall_frontend_public_lb"></a> [whitehall\_frontend\_public\_lb](#module\_whitehall\_frontend\_public\_lb) | ../../modules/aws/lb |  |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.bouncer_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.cache_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.ckan_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.content-store_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.deploy_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.draft_cache_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.email_alert_api_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.frontend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.graphite_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.jumpbox_asg_attachment_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.licensify_backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.licensify_frontend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.mapit-1_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.mapit-2_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.monitoring_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.prometheus_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.search_api_backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.sidekiq_monitoring_backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.static_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.support_api_backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.whitehall_backend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_attachment.whitehall_frontend_asg_attachment_alb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/autoscaling_attachment) | resource |
| [aws_elb.jumpbox_public_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/elb) | resource |
| [aws_iam_role.aws_waf_firehose](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role.aws_waf_log_trimmer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.aws_waf_firehose](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/iam_role_policy) | resource |
| [aws_kinesis_firehose_delivery_stream.splunk](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_lambda_function.aws_waf_log_trimmer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lambda_function) | resource |
| [aws_lb_listener.licensify_backend_http_80](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.licensify_frontend_public_http_80](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.backend_alb_blocked_host_headers](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/lb_listener_rule) | resource |
| [aws_route53_record.account_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.account_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.apt_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.asset_master_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_internal_service_redirected_via_public_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.backend_redis_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.bouncer_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.bouncer_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.cache_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.cache_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.cache_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.cache_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.calculators_frontend_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.calculators_frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ckan_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ckan_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ckan_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.ckan_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.content-store_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.content_data_api_db_admin_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.content_data_api_postgresql_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.content_store_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.db_admin_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.deploy_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.deploy_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.docker_management_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_cache_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_cache_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_cache_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_cache_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_content_store_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_content_store_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_frontend_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.draft_whitehall_frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.elasticsearch6_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.email_alert_api_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.email_alert_api_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.feedback_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.frontend_cache_name](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.frontend_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.graphite_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.graphite_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.jumpbox_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.licensify_backend_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.licensify_frontend_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.licensify_frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.licensify_frontend_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.licensify_frontend_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mapit_cache_name](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mapit_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mapit_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mongo_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.monitoring_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.monitoring_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.mysql_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.postgresql_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.prometheus_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.prometheus_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.publishing_api_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.puppetmaster_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.rabbitmq_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.router_backend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.search_api_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.search_internal_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.search_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.sidekiq_monitoring_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.static_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.support_api_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.transition_db_admin_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.transition_postgresql_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.whitehall_backend_public_service_cnames](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.whitehall_backend_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.whitehall_frontend_internal_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_route53_record.whitehall_frontend_public_service_names](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.aws_waf_logs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/s3_bucket) | resource |
| [aws_shield_protection.cache_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/shield_protection) | resource |
| [aws_wafregional_regex_match_set.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_regex_match_set) | resource |
| [aws_wafregional_regex_pattern_set.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_regex_pattern_set) | resource |
| [aws_wafregional_rule.x_always_block](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_rule) | resource |
| [aws_wafregional_web_acl.default](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl) | resource |
| [aws_wafregional_web_acl_association.backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [aws_wafregional_web_acl_association.cache_public_web_acl](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [aws_wafregional_web_acl_association.licensify_backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [aws_wafregional_web_acl_association.licensify_frontend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [aws_wafregional_web_acl_association.whitehall_backend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [aws_wafregional_web_acl_association.whitehall_frontend_public_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/wafregional_web_acl_association) | resource |
| [archive_file.aws_waf_log_trimmer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_autoscaling_group.backend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_group) | data source |
| [aws_autoscaling_group.cache](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_group) | data source |
| [aws_autoscaling_groups.bouncer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.ckan](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.content-store](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.deploy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.draft_cache](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.email_alert_api](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.frontend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.graphite](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.jumpbox](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.licensify_backend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.licensify_frontend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.mapit-1](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.mapit-2](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.prometheus](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.search](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.static](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.whitehall_backend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [aws_autoscaling_groups.whitehall_frontend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/data-sources/autoscaling_groups) | data source |
| [terraform_remote_state.infra_monitoring](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_root_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_security_groups](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_stack_dns_zones](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_internal_service_cnames"></a> [account\_internal\_service\_cnames](#input\_account\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_account_internal_service_names"></a> [account\_internal\_service\_names](#input\_account\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_app_stackname"></a> [app\_stackname](#input\_app\_stackname) | Stackname of the app projects in this environment | `string` | `"blue"` | no |
| <a name="input_apt_internal_service_names"></a> [apt\_internal\_service\_names](#input\_apt\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_apt_public_service_cnames"></a> [apt\_public\_service\_cnames](#input\_apt\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_apt_public_service_names"></a> [apt\_public\_service\_names](#input\_apt\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_asset_master_internal_service_names"></a> [asset\_master\_internal\_service\_names](#input\_asset\_master\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_backend_alb_blocked_host_headers"></a> [backend\_alb\_blocked\_host\_headers](#input\_backend\_alb\_blocked\_host\_headers) | n/a | `list` | `[]` | no |
| <a name="input_backend_allow_routing_for_absent_host_header_rules"></a> [backend\_allow\_routing\_for\_absent\_host\_header\_rules](#input\_backend\_allow\_routing\_for\_absent\_host\_header\_rules) | n/a | `string` | `"true"` | no |
| <a name="input_backend_internal_service_cnames"></a> [backend\_internal\_service\_cnames](#input\_backend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_backend_internal_service_names"></a> [backend\_internal\_service\_names](#input\_backend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_backend_internal_service_redirected_via_public_cnames"></a> [backend\_internal\_service\_redirected\_via\_public\_cnames](#input\_backend\_internal\_service\_redirected\_via\_public\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_backend_public_service_cnames"></a> [backend\_public\_service\_cnames](#input\_backend\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_backend_public_service_names"></a> [backend\_public\_service\_names](#input\_backend\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_backend_redis_internal_service_names"></a> [backend\_redis\_internal\_service\_names](#input\_backend\_redis\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_backend_renamed_public_service_cnames"></a> [backend\_renamed\_public\_service\_cnames](#input\_backend\_renamed\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_backend_rules_for_existing_target_groups"></a> [backend\_rules\_for\_existing\_target\_groups](#input\_backend\_rules\_for\_existing\_target\_groups) | create an additional rule for a target group already created via rules\_host | `map` | `{}` | no |
| <a name="input_bouncer_internal_service_names"></a> [bouncer\_internal\_service\_names](#input\_bouncer\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_bouncer_public_service_names"></a> [bouncer\_public\_service\_names](#input\_bouncer\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_cache_internal_service_cnames"></a> [cache\_internal\_service\_cnames](#input\_cache\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_cache_internal_service_names"></a> [cache\_internal\_service\_names](#input\_cache\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_cache_public_service_cnames"></a> [cache\_public\_service\_cnames](#input\_cache\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_cache_public_service_names"></a> [cache\_public\_service\_names](#input\_cache\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_calculators_frontend_internal_service_cnames"></a> [calculators\_frontend\_internal\_service\_cnames](#input\_calculators\_frontend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_calculators_frontend_internal_service_names"></a> [calculators\_frontend\_internal\_service\_names](#input\_calculators\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_ckan_internal_service_cnames"></a> [ckan\_internal\_service\_cnames](#input\_ckan\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_ckan_internal_service_names"></a> [ckan\_internal\_service\_names](#input\_ckan\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_ckan_public_service_cnames"></a> [ckan\_public\_service\_cnames](#input\_ckan\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_ckan_public_service_names"></a> [ckan\_public\_service\_names](#input\_ckan\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_content_data_api_db_admin_internal_service_names"></a> [content\_data\_api\_db\_admin\_internal\_service\_names](#input\_content\_data\_api\_db\_admin\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_content_data_api_postgresql_internal_service_names"></a> [content\_data\_api\_postgresql\_internal\_service\_names](#input\_content\_data\_api\_postgresql\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_content_store_internal_service_names"></a> [content\_store\_internal\_service\_names](#input\_content\_store\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_content_store_public_service_names"></a> [content\_store\_public\_service\_names](#input\_content\_store\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_db_admin_internal_service_names"></a> [db\_admin\_internal\_service\_names](#input\_db\_admin\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_deploy_internal_service_names"></a> [deploy\_internal\_service\_names](#input\_deploy\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_deploy_public_service_names"></a> [deploy\_public\_service\_names](#input\_deploy\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_docker_management_internal_service_names"></a> [docker\_management\_internal\_service\_names](#input\_docker\_management\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_cache_internal_service_cnames"></a> [draft\_cache\_internal\_service\_cnames](#input\_draft\_cache\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_draft_cache_internal_service_names"></a> [draft\_cache\_internal\_service\_names](#input\_draft\_cache\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_cache_public_service_cnames"></a> [draft\_cache\_public\_service\_cnames](#input\_draft\_cache\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_draft_cache_public_service_names"></a> [draft\_cache\_public\_service\_names](#input\_draft\_cache\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_content_store_internal_service_names"></a> [draft\_content\_store\_internal\_service\_names](#input\_draft\_content\_store\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_content_store_public_service_names"></a> [draft\_content\_store\_public\_service\_names](#input\_draft\_content\_store\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_frontend_internal_service_cnames"></a> [draft\_frontend\_internal\_service\_cnames](#input\_draft\_frontend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_draft_frontend_internal_service_names"></a> [draft\_frontend\_internal\_service\_names](#input\_draft\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_draft_whitehall_frontend_internal_service_names"></a> [draft\_whitehall\_frontend\_internal\_service\_names](#input\_draft\_whitehall\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_elasticsearch6_internal_service_names"></a> [elasticsearch6\_internal\_service\_names](#input\_elasticsearch6\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_elb_public_certname"></a> [elb\_public\_certname](#input\_elb\_public\_certname) | The ACM cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_elb_public_internal_certname"></a> [elb\_public\_internal\_certname](#input\_elb\_public\_internal\_certname) | The ACM secondary cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_elb_public_secondary_certname"></a> [elb\_public\_secondary\_certname](#input\_elb\_public\_secondary\_certname) | The ACM secondary cert domain name to find the ARN of | `string` | n/a | yes |
| <a name="input_email_alert_api_internal_service_names"></a> [email\_alert\_api\_internal\_service\_names](#input\_email\_alert\_api\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_email_alert_api_public_service_names"></a> [email\_alert\_api\_public\_service\_names](#input\_email\_alert\_api\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_enable_lb_app_healthchecks"></a> [enable\_lb\_app\_healthchecks](#input\_enable\_lb\_app\_healthchecks) | Use application specific target groups and healthchecks based on the list of services in the cname variable. | `string` | `false` | no |
| <a name="input_feedback_public_service_names"></a> [feedback\_public\_service\_names](#input\_feedback\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_frontend_internal_service_cnames"></a> [frontend\_internal\_service\_cnames](#input\_frontend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_frontend_internal_service_names"></a> [frontend\_internal\_service\_names](#input\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_graphite_internal_service_names"></a> [graphite\_internal\_service\_names](#input\_graphite\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_graphite_public_service_names"></a> [graphite\_public\_service\_names](#input\_graphite\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_jumpbox_public_service_names"></a> [jumpbox\_public\_service\_names](#input\_jumpbox\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_licensify_backend_elb_public_certname"></a> [licensify\_backend\_elb\_public\_certname](#input\_licensify\_backend\_elb\_public\_certname) | Domain name (CN) of the ACM cert to use for licensify\_backend. | `string` | n/a | yes |
| <a name="input_licensify_backend_public_service_names"></a> [licensify\_backend\_public\_service\_names](#input\_licensify\_backend\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_licensify_frontend_internal_service_cnames"></a> [licensify\_frontend\_internal\_service\_cnames](#input\_licensify\_frontend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_licensify_frontend_internal_service_names"></a> [licensify\_frontend\_internal\_service\_names](#input\_licensify\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_licensify_frontend_public_service_cnames"></a> [licensify\_frontend\_public\_service\_cnames](#input\_licensify\_frontend\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_licensify_frontend_public_service_names"></a> [licensify\_frontend\_public\_service\_names](#input\_licensify\_frontend\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_mapit_internal_service_names"></a> [mapit\_internal\_service\_names](#input\_mapit\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_mapit_public_service_names"></a> [mapit\_public\_service\_names](#input\_mapit\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_mongo_internal_service_names"></a> [mongo\_internal\_service\_names](#input\_mongo\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_monitoring_internal_service_names"></a> [monitoring\_internal\_service\_names](#input\_monitoring\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_monitoring_internal_service_names_cname_dest"></a> [monitoring\_internal\_service\_names\_cname\_dest](#input\_monitoring\_internal\_service\_names\_cname\_dest) | This variable specifies the CNAME record destination to be associated with the service names defined in monitoring\_internal\_service\_names | `string` | `"alert"` | no |
| <a name="input_monitoring_public_service_names"></a> [monitoring\_public\_service\_names](#input\_monitoring\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_mysql_internal_service_names"></a> [mysql\_internal\_service\_names](#input\_mysql\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_postgresql_internal_service_names"></a> [postgresql\_internal\_service\_names](#input\_postgresql\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_prometheus_internal_service_names"></a> [prometheus\_internal\_service\_names](#input\_prometheus\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_prometheus_public_service_names"></a> [prometheus\_public\_service\_names](#input\_prometheus\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_publishing_api_internal_service_names"></a> [publishing\_api\_internal\_service\_names](#input\_publishing\_api\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_puppetmaster_internal_service_names"></a> [puppetmaster\_internal\_service\_names](#input\_puppetmaster\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_rabbitmq_internal_service_names"></a> [rabbitmq\_internal\_service\_names](#input\_rabbitmq\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_monitoring_key_stack"></a> [remote\_state\_infra\_monitoring\_key\_stack](#input\_remote\_state\_infra\_monitoring\_key\_stack) | Override stackname path to infra\_monitoring remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_root_dns_zones_key_stack"></a> [remote\_state\_infra\_root\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_root\_dns\_zones\_key\_stack) | Override stackname path to infra\_root\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_security_groups_key_stack"></a> [remote\_state\_infra\_security\_groups\_key\_stack](#input\_remote\_state\_infra\_security\_groups\_key\_stack) | Override infra\_security\_groups stackname path to infra\_vpc remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_stack_dns_zones_key_stack"></a> [remote\_state\_infra\_stack\_dns\_zones\_key\_stack](#input\_remote\_state\_infra\_stack\_dns\_zones\_key\_stack) | Override stackname path to infra\_stack\_dns\_zones remote state | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_router_backend_internal_service_names"></a> [router\_backend\_internal\_service\_names](#input\_router\_backend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_search_api_public_service_names"></a> [search\_api\_public\_service\_names](#input\_search\_api\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_search_internal_service_cnames"></a> [search\_internal\_service\_cnames](#input\_search\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_search_internal_service_names"></a> [search\_internal\_service\_names](#input\_search\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_sidekiq_monitoring_public_service_names"></a> [sidekiq\_monitoring\_public\_service\_names](#input\_sidekiq\_monitoring\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | Stackname | `string` | n/a | yes |
| <a name="input_static_public_service_names"></a> [static\_public\_service\_names](#input\_static\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_support_api_public_service_names"></a> [support\_api\_public\_service\_names](#input\_support\_api\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_transition_db_admin_internal_service_names"></a> [transition\_db\_admin\_internal\_service\_names](#input\_transition\_db\_admin\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_transition_postgresql_internal_service_names"></a> [transition\_postgresql\_internal\_service\_names](#input\_transition\_postgresql\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_waf_logs_hec_endpoint"></a> [waf\_logs\_hec\_endpoint](#input\_waf\_logs\_hec\_endpoint) | Splunk endpoint for shipping application firewall logs | `string` | n/a | yes |
| <a name="input_waf_logs_hec_token"></a> [waf\_logs\_hec\_token](#input\_waf\_logs\_hec\_token) | Splunk token for shipping application firewall logs | `string` | n/a | yes |
| <a name="input_whitehall_backend_internal_service_cnames"></a> [whitehall\_backend\_internal\_service\_cnames](#input\_whitehall\_backend\_internal\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_whitehall_backend_internal_service_names"></a> [whitehall\_backend\_internal\_service\_names](#input\_whitehall\_backend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_whitehall_backend_public_service_cnames"></a> [whitehall\_backend\_public\_service\_cnames](#input\_whitehall\_backend\_public\_service\_cnames) | n/a | `list` | `[]` | no |
| <a name="input_whitehall_backend_public_service_names"></a> [whitehall\_backend\_public\_service\_names](#input\_whitehall\_backend\_public\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_whitehall_frontend_internal_service_names"></a> [whitehall\_frontend\_internal\_service\_names](#input\_whitehall\_frontend\_internal\_service\_names) | n/a | `list` | `[]` | no |
| <a name="input_whitehall_frontend_public_service_names"></a> [whitehall\_frontend\_public\_service\_names](#input\_whitehall\_frontend\_public\_service\_names) | n/a | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_waf_acl"></a> [default\_waf\_acl](#output\_default\_waf\_acl) | GOV.UK default regional WAF ACL |
