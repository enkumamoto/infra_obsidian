resource "aws_ecs_cluster" "obsidian_cluster" {
  name = "obsidian-ecs_cluster-${var.environment}"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.obsidian_kms_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.obsidian_log_group.name
      }
    }
  }

  tags = {
    Environment = var.environment
    Name        = "obsidian ECS Cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
  cluster_name = aws_ecs_cluster.obsidian_cluster.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_kms_key" "obsidian_kms_key" {
  description             = "KMS key for obsidian ECS cluster"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "obsidian_log_group" {
  name = "/ecs/obsidian-${var.environment}"
}
