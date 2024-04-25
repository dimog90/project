 
# создаем 2 route таблицы: 
#для публичной и для приватной подсети


# route таблица для приватной подсети. 
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id


  route {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.nat.id
    }

  tags = {
    Name = "${var.project_name}-private" # тег с именем 
  }
}

# route таблица для публичной подсети
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

 
  route {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.igw.id
    }

  tags = {
    Name = "${var.project_name}-public"
  }
}



# аттачим приватную route таблицу к приватной подсети #1 
resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-a.id 
  route_table_id = aws_route_table.private.id 
}

# аттачим приватную route таблицу к приватной подсети #2 
resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-b.id 
  route_table_id = aws_route_table.private.id 
}

# аттачим route таблицу для публичной подсети к публичным подсетям
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id 
  route_table_id = aws_route_table.public.id 
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-b.id 
  route_table_id = aws_route_table.public.id
}