//////////////////MYSQL:   instace creation
resource "aws_instance" "mysqlin" {
  ami           = var.mysql_ami
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
  ami           = var.wordpress_ami
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