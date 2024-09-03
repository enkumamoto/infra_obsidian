output "aws_vpc" {
  value = {
    id = aws_vpc.obsidian-vpc.id
  }
}

output "private_subnet_ids" {
  value = aws_subnet.obsidian_private_subnet[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.obsidian_public_subnet[*].id
}

output "dynamodb_table" {
  value = {
    module_outputs_table  = aws_dynamodb_table.module_outputs_table.name
    monitor_outputs_table = aws_dynamodb_table.monitor_outputs_table.name
  }
}

output "s3_bucket" {
  value = {
    lb_logs_bucket  = aws_s3_bucket.load-balancer-logs-bucket.bucket
    frontend_bucket = aws_s3_bucket.frontend.bucket
  }
}

output "ecs_service" {
  value = {
    task_definition = aws_ecs_task_definition.nginx.arn
    service         = aws_ecs_service.nginx.name
  }
}

output "load_balancer" {
  value = {
    lb_name = aws_lb.obsidian_lb.name
  }
}

output "route53" {
  value = {
    zone_id = aws_route53_zone.obsidian_zone.zone_id
  }
}

output "security_group" {
  value = {
    iac_sg   = aws_security_group.obsidian_iac_sg.id
    nginx_sg = aws_security_group.sg-nginx.id
  }
}

output "target_group" {
  value = {
    target_group_name = aws_lb_target_group.obsidian_lb_target_group.name
  }
}

output "lb_listener" {
  value = {
    lb_listener = aws_lb_listener.obsidian_lb_listener.port
  }
}

output "eip" {
  value = {
    eip = aws_eip.lb.public_ip
  }
}

# output "acm_certificate" {
#   value = {
#     acm_certificate = aws_acm_certificate.obsidian_acm.domain_name
#   }
# }

# output "acm_certificate_validation" {
#   value = {
#     acm_certificate_validation = aws_acm_certificate_validation.obsidian_acm_validation.certificate_arn
#   }
# }

# output "route53_record" {
#   value = {
#     route53_record = aws_route53_record.obsidian_acm_validation.records
#   }
# }

