resource "ucloud_vpc" "this" {
  name        = var.vpc_name
  cidr_blocks = var.vpc_cidr_blocks
  tag         = var.vpc_tag
}

resource "ucloud_subnet" "this" {
  for_each = var.subnets

  cidr_block = each.value.cidr_block
  vpc_id     = ucloud_vpc.this.id
  name       = each.value.name != null ? each.value.name : each.key
  tag        = each.value.tag != null ? each.value.tag : var.vpc_tag

  # Optional
  remark = each.value.remark != null ? each.value.remark : null
}

resource "ucloud_vpc_peering_connection" "this" {
  for_each = toset(var.vpc_peering_ids)

  vpc_id      = ucloud_vpc.this.id
  peer_vpc_id = each.value
}
