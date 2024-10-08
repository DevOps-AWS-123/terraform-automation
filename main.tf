#plugin random_id or module
resource "random_id" "server" {
  byte_length = 2
}
resource "aws_vpc" "first_vpc" {
  cidr_block           = var.first_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Dev-${random_id.server.hex}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.first_vpc.id
  tags = {
    Name = "Main-IGW-${random_id.server.hex}"
  }
}
