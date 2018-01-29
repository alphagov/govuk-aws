## Styleguide

Please follow this style guide when developing in the repository:

1. The `main.tf` file should contain a comment with the module or project name, and
a small description:

```
/**
* ## Module: my-module
*
* This module does super awesome things
*/
```

2. Where possible, put variables and outputs within `main.tf`. Variables should be
included at the beginning of the manifest, and outputs should be included at the end.
If the project contains a large number of outputs, include these in a separate `outputs.tf`
file.

3. Include a backend file named `<environment>.<stackname>.backend` (you may
use the [create-backends tool](../../tools/create-backends.sh) to do this)

4. Generate [`remote_state.tf`](../../tools/generate-remote-state-boiler-plate.sh)
and [`user_data_snippets.tf`](../../tools/generate-user-data-boiler-plate.sh) files.

5. Run `terraform fmt` across your manifests.

6. Install `terraform-docs` with Homebrew and [generate docs for the new Terraform](../../tools/update-docs.sh).
