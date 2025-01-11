variable "robobshop_vpc_cidr" {
  type = string
  # default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type = bool
  default = true
}

variable "common_tags" {
    type = map
    default = {} # if empty its optional  
}

variable "vpc_tags" {
    type = map
    default = {} # if empty its optional  
}

variable "project_name" {
    type = string
}

variable "project_environment" {
    type = string
}
variable "igw_tags" {
    type = map
    default = {}
}
variable "public_subnet_tags" {
    type = map
    default = {}
}

variable "private_subnet_tags" {
    type = map
    default = {}
}

variable "database_subnet_tags" {
    type = map
    default = {}
}

variable "public_subnet_cidr" {
  type = list # if we give string we cant handle a list 
# if user provides bad input (list of 1 or 3 instead of 2 ) we must throw error 
  validation {
    condition = length(var.public_subnet_cidr) == 2
    error_message = "size of public subnet cidr must be 2 , check and provide valid cidr"
  }
}

variable "private_subnet_cidr" {
  type = list
#   default = [] if we enable this list is null by default so validation cannot be done so defeats purpose 
  validation {
    condition = length(var.private_subnet_cidr) == 2
    error_message = "size of private subnet cidr must be 2 , check and provide valid cidr"
  }
}

variable "database_subnet_cidr" {
  type = list
#   default = [] if we enable this list is null by default so validation cannot be done so defeats purpose 
  validation {
    condition = length(var.database_subnet_cidr) == 2
    error_message = "size of database subnet cidr must be 2 , check and provide valid cidr"
  }
}

variable "aws_nat_gateway_tags" {
  type = map
  default = {}
}

variable "public_routetable_tags" {
  type = map
  default = {}
}

variable "private_routetable_tags" {
  type = map
  default = {}
}
variable "database_routetable_tags" {
  type = map
  default = {}
}

variable "vpc_peering_tags" {
  type = map
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "peering_vpc_id" {
  type = string
  default = ""
}
