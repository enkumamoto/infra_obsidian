variable "environment" {
  type    = string
  default = "sandbox"
  validation {
    condition     = var.environment == "production" || var.environment == "staging" || var.environment == "sandbox"
    error_message = "Environment must be either production, staging, or sandbox"
  }
}

variable "tags_to_append" {
  type    = map(string)
  default = {}
}


variable "vpc_config_public_subnet_ids" {
  type    = list(string)
  default = []
}