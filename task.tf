provider "aws" {
  region  =  "ap-south-1"
  profile =  "myprofile"
}


resource "aws_vpc" "my_vpc_cre" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.my_vpc_cre.id
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true 
  availability_zone = "ap-south-1a"
  tags = {
    Name = "Subnet1-1a"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}

resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.my_vpc_cre.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "Subnet1-1b"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}

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


/////////////////////////////instance related

////////////////////////////////////////////////////////// EC2_INSTANCE AND EBS 



//////////////////WORDPRESS:  security group creation
resource "aws_security_group" "wp_sec" {
  name        = "wp"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc_cre.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
  ]
}


//////////////////MYSQL:  security group creation
resource "aws_security_group" "mysql_sec" {
  name        = "mysql"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.my_vpc_cre.id

  ingress {
    description = "sql"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [ aws_security_group.wp_sec.id ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql"
  }
  depends_on = [
    aws_vpc.my_vpc_cre,
    aws_security_group.wp_sec,
  ]
}


//////////////////MYSQL:   instace creation
resource "aws_instance" "mysqlin" {
  ami           = "ami-0e18cc6022b19cde1"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.second_subnet.id
  security_groups = [ aws_security_group.mysql_sec.id ]
  tags = {
    Name = "mysql"
  }
  depends_on = [
    aws_security_group.mysql_sec,
  ]
}





//////////////////WORDPRESS:   instace creation

resource "aws_instance" "wpin" {
  ami           = "ami-081545ade3dff9b59"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.first_subnet.id
  security_groups = [ aws_security_group.wp_sec.id ]
  key_name = "mykey"
  tags = {
    Name = "wp"
  }
  depends_on = [
    aws_security_group.wp_sec,
  ]
}



