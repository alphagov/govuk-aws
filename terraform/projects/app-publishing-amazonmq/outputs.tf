output "broker_id" {
  description = "AWS-generated unique identifier for the broker"
  value       = aws_mq_broker.publishing_amazonmq.id
}

output "console_url" {
  description = "URL of the RabbitMQ web management UI"
  value       = aws_mq_broker.publishing_amazonmq.instances[0].console_url
}

output "amqp_endpoint" {
  description = "AMQP URL for connecting a client app to the broker"
  value       = aws_mq_broker.publishing_amazonmq.instances[0].endpoints[0]
}

output "internal_domain_name" {
  description = "Persistent internal domain name for the broker. Use this as the hostname for RabbitMQ connection strings in client apps."
  value       = aws_route53_record.publishing_amazonmq_internal_root_domain_name.fqdn
}

# Use `terraform output -json` to retrieve these sensitive=true outputs.
output "publishing_amazonmq_passwords" {
  description = "Generated passwords for each RabbitMQ user account. Use `terraform output -json | jq '.publishing_amazonmq_passwords.value'` to retrieve the values."
  sensitive   = true
  value       = { for user, pw in random_password.mq_user : user => pw.result }
}

output "lambda_function_name" {
  description = "Name of the Lambda function which posts config to AmazonMQ after creation"
  value       = aws_lambda_function.post_config_to_amazonmq.function_name
}

output "lambda_function_result" {
  value = jsondecode(data.aws_lambda_invocation.post_config_to_amazonmq.result)
}
