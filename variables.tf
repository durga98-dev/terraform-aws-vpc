variable "project_name" {
  
}

variable "environment" {
  
}

variable "vpc_cidr"{
  
}

variable "enable_dnshostnames"{
  default = true
}

# Mandatory
variable "common_tags" {
  
}

# Flexibility for the user to add more tags - optional.
variable "vpc_tags" {
  default = {}
}

variable "igw_tags" {
  default = {}
}

variable "public_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "Must provide two valid public subnet CIDR"
  }
}

variable "private_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "Must provide two valid private subnet CIDR"
  }
}

variable "db_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.db_subnet_cidrs) == 2
    error_message = "Must provide two valid db subnet CIDR"
  }
}

variable "public_subnet_tags" {
  default = {}
}

variable "private_subnet_tags" {
  default = {}
}

variable "db_subnet_tags" {
  default = {}
}

variable "nat_gw_tags" {
  default = {}
}

variable "public_routetable_tags" {
  default = {}
}

variable "private_routetable_tags" {
  default = {}
}

variable "database_routetable_tags" {
  default = {}
}

variable "is_peering_required" {
  default = false
}

variable "vpc_peering_tags" {
  default = {}
}

