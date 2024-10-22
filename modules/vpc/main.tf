data "aws_availability_zones" "availability_zones" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.project_name}-${var.environment_name}-vpc"
  }
}

resource "aws_subnet" "subnets" {
  count = length(data.aws_availability_zones.availability_zones.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  availability_zone = data.aws_availability_zones.availability_zones.names[count.index]
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}
