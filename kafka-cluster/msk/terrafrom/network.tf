resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  count                   = var.use_current_vpc == true ? 0 : 1
  cidr_block              = element(var.private_subnet_cidr_block, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = var.tags
}

/* If you are not using private link, then to access services outside VPC MSK connect needs internet access */
/* See https://docs.aws.amazon.com/msk/latest/developerguide/msk-connect-internet-access.html */

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = var.public_subnet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name        = "${lower(var.env_code)}-${lower(var.cluster_name)}-public-subnet"
    Environment = "${upper(var.aws_region)}"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  tags = {
    Name        = "${var.env_code}-igw"
    Environment = "${upper(var.env_code)}"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]
  tags = {
    Name        = "nat"
    Environment = "${upper(var.env_code)}"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  tags = {
    Name        = "${var.env_code}-public-route-table"
    Environment = "${upper(var.env_code)}"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  tags = {
    Name        = "${var.env_code}-private-route-table"
    Environment = "${upper(var.env_code)}"
  }
}

resource "aws_main_route_table_association" "private" {
  vpc_id         = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  subnet_id      = element(aws_subnet.public_subnet.*.id, 0)
  route_table_id = aws_route_table.public.id
}