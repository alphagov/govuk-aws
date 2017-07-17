"public_subnet_cidrs" = {
  "govuk_public_a" = "10.4.1.0/24"
  "govuk_public_b" = "10.4.2.0/24"
  "govuk_public_c" = "10.4.3.0/24"
}

"public_subnet_availability_zones" = {
  "govuk_public_a" = "eu-west-1a"
  "govuk_public_b" = "eu-west-1b"
  "govuk_public_c" = "eu-west-1c"
}

"public_subnet_nat_gateway_enable" = [ "govuk_public_a", "govuk_public_b", "govuk_public_c" ]

"private_subnet_cidrs" = {
  "govuk_private_a" = "10.4.4.0/24"
  "govuk_private_b" = "10.4.5.0/24"
  "govuk_private_c" = "10.4.6.0/24"
}

"private_subnet_elasticache_cidrs" = {
  "govuk_elasticache_private_a" = "10.4.7.0/24"
  "govuk_elasticache_private_b" = "10.4.8.0/24"
  "govuk_elasticache_private_c" = "10.4.9.0/24"
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

