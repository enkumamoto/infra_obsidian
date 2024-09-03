### S3 Bucket Logs ###
# resource "aws_s3_bucket" "lb_logs" {
#   bucket = "obsidian-lb-logs-tf-${var.environment}"

#   tags = {
#     Environment = var.environment
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "s3-log-bucket-ownership-controls" {
#   bucket = aws_s3_bucket.lb_logs.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "acl_lb_logs" {
#   depends_on = [aws_s3_bucket_ownership_controls.s3-log-bucket-ownership-controls]

#   bucket = aws_s3_bucket.lb_logs.id
#   acl    = aws_s3_bucket_public_access_block.log-bucket-public-access-block.block_public_acls ? "private" : "public-read"
# }

# resource "aws_s3_bucket_public_access_block" "log-bucket-public-access-block" {
#   bucket = aws_s3_bucket.lb_logs.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

resource "aws_s3_bucket" "load-balancer-logs-bucket" {
  bucket = "obsidian-load-balancer-logs-${var.environment}"
  tags = {
    Environment = var.environment
  }
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "load-balancer-logs-public-access-block" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "load-balancer-logs" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket     = aws_s3_bucket.load-balancer-logs-bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.load-balancer-logs]
}

data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs-${var.environment}"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.load-balancer-logs-bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}

### S3 Bucket Frontend ###
resource "aws_s3_bucket" "frontend" {
  bucket = "obsidian-frontend-${var.environment}"

  tags = {
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "s3-fontend-bucket-ownership-controls" {
  bucket = aws_s3_bucket.frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl_frontend" {
  depends_on = [aws_s3_bucket_ownership_controls.s3-fontend-bucket-ownership-controls]

  bucket = aws_s3_bucket.frontend.id
  acl    = "private"
}
