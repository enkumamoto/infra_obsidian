## Lambda loader function
resource "aws_lambda_function" "lambda_loader" {
  function_name = "BlackstoneLoader"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Raw Tags Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  environment {
    variables = {
      sqs_dataextractor_add_pipoint     = aws_sqs_queue.sqs_dataextractor_add_pipoint.url
      sqs_dataextractor_update_pipoint  = aws_sqs_queue.sqs_dataextractor_update_pipoint.url
      sqs_dataextractor_remove_pipoint  = aws_sqs_queue.sqs_dataextractor_remove_pipoint.url
      sqs_dataextractor_general_pipoint = aws_sqs_queue.sqs_dataextractor_general_pipoint.url
    }
  }

  image_uri    = "${aws_ecr_repository.loader-function.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }
  tags = {
    Name        = "BlackstoneLoader"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

output "lambda_loader_arn" {
  value = aws_lambda_function.lambda_loader.arn
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_1" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_add_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_2" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_update_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_3" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

resource "aws_lambda_event_source_mapping" "lambda_loader_trigger_4" {
  event_source_arn                   = aws_sqs_queue.sqs_dataextractor_general_pipoint.arn
  function_name                      = aws_lambda_function.lambda_loader.arn
  batch_size                         = 2000
  maximum_batching_window_in_seconds = 1
}

## Lambda Duplicate Tags function
resource "aws_lambda_function" "lambda_duplicated_tags" {
  function_name = "DuplicatedTags"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Module Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  # environment {
  #   variables = {
  #     sqs_dataextractor_duplicated_pipoint = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint.url
  #   }
  # }

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDuplicatedTags"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_duplicated_tags_trigger" {
  event_source_arn = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint.arn
  function_name    = aws_lambda_function.lambda_duplicated_tags.arn
}

output "lambda_duplicated_tags_arn" {
  value = aws_lambda_function.lambda_duplicated_tags.arn
}

## Lambda Component Surveillance
resource "aws_lambda_function" "lambda_component_surveillance" {
  function_name = "ComponentSurveillance"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneComponentSurveillance"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_component_surveillance_trigger" {
  event_source_arn = aws_sqs_queue.sqs_blackstone_component_surveillance_raw.arn
  function_name    = aws_lambda_function.lambda_component_surveillance.arn
}

output "lambda_component_surveillance_arn" {
  value = aws_lambda_function.lambda_component_surveillance.arn
}

## Lambda Data Collection Frequency
resource "aws_lambda_function" "lambda_data_collection_frequency" {
  function_name = "DataCollectionFrequency"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataCollectionFrequency"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_data_collection_frequency_trigger" {
  event_source_arn = aws_sqs_queue.sqs_data_collection_frequency_raw.arn
  function_name    = aws_lambda_function.lambda_data_collection_frequency.arn
}

output "lambda_data_collection_frequency_arn" {
  value = aws_lambda_function.lambda_data_collection_frequency.arn
}

## Lambda Data Quality function
resource "aws_lambda_function" "lambda_dataquality" {
  function_name = "DataQuality"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.dataquality-function.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataQuality"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_dataquality_trigger" {
  event_source_arn = aws_sqs_queue.sqs_blackstone_data_quality_raw.arn
  function_name    = aws_lambda_function.lambda_dataquality.arn
}

output "lambda_dataquality_arn" {
  value = aws_lambda_function.lambda_dataquality.arn
}

# Lambda Monitor function
resource "aws_lambda_function" "lambda_monitor_function" {
  function_name = "BlackstoneMonitor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_monitor_timeout # 10 minutes timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.monitor-function.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_monitor_trigger" {
  event_source_arn = aws_sqs_queue.sqs_blackstone_monitor_trigger.arn
  function_name    = aws_lambda_function.lambda_monitor_function.arn
}

output "lambda_monitor_function_arn" {
  value = aws_lambda_function.lambda_monitor_function.arn
}

## Lambda Tag State function
resource "aws_lambda_function" "lambda_tag_state_function" {
  function_name = "TagState"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.tagstate-function.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneTagState"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_tag_state_trigger" {
  event_source_arn = aws_sqs_queue.sqs_tag_state_raw.arn
  function_name    = aws_lambda_function.lambda_tag_state_function.arn
}

output "lambda_tag_state_function_arn" {
  value = aws_lambda_function.lambda_tag_state_function.arn
}

## Lambda Data Work Flow function
resource "aws_lambda_function" "lambda_data_work_flow_function" {
  function_name = "DataWorkflow"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDataWorkflow"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_data_work_flow_trigger" {
  event_source_arn = aws_sqs_queue.sqs_blackstone_data_workflow_raw.arn
  function_name    = aws_lambda_function.lambda_data_work_flow_function.arn
}

output "lambda_data_work_flow_function_arn" {
  value = aws_lambda_function.lambda_data_work_flow_function.arn
}

# Lambda Tag Config Consistency function
resource "aws_lambda_function" "lambda_tag_config_consistency_function" {
  function_name = "TagConfigConsistency"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneTagConfigConsistency"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_tag_config_consistency_trigger" {
  event_source_arn = aws_sqs_queue.sqs_tag_config_consistency_raw.arn
  function_name    = aws_lambda_function.lambda_tag_config_consistency_function.arn
}

output "lambda_tag_config_consistency_function_arn" {
  value = aws_lambda_function.lambda_tag_config_consistency_function.arn
}

# Lambda BlackstoneDuplicatedTagsMonitor
resource "aws_lambda_function" "lambda_duplicated_tags_monitor" {
  function_name = "BlackstoneDuplicatedTagsMonitor"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneDuplicatedTagsMonitor"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

resource "aws_lambda_event_source_mapping" "lambda_duplicated_tags_monitor_trigger" {
  event_source_arn = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn
  function_name    = aws_lambda_function.lambda_duplicated_tags_monitor.arn
}

output "lambda_duplicated_tags_monitor_arn" {
  value = aws_lambda_function.lambda_duplicated_tags_monitor.arn
}

# Função BlackstoneMetadataMerger
resource "aws_lambda_function" "lambda_metadata_merger_function" {
  function_name = "BlackstoneMetadataMerger"
  role          = aws_iam_role.iam_lambda.arn
  description   = "Lambda function Monitor Outputs Table"
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout
  depends_on    = [aws_iam_role.iam_lambda]

  image_uri    = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest"
  package_type = "Image"

  vpc_config {
    subnet_ids         = var.lambda_vpc_config_subnet_ids
    security_group_ids = var.lambda_vpc_config_security_group_ids
  }

  tags = {
    Name        = "BlackstoneMetadataMerger"
    environment = var.environment
  }

  lifecycle {
    ignore_changes = [image_uri]
  }
}

# Event Source Mapping - Agora usando o ARN do Stream de DynamoDB
resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = data.aws_dynamodb_table.monitor_outputs_metadata_table.stream_arn # Aqui estamos usando o stream_arn
  function_name     = aws_lambda_function.lambda_metadata_merger_function.arn
  enabled           = true
  batch_size        = 100
  starting_position = "LATEST"
  depends_on        = [aws_lambda_function.lambda_metadata_merger_function]
}

output "lambda_metadata_merger_function_arn" {
  value = aws_lambda_function.lambda_metadata_merger_function.arn
}
