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


#Database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_tags,
    {
      Name = "${local.name}-database-${local.az_names[count.index]}"
    }
  )
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id # since its a list

  tags = merge(
    var.common_tags,
    var.aws_nat_gateway_tags,
    {
    Name = "${local.name}-NAT"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#public routetable

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.public_routetable_tags,
    {
      Name = "${local.name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.private_routetable_tags,
    {
      Name = "${local.name}-private"
    }
  )
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    var.database_routetable_tags,
    {
      Name = "${local.name}-database"
    }
  )
}
# Resource: aws_route Provides a resource to create a routing table entry (a route) in a VPC routing table.
resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NAT.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.NAT.id
}

#association of routes

resource "aws_route_table_association" "public"  {
  count =  length(var.private_subnet_cidr) # to get iteration count 
  subnet_id      = element(aws_subnet.public[*].id, count.index) #this function returns the element 
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private"  {
  count =  length(var.private_subnet_cidr) # to get iteration count 
  subnet_id      = element(aws_subnet.private[*].id, count.index) #this function returns the element 
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "database"  {
  count =  length(var.database_subnet_cidr) # to get iteration count 
  subnet_id      = element(aws_subnet.database[*].id, count.index) #this function returns the element 
  route_table_id = aws_route_table.database.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${local.name}"
  subnet_ids = aws_subnet.database[*].id
  tags = merge(
    var.common_tags,
    {
      Name = "${local.name}-db-subnet-group"
    }
  )
}