#!/bin/bash

#
# This script generates the user-data resource and variable
# boilerplate. We've separated it out so it can be run once
# and added to all of our projects that need it.
#

cat << EOH
# == Manifest: ::user-data
#
# This file is generated by $(basename "$0"). DO NOT EDIT
#
# Generate user-data from a list of snippets.
#
# To concatenate the snippets, use:
# \${join("\n", null_resource.user_data.*.triggers.snippet)}
# 
EOH

cat << 'EOT'

variable "user_data_snippets" {
  type        = "list"
  description = "List of user-data snippets"
}

# Resources
# --------------------------------------------------------------

resource "null_resource" "user_data" {
  count = "${length(var.user_data_snippets)}"

  triggers {
    snippet = "${replace(file("../../userdata/${element(var.user_data_snippets, count.index)}"),"ESM_TRUSTY_TOKEN","${var.esm_trusty_token}")}"
  }
}
EOT
