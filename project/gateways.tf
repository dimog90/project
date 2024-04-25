# создаем internet gateway для выхода в интернет

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# для nat gateway создаем elastic ip адрес, чтобы он был постоянным

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat"
  }
}

# создаем nat gateway для приватных подсетей 
# приватная подсеть -> nat gateway -> internet gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id 
  subnet_id     = aws_subnet.public-a.id 

  tags = {
    Name = "${var.project_name}-nat"
  }

  depends_on = [aws_internet_gateway.igw] 
}