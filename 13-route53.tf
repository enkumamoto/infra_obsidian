resource "aws_eip" "lb" {
  domain = "vpc"

  tags = {
    Name        = "obsidian-lb-${var.environment}"
    environment = var.environment
  }
}

resource "aws_route53_zone" "obsidian_zone" {
  name = "obsidianteste.com"

  tags = {
    Environment = var.environment
  }
}

resource "aws_acm_certificate" "obsidian_cert" {
  domain_name       = "obsidianteste.com"
  validation_method = "DNS"

  tags = {
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "obsidian_cname_record" {
  zone_id = aws_route53_zone.obsidian_zone.zone_id
  name    = "app.obsidianteste.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_eip.lb.public_ip]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_acm_certificate.obsidian_cert]
}

resource "aws_route53_record" "A_record" {
  zone_id = aws_route53_zone.obsidian_zone.zone_id
  name    = "www.obsidianteste.com"
  type    = "A"
  ttl     = "300"

  records = ["192.0.2.44"] # Substitua pelo seu endereço IP
}

resource "aws_route53_record" "txt" {
  zone_id = aws_route53_zone.obsidian_zone.zone_id
  name    = "obsidianteste.com"
  type    = "TXT"
  ttl     = "300"

  records = [aws_eip.lb.public_ip]
}
