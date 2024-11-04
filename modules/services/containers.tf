# locals {
#   vpc_id                   = var.vpc_id
#   microservices_dns_suffix = "ms.${var.environment}"
#   secret_entries           = [for v in var.service_secrets : "\"${v}\""]
# }

# # resource "aws_ecs_service" "frontend-taskDefinition_ecs_service" {
# #   name            = "frontend-taskDefinition_${var.environment}"
# #   cluster         = var.ecs_cluster_id
# #   launch_type     = "FARGATE"
# #   task_definition = aws_ecs_task_definition.frontend-taskDefinition.arn
# #   desired_count   = 1

# #   network_configuration {
# #     subnets = var.vpc_config_private_app_subnet_ids
# #     security_groups = [
# #       aws_security_group.allow_service_access.id
# #     ]
# #   }

# #   depends_on = [
# #     aws_security_group.allow_service_access
# #   ]

# #   tags = local.tags
# # }

# # # separar todos os serviços em containers
# # resource "aws_ecs_task_definition" "frontend-taskDefinition" {
# #   family                   = "frontend-taskDefinition_${var.environment}"
# #   network_mode             = "awsvpc"
# #   requires_compatibilities = ["FARGATE"]
# #   cpu                      = "512"
# #   memory                   = "1024"
# #   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
# #   task_role_arn            = aws_iam_role.ecs_task_role.arn

# #   container_definitions = jsonencode([
# #     {
# #       name  = "frontend"
# #       image = "nginx:latest" # Exemplo de imagem para o frontend

# #       essential = true
# #       portMappings = [
# #         {
# #           containerPort    = 80
# #           hostPort         = 80
# #           target_group_arn = "aws_lb_target_group.frontend_alb_target_group.arn"
# #         }
# #       ]
# #     }
# #   ])
# # }

