resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "${var.lambda_function_name}"
  retention_in_days = "${var.lambda_logs_retention_in_days}"

  tags {
    environment = "${var.envname}"
    service     = "${var.service}"
  }
}

## create lambda package
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/include/lambda.py"
  output_path = "${path.module}/include/lambda.zip"
}

## create lambda function
resource "aws_lambda_function" "volume_backup" {
  depends_on       = ["aws_cloudwatch_log_group.lambda_log_group"]
  filename         = "${path.module}/include/lambda.zip"
  source_code_hash = "${data.archive_file.lambda_package.output_base64sha256}"
  function_name    = "${var.lambda_function_name}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "lambda.lambda_handler"
  runtime          = "python2.7"
  timeout          = "60"
  publish          = true
}
