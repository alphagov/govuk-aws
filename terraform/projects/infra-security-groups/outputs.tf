#
# Outputs of the security group project
#

output "sg_asset-master_id" {
  value = "${aws_security_group.asset-master.id}"
}

output "sg_asset-master-efs_id" {
  value = "${aws_security_group.asset-master-efs.id}"
}

output "sg_postgresql-primary_id" {
  value = "${aws_security_group.postgresql-primary.id}"
}

output "sg_apt_external_elb_id" {
  value = "${aws_security_group.apt_external_elb.id}"
}

output "sg_apt_id" {
  value = "${aws_security_group.apt.id}"
}

output "sg_apt_internal_elb_id" {
  value = "${aws_security_group.apt_internal_elb.id}"
}

output "sg_backend_elb_internal_id" {
  value = "${aws_security_group.backend_elb_internal.id}"
}

output "sg_backend_elb_external_id" {
  value = "${aws_security_group.backend_elb_external.id}"
}

output "sg_backend_id" {
  value = "${aws_security_group.backend.id}"
}

output "sg_backend-redis_id" {
  value = "${aws_security_group.backend-redis.id}"
}

output "sg_bouncer_internal_elb_id" {
  value = "${aws_security_group.bouncer_internal_elb.id}"
}

output "sg_bouncer_elb_id" {
  value = "${aws_security_group.bouncer_elb.id}"
}

output "sg_bouncer_id" {
  value = "${aws_security_group.bouncer.id}"
}

output "sg_cache_elb_id" {
  value = "${aws_security_group.cache_elb.id}"
}

output "sg_cache_external_elb_id" {
  value = "${aws_security_group.cache_external_elb.id}"
}

output "sg_cache_id" {
  value = "${aws_security_group.cache.id}"
}

output "sg_calendars_carrenza_alb_id" {
  value = "${aws_security_group.calendars_carrenza_alb.id}"
}

output "sg_calculators-frontend_elb_id" {
  value = "${aws_security_group.calculators-frontend_elb.id}"
}

output "sg_calculators-frontend_id" {
  value = "${aws_security_group.calculators-frontend.id}"
}

output "sg_ckan_elb_internal_id" {
  value = "${aws_security_group.ckan_elb_internal.id}"
}

output "sg_ckan_elb_external_id" {
  value = "${aws_security_group.ckan_elb_external.id}"
}

output "sg_ckan_id" {
  value = "${aws_security_group.ckan.id}"
}

output "sg_content-data-api-db-admin_id" {
  value = "${aws_security_group.content-data-api-db-admin.id}"
}

output "sg_content-data-api-postgresql-primary_id" {
  value = "${aws_security_group.content-data-api-postgresql-primary.id}"
}

output "sg_content-store_external_elb_id" {
  value = "${aws_security_group.content-store_external_elb.id}"
}

output "sg_content-store_internal_elb_id" {
  value = "${aws_security_group.content-store_internal_elb.id}"
}

output "sg_content-store_id" {
  value = "${aws_security_group.content-store.id}"
}

output "sg_db-admin_elb_id" {
  value = "${aws_security_group.db-admin_elb.id}"
}

output "sg_db-admin_id" {
  value = "${aws_security_group.db-admin.id}"
}

output "sg_deploy_elb_id" {
  value = "${aws_security_group.deploy_elb.id}"
}

output "sg_deploy_internal_elb_id" {
  value = "${aws_security_group.deploy_internal_elb.id}"
}

output "sg_deploy_id" {
  value = "${aws_security_group.deploy.id}"
}

output "sg_docker_management_etcd_elb_id" {
  value = "${aws_security_group.docker_management_etcd_elb.id}"
}

output "sg_docker_management_id" {
  value = "${aws_security_group.docker_management.id}"
}

output "sg_shared_documentdb_id" {
  value = "${aws_security_group.shared-documentdb.id}"
}

