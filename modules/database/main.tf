locals {
  avaliability_zones = [for s in data.aws_subnet.private_data_subnets : s.availability_zone]
  tags               = merge(var.tags_to_append, { Environment = var.environment })
  vpc_id             = data.aws_subnet.private_data_subnets[0].vpc_id
  db_domain_name     = "postgres.${var.environment}"
}

output "avaliability_zones" {
  value = local.avaliability_zones
}

resource "aws_db_subnet_group" "default" {
  name       = "default_db_subnet_group_postgres_${var.environment}"
  subnet_ids = var.vpc_config_private_data_subnet_ids

  tags = merge(local.tags, { Name = "default_db_subnet_group_postgres_${var.environment}" })
}

resource "aws_security_group" "allow_postgres" {
  name        = "allow_postgres_${var.environment}"
  description = "Allow Postgres inbound traffic"
  vpc_id      = data.aws_subnet.private_data_subnets[0].vpc_id

  ingress {
    description = "Allow Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.private_app_subnets : s.cidr_block]
  }

  tags = merge(local.tags, { Name = "allow_postgres_${var.environment}" })
}

resource "aws_rds_cluster" "blackstone_postgresql" {
  cluster_identifier = "obsidian-datapolling"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"

  serverlessv2_scaling_configuration {
    max_capacity = 8.0
    min_capacity = 0.5
  }

  db_subnet_group_name    = aws_db_subnet_group.default.name
  database_name           = var.initial_db_name
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = 7
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
  vpc_security_group_ids = [
    aws_security_group.allow_postgres.id
  ]

  depends_on = [aws_db_subnet_group.default, aws_security_group.allow_postgres]

  tags = merge(local.tags, { Name = "postgres_db_${var.environment}" })
}

resource "aws_rds_cluster_instance" "blackstone_postgresql_instance" {
  count = 1

  identifier                 = "obsidian-datapolling-instance-${count.index}"
  cluster_identifier         = aws_rds_cluster.blackstone_postgresql.id
  instance_class             = "db.serverless"
  engine                     = "aurora-postgresql"
  engine_version             = "15.4"
  publicly_accessible        = false
  apply_immediately          = true
  auto_minor_version_upgrade = true

  tags = merge(local.tags, { Name = "postgres_db_instance_${var.environment}" })
}
