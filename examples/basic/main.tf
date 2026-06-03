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

output "vpc_id"     { value = module.vpc.vpc_id }
output "subnet_ids" { value = module.vpc.subnet_ids }
