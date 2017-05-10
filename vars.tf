variable "envname" {}

variable "service" {}

variable "cloudwatch_event_rule_name" {}

variable "lambda_function_name" {}

variable "volume_id" {}

variable "lambda_version" {
  description = "Version for lambda function"
}

variable "cron_schedule" {
  default = "cron(0 1 * * SUN *)"
}

variable "snapshots_to_keep" {
  default = 4
}

variable "tag_name" {
  default = "lambda_managed-snapshot"
}

variable "tag_value" {
  default = "weekly"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "lambda_logs_retention_in_days" {
  default = "30"
}
