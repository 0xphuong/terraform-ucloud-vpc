# Changelog

All notable changes to this module will be documented here.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-04-29

### Added
- Validation: each VIP's `subnet_key` must reference an existing key in `var.subnets`

## [1.1.0] - 2026-04-29

### Added
- `vips` variable — map of VIPs bound to subnets in this VPC
- `ucloud_vip` resource: creates VIP per entry, bound via `subnet_key` reference
- Outputs: `vip_ids` (map of name => ID), `vip_ips` (map of name => IP address)
- Per-VIP: optional `name` (fallback to key), `tag` (fallback to `vpc_tag`), `remark`

### Changed
- Provider version constraint: `>= 1.24.0` → `>= 1.39.5`

## [1.0.0] - 2026-04-29

### Added
- Initial release
- `ucloud_vpc` resource with multi-CIDR support via `vpc_cidr_blocks`
- `ucloud_subnet` resource supporting multiple subnets via `for_each` map
- `ucloud_vpc_peering_connection` resource — optional, via `vpc_peering_ids` list
- Input validation: CIDR format, name length (3–63 chars)
- Per-subnet: optional `name`, `tag`, `remark` fields; inherits `vpc_tag` if not set
- Outputs: `vpc_id`, `vpc_name`, `vpc_cidr_blocks`, `subnet_ids`, `subnet_cidrs`, `peering_ids`
- Examples: `basic` (VPC + 2 subnets), `complete` (2 VPCs with peering)
- GitHub Actions CI: fmt, validate
