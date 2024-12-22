# user can decide peering required or not
# if required
# 	1. they have to give peering VPC ID
# 	2. if they are not giving peering VPC ID, we will consider default VPC

# Requestor - roboshop
# Acceptor - user provided VPC or default

# roboshop-dev-mongodb
# 	1. accept connections only from catalogue and user

resource "aws_vpc_peering_connection" "vpc_peering" {
    count = var.is_peering_required ? 1 : 0
    vpc_id = aws_vpc.main.id # we need to check if peering required
    # if no vpc id is given then vpc id = default vpc id other wise vpc id is the vpc id given by user
    peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default_vpc.id : var.acceptor_vpc_id
    #if default auto accept vpc peering
    auto_accept = var.acceptor_vpc_id == "" ? true : false
    
    tags = merge(
        var.common_tags,
        var.vpc_peering_tags,
        {
            Name = "${local.name}-vpc-peering"
        }
    )
}


# resource "aws_route" "acceptor_rotue" {
# # we will only be able to create route if vpc peering is enabled and accepter vpc is null
# count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
# # we need to add the route to default vpc route table
#   route_table_id            = aws_route_table.public.id
#   destination_cidr_block    = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.NAT.id
# }