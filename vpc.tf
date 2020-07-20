resource "aws_vpc" "my_vpc_cre" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

// PUBLIC Subnet
resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.my_vpc_cre.id
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true 
  availability_zone = var.PublicSubnet_AvailabilityZone
  tags = {
    Name = "Subnet1"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}

// Private Subnet
resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.my_vpc_cre.id
  cidr_block = "192.168.1.0/24"
  availability_zone = var.PrivateSubnet_AvailabilityZone
  tags = {
    Name = "Subnet1"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}