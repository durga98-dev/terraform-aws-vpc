
variable "project_name"{
    default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "public_subnet_cidrs"{
    default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

variable "private_subnet_cidrs" {
  default = [ "10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  default = [ "10.0.21.0/24", "10.0.22.0/24" ]
}

variable "vpc_cidr"{

}

variable "enable_dns_hostnames"{
    default = true
}

variable "project_name" {
  
}

variable "environment" {
  
}

#Mandatory
variable "common_tags"{
    type = map
    default = {}
}

variable "vpc_tags" {
  type = map
  default = {}
}

variable "igw_tags" {
  default = {}
}

variable "public_subnet_tags" {
  default = {}
}

variable "public_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.public_subnet_cidrs)==2
    error_message = "Please provide 2 valid public subnet CIDR"
  }
}

variable "private_subnet_tags" {
  default = {}
}

variable "private_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.private_subnet_cidrs)==2
    error_message = "Please provide 2 valid private subnet CIDR"
  }
}

variable "database_subnet_tags" {
  default = {}
}

variable "database_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.database_subnet_cidrs)==2
    error_message = "Please provide 2 valid private subnet CIDR"
  }
}

variable "natgateway_tags" {
  default = {}
}

variable "public_route_tags" {
  default = {}
}

variable "private_route_tags" {
  default = {}
}

variable "database_route_tags" {
  default = {}
}

variable "is_peering_required" {
  default = false
}

variable "vpc_peering_tags" {
  default = {}
}


