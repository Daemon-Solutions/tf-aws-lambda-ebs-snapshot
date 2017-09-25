/* Environment variables */
variable "envname" {
  description = "This value will be the first name prefix and value for the 'environment' tag on all resources created by this module"
  type = "string"
}

variable "service" {
  description = "This value will be the second name prefix and value for the 'service' tag on all resources created by this module"
  type = "string"
}

variable "aws_region" {
  description = "The AWS region in which to place resources created by this module"
  type = "string"
  default = "eu-west-1"
}

/* CloudWatch variables */
variable "cloudwatch_event_rule_name" {
  description = "The name of the CloudWatch rule to trigger the Lambda volume backup"
  type = "string"
}

/* Lambda variables */
variable "lambda_function_name" {
  description = "The name of the Lambda function to trigger the volume backup"
  type = "string"
}

variable "volume_id" {
  description = "The ID of the volume you wish to invoke a backup on"
  type = "string"
}

variable "lambda_version" {
  description = "Version for the Lambda function"
  type = "string"
}

variable "cron_schedule" {
  description = "The schedule for the volume backup to occur defined as a cron expression"
  type = "string"
  default = "cron(0 1 * * SUN *)"
}

variable "snapshots_to_keep" {
  description = "Count of how many snapshots to keep"
  type = "string"
  default = 4
}

variable "tag_name" {
  description = "Name of the tag to associate with the volume backups"
  type = "string"
  default = "lambda_managed-snapshot"
}

variable "tag_value" {
  description = "Value of the tag to associate with the volume backups"
  type = "string"
  default = "weekly"
}

variable "lambda_logs_retention_in_days" {
  description = "The count of how many days to keep Lambda logs for this task"
  type = "string"
  default = "30"
}
