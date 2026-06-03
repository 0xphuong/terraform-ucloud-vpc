variable "vpc_name" {
  description = "Name of the VPC"
  type        = string

  validation {
    condition     = length(var.vpc_name) >= 3 && length(var.vpc_name) <= 63
    error_message = "vpc_name must be between 3 and 63 characters."
  }
}

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for the VPC (e.g. [\"192.168.0.0/16\"])"
  type        = list(string)

  validation {
    condition     = length(var.vpc_cidr_blocks) > 0
    error_message = "At least one CIDR block must be specified."
  }
  validation {
    condition     = alltrue([for cidr in var.vpc_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "Each cidr_block must be a valid IPv4 CIDR."
  }
}

variable "vpc_tag" {
  description = "Tag assigned to the VPC and subnets"
  type        = string
  default     = "Default"
}

variable "subnets" {
  description = "Map of subnets to create. Key is a logical name."
  type = map(object({
    cidr_block = string
    name       = optional(string)
    tag        = optional(string)
    remark     = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.subnets : can(cidrhost(v.cidr_block, 0))])
    error_message = "Each subnet cidr_block must be a valid IPv4 CIDR."
  }
}

variable "vpc_peering_ids" {
  description = "List of peer VPC IDs to create peering connections with. Set to [] to skip."
  type        = list(string)
  default     = []
}

variable "vips" {
  description = "Map of VIPs to create. Key is a logical name. Each VIP is bound to a subnet in this VPC."
  type = map(object({
    subnet_key = string
    name       = optional(string)
    tag        = optional(string)
    remark     = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.vips : length(v.subnet_key) > 0])
    error_message = "Each VIP must reference a subnet_key."
  }
  validation {
    condition     = alltrue([for k, v in var.vips : contains(keys(var.subnets), v.subnet_key)])
    error_message = "Each VIP's subnet_key must match an existing key in var.subnets."
  }
}
