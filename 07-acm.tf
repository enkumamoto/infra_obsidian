# resource "aws_acm_certificate" "obsidian_acm" {
#   domain_name       = "obsidianteste.com"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Environment = var.environment
#   }
# }

# resource "aws_acm_certificate_validation" "obsidian_acm_validation" {
#   certificate_arn = aws_acm_certificate.obsidian_acm.arn

#   lifecycle {
#     create_before_destroy = true
#   }

#   timeouts {
#     create = "30m" # Increase the timeout duration to 30 minutes
#   }
# }
