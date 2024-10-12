locals {
  vpc_id                   = var.vpc_id
  microservices_dns_suffix = "ms.${var.environment}"
  secret_entries           = [for v in var.service_secrets : "\"${v}\""]
}

resource "aws_ecs_service" "ecs_service" {
  name            = "blackstone_ecs_service_${var.environment}"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 1

  network_configuration {
    subnets = var.vpc_config_private_app_subnet_ids
    security_groups = [
      aws_security_group.allow_service_access.id
    ]
  }

  depends_on = [
    aws_ecs_task_definition.ecs_task_definition,
    aws_security_group.allow_service_access
  ]

  tags = local.tags
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "blackstone_ecs_task_definition_${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "nginx:latest" # Exemplo de imagem para o frontend
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "blackstone-api-Service"
      image     = "${aws_ecr_repository.blackstone-api.repository_url}:latest" # Substituir com a imagem da sua API
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    },
    {
      name      = "blackstone-ui-Service"
      image     = "${aws_ecr_repository.blackstone-ui.repository_url}:latest" # Substituir com a imagem da sua API
      essential = true
      portMappings = [
        {
          containerPort = 7070
          hostPort      = 7070
        }
      ]
    },
    {
      name      = "datapolling-Service"
      image     = "${aws_ecr_repository.datapolling.repository_url}:latest" # Substituir com a imagem para Data Polling
      essential = true
    },
    {
      name      = "keycloak"
      image     = "${aws_ecr_repository.keycloak.repository_url}:latest" # Imagem oficial do Keycloak
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
        }
      ]
    }
  ])
}

# resource "aws_ecs_service" "ecs_service" {
#   name            = "my-ecs-service"
#   cluster         = aws_ecs_cluster.example.id
#   task_definition = aws_ecs_task_definition.my_task.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets         = data.aws_subnet.private_app_subnets     # Substituir pelos seus subnets
#     security_groups = aws_security_group.allow_service_access # Substituir pelo seu security group
#   }
# }

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "blackstone_ecs_task_execution_role_${var.environment}"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = local.tags
}

resource "aws_iam_role_policy" "password_policy_ssm" {
  count = length([for v in var.service_secrets : v]) > 0 ? 1 : 0
  name  = "password-policy-ssm-blackstone-${var.environment}"
  role  = aws_iam_role.ecs_task_execution_role.id

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": [
        ${join(",", local.secret_entries)}
      ]
    }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs_service_log_group" {
  name = "ecs/${var.environment}/blackstone-service-log-group"

  tags = local.tags
}

resource "aws_security_group" "allow_service_access" {
  name        = "allow_blackstone_service_access_${var.environment}_${substr(uuid(), 0, 3)}_sg"
  description = "Allow blackstone alb inbound traffic"
  vpc_id      = local.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }

  tags = merge(local.tags, { Name = "allow_blackstone_service_access_${var.environment}" })
}
