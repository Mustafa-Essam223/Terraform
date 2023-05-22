resource "aws_vpc" "iti-vpc" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = var.vpc-name
  }
}
resource "aws_subnet" "iti-vpc-subnets" {
  count             = length(var.subnet-cidrs)
  vpc_id            = aws_vpc.iti-vpc.id
  depends_on        = [aws_vpc.iti-vpc]
  cidr_block        = var.subnet-cidrs[count.index]
  availability_zone = var.subnet-avZones[count.index]

  tags = {
    Name = "${var.subnet-names[count.index]}${count.index + 1}"
  }
}
resource "aws_internet_gateway" "iti-vpc-igw" {
  vpc_id = aws_vpc.iti-vpc.id
  tags = {
    Name = var.IGW-Name
  }
}

resource "aws_route_table" "igw-route-table" {
  vpc_id     = aws_vpc.iti-vpc.id
  depends_on = [aws_internet_gateway.iti-vpc-igw]
  route {
    cidr_block = var.any-ip-cidr
    gateway_id = aws_internet_gateway.iti-vpc-igw.id

  }
  tags = {
    Name = var.igw-route-terra
  }

}


resource "aws_route_table_association" "publicSubnet" {
  depends_on     = [aws_route_table.igw-route-table, aws_subnet.iti-vpc-subnets]
  subnet_id      = aws_subnet.iti-vpc-subnets[0].id
  route_table_id = aws_route_table.igw-route-table.id

}


resource "aws_security_group" "public-sg" {
  name       = var.security-group-names[0]
  vpc_id     = aws_vpc.iti-vpc.id
  depends_on = [aws_vpc.iti-vpc]

  ingress {
    from_port   = var.sg-info[0][0]
    to_port     = var.sg-info[0][1]
    protocol    = var.sg-info[0][2]
    cidr_blocks = [var.sg-info[0][3]]
  }
  egress {
    from_port   = var.sg-info[0][0]
    to_port     = var.sg-info[0][1]
    protocol    = var.sg-info[0][2]
    cidr_blocks = [var.sg-info[0][3]]
  }
}

resource "aws_security_group" "private-sg" {
  name       = var.security-group-names[1]
  vpc_id     = aws_vpc.iti-vpc.id
  depends_on = [aws_vpc.iti-vpc]


  egress {
    from_port   = var.sg-info[1][0]
    to_port     = var.sg-info[1][1]
    protocol    = var.sg-info[1][2]
    cidr_blocks = [var.sg-info[1][3]]
  }
}

resource "aws_security_group_rule" "private-SG-inbound" {

  depends_on               = [aws_vpc.iti-vpc, aws_security_group.private-sg]
  security_group_id        = aws_security_group.private-sg.id
  type                     = "ingress"
  from_port                = var.sg-info[1][0]
  to_port                  = var.sg-info[1][1]
  protocol                 = var.sg-info[1][2]
  source_security_group_id = aws_security_group.public-sg.id

}

resource "aws_eip" "nat-gateway" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway.id
  subnet_id     = aws_subnet.iti-vpc-subnets[0].id
  tags = {
    Name = var.nat-name
  }
}

resource "aws_route_table" "nat-route-table" {
  vpc_id     = aws_vpc.iti-vpc.id
  depends_on = [aws_nat_gateway.nat-gateway]

  route {
    cidr_block = var.any-ip-cidr
    gateway_id = aws_nat_gateway.nat-gateway.id

  }
  tags = {
    Name = var.nat-route-name
  }
}


resource "aws_route_table_association" "private-subnet-association" {
  depends_on     = [aws_route_table.nat-route-table, aws_subnet.iti-vpc-subnets]
  subnet_id      = aws_subnet.iti-vpc-subnets[1].id
  route_table_id = aws_route_table.nat-route-table.id
}

resource "aws_instance" "public-app" {

  ami           = var.instance-info[0][0]
  instance_type = var.instance-info[0][1]
  key_name      = var.instance-info[0][2]

  subnet_id = aws_subnet.iti-vpc-subnets[0].id

  associate_public_ip_address = var.instance-info[0][3]
  vpc_security_group_ids      = var.instance-info[0][4]
  tags = {
    Name = var.instance-info[0][5]
  }
  user_data = <<-EOF
    #cloud-config
    packages:
      - apache2
    runcmd:
      - systemctl start apache2
      - systemctl enable apache2
  EOF

}


resource "aws_instance" "private-app" {

  ami           = var.instance-info[1][0]
  instance_type = var.instance-info[1][1]
  key_name      = var.instance-info[1][2]

  subnet_id = aws_subnet.iti-vpc-subnets[1].id

  associate_public_ip_address = var.instance-info[1][3]
  vpc_security_group_ids      = var.instance-info[1][4]
  tags = {
    Name = var.instance-info[1][5]
  }
  user_data = <<-EOF
    #cloud-config
    packages:
      - apache2
    runcmd:
      - systemctl start apache2
      - systemctl enable apache2
  EOF

}
