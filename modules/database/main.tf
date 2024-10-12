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

# resource "aws_rds_cluster" "blackstone_postgresql" {
#   cluster_identifier      = "blackstone-datapolling"
#   engine                  = "aurora-postgresql"
#   engine_mode             = "provisioned"
#   db_subnet_group_name    = aws_db_subnet_group.default.name
#   database_name           = var.initial_db_name
#   master_username         = var.master_username
#   master_password         = var.master_password
#   backup_retention_period = 7
#   preferred_backup_window = "07:00-09:00"
#   skip_final_snapshot     = true
#   vpc_security_group_ids = [
#     aws_security_group.allow_postgres.id
#   ]

#   depends_on = [aws_db_subnet_group.default, aws_security_group.allow_postgres]

#   tags = merge(local.tags, { Name = "postgres_db_${var.environment}" })
# }

# resource "aws_rds_cluster_instance" "blackstone_db_instances" {
#   count              = 2
#   identifier         = "blackstone-datapolling-instance-${count.index}"
#   cluster_identifier = aws_rds_cluster.blackstone_postgresql.id
#   availability_zone  = var.region == "us-east-1" ? local.avaliability_zones[count.index] : local.avaliability_zones[count.index % 2]
#   instance_class     = "db.r4.large"
#   engine             = aws_rds_cluster.blackstone_postgresql.engine
#   engine_version     = "15.4"

#   depends_on = [aws_rds_cluster.blackstone_postgresql]
# }

resource "aws_rds_cluster" "blackstone_postgresql" {
  cluster_identifier      = "blackstone-datapolling"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
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

resource "aws_rds_cluster_instance" "blackstone_db_instances" {
  count              = 1
  identifier         = "blackstone-datapolling-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.blackstone_postgresql.id
  availability_zone  = var.region == "us-east-1" ? local.avaliability_zones[count.index] : local.avaliability_zones[count.index % 2]
  instance_class     = "db.t3.medium" # ou outra classe compatível
  engine             = aws_rds_cluster.blackstone_postgresql.engine
  engine_version     = "15.4" # Tente uma versão suportada e estável do Aurora PostgreSQL

  depends_on = [aws_rds_cluster.blackstone_postgresql]
}