output "sg_draft-cache_id" {
  value = "${aws_security_group.draft-cache.id}"
}

output "sg_draft-cache_elb_id" {
  value = "${aws_security_group.draft-cache_elb.id}"
}

output "sg_draft-cache_external_elb_id" {
  value = "${aws_security_group.draft-cache_external_elb.id}"
}

output "sg_draft-content-store_external_elb_id" {
  value = "${aws_security_group.draft-content-store_external_elb.id}"
}

output "sg_draft-content-store_internal_elb_id" {
  value = "${aws_security_group.draft-content-store_internal_elb.id}"
}

output "sg_draft-content-store_id" {
  value = "${aws_security_group.draft-content-store.id}"
}

output "sg_draft-frontend_elb_id" {
  value = "${aws_security_group.draft-frontend_elb.id}"
}

output "sg_draft-frontend_id" {
  value = "${aws_security_group.draft-frontend.id}"
}

output "sg_elasticsearch6_id" {
  value = "${aws_security_group.elasticsearch6.id}"
}

output "sg_email-alert-api_elb_internal_id" {
  value = "${aws_security_group.email-alert-api_elb_internal.id}"
}

output "sg_email-alert-api_elb_external_id" {
  value = "${aws_security_group.email-alert-api_elb_external.id}"
}

output "sg_email-alert-api_id" {
  value = "${aws_security_group.email-alert-api.id}"
}

output "sg_feedback_elb_id" {
  value = "${aws_security_group.feedback_elb.id}"
}

output "sg_frontend_elb_id" {
  value = "${aws_security_group.frontend_elb.id}"
}

output "sg_frontend_id" {
  value = "${aws_security_group.frontend.id}"
}

output "sg_gatling_id" {
  value = "${aws_security_group.gatling.id}"
}

output "sg_gatling_external_elb_id" {
  value = "${aws_security_group.gatling_external_elb.id}"
}

output "sg_graphite_id" {
  value = "${aws_security_group.graphite.id}"
}

output "sg_prometheus_id" {
  value = "${aws_security_group.prometheus.id}"
}

output "sg_graphite_external_elb_id" {
  value = "${aws_security_group.graphite_external_elb.id}"
}

output "sg_prometheus_external_elb_id" {
  value = "${aws_security_group.prometheus_external_elb.id}"
}

output "sg_graphite_internal_elb_id" {
  value = "${aws_security_group.graphite_internal_elb.id}"
}

output "sg_jumpbox_id" {
  value = "${aws_security_group.jumpbox.id}"
}

output "sg_licensify_documentdb_id" {
  value = "${aws_security_group.licensify_documentdb.id}"
}

output "sg_licensify-frontend_external_elb_id" {
  value = "${aws_security_group.licensify-frontend_external_elb.id}"
}

output "sg_licensify-frontend_internal_lb_id" {
  value = "${aws_security_group.licensify-frontend_internal_lb.id}"
}

output "sg_licensify-frontend_id" {
  value = "${aws_security_group.licensify-frontend.id}"
}

output "sg_licensify-backend_external_elb_id" {
  value = "${aws_security_group.licensify-backend_external_elb.id}"
}

output "sg_licensify-backend_internal_elb_id" {
  value = "${aws_security_group.licensify-backend_internal_elb.id}"
}

output "sg_licensify-backend_id" {
  value = "${aws_security_group.licensify-backend.id}"
}

output "sg_mapit_id" {
  value = "${aws_security_group.mapit.id}"
}

output "sg_mapit_carrenza_alb_id" {
  value = "${aws_security_group.mapit_carrenza_alb.id}"
}

output "sg_mapit_elb_id" {
  value = "${aws_security_group.mapit_elb.id}"
}

output "sg_management_id" {
  value = "${aws_security_group.management.id}"
}

output "sg_mirrorer_id" {
  value = "${aws_security_group.mirrorer.id}"
}

