## create lambda package
data "archive_file" "create_lambda_package" {
  type        = "zip"
  source_dir  = "${path.module}/include/"
  output_path = "/tmp/${var.envname}-${var.service}-lambda/lambda-${var.lambda_version}.zip"
}

## upload lambda package to s3
resource "aws_s3_bucket_object" "upload_lambda_package" {
  depends_on = ["data.archive_file.create_lambda_package"]
  bucket     = "${aws_s3_bucket.bucket_for_lambda_package.id}"
  key        = "lambda-snapshot-${var.lambda_version}.zip"
  source     = "/tmp/${var.envname}-${var.service}-lambda/lambda-${var.lambda_version}.zip"
}

## create lambda function
resource "aws_lambda_function" "volume_backup" {
  depends_on        = ["aws_s3_bucket_object.upload_lambda_package"]
  s3_bucket         = "${aws_s3_bucket.bucket_for_lambda_package.id}"
  s3_key            = "lambda-snapshot-${var.lambda_version}.zip"
  s3_object_version = "null"
  function_name     = "${var.lambda_function_name}"
  role              = "${aws_iam_role.lambda_role.arn}"
  handler           = "lambda.lambda_handler"
  runtime           = "python2.7"
  timeout           = "60"
  publish           = true
}
