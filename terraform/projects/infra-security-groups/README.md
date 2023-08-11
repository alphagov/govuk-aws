## Project: infra-security-groups

Manage the security groups for the entire infrastructure

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | = 0.12.31 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 2.46.0 |
| <a name="requirement_fastly"></a> [fastly](#requirement\_fastly) | ~> 0.26.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 2.46.0 |
| <a name="provider_fastly"></a> [fastly](#provider\_fastly) | ~> 0.26.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 4.15 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.apt](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.apt_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.apt_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.apt_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.asset-master-efs](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.backend-redis](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-1](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-1_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-2](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-2_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-3](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-3_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-4](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-4_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-5](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-agent-5_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-master](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-master_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ci-master_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ckan](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ckan_elb_external](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ckan_elb_internal](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.ckan_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.content-data-api-db-admin](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.content-data-api-db-admin_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.content-data-api-postgresql-primary](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.content-data-api-postgresql-primary_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.db-admin](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.db-admin_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.deploy](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.deploy_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.deploy_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.docker_management](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.docker_management_etcd_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.elasticsearch6](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.gatling](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.gatling_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.graphite](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.graphite_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.graphite_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.jumpbox](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-backend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-backend_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-backend_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-frontend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-frontend_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify-frontend_internal_lb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify_backend_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify_documentdb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.licensify_frontend_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.management](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.mirrorer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.mongo](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.monitoring](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.monitoring_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.monitoring_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.offsite_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.prometheus](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.prometheus_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.prometheus_internal_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.puppetmaster](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.puppetmaster_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.rabbitmq](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.rabbitmq_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.rate-limit-redis](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.related-links](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.router-backend](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.router-backend_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.search](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.search-ltr-generation](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.search_ithc_access](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.shared-documentdb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.support-api_external_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.transition-db-admin](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.transition-db-admin_elb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.transition-postgresql-primary](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group.transition-postgresql-standby](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group) | resource |
| [aws_security_group_rule.apt-external-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-external-elb_ingress_fastly_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-external-elb_ingress_fastly_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-external-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-internal-elb_ingress_management_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt-internal-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt_ingress_apt-external-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.apt_ingress_apt-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.backend-redis_ingress_ckan_redis](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.backend-redis_ingress_db-admin_redis](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.backend-redis_ingress_deploy_redis](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-1-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-1-elb_ingress_ci-master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-1-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-1_ingress_ci-agent-1-ci_master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-1_ingress_ci-agent-1-elb_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-2-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-2-elb_ingress_ci-master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-2-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-2_ingress_ci-agent-2-ci_master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-2_ingress_ci-agent-2-elb_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-3-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-3-elb_ingress_ci-master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-3-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-3_ingress_ci-agent-3-ci_master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-3_ingress_ci-agent-3-elb_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-4-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-4-elb_ingress_ci-master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-4-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-4_ingress_ci-agent-4-ci_master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-4_ingress_ci-agent-4-elb_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-5-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-5-elb_ingress_ci-master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-5-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-5_ingress_ci-agent-5-ci_master_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-agent-5_ingress_ci-agent-5-elb_ssh_tcp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master-elb_ingress_github_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master-internal-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master_ingress_ci-master-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ci-master_ingress_ci-master-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan-elb-external_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan-elb-external_ingress_public_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan-elb-internal_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan-elb-internal_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan_ingress_ckan-elb-external_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan_ingress_ckan-elb-internal_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ckan_ingress_db-admin_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.content-data-api-postgresql-primary_ingress_db-admin_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db-admin-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db-admin-elb_ingress_management_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db-admin_ingress_db-admin-elb_pgbouncer](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.db-admin_ingress_db-admin-elb_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-elb_ingress_aws_integration_access_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-elb_ingress_aws_staging_access_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy-internal-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy_ingress_deploy-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.deploy_ingress_deploy-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.docker-management-etcd-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.docker-management-etcd-elb_ingress_management_etcd-client](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.docker-management_ingress_docker-management-etcd-elb_etcd-client](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.docker-management_ingress_docker-management_etcd-transport](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elasticsearch6_ingress_search-ltr-generation_elasticsearch-api](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elasticsearch6_ingress_search-ltr-generation_elasticsearch-api-https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elasticsearch6_ingress_search_elasticsearch-api](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.elasticsearch6_ingress_search_elasticsearch-api-https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatling-external-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatling-external-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatling_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatling_ingress_gatling_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.gatling_ingress_gatling_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-external-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-external-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-external-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-internal-elb_ingress_deploy_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-internal-elb_ingress_management_carbon](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-internal-elb_ingress_management_pickle](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite-internal-elb_ingress_monitoring_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite_ingress_graphite-external-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite_ingress_graphite-internal-elb_carbon](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite_ingress_graphite-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite_ingress_graphite-internal-elb_pickle](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.graphite_ingress_graphite_internal_elb_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_apt_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_ckan_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_content-data-api-db-admin_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_content-data-api-postgresql-primary_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_licensify_backend_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_licensify_frontend_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_router-backend_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_search_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ithc_ingress_support-api_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.jumpbox_ingress_offsite-ssh_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend-external-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend-external-elb_ingress_public_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend-external-elb_ingress_public_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend-internal-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend_ingress_licensify-backend-external-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-backend_ingress_licensify-backend-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-documentdb_ingress_db-admin_mongodb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-documentdb_ingress_db-licensify_backend_mongodb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-documentdb_ingress_db-licensify_frontend_mongodb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_ingress_ithc_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_ingress_office_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_ingress_public_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-elb_ingress_public_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-internal-lb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend-internal-lb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend_ingress_licensify-frontend-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.licensify-frontend_ingress_licensify-frontend-internal-lb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ingress_deploy_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ingress_jumpbox_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ingress_monitoring_nrpe](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ingress_monitoring_ping](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.management_ingress_prometheus_node_exporter](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mangement_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.mongo_ingress_mongo_mongo](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-elb_ingress_fastly_syslog-tls](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-external-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-external-elb_ingress_office_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-internal-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-internal-elb_ingress_jumpbox_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-internal-elb_ingress_management_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring-internal-elb_ingress_management_ncsa](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring_ingress_monitoring-elb_syslog-tls](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring_ingress_monitoring-external-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring_ingress_monitoring-internal-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring_ingress_monitoring-internal-elb_nsca](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.monitoring_ingress_monitoring-internal-elb_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.offsite-ssh_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.offsite-ssh_ingress_office-and-carrenza_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheus-elb_egress_prometheus_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheus-elb_ingress_officeips_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheus-internal-elb_egress_prometheus_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheus-internal-elb_ingress_grafana_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheus-internal-elb_ingress_prometheus_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.prometheuselb_ingress_prometheus_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster-elb_ingress_jumpbox_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster-elb_ingress_management_puppet](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster-elb_ingress_monitoring_https](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster_ingress_puppetmaster-elb_http](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.puppetmaster_ingress_puppetmaster-elb_puppet](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq-elb_ingress_management_amqp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq-elb_ingress_management_rabbitmq-stomp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq_ingress_rabbitmq-elb_amqp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq_ingress_rabbitmq-elb_rabbitmq-stomp](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq_ingress_rabbitmq_rabbitmq-epmd](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.rabbitmq_ingress_rabbitmq_rabbitmq-transport](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.related-links_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.related-links_ingress_jenkins_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.router-backend_ingress_router-backend_mongo](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.search-ltr-generation_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.search-ltr-generation_ingress_jenkins_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.shared-documentdb_ingress_db-admin_mongodb](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.support-api_egress_external_elb_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.transition-db-admin-elb_egress_any_any](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.transition-db-admin-elb_ingress_management_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.transition-db-admin_ingress_transition-db-admin-elb_ssh](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.transition-postgresql-primary_ingress_db-admin_postgres](https://registry.terraform.io/providers/hashicorp/aws/2.46.0/docs/resources/security_group_rule) | resource |
| [fastly_ip_ranges.fastly](https://registry.terraform.io/providers/hashicorp/fastly/latest/docs/data-sources/ip_ranges) | data source |
| [github_ip_ranges.github](https://registry.terraform.io/providers/hashicorp/github/latest/docs/data-sources/ip_ranges) | data source |
| [terraform_remote_state.infra_networking](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.infra_vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_environment"></a> [aws\_environment](#input\_aws\_environment) | AWS Environment | `string` | n/a | yes |
| <a name="input_aws_integration_external_nat_gateway_ips"></a> [aws\_integration\_external\_nat\_gateway\_ips](#input\_aws\_integration\_external\_nat\_gateway\_ips) | An array of public IPs of the AWS integration external NAT gateways. | `list` | `[]` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"eu-west-1"` | no |
| <a name="input_aws_staging_external_nat_gateway_ips"></a> [aws\_staging\_external\_nat\_gateway\_ips](#input\_aws\_staging\_external\_nat\_gateway\_ips) | An array of public IPs of the AWS staging external NAT gateways. | `list` | `[]` | no |
| <a name="input_ithc_access_ips"></a> [ithc\_access\_ips](#input\_ithc\_access\_ips) | An array of CIDR blocks that will be allowed temporary access for ITHC purposes. | `list` | `[]` | no |
| <a name="input_office_ips"></a> [office\_ips](#input\_office\_ips) | An array of CIDR blocks that will be allowed offsite access. | `list` | n/a | yes |
| <a name="input_paas_ireland_egress_ips"></a> [paas\_ireland\_egress\_ips](#input\_paas\_ireland\_egress\_ips) | An array of CIDR blocks that are used for egress from the GOV.UK PaaS Ireland region | `list` | `[]` | no |
| <a name="input_paas_london_egress_ips"></a> [paas\_london\_egress\_ips](#input\_paas\_london\_egress\_ips) | An array of CIDR blocks that are used for egress from the GOV.UK PaaS London region | `list` | `[]` | no |
| <a name="input_remote_state_bucket"></a> [remote\_state\_bucket](#input\_remote\_state\_bucket) | S3 bucket we store our terraform state in | `string` | n/a | yes |
| <a name="input_remote_state_infra_networking_key_stack"></a> [remote\_state\_infra\_networking\_key\_stack](#input\_remote\_state\_infra\_networking\_key\_stack) | Override infra\_networking remote state path | `string` | `""` | no |
| <a name="input_remote_state_infra_vpc_key_stack"></a> [remote\_state\_infra\_vpc\_key\_stack](#input\_remote\_state\_infra\_vpc\_key\_stack) | Override infra\_vpc remote state path | `string` | `""` | no |
| <a name="input_stackname"></a> [stackname](#input\_stackname) | The name of the stack being built. Must be unique within the environment as it's used for disambiguation. | `string` | n/a | yes |
| <a name="input_traffic_replay_ips"></a> [traffic\_replay\_ips](#input\_traffic\_replay\_ips) | An array of CIDR blocks that will replay traffic against an environment | `list` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_office_ips"></a> [office\_ips](#output\_office\_ips) | n/a |
| <a name="output_sg_apt_external_elb_id"></a> [sg\_apt\_external\_elb\_id](#output\_sg\_apt\_external\_elb\_id) | n/a |
| <a name="output_sg_apt_id"></a> [sg\_apt\_id](#output\_sg\_apt\_id) | n/a |
| <a name="output_sg_apt_internal_elb_id"></a> [sg\_apt\_internal\_elb\_id](#output\_sg\_apt\_internal\_elb\_id) | n/a |
| <a name="output_sg_asset-master-efs_id"></a> [sg\_asset-master-efs\_id](#output\_sg\_asset-master-efs\_id) | n/a |
| <a name="output_sg_backend-redis_id"></a> [sg\_backend-redis\_id](#output\_sg\_backend-redis\_id) | n/a |
| <a name="output_sg_ci-agent-1_elb_id"></a> [sg\_ci-agent-1\_elb\_id](#output\_sg\_ci-agent-1\_elb\_id) | n/a |
| <a name="output_sg_ci-agent-1_id"></a> [sg\_ci-agent-1\_id](#output\_sg\_ci-agent-1\_id) | n/a |
| <a name="output_sg_ci-agent-2_elb_id"></a> [sg\_ci-agent-2\_elb\_id](#output\_sg\_ci-agent-2\_elb\_id) | n/a |
| <a name="output_sg_ci-agent-2_id"></a> [sg\_ci-agent-2\_id](#output\_sg\_ci-agent-2\_id) | n/a |
| <a name="output_sg_ci-agent-3_elb_id"></a> [sg\_ci-agent-3\_elb\_id](#output\_sg\_ci-agent-3\_elb\_id) | n/a |
| <a name="output_sg_ci-agent-3_id"></a> [sg\_ci-agent-3\_id](#output\_sg\_ci-agent-3\_id) | n/a |
| <a name="output_sg_ci-agent-4_elb_id"></a> [sg\_ci-agent-4\_elb\_id](#output\_sg\_ci-agent-4\_elb\_id) | n/a |
| <a name="output_sg_ci-agent-4_id"></a> [sg\_ci-agent-4\_id](#output\_sg\_ci-agent-4\_id) | n/a |
| <a name="output_sg_ci-agent-5_elb_id"></a> [sg\_ci-agent-5\_elb\_id](#output\_sg\_ci-agent-5\_elb\_id) | n/a |
| <a name="output_sg_ci-agent-5_id"></a> [sg\_ci-agent-5\_id](#output\_sg\_ci-agent-5\_id) | n/a |
| <a name="output_sg_ci-master_elb_id"></a> [sg\_ci-master\_elb\_id](#output\_sg\_ci-master\_elb\_id) | n/a |
| <a name="output_sg_ci-master_id"></a> [sg\_ci-master\_id](#output\_sg\_ci-master\_id) | n/a |
| <a name="output_sg_ci-master_internal_elb_id"></a> [sg\_ci-master\_internal\_elb\_id](#output\_sg\_ci-master\_internal\_elb\_id) | n/a |
| <a name="output_sg_ckan_elb_external_id"></a> [sg\_ckan\_elb\_external\_id](#output\_sg\_ckan\_elb\_external\_id) | n/a |
| <a name="output_sg_ckan_elb_internal_id"></a> [sg\_ckan\_elb\_internal\_id](#output\_sg\_ckan\_elb\_internal\_id) | n/a |
| <a name="output_sg_ckan_id"></a> [sg\_ckan\_id](#output\_sg\_ckan\_id) | n/a |
| <a name="output_sg_content-data-api-db-admin_id"></a> [sg\_content-data-api-db-admin\_id](#output\_sg\_content-data-api-db-admin\_id) | n/a |
| <a name="output_sg_content-data-api-postgresql-primary_id"></a> [sg\_content-data-api-postgresql-primary\_id](#output\_sg\_content-data-api-postgresql-primary\_id) | n/a |
| <a name="output_sg_db-admin_elb_id"></a> [sg\_db-admin\_elb\_id](#output\_sg\_db-admin\_elb\_id) | n/a |
| <a name="output_sg_db-admin_id"></a> [sg\_db-admin\_id](#output\_sg\_db-admin\_id) | n/a |
| <a name="output_sg_deploy_elb_id"></a> [sg\_deploy\_elb\_id](#output\_sg\_deploy\_elb\_id) | n/a |
| <a name="output_sg_deploy_id"></a> [sg\_deploy\_id](#output\_sg\_deploy\_id) | n/a |
| <a name="output_sg_deploy_internal_elb_id"></a> [sg\_deploy\_internal\_elb\_id](#output\_sg\_deploy\_internal\_elb\_id) | n/a |
| <a name="output_sg_docker_management_etcd_elb_id"></a> [sg\_docker\_management\_etcd\_elb\_id](#output\_sg\_docker\_management\_etcd\_elb\_id) | n/a |
| <a name="output_sg_docker_management_id"></a> [sg\_docker\_management\_id](#output\_sg\_docker\_management\_id) | n/a |
| <a name="output_sg_elasticsearch6_id"></a> [sg\_elasticsearch6\_id](#output\_sg\_elasticsearch6\_id) | n/a |
| <a name="output_sg_gatling_external_elb_id"></a> [sg\_gatling\_external\_elb\_id](#output\_sg\_gatling\_external\_elb\_id) | n/a |
| <a name="output_sg_gatling_id"></a> [sg\_gatling\_id](#output\_sg\_gatling\_id) | n/a |
| <a name="output_sg_graphite_external_elb_id"></a> [sg\_graphite\_external\_elb\_id](#output\_sg\_graphite\_external\_elb\_id) | n/a |
| <a name="output_sg_graphite_id"></a> [sg\_graphite\_id](#output\_sg\_graphite\_id) | n/a |
| <a name="output_sg_graphite_internal_elb_id"></a> [sg\_graphite\_internal\_elb\_id](#output\_sg\_graphite\_internal\_elb\_id) | n/a |
| <a name="output_sg_jumpbox_id"></a> [sg\_jumpbox\_id](#output\_sg\_jumpbox\_id) | n/a |
| <a name="output_sg_licensify-backend_external_elb_id"></a> [sg\_licensify-backend\_external\_elb\_id](#output\_sg\_licensify-backend\_external\_elb\_id) | n/a |
| <a name="output_sg_licensify-backend_id"></a> [sg\_licensify-backend\_id](#output\_sg\_licensify-backend\_id) | n/a |
| <a name="output_sg_licensify-backend_internal_elb_id"></a> [sg\_licensify-backend\_internal\_elb\_id](#output\_sg\_licensify-backend\_internal\_elb\_id) | n/a |
| <a name="output_sg_licensify-frontend_external_elb_id"></a> [sg\_licensify-frontend\_external\_elb\_id](#output\_sg\_licensify-frontend\_external\_elb\_id) | n/a |
| <a name="output_sg_licensify-frontend_id"></a> [sg\_licensify-frontend\_id](#output\_sg\_licensify-frontend\_id) | n/a |
| <a name="output_sg_licensify-frontend_internal_lb_id"></a> [sg\_licensify-frontend\_internal\_lb\_id](#output\_sg\_licensify-frontend\_internal\_lb\_id) | n/a |
| <a name="output_sg_licensify_documentdb_id"></a> [sg\_licensify\_documentdb\_id](#output\_sg\_licensify\_documentdb\_id) | n/a |
| <a name="output_sg_management_id"></a> [sg\_management\_id](#output\_sg\_management\_id) | n/a |
| <a name="output_sg_mirrorer_id"></a> [sg\_mirrorer\_id](#output\_sg\_mirrorer\_id) | n/a |
| <a name="output_sg_mongo_id"></a> [sg\_mongo\_id](#output\_sg\_mongo\_id) | n/a |
| <a name="output_sg_monitoring_external_elb_id"></a> [sg\_monitoring\_external\_elb\_id](#output\_sg\_monitoring\_external\_elb\_id) | n/a |
| <a name="output_sg_monitoring_id"></a> [sg\_monitoring\_id](#output\_sg\_monitoring\_id) | n/a |
| <a name="output_sg_monitoring_internal_elb_id"></a> [sg\_monitoring\_internal\_elb\_id](#output\_sg\_monitoring\_internal\_elb\_id) | n/a |
| <a name="output_sg_offsite_ssh_id"></a> [sg\_offsite\_ssh\_id](#output\_sg\_offsite\_ssh\_id) | n/a |
| <a name="output_sg_prometheus_external_elb_id"></a> [sg\_prometheus\_external\_elb\_id](#output\_sg\_prometheus\_external\_elb\_id) | n/a |
| <a name="output_sg_prometheus_id"></a> [sg\_prometheus\_id](#output\_sg\_prometheus\_id) | n/a |
| <a name="output_sg_prometheus_internal_elb_id"></a> [sg\_prometheus\_internal\_elb\_id](#output\_sg\_prometheus\_internal\_elb\_id) | n/a |
| <a name="output_sg_puppetmaster_elb_id"></a> [sg\_puppetmaster\_elb\_id](#output\_sg\_puppetmaster\_elb\_id) | n/a |
| <a name="output_sg_puppetmaster_id"></a> [sg\_puppetmaster\_id](#output\_sg\_puppetmaster\_id) | n/a |
| <a name="output_sg_rabbitmq_elb_id"></a> [sg\_rabbitmq\_elb\_id](#output\_sg\_rabbitmq\_elb\_id) | n/a |
| <a name="output_sg_rabbitmq_id"></a> [sg\_rabbitmq\_id](#output\_sg\_rabbitmq\_id) | n/a |
| <a name="output_sg_rate-limit-redis_id"></a> [sg\_rate-limit-redis\_id](#output\_sg\_rate-limit-redis\_id) | n/a |
| <a name="output_sg_related-links_id"></a> [sg\_related-links\_id](#output\_sg\_related-links\_id) | n/a |
| <a name="output_sg_router-backend_id"></a> [sg\_router-backend\_id](#output\_sg\_router-backend\_id) | n/a |
| <a name="output_sg_search-ltr-generation_id"></a> [sg\_search-ltr-generation\_id](#output\_sg\_search-ltr-generation\_id) | n/a |
| <a name="output_sg_search_id"></a> [sg\_search\_id](#output\_sg\_search\_id) | n/a |
| <a name="output_sg_shared_documentdb_id"></a> [sg\_shared\_documentdb\_id](#output\_sg\_shared\_documentdb\_id) | n/a |
| <a name="output_sg_transition-db-admin_elb_id"></a> [sg\_transition-db-admin\_elb\_id](#output\_sg\_transition-db-admin\_elb\_id) | n/a |
| <a name="output_sg_transition-db-admin_id"></a> [sg\_transition-db-admin\_id](#output\_sg\_transition-db-admin\_id) | n/a |
| <a name="output_sg_transition-postgresql-primary_id"></a> [sg\_transition-postgresql-primary\_id](#output\_sg\_transition-postgresql-primary\_id) | n/a |
| <a name="output_sg_transition-postgresql-standby_id"></a> [sg\_transition-postgresql-standby\_id](#output\_sg\_transition-postgresql-standby\_id) | n/a |
