output "broker_id" {
  description = "AWS-generated unique identifier for the broker"
  value       = aws_mq_broker.publishing_amazonmq.id
}

output "console_url" {
  description = "URL of the RabbitMQ web management UI"
  value       = aws_mq_broker.publishing_amazonmq.instances.0.console_url
}

output "amqp_endpoint" {
  description = "AMQP URL for connecting a client app to the broker"
  value       = aws_mq_broker.publishing_amazonmq.instances.0.endpoints.0
}

#----------------------------------------------------------------------
# These outputs are marked sensitive, so will not be shown in STDOUT 
# by default. To retrieve them, use `terraform output -json`
output "publishing_amazonmq_passwords" {
  description = "Generated passwords for each RabbitMQ user account. Use `terraform output -json | jq '.publishing_amazonmq_passwords.value'` to retrieve the values."
  sensitive   = true
  value       = local.publishing_amazonmq_passwords
}