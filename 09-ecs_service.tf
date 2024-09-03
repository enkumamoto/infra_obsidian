resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Criando um serviço ECS para executar a task
resource "aws_ecs_service" "nginx" {
  name            = "obsidian-nginx-service-${var.environment}"
  cluster         = aws_ecs_cluster.obsidian_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.obsidian_private_subnet[0].id]
    security_groups  = [aws_security_group.sg-nginx.id]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_cluster.obsidian_cluster]
}
