resource "aws_athena_workgroup" "test" {
  name = "obsidian-Athena-Workgroup-${var.environment}"

  configuration {
    result_configuration {
      encryption_configuration {
        encryption_option = "SSE_KMS"
        kms_key_arn       = aws_kms_key.athena_kms_key.arn
      }
    }
  }
  tags = {
    Environment = var.environment
  }
}

resource "aws_athena_database" "obsidian-athena-db" {
  name   = "obsidian"
  bucket = aws_s3_bucket.athena_bucket.id
}

resource "aws_athena_named_query" "obsidian-athena-query" {
  name      = "raw_tags_partioned"
  workgroup = aws_athena_workgroup.test.id
  database  = aws_athena_database.obsidian-athena-db.name
  query     = "SELECT * FROM ${aws_athena_database.obsidian-athena-db.name} limit 10;"
}
