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

# creation of subnets in terraform
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.name}-public-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${local.name}-private-${local.az_names[count.index]}"
    }
  )
}