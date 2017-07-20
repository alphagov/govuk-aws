
"stackname" = "govuk"
"remote_state_infra_vpc_key_stack" = "govuk"

"public_subnet_cidrs" = {
  "govuk_public_a" = "10.1.1.0/24"
  "govuk_public_b" = "10.1.2.0/24"
  "govuk_public_c" = "10.1.3.0/24"
}

"public_subnet_availability_zones" = {
  "govuk_public_a" = "eu-west-1a"
  "govuk_public_b" = "eu-west-1b"
  "govuk_public_c" = "eu-west-1c"
}

"public_subnet_nat_gateway_enable" = [ "govuk_public_a", "govuk_public_b", "govuk_public_c" ]

"private_subnet_cidrs" = {
  "govuk_private_a" = "10.1.4.0/24"
  "govuk_private_b" = "10.1.5.0/24"
  "govuk_private_c" = "10.1.6.0/24"
}

"private_subnet_elasticache_cidrs" = {
  "govuk_elasticache_private_a" = "10.1.7.0/24"
  "govuk_elasticache_private_b" = "10.1.8.0/24"
  "govuk_elasticache_private_c" = "10.1.9.0/24"
}

"private_subnet_availability_zones" = {
  "govuk_private_a" = "eu-west-1a"
  "govuk_private_b" = "eu-west-1b"
  "govuk_private_c" = "eu-west-1c"
}

"private_subnet_elasticache_availability_zones" = {
  "govuk_elasticache_private_a" = "eu-west-1a"
  "govuk_elasticache_private_b" = "eu-west-1b"
  "govuk_elasticache_private_c" = "eu-west-1c"
}

"private_subnet_nat_gateway_association" = {
  "govuk_private_a" = "govuk_public_a"
  "govuk_private_b" = "govuk_public_b"
  "govuk_private_c" = "govuk_public_c"
}

"private_subnet_rds_cidrs" = {
  "govuk_rds_private_a" = "10.1.10.0/24"
  "govuk_rds_private_b" = "10.1.11.0/24"
  "govuk_rds_private_c" = "10.1.12.0/24"
}

"private_subnet_rds_availability_zones" = {
  "govuk_rds_private_a" = "eu-west-1a"
  "govuk_rds_private_b" = "eu-west-1b"
  "govuk_rds_private_c" = "eu-west-1c"
}
