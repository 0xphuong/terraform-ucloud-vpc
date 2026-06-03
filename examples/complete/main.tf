# Primary VPC with subnets and peering to a secondary VPC
module "vpc_primary" {
  source = "github.com/0xphuong/terraform-ucloud-vpc?ref=v1.0.0"

  vpc_name        = "prod-vpc"
  vpc_cidr_blocks = ["10.0.0.0/16"]
  vpc_tag         = "production"

  subnets = {
    public_subnet = {
      cidr_block = "10.0.1.0/24"
      name       = "public-subnet"
      tag        = "production"
    }
    private_subnet = {
      cidr_block = "10.0.2.0/24"
      name       = "private-subnet"
      tag        = "production"
    }
    database_subnet = {
      cidr_block = "10.0.3.0/24"
      name       = "database-subnet"
      tag        = "production"
      remark     = "Dedicated subnet for database tier"
    }
  }

  # Peering to secondary VPC (e.g. shared services VPC)
  vpc_peering_ids = [module.vpc_secondary.vpc_id]

  # VIPs — each VIP is bound to a subnet key defined above
  vips = {
    lb-vip = {
      subnet_key = "public_subnet"
      name       = "prod-lb-vip"
      tag        = "production"
      remark     = "VIP for load balancer"
    }
    db-vip = {
      subnet_key = "database_subnet"
      name       = "prod-db-vip"
      tag        = "production"
    }
  }
}

# Secondary VPC (shared services)
module "vpc_secondary" {
  source = "github.com/0xphuong/terraform-ucloud-vpc?ref=v1.0.0"

  vpc_name        = "shared-services-vpc"
  vpc_cidr_blocks = ["172.16.0.0/16"]
  vpc_tag         = "shared"

  subnets = {
    services_subnet = {
      cidr_block = "172.16.1.0/24"
      name       = "services-subnet"
    }
  }
}

output "primary_vpc_id"      { value = module.vpc_primary.vpc_id }
output "primary_subnet_ids"  { value = module.vpc_primary.subnet_ids }
output "primary_peering_ids" { value = module.vpc_primary.peering_ids }
output "primary_vip_ids"     { value = module.vpc_primary.vip_ids }
output "primary_vip_ips"     { value = module.vpc_primary.vip_ips }
output "secondary_vpc_id"    { value = module.vpc_secondary.vpc_id }
