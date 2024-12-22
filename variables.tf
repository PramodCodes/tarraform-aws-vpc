variable "robobshop_vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
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