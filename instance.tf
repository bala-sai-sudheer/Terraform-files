resource "aws_instance" "instance" {
  tags = {
    Name = "Terraform"
  }
  ami                    = "ami-0aaa636894689fa47"
  instance_type          = "t3.micro"
  key_name               = "sudheer"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = aws_subnet.subnet.id
  availability_zone      = "eu-north-1a"
}



resource "aws_security_group" "sg" {
  name        = "Terraform-Sg"
  description = "Terraform"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}
