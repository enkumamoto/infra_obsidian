# resource "aws_lb" "obsidian_lb" {
#   name               = "obsidian-lb-tf-${var.environment}"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.obsidian_iac_sg.id]
#   subnets            = aws_subnet.obsidian_public_subnet[*].id

#   enable_deletion_protection = true

#   access_logs {
#     bucket  = aws_s3_bucket.load-balancer-logs-bucket.id
#     prefix  = "test-lb"
#     enabled = true
#   }

#   tags = {
#     Environment = var.environment
#   }
# }

resource "aws_lb_target_group" "obsidian_lb_target_group" {
  name     = "obsidian-lb-tg-${var.environment}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.obsidian-vpc.id

  health_check {
    path                = "/health"
    port                = 8080
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "obsidian_lb_listener" {
  load_balancer_arn = aws_lb.obsidian_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.obsidian_lb_target_group.arn
  }
}

###

resource "aws_lb" "obsidian_lb" {
  name               = "loadbalancer-${var.environment}"
  load_balancer_type = "application"

  subnets = aws_subnet.obsidian_public_subnet[*].id

  security_groups = [
    aws_security_group.allow_tls.id
  ]

  # Fix: Disabling logging is security-sensitive terraform:S6258
  access_logs {
    enabled = true
    bucket  = aws_s3_bucket.load-balancer-logs-bucket.bucket
  }

  enable_http2 = true

  tags = {
    Environment = var.environment
    name        = "loadbalancer-${var.environment}"
  }

  depends_on = [aws_security_group.allow_tls]
}

# resource "time_sleep" "wait_for_lb" {
#   depends_on = [aws_lb.loadbalancer]
#   create_duration = "120s"  
# }

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = aws_lb.obsidian_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Environment = var.environment
    name        = "loadbalancer-listener-${var.environment}"
  }
}

resource "aws_lb_listener" "loadbalancer_listener_secure" {
  load_balancer_arn = aws_lb.obsidian_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "application/json"
      status_code  = "404"
      message_body = "{\"message: \"Not Found\"\"}"
    }
  }
}
