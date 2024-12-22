locals {
  name = "${var.project_name}-${var.project_environment}"
  az_names = slice(data.aws_availability_zones.azs.names, 0, 2) 
  # gets first two items of the list
}