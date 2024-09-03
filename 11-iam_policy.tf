resource "aws_iam_policy" "ecs_cluster_policy" {
  name        = "ecs-cluster-policy-${var.environment}"
  description = "IAM policy for ECS cluster"

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecs:CreateCluster",
                    "ecs:DeleteCluster",
                    "ecs:DescribeClusters",
                    "ecs:ListClusters"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
}

resource "aws_iam_policy" "ecs_service_policy" {
  name        = "ecs-service-policy-${var.environment}"
  description = "IAM policy for ECS service"

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecs:CreateService",
                    "ecs:DeleteService",
                    "ecs:DescribeServices",
                    "ecs:ListServices"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "ecs-task-policy-${var.environment}"
  description = "IAM policy for ECS task"

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecs:RegisterTaskDefinition",
                    "ecs:DeregisterTaskDefinition",
                    "ecs:DescribeTaskDefinition",
                    "ecs:ListTaskDefinitions"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
}

resource "aws_iam_policy" "s3_bucket_policy" {
  name        = "s3-bucket-policy-${var.environment}"
  description = "IAM policy for S3 bucket"

  policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "s3:CreateBucket",
                        "s3:DeleteBucket",
                        "s3:ListBucket",
                        "s3:GetBucketLocation"
                    ],
                    "Resource" : "arn:aws:s3:::${aws_s3_bucket.frontend.bucket}/*"
                }
            ]
        }
        EOF
}

resource "aws_iam_policy" "this" {
  name        = "s3_bucket_lb_logs-${var.environment}"
  description = "IAM policy for S3 bucket"

  policy = <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "s3:PutObject",
                        "s3:GetObject"
                    ],
                    "Resource" : "arn:aws:s3:::${aws_s3_bucket.load-balancer-logs-bucket.bucket}/*"
                }
            ]
        }
        EOF
}
