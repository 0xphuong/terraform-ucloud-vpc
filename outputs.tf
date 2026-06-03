output "vpc_id" {
  description = "The ID of the VPC"
  value       = ucloud_vpc.this.id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = ucloud_vpc.this.name
}

output "vpc_cidr_blocks" {
  description = "The CIDR blocks of the VPC"
  value       = ucloud_vpc.this.cidr_blocks
}

output "subnet_ids" {
  description = "Map of subnet logical name => subnet ID"
  value       = { for k, s in ucloud_subnet.this : k => s.id }
}

output "subnet_cidrs" {
  description = "Map of subnet logical name => subnet CIDR"
  value       = { for k, s in ucloud_subnet.this : k => s.cidr_block }
}

output "peering_ids" {
  description = "Map of peer VPC ID => peering connection ID"
  value       = { for k, p in ucloud_vpc_peering_connection.this : k => p.id }
}

output "vip_ids" {
  description = "Map of VIP logical name => VIP ID"
  value       = { for k, v in ucloud_vip.this : k => v.id }
}

output "vip_ips" {
  description = "Map of VIP logical name => VIP IP address"
  value       = { for k, v in ucloud_vip.this : k => v.ip_address }
}
