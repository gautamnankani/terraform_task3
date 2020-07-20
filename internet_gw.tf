resource "aws_internet_gateway" "gateway_cre" {
  vpc_id = aws_vpc.my_vpc_cre.id
  tags = {
    Name = "mypvc_gateway"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}


//////////////////////////////////////Routing Table Creation
resource "aws_route_table" "route_table_cre" {
  vpc_id = aws_vpc.my_vpc_cre.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_cre.id
  }

  tags = {
    Name = "myvpc_RT"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
    aws_internet_gateway.gateway_cre,
  ]
}

//////////////////////////////////RT association with subnet1
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.route_table_cre.id
  depends_on = [
    aws_subnet.first_subnet,
    aws_route_table.route_table_cre,
  ]
}