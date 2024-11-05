data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.app_name}-${var.environment}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.num_subnets

  vpc_id = aws_vpc.vpc.id

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet("10.0.0.0/16", 4, count.index)

  tags = {
    Name = "${var.app_name}-${var.environment}-subnet-public${count.index + 1}-${data.aws_availability_zones.available.names[count.index]}"
  }
}
resource "aws_subnet" "private" {
  count = var.num_subnets

  vpc_id = aws_vpc.vpc.id

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet("10.0.0.0/16", 4, 8 + count.index)

  tags = {
    Name = "${var.app_name}-${var.environment}-subnet-private${count.index}-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_internet_gateway" "public_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment}-rtb-public"
  }
}
resource "aws_route" "public_to_internet_gateway" {
  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public_gateway.id
}
resource "aws_route_table_association" "public" {
  for_each = { for index, subnet in aws_subnet.public : index => subnet.id }

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}
