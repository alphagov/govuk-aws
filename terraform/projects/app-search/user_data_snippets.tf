variable "user_data_snippets" {
  type        = list(any)
  description = "List of user-data snippets"
}

variable "esm_trusty_token" {}

# Generates user-data from a list of snippets. To concatenate the snippets, use:
#     join("\n", null_resource.user_data[*].triggers.snippet)
resource "null_resource" "user_data" {
  count = length(var.user_data_snippets)

  triggers = {
    snippet = replace(file("../../userdata/${element(var.user_data_snippets, count.index)}"), "ESM_TRUSTY_TOKEN", var.esm_trusty_token)
  }
}
