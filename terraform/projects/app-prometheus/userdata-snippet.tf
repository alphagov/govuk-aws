# == Manifest: ::user-data
#
# This file is generated by generate-user-data-boiler-plate.sh. DO NOT EDIT
#
# Generate user-data from a list of snippets.
#
# To concatenate the snippets, use:
# ${join("\n", null_resource.user_data.*.triggers.snippet)}
# 

variable "user_data_snippets" {
  type        = list(string)
  description = "List of user-data snippets"
}

# Resources
# --------------------------------------------------------------

resource "null_resource" "user_data" {
  count = length(var.user_data_snippets)

  triggers {
    snippet = file("../../userdata/${element(var.user_data_snippets, count.index)}")
  }
}
