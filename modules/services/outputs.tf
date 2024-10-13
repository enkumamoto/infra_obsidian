output "sqs_dataextractor_add_pipoint_url" {
  value = aws_sqs_queue.sqs_dataextractor_add_pipoint.url
}

output "sqs_dataextractor_update_pipoint_url" {
  value = aws_sqs_queue.sqs_dataextractor_update_pipoint.url
}

output "sqs_dataextractor_remove_pipoint_url" {
  value = aws_sqs_queue.sqs_dataextractor_remove_pipoint.url
}

output "sqs_dataextractor_general_pipoint_url" {
  value = aws_sqs_queue.sqs_dataextractor_general_pipoint.url
}

output "sqs_tag_state_raw_url" {
  value = aws_sqs_queue.sqs_tag_state_raw.url
}

output "sqs_monitor_job_url" {
  value = aws_sqs_queue.sqs_monitor_job.url
}

output "sqs_obsidian_data_workflow_raw_url" {
  value = aws_sqs_queue.sqs_obsidian_data_workflow_raw.url
}

output "sqs_obsidian_data_quality_raw_url" {
  value = aws_sqs_queue.sqs_obsidian_data_quality_raw.url
}

output "sqs_obsidian_component_surveillance_raw_url" {
  value = aws_sqs_queue.sqs_obsidian_component_surveillance_raw.url
}

output "sqs_obsidian_monitor_trigger_url" {
  value = aws_sqs_queue.sqs_obsidian_monitor_trigger.url
}

output "sqs_dataextractor_duplicated_pipoint_group_url" {
  value = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.url
}

output "sqs_data_collection_frequency_raw_url" {
  value = aws_sqs_queue.sqs_data_collection_frequency_raw.url
}

output "sqs_tag_config_consistency_raw_url" {
  value = aws_sqs_queue.sqs_tag_config_consistency_raw.url
}

output "sqs_dataextractor_duplicated_pipoint_url" {
  value = aws_sqs_queue.sqs_dataextractor_duplicated_pipoint.url
}

output "sqs_data_workflow_raw_url" {
  value = aws_sqs_queue.sqs_obsidian_data_workflow_raw.url
}

output "sqs_data_quality_raw_url" {
  value = aws_sqs_queue.sqs_obsidian_data_quality_raw.url
}
