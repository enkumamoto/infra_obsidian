locals {
  tags = merge(var.tags_to_append, { Environment = var.environment })
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = var.vpc_id
  security_group_ids = var.defaul_security_group_id

  endpoints = {
    s3 = {
      service = "s3"
      tags    = local.tags
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([var.intra_route_table_ids, var.public_route_table_ids])
      tags            = local.tags
    },
  }
  tags = local.tags
}

resource "aws_dynamodb_table" "raw_tags_table" {
  name             = "obsidian-raw-tags"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "RawTagsId"
  range_key        = "Timestamp"

  attribute {
    name = "RawTagsId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Raw Tags Table"
  }
}

resource "aws_dynamodb_table" "module_outputs_table" {
  name             = "obsidian-module-outputs"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "ModuleOutputsId"
  range_key        = "Timestamp"

  attribute {
    name = "ModuleOutputsId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Module Outputs Table"
  }
}

resource "aws_dynamodb_table" "module_config_table" {
  name             = "obsidian-module-configs"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "ModuleConfigsId"
  range_key        = "Timestamp"

  attribute {
    name = "ModuleConfigsId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Module Outputs Table"
  }
}

resource "aws_dynamodb_table" "monitor_outputs_metadata_table" {
  name             = "obsidian-monitor-metadata"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "MonitorMetadataId"
  range_key        = "Timestamp"

  attribute {
    name = "MonitorMetadataId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Monitor Outputs Metadata Table"
  }
}

resource "aws_dynamodb_table" "monitor_warning_outputs_table" {
  name             = "obsidian-monitor-warnings"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "MonitorWarningId"
  range_key        = "Timestamp"

  attribute {
    name = "MonitorWarningId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Monitor Warning Outputs Table"
  }
}

output "monitor_warning_outputs_table" {
  value = aws_dynamodb_table.monitor_outputs_metadata_table.stream_arn
}

resource "aws_dynamodb_table" "group_config_table" {
  name             = "obsidian-group-configs"
  billing_mode     = "PROVISIONED"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"
  read_capacity    = 5000
  write_capacity   = 5000
  hash_key         = "GroupConfigId"
  range_key        = "Timestamp"

  attribute {
    name = "GroupConfigId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Group Config Table"
  }
}
