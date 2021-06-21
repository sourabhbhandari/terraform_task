
# Creating New VPC:

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  tags = {
    name = "New-VPC-Lambda"
  }
}

# Creating Internet Gateway:

resource "aws_internet_gateway" "lambda_igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = "IGW_For_Lambda"
  }
}

# Creating New Routing Table (Private):

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id

  tags = {
    name = "private route table for VPC"
  }
}

# Creating Route Entry and attaching NAT Gateway: 

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default[count.index].id
}

# Creating New Public Route Table: 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = "public route table for VPC"
  }
}

# Creating Route and Attaching Internet Gateway to Public Route Table: 

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lambda_igw.id
}

# Private Subnets: 

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    name = "Private Subnet for VPC"
  }
}

# Public Subnet: 

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    name = "Public Subnet for VPC"
  }
}

# Private Route Table Associatation:

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Public Route Table Associatation: 

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Elastic IP for NAT Gateway:

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)
  vpc = true
}

# Natgateway Creation:

resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.lambda_igw]

  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    name = "Nat Gateway for Private Subnets"
  }
}

# Security Group for Instance:

resource "aws_security_group" "ubuntu_instance_sg" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = "Security Group for Lambda Test Instance"
  }
}

# Attachment on Network Interface:

resource "aws_network_interface_sg_attachment" "ubuntu_instance" {
  security_group_id    = aws_security_group.ubuntu_instance_sg.id
  network_interface_id = aws_instance.ubuntu_instance.primary_network_interface_id
}

# Creating Ubuntu Instance:

resource "aws_instance" "ubuntu_instance" {
  ami                         = var.ubuntu_ami
  availability_zone           = var.availability_zones[0]
  instance_type               = var.ubuntu_instance_type
  key_name                    = var.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private[0].id
  associate_public_ip_address = true

  tags = {
    name = "New Ubuntu Instance for Lambda Test"
  }
}