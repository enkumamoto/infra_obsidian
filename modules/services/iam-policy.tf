resource "aws_iam_policy" "api" {
  name = "apigateway_sqs_policy_${var.environment}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:SendMessageBatch",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "sqs:CreateQueue",
          "sqs:ListQueueTags",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:SetQueueAttributes"
        ],
        "Resource": [
          "${aws_sqs_queue.sqs_dataextractor_add_pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor_update_pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn}",
          "${aws_sqs_queue.sqs_dataextractor_general_pipoint.arn}",
          "${aws_sqs_queue.sqs_obsidian_data_workflow_raw.arn}",
          "${aws_sqs_queue.sqs_tag_state_raw.arn}",
          "${aws_sqs_queue.sqs_tag_config_consistency_raw.arn}",
          "${aws_sqs_queue.sqs_data_collection_frequency_raw.arn}",
          "${aws_sqs_queue.sqs_dataextractor_duplicated_pipoint.arn}",
          "${aws_sqs_queue.sqs_obsidian_component_surveillance_raw.arn}",
          "${aws_sqs_queue.sqs_obsidian_monitor_trigger.arn}",
          "${aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn}",
          "${aws_sqs_queue.sqs_monitor_job.arn}",
          "${aws_sqs_queue.sqs_obsidian_data_workflow_raw.arn}",
          "${aws_sqs_queue.sqs_obsidian_data_quality_raw.arn}"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource": "${aws_kms_key.sqs_key.arn}"
      },
      {
        "Effect": "Allow",
        "Action": "sqs:ListQueues",
        "Resource": "*"
      }
    ]
}
EOF
  tags   = local.tags
}
