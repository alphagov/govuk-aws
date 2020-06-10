# 13. Userdata provisioning snippets

Date: 2017-07-14

## Status

Pending

## Context

Our provisioning process with Terraform uses a user_data script to customise
the installation during the instance initialisation. Parts of this customisation
will be common to most projects, for instance, install the puppet client,
apply package updates, add external disks, etc.

At the moment, the node_group module takes a parameter for a default user_data
script, and optionally accepts another parameter for an additional script that
is appended to the default one. We've been adding common customisation to the
default user_data script in the node_group module, and adding similar code in 
additional user_data scripts within the project modules.

This is a problem because the default user_data script in the node_group module
is becoming very specific for GOV.UK use, and we are repeating a lot of code in
the additional user_data scripts.

## Decision

Add a userdata-snippets directory to the root Terraform directory with parts of scripts
that can be concatenated to create the additional user_data script for each project.
We can use a variable that accepts a list of parts that need to be concatenated so
the final script can be customised for each project.

All the user_data snippets live in this directory so we can easily locate and maintain
provisioning scripts.

The default user_data script in the node_group module should be very generic, probably
just a header for the type of script we are appending afterwards.

## Consequences

We are adding a little bit of logic to the project code to evaluate the variable with
the list of snippets and concatenate the parts into the additional_user_data parameter
passed to the node_group module.

The snippet scripts need to use a numeric prefix to make sure parts are concatenated in
the right order.
