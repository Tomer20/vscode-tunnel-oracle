# terraform-docs

[![Build Status](https://github.com/terraform-docs/terraform-docs/workflows/ci/badge.svg)](https://github.com/terraform-docs/terraform-docs/actions) [![GoDoc](https://pkg.go.dev/badge/github.com/terraform-docs/terraform-docs)](https://pkg.go.dev/github.com/terraform-docs/terraform-docs) [![Go Report Card](https://goreportcard.com/badge/github.com/terraform-docs/terraform-docs)](https://goreportcard.com/report/github.com/terraform-docs/terraform-docs) [![Codecov Report](https://codecov.io/gh/terraform-docs/terraform-docs/branch/master/graph/badge.svg)](https://codecov.io/gh/terraform-docs/terraform-docs) [![License](https://img.shields.io/github/license/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/blob/master/LICENSE) [![Latest release](https://img.shields.io/github/v/release/terraform-docs/terraform-docs)](https://github.com/terraform-docs/terraform-docs/releases)

![terraform-docs-teaser](./images/terraform-docs-teaser.png)

## What is terraform-docs

A utility to generate documentation from Terraform modules in various output formats.

## Installation

macOS users can install using [Homebrew]:

```bash
brew install terraform-docs
```

or

```bash
brew install terraform-docs/tap/terraform-docs
```

Windows users can install using [Scoop]:

```bash
scoop bucket add terraform-docs https://github.com/terraform-docs/scoop-bucket
scoop install terraform-docs
```

or [Chocolatey]:

```bash
choco install terraform-docs
```

Stable binaries are also available on the [releases] page. To install, download the
binary for your platform from "Assets" and place this into your `$PATH`:

```bash
curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.20.0/terraform-docs-v0.20.0-$(uname)-amd64.tar.gz
tar -xzf terraform-docs.tar.gz
chmod +x terraform-docs
mv terraform-docs /usr/local/bin/terraform-docs
```

**NOTE:** Windows releases are in `ZIP` format.

The latest version can be installed using `go install` or `go get`:

```bash
# go1.17+
go install github.com/terraform-docs/terraform-docs@v0.20.0
```

```bash
# go1.16
GO111MODULE="on" go get github.com/terraform-docs/terraform-docs@v0.20.0
```

**NOTE:** please use the latest Go to do this, minimum `go1.16` is required.

This will put `terraform-docs` in `$(go env GOPATH)/bin`. If you encounter the error
`terraform-docs: command not found` after installation then you may need to either add
that directory to your `$PATH` as shown [here] or do a manual installation by cloning
the repo and run `make build` from the repository which will put `terraform-docs` in:

```bash
$(go env GOPATH)/src/github.com/terraform-docs/terraform-docs/bin/$(uname | tr '[:upper:]' '[:lower:]')-amd64/terraform-docs
```

## Usage

### Running the binary directly

To run and generate documentation into README within a directory:

```bash
terraform-docs markdown table --output-file README.md --output-mode inject /path/to/module
```

Check [`output`] configuration for more details and examples.

### Using docker

terraform-docs can be run as a container by mounting a directory with `.tf`
files in it and run the following command:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.20.0 markdown /terraform-docs
```

If `output.file` is not enabled for this module, generated output can be redirected
back to a file:

```bash
docker run --rm --volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.20.0 markdown /terraform-docs > doc.md
```

**NOTE:** Docker tag `latest` refers to _latest_ stable released version and `edge`
refers to HEAD of `master` at any given point in time.

### Using GitHub Actions

To use terraform-docs GitHub Action, configure a YAML workflow file (e.g.
`.github/workflows/documentation.yml`) with the following:

```yaml
name: Generate terraform docs
on:
  - pull_request

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        ref: ${{ github.event.pull_request.head.ref }}

    - name: Render terraform docs and push changes back to PR
      uses: terraform-docs/gh-actions@main
      with:
        working-dir: .
        output-file: README.md
        output-method: inject
        git-push: "true"
```

Read more about [terraform-docs GitHub Action] and its configuration and
examples.

### pre-commit hook

With pre-commit, you can ensure your Terraform module documentation is kept
up-to-date each time you make a commit.

First [install pre-commit] and then create or update a `.pre-commit-config.yaml`
in the root of your Git repo with at least the following content:

```yaml
repos:
  - repo: https://github.com/terraform-docs/terraform-docs
    rev: "v0.20.0"
    hooks:
      - id: terraform-docs-go
        args: ["markdown", "table", "--output-file", "README.md", "./mymodule/path"]
```

Then run:

```bash
pre-commit install
pre-commit install-hooks
```

Further changes to your module's `.tf` files will cause an update to documentation
when you make a commit.

## Configuration

terraform-docs can be configured with a yaml file. The default name of this file is
`.terraform-docs.yml` and the path order for locating it is:

1. root of module directory
1. `.config/` folder at root of module directory
1. current directory
1. `.config/` folder at current directory
1. `$HOME/.tfdocs.d/`

```yaml
formatter: "" # this is required

version: ""

header-from: main.tf
footer-from: ""

recursive:
  enabled: false
  path: modules
  include-main: true

sections:
  hide: []
  show: []

content: ""

output:
  file: ""
  mode: inject
  template: |-
    <!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.12.2 |
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | 7.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 7.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_bastion_bastion.bastion](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/bastion_bastion) | resource |
| [oci_budget_alert_rule.free_tier_alert](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/budget_alert_rule) | resource |
| [oci_budget_budget.free_tier_budget](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/budget_budget) | resource |
| [oci_core_instance.tunnel_instance](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.igw](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.nat](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_nat_gateway) | resource |
| [oci_core_route_table.private_rt](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_route_table) | resource |
| [oci_core_route_table.public_rt](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_route_table) | resource |
| [oci_core_security_list.private_sg](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_security_list) | resource |
| [oci_core_security_list.public_sg](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_security_list) | resource |
| [oci_core_subnet.private_subnet](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_subnet) | resource |
| [oci_core_subnet.public_subnet](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_subnet) | resource |
| [oci_core_vcn.main_vcn](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/core_vcn) | resource |
| [oci_limits_quota.quota_policy](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/resources/limits_quota) | resource |
| [oci_core_images.ubuntu](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_compartment.target](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/data-sources/identity_compartment) | data source |
| [oci_identity_compartments.matching](https://registry.terraform.io/providers/oracle/oci/7.24.0/docs/data-sources/identity_compartments) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_enabled"></a> [bastion\_enabled](#input\_bastion\_enabled) | Whether to enable the OCI Bastion service | `bool` | `true` | no |
| <a name="input_budget_alert_email"></a> [budget\_alert\_email](#input\_budget\_alert\_email) | Email address to send budget alerts. | `string` | n/a | yes |
| <a name="input_compartment_name"></a> [compartment\_name](#input\_compartment\_name) | The name of the compartment to be created. | `string` | n/a | yes |
| <a name="input_compute_ssh_public_key"></a> [compute\_ssh\_public\_key](#input\_compute\_ssh\_public\_key) | Raw SSH public key content. | `string` | n/a | yes |
| <a name="input_enable_strict_limits"></a> [enable\_strict\_limits](#input\_enable\_strict\_limits) | Set to true to enforce strict resource quotas in the compartment. When false, no quota restrictions will be applied. | `bool` | `true` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | The fingerprint for the public key used for OCI CLI. | `string` | n/a | yes |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Display name for the instance. | `string` | `"vscode-tunnel-instance"` | no |
| <a name="input_my_public_ip_cidr"></a> [my\_public\_ip\_cidr](#input\_my\_public\_ip\_cidr) | Your home or office public IPv4 address in CIDR notation (e.g., 203.0.113.42/32). | `string` | `"203.0.113.42/32"` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to the private key for OCI CLI authentication. | `string` | n/a | yes |
| <a name="input_private_subnet_cidr_block"></a> [private\_subnet\_cidr\_block](#input\_private\_subnet\_cidr\_block) | Private subnet CIDR. | `string` | `"10.0.0.0/30"` | no |
| <a name="input_public_subnet_cidr_block"></a> [public\_subnet\_cidr\_block](#input\_public\_subnet\_cidr\_block) | Public subnet CIDR. | `string` | `"10.0.0.8/29"` | no |
| <a name="input_region"></a> [region](#input\_region) | The OCI region to deploy into (e.g., eu-frankfurt-1). | `string` | n/a | yes |
| <a name="input_subnet_display_name"></a> [subnet\_display\_name](#input\_subnet\_display\_name) | Display name of the subnet. | `string` | `"vscode-tunnel-private-subnet"` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | Your Oracle Cloud tenancy OCID. | `string` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | The OCID of the OCI user for authentication. | `string` | n/a | yes |
| <a name="input_vcn_cidr_block"></a> [vcn\_cidr\_block](#input\_vcn\_cidr\_block) | Minimal VCN CIDR block. | `string` | `"10.0.0.0/28"` | no |
| <a name="input_vcn_display_name"></a> [vcn\_display\_name](#input\_vcn\_display\_name) | Display name of the VCN. | `string` | `"vscode-tunnel-vcn"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | OCID of the Bastion service |
| <a name="output_bastion_name"></a> [bastion\_name](#output\_bastion\_name) | Name of the Bastion |
| <a name="output_budget_alert_id"></a> [budget\_alert\_id](#output\_budget\_alert\_id) | OCID of the budget alert rule |
| <a name="output_budget_id"></a> [budget\_id](#output\_budget\_id) | OCID of the created budget |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | OCID of the compute instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | Private IP address of the compute instance |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | OCID of the Internet Gateway |
| <a name="output_nat_gateway_id"></a> [nat\_gateway\_id](#output\_nat\_gateway\_id) | OCID of the NAT Gateway |
| <a name="output_private_route_table_id"></a> [private\_route\_table\_id](#output\_private\_route\_table\_id) | OCID of the private route table |
| <a name="output_private_security_list_id"></a> [private\_security\_list\_id](#output\_private\_security\_list\_id) | OCID of the private security list |
| <a name="output_private_subnet_id"></a> [private\_subnet\_id](#output\_private\_subnet\_id) | OCID of the private subnet |
| <a name="output_public_route_table_id"></a> [public\_route\_table\_id](#output\_public\_route\_table\_id) | OCID of the public route table |
| <a name="output_public_security_list_id"></a> [public\_security\_list\_id](#output\_public\_security\_list\_id) | OCID of the public security list |
| <a name="output_public_subnet_id"></a> [public\_subnet\_id](#output\_public\_subnet\_id) | OCID of the public subnet |
| <a name="output_quota_policy_id"></a> [quota\_policy\_id](#output\_quota\_policy\_id) | OCID of the quota policy applied to the compartment |
| <a name="output_vcn_cidr_block"></a> [vcn\_cidr\_block](#output\_vcn\_cidr\_block) | CIDR block of the VCN |
| <a name="output_vcn_id"></a> [vcn\_id](#output\_vcn\_id) | OCID of the created VCN |
<!-- END_TF_DOCS -->

output-values:
  enabled: false
  from: ""

sort:
  enabled: true
  by: name

settings:
  anchor: true
  color: true
  default: true
  description: false
  escape: true
  hide-empty: false
  html: true
  indent: 2
  lockfile: true
  read-comments: true
  required: true
  sensitive: true
  type: true
```

## Content Template

Generated content can be customized further away with `content` in configuration.
If the `content` is empty the default order of sections is used.

Compatible formatters for customized content are `asciidoc` and `markdown`. `content`
will be ignored for other formatters.

`content` is a Go template with following additional variables:

- `{{ .Header }}`
- `{{ .Footer }}`
- `{{ .Inputs }}`
- `{{ .Modules }}`
- `{{ .Outputs }}`
- `{{ .Providers }}`
- `{{ .Requirements }}`
- `{{ .Resources }}`

and following functions:

- `{{ include "relative/path/to/file" }}`

These variables are the generated output of individual sections in the selected
formatter. For example `{{ .Inputs }}` is Markdown Table representation of _inputs_
when formatter is set to `markdown table`.

Note that sections visibility (i.e. `sections.show` and `sections.hide`) takes
precedence over the `content`.

Additionally there's also one extra special variable avaialble to the `content`:

- `{{ .Module }}`

As opposed to the other variables mentioned above, which are generated sections
based on a selected formatter, the `{{ .Module }}` variable is just a `struct`
representing a [Terraform module].

````yaml
content: |-
  Any arbitrary text can be placed anywhere in the content

  {{ .Header }}

  and even in between sections

  {{ .Providers }}

  and they don't even need to be in the default order

  {{ .Outputs }}

  include any relative files

  {{ include "relative/path/to/file" }}

  {{ .Inputs }}

  # Examples

  ```hcl
  {{ include "examples/foo/main.tf" }}
  ```

  ## Resources

  {{ range .Module.Resources }}
  - {{ .GetMode }}.{{ .Spec }} ({{ .Position.Filename }}#{{ .Position.Line }})
  {{- end }}
````

## Build on top of terraform-docs

terraform-docs primary use-case is to be utilized as a standalone binary, but
some parts of it is also available publicly and can be imported in your project
as a library.

```go
import (
    "github.com/terraform-docs/terraform-docs/format"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/terraform"
)

// buildTerraformDocs for module root `path` and provided content `tmpl`.
func buildTerraformDocs(path string, tmpl string) (string, error) {
    config := print.DefaultConfig()
    config.ModuleRoot = path // module root path (can be relative or absolute)

    module, err := terraform.LoadWithOptions(config)
    if err != nil {
        return "", err
    }

    // Generate in Markdown Table format
    formatter := format.NewMarkdownTable(config)

    if err := formatter.Generate(module); err != nil {
        return "", err
    }

    // // Note: if you don't intend to provide additional template for the generated
    // // content, or the target format doesn't provide templating (e.g. json, yaml,
    // // xml, or toml) you can use `Content()` function instead of `Render()`.
    // // `Content()` returns all the sections combined with predefined order.
    // return formatter.Content(), nil

    return formatter.Render(tmpl)
}
```

## Plugin

Generated output can be heavily customized with [`content`], but if using that
is not enough for your use-case, you can write your own plugin.

In order to install a plugin the following steps are needed:

- download the plugin and place it in `~/.tfdocs.d/plugins` (or `./.tfdocs.d/plugins`)
- make sure the plugin file name is `tfdocs-format-<NAME>`
- modify [`formatter`] of `.terraform-docs.yml` file to be `<NAME>`

**Important notes:**

- if the plugin file name is different than the example above, terraform-docs won't
be able to to pick it up nor register it properly
- you can only use plugin thorough `.terraform-docs.yml` file and it cannot be used
with CLI arguments

To create a new plugin create a new repository called `tfdocs-format-<NAME>` with
following `main.go`:

```go
package main

import (
    _ "embed" //nolint

    "github.com/terraform-docs/terraform-docs/plugin"
    "github.com/terraform-docs/terraform-docs/print"
    "github.com/terraform-docs/terraform-docs/template"
    "github.com/terraform-docs/terraform-docs/terraform"
)

func main() {
    plugin.Serve(&plugin.ServeOpts{
        Name:    "<NAME>",
        Version: "0.1.0",
        Printer: printerFunc,
    })
}

//go:embed sections.tmpl
var tplCustom []byte

// printerFunc the function being executed by the plugin client.
func printerFunc(config *print.Config, module *terraform.Module) (string, error) {
    tpl := template.New(config,
        &template.Item{Name: "custom", Text: string(tplCustom)},
    )

    rendered, err := tpl.Render("custom", module)
    if err != nil {
        return "", err
    }

    return rendered, nil
}
```

Please refer to [tfdocs-format-template] for more details. You can create a new
repository from it by clicking on `Use this template` button.

## Documentation

- **Users**
  - Read the [User Guide] to learn how to use terraform-docs
  - Read the [Formats Guide] to learn about different output formats of terraform-docs
  - Refer to [Config File Reference] for all the available configuration options
- **Developers**
  - Read [Contributing Guide] before submitting a pull request

Visit [our website] for all documentation.

## Community

- Discuss terraform-docs on [Slack]

## License

MIT License - Copyright (c) 2021 The terraform-docs Authors.

[Chocolatey]: https://www.chocolatey.org
[Config File Reference]: https://terraform-docs.io/user-guide/configuration/
[`content`]: https://terraform-docs.io/user-guide/configuration/content/
[Contributing Guide]: CONTRIBUTING.md
[Formats Guide]: https://terraform-docs.io/reference/terraform-docs/
[`formatter`]: https://terraform-docs.io/user-guide/configuration/formatter/
[here]: https://golang.org/doc/code.html#GOPATH
[Homebrew]: https://brew.sh
[install pre-commit]: https://pre-commit.com/#install
[`output`]: https://terraform-docs.io/user-guide/configuration/output/
[releases]: https://github.com/terraform-docs/terraform-docs/releases
[Scoop]: https://scoop.sh/
[Slack]: https://slack.terraform-docs.io/
[terraform-docs GitHub Action]: https://github.com/terraform-docs/gh-actions
[Terraform module]: https://pkg.go.dev/github.com/terraform-docs/terraform-docs/terraform#Module
[tfdocs-format-template]: https://github.com/terraform-docs/tfdocs-format-template
[our website]: https://terraform-docs.io/
[User Guide]: https://terraform-docs.io/user-guide/introduction/
