## Project: infra-security-groups

Manage the security groups for the entire infrastructure


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_region | AWS region | string | `eu-west-1` | no |
| carrenza_draft_frontend_ips | An array of CIDR blocks for the current environment that will allow access to draft-content-store from Carrenza. | list | `<list>` | no |
| carrenza_env_ips | An array of CIDR blocks for the current environment that will be allowed to SSH to the jumpbox. | list | `<list>` | no |
| carrenza_integration_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | - | yes |
| carrenza_production_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | - | yes |
| carrenza_staging_ips | An array of CIDR blocks that will be allowed to SSH to the jumpbox. | list | - | yes |
| carrenza_vpn_subnet_cidr | The Carrenza VPN subnet CIDR | list | `<list>` | no |
| ithc_access_ips | An array of CIDR blocks that will be allowed temporary access for ITHC purposes. | list | `<list>` | no |
| office_ips | An array of CIDR blocks that will be allowed offsite access. | list | - | yes |
| remote_state_bucket | S3 bucket we store our terraform state in | string | - | yes |
| remote_state_infra_networking_key_stack | Override infra_networking remote state path | string | `` | no |
| remote_state_infra_vpc_key_stack | Override infra_vpc remote state path | string | `` | no |
| stackname | The name of the stack being built. Must be unique within the environment as it's used for disambiguation. | string | - | yes |
| traffic_replay_ips | An array of CIDR blocks that will replay traffic against an environment | list | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| sg_apt_external_elb_id |  |
| sg_apt_id |  |
| sg_apt_internal_elb_id |  |
| sg_asset-master-efs_id |  |
| sg_asset-master_id |  |
| sg_aws-vpn_id |  |
| sg_backend-redis_id |  |
| sg_backend_elb_external_id |  |
| sg_backend_elb_internal_id |  |
| sg_backend_id |  |
| sg_bouncer_elb_id |  |
| sg_bouncer_id |  |
| sg_bouncer_internal_elb_id |  |
| sg_cache_elb_id |  |
| sg_cache_external_elb_id |  |
| sg_cache_id |  |
| sg_calculators-frontend_elb_id |  |
| sg_calculators-frontend_id |  |
| sg_calendars_carrenza_alb_id |  |
| sg_ckan_elb_external_id |  |
| sg_ckan_elb_internal_id |  |
| sg_ckan_id |  |
| sg_content-data-api-db-admin_id |  |
| sg_content-data-api-postgresql-primary_id |  |
| sg_content-store_external_elb_id |  |
| sg_content-store_id |  |
| sg_content-store_internal_elb_id |  |
| sg_db-admin_elb_id |  |
| sg_db-admin_id |  |
| sg_deploy_elb_id |  |
| sg_deploy_id |  |
| sg_deploy_internal_elb_id |  |
| sg_docker_management_etcd_elb_id |  |
| sg_docker_management_id |  |
| sg_draft-cache_elb_id |  |
| sg_draft-cache_external_elb_id |  |
| sg_draft-cache_id |  |
| sg_draft-content-store_external_elb_id |  |
| sg_draft-content-store_id |  |
| sg_draft-content-store_internal_elb_id |  |
| sg_draft-frontend_elb_id |  |
| sg_draft-frontend_id |  |
| sg_elasticsearch5_id |  |
| sg_elasticsearch6_id |  |
| sg_email-alert-api-db-admin_elb_id |  |
| sg_email-alert-api-db-admin_id |  |
| sg_email-alert-api-postgresql-primary_id |  |
| sg_email-alert-api-postgresql-standby_id |  |
| sg_email-alert-api_elb_external_id |  |
| sg_email-alert-api_elb_internal_id |  |
| sg_email-alert-api_id |  |
| sg_feedback_elb_id |  |
| sg_frontend_elb_id |  |
| sg_frontend_id |  |
| sg_gatling_id |  |
| sg_graphite_external_elb_id |  |
| sg_graphite_id |  |
| sg_graphite_internal_elb_id |  |
| sg_jumpbox_id |  |
| sg_management_id |  |
| sg_mapit_carrenza_alb_id |  |
| sg_mapit_elb_id |  |
| sg_mapit_id |  |
| sg_mirrorer_id |  |
| sg_mongo_id |  |
| sg_monitoring_external_elb_id |  |
| sg_monitoring_id |  |
| sg_monitoring_internal_elb_id |  |
| sg_mysql-primary_id |  |
| sg_mysql-replica_id |  |
| sg_offsite_ssh_id |  |
| sg_postgresql-primary_id |  |
| sg_prometheus_external_elb_id |  |
| sg_prometheus_id |  |
| sg_publishing-api-db-admin_elb_id |  |
| sg_publishing-api-db-admin_id |  |
| sg_publishing-api-postgresql-primary_id |  |
| sg_publishing-api_elb_external_id |  |
| sg_publishing-api_elb_internal_id |  |
| sg_publishing-api_id |  |
| sg_puppetmaster_elb_id |  |
| sg_puppetmaster_id |  |
| sg_rabbitmq_elb_id |  |
| sg_rabbitmq_id |  |
| sg_router-api_elb_id |  |
| sg_router-backend_id |  |
| sg_search-api_external_elb_id |  |
| sg_search_elb_id |  |
| sg_search_id |  |
| sg_static_carrenza_alb_id |  |
| sg_support-api_external_elb_id |  |
| sg_transition-db-admin_elb_id |  |
| sg_transition-db-admin_id |  |
| sg_transition-postgresql-primary_id |  |
| sg_transition-postgresql-standby_id |  |
| sg_ubuntutest_id |  |
| sg_whitehall-backend_external_elb_id |  |
| sg_whitehall-backend_id |  |
| sg_whitehall-backend_internal_elb_id |  |
| sg_whitehall-frontend_elb_id |  |
| sg_whitehall-frontend_id |  |

