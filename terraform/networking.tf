resource "aws_vpc" "mszotowicz-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name  = "mszotowicz-vpc"
    Owner = "mszotowicz"
  }
}

##########################################################################

resource "aws_subnet" "szotowicz-subnet-client-a" {
  availability_zone_id = "euw2-az2"
  cidr_block           = "10.0.0.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-client-a"
    Owner = "mszotowicz"
  }
}
resource "aws_subnet" "szotowicz-subnet-client-b" {
  availability_zone_id = "euw2-az3"
  cidr_block           = "10.0.1.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-client-b"
    Owner = "mszotowicz"
  }
}

resource "aws_subnet" "szotowicz-subnet-server-a" {
  availability_zone_id = "euw2-az2"
  cidr_block           = "10.0.2.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-server-a"
    Owner = "mszotowicz"
  }
}
resource "aws_subnet" "szotowicz-subnet-server-b" {
  availability_zone_id = "euw2-az3"
  cidr_block           = "10.0.3.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-server-b"
    Owner = "mszotowicz"
  }
}

resource "aws_subnet" "szotowicz-subnet-rds-a" {
  availability_zone_id = "euw2-az2"
  cidr_block           = "10.0.4.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-rds-a"
    Owner = "mszotowicz"
  }
}
resource "aws_subnet" "szotowicz-subnet-rds-b" {
  availability_zone_id = "euw2-az3"
  cidr_block           = "10.0.5.0/24"
  vpc_id               = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name = "szotowicz-subnet-rds-b"
    Owner = "mszotowicz"
  }
}
resource "aws_db_subnet_group" "szotowicz-rds-sg" {
  name       = "szotowicz-rds-sg"
  subnet_ids = [
    aws_subnet.szotowicz-subnet-rds-a.id,
    aws_subnet.szotowicz-subnet-rds-b.id
  ]

  tags = {
    Name  = "szotowicz-rds-sg"
    Owner = "mszotowicz"
  }
}

##########################################################################

resource "aws_eip" "szotowicz-eip" {
  vpc = true

  tags = {
    Name  = "mszotowicz-eip"
    Owner = "mszotowicz"
  }
}
resource "aws_nat_gateway" "szotowicz-natgw" {
  allocation_id = aws_eip.szotowicz-eip.id
  subnet_id     = aws_subnet.szotowicz-subnet-client-a.id

  tags = {
    Name  = "mszotowicz-natgw"
    Owner = "mszotowicz"
  }
}
resource "aws_internet_gateway" "szotowicz-igw" {
  vpc_id = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name  = "mszotowicz-igw"
    Owner = "mszotowicz"
  }
}

##########################################################################

resource "aws_route_table" "mszotowicz-rt-client" {
  vpc_id = aws_vpc.mszotowicz-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.szotowicz-igw.id
  }

  tags = {
    Name  = "mszotowicz-rt-client"
    Owner = "mszotowicz"
  }
}
resource "aws_route_table_association" "mszotowicz-rt-client-a-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-client-a.id
  route_table_id = aws_route_table.mszotowicz-rt-client.id
}
resource "aws_route_table_association" "mszotowicz-rt-client-b-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-client-b.id
  route_table_id = aws_route_table.mszotowicz-rt-client.id
}
resource "aws_route_table" "mszotowicz-rt-server" {
  vpc_id = aws_vpc.mszotowicz-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.szotowicz-natgw.id
  }

  tags = {
    Name  = "mszotowicz-rt-server"
    Owner = "mszotowicz"
  }
}
resource "aws_route_table_association" "mszotowicz-rt-server-a-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-server-a.id
  route_table_id = aws_route_table.mszotowicz-rt-server.id
}
resource "aws_route_table_association" "mszotowicz-rt-server-b-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-server-b.id
  route_table_id = aws_route_table.mszotowicz-rt-server.id
}
resource "aws_route_table" "mszotowicz-rt-rds" {
  vpc_id = aws_vpc.mszotowicz-vpc.id

  tags = {
    Name  = "mszotowicz-rt-rds"
    Owner = "mszotowicz"
  }
}
resource "aws_route_table_association" "mszotowicz-rt-rds-a-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-rds-a.id
  route_table_id = aws_route_table.mszotowicz-rt-rds.id
}
resource "aws_route_table_association" "mszotowicz-rt-rds-b-association" {
  subnet_id      = aws_subnet.szotowicz-subnet-rds-b.id
  route_table_id = aws_route_table.mszotowicz-rt-rds.id
}

##########################################################################

resource "aws_security_group" "szotowicz-allow-http-public" {
  name        = "szotowicz-allow-http-public"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "szotowicz-allow-http-public"
    Owner = "mszotowicz"
  }
}

resource "aws_security_group" "szotowicz-allow-http-internal" {
  name        = "szotowicz-allow-http-internal"
  description = "Allow internal HTTP requests"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mszotowicz-vpc.cidr_block]
  }

  tags = {
    Name  = "szotowicz-allow-http-internal"
    Owner = "mszotowicz"
  }
}

resource "aws_security_group" "szotowicz-allow-ssh-owner" {
  name        = "szotowicz-allow-ssh-owner"
  description = "Allow SSH inbound traffic only for owner"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.owner-cidr-block]
  }

  tags = {
    Name  = "szotowicz-allow-ssh-owner"
    Owner = "mszotowicz"
  }
}

resource "aws_security_group" "szotowicz-allow-ssh-internal" {
  name        = "szotowicz-allow-ssh-internal"
  description = "Allow internal SSH requests"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mszotowicz-vpc.cidr_block]
  }

  tags = {
    Name  = "szotowicz-allow-ssh-internal"
    Owner = "mszotowicz"
  }
}

resource "aws_security_group" "szotowicz-allow-db-internal" {
  name        = "szotowicz-allow-db-internal"
  description = "Allow internal MySQL requests"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.mszotowicz-vpc.cidr_block]
  }

  tags = {
    Name  = "szotowicz-allow-db-internal"
    Owner = "mszotowicz"
  }
}

resource "aws_security_group" "szotowicz-allow-all-outbound" {
  name        = "szotowicz-allow-all-outbound"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.mszotowicz-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "szotowicz-allow-all-outbound"
    Owner = "mszotowicz"
  }
}

##########################################################################