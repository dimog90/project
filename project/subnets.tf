# создаем приватные и публичные подсети в vpc

# приватная подсеть №1
resource "aws_subnet" "private-a" {
  vpc_id            = aws_vpc.vpc.id 
  cidr_block        = "192.168.0.0/19" 
  availability_zone = "${var.aws_region}a" 

  tags = {
    Name                              = "${var.project_name}-private-a"
    "kubernetes.io/cluster/demo"      = "owned" 
  }
}

# приватная подсеть №2 
resource "aws_subnet" "private-b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "192.168.32.0/19"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name                              = "${var.project_name}-private-b"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

# публичная подсеть №1. 
resource "aws_subnet" "public-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.64.0/19"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "${var.project_name}-public-a"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

# публичная подсеть №2
resource "aws_subnet" "public-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "192.168.96.0/19"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags = {
    Name                         = "${var.project_name}-public-b"
    "kubernetes.io/cluster/demo" = "owned"
  }
}