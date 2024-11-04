# ### ECR for container images
# resource "aws_ecr_repository" "obsidian-ui" {
#   name                 = "obsidian/obsidian-ui"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "obsidian-ui_url" {
#   value = aws_ecr_repository.obsidian-ui.repository_url
# }

# resource "aws_ecr_repository" "obsidian-monitor" {
#   name                 = "obsidian/obsidian-monitor"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "obsidian-monitor_url" {
#   value = aws_ecr_repository.obsidian-monitor.repository_url
# }

# resource "aws_ecr_repository" "obsidian-api" {
#   name                 = "obsidian/obsidian-api"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "obsidian-api_url" {
#   value = aws_ecr_repository.obsidian-api.repository_url
# }

# resource "aws_ecr_repository" "datapolling" {
#   name                 = "obsidian/datapolling"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "datapolling" {
#   value = aws_ecr_repository.datapolling.repository_url
# }

# resource "aws_ecr_repository" "keycloak" {
#   name                 = "obsidian/keycloak"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "keycloak" {
#   value = aws_ecr_repository.keycloak.repository_url
# }

# ## ECR for Lambda functions
# resource "aws_ecr_repository" "dataquality-function" {
#   name                 = "obsidian/lambda/dataquality-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "dataquality-function" {
#   value = aws_ecr_repository.dataquality-function.repository_url
# }

# resource "aws_ecr_repository" "duplicatedtags-function" {
#   name                 = "obsidian/lambda/duplicatedtags-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "duplicatedtags-function" {
#   value = aws_ecr_repository.duplicatedtags-function.repository_url
# }

# resource "aws_ecr_repository" "loader-function" {
#   name                 = "obsidian/lambda/loader-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "loader-function" {
#   value = aws_ecr_repository.loader-function.repository_url
# }

# resource "aws_ecr_repository" "metadata-merger-function" {
#   name                 = "obsidian/lambda/metadata-merger-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "metadata-merger-function" {
#   value = aws_ecr_repository.metadata-merger-function.repository_url
# }

# resource "aws_ecr_repository" "monitor-function" {
#   name                 = "obsidian/lambda/monitor-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "monitor-function" {
#   value = aws_ecr_repository.monitor-function.repository_url
# }

# resource "aws_ecr_repository" "tagstate-function" {
#   name                 = "obsidian/lambda/tagstate-function"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = local.tags
# }

# output "tagstate-function" {
#   value = aws_ecr_repository.tagstate-function.repository_url
# }

# data "aws_ecr_authorization_token" "token" {}

# terraform {
#   required_providers {
#     docker = {
#       source  = "kreuzwerker/docker"
#       version = "3.0.2"
#     }
#   }
# }

# provider "docker" {
#   registry_auth {
#     address  = data.aws_ecr_authorization_token.token.proxy_endpoint
#     username = data.aws_ecr_authorization_token.token.user_name
#     password = data.aws_ecr_authorization_token.token.password
#   }
# }

# ## Lambda DataQuality function
# data "docker_registry_image" "dataquality-function" {
#   name = "hello-world"
# }

# resource "docker_image" "dataquality-function" {
#   name = data.docker_registry_image.dataquality-function.name
# }

# resource "docker_tag" "dataquality-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.dataquality-function.repository_url}:latest"
#   source_image = data.docker_registry_image.dataquality-function.name
# }

# resource "docker_registry_image" "dataquality-function_ecr" {
#   name = "${aws_ecr_repository.dataquality-function.repository_url}:latest"
# }

# ## Lambda DuplicatedTags function
# data "docker_registry_image" "duplicatedtags-function" {
#   name = "hello-world"
# }

# resource "docker_image" "duplicatedtags-function" {
#   name = data.docker_registry_image.duplicatedtags-function.name
# }

# resource "docker_tag" "duplicatedtags-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.duplicatedtags-function.repository_url}:latest"
#   source_image = data.docker_registry_image.duplicatedtags-function.name
# }

# resource "docker_registry_image" "duplicatedtags-function_ecr" {
#   name = "${aws_ecr_repository.duplicatedtags-function.repository_url}:latest"
# }

# # Lambda TagState function
# data "docker_registry_image" "tagstate-function" {
#   name = "hello-world"
# }

# resource "docker_image" "tagstate-function" {
#   name = data.docker_registry_image.tagstate-function.name
# }

# resource "docker_tag" "tagstate-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.tagstate-function.repository_url}:latest"
#   source_image = data.docker_registry_image.tagstate-function.name
# }

# resource "docker_registry_image" "tagstate-function_ecr" {
#   name = "${aws_ecr_repository.tagstate-function.repository_url}:latest"
# }

# ## Lambda Loader function
# data "docker_registry_image" "loader-function" {
#   name = "hello-world"
# }

# resource "docker_image" "loader-function" {
#   name = data.docker_registry_image.loader-function.name
# }

# resource "docker_tag" "loader-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.loader-function.repository_url}:latest"
#   source_image = data.docker_registry_image.loader-function.name
# }

