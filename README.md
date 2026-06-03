# terraform-ucloud-vpc

Terraform module to create a **VPC**, **Subnets**, and optional **VPC Peering Connections** on [UCloud](https://www.ucloud.cn).

## Features

- Creates a UCloud VPC with one or more CIDR blocks
- Creates multiple subnets via a map input
- Optional VPC peering connections to other VPCs
- Input validation for CIDR blocks and name length
- Structured outputs: VPC ID, subnet IDs, subnet CIDRs, peering IDs

## Usage

### Basic

```hcl
module "vpc" {
  source = "github.com/0xphuong/terraform-ucloud-vpc?ref=v1.0.0"

  vpc_name        = "my-vpc"
  vpc_cidr_blocks = ["192.168.0.0/16"]

  subnets = {
    public = {
      cidr_block = "192.168.1.0/24"
      name       = "public-subnet"
    }
    private = {
      cidr_block = "192.168.2.0/24"
      name       = "private-subnet"
    }
  }
}
```

### Complete — with peering

```hcl
module "vpc_primary" {
  source = "github.com/0xphuong/terraform-ucloud-vpc?ref=v1.0.0"

  vpc_name        = "prod-vpc"
  vpc_cidr_blocks = ["10.0.0.0/16"]
  vpc_tag         = "production"

  subnets = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      name       = "public-subnet"
    }
    private_subnet = {
      cidr_block = "10.0.2.0/24"
      name       = "private-subnet"
    }
    database_subnet = {
      cidr_block = "10.0.3.0/24"
      name       = "database-subnet"
      remark     = "Dedicated subnet for database tier"
    }
  }

  vpc_peering_ids = [module.vpc_secondary.vpc_id]
}

module "vpc_secondary" {
  source = "github.com/0xphuong/terraform-ucloud-vpc?ref=v1.0.0"

  vpc_name        = "shared-services-vpc"
  vpc_cidr_blocks = ["172.16.0.0/16"]

  subnets = {
    services = {
      cidr_block = "172.16.1.0/24"
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| ucloud | >= 1.24.0 |

## Providers

| Name | Version |
|------|---------|
| ucloud | >= 1.24.0 |

## Resources

| Name | Type |
|------|------|
| ucloud_vpc.this | resource |
| ucloud_subnet.this | resource |
| ucloud_vpc_peering_connection.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc\_name | Name of the VPC (3–63 characters) | `string` | — | **yes** |
| vpc\_cidr\_blocks | List of CIDR blocks for the VPC | `list(string)` | — | **yes** |
| subnets | Map of subnets to create | `map(object)` | `{}` | no |
| vpc\_tag | Tag for the VPC and subnets | `string` | `"Default"` | no |
| vpc\_peering\_ids | List of peer VPC IDs to create peering connections with | `list(string)` | `[]` | no |

### `subnets` map value

| Field | Type | Default | Required | Description |
|-------|------|---------|----------|-------------|
| `cidr_block` | `string` | — | **yes** | Subnet CIDR (must be within vpc\_cidr\_blocks) |
| `name` | `string` | key name | no | Subnet display name |
| `tag` | `string` | `vpc_tag` | no | Override tag for this subnet |
| `remark` | `string` | `null` | no | Subnet remarks |

## Outputs

| Name | Description |
|------|-------------|
| vpc\_id | The ID of the VPC |
| vpc\_name | The name of the VPC |
| vpc\_cidr\_blocks | The CIDR blocks of the VPC |
| subnet\_ids | Map of subnet logical name => subnet ID |
| subnet\_cidrs | Map of subnet logical name => subnet CIDR |
| peering\_ids | Map of peer VPC ID => peering connection ID |
<!-- END_TF_DOCS -->

## Examples

- [Basic](./examples/basic) — VPC with 2 subnets
- [Complete](./examples/complete) — 2 VPCs with subnets and peering

## Changelog

See [CHANGELOG.md](./CHANGELOG.md).

## License

[MIT](./LICENSE)
