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