# resource "docker_registry_image" "loader-function_ecr" {
#   name = "${aws_ecr_repository.loader-function.repository_url}:latest"
# }

# ## Lambda Metadata Merger function
# data "docker_registry_image" "metadata-merger-function" {
#   name = "hello-world"
# }

# resource "docker_image" "metadata-merger-function" {
#   name = data.docker_registry_image.metadata-merger-function.name
# }

# resource "docker_tag" "metadata-merger-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest"
#   source_image = data.docker_registry_image.metadata-merger-function.name
# }

# resource "docker_registry_image" "metadata-merger-function_ecr" {
#   name = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest"
# }

# ## Lambda Monitor function
# data "docker_registry_image" "monitor-function" {
#   name = "hello-world"
# }

# resource "docker_image" "monitor-function" {
#   name = data.docker_registry_image.monitor-function.name
# }

# resource "docker_tag" "monitor-function_ecr_tag" {
#   target_image = "${aws_ecr_repository.monitor-function.repository_url}:latest"
#   source_image = data.docker_registry_image.monitor-function.name
# }

# resource "docker_registry_image" "monitor-function_ecr" {
#   name = "${aws_ecr_repository.monitor-function.repository_url}:latest"
# }

# ## Container images
# ## obsidian UI
# data "docker_registry_image" "obsidian-ui" {
#   name = "hello-world"
# }

# resource "docker_image" "obsidian-ui" {
#   name = data.docker_registry_image.obsidian-ui.name
# }

# resource "docker_tag" "obsidian-ui_ecr_tag" {
#   target_image = "${aws_ecr_repository.obsidian-ui.repository_url}:latest"
#   source_image = data.docker_registry_image.obsidian-ui.name
# }

# output "image-obsidian-ui" {
#   value = "${aws_ecr_repository.obsidian-ui.repository_url}:latest"
# }

# resource "docker_registry_image" "obsidian-ui_ecr" {
#   name = "${aws_ecr_repository.obsidian-ui.repository_url}:latest"
# }

# ## obsidian API
# data "docker_registry_image" "obsidian-api" {
#   name = "hello-world"
# }

# resource "docker_image" "obsidian-api" {
#   name = data.docker_registry_image.obsidian-api.name
# }

# resource "docker_tag" "obsidian-api_ecr_tag" {
#   target_image = "${aws_ecr_repository.obsidian-api.repository_url}:latest"
#   source_image = data.docker_registry_image.obsidian-api.name
# }

# output "image-obsidian-api" {
#   value = "${aws_ecr_repository.obsidian-api.repository_url}:latest"
# }

# resource "docker_registry_image" "obsidian-api_ecr" {
#   name = "${aws_ecr_repository.obsidian-api.repository_url}:latest"
# }

# ## Data Polling
# data "docker_registry_image" "datapolling" {
#   name = "hello-world"
# }

# resource "docker_image" "datapolling" {
#   name = data.docker_registry_image.datapolling.name
# }

# resource "docker_tag" "datapolling_ecr_tag" {
#   target_image = "${aws_ecr_repository.datapolling.repository_url}:latest"
#   source_image = data.docker_registry_image.datapolling.name
# }

# output "image-datapolling" {
#   value = "${aws_ecr_repository.datapolling.repository_url}:latest"
# }

# resource "docker_registry_image" "datapolling_ecr" {
#   name = "${aws_ecr_repository.datapolling.repository_url}:latest"
# }

# ## Keycloak
# data "docker_registry_image" "keycloak" {
#   name = "hello-world"
# }

# resource "docker_image" "keycloak" {
#   name = data.docker_registry_image.keycloak.name
# }

# resource "docker_tag" "keycloak_ecr_tag" {
#   target_image = "${aws_ecr_repository.keycloak.repository_url}:latest"
#   source_image = data.docker_registry_image.keycloak.name
# }

# output "image-keycloak" {
#   value = "${aws_ecr_repository.keycloak.repository_url}:latest"
# }

# resource "docker_registry_image" "keycloak_ecr" {
#   name = "${aws_ecr_repository.keycloak.repository_url}:latest"
# }

# ## obsidian Monitor
# data "docker_registry_image" "obsidian-monitor" {
#   name = "hello-world"
# }

# resource "docker_image" "obsidian-monitor" {
#   name = data.docker_registry_image.obsidian-monitor.name
# }

# resource "docker_tag" "obsidian-monitor_ecr_tag" {
#   target_image = "${aws_ecr_repository.obsidian-monitor.repository_url}:latest"
#   source_image = data.docker_registry_image.obsidian-monitor.name
# }

# output "image-obsidian-monitor" {
#   value = "${aws_ecr_repository.obsidian-monitor.repository_url}:latest"
# }

# resource "docker_registry_image" "obsidian-monitor_ecr" {
#   name = "${aws_ecr_repository.obsidian-monitor.repository_url}:latest"
# }
