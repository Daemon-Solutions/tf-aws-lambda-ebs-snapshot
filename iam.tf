# Lambda role
resource "aws_iam_role" "lambda_role" {
  name = "${var.envname}-${var.service}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Lambda policy for logging
resource "aws_iam_role_policy" "lambda_logging_policy" {
  name = "${var.envname}-${var.service}-lambda-logging"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
EOF
}

# Lambda policy for managing snapshots
resource "aws_iam_role_policy" "lambda_snapshots_policy" {
  name = "${var.envname}-${var.service}-lambda-snapshots"
  role = "${aws_iam_role.lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshot*",
        "ec2:DescribeTags",
        "ec2:DescribeVolume*"
      ],
      "Resource": ["*"]
    }
  ]
}
EOF
}
