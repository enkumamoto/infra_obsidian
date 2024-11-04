# ##ALB
# resource "aws_lb" "frontend_alb" {
#   name            = "blackstone-alb-${var.environment}"
#   internal        = false # Public facing ALB
#   security_groups = [aws_security_group.allow_service_access.id]
#   subnets         = var.vpc_config_public_subnet_ids

#   load_balancer_type = "application"

#   tags = merge(local.tags, { Name = "blackstone-alb-${var.environment}" })
# }

# resource "aws_lb_target_group" "frontend_alb_target_group" {
#   name        = "blackstone-ui-alb-target-group"
#   target_type = "ip" # Use ip para tarefas ECS
#   port        = 3000 # Matches container port
#   protocol    = "HTTP"
#   vpc_id      = local.vpc_id

#   health_check {
#     port     = 3000
#     protocol = "HTTP"
#   }

#   tags = merge(local.tags, { Name = "blackstone-ui-alb-target-group-${var.environment}" })
# }

# resource "aws_lb_listener" "frontend_alb_listener" {
#   load_balancer_arn = aws_lb.frontend_alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_alb_target_group.arn
#   }
# }

# resource "aws_lb_listener_rule" "frontend_alb_listener_rule" {
#   listener_arn = aws_lb_listener.frontend_alb_listener.arn
#   priority     = 50000

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_alb_target_group.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/static/*"]
#     }
#   }

#   depends_on = [
#     aws_lb_listener.frontend_alb_listener
#   ]

#   tags = merge(local.tags, { Name = "blackstone-ui-alb-listener-rule-${var.environment}" })
# }

# # # NLB
# # resource "aws_lb" "blackstone-nlb" {
# #   name            = "blackstone-nlb-${var.environment}"
# #   internal        = false # Public facing ALB 
# #   security_groups = [aws_security_group.allow_service_access.id]
# #   subnets         = var.vpc_config_public_subnet_ids

# #   load_balancer_type = "network"

# #   tags = merge(local.tags, { Name = "blackstone-nlb-${var.environment}" })
# # }

# # # Target Group para o NLB
# # resource "aws_lb_target_group" "nlb_target_group" {
# #   name        = "blackstone-nlb-target-group"
# #   port        = 8080 # Altere a porta se o seu serviço usar uma porta diferente
# #   protocol    = "HTTP"
# #   vpc_id      = var.vpc_id
# #   target_type = "ip" # Use instance para tarefas ECS

# #   tags = merge(local.tags, { Name = "blackstone-nlb-target_group-${var.environment}" })
# # }

# # # Listener para o NLB
# # resource "aws_lb_listener" "nlb_listener" {
# #   load_balancer_arn = aws_lb.blackstone-nlb.arn
# #   port              = 8080
# #   protocol          = "TCP"

# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.nlb_target_group.arn
# #   }
# # }

# # resource "aws_lb_listener_rule" "frontend_alb_listener_rule" {
# #   listener_arn = aws_lb_listener.frontend_alb_listener.arn
# #   priority     = 50000

# #   action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.frontend_alb_target_group.arn
# #   }

# #   condition {
# #     path_pattern {
# #       values = ["/static/*"]
# #     }
# #   }

# #   depends_on = [
# #     aws_lb_listener.frontend_alb_listener
# #   ]

# #   tags = merge(local.tags, { Name = "blackstone-ui-alb-listener-rule-${var.environment}" })
# # }
