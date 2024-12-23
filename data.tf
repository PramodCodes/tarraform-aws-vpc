# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.
data "aws_availability_zones" "azs" {
  state = "available" # we are not providing name because its listed in provider
}

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_route_table" "default" {
    vpc_id = data.aws_vpc.default_vpc.id
    filter {
      name = "association.main"
      values = ["true"]
    }
}