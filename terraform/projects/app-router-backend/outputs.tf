output "router_backend_1_service_dns_name" {
  value       = aws_route53_record.router-backend_1_service_record.fqdn
  description = "DNS name to access the Router Mongo 1 internal service"
}

output "router_backend_2_service_dns_name" {
  value       = aws_route53_record.router-backend_2_service_record.fqdn
  description = "DNS name to access the Router Mongo 2 internal service"
}

output "router_backend_3_service_dns_name" {
  value       = aws_route53_record.router-backend_3_service_record.fqdn
  description = "DNS name to access the Router Mongo 3 internal service"
}
