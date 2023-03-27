variable "remote_state_infra_networking_key_stack" {
  type        = "string"
  description = "Override infra_networking remote state path"
  default     = ""
}

# Resources
# --------------------------------------------------------------

data "terraform_remote_state" "infra_networking" {
  backend = "s3"

  config = {
    bucket = "${var.remote_state_bucket}"
    key    = "${coalesce(var.remote_state_infra_networking_key_stack, var.stackname)}/infra-networking.tfstate"
    region = "${var.aws_region}"
  }
}
