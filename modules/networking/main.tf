locals {
  vpc_network = "10.0.0.0/16"
  tags        = merge(var.tags_to_append, { Environment = var.environment })
  az_subnets = {
    "${var.region}a" = { "public" = "10.0.0.0/20", "private_app" = "10.0.16.0/20", "private_data" = "10.0.32.0/20" }     #AZ1
    "${var.region}b" = { "public" = "10.0.64.0/20", "private_app" = "10.0.80.0/20", "private_data" = "10.0.96.0/20" }    #AZ2
    "${var.region}c" = { "public" = "10.0.128.0/20", "private_app" = "10.0.144.0/20", "private_data" = "10.0.160.0/20" } #AZ3
  }
}

resource "aws_vpc" "main" {
  cidr_block = local.vpc_network
  tags       = merge(local.tags, { Name = "vpc_${var.environment}" })
}

output "vpc_id" {
  value = aws_vpc.main.id
}

resource "aws_subnet" "az_a" {
  for_each          = local.az_subnets["${var.region}a"]
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}a"

  tags = merge(local.tags, { Name = "subnet_aza_${each.key}_${var.environment}" })
}

resource "aws_subnet" "az_b" {
  for_each          = local.az_subnets["${var.region}b"]
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}b"

  tags = merge(local.tags, { Name = "subnet_azb_${each.key}_${var.environment}" })
}

resource "aws_subnet" "az_c" {
  for_each          = local.az_subnets["${var.region}c"]
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = "${var.region}c"

  tags = merge(local.tags, { Name = "subnet_azc_${each.key}_${var.environment}" })
}

output "public_subnet_ids" {
  value = [aws_subnet.az_a["public"].id, aws_subnet.az_b["public"].id, aws_subnet.az_c["public"].id]
}

output "private_app_subnet_ids" {
  value = [aws_subnet.az_a["private_app"].id, aws_subnet.az_b["private_app"].id, aws_subnet.az_c["private_app"].id]
}

output "private_data_subnet_ids" {
  value = [aws_subnet.az_a["private_data"].id, aws_subnet.az_b["private_data"].id, aws_subnet.az_c["private_data"].id]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.tags, { Name = "igw_${var.environment}" })
}

resource "aws_eip" "eip_A" {
  domain = "vpc"
  tags   = merge(local.tags, { Name = "eip_A_${var.environment}" })
}

resource "aws_eip" "eip_B" {
  domain = "vpc"
  tags   = merge(local.tags, { Name = "eip_B_${var.environment}" })
}

resource "aws_eip" "eip_C" {
  domain = "vpc"
  tags   = merge(local.tags, { Name = "eip_C_${var.environment}" })
}

output "external_ip" {
  value = {
    az_a = aws_eip.eip_A.public_ip
    az_b = aws_eip.eip_B.public_ip
    az_c = aws_eip.eip_C.public_ip
  }
}

resource "aws_nat_gateway" "nat_gateway_A" {
  allocation_id = aws_eip.eip_A.allocation_id
  subnet_id     = aws_subnet.az_a["public"].id

  tags = merge(local.tags, { Name = "nat_gw_A_${var.environment}" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway_B" {
  allocation_id = aws_eip.eip_B.allocation_id
  subnet_id     = aws_subnet.az_b["public"].id

  tags = merge(local.tags, { Name = "nat_gw_B_${var.environment}" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway_C" {
  allocation_id = aws_eip.eip_C.allocation_id
  subnet_id     = aws_subnet.az_c["public"].id

  tags = merge(local.tags, { Name = "nat_gw_C_${var.environment}" })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.tags, { Name = "rt_public_${var.environment}" })
}

resource "aws_route_table_association" "route_table_association_public_A" {
  subnet_id      = aws_subnet.az_a["public"].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_public_B" {
  subnet_id      = aws_subnet.az_b["public"].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_public_C" {
  subnet_id      = aws_subnet.az_c["public"].id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table" "route_table_private_A" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_A.id
  }
  tags = merge(local.tags, { Name = "rt_private_A_${var.environment}" })
}

resource "aws_route_table" "route_table_private_B" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_B.id
  }
  tags = merge(local.tags, { Name = "rt_private_B_${var.environment}" })
}

resource "aws_route_table" "route_table_private_C" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_C.id
  }
  tags = merge(local.tags, { Name = "rt_private_C_${var.environment}" })
}

resource "aws_route_table_association" "route_table_association_private_A" {
  subnet_id      = aws_subnet.az_a["private_app"].id
  route_table_id = aws_route_table.route_table_private_A.id
}

resource "aws_route_table_association" "route_table_association_private_B" {
  subnet_id      = aws_subnet.az_b["private_app"].id
  route_table_id = aws_route_table.route_table_private_B.id
}

resource "aws_route_table_association" "route_table_association_private_C" {
  subnet_id      = aws_subnet.az_c["private_app"].id
  route_table_id = aws_route_table.route_table_private_C.id
}

resource "aws_security_group" "BlackStoneSG" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.tags, { Name = "sg_${var.environment}" })
}
