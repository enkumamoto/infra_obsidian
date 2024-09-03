variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
}

variable "aws_profile" {
  description = "The AWS profile to use."
  type        = string
}

variable "environment" {
  description = "The environment to deploy resources."
  type        = string
}

## RDS
variable "db_user_name" {
  description = "The RDS database username."
  type        = string
}

variable "db_password" {
  description = "The RDS database password."
  type        = string
}

variable "db_name" {
  description = "The RDS database name."
  type        = string
}

variable "db_engine" {
  description = "The RDS database engine."
  type        = string
}

variable "db_engine_version" {
  description = "The RDS database engine version."
  type        = string
}

