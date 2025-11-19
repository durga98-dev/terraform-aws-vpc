resource "aws_vpc" "main" {
 cidr_block = var.vpc_cidr
 instance_tenancy = "default"
 enable_dns_hostnames = var.enable_dnshostnames
 #expense-dev
 tags = merge(
  var.common_tags, 
  var.vpc_tags,
  {
    Name = local.resource_name
  }
 ) 
}

resource "aws_internet_gateway" "main" {
 vpc_id = aws_vpc.main.id
 tags = merge(
  var.common_tags,
  var.vpc_tags,
  var.igw_tags
 )
}

#expense-dev-public-us-east-1a
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.public_subnet_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

#expense-dev-private-us-east-1a
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.private_subnet_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-${local.az_names[count.index]}"
    }
  )
}

#expense-db-private-us-east-1a
resource "aws_subnet" "db" {
  count = length(var.db_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.db_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.db_subnet_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-${local.az_names[count.index]}"
    }
  )
}

#elastic ip
resource "aws_eip" "nat"{
  domain = vpc
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gw_tags,
    {
    Name = local.resource_name
    }
  )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

#Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_routetable_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )
}

#Private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_routetable_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )
}

# database route table
resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.database_routetable_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.example.id
}

resource "aws_route" "db" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.example.id
}

