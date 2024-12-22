resource "aws_vpc" "main" {
  cidr_block       = var.robobshop_vpc_cidr
#enable dns hostenames  this will give default hostnames for server
enable_dns_hostnames = true
# proper tagging is very important in resource utilization
# tags = merge(var.common_tags, var.vpc_tags) 
# the above line will merge two tags and if anything is common the vpc_tags value
# will be taken instead of merging both values
tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
        Name = local.name
        }
    )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  
  
  tags = merge(var.common_tags,
    var.igw_tags,
    {
      Name = "${local.name}-igw"
    }
  )
}