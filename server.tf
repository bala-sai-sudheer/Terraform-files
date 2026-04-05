resource "aws_instance" "server" {
  tags = {
    Name        = "Terrafrom-Server"
    Environment = "Dev"
  }

  ami                    = "ami-0bfa6d0ea0fe2c5a1"
  key_name               = "sudheer"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["ALL-SG"]

  root_block_device {
    volume_size = 10
  }
}