output "sg_mongo_id" {
  value = "${aws_security_group.mongo.id}"
}

output "sg_monitoring_id" {
  value = "${aws_security_group.monitoring.id}"
}

output "sg_monitoring_external_elb_id" {
  value = "${aws_security_group.monitoring_external_elb.id}"
}

output "sg_monitoring_internal_elb_id" {
  value = "${aws_security_group.monitoring_internal_elb.id}"
}

output "sg_mysql-primary_id" {
  value = "${aws_security_group.mysql-primary.id}"
}

output "sg_mysql-replica_id" {
  value = "${aws_security_group.mysql-replica.id}"
}

output "sg_publishing-api_elb_internal_id" {
  value = "${aws_security_group.publishing-api_elb_internal.id}"
}

output "sg_publishing-api_elb_external_id" {
  value = "${aws_security_group.publishing-api_elb_external.id}"
}

output "sg_publishing-api_id" {
  value = "${aws_security_group.publishing-api.id}"
}

output "sg_puppetmaster_elb_id" {
  value = "${aws_security_group.puppetmaster_elb.id}"
}

output "sg_puppetmaster_id" {
  value = "${aws_security_group.puppetmaster.id}"
}

output "sg_rabbitmq_elb_id" {
  value = "${aws_security_group.rabbitmq_elb.id}"
}

output "sg_rabbitmq_id" {
  value = "${aws_security_group.rabbitmq.id}"
}

output "sg_router-api_elb_id" {
  value = "${aws_security_group.router-api_elb.id}"
}

output "sg_router-backend_id" {
  value = "${aws_security_group.router-backend.id}"
}

output "sg_search-api_external_elb_id" {
  value = "${aws_security_group.search-api_external_elb.id}"
}

output "sg_search_elb_id" {
  value = "${aws_security_group.search_elb.id}"
}

output "sg_search_id" {
  value = "${aws_security_group.search.id}"
}

output "sg_static_carrenza_alb_id" {
  value = "${aws_security_group.static_carrenza_alb.id}"
}

output "sg_transition-db-admin_elb_id" {
  value = "${aws_security_group.transition-db-admin_elb.id}"
}

output "sg_transition-db-admin_id" {
  value = "${aws_security_group.transition-db-admin.id}"
}

output "sg_transition-postgresql-primary_id" {
  value = "${aws_security_group.transition-postgresql-primary.id}"
}

output "sg_transition-postgresql-standby_id" {
  value = "${aws_security_group.transition-postgresql-standby.id}"
}

output "sg_offsite_ssh_id" {
  value = "${aws_security_group.offsite_ssh.id}"
}

output "sg_whitehall-backend_external_elb_id" {
  value = "${aws_security_group.whitehall-backend_external_elb.id}"
}

output "sg_whitehall-backend_internal_elb_id" {
  value = "${aws_security_group.whitehall-backend_internal_elb.id}"
}

output "sg_whitehall-backend_id" {
  value = "${aws_security_group.whitehall-backend.id}"
}

output "sg_whitehall-frontend_elb_id" {
  value = "${aws_security_group.whitehall-frontend_elb.id}"
}

output "sg_whitehall-frontend_external_elb_id" {
  value = "${aws_security_group.whitehall-frontend_external_elb.id}"
}

output "sg_whitehall-frontend_id" {
  value = "${aws_security_group.whitehall-frontend.id}"
}

output "sg_aws-vpn_id" {
  value = "${aws_security_group.vpn.*.id}"
}

output "sg_support-api_external_elb_id" {
  value = "${aws_security_group.support-api_external_elb.id}"
}

output "sg_related-links_id" {
  value = "${aws_security_group.related-links.id}"
}

output "sg_knowledge-graph_id" {
  value = "${aws_security_group.knowledge-graph.id}"
}

output "sg_knowledge-graph_elb_external_id" {
  value = "${aws_security_group.knowledge-graph_elb_external.id}"
}
