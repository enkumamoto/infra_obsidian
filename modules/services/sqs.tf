resource "aws_kms_key" "sqs_key" {
  description             = "KMS key for SQS encryption"
  deletion_window_in_days = 30
  tags                    = merge(local.tags, { Name = "sqs_key_${var.environment}" })
}

# blackstoneLoader Lambda
resource "aws_sqs_queue" "sqs_dataextractor_add_pipoint" {
  name                       = "dataextractor-add-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_update_pipoint" {
  name                       = "dataextractor-update-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_remove_pipoint" {
  name                       = "dataextractor-remove-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_general_pipoint" {
  name                       = "dataextractor-general-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda TagState 
resource "aws_sqs_queue" "sqs_tag_state_raw" {
  name                       = "obsidian-tag-state-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda TagConfigConsistency
resource "aws_sqs_queue" "sqs_tag_config_consistency_raw" {
  name                       = "obsidian-tag-config-consistency-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda DataCollectionFrequency
resource "aws_sqs_queue" "sqs_data_collection_frequency_raw" {
  name                       = "obsidian-data-collection-frequency-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda DuplicateTags
resource "aws_sqs_queue" "sqs_dataextractor-duplicated-pipoint" {
  name                       = "dataextractor-duplicated-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda ComponentSurveillance
resource "aws_sqs_queue" "sqs_blackstone_component_surveillance_raw" {
  name                       = "obsidian-component-surveillance-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda MonitorTrigger
resource "aws_sqs_queue" "sqs_blackstone_monitor_trigger" {
  name                       = "obsidian-monitor-trigger"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

# Lambda DuplicatedPipointGroup
resource "aws_sqs_queue" "sqs_dataextractor_duplicated_pipoint_group" {
  name                       = "dataextractor-duplicated-pipoint-group"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_dataextractor_duplicated_pipoint" {
  name                       = "dataextractor-duplicated-pipoint"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_monitor_job" {
  name                       = "monitor-job"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_blackstone_data_workflow_raw" {
  name                       = "obsidian-data-workflow-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "sqs_blackstone_data_quality_raw" {
  name                       = "obsidian-data-quality-raw"
  delay_seconds              = var.sqs_delayseconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds

  kms_master_key_id                 = aws_kms_key.sqs_key.key_id
  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}
