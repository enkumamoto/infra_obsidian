### ECR for container images
resource "aws_ecr_repository" "blackstone-ui" {
  name                 = "blackstone/blackstone-ui"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "blackstone-ui_url" {
  value = aws_ecr_repository.blackstone-ui.repository_url
}

resource "aws_ecr_repository" "blackstone-api" {
  name                 = "blackstone/blackstone-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "blackstone-api_url" {
  value = aws_ecr_repository.blackstone-api.repository_url
}

resource "aws_ecr_repository" "datapolling" {
  name                 = "blackstone/datapolling"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "datapolling" {
  value = aws_ecr_repository.datapolling.repository_url
}

resource "aws_ecr_repository" "keycloak" {
  name                 = "blackstone/keycloak"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "keycloak" {
  value = aws_ecr_repository.keycloak.repository_url
}

## ECR for Lambda functions
resource "aws_ecr_repository" "dataquality-function" {
  name                 = "blackstone/lambda/dataquality-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "dataquality-function" {
  value = aws_ecr_repository.dataquality-function.repository_url
}

resource "aws_ecr_repository" "duplicatedtags-function" {
  name                 = "blackstone/lambda/duplicatedtags-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "duplicatedtags-function" {
  value = aws_ecr_repository.duplicatedtags-function.repository_url
}

resource "aws_ecr_repository" "loader-function" {
  name                 = "blackstone/lambda/loader-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "loader-function" {
  value = aws_ecr_repository.loader-function.repository_url
}

resource "aws_ecr_repository" "metadata-merger-function" {
  name                 = "blackstone/lambda/metadata-merger-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "metadata-merger-function" {
  value = aws_ecr_repository.metadata-merger-function.repository_url
}

resource "aws_ecr_repository" "monitor-function" {
  name                 = "blackstone/lambda/monitor-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "monitor-function" {
  value = aws_ecr_repository.monitor-function.repository_url
}

resource "aws_ecr_repository" "tagstate-function" {
  name                 = "blackstone/lambda/tagstate-function"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = local.tags
}

output "tagstate-function" {
  value = aws_ecr_repository.tagstate-function.repository_url
}

data "aws_ecr_authorization_token" "token" {}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  registry_auth {
    address  = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

## Lambda DataQuality function
data "docker_registry_image" "dataquality-function" {
  name = "hello-world"
}

resource "docker_image" "dataquality-function" {
  name = data.docker_registry_image.dataquality-function.name
}

resource "docker_tag" "dataquality-function_ecr_tag" {
  target_image = "${aws_ecr_repository.dataquality-function.repository_url}:latest"
  source_image = data.docker_registry_image.dataquality-function.name
}

resource "docker_registry_image" "dataquality-function_ecr" {
  name = "${aws_ecr_repository.dataquality-function.repository_url}:latest"
}

## Lambda DuplicatedTags function
data "docker_registry_image" "duplicatedtags-function" {
  name = "hello-world"
}

resource "docker_image" "duplicatedtags-function" {
  name = data.docker_registry_image.duplicatedtags-function.name
}

resource "docker_tag" "duplicatedtags-function_ecr_tag" {
  target_image = "${aws_ecr_repository.duplicatedtags-function.repository_url}:latest"
  source_image = data.docker_registry_image.duplicatedtags-function.name
}

resource "docker_registry_image" "duplicatedtags-function_ecr" {
  name = "${aws_ecr_repository.duplicatedtags-function.repository_url}:latest"
}

# Lambda TagState function
data "docker_registry_image" "tagstate-function" {
  name = "hello-world"
}

resource "docker_image" "tagstate-function" {
  name = data.docker_registry_image.tagstate-function.name
}

resource "docker_tag" "tagstate-function_ecr_tag" {
  target_image = "${aws_ecr_repository.tagstate-function.repository_url}:latest"
  source_image = data.docker_registry_image.tagstate-function.name
}

resource "docker_registry_image" "tagstate-function_ecr" {
  name = "${aws_ecr_repository.tagstate-function.repository_url}:latest"
}

## Lambda Loader function
data "docker_registry_image" "loader-function" {
  name = "hello-world"
}

resource "docker_image" "loader-function" {
  name = data.docker_registry_image.loader-function.name
}

resource "docker_tag" "loader-function_ecr_tag" {
  target_image = "${aws_ecr_repository.loader-function.repository_url}:latest"
  source_image = data.docker_registry_image.loader-function.name
}

resource "docker_registry_image" "loader-function_ecr" {
  name = "${aws_ecr_repository.loader-function.repository_url}:latest"
}

## Lambda Metadata Merger function
data "docker_registry_image" "metadata-merger-function" {
  name = "hello-world"
}

resource "docker_image" "metadata-merger-function" {
  name = data.docker_registry_image.metadata-merger-function.name
}

resource "docker_tag" "metadata-merger-function_ecr_tag" {
  target_image = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest"
  source_image = data.docker_registry_image.metadata-merger-function.name
}

resource "docker_registry_image" "metadata-merger-function_ecr" {
  name = "${aws_ecr_repository.metadata-merger-function.repository_url}:latest"
}

## Lambda Monitor function
data "docker_registry_image" "monitor-function" {
  name = "hello-world"
}

resource "docker_image" "monitor-function" {
  name = data.docker_registry_image.monitor-function.name
}

resource "docker_tag" "monitor-function_ecr_tag" {
  target_image = "${aws_ecr_repository.monitor-function.repository_url}:latest"
  source_image = data.docker_registry_image.monitor-function.name
}

resource "docker_registry_image" "monitor-function_ecr" {
  name = "${aws_ecr_repository.monitor-function.repository_url}:latest"
}

## Container images
## Blackstone UI
data "docker_registry_image" "blackstone-ui" {
  name = "hello-world"
}

resource "docker_image" "blackstone-ui" {
  name = data.docker_registry_image.blackstone-ui.name
}

resource "docker_tag" "blackstone-ui_ecr_tag" {
  target_image = "${aws_ecr_repository.blackstone-ui.repository_url}:latest"
  source_image = data.docker_registry_image.blackstone-ui.name
}

output "image-blackstone-ui" {
  value = "${aws_ecr_repository.blackstone-ui.repository_url}:latest"
}

resource "docker_registry_image" "blackstone-ui_ecr" {
  name = "${aws_ecr_repository.blackstone-ui.repository_url}:latest"
}

## Blackstone API
data "docker_registry_image" "blackstone-api" {
  name = "hello-world"
}

resource "docker_image" "blackstone-api" {
  name = data.docker_registry_image.blackstone-api.name
}

resource "docker_tag" "blackstone-api_ecr_tag" {
  target_image = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
  source_image = data.docker_registry_image.blackstone-api.name
}

output "image-blackstone-api" {
  value = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
}

resource "docker_registry_image" "blackstone-api_ecr" {
  name = "${aws_ecr_repository.blackstone-api.repository_url}:latest"
}

## Data Polling
data "docker_registry_image" "datapolling" {
  name = "hello-world"
}

resource "docker_image" "datapolling" {
  name = data.docker_registry_image.datapolling.name
}

resource "docker_tag" "datapolling_ecr_tag" {
  target_image = "${aws_ecr_repository.datapolling.repository_url}:latest"
  source_image = data.docker_registry_image.datapolling.name
}

output "image-datapolling" {
  value = "${aws_ecr_repository.datapolling.repository_url}:latest"
}

resource "docker_registry_image" "datapolling_ecr" {
  name = "${aws_ecr_repository.datapolling.repository_url}:latest"
}

## Keycloak
data "docker_registry_image" "keycloak" {
  name = "hello-world"
}

resource "docker_image" "keycloak" {
  name = data.docker_registry_image.keycloak.name
}

resource "docker_tag" "keycloak_ecr_tag" {
  target_image = "${aws_ecr_repository.keycloak.repository_url}:latest"
  source_image = data.docker_registry_image.keycloak.name
}

output "image-keycloak" {
  value = "${aws_ecr_repository.keycloak.repository_url}:latest"
}

resource "docker_registry_image" "keycloak_ecr" {
  name = "${aws_ecr_repository.keycloak.repository_url}:latest"
}