# ###
# resource "aws_ecs_service" "frontend-taskDefinition_ecs_service" {
#   name            = "frontend-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.frontend-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#     # Adicionar configuração de IP para que as tarefas ECS recebam um IP ao serem executadas.
#     assign_public_ip = false # se necessário acesso direto público ao container
#   }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   # Configuração de load balancer para Nginx responder nas portas configuradas
#   load_balancer {
#     target_group_arn = aws_lb_target_group.frontend_alb_target_group.arn
#     container_name   = "frontend"
#     container_port   = 80
#   }

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "frontend-taskDefinition" {
#   family                   = "frontend-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name  = "frontend"
#       image = "nginx:latest"

#       # Configuração essencial para manter o container ativo e pronto para atender requisições.
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp" # Definir o protocolo de comunicação.
#         }
#       ]

#       # Configuração opcional para monitoramento e customização do Nginx
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = "/ecs/frontend"
#           awslogs-region        = var.region
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
# }

# ###

# resource "aws_ecs_service" "apiService-taskDefinition_ecs_service" {
#   name            = "apiService-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.apiService-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#   }
#   # load_balancer {
#   #   target_group_arn = aws_lb_target_group.nlb_target_group.arn
#   #   container_name   = "apiservice"
#   #   container_port   = 8080
#   # }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "apiService-taskDefinition" {
#   family                   = "apiService-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "blackstone-api-Service"
#       image     = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # Substituir com a imagem da sua API
#       essential = true
#       portMappings = [
#         {
#           containerPort = 8080
#           hostPort      = 8080
#         }
#       ]
#       # Configuração opcional para monitoramento e customização do Nginx
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = "/ecs/frontend"
#           awslogs-region        = var.region
#           awslogs-stream-prefix = "ecs"
#         }
#       }
#     }
#   ])
# }

# resource "aws_ecs_service" "uiService-taskDefinition_ecs_service" {
#   name            = "uiService-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.uiService-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#   }

#   # Configuração de load balancer para Nginx responder nas portas configuradas
#   load_balancer {
#     target_group_arn = aws_lb_target_group.frontend_alb_target_group.arn
#     container_name   = "blackstone-ui-Service"
#     container_port   = 3000
#   }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "uiService-taskDefinition" {
#   family                   = "uiService-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "blackstone-ui-Service"
#       image     = "${aws_ecr_repository.blackstone-ui.repository_url}:latest" # Substituir com a imagem da sua API
#       essential = true
#       portMappings = [
#         {
#           containerPort = 3000
#           hostPort      = 3000
#         }
#       ]
#     }
#   ])
# }

# resource "aws_ecs_service" "monitorService-taskDefinition_ecs_service" {
#   name            = "monitorService-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.monitorService-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#   }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "monitorService-taskDefinition" {
#   family                   = "monitorService-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "blackstone-monitor-Service"
#       image     = "${aws_ecr_repository.blackstone-monitor.repository_url}:latest" # Substituir com a imagem da sua API
#       essential = true
#       portMappings = [
#         {
#           containerPort = 8080
#           hostPort      = 8080
#         }
#       ]
#     }
#   ])
# }

# resource "aws_ecs_service" "datapollingService-taskDefinition_ecs_service" {
#   name            = "datapollingService-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.datapollingService-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#   }
#   # load_balancer {
#   #   target_group_arn = aws_lb_target_group.nlb_target_group.arn
#   #   container_name   = "datapollingservice"
#   #   container_port   = 8080
#   # }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "datapollingService-taskDefinition" {
#   family                   = "datapollingService-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "datapolling-Service"
#       image     = "${aws_ecr_repository.datapolling.repository_url}:latest" # Substituir com a imagem para Data Polling
#       essential = true
#     }
#   ])
# }

# resource "aws_ecs_service" "keycloak-taskDefinition_ecs_service" {
#   name            = "keycloak-taskDefinition_${var.environment}"
#   cluster         = var.ecs_cluster_id
#   launch_type     = "FARGATE"
#   task_definition = aws_ecs_task_definition.keycloak-taskDefinition.arn
#   desired_count   = 1

#   network_configuration {
#     subnets = var.vpc_config_private_app_subnet_ids
#     security_groups = [
#       aws_security_group.allow_service_access.id
#     ]
#   }

#   depends_on = [
#     aws_security_group.allow_service_access
#   ]

#   tags = local.tags
# }

# resource "aws_ecs_task_definition" "keycloak-taskDefinition" {
#   family                   = "keycloak-taskDefinition_${var.environment}"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = "512"
#   memory                   = "1024"
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn

#   container_definitions = jsonencode([
#     {
#       name      = "keycloak"
#       image     = "${aws_ecr_repository.keycloak.repository_url}:latest" # Imagem oficial do Keycloak
#       essential = true
#       portMappings = [
#         {
#           containerPort = 9090
#           hostPort      = 9090
#         }
#       ]
#     }

#   ])
# }

# resource "aws_iam_role" "ecs_task_execution_role" {
#   name               = "blackstone_ecs_task_execution_role_${var.environment}"
#   assume_role_policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Action": "sts:AssumeRole",
#      "Principal": {
#        "Service": "ecs-tasks.amazonaws.com"
#      },
#      "Effect": "Allow",
#      "Sid": ""
#    }
#  ]
# }
# EOF

#   tags = local.tags
# }

# resource "aws_iam_role_policy" "password_policy_ssm" {
#   count = length([for v in var.service_secrets : v]) > 0 ? 1 : 0
#   name  = "password-policy-ssm-blackstone-${var.environment}"
#   role  = aws_iam_role.ecs_task_execution_role.id

#   policy = <<EOF
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#       "Effect": "Allow",
#       "Action": [
#         "ssm:GetParameters"
#       ],
#       "Resource": [
#         ${join(",", local.secret_entries)}
#       ]
#     }
#  ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }

# resource "aws_cloudwatch_log_group" "ecs_service_log_group" {
#   name = "ecs/${var.environment}/blackstone-service-log-group"

#   tags = local.tags
# }

# resource "aws_security_group" "allow_service_access" {
#   name        = "allow_blackstone_service_access_${var.environment}_${substr(uuid(), 0, 3)}_sg"
#   description = "Allow blackstone alb inbound traffic"
#   vpc_id      = local.vpc_id

#   lifecycle {
#     create_before_destroy = true
#     ignore_changes        = [name]
#   }

#   tags = merge(local.tags, { Name = "allow_blackstone_service_access_${var.environment}" })
# }

# resource "aws_iam_policy" "ecs_task_role_policy" {
#   name        = "ecs_task_role_policy"
#   path        = "/"
#   description = "ECS Task Role Policy"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "sqs:*",
#           "sns:*",
#           "dynamodb:*",
#           "logs:PutLogEvents",
#           "logs:CreateLogGroup",
#           "logs:CreateLogStream",
#           "logs:DescribeLogStreams",
#           "logs:DescribeLogGroups",
#           "xray:PutTraceSegments",
#           "xray:PutTelemetryRecords",
#           "xray:GetSamplingRules",
#           "xray:GetSamplingTargets",
#           "xray:GetSamplingStatisticSummaries"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#       {
#         "Action" : "iam:*",
#         "Resource" : "*",
#         "Effect" : "Deny"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "ecs_task_role" {
#   name = "ecs_task_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = aws_iam_policy.ecs_task_role_policy.arn
# }
