output "broker_id" {
  value = aws_mq_broker.publishing_amazonmq.id
}

output "console_url" {
  value = aws_mq_broker.publishing_amazonmq.instances.0.console_url
}

output "endpoint" {
  value = aws_mq_broker.publishing_amazonmq.instances.0.endpoints.0
}
