# Criar uma VPC
resource "aws_vpc" "obsidian-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "obsidian-vpc-${var.environment}"
  }
}

# Definindo as Zonas de Disponibilidade (AZs)
data "aws_availability_zones" "available" {}

# Criar Subnets Públicas
resource "aws_subnet" "obsidian_public_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.obsidian-vpc.id
  cidr_block              = cidrsubnet(aws_vpc.obsidian-vpc.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "obsidian-public-subnet-${count.index + 1}-${var.environment}"
  }
}

# Criar Subnets Privadas
resource "aws_subnet" "obsidian_private_subnet" {
  count             = 2
  vpc_id            = aws_vpc.obsidian-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.obsidian-vpc.cidr_block, 4, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "obsidian-private-subnet-${count.index + 1}-${var.environment}"
  }
}

# Criar Subnets para Database
resource "aws_subnet" "obsidian_database_subnet" {
  count             = 2
  vpc_id            = aws_vpc.obsidian-vpc.id
  cidr_block        = cidrsubnet(aws_vpc.obsidian-vpc.cidr_block, 4, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "obsidian-database-subnet-${count.index + 1}-${var.environment}"
  }
}

resource "aws_db_subnet_group" "obsidian_db_subnet_gruop" {
  name       = "obsidian-db-subnet-group-${var.environment}"
  subnet_ids = aws_subnet.obsidian_database_subnet.*.id
}

# Criar uma Tabela de Roteamento Pública
resource "aws_route_table" "obsidian-public-rt" {
  vpc_id = aws_vpc.obsidian-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.obsidian_ig.id
  }

  tags = {
    Name = "obsidian-public-route-table-${var.environment}"
  }
}

# Associar Subnets Públicas à Tabela de Roteamento Pública
resource "aws_route_table_association" "obsidian_public_rta" {
  count          = 2
  subnet_id      = aws_subnet.obsidian_public_subnet[count.index].id
  route_table_id = aws_route_table.obsidian-public-rt.id
}

# Criar um Internet Gateway para subnets públicas
resource "aws_internet_gateway" "obsidian_ig" {
  vpc_id = aws_vpc.obsidian-vpc.id

  tags = {
    Name = "obsidian-main-internet-gateway-${var.environment}"
  }
}
