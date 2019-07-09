locals {
  module_relpath_11 = "${substr(path.module, length(path.cwd) + 1, -1)}"
  module_relpath_12 = "${path.module}"
  module_relpath    = "${path.cwd == substr(path.module, 0, length(path.cwd)) ? local.module_relpath_11 : local.module_relpath_12}"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "${var.lambda_function_name}"
  retention_in_days = "${var.lambda_logs_retention_in_days}"

  tags = {
    environment = "${var.envname}"
    service     = "${var.service}"
  }
}

## create lambda package
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${local.module_relpath}/include/lambda.py"
  output_path = "${local.module_relpath}/include/lambda.zip"
}

## create lambda function
resource "aws_lambda_function" "volume_backup" {
  depends_on       = ["aws_cloudwatch_log_group.lambda_log_group"]
  filename         = "${data.archive_file.lambda_package.output_path}"
  source_code_hash = "${data.archive_file.lambda_package.output_base64sha256}"
  function_name    = "${var.lambda_function_name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "python2.7"
  timeout          = "60"
  publish          = true
}
