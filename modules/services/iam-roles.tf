#IAM Resource block for Lambda IAM role.
resource "aws_iam_role" "iam_lambda" {
  name = "lambda_iam_role_${var.environment}"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = local.tags
}

#Attachment of a Managed AWS IAM Policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a Managed AWS IAM Policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_vpc_access_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a Managed AWS IAM Policy for Lambda sqs execution
resource "aws_iam_role_policy_attachment" "lambda_basic_sqs_queue_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_monitor_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
  role       = aws_iam_role.iam_lambda.name
}

#Attachment of a custom IAM policy for API Gateway
resource "aws_iam_role_policy_attachment" "api" {
  role       = aws_iam_role.api.name
  policy_arn = aws_iam_policy.api.arn
}

resource "aws_iam_role" "api" {
  name = "api_gateway_role_${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = local.tags
}

data "aws_iam_policy_document" "api" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      aws_sqs_queue.sqs_dataextractor_add_pipoint.arn,
      aws_sqs_queue.sqs_dataextractor_update_pipoint.arn,
      aws_sqs_queue.sqs_dataextractor_remove_pipoint.arn,
      aws_sqs_queue.sqs_dataextractor_general_pipoint.arn,
      aws_sqs_queue.sqs_obsidian_data_workflow_raw.arn,
      aws_sqs_queue.sqs_tag_state_raw.arn,
      aws_sqs_queue.sqs_tag_config_consistency_raw.arn,
      aws_sqs_queue.sqs_data_collection_frequency_raw.arn,
      aws_sqs_queue.sqs_dataextractor_duplicated_pipoint.arn,
      aws_sqs_queue.sqs_obsidian_component_surveillance_raw.arn,
      aws_sqs_queue.sqs_obsidian_monitor_trigger.arn,
      aws_sqs_queue.sqs_dataextractor_duplicated_pipoint_group.arn,
      aws_sqs_queue.sqs_monitor_job.arn,
      aws_sqs_queue.sqs_obsidian_data_quality_raw.arn,
    ]
  }
}
