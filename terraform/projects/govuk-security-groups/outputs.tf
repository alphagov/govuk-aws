#
# Outputs of the security group project
#

output "sg_jumpbox_id" {
  value = "${aws_security_group.jumpbox.id}"
}

output "sg_management_id" {
  value = "${aws_security_group.management.id}"
}

output "sg_offsite_ssh_id" {
  value = "${aws_security_group.offsite_ssh.id}"
}

output "sg_puppetmaster_id" {
  value = "${aws_security_group.puppetmaster.id}"
}

output "sg_puppetmaster_elb_id" {
  value = "${aws_security_group.puppetmaster_elb.id}"
}

output "sg_deploy_id" {
  value = "${aws_security_group.deploy.id}"
}

output "sg_deploy_elb_id" {
  value = "${aws_security_group.deploy_elb.id}"
}

output "sg_monitoring_id" {
  value = "${aws_security_group.monitoring.id}"
}

output "sg_monitoring_elb_id" {
  value = "${aws_security_group.monitoring_elb.id}"
}

output "sg_docker_management_id" {
  value = "${aws_security_group.docker_management.id}"
}

output "sg_docker_management_etcd_elb_id" {
  value = "${aws_security_group.docker_management_etcd_elb.id}"
}

output "sg_frontend_id" {
  value = "${aws_security_group.frontend.id}"
}

output "sg_frontend_elb_id" {
  value = "${aws_security_group.frontend_elb.id}"
}

output "sg_graphite_id" {
  value = "${aws_security_group.graphite.id}"
}

output "sg_graphite_internal_elb_id" {
  value = "${aws_security_group.graphite_internal_elb.id}"
}

output "sg_graphite_external_elb_id" {
  value = "${aws_security_group.graphite_external_elb.id}"
}

output "sg_cache_id" {
  value = "${aws_security_group.cache.id}"
}

output "sg_cache_elb_id" {
  value = "${aws_security_group.cache_elb.id}"
}

output "sg_frontend-lb_id" {
  value = "${aws_security_group.frontend-lb.id}"
}

output "sg_frontend-lb_elb_id" {
  value = "${aws_security_group.frontend-lb_elb.id}"
}

output "sg_backend-lb_id" {
  value = "${aws_security_group.backend-lb.id}"
}

output "sg_backend-lb_elb_id" {
  value = "${aws_security_group.backend-lb_elb.id}"
}

output "sg_api-lb_id" {
  value = "${aws_security_group.api-lb.id}"
}

output "sg_api-lb_elb_id" {
  value = "${aws_security_group.api-lb_elb.id}"
}

output "sg_logging_id" {
  value = "${aws_security_group.logging.id}"
}

output "sg_logging_elb_id" {
  value = "${aws_security_group.logging_elb.id}"
}

output "sg_logs-elasticsearch_id" {
  value = "${aws_security_group.logs-elasticsearch.id}"
}

output "sg_logs-elasticsearch_elb_id" {
  value = "${aws_security_group.logs-elasticsearch_elb.id}"
}

output "sg_logs-redis_id" {
  value = "${aws_security_group.logs-redis.id}"
}

output "sg_api-redis_id" {
  value = "${aws_security_group.api-redis.id}"
}

output "sg_backend-redis_id" {
  value = "${aws_security_group.backend-redis.id}"
}

output "sg_draft-cache_id" {
  value = "${aws_security_group.draft-cache.id}"
}

output "sg_draft-cache_elb_id" {
  value = "${aws_security_group.draft-cache_elb.id}"
}
