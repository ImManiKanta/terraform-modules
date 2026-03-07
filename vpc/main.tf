resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id #VPC Association

  tags = local.ig_final_tags
}

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]
    map_public_ip_on_launch = true

  tags = merge(
        local.common_tags,
        #roboshop=dev-public-us-east-1a
        {
        Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        },
        var.public_subnet_tags
    )
}

resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

  tags = merge(
        local.common_tags,
        #roboshop=dev-private-us-east-1a
        {
        Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        },
        var.private_subnet_tags
    )
}

resource "aws_subnet" "databse" {
    count = length(var.database_subnet_cidrs)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.database_subnet_cidrs[count.index]
    availability_zone = local.az_names[count.index]

  tags = merge(
        local.common_tags,
        #roboshop=dev-database-us-east-1a
        {
        Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        },
        var.private_subnet_tags
    )
}

#AWS route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        #roboshop=dev-public
        {
        Name = "${var.project}-${var.environment}-public"
        },
        var.public_route_table_tags
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        #roboshop=dev-private
        {
        Name = "${var.project}-${var.environment}-private"
        },
        var.private_route_table_tags
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        #roboshop=dev-database
        {
        Name = "${var.project}-${var.environment}-database"
        },
        var.database_route_table_tags
    )
}

#AWS public Route 
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

#Elastic IP create
resource "aws_eip" "main" {
  domain                    = "vpc"
 tags = merge(
        local.common_tags,
        #roboshop=dev-database
        {
        Name = "${var.project}-${var.environment}-nat"
        }
    )
}

#create natgateway and attach EIP to NAT 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.private[0].id #Attach to 1st region - us-east-1a

  tags = merge(
        local.common_tags,
        #roboshop=dev-database
        {
        Name = "${var.project}-${var.environment}-nat-gateway"
        }
    )
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

#AWS private Route 
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

#AWS databse Route 
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.main.id
}