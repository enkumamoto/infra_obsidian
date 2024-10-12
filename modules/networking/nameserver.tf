# resource "aws_route53_zone" "zone" {
#   name = var.dns_zone_name
# }

# output "nameserver" {
#   value = aws_route53_zone.zone.name_servers
# }

# resource "aws_acm_certificate" "cert" {
#   domain_name = aws_route53_zone.zone.name
#   subject_alternative_names = [
#     "*.${aws_route53_zone.zone.name}",
#     "*.${var.environment}.${aws_route53_zone.zone.name}",
#     "*.ms.${var.environment}.${aws_route53_zone.zone.name}",
#     "static-content.${var.environment}.${aws_route53_zone.zone.name}"
#   ]
#   validation_method = "DNS"

#   tags = local.tags

#   # adicionado
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# output "aws_acm_certificate_arn" {
#   value = aws_acm_certificate.cert.arn
# }

# resource "aws_route53_record" "route53_acm_certification_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#       zone_id = aws_route53_zone.zone.zone_id
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = each.value.zone_id
# }

# resource "aws_acm_certificate_validation" "acm_certification_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.route53_acm_certification_validation : record.fqdn]
#   timeouts {
#     create = "40m"
#   }
# }
