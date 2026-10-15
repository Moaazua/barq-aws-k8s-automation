resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "barq-vpc"
  }
}

######################################
##### subnets ########################
######################################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.public_az
  map_public_ip_on_launch = true

  tags = {
    Name = "barq-public-subnet"
  }
}

# Private DB Subnet 1
resource "aws_subnet" "private_db_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_db_subnet_1_cidr
  availability_zone       = var.private_db_az_1
  map_public_ip_on_launch = false

  tags = {
    Name = "barq-private-db-subnet-1"
  }
}

# Private DB Subnet 2
resource "aws_subnet" "private_db_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_db_subnet_2_cidr
  availability_zone       = var.private_db_az_2
  map_public_ip_on_launch = false

  tags = {
    Name = "barq-private-db-subnet-2"
  }
}

######################################
##### IGW ########################
######################################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "barq-igw"
  }
}

######################################
##### Route Tables ########################
######################################

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "barq-public-rt"
  }
}

# Associate Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "barq-private-rt"
  }
}

# Associate Private DB Subnet 1
resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.private_db_1.id
  route_table_id = aws_route_table.private.id
}

# Associate Private DB Subnet 2
resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.private_db_2.id
  route_table_id = aws_route_table.private.id
}
