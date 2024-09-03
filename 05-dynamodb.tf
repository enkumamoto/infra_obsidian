resource "aws_dynamodb_table" "raw_tags_table" {
  name         = "RawTagsTable${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "TagId"

  attribute {
    name = "TagId"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Name        = "Raw Tags Table"
  }
}

resource "aws_dynamodb_table" "module_outputs_table" {
  name         = "ModuleOutputsTable${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "ModuleId"
  range_key = "Timestamp"

  attribute {
    name = "ModuleId"
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

resource "aws_dynamodb_table" "monitor_outputs_table" {
  name         = "MonitorOutputsTable${var.environment}"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "MonitorId"
  range_key = "Timestamp"

  attribute {
    name = "MonitorId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }

  tags = {
    Environment = var.environment
    Name        = "Monitor Outputs Table"
  }
}
