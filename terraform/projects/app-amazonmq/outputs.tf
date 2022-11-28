output "broker_id" {
  description = "AWS-generated unique identifier for the broker"
  value       = aws_mq_broker.publishing_amazonmq.id
}

output "console_url" {
  description = "URL of the RabbitMQ web management UI"
  value       = aws_mq_broker.publishing_amazonmq.instances.0.console_url
}

output "endpoint" {
  description = "AMQP URL for connecting a client app to the broker"
  value       = aws_mq_broker.publishing_amazonmq.instances.0.endpoints.0
}
