resource "aws_vpc" "my_vpc" {
 cidr_block = var.vpc_cidr
 
 tags = {
   Name = "ionginx-vpc"
 }
}

resource "aws_subnet" "public_subnets" {
 depends_on = [ aws_vpc.my_vpc]
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 map_public_ip_on_launch = true
 tags = {
   Name = "my_public_subnet_${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 depends_on = [ aws_vpc.my_vpc]
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.my_vpc.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 map_public_ip_on_launch = false
 tags = {
   Name = "my_private_subnet_${count.index + 1}"
 }
}

resource "aws_internet_gateway" "igw" {
 
 vpc_id = aws_vpc.my_vpc.id
 
 tags = {
   Name = "My_igw"
 }
}

resource "aws_route_table" "public" {
 vpc_id = aws_vpc.my_vpc.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
 tags = {
   Name = "public route table"
 }
}

resource "aws_route_table_association" "public_subnet_association" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  depends_on    = [aws_internet_gateway.ig]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnets.*.id, 0)
  tags = {
    Name        = "nat_gateway"
   }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.my_vpc.id
   route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_nat_gateway.nat_gateway.id
 }
  tags = {
    Name        = "Private route table"
    }
}

resource "aws_route_table_association" "private_subnet_association" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
 route_table_id = aws_route_table.public.id
}