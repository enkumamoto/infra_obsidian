resource "aws_s3_bucket" "log-bucket" {
  bucket = "blackstone-lb-logs-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "athena_bucket" {
  bucket = "blackstone-athena-${var.environment}"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "blackstone-lambdas-${var.environment}"
  # acl    = "private"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_object" "zip_upload" {
  bucket = aws_s3_bucket.lambda_bucket.bucket
  key    = "meu_hello_world.zip"            # Nome do arquivo dentro do bucket
  source = "${path.module}/hello_world.zip" # Caminho relativo para o arquivo ZIP
  # acl    = "private"
}

resource "aws_s3_bucket_policy" "lb_logs_policy" {
  bucket = aws_s3_bucket.log-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLBLogging",
        Effect = "Allow",
        Principal = {
          Service = "logs.${var.region}.amazonaws.com"
        },
        Action = [
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.log-bucket.bucket}/*"
        ]
      }
    ]
  })
}
