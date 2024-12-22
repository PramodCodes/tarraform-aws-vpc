# Retrieve the AZ where we want to create network resources
# This must be in the region selected on the AWS provider.
data "aws_availability_zones" "azs" {
  state = "available" # we are not providing name because its listed in provider
}