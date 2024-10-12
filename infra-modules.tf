locals {
  tags_to_append = {
    "Environment" = var.environment
  }
}

module "networking" {
  source         = "./modules/networking"
  environment    = var.environment
  tags_to_append = local.tags_to_append
  region         = var.region
}

data "aws_security_group" "default" {
  vpc_id = module.networking.vpc_id
  name   = "default"
}

module "ecs_cluster" {
  source         = "./modules/ecs_cluster"
  environment    = var.environment
  tags_to_append = local.tags_to_append

  vpc_config_public_subnet_ids = module.networking.public_subnet_ids

  depends_on = [module.networking]
}

module "ingestion" {
  source                               = "./modules/services"
  environment                          = var.environment
  tags_to_append                       = local.tags_to_append
  region                               = var.region
  lambda_vpc_config_subnet_ids         = module.networking.private_app_subnet_ids
  lambda_vpc_config_security_group_ids = [data.aws_security_group.default.id]
  ecs_cluster_id                       = module.ecs_cluster.ecs_cluster_id
  vpc_config_private_app_subnet_ids    = module.networking.private_app_subnet_ids
  vpc_id                               = module.networking.vpc_id
}

module "database" {
  source         = "./modules/database"
  environment    = var.environment
  tags_to_append = local.tags_to_append
  region         = var.region

  vpc_config_private_app_subnet_ids  = module.networking.private_app_subnet_ids
  vpc_config_private_data_subnet_ids = module.networking.private_data_subnet_ids

  initial_db_name = var.initial_db_name
  master_username = var.master_username
  master_password = var.master_password

  depends_on = [module.networking]
}

module "dynamodb" {
  source         = "./modules/dynamodb"
  environment    = var.environment
  tags_to_append = local.tags_to_append
  region         = var.region
  vpc_id         = module.networking.vpc_id
}
