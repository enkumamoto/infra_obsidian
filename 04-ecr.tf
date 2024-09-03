resource "aws_ecr_repository" "obsidian_ecr" {
  name                 = "obsidian-ecr-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Name        = "obsidian ECR"
  }
}